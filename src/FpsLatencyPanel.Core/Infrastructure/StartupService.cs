
namespace FpsLatencyPanel.Core.Infrastructure;

using System.Security.Cryptography;
using System.Text;
using FpsLatencyPanel.Core.Abstractions;
using Microsoft.Win32;

public sealed class StartupService : IStartupService
{
    private readonly ILogger _log;

    private static readonly byte[] EnabledBytes  = { 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    private static readonly byte[] DisabledBytes = { 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

    public StartupService(ILogger log) => _log = log;

    public IReadOnlyList<StartupItem> Enumerate()
    {
        var list = new List<StartupItem>();

        AddFromRunKey(list, RegistryHive.CurrentUser, RegistryView.Registry64, StartupSource.HkcuRun,
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run");

        AddFromRunKey(list, RegistryHive.LocalMachine, RegistryView.Registry64, StartupSource.HklmRun,
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run");

        AddFromRunKey(list, RegistryHive.CurrentUser, RegistryView.Registry32, StartupSource.HkcuRunWow64,
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32");

        AddFromRunKey(list, RegistryHive.LocalMachine, RegistryView.Registry32, StartupSource.HklmRunWow64,
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32");

        AddFromFolder(list, RegistryHive.CurrentUser, StartupSource.StartupFolderUser,
            Environment.GetFolderPath(Environment.SpecialFolder.Startup),
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder");

        AddFromFolder(list, RegistryHive.LocalMachine, StartupSource.StartupFolderCommon,
            Environment.GetFolderPath(Environment.SpecialFolder.CommonStartup),
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder");

        return list.OrderBy(i => i.Name, StringComparer.OrdinalIgnoreCase).ToList();
    }

    public bool Disable(StartupItem item, out string? error)
    {
        try
        {
            var (approvedPath, approvedValueName) = ApprovedFor(item);
            using var approvedKey = OpenKey(item.Source, approvedPath, writable: true);
            if (approvedKey is null) { error = "Nao foi possivel abrir chave StartupApproved."; return false; }
            approvedKey.SetValue(approvedValueName, DisabledBytes, RegistryValueKind.Binary);
            error = null;
            return true;
        }
        catch (Exception ex)
        {
            _log.Error("StartupService", $"Falha ao desativar {item.Name}.", ex);
            error = ex.Message;
            return false;
        }
    }

    public bool Enable(StartupItem item, out string? error)
    {
        try
        {
            var (approvedPath, approvedValueName) = ApprovedFor(item);
            using var approvedKey = OpenKey(item.Source, approvedPath, writable: true);
            if (approvedKey is null) { error = "Nao foi possivel abrir chave StartupApproved."; return false; }
            approvedKey.SetValue(approvedValueName, EnabledBytes, RegistryValueKind.Binary);
            error = null;
            return true;
        }
        catch (Exception ex)
        {
            _log.Error("StartupService", $"Falha ao reativar {item.Name}.", ex);
            error = ex.Message;
            return false;
        }
    }

    private void AddFromRunKey(
        List<StartupItem> list, RegistryHive hive, RegistryView view, StartupSource source,
        string runPath, string approvedPath)
    {
        try
        {
            using var baseKey = RegistryKey.OpenBaseKey(hive, view);
            using var run = baseKey.OpenSubKey(runPath, writable: false);
            if (run is null) return;

            using var approved = baseKey.OpenSubKey(approvedPath, writable: false);

            foreach (var valueName in run.GetValueNames())
            {
                var command = run.GetValue(valueName)?.ToString() ?? "";
                bool enabled = true;
                if (approved?.GetValue(valueName) is byte[] b && b.Length > 0 && b[0] == 0x03)
                    enabled = false;

                var id = MakeId(source, runPath, valueName);
                list.Add(new StartupItem(id, valueName, command, source, enabled,
                    $"{hive}\\{runPath}", valueName));
            }
        }
        catch (Exception ex)
        {
            _log.Warn("StartupService", $"Falha ao ler {hive}\\{runPath}: {ex.Message}");
        }
    }

    private void AddFromFolder(
        List<StartupItem> list, RegistryHive hive, StartupSource source,
        string folderPath, string approvedPath)
    {
        try
        {
            if (!Directory.Exists(folderPath)) return;

            var approvedRoot = hive == RegistryHive.CurrentUser
                ? Registry.CurrentUser
                : Registry.LocalMachine;

            using var approved = approvedRoot.OpenSubKey(approvedPath, writable: false);

            foreach (var file in Directory.EnumerateFiles(folderPath))
            {
                var name = Path.GetFileName(file);
                var ext = Path.GetExtension(file).ToLowerInvariant();
                if (ext != ".lnk" && ext != ".url" && ext != ".exe" && ext != ".bat" && ext != ".cmd")
                    continue;

                var attrs = File.GetAttributes(file);
                if (attrs.HasFlag(FileAttributes.Hidden)) continue;

                bool enabled = true;
                if (approved?.GetValue(name) is byte[] b && b.Length > 0 && b[0] == 0x03)
                    enabled = false;

                var id = MakeId(source, folderPath, name);
                list.Add(new StartupItem(id, name, file, source, enabled, folderPath, name));
            }
        }
        catch (Exception ex)
        {
            _log.Warn("StartupService", $"Falha ao ler pasta {folderPath}: {ex.Message}");
        }
    }

    private static (string approvedPath, string valueName) ApprovedFor(StartupItem item)
    {
        var approvedPath = item.Source switch
        {
            StartupSource.HkcuRun       => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
            StartupSource.HklmRun       => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
            StartupSource.HkcuRunWow64  => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32",
            StartupSource.HklmRunWow64  => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32",
            StartupSource.StartupFolderUser   => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder",
            StartupSource.StartupFolderCommon => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder",
            _ => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
        };
        return (approvedPath, item.ValueName);
    }

    private static RegistryKey? OpenKey(StartupSource source, string path, bool writable)
    {
        var hive = source switch
        {
            StartupSource.HkcuRun or StartupSource.HkcuRunWow64 or StartupSource.StartupFolderUser
                => RegistryHive.CurrentUser,
            _ => RegistryHive.LocalMachine
        };
        var view = source is StartupSource.HkcuRunWow64 or StartupSource.HklmRunWow64
            ? RegistryView.Registry32
            : RegistryView.Registry64;

        try
        {
            var baseKey = RegistryKey.OpenBaseKey(hive, view);
            return writable ? baseKey.CreateSubKey(path, writable: true) : baseKey.OpenSubKey(path, false);
        }
        catch { return null; }
    }

    private static string MakeId(StartupSource source, string location, string name)
    {
        var raw = $"{source}|{location}|{name}".ToLowerInvariant();
        var hash = SHA1.HashData(Encoding.UTF8.GetBytes(raw));
        return $"{source}:{Convert.ToHexString(hash)[..12].ToLowerInvariant()}";
    }
}