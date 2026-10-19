namespace FpsLatencyPanel.Core.Engine;

using System.Management;
using FpsLatencyPanel.Core.Abstractions;
using Microsoft.Win32;

public sealed class EnvironmentDetector : IEnvironmentDetector
{
    private readonly ILogger _log;
    private readonly IRestorePointService _rp;

    public EnvironmentDetector(ILogger log, IRestorePointService rp)
    {
        _log = log;
        _rp = rp;
    }

    public async Task<EnvironmentInfo> DetectAsync(CancellationToken ct = default)
    {
        return await Task.Run(() =>
        {
            bool hasBattery = HasBattery();
            bool isLaptop   = hasBattery || IsLaptopByChassis();
            var (ver, build, edition) = WindowsVersionInfo();
            var gpu = GpuName();
            var lang = System.Globalization.CultureInfo.CurrentUICulture.Name;
            var disk = SystemDiskKind();
            var restore = false;
            try { restore = _rp.IsSystemRestoreEnabledAsync(ct).GetAwaiter().GetResult(); }
            catch (Exception ex) { _log.Warn("EnvironmentDetector", "Falha ao checar restore point.", ex.Message); }

            var info = new EnvironmentInfo(
                IsLaptop: isLaptop,
                HasBattery: hasBattery,
                SystemDiskKind: disk,
                WindowsVersion: ver,
                WindowsBuild: build,
                WindowsEdition: edition,
                GpuName: gpu,
                SystemLanguage: lang,
                IsSystemRestoreEnabled: restore,
                MachineName: Environment.MachineName,
                LogicalProcessors: Environment.ProcessorCount,
                TotalRamBytes: TotalRamBytes());

            _log.Info("EnvironmentDetector", "Ambiente detectado", after: info.ToString());
            return info;
        }, ct);
    }

    private static bool HasBattery()
    {
        try
        {
            using var searcher = new ManagementObjectSearcher("SELECT Name FROM Win32_Battery");
            return searcher.Get().Count > 0;
        }
        catch { return false; }
    }

    private static bool IsLaptopByChassis()
    {
        try
        {
            using var searcher = new ManagementObjectSearcher("SELECT ChassisTypes FROM Win32_SystemEnclosure");
            foreach (ManagementObject mo in searcher.Get())
            {
                if (mo["ChassisTypes"] is ushort[] types)
                    foreach (var t in types)
                        if (t is 8 or 9 or 10 or 11 or 12 or 14 or 18 or 21 or 30 or 31 or 32)
                            return true;
            }
        }
        catch { }
        return false;
    }

    private static (string version, string build, string edition) WindowsVersionInfo()
    {
        try
        {
            using var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion");
            var product = key?.GetValue("ProductName")?.ToString() ?? "Windows";
            var build   = key?.GetValue("CurrentBuildNumber")?.ToString() ?? "0";
            var edition = key?.GetValue("EditionID")?.ToString() ?? "";

            var isWin11 = int.TryParse(build, out var b) && b >= 22000;
            var version = isWin11 ? "11" : (product.Contains("Windows 10") ? "10" : "10");
            return (version, build, edition);
        }
        catch { return ("10", "0", ""); }
    }

    private static string GpuName()
    {
        try
        {
            using var searcher = new ManagementObjectSearcher(
                "SELECT Name FROM Win32_VideoController");
            foreach (ManagementObject mo in searcher.Get())
            {
                var n = mo["Name"]?.ToString();
                if (!string.IsNullOrWhiteSpace(n) && !n.Contains("Basic Display", StringComparison.OrdinalIgnoreCase))
                    return n;
            }
        }
        catch { }
        return "Desconhecida";
    }

    private static DiskKind SystemDiskKind()
    {
        try
        {
            var scope = new ManagementScope(@"\\.\root\Microsoft\Windows\Storage");
            var q = new ObjectQuery("SELECT MediaType FROM MSFT_PhysicalDisk WHERE DeviceId='0'");
            using var s = new ManagementObjectSearcher(scope, q);
            foreach (ManagementObject mo in s.Get())
            {
                var mt = Convert.ToInt32(mo["MediaType"] ?? 0);
                if (mt == 4) return DiskKind.Ssd;
                if (mt == 3) return DiskKind.Hdd;
            }
        }
        catch { }
        return DiskKind.Unknown;
    }

    private static ulong TotalRamBytes()
    {
        try
        {
            using var searcher = new ManagementObjectSearcher(
                "SELECT TotalPhysicalMemory FROM Win32_ComputerSystem");
            foreach (ManagementObject mo in searcher.Get())
                return Convert.ToUInt64(mo["TotalPhysicalMemory"] ?? 0UL);
        }
        catch { }
        return 0;
    }
}