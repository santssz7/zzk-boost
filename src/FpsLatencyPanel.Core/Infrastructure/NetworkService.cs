namespace FpsLatencyPanel.Core.Infrastructure;

using System.Diagnostics;
using System.Management;
using System.Net.NetworkInformation;
using FpsLatencyPanel.Core.Abstractions;

public sealed class NetworkService : INetworkService
{
    private readonly ILogger _log;
    public NetworkService(ILogger log) => _log = log;

    public Task<IReadOnlyList<NetworkAdapterInfo>> GetActiveAdaptersAsync(CancellationToken ct = default)
    {
        return Task.Run<IReadOnlyList<NetworkAdapterInfo>>(() =>
        {
            var list = new List<NetworkAdapterInfo>();
            try
            {
                foreach (var nic in NetworkInterface.GetAllNetworkInterfaces())
                {
                    if (nic.NetworkInterfaceType == NetworkInterfaceType.Loopback) continue;
                    if (nic.NetworkInterfaceType == NetworkInterfaceType.Tunnel) continue;
                    if (nic.OperationalStatus != OperationalStatus.Up) continue;
                    if (!nic.Supports(NetworkInterfaceComponent.IPv4)) continue;

                    var desc = nic.Description ?? "";
                    bool physical = !(desc.Contains("Virtual", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("Hyper-V", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("VMware", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("TAP-", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("WireGuard", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("OpenVPN", StringComparison.OrdinalIgnoreCase));

                    list.Add(new NetworkAdapterInfo(nic.Id, nic.Name, desc, true, physical));
                }
            }
            catch (Exception ex)
            {
                _log.Error("NetworkService", "Falha ao enumerar adaptadores.", ex);
            }
            return list;
        }, ct);
    }

    public async Task<AutotuningLevel> GetAutotuningAsync(CancellationToken ct = default)
    {
        var r = await RunAsync("netsh", "int tcp show global", ct);
        if (r.exit != 0) return AutotuningLevel.Unknown;

        foreach (var raw in r.stdout.Split('\n'))
        {
            var line = raw.Trim();
            var lower = line.ToLowerInvariant();
            if (!lower.Contains("autotuning")) continue;

            if (lower.Contains("normal"))            return AutotuningLevel.Normal;
            if (lower.Contains("disabled"))          return AutotuningLevel.Disabled;
            if (lower.Contains("highlyrestricted"))  return AutotuningLevel.HighlyRestricted;
            if (lower.Contains("restricted"))        return AutotuningLevel.Restricted;
            if (lower.Contains("experimental"))      return AutotuningLevel.Experimental;
        }
        return AutotuningLevel.Unknown;
    }

    public async Task<bool> SetAutotuningAsync(AutotuningLevel level, CancellationToken ct = default)
    {
        var name = level switch
        {
            AutotuningLevel.Disabled         => "disabled",
            AutotuningLevel.HighlyRestricted => "highlyrestricted",
            AutotuningLevel.Restricted       => "restricted",
            AutotuningLevel.Normal           => "normal",
            AutotuningLevel.Experimental     => "experimental",
            _ => throw new ArgumentOutOfRangeException(nameof(level))
        };
        var r = await RunAsync("netsh", $"int tcp set global autotuninglevel={name}", ct);
        if (r.exit != 0)
        {
            _log.Error("NetworkService", $"netsh autotuning falhou: {r.stderr}");
            return false;
        }
        return true;
    }

    public async Task<bool?> GetRssAsync(string adapterName, CancellationToken ct = default)
    {
        var r = await RunAsync("netsh", "int tcp show global", ct);
        if (r.exit == 0)
        {
            foreach (var raw in r.stdout.Split('\n'))
            {
                var line = raw.Trim().ToLowerInvariant();
                if (line.Contains("rss") || line.Contains("receive-side scaling") || line.Contains("escalonamento"))
                {
                    if (line.Contains("enabled")) return true;
                    if (line.Contains("disabled")) return false;
                }
            }
        }
        return null;
    }

    public async Task<bool> SetRssAsync(string adapterName, bool enabled, CancellationToken ct = default)
    {
        var arg = enabled ? "enabled" : "disabled";
        var r = await RunAsync("netsh", $"int tcp set global rss={arg}", ct);
        if (r.exit != 0)
        {
            _log.Error("NetworkService", $"netsh rss falhou: {r.stderr}");
            return false;
        }
        return true;
    }

    public Task<IReadOnlyList<string>> GetDnsServersAsync(string adapterName, CancellationToken ct = default)
    {
        return Task.Run<IReadOnlyList<string>>(() =>
        {
            try
            {
                var scope = new ManagementScope(@"\\.\root\cimv2");
                var q = new ObjectQuery(
                    $"SELECT DNSServerSearchOrder FROM Win32_NetworkAdapterConfiguration " +
                    $"WHERE Description = '{Escape(adapterName)}' AND IPEnabled = TRUE");
                using var s = new ManagementObjectSearcher(scope, q);
                foreach (ManagementObject mo in s.Get())
                {
                    if (mo["DNSServerSearchOrder"] is string[] arr) return arr;
                }
            }
            catch (Exception ex)
            {
                _log.Error("NetworkService", "Falha ao ler DNS via WMI.", ex);
            }
            return Array.Empty<string>();
        }, ct);
    }

    public Task<bool> SetDnsServersAsync(string adapterName, IReadOnlyList<string> servers, CancellationToken ct = default)
    {
        return Task.Run(() =>
        {
            try
            {
                var scope = new ManagementScope(@"\\.\root\cimv2");
                var q = new ObjectQuery(
                    $"SELECT * FROM Win32_NetworkAdapterConfiguration " +
                    $"WHERE Description = '{Escape(adapterName)}' AND IPEnabled = TRUE");
                using var s = new ManagementObjectSearcher(scope, q);
                foreach (ManagementObject mo in s.Get())
                {
                    var inParams = mo.GetMethodParameters("SetDNSServerSearchOrder");
                    inParams["DNSServerSearchOrder"] = servers.ToArray();
                    var outParams = mo.InvokeMethod("SetDNSServerSearchOrder", inParams, null);
                    var ret = Convert.ToInt32(outParams?["ReturnValue"] ?? -1);
                    if (ret == 0) return true;
                    _log.Error("NetworkService", $"SetDNSServerSearchOrder retornou {ret}.");
                }
            }
            catch (Exception ex)
            {
                _log.Error("NetworkService", "Falha ao aplicar DNS.", ex);
            }
            return false;
        }, ct);
    }

    public Task<bool> ResetDnsServersAsync(string adapterName, CancellationToken ct = default)
    {
        return Task.Run(() =>
        {
            try
            {
                var scope = new ManagementScope(@"\\.\root\cimv2");
                var q = new ObjectQuery(
                    $"SELECT * FROM Win32_NetworkAdapterConfiguration " +
                    $"WHERE Description = '{Escape(adapterName)}' AND IPEnabled = TRUE");
                using var s = new ManagementObjectSearcher(scope, q);
                foreach (ManagementObject mo in s.Get())
                {
                    var inParams = mo.GetMethodParameters("SetDNSServerSearchOrder");
                    inParams["DNSServerSearchOrder"] = null;
                    var outParams = mo.InvokeMethod("SetDNSServerSearchOrder", inParams, null);
                    var ret = Convert.ToInt32(outParams?["ReturnValue"] ?? -1);
                    if (ret == 0) return true;
                    _log.Error("NetworkService", $"Reset DNS retornou {ret}.");
                }
            }
            catch (Exception ex)
            {
                _log.Error("NetworkService", "Falha ao resetar DNS.", ex);
            }
            return false;
        }, ct);
    }

    private static string Escape(string s) => s.Replace("'", "''");

    private static async Task<(int exit, string stdout, string stderr)> RunAsync(
        string exe, string args, CancellationToken ct)
    {
        var psi = new ProcessStartInfo(exe, args)
        {
            RedirectStandardOutput = true,
            RedirectStandardError  = true,
            UseShellExecute        = false,
            CreateNoWindow         = true
        };
        using var p = Process.Start(psi)!;
        var stdout = await p.StandardOutput.ReadToEndAsync(ct);
        var stderr = await p.StandardError.ReadToEndAsync(ct);
        await p.WaitForExitAsync(ct);
        return (p.ExitCode, stdout, stderr);
    }
}