namespace FpsLatencyPanel.Core.Tweaks.Power;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class CustomPowerPlanTweak : ITweak
{
    private readonly IPowerPlanService _power;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public CustomPowerPlanTweak(IPowerPlanService power, IBackupManager backup, ILogger log)
    {
        _power = power; _backup = backup; _log = log;
    }

    public string Id => "power.customplan";
    public string Name => "Criar e ativar plano de energia ZZK BOOST";
    public TweakCategory Category => TweakCategory.Power;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => true;
    public bool RequiresReboot => false;

    public string Description =>
        "Cria um plano de energia NOVO (derivado do Alto Desempenho), chamado " +
"\"ZZK BOOST - Performance\", e o ativa. O plano original do Windows NAO e " +
        "O plano original do Windows NAO e alterado nem removido. Em notebooks, " +
        "aumenta consumo de bateria enquanto estiver ativo.";

    public string HowToUndo =>
        "Reverter pelo painel reativa o plano anterior.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var customGuid = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (customGuid is null) return TweakState.NaoAplicado;

        var active = await _power.GetActivePlanGuidAsync(ct);
        if (active is null) return TweakState.Desconhecido("Nao foi possivel ler o plano ativo.");
        return active.Value == customGuid.Value
            ? TweakState.Aplicado
            : TweakState.Parcial("Plano existe, mas nao e o ativo.");
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var previous = await _power.GetActivePlanGuidAsync(ct);
        if (previous is null)
            return TweakResult.Fail("Nao foi possivel ler o plano ativo atual.");

        await _backup.SaveAsync(Id, "previous", previous.Value.ToString(), "guid", ct);

        if (!await _power.EnsureCustomPlanAsync(ct))
            return TweakResult.Fail("Falha ao criar plano customizado.", before: previous.Value.ToString());

        var customGuid = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (customGuid is null)
            return TweakResult.Fail("Plano criado mas GUID nao encontrado.", before: previous.Value.ToString());

        await _backup.SaveAsync(Id, "custom", customGuid.Value.ToString(), "guid", ct);

        if (!await _power.ActivateAsync(customGuid.Value, ct))
            return TweakResult.Fail("Falha ao ativar plano customizado.", before: previous.Value.ToString());

        _log.Info($"Tweak:{Id}", "Plano customizado ativado.", previous.Value.ToString(), customGuid.Value.ToString());
        return TweakResult.Ok("Plano ativado.", previous.Value.ToString(), customGuid.Value.ToString());
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "previous", ct);
        if (b is null || !Guid.TryParse(b.Value, out var previousGuid))
            return TweakResult.Fail("Sem backup do plano anterior.");

        var ok = await _power.ActivateAsync(previousGuid, ct);
        if (!ok) return TweakResult.Fail("Falha ao reativar plano anterior.");

        _log.Info($"Tweak:{Id}", "Plano anterior reativado.", after: previousGuid.ToString());
        return TweakResult.Ok("Plano anterior reativado.", after: previousGuid.ToString());
    }
}