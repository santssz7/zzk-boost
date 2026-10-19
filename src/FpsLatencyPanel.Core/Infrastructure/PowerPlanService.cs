namespace FpsLatencyPanel.Core.Infrastructure;

using System.Diagnostics;
using FpsLatencyPanel.Core.Abstractions;

public sealed class PowerPlanService : IPowerPlanService
{
    private readonly ILogger _log;
    public const string CustomPlanName = "ZZK BOOST - Performance";

    public PowerPlanService(ILogger log) => _log = log;

    public async Task<Guid?> GetActivePlanGuidAsync(CancellationToken ct = default)
    {
        return await Task.Run(() =>
        {
            try
            {
                var scope = new System.Management.ManagementScope(@"\\.\root\cimv2\power");
                var query = new System.Management.ObjectQuery(
                    "SELECT InstanceID, IsActive FROM Win32_PowerPlan");
                using var searcher = new System.Management.ManagementObjectSearcher(scope, query);
                foreach (System.Management.ManagementObject mo in searcher.Get())
                {
                    if (!(bool)(mo["IsActive"] ?? false)) continue;
                    var id = mo["InstanceID"]?.ToString() ?? "";
                    var guidStr = id.Replace("Microsoft:PowerPlan\\", "", StringComparison.OrdinalIgnoreCase).Trim('{', '}');
                    return Guid.TryParse(guidStr, out var g) ? g : (Guid?)null;
                }
                return null;
            }
            catch (Exception ex)
            {
                _log.Error("PowerPlanService", "Falha ao ler plano ativo via WMI.", ex);
                return null;
            }
        }, ct);
    }

    public async Task<bool> EnsureCustomPlanAsync(CancellationToken ct = default)
    {
        var existing = await FindPlanGuidByNameAsync(CustomPlanName, ct);
        if (existing is not null)
        {
            _log.Info("PowerPlanService", $"Plano customizado ja existe: {existing}");
            return true;
        }

        var dup = await RunPowerCfgAsync($"-duplicatescheme {WellKnownPlans.HighPerformance}", ct);
        var newGuid = ParseGuidFromOutput(dup.stdout);
        if (newGuid is null)
        {
            _log.Error("PowerPlanService", "Nao foi possivel duplicar o plano de energia: " + dup.stderr);
            return false;
        }

        await RunPowerCfgAsync($"-changename {newGuid} \"{CustomPlanName}\"", ct);
        _log.Info("PowerPlanService", $"Plano customizado criado: {newGuid}");
        return true;
    }

    public async Task<Guid?> FindPlanGuidByNameAsync(string name, CancellationToken ct = default)
    {
        var r = await RunPowerCfgAsync("-list", ct);
        if (r.exit != 0) return null;
        foreach (var line in r.stdout.Split('\n'))
        {
            if (!line.Contains(name, StringComparison.OrdinalIgnoreCase)) continue;
            var idx = line.IndexOf('{');
            var end = line.IndexOf('}', idx);
            if (idx >= 0 && end > idx)
            {
                var g = line.Substring(idx + 1, end - idx - 1);
                if (Guid.TryParse(g, out var guid)) return guid;
            }
        }
        return null;
    }

    public async Task<bool> ActivateAsync(Guid guid, CancellationToken ct = default)
    {
        var r = await RunPowerCfgAsync($"-setactive {guid}", ct);
        if (r.exit == 0)
        {
            _log.Info("PowerPlanService", $"Plano ativado: {guid}");
            return true;
        }
        _log.Error("PowerPlanService", $"Falha ao ativar plano {guid}: {r.stderr}");
        return false;
    }

    public async Task<bool> SetSettingEnabledAsync(
        Guid planGuid, Guid subGroupGuid, Guid settingGuid,
        bool onAc, bool onDc, CancellationToken ct = default)
    {
        var acResult = await SetOneAsync(planGuid, subGroupGuid, settingGuid, onAc, dc: false, ct);
        var dcResult = await SetOneAsync(planGuid, subGroupGuid, settingGuid, onDc, dc: true, ct);
        return acResult && dcResult;
    }

    public async Task<PowerSettingValue> GetSettingAsync(
        Guid planGuid, Guid subGroupGuid, Guid settingGuid,
        bool onAc, CancellationToken ct = default)
    {
        var args = $"-query {planGuid} {subGroupGuid} {settingGuid}";
        var r = await RunPowerCfgAsync(args, ct);
        if (r.exit != 0) return PowerSettingValue.Unknown;

        var lines = r.stdout.Split('\n');
        bool wantAc = onAc;
        foreach (var raw in lines)
        {
            var line = raw.Trim();
            if (line.StartsWith("AC", StringComparison.OrdinalIgnoreCase) ||
                line.Contains("CA", StringComparison.OrdinalIgnoreCase))
            {
                if (!wantAc) continue;
                return ParseHexValue(line);
            }
            if (line.StartsWith("DC", StringComparison.OrdinalIgnoreCase) ||
                line.Contains("CC", StringComparison.OrdinalIgnoreCase))
            {
                if (wantAc) continue;
                return ParseHexValue(line);
            }
        }
        return PowerSettingValue.Unknown;
    }

    private static PowerSettingValue ParseHexValue(string line)
    {
        var idx = line.IndexOf("0x", StringComparison.OrdinalIgnoreCase);
        if (idx < 0) return PowerSettingValue.Unknown;
        var hex = line.Substring(idx + 2).Trim().TrimEnd('.', ',', '\r');
        if (hex.Length > 8) hex = hex.Substring(0, 8);
        if (!int.TryParse(hex, System.Globalization.NumberStyles.HexNumber,
                System.Globalization.CultureInfo.InvariantCulture, out var v))
            return PowerSettingValue.Unknown;
        return v == 0 ? PowerSettingValue.On : PowerSettingValue.Off;
    }

    private async Task<bool> SetOneAsync(
        Guid planGuid, Guid subGroup, Guid setting, bool enabled, bool dc, CancellationToken ct)
    {
        var args = dc
            ? $"-setdcvalueindex {planGuid} {subGroup} {setting} {(enabled ? 0 : 1)}"
            : $"-setacvalueindex {planGuid} {subGroup} {setting} {(enabled ? 0 : 1)}";

        var r = await RunPowerCfgAsync(args, ct);
        if (r.exit != 0)
        {
            _log.Error("PowerPlanService", $"powercfg falhou: {args} | {r.stderr}");
            return false;
        }
        return true;
    }

    private static async Task<(int exit, string stdout, string stderr)> RunPowerCfgAsync(
        string args, CancellationToken ct)
    {
        var psi = new ProcessStartInfo("powercfg.exe", args)
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

    private static string? ParseGuidFromOutput(string stdout)
    {
        foreach (var line in stdout.Split('\n'))
        {
            var idx = line.IndexOf('{');
            var end = line.IndexOf('}', idx);
            if (idx >= 0 && end > idx)
            {
                var g = line.Substring(idx + 1, end - idx - 1);
                if (Guid.TryParse(g, out var guid)) return guid.ToString();
            }
        }
        return null;
    }
}

public static class WellKnownPlans
{
    public const string HighPerformance = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c";
}