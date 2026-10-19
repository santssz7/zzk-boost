namespace FpsLatencyPanel.Core.Abstractions;

public sealed record BackupEntry(
    string TweakId,
    string ValueKey,
    string Value,
    string ValueKind,
    DateTimeOffset CapturedAtUtc,
    string Sha256);

public interface IBackupManager
{
    Task SaveAsync(string tweakId, string valueKey, string value, string valueKind, CancellationToken ct = default);
    Task<BackupEntry?> LoadAsync(string tweakId, string valueKey, CancellationToken ct = default);
    Task<IReadOnlyList<BackupEntry>> LoadAllForAsync(string tweakId, CancellationToken ct = default);
    Task DeleteAsync(string tweakId, string valueKey, CancellationToken ct = default);
    Task<bool> HasAnyAsync(CancellationToken ct = default);
}