namespace FpsLatencyPanel.Core.Tweaks.Power;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class UsbSuspendTweak : ITweak
{
    private readonly IPowerPlanService _power;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public UsbSuspendTweak(IPowerPlanService power, IBackupManager backup, ILogger log)
    {
        _power = power; _backup = backup; _log = log;
    }

    public string Id => "power.usbsuspend";
    public string Name => "Desligar suspensao seletiva USB (na tomada)";
    public TweakCategory Category => TweakCategory.Power;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => true;
    public bool RequiresReboot => false;

    public string Description =>
        "Desativa a Suspensao Seletiva USB no plano customizado, na TOMADA. Evita " +
        "que dispositivos USB (mouse, teclado, headset) entrem em suspensao e " +
        "acordem com micro-atraso. Na BATERIA, mantemos ligado para nao drenar. " +
        "So e aplicado no plano \"ZZK BOOST - Performance\" - seu plano original fica " +
        "intocado.";

    public string HowToUndo =>
        "Reverter pelo painel reativa o valor original no plano customizado.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var plan = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (plan is null) return TweakState.NaoAplicavel;

        var ac = await _power.GetSettingAsync(
            plan.Value, PowerGuids.SubUsbSettings, PowerGuids.SettingUsbSuspend, onAc: true, ct);

        return ac switch
        {
            PowerSettingValue.Off => TweakState.Aplicado,
            PowerSettingValue.On  => TweakState.NaoAplicado,
            _ => TweakState.Desconhecido("Nao foi possivel ler configuracao USB.")
        };
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var plan = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (plan is null)
            return TweakResult.Fail("Plano customizado nao existe. Aplique primeiro o ajuste \"power.customplan\".");

        var acBefore = await _power.GetSettingAsync(
            plan.Value, PowerGuids.SubUsbSettings, PowerGuids.SettingUsbSuspend, onAc: true, ct);

        await _backup.SaveAsync(Id, "acBefore", acBefore.ToString(), "enum", ct);
        await _backup.SaveAsync(Id, "planGuid", plan.Value.ToString(), "guid", ct);

        var ok = await _power.SetSettingEnabledAsync(
            plan.Value, PowerGuids.SubUsbSettings, PowerGuids.SettingUsbSuspend,
            onAc: false, onDc: true, ct);

        if (!ok) return TweakResult.Fail("Falha ao aplicar configuracao USB.", before: acBefore.ToString());

        _log.Info($"Tweak:{Id}", "USB selective suspend desligado em AC.", acBefore.ToString(), "Off");
        return TweakResult.Ok("USB suspend desligado na tomada.", acBefore.ToString(), "Off");
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
            plan, PowerGuids.SubUsbSettings, PowerGuids.SettingUsbSuspend,
            onAc: onAc, onDc: true, ct);

        return ok
            ? TweakResult.Ok($"Restaurado (AC={(onAc ? "On" : "Off")}).")
            : TweakResult.Fail("Falha ao restaurar USB.");
    }
}