namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class CleanupViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _lastResult = "";
    public string LastResult { get => _lastResult; set => Set(ref _lastResult, value); }

    public ICommand ApplyItemCommand { get; }

    public CleanupViewModel(
        IEnumerable<ITweak> all,
        TweakEngine engine,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _engine = engine; _dialog = dialog; _gate = gate;
        foreach (var t in all.Where(x => x.Category == TweakCategory.Cleanup))
            Items.Add(new TweakItemViewModel(t));

        ApplyItemCommand = new AsyncRelayCommand<TweakItemViewModel>(ApplyItemAsync);
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var i in Items) await i.RefreshAsync(ct);
    }

    public async Task ApplyItemAsync(TweakItemViewModel item)
    {
        if (!_gate.EnsureLicensed("Limpar " + item.Tweak.Name)) return;

        var msg = $"{item.Tweak.Name}\n\n{item.Tweak.Description}\n\nProsseguir?";
        if (!_dialog.Confirm("Confirmar limpeza", msg)) return;

        Busy = true;
        try
        {
            var r = await _engine.ApplyManyAsync(new[] { item.Tweak }, new EngineOptions(false, true),
                new Progress<string>(p => Progress = p));

            var result = r.Details.FirstOrDefault().Result;
            LastResult = result.Message ?? "";

            // Após limpeza bem-sucedida, força o badge para "Ativo".
            if (result.Success)
            {
                item.MarkAsApplied(result.Message ?? "Limpeza concluída.");
            }
            else
            {
                // Se falhou, revalida o estado real.
                await item.RefreshAsync();
            }
        }
        finally { Busy = false; Progress = ""; }
    }
}