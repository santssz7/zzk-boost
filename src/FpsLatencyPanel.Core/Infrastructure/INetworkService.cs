namespace FpsLatencyPanel.Core.Infrastructure;

public enum AutotuningLevel { Disabled, HighlyRestricted, Restricted, Normal, Experimental, Unknown }

public sealed record NetworkAdapterInfo(
    string Id,
    string Name,
    string Description,
    bool IsUp,
    bool IsPhysical);

public interface INetworkService
{
    Task<IReadOnlyList<NetworkAdapterInfo>> GetActiveAdaptersAsync(CancellationToken ct = default);
    Task<AutotuningLevel> GetAutotuningAsync(CancellationToken ct = default);
    Task<bool> SetAutotuningAsync(AutotuningLevel level, CancellationToken ct = default);
    Task<bool?> GetRssAsync(string adapterName, CancellationToken ct = default);
    Task<bool> SetRssAsync(string adapterName, bool enabled, CancellationToken ct = default);
    Task<IReadOnlyList<string>> GetDnsServersAsync(string adapterName, CancellationToken ct = default);
    Task<bool> SetDnsServersAsync(string adapterName, IReadOnlyList<string> servers, CancellationToken ct = default);
    Task<bool> ResetDnsServersAsync(string adapterName, CancellationToken ct = default);
}