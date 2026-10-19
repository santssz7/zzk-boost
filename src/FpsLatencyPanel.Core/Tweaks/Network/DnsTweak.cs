namespace FpsLatencyPanel.Core.Tweaks.Network;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public enum DnsProvider { Cloudflare, Google, Automatic }

public sealed class DnsTweak : ITweak
{
    private readonly INetworkService _net;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public DnsProvider Provider { get; set; } = DnsProvider.Cloudflare;

    private static readonly string[] CloudflareServers = { "1.1.1.1", "1.0.0.1" };
    private static readonly string[] GoogleServers     = { "8.8.8.8", "8.8.4.4" };

    public DnsTweak(INetworkService net, IBackupManager backup, ILogger log)
    {
        _net = net; _backup = backup; _log = log;
    }

    public string Id => "net.dns";
    public string Name => "Trocar DNS do adaptador ativo";
    public TweakCategory Category => TweakCategory.Network;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Troca o servidor DNS do adaptador de rede fisico ativo. DNS afeta o tempo " +
        "para RESOLVER nomes, nao a velocidade do download.";

    public string HowToUndo =>
        "Reverter pelo painel restaura o DNS anterior.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null) return TweakState.NaoAplicavel;

        var current = await _net.GetDnsServersAsync(physical.Name, ct);
        if (current.Count == 0) return TweakState.NaoAplicado;

        var target = ServersFor(Provider);
        if (target is null) return TweakState.NaoAplicavel;

        return current.SequenceEqual(target) ? TweakState.Aplicado : TweakState.NaoAplicado;
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null)
            return TweakResult.Fail("Nenhum adaptador fisico ativo.");

        var before = await _net.GetDnsServersAsync(physical.Name, ct);
        await _backup.SaveAsync(Id, "adapterId", physical.Id, "string", ct);
        await _backup.SaveAsync(Id, "adapterName", physical.Name, "string", ct);
        await _backup.SaveAsync(Id, "before", string.Join(",", before), "csv", ct);
        await _backup.SaveAsync(Id, "beforeEmpty", (before.Count == 0 ? "1" : "0"), "flag", ct);

        if (Provider == DnsProvider.Automatic)
        {
            var okReset = await _net.ResetDnsServersAsync(physical.Name, ct);
            return okReset
                ? TweakResult.Ok("DNS restaurado para automatico.", string.Join(",", before), "DHCP")
                : TweakResult.Fail("Falha ao restaurar DNS automatico.");
        }

        var target = ServersFor(Provider);
        if (target is null) return TweakResult.Fail("Provedor DNS invalido.");

        var ok = await _net.SetDnsServersAsync(physical.Name, target, ct);
        if (!ok) return TweakResult.Fail("Falha ao definir DNS.", before: string.Join(",", before));

        _log.Info($"Tweak:{Id}", $"DNS definido para {Provider}.",
            string.Join(",", before), string.Join(",", target));
        return TweakResult.Ok($"DNS definido para {Provider}.", string.Join(",", before), string.Join(",", target));
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var nameB = await _backup.LoadAsync(Id, "adapterName", ct);
        var wasEmptyB = await _backup.LoadAsync(Id, "beforeEmpty", ct);
        var beforeB = await _backup.LoadAsync(Id, "before", ct);

        if (nameB is null)
            return TweakResult.Fail("Sem backup do adaptador. Restaure DNS manualmente.");

        if (wasEmptyB?.Value == "1")
        {
            var ok = await _net.ResetDnsServersAsync(nameB.Value, ct);
            return ok
                ? TweakResult.Ok("DNS restaurado para automatico.")
                : TweakResult.Fail("Falha ao restaurar DNS automatico.");
        }

        if (beforeB is null || string.IsNullOrWhiteSpace(beforeB.Value))
            return TweakResult.Fail("Backup de DNS invalido.");

        var servers = beforeB.Value.Split(',', StringSplitOptions.RemoveEmptyEntries);
        var ok2 = await _net.SetDnsServersAsync(nameB.Value, servers, ct);
        return ok2
            ? TweakResult.Ok($"DNS restaurado ({beforeB.Value}).")
            : TweakResult.Fail("Falha ao restaurar DNS.");
    }

    private string[]? ServersFor(DnsProvider p) => p switch
    {
        DnsProvider.Cloudflare => CloudflareServers,
        DnsProvider.Google     => GoogleServers,
        DnsProvider.Automatic  => null,
        _ => null
    };
}