namespace FpsLatencyPanel.Core.Tweaks.Power;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class PcieAspmTweak : ITweak
{
    private readonly IPowerPlanService _power;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public PcieAspmTweak(IPowerPlanService power, IBackupManager backup, ILogger log)
    {
        _power = power; _backup = backup; _log = log;
    }

    public string Id => "power.pcieaspm";
    public string Name => "Desligar PCIe ASPM (na tomada)";
    public TweakCategory Category => TweakCategory.Power;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => true;
    public bool RequiresReboot => false;

    public string Description =>
        "Desativa o gerenciamento de energia de estados ativos do barramento PCI " +
        "Express no plano customizado, na TOMADA. Em algumas placas-mae e GPUs isso " +
        "reduz micro-oscilacoes de latencia; em muitas outras e imperceptivel. " +
        "Aplicado somente no plano \"ZZK BOOST - Performance\".";

    public string HowToUndo =>
        "Reverter pelo painel reativa o valor original.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var plan = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (plan is null) return TweakState.NaoAplicavel;

        var ac = await _power.GetSettingAsync(
            plan.Value, PowerGuids.SubPcie, PowerGuids.SettingPcieAspm, onAc: true, ct);

        return ac switch
        {
            PowerSettingValue.Off => TweakState.Aplicado,
            PowerSettingValue.On  => TweakState.NaoAplicado,
            _ => TweakState.Desconhecido("Nao foi possivel ler configuracao PCIe.")
        };
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var plan = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (plan is null)
            return TweakResult.Fail("Plano customizado nao existe. Aplique primeiro o ajuste \"power.customplan\".");

        var acBefore = await _power.GetSettingAsync(
            plan.Value, PowerGuids.SubPcie, PowerGuids.SettingPcieAspm, onAc: true, ct);

        await _backup.SaveAsync(Id, "acBefore", acBefore.ToString(), "enum", ct);
        await _backup.SaveAsync(Id, "planGuid", plan.Value.ToString(), "guid", ct);

        var ok = await _power.SetSettingEnabledAsync(
            plan.Value, PowerGuids.SubPcie, PowerGuids.SettingPcieAspm,
            onAc: false, onDc: true, ct);

        if (!ok) return TweakResult.Fail("Falha ao aplicar configuracao PCIe.", before: acBefore.ToString());

        _log.Info($"Tweak:{Id}", "PCIe ASPM desligado em AC.", acBefore.ToString(), "Off");
        return TweakResult.Ok("PCIe ASPM desligado na tomada.", acBefore.ToString(), "Off");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "planGuid", ct);
        var plan = b is not null && Guid.TryParse(b.Value, out var g)
            ? g
            : await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct) ?? Guid.Empty;
        if (plan == Guid.Empty) return TweakResult.Fail("Plano customizado nao encontrado.");

        var acB = await _backup.LoadAsync(Id, "acBefore", ct);
        bool onAc = acB?.Value == nameof(PowerSettingValue.On);

        var ok = await _power.SetSettingEnabledAsync(
            plan, PowerGuids.SubPcie, PowerGuids.SettingPcieAspm,
            onAc: onAc, onDc: true, ct);

        return ok
            ? TweakResult.Ok($"Restaurado (AC={(onAc ? "On" : "Off")}).")
            : TweakResult.Fail("Falha ao restaurar PCIe.");
    }
}