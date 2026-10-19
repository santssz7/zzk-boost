namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Infrastructure;
using FpsLatencyPanel.Core.Tweaks.Startup;

public sealed class StartupViewModel : ViewModelBase
{
    private readonly StartupItemsManager _manager;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<StartupItemVM> Items { get; } = new();

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _hint =
        "Voce decide o que desativar. O painel nunca mexe sozinho. " +
        "A desativacao usa o mesmo mecanismo do Gerenciador de Tarefas e e reversivel.";

    public string Hint { get => _hint; set => Set(ref _hint, value); }

    public ICommand ToggleCommand { get; }
    public ICommand RefreshCommand { get; }

    public StartupViewModel(StartupItemsManager manager, IDialogService dialog, ILicenseGate gate)
    {
        _manager = manager; _dialog = dialog; _gate = gate;
        ToggleCommand = new AsyncRelayCommand<StartupItemVM>(ToggleAsync);
        RefreshCommand = new AsyncRelayCommand(RefreshAsync);
    }

    public Task RefreshAsync()
    {
        Items.Clear();
        foreach (var i in _manager.List())
            Items.Add(new StartupItemVM(i));
        return Task.CompletedTask;
    }

    public async Task ToggleAsync(StartupItemVM vm)
    {
        if (!_gate.EnsureLicensed(vm.Item.IsEnabled ? "Desativar item" : "Reativar item")) return;

        Busy = true;
        try
        {
            if (vm.Item.IsEnabled)
            {
                if (!_dialog.Confirm("Desativar", $"Desativar \"{vm.Item.Name}\"?\n\n{vm.Item.Command}")) return;
                var r = await _manager.DisableItemAsync(vm.Item);
                if (!r.Success) _dialog.Error("Erro", r.Message);
            }
            else
            {
                var r = await _manager.EnableItemAsync(vm.Item);
                if (!r.Success) _dialog.Error("Erro", r.Message);
            }
            await RefreshAsync();
        }
        finally { Busy = false; }
    }
}

public sealed class StartupItemVM
{
    public StartupItem Item { get; }
    public StartupItemVM(StartupItem item) => Item = item;
    public string Name => Item.Name;
    public string Command => Item.Command;
    public string Location => Item.Location;
    public bool IsEnabled => Item.IsEnabled;
    public string ToggleText => Item.IsEnabled ? "Desativar" : "Reativar";
}