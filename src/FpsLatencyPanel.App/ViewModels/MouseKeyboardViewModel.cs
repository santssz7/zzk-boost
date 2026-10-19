namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class MouseKeyboardViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    public ICommand ApplyItemCommand { get; }
    public ICommand RevertItemCommand { get; }

    public MouseKeyboardViewModel(
        IEnumerable<ITweak> all,
        TweakEngine engine,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _engine = engine; _dialog = dialog; _gate = gate;
        foreach (var t in all.Where(x => x.Category is TweakCategory.Mouse or TweakCategory.Keyboard))
            Items.Add(new TweakItemViewModel(t));

        ApplyItemCommand  = new AsyncRelayCommand<TweakItemViewModel>(ApplyItemAsync);
        RevertItemCommand = new AsyncRelayCommand<TweakItemViewModel>(RevertItemAsync);
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var i in Items) await i.RefreshAsync(ct);
    }

    public async Task ApplyItemAsync(TweakItemViewModel item)
    {
        if (!_gate.EnsureLicensed("Aplicar " + item.Tweak.Name)) return;

        if (item.Tweak.AffectsLaptop &&
            !_dialog.Confirm("Confirmação", $"{item.Tweak.Name} afeta notebook. Aplicar?"))
            return;

        if (!_dialog.Confirm("Aplicar", $"Aplicar \"{item.Tweak.Name}\"?\n\n{item.Tweak.Description}")) return;

        Busy = true;
        try
        {
            var opts = new EngineOptions(CreateRestorePoint: false, IsLaptopUserAcknowledged: true);
            var report = await _engine.ApplyManyAsync(new[] { item.Tweak }, opts,
                new Progress<string>(p => Progress = p));

            var result = report.Details.FirstOrDefault().Result;

            if (result.Success)
            {
                // Marca como Ativo IMEDIATAMENTE (não espera DetectAsync).
                item.MarkAsApplied(result.Message ?? "Aplicado.");
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
                // Marca como Inativo IMEDIATAMENTE.
                item.MarkAsNotApplied(result.Message ?? "Revertido.");
            }
            else
            {
                await item.RefreshAsync();
            }
        }
        finally { Busy = false; Progress = ""; }
    }
}