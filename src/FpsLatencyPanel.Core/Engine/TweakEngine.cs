namespace FpsLatencyPanel.Core.Engine;

using FpsLatencyPanel.Core.Abstractions;

public sealed record EngineOptions(
    bool CreateRestorePoint,
    bool IsLaptopUserAcknowledged);

public sealed record EngineReport(
    int Total,
    int Applied,
    int Skipped,
    int Failed,
    IReadOnlyList<(string TweakId, TweakResult Result)> Details);

public sealed class TweakEngine
{
    private readonly IBackupManager _backup;
    private readonly ILogger _log;
    private readonly IRestorePointService _rp;

    public TweakEngine(IBackupManager backup, ILogger log, IRestorePointService rp)
    {
        _backup = backup;
        _log    = log;
        _rp     = rp;
    }

    public async Task<EngineReport> ApplyManyAsync(
        IEnumerable<ITweak> tweaks,
        EngineOptions options,
        IProgress<string>? progress = null,
        CancellationToken ct = default)
    {
        var list = tweaks.ToList();
        var details = new List<(string, TweakResult)>();
        int applied = 0, skipped = 0, failed = 0;

        if (options.CreateRestorePoint)
        {
            progress?.Report("Criando ponto de restauracao...");
            var ok = await _rp.TryCreateAsync($"ZZK BOOST - antes de aplicar ajustes em {DateTime.Now:yyyy-MM-dd HH:mm}", ct);
            if (!ok)
            {
                _log.Warn("TweakEngine", "Ponto de restauracao nao pode ser criado. Prosseguindo com backup JSON.");
            }
        }

        foreach (var tweak in list)
        {
            ct.ThrowIfCancellationRequested();
            progress?.Report($"Aplicando: {tweak.Name}");

            if (tweak.AffectsLaptop && !options.IsLaptopUserAcknowledged)
            {
                var skip = TweakResult.Skipped("Ignorado: exige confirmacao em notebook.");
                details.Add((tweak.Id, skip));
                skipped++;
                continue;
            }

            try
            {
                var state = await tweak.DetectAsync(ct);
                if (state.Kind == TweakStateKind.Aplicado)
                {
                    var s = TweakResult.Skipped("Ja aplicado.", state.Detalhe);
                    details.Add((tweak.Id, s));
                    skipped++;
                    continue;
                }
                if (state.Kind == TweakStateKind.NaoAplicavel)
                {
                    var s = TweakResult.Skipped("Nao aplicavel: " + state.Detalhe);
                    details.Add((tweak.Id, s));
                    skipped++;
                    continue;
                }

                var result = await tweak.ApplyAsync(ct);

                if (result.Success)
                {
                    applied++;
                    _log.Info($"Tweak:{tweak.Id}", $"Aplicado: {result.Message}", result.ValueBefore, result.ValueAfter);
                }
                else
                {
                    failed++;
                    _log.Error($"Tweak:{tweak.Id}", $"Falha ao aplicar: {result.Message}", result.Error, result.ValueBefore);
                    try { await tweak.RevertAsync(ct); }
                    catch (Exception ex) { _log.Error($"Tweak:{tweak.Id}", "Falha tambem no rollback.", ex); }
                }
                details.Add((tweak.Id, result));
            }
            catch (Exception ex)
            {
                failed++;
                _log.Error($"Tweak:{tweak.Id}", "Excecao nao tratada no tweak.", ex);
                details.Add((tweak.Id, TweakResult.Fail("Excecao: " + ex.Message, ex)));
                try { await tweak.RevertAsync(ct); } catch { }
            }
        }

        return new EngineReport(list.Count, applied, skipped, failed, details);
    }

    public async Task<EngineReport> RevertAllAsync(
        IEnumerable<ITweak> tweaks,
        IProgress<string>? progress = null,
        CancellationToken ct = default)
    {
        var list = tweaks.ToList();
        var details = new List<(string, TweakResult)>();
        int ok = 0, skipped = 0, failed = 0;

        foreach (var tweak in list)
        {
            ct.ThrowIfCancellationRequested();
            progress?.Report($"Revertendo: {tweak.Name}");
            try
            {
                var state = await tweak.DetectAsync(ct);
                if (state.Kind == TweakStateKind.NaoAplicado)
                {
                    details.Add((tweak.Id, TweakResult.Skipped("Nada a reverter.", state.Detalhe)));
                    skipped++;
                    continue;
                }

                var r = await tweak.RevertAsync(ct);
                if (r.Success) { ok++; _log.Info($"Tweak:{tweak.Id}", $"Revertido: {r.Message}", r.ValueBefore, r.ValueAfter); }
                else { failed++; _log.Error($"Tweak:{tweak.Id}", $"Falha ao reverter: {r.Message}", r.Error); }
                details.Add((tweak.Id, r));
            }
            catch (Exception ex)
            {
                failed++;
                _log.Error($"Tweak:{tweak.Id}", "Excecao ao reverter.", ex);
                details.Add((tweak.Id, TweakResult.Fail("Excecao: " + ex.Message, ex)));
            }
        }

        return new EngineReport(list.Count, ok, skipped, failed, details);
    }
}