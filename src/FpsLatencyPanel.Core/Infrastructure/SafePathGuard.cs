namespace FpsLatencyPanel.Core.Infrastructure;

public static class SafePathGuard
{
    private static readonly string[] BlockedExactRoots =
    {
        @"C:\Windows",
        @"C:\Windows\System32",
        @"C:\Windows\SysWOW64",
        @"C:\Program Files",
        @"C:\Program Files (x86)",
        @"C:\ProgramData",
        @"C:\Users",
        @"C:\Recovery",
        @"C:\$Recycle.Bin"
    };

    public static bool IsSafeToDelete(string path)
    {
        if (string.IsNullOrWhiteSpace(path)) return false;

        string full;
        try { full = Path.GetFullPath(path).TrimEnd('\\'); }
        catch { return false; }

        if (full.Length == 2 && full[1] == ':') return false;

        foreach (var blocked in BlockedExactRoots)
        {
            var b = Path.GetFullPath(blocked).TrimEnd('\\');
            if (string.Equals(full, b, StringComparison.OrdinalIgnoreCase)) return false;
        }
        return true;
    }

    public static bool IsSystemCriticalPath(string path)
    {
        var full = Path.GetFullPath(path).TrimEnd('\\');
        return BlockedExactRoots.Any(b =>
            string.Equals(full, Path.GetFullPath(b).TrimEnd('\\'), StringComparison.OrdinalIgnoreCase) ||
            full.StartsWith(Path.GetFullPath(b).TrimEnd('\\') + "\\", StringComparison.OrdinalIgnoreCase));
    }
}