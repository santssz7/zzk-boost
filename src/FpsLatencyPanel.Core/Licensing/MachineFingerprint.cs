namespace FpsLatencyPanel.Core.Licensing;

using System.Management;
using System.Security.Cryptography;
using System.Text;

public static class MachineFingerprint
{
    public static string GetMachineId()
    {
        var parts = new List<string>
        {
            GetCpuId(),
            GetMotherboardSerial(),
            GetSystemVolumeSerial()
        };

        var raw = string.Join("|", parts.Where(p => !string.IsNullOrWhiteSpace(p)));
        if (string.IsNullOrWhiteSpace(raw)) raw = Environment.MachineName;

        var hash = SHA256.HashData(Encoding.UTF8.GetBytes(raw));
        return Convert.ToHexString(hash).Substring(0, 16).ToLowerInvariant();
    }

    private static string GetCpuId()
    {
        try
        {
            using var s = new ManagementObjectSearcher("SELECT ProcessorId FROM Win32_Processor");
            foreach (ManagementObject mo in s.Get())
                return mo["ProcessorId"]?.ToString() ?? "";
        }
        catch { }
        return "";
    }

    private static string GetMotherboardSerial()
    {
        try
        {
            using var s = new ManagementObjectSearcher("SELECT SerialNumber FROM Win32_BaseBoard");
            foreach (ManagementObject mo in s.Get())
                return mo["SerialNumber"]?.ToString()?.Trim() ?? "";
        }
        catch { }
        return "";
    }

    private static string GetSystemVolumeSerial()
    {
        try
        {
            var sysDrive = Path.GetPathRoot(Environment.SystemDirectory) ?? "C:\\";
            using var s = new ManagementObjectSearcher(
                $"SELECT VolumeSerialNumber FROM Win32_LogicalDisk WHERE DeviceID='{sysDrive.TrimEnd('\\')}'");
            foreach (ManagementObject mo in s.Get())
                return mo["VolumeSerialNumber"]?.ToString() ?? "";
        }
        catch { }
        return "";
    }
}