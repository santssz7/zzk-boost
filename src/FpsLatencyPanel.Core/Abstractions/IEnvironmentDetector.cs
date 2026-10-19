namespace FpsLatencyPanel.Core.Abstractions;

public enum DiskKind { Hdd, Ssd, Unknown }

public sealed record EnvironmentInfo(
    bool IsLaptop,
    bool HasBattery,
    DiskKind SystemDiskKind,
    string WindowsVersion,
    string WindowsBuild,
    string WindowsEdition,
    string GpuName,
    string SystemLanguage,
    bool IsSystemRestoreEnabled,
    string MachineName,
    int LogicalProcessors,
    ulong TotalRamBytes);

public interface IEnvironmentDetector
{
    Task<EnvironmentInfo> DetectAsync(CancellationToken ct = default);
}