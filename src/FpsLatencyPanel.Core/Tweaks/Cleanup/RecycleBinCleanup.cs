namespace FpsLatencyPanel.Core.Tweaks.Cleanup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class RecycleBinCleanup : ITweak
{
    private readonly IFileSystemService _fs;
    private readonly ILogger _log;

    public RecycleBinCleanup(IFileSystemService fs, ILogger log)
    {
        _fs = fs; _log = log;
    }

    public string Id => "clean.recyclebin";
    public string Name => "Esvaziar Lixeira";
    public TweakCategory Category => TweakCategory.Cleanup;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Esvazia a Lixeira. Arquivos apagados NAO PODEM SER RESTAURADOS. " +
        "Impacto MENSURAVEL em espaco em disco. Nenhum efeito em FPS.";

    public string HowToUndo =>
        "Nao ha como restaurar. A Lixeira e definitiva apos este comando.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
        => Task.FromResult(TweakState.NaoAplicado);

    public Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var r = _fs.EmptyRecycleBin(ct);
        if (r.Error is not null)
            return Task.FromResult(TweakResult.Fail(r.Error));

        var summary = $"Lixeira esvaziada. Liberado: {TempFilesCleanup.FormatBytes(r.BytesFreed)}.";
        _log.Info($"Tweak:{Id}", summary);
        return Task.FromResult(TweakResult.Ok(summary));
    }

    public Task<TweakResult> RevertAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped("Irreversivel por natureza."));
}