namespace FpsLatencyPanel.Core.Abstractions;

public interface IRestorePointService
{
    Task<bool> IsSystemRestoreEnabledAsync(CancellationToken ct = default);
    Task<bool> TryCreateAsync(string description, CancellationToken ct = default);
}