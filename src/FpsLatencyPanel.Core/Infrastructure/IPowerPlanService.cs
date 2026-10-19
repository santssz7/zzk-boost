namespace FpsLatencyPanel.Core.Infrastructure;

public enum PowerSettingValue
{
    On,
    Off,
    Unknown
}

public interface IPowerPlanService
{
    Task<Guid?> GetActivePlanGuidAsync(CancellationToken ct = default);
    Task<bool> EnsureCustomPlanAsync(CancellationToken ct = default);
    Task<Guid?> FindPlanGuidByNameAsync(string name, CancellationToken ct = default);
    Task<bool> ActivateAsync(Guid guid, CancellationToken ct = default);

    Task<bool> SetSettingEnabledAsync(
        Guid planGuid,
        Guid subGroupGuid,
        Guid settingGuid,
        bool onAc,
        bool onDc,
        CancellationToken ct = default);

    Task<PowerSettingValue> GetSettingAsync(
        Guid planGuid,
        Guid subGroupGuid,
        Guid settingGuid,
        bool onAc,
        CancellationToken ct = default);
}