namespace FpsLatencyPanel.Core.Tweaks.Cleanup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class ShaderCacheCleanup : ITweak
{
    private readonly IFileSystemService _fs;
    private readonly IEnvironmentDetector _env;
    private readonly ILogger _log;

    public ShaderCacheCleanup(IFileSystemService fs, IEnvironmentDetector env, ILogger log)
    {
        _fs = fs; _env = env; _log = log;
    }

    public string Id => "clean.shader";
    public string Name => "Limpar cache de shaders (DirectX / NVIDIA / AMD)";
    public TweakCategory Category => TweakCategory.Cleanup;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Apaga o cache de shaders compilados. AVISO: o jogo vai RECOMPILAR no proximo " +
        "lancamento - espere alguns segundos de stutter. Em HDD, o tweak e recusado.";

    public string HowToUndo =>
        "Nao ha backup. O cache e recriado automaticamente pelos drivers.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var env = await _env.DetectAsync(ct);
        if (env.SystemDiskKind == DiskKind.Hdd)
            return TweakState.NaoAplicavel;

        var total = Targets().Where(t => Directory.Exists(t.path)).Sum(t => _fs.MeasureBytes(t.path));
        return total < 500L * 1024 * 1024
            ? TweakState.Aplicado
            : TweakState.NaoAplicado;
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var env = await _env.DetectAsync(ct);
        if (env.SystemDiskKind == DiskKind.Hdd)
            return TweakResult.Fail("Cache de shader e ignorado em HDD: recompilacao piora a experiencia.");

        var results = new List<CleanupTargetResult>();
        foreach (var (label, path) in Targets())
        {
            if (!Directory.Exists(path)) continue;
            try { results.Add(_fs.CleanDirectory(label, path, ct)); }
            catch (Exception ex) { _log.Error($"Tweak:{Id}", $"Falha em {label}.", ex); }
        }

        long total = results.Sum(r => r.BytesFreed);
        var summary = $"Liberado: {TempFilesCleanup.FormatBytes(total)}. " +
                      $"Recompilacao de shaders ocorrera no proximo lancamento.";
        _log.Info($"Tweak:{Id}", summary);
        return TweakResult.Ok(summary);
    }

    public Task<TweakResult> RevertAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped("Limpeza e irreversivel."));

    private static IEnumerable<(string label, string path)> Targets()
    {
        var local = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);

        yield return ("D3DSCache", Path.Combine(local, "D3DSCache"));
        yield return ("NVIDIA DXCache", Path.Combine(local, "NVIDIA", "DXCache"));
        yield return ("NVIDIA GLCache", Path.Combine(local, "NVIDIA", "GLCache"));
        yield return ("AMD DxCache", Path.Combine(local, "AMD", "DxCache"));
        yield return ("AMD DxcCache", Path.Combine(local, "AMD", "DxcCache"));
        yield return ("AMD GLCache", Path.Combine(local, "AMD", "GLCache"));
    }
}