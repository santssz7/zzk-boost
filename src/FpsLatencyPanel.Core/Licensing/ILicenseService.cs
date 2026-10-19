namespace FpsLatencyPanel.Core.Licensing;

public enum LicenseStatus
{
    Valid,
    Missing,
    InvalidSignature,
    Expired,
    HardwareMismatch,
    Corrupted
}

public sealed record LicenseInfo(
    LicenseStatus Status,
    string? CustomerName,
    string? CustomerEmail,
    DateTimeOffset? ExpiresAtUtc,
    string? MachineId,
    string Message);

public interface ILicenseService
{
    string GetMachineId();
    LicenseInfo Activate(string key);
    LicenseInfo GetCurrentStatus();
    void Deactivate();
    string LicenseFilePath { get; }
}