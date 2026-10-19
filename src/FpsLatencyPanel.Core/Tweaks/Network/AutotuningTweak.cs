namespace FpsLatencyPanel.Core.Tweaks.Network;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class AutotuningTweak : ITweak
{
    private readonly INetworkService _net;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public AutotuningTweak(INetworkService net, IBackupManager backup, ILogger log)
    {
        _net = net; _backup = backup; _log = log;
    }

    public string Id => "net.autotuning";
    public string Name => "TCP autotuning no nivel Normal";
    public TweakCategory Category => TweakCategory.Network;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Garante que o ajuste automatico da janela TCP esteja em Normal, que e o " +
        "padrao do Windows 10/11. NAO aumenta a velocidade da internet.";

    public string HowToUndo =>
        "Reverter pelo painel reaplica o valor original.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var lvl = await _net.GetAutotuningAsync(ct);
        return lvl switch
        {
            AutotuningLevel.Normal => TweakState.Aplicado,
            AutotuningLevel.Unknown => TweakState.Desconhecido("Nao foi possivel ler autotuning."),
            _ => TweakState.NaoAplicado
        };
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var before = await _net.GetAutotuningAsync(ct);
        await _backup.SaveAsync(Id, "level", before.ToString(), "enum", ct);

        if (!await _net.SetAutotuningAsync(AutotuningLevel.Normal, ct))
            return TweakResult.Fail("Falha ao definir autotuninglevel=normal. Painel precisa estar elevado.",
                before: before.ToString());

        var after = await _net.GetAutotuningAsync(ct);
        _log.Info($"Tweak:{Id}", "Autotuning = Normal.", before.ToString(), after.ToString());
        return TweakResult.Ok("Autotuning definido como Normal.", before.ToString(), after.ToString());
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "level", ct);
        var target = AutotuningLevel.Normal;
        if (b is not null && Enum.TryParse<AutotuningLevel>(b.Value, out var parsed))
            target = parsed;

        if (!await _net.SetAutotuningAsync(target, ct))
            return TweakResult.Fail($"Falha ao restaurar {target}.");

        _log.Info($"Tweak:{Id}", $"Autotuning restaurado para {target}.");
        return TweakResult.Ok($"Autotuning restaurado para {target}.");
    }
}