namespace FpsLatencyPanel.Core.Infrastructure;

public sealed record CleanupTargetResult(
    string Label,
    string Path,
    long BytesFreed,
    int FilesDeleted,
    int FilesSkipped,
    string? Error);

public interface IFileSystemService
{
    long MeasureBytes(string path);
    CleanupTargetResult CleanDirectory(string label, string path, CancellationToken ct = default);
    CleanupTargetResult EmptyRecycleBin(CancellationToken ct = default);
}