namespace FpsLatencyPanel.Core.Abstractions;

using Microsoft.Win32;

public enum Hive { CurrentUser, LocalMachine }

public sealed record RegLocation(Hive Hive, string SubKey, string? ValueName, bool Is64BitView = true);

public interface IRegistryAccessor
{
    object? ReadValue(RegLocation loc);
    RegistryValueKind? GetValueKind(RegLocation loc);
    void WriteValue(RegLocation loc, object value, RegistryValueKind kind);
    void DeleteValue(RegLocation loc);
    bool KeyExists(RegLocation loc);
    string[] GetSubKeyNames(RegLocation loc);
    string[] GetValueNames(RegLocation loc);
}