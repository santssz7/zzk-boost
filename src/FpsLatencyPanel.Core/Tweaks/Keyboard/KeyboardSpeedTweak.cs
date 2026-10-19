namespace FpsLatencyPanel.Core.Tweaks.Keyboard;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class KeyboardSpeedTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation Loc = new(
        Hive.CurrentUser, @"Control Panel\Keyboard", "KeyboardSpeed", true);

    private const string TargetValue = "31";
    private const string WindowsDefault = "31";

    public KeyboardSpeedTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "kbd.speed";
    public string Name => "Aumentar taxa de repeticao de tecla";
    public TweakCategory Category => TweakCategory.Keyboard;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Define KeyboardSpeed = 31, a taxa maxima de repeticao do Windows (~30 Hz).";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Painel de Controle -> Teclado.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var v = _reg.ReadValue(Loc)?.ToString();
        if (v is null) return Task.FromResult(TweakState.Desconhecido("Valor ausente no registro."));
        return Task.FromResult(v == TargetValue ? TweakState.Aplicado : TweakState.NaoAplicado);
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var before = _reg.ReadValue(Loc)?.ToString() ?? "<ausente>";
        await _backup.SaveAsync(Id, "speed", before, "REG_SZ", ct);

        try
        {
            _reg.WriteValue(Loc, TargetValue, RegistryValueKind.String);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao gravar KeyboardSpeed.", ex, before);
        }

        _log.Info($"Tweak:{Id}", "KeyboardSpeed ajustado.", before, TargetValue);
        return TweakResult.Ok("Taxa de repeticao ajustada.", before, TargetValue);
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "speed", ct);
        var target = b?.Value ?? WindowsDefault;

        try
        {
            _reg.WriteValue(Loc, target, RegistryValueKind.String);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao restaurar KeyboardSpeed.", ex);
        }

        _log.Info($"Tweak:{Id}", "KeyboardSpeed restaurado.", before: TargetValue, after: target);
        return TweakResult.Ok("Restaurado.", before: TargetValue, after: target);
    }
}