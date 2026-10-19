namespace FpsLatencyPanel.Core.Infrastructure;

using System.Runtime.InteropServices;
using FpsLatencyPanel.Core.Abstractions;

public sealed class FileSystemService : IFileSystemService
{
    private readonly ILogger _log;
    public FileSystemService(ILogger log) => _log = log;

    public long MeasureBytes(string path)
    {
        if (!Directory.Exists(path)) return 0;
        long total = 0;
        try
        {
            foreach (var f in Directory.EnumerateFiles(path, "*", SearchOption.AllDirectories))
            {
                try { total += new FileInfo(f).Length; } catch { }
            }
        }
        catch (Exception ex)
        {
            _log.Warn("FileSystemService", $"Falha ao medir {path}: {ex.Message}");
        }
        return total;
    }

    public CleanupTargetResult CleanDirectory(string label, string path, CancellationToken ct = default)
    {
        if (!Directory.Exists(path))
            return new CleanupTargetResult(label, path, 0, 0, 0, "Diretorio nao existe.");

        if (!SafePathGuard.IsSafeToDelete(path))
        {
            _log.Error("FileSystemService", $"Caminho bloqueado por SafePathGuard: {path}");
            return new CleanupTargetResult(label, path, 0, 0, 0, "Caminho bloqueado por seguranca.");
        }

        long before = MeasureBytes(path);
        int deleted = 0, skipped = 0;

        foreach (var f in SafeEnumerate(path, ct))
        {
            ct.ThrowIfCancellationRequested();
            try
            {
                File.SetAttributes(f, FileAttributes.Normal);
                File.Delete(f);
                deleted++;
            }
            catch (UnauthorizedAccessException) { skipped++; }
            catch (IOException)                  { skipped++; }
            catch (Exception ex)
            {
                skipped++;
                _log.Warn("FileSystemService", $"Falha ao apagar {f}: {ex.Message}");
            }
        }

        try
        {
            foreach (var d in Directory.EnumerateDirectories(path, "*", SearchOption.AllDirectories)
                                      .OrderByDescending(s => s.Length))
            {
                try
                {
                    if (!Directory.EnumerateFileSystemEntries(d).Any())
                        Directory.Delete(d, recursive: false);
                }
                catch { }
            }
        }
        catch { }

        long after = MeasureBytes(path);
        long freed = Math.Max(0, before - after);

        _log.Info("FileSystemService", $"Limpeza {label}: {freed} bytes liberados.",
            before.ToString(), after.ToString());

        return new CleanupTargetResult(label, path, freed, deleted, skipped, null);
    }

    public CleanupTargetResult EmptyRecycleBin(CancellationToken ct = default)
    {
        long before = MeasureRecycleBinBytes();
        int ret = SHEmptyRecycleBin(IntPtr.Zero, null, SHERB_NOCONFIRMATION | SHERB_NOPROGRESSUI | SHERB_NOSOUND);

        if (ret < 0)
        {
            _log.Error("FileSystemService", $"SHEmptyRecycleBin retornou 0x{ret:X8}.");
            return new CleanupTargetResult("Lixeira", "<shell>", 0, 0, 0, "Falha ao esvaziar Lixeira.");
        }

        long after = MeasureRecycleBinBytes();
        long freed = Math.Max(0, before - after);
        _log.Info("FileSystemService", $"Lixeira esvaziada: {freed} bytes liberados.");
        return new CleanupTargetResult("Lixeira", "<shell>", freed, 0, 0, null);
    }

    private long MeasureRecycleBinBytes()
    {
        try
        {
            var sh = (Shell32.IShellDispatch)new Shell32.Shell();
            var folder = sh.NameSpace(10);
            if (folder is null) return 0;
            long total = 0;
            foreach (Shell32.FolderItem item in folder.Items())
            {
                try
                {
                    var size = folder.GetDetailsOf(item, 3);
                    if (long.TryParse(size, out var s)) total += s;
                }
                catch { }
            }
            return total;
        }
        catch { return 0; }
    }

    private static IEnumerable<string> SafeEnumerate(string root, CancellationToken ct)
    {
        var stack = new Stack<string>();
        stack.Push(root);
        while (stack.Count > 0)
        {
            ct.ThrowIfCancellationRequested();
            var dir = stack.Pop();
            string[] files;
            string[] subdirs;
            try
            {
                files = Directory.GetFiles(dir);
                subdirs = Directory.GetDirectories(dir);
            }
            catch { continue; }

            foreach (var f in files) yield return f;
            foreach (var d in subdirs) stack.Push(d);
        }
    }

    private const uint SHERB_NOCONFIRMATION = 0x00000001;
    private const uint SHERB_NOPROGRESSUI   = 0x00000002;
    private const uint SHERB_NOSOUND        = 0x00000004;

    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    private static extern int SHEmptyRecycleBin(IntPtr hwnd, string? pszRootPath, uint dwFlags);
}