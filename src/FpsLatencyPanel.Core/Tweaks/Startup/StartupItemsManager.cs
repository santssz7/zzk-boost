namespace FpsLatencyPanel.Core.Tweaks.Startup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class StartupItemsManager : ITweak
{
    private readonly IStartupService _startup;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public StartupItemsManager(IStartupService startup, IBackupManager backup, ILogger log)
    {
        _startup = startup; _backup = backup; _log = log;
    }

    public string Id => "startup.manager";
    public string Name => "Gerenciar programas de inicializacao";
    public TweakCategory Category => TweakCategory.Startup;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Lista os programas que abrem com o Windows. VOCE decide o que desativar - " +
        "o painel NUNCA desativa nada sozinho. A desativacao usa o mecanismo oficial " +
        "do Windows (StartupApproved, o mesmo do Gerenciador de Tarefas).";

    public string HowToUndo =>
        "Reative cada item pelo painel, ou: Gerenciador de Tarefas -> Inicializar.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var items = _startup.Enumerate();
        int disabled = items.Count(i => !i.IsEnabled);
        if (items.Count == 0) return Task.FromResult(TweakState.Desconhecido("Nenhum item de inicializacao."));
        if (disabled == 0) return Task.FromResult(TweakState.Aplicado);
        return Task.FromResult(TweakState.Parcial($"{disabled} item(ns) desabilitado(s)."));
    }

    public Task<TweakResult> ApplyAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped(
            "Gerenciamento de inicializacao e sempre manual."));

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var items = _startup.Enumerate();
        int reEnabled = 0, failed = 0;

        foreach (var item in items.Where(i => !i.IsEnabled))
        {
            var b = await _backup.LoadAsync(Id, "item:" + item.Id);
            if (b is null) continue;

            if (_startup.Enable(item, out var err))
            {
                reEnabled++;
                _log.Info($"Tweak:{Id}", $"Reativado: {item.Name}");
            }
            else
            {
                failed++;
                _log.Error($"Tweak:{Id}", $"Falha ao reativar {item.Name}: {err}");
            }
        }

        return failed == 0
            ? TweakResult.Ok($"Reativados {reEnabled} item(ns).")
            : TweakResult.Fail($"Reativados {reEnabled}, falha em {failed}.");
    }

    public IReadOnlyList<StartupItem> List() => _startup.Enumerate();

    public async Task<TweakResult> DisableItemAsync(StartupItem item, CancellationToken ct = default)
    {
        if (!item.IsEnabled)
            return TweakResult.Skipped("Item ja esta desativado.");

        await _backup.SaveAsync(Id, "item:" + item.Id, "enabledBefore", "flag", ct);

        if (!_startup.Disable(item, out var err))
            return TweakResult.Fail($"Falha ao desativar {item.Name}: {err}");

        _log.Info($"Tweak:{Id}", $"Desativado: {item.Name}");
        return TweakResult.Ok($"Desativado: {item.Name}.");
    }

    public async Task<TweakResult> EnableItemAsync(StartupItem item, CancellationToken ct = default)
    {
        if (item.IsEnabled)
            return TweakResult.Skipped("Item ja esta ativado.");

        if (!_startup.Enable(item, out var err))
            return TweakResult.Fail($"Falha ao reativar {item.Name}: {err}");

        await _backup.DeleteAsync(Id, "item:" + item.Id, ct);
        _log.Info($"Tweak:{Id}", $"Reativado: {item.Name}");
        return TweakResult.Ok($"Reativado: {item.Name}.");
    }
}