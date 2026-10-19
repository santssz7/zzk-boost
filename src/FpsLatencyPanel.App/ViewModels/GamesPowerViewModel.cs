namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class GamesPowerViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _rebootNotice = "";
    public string RebootNotice { get => _rebootNotice; set => Set(ref _rebootNotice, value); }

    public ICommand ApplyItemCommand { get; }
    public ICommand RevertItemCommand { get; }
    public ICommand ApplyAllSafeCommand { get; }
    public ICommand RefreshCommand { get; }

    public GamesPowerViewModel(
        IEnumerable<ITweak> all,
        TweakEngine engine,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _engine = engine; _dialog = dialog; _gate = gate;
        foreach (var t in all.Where(x => x.Category is TweakCategory.Games or TweakCategory.Power))
            Items.Add(new TweakItemViewModel(t));

        ApplyItemCommand    = new AsyncRelayCommand<TweakItemViewModel>(ApplyItemAsync);
        RevertItemCommand   = new AsyncRelayCommand<TweakItemViewModel>(RevertItemAsync);
        ApplyAllSafeCommand = new AsyncRelayCommand(ApplyAllSafeAsync);
        RefreshCommand      = new AsyncRelayCommand(() => RefreshAllAsync());
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var i in Items) await i.RefreshAsync(ct);
        var reboot = Items.Where(i => i.Tweak.RequiresReboot && i.IsApplied).ToList();
        RebootNotice = reboot.Count > 0
            ? $"Reinício necessário para: {string.Join(", ", reboot.Select(r => r.Tweak.Name))}"
            : "";
    }

    public async Task ApplyItemAsync(TweakItemViewModel item)
    {
        if (!_gate.EnsureLicensed("Aplicar " + item.Tweak.Name)) return;

        if (item.Tweak.AffectsLaptop &&
            !_dialog.Confirm("Notebook detectado",
                $"{item.Tweak.Name} afeta consumo em bateria. Aplicar mesmo assim?"))
            return;

        if (!_dialog.Confirm("Aplicar", $"Aplicar \"{item.Tweak.Name}\"?\n\n{item.Tweak.Description}")) return;

        Busy = true;
        try
        {
            var opts = new EngineOptions(false, IsLaptopUserAcknowledged: true);
            var report = await _engine.ApplyManyAsync(new[] { item.Tweak }, opts,
                new Progress<string>(p => Progress = p));

            var result = report.Details.FirstOrDefault().Result;

            if (result.Success)
            {
                item.MarkAsApplied(result.Message ?? "Aplicado.");
                UpdateRebootNotice();
            }
            else
            {
                await item.RefreshAsync();
            }
        }
        finally { Busy = false; Progress = ""; }
    }

    public async Task RevertItemAsync(TweakItemViewModel item)
    {
        if (!_dialog.Confirm("Reverter", $"Reverter \"{item.Tweak.Name}\"?")) return;
        Busy = true;
        try
        {
            var report = await _engine.RevertAllAsync(new[] { item.Tweak },
                new Progress<string>(p => Progress = p));

            var result = report.Details.FirstOrDefault().Result;

            if (result.Success)
            {
                item.MarkAsNotApplied(result.Message ?? "Revertido.");
                UpdateRebootNotice();
            }
            else
            {
                await item.RefreshAsync();
            }
        }
        finally { Busy = false; Progress = ""; }
    }

    public async Task ApplyAllSafeAsync()
    {
        if (!_gate.EnsureLicensed("Aplicar ajustes seguros")) return;

        var pending = Items.Where(i =>
            !i.IsApplied && !i.IsNotApplicable
            && !i.Tweak.RequiresReboot
            && i.Tweak.Risk == RiskLevel.Baixo).ToList();

        if (pending.Count == 0) { _dialog.Info("Jogos / Energia", "Nada pendente de baixo risco."); return; }
        if (!_dialog.Confirm("Aplicar seguros",
            $"Aplicar {pending.Count} ajustes de baixo risco, sem reboot?")) return;

        Busy = true;
        try
        {
            var opts = new EngineOptions(false, IsLaptopUserAcknowledged: true);
            var report = await _engine.ApplyManyAsync(pending.Select(p => p.Tweak), opts,
                new Progress<string>(p => Progress = p));

            // Marca cada um conforme o resultado
            foreach (var detail in report.Details)
            {
                var item = Items.FirstOrDefault(i => i.Tweak.Id == detail.TweakId);
                if (item is null) continue;

                if (detail.Result.Success && detail.Result.Message?.Contains("já aplicado", StringComparison.OrdinalIgnoreCase) != true)
                    item.MarkAsApplied(detail.Result.Message ?? "Aplicado.");
            }

            UpdateRebootNotice();
        }
        finally { Busy = false; Progress = ""; }
    }

    private void UpdateRebootNotice()
    {
        var reboot = Items.Where(i => i.Tweak.RequiresReboot && i.IsApplied).ToList();
        RebootNotice = reboot.Count > 0
            ? $"Reinício necessário para: {string.Join(", ", reboot.Select(r => r.Tweak.Name))}"
            : "";
    }
}