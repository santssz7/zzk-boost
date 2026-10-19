namespace FpsLatencyPanel.Core.Tweaks.Mouse;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class MouseSpeedTweak : ITweak
{
    private readonly ISystemParametersService _spi;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private const int TargetSpeed = 6;

    public MouseSpeedTweak(ISystemParametersService spi, IBackupManager backup, ILogger log)
    {
        _spi = spi; _backup = backup; _log = log;
    }

    public string Id => "mouse.speed";
    public string Name => "Velocidade do mouse 6/11 (1:1)";
    public TweakCategory Category => TweakCategory.Mouse;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Define a velocidade do ponteiro para 6/11, o unico valor em que 1 pixel " +
        "contado = 1 pixel movido. Jogos com RAW INPUT ignoram.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Painel de Controle -> Mouse -> Opcoes de Ponteiro.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var s = _spi.GetMouseSpeed();
        if (s is null) return Task.FromResult(TweakState.Desconhecido("SPI_GETMOUSESPEED falhou."));
        return Task.FromResult(s.Value == TargetSpeed ? TweakState.Aplicado : TweakState.NaoAplicado);
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var cur = _spi.GetMouseSpeed();
        if (cur is null)
            return TweakResult.Fail("Nao foi possivel ler a velocidade atual.");

        await _backup.SaveAsync(Id, "speed", cur.Value.ToString(), "int", ct);

        var ok = _spi.SetMouseSpeed(TargetSpeed);
        if (!ok) return TweakResult.Fail("SPI_SETMOUSESPEED falhou.", before: cur.Value.ToString());

        var after = _spi.GetMouseSpeed();
        _log.Info($"Tweak:{Id}", $"Velocidade ajustada para {TargetSpeed}.", cur.Value.ToString(), after?.ToString());
        return TweakResult.Ok("Velocidade 6/11 aplicada.", cur.Value.ToString(), after?.ToString());
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "speed", ct);
        var target = TargetSpeed;
        if (b is not null && int.TryParse(b.Value, out var v)) target = v;

        var ok = _spi.SetMouseSpeed(target);
        return ok
            ? TweakResult.Ok($"Restaurado para {target}.", after: target.ToString())
            : TweakResult.Fail("Falha ao restaurar velocidade.");
    }
}