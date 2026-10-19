namespace FpsLatencyPanel.Core.Engine;

using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using FpsLatencyPanel.Core.Abstractions;

public sealed class BackupManager : IBackupManager
{
    private readonly string _dir;
    private readonly ILogger _log;
    private static readonly JsonSerializerOptions JsonOpts = new() { WriteIndented = true };

    public BackupManager(ILogger log, string? baseDir = null)
    {
        _log = log;
        _dir = baseDir ?? Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "FpsLatencyPanel", "backups");
        Directory.CreateDirectory(_dir);
    }

    private string FileFor(string tweakId, string valueKey)
    {
        var safeTweak = Sanitize(tweakId);
        var safeKey   = Sanitize(valueKey);
        return Path.Combine(_dir, $"{safeTweak}__{safeKey}.json");
    }

    private static string Sanitize(string s)
    {
        var sb = new StringBuilder(s.Length);
        foreach (var c in s)
            sb.Append(char.IsLetterOrDigit(c) || c is '.' or '-' or '_' ? c : '_');
        return sb.ToString();
    }

    private static string Sha256Hex(string input)
    {
        var bytes = SHA256.HashData(Encoding.UTF8.GetBytes(input));
        return Convert.ToHexString(bytes).ToLowerInvariant();
    }

    public async Task SaveAsync(string tweakId, string valueKey, string value, string valueKind, CancellationToken ct = default)
    {
        var entry = new BackupEntry(
            tweakId, valueKey, value, valueKind,
            DateTimeOffset.UtcNow, Sha256Hex(value));

        var json = JsonSerializer.Serialize(entry, JsonOpts);
        await File.WriteAllTextAsync(FileFor(tweakId, valueKey), json, ct);
        _log.Info("BackupManager", $"Backup gravado: {tweakId}/{valueKey}", before: value);
    }

    public async Task<BackupEntry?> LoadAsync(string tweakId, string valueKey, CancellationToken ct = default)
    {
        var path = FileFor(tweakId, valueKey);
        if (!File.Exists(path)) return null;

        try
        {
            var json = await File.ReadAllTextAsync(path, ct);
            var entry = JsonSerializer.Deserialize<BackupEntry>(json, JsonOpts);
            if (entry is null) return null;

            var expected = Sha256Hex(entry.Value);
            if (!string.Equals(expected, entry.Sha256, StringComparison.OrdinalIgnoreCase))
            {
                _log.Error("BackupManager", $"Hash invalido no backup {tweakId}/{valueKey}.");
                return null;
            }
            return entry;
        }
        catch (Exception ex)
        {
            _log.Error("BackupManager", $"Falha ao ler backup {tweakId}/{valueKey}.", ex);
            return null;
        }
    }

    public async Task<IReadOnlyList<BackupEntry>> LoadAllForAsync(string tweakId, CancellationToken ct = default)
    {
        var safe = Sanitize(tweakId) + "__";
        var list = new List<BackupEntry>();
        foreach (var f in Directory.EnumerateFiles(_dir, safe + "*.json"))
        {
            try
            {
                var json = await File.ReadAllTextAsync(f, ct);
                var entry = JsonSerializer.Deserialize<BackupEntry>(json, JsonOpts);
                if (entry is not null) list.Add(entry);
            }
            catch (Exception ex)
            {
                _log.Error("BackupManager", $"Falha ao ler {f}.", ex);
            }
        }
        return list;
    }

    public Task DeleteAsync(string tweakId, string valueKey, CancellationToken ct = default)
    {
        var path = FileFor(tweakId, valueKey);
        if (File.Exists(path)) File.Delete(path);
        return Task.CompletedTask;
    }

    public Task<bool> HasAnyAsync(CancellationToken ct = default)
        => Task.FromResult(Directory.EnumerateFiles(_dir, "*.json").Any());
}