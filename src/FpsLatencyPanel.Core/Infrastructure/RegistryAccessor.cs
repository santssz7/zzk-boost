namespace FpsLatencyPanel.Core.Infrastructure;

using FpsLatencyPanel.Core.Abstractions;
using Microsoft.Win32;

public sealed class RegistryAccessor : IRegistryAccessor
{
    private static RegistryHive ToHive(Hive h) => h == Hive.CurrentUser ? RegistryHive.CurrentUser : RegistryHive.LocalMachine;

    public object? ReadValue(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        if (key is null) return null;
        return loc.ValueName is null ? null : key.GetValue(loc.ValueName, null);
    }

    public RegistryValueKind? GetValueKind(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        if (key is null || loc.ValueName is null) return null;
        try { return key.GetValueKind(loc.ValueName); }
        catch { return null; }
    }

    public void WriteValue(RegLocation loc, object value, RegistryValueKind kind)
    {
        if (loc.ValueName is null)
            throw new ArgumentException("ValueName obrigatorio para escrita.", nameof(loc));

        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.CreateSubKey(loc.SubKey, writable: true)
            ?? throw new InvalidOperationException($"Falha ao abrir/criar chave {loc.SubKey}");
        key.SetValue(loc.ValueName, value, kind);
    }

    public void DeleteValue(RegLocation loc)
    {
        if (loc.ValueName is null) return;
        try
        {
            using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
                loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
            using var key = baseKey.OpenSubKey(loc.SubKey, writable: true);
            key?.DeleteValue(loc.ValueName, throwOnMissingValue: false);
        }
        catch (UnauthorizedAccessException) { }
    }

    public bool KeyExists(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        return key is not null;
    }

    public string[] GetSubKeyNames(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        return key?.GetSubKeyNames() ?? Array.Empty<string>();
    }

    public string[] GetValueNames(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        return key?.GetValueNames() ?? Array.Empty<string>();
    }
}