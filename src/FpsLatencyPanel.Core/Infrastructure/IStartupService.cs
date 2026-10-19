namespace FpsLatencyPanel.Core.Infrastructure;

public enum StartupSource
{
    HkcuRun,
    HklmRun,
    HkcuRunWow64,
    HklmRunWow64,
    StartupFolderUser,
    StartupFolderCommon,
    StartupApprovedHkcu,
    StartupApprovedHklm
}

public sealed record StartupItem(
    string Id,
    string Name,
    string Command,
    StartupSource Source,
    bool IsEnabled,
    string Location,
    string ValueName);

public interface IStartupService
{
    IReadOnlyList<StartupItem> Enumerate();
    bool Disable(StartupItem item, out string? error);
    bool Enable(StartupItem item, out string? error);
}