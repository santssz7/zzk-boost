namespace FpsLatencyPanel.Core.Tweaks.Cleanup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class TempFilesCleanup : ITweak
{
    private readonly IFileSystemService _fs;
    private readonly ILogger _log;

    public TempFilesCleanup(IFileSystemService fs, ILogger log)
    {
        _fs = fs; _log = log;
    }

    public string Id => "clean.temp";
    public string Name => "Limpar arquivos temporarios";
    public TweakCategory Category => TweakCategory.Cleanup;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Apaga arquivos temporarios do usuario, do Windows e do LocalAppData. " +
        "Arquivos em uso sao PULADOS, nao forcados - nada quebra.";

    public string HowToUndo =>
        "Nao ha como restaurar arquivos temporarios apagados.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var total = Targets().Sum(t => _fs.MeasureBytes(t.path));
        return Task.FromResult(total < 100L * 1024 * 1024
            ? TweakState.Aplicado
            : TweakState.NaoAplicado);
    }

    public Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var results = new List<CleanupTargetResult>();
        foreach (var (label, path) in Targets())
        {
            try { results.Add(_fs.CleanDirectory(label, path, ct)); }
            catch (Exception ex)
            {
                _log.Error($"Tweak:{Id}", $"Falha em {label}.", ex);
            }
        }

        long total = results.Sum(r => r.BytesFreed);
        int files = results.Sum(r => r.FilesDeleted);
        int skipped = results.Sum(r => r.FilesSkipped);

        var summary = $"Liberado: {FormatBytes(total)} em {files} arquivos (pulados: {skipped}).";
        _log.Info($"Tweak:{Id}", summary);
        return Task.FromResult(TweakResult.Ok(summary));
    }

    public Task<TweakResult> RevertAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped("Limpeza e irreversivel por natureza."));

    private static IEnumerable<(string label, string path)> Targets()
    {
        yield return ("TEMP do usuario", Path.GetTempPath().TrimEnd('\\'));
        yield return ("LocalAppData\\Temp",
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Temp"));
        yield return ("Windows\\Temp",
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Windows), "Temp"));
    }

    internal static string FormatBytes(long bytes)
    {
        string[] units = { "B", "KB", "MB", "GB", "TB" };
        double v = bytes;
        int u = 0;
        while (v >= 1024 && u < units.Length - 1) { v /= 1024; u++; }
        return $"{v:0.##} {units[u]}";
    }
}