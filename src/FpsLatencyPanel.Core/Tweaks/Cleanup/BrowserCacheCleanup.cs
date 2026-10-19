namespace FpsLatencyPanel.Core.Tweaks.Cleanup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class BrowserCacheCleanup : ITweak
{
    private readonly IFileSystemService _fs;
    private readonly ILogger _log;

    public BrowserCacheCleanup(IFileSystemService fs, ILogger log)
    {
        _fs = fs; _log = log;
    }

    public string Id => "clean.browser";
    public string Name => "Limpar cache de navegadores (Chrome / Edge / Firefox)";
    public TweakCategory Category => TweakCategory.Cleanup;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Apaga APENAS as pastas de cache de Chrome, Edge e Firefox. NAO toca em " +
        "cookies, historico, senhas ou favoritos. Voce continuara logado.";

    public string HowToUndo =>
        "Nao ha como restaurar. Cache e descartavel por definicao.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var total = Targets().Where(t => Directory.Exists(t.path)).Sum(t => _fs.MeasureBytes(t.path));
        return Task.FromResult(total < 200L * 1024 * 1024
            ? TweakState.Aplicado
            : TweakState.NaoAplicado);
    }

    public Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var results = new List<CleanupTargetResult>();
        foreach (var (label, path) in Targets())
        {
            if (!Directory.Exists(path)) continue;
            try { results.Add(_fs.CleanDirectory(label, path, ct)); }
            catch (Exception ex) { _log.Error($"Tweak:{Id}", $"Falha em {label}.", ex); }
        }

        long total = results.Sum(r => r.BytesFreed);
        var summary = $"Liberado: {TempFilesCleanup.FormatBytes(total)} em cache de navegadores.";
        _log.Info($"Tweak:{Id}", summary);
        return Task.FromResult(TweakResult.Ok(summary));
    }

    public Task<TweakResult> RevertAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped("Limpeza e irreversivel."));

    private static IEnumerable<(string label, string path)> Targets()
    {
        var local = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
        var roaming = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);

        var chrome = Path.Combine(local, "Google", "Chrome", "User Data");
        foreach (var profile in ProfilesOf(chrome, "Default", "Profile 1", "Profile 2", "Profile 3"))
        {
            yield return ($"Chrome {Path.GetFileName(profile)}/Cache", Path.Combine(profile, "Cache"));
            yield return ($"Chrome {Path.GetFileName(profile)}/Code Cache", Path.Combine(profile, "Code Cache"));
            yield return ($"Chrome {Path.GetFileName(profile)}/GPUCache", Path.Combine(profile, "GPUCache"));
        }

        var edge = Path.Combine(local, "Microsoft", "Edge", "User Data");
        foreach (var profile in ProfilesOf(edge, "Default", "Profile 1", "Profile 2", "Profile 3"))
        {
            yield return ($"Edge {Path.GetFileName(profile)}/Cache", Path.Combine(profile, "Cache"));
            yield return ($"Edge {Path.GetFileName(profile)}/Code Cache", Path.Combine(profile, "Code Cache"));
            yield return ($"Edge {Path.GetFileName(profile)}/GPUCache", Path.Combine(profile, "GPUCache"));
        }

        var ffRoot = Path.Combine(roaming, "Mozilla", "Firefox", "Profiles");
        if (Directory.Exists(ffRoot))
        {
            foreach (var profile in Directory.EnumerateDirectories(ffRoot))
            {
                yield return ($"Firefox {Path.GetFileName(profile)}/cache2",
                    Path.Combine(profile, "cache2"));
            }
        }
    }

    private static IEnumerable<string> ProfilesOf(string root, params string[] candidates)
    {
        if (!Directory.Exists(root)) yield break;
        foreach (var c in candidates)
        {
            var p = Path.Combine(root, c);
            if (Directory.Exists(p)) yield return p;
        }
    }
}