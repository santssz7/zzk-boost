namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Text;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class HomeViewModel : ViewModelBase
{
    private readonly IEnvironmentDetector _env;
    private readonly ProfileRecommended _profile;
    private readonly TweakEngine _engine;
    private readonly ILogger _log;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private EnvironmentInfo? _envInfo;
    public EnvironmentInfo? EnvInfo { get => _envInfo; set => Set(ref _envInfo, value); }

    private string _envSummary = "Detectando...";
    public string EnvSummary { get => _envSummary; set => Set(ref _envSummary, value); }

    private string _profileSummary = "";
    public string ProfileSummary { get => _profileSummary; set => Set(ref _profileSummary, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _createRestorePoint = true;
    public bool CreateRestorePoint { get => _createRestorePoint; set => Set(ref _createRestorePoint, value); }

    private double _otimizacaoPercent;
    public double OtimizacaoPercent { get => _otimizacaoPercent; set => Set(ref _otimizacaoPercent, value); }

    private string _appliedCount = "0 de 0 ajustes";
    public string AppliedCount { get => _appliedCount; set => Set(ref _appliedCount, value); }

    public HomeViewModel(
        IEnvironmentDetector env,
        ProfileRecommended profile,
        TweakEngine engine,
        ILogger log,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _env = env; _profile = profile; _engine = engine; _log = log; _dialog = dialog; _gate = gate;
    }

    public async Task InitializeAsync(CancellationToken ct = default)
    {
        Busy = true;
        try
        {
            EnvInfo = await _env.DetectAsync(ct);
            EnvSummary = BuildEnvSummary(EnvInfo!);

            Items.Clear();
            foreach (var step in _profile.Steps)
                Items.Add(new TweakItemViewModel(step.Tweak));

            await RefreshAllAsync(ct);

            ProfileSummary = $"Perfil recomendado: {_profile.Steps.Count} ajustes seguros.";
        }
        catch (Exception ex)
        {
            _log.Error("HomeViewModel", "Falha na inicializacao.", ex);
            EnvSummary = "Falha ao detectar ambiente: " + ex.Message;
        }
        finally { Busy = false; }
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var item in Items)
            await item.RefreshAsync(ct);

        UpdateScore();
    }

    public async Task ApplyRecommendedAsync()
    {
        if (!_gate.EnsureLicensed("Aplicar perfil recomendado")) return;

        var pending = Items.Where(i => !i.IsApplied && !i.IsNotApplicable).ToList();
        if (pending.Count == 0) { _dialog.Info("Perfil recomendado", "Todos os ajustes já estão aplicados."); return; }

        var sb = new StringBuilder();
        sb.AppendLine($"Serão aplicados {pending.Count} ajustes:");
        foreach (var p in pending) sb.AppendLine($"  • {p.Tweak.Name}");
        sb.AppendLine();
        sb.AppendLine("Backup automático por ajuste.");

        if (!_dialog.Confirm("Aplicar perfil recomendado", sb.ToString())) return;

        Busy = true;
        try
        {
            var prog = new Progress<string>(p => Progress = p);
            bool laptopAck = EnvInfo?.IsLaptop != true ||
                _dialog.Confirm("Notebook detectado", "Aplicar ajustes de energia mesmo em bateria?");
            var opts = new EngineOptions(CreateRestorePoint, laptopAck);
            var report = await _engine.ApplyManyAsync(_profile.Tweaks, opts, prog);

            foreach (var detail in report.Details)
            {
                var item = Items.FirstOrDefault(i => i.Tweak.Id == detail.TweakId);
                if (item is null) continue;

                if (detail.Result.Success &&
                    detail.Result.Message?.Contains("já aplicado", StringComparison.OrdinalIgnoreCase) != true)
                {
                    item.MarkAsApplied(detail.Result.Message ?? "Aplicado.");
                }
                else if (!detail.Result.Success && detail.Result.Message?.Contains("não aplicável", StringComparison.OrdinalIgnoreCase) == true)
                {
                    item.MarkAsNotApplicable(detail.Result.Message);
                }
            }

            UpdateScore();
            _dialog.Info("Perfil recomendado",
                $"Aplicados: {report.Applied}\n" +
                $"Já aplicados: {report.Skipped}\n" +
                $"Falhas: {report.Failed}");
        }
        catch (Exception ex)
        {
            _log.Error("HomeViewModel", "Falha ao aplicar perfil recomendado.", ex);
            _dialog.Error("Erro", "Falha ao aplicar: " + ex.Message);
        }
        finally { Busy = false; Progress = ""; }
    }

    private void UpdateScore()
    {
        var applied = Items.Count(i => i.IsApplied);
        var total = Items.Count;
        OtimizacaoPercent = total == 0 ? 0 : Math.Round((double)applied / total * 100);
        AppliedCount = $"{applied} de {total} ajustes aplicados";
    }

    private static string BuildEnvSummary(EnvironmentInfo e)
    {
        var kind = e.SystemDiskKind switch
        {
            DiskKind.Ssd => "SSD",
            DiskKind.Hdd => "HDD",
            _ => "Disco desconhecido"
        };
        var tipo = e.IsLaptop ? "Notebook" : "Desktop";
        return $"{tipo} | {e.LogicalProcessors} nucleos | " +
               $"{e.TotalRamBytes / (1024UL * 1024 * 1024)} GB RAM | " +
               $"{kind} no sistema | Windows {e.WindowsVersion} ({e.WindowsBuild}) | " +
               $"GPU: {e.GpuName}";
    }
}