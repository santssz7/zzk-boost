namespace FpsLatencyPanel.Core.Tweaks.Network;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class RssTweak : ITweak
{
    private readonly INetworkService _net;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public RssTweak(INetworkService net, IBackupManager backup, ILogger log)
    {
        _net = net; _backup = backup; _log = log;
    }

    public string Id => "net.rss";
    public string Name => "Habilitar RSS (Receive Side Scaling)";
    public TweakCategory Category => TweakCategory.Network;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Habilita o Receive Side Scaling, que distribui o processamento de pacotes " +
        "de rede por varios nucleos de CPU. NAO aumenta a velocidade da internet.";

    public string HowToUndo =>
        "Reverter pelo painel restaura o valor anterior.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null) return TweakState.NaoAplicavel;

        var rss = await _net.GetRssAsync(physical.Name, ct);
        if (rss is null) return TweakState.Desconhecido("Nao foi possivel ler RSS.");
        return rss.Value ? TweakState.Aplicado : TweakState.NaoAplicado;
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null)
            return TweakResult.Fail("Nenhum adaptador fisico ativo encontrado.");

        var before = await _net.GetRssAsync(physical.Name, ct);
        await _backup.SaveAsync(Id, "rss", (before ?? true).ToString(), "bool", ct);

        if (!await _net.SetRssAsync(physical.Name, true, ct))
            return TweakResult.Fail("Falha ao habilitar RSS.", before: before?.ToString());

        _log.Info($"Tweak:{Id}", "RSS habilitado.", before?.ToString(), "True");
        return TweakResult.Ok("RSS habilitado.", before?.ToString(), "True");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null) return TweakResult.Fail("Nenhum adaptador fisico ativo.");

        var b = await _backup.LoadAsync(Id, "rss", ct);
        bool target = true;
        if (b is not null && bool.TryParse(b.Value, out var v)) target = v;

        if (!await _net.SetRssAsync(physical.Name, target, ct))
            return TweakResult.Fail($"Falha ao restaurar RSS para {target}.");

        return TweakResult.Ok($"RSS restaurado para {target}.");
    }
}