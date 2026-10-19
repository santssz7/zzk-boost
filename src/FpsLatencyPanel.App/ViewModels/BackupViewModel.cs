namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.IO;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class BackupViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly ILogger _log;
    private readonly IDialogService _dialog;
    private readonly IReadOnlyList<ITweak> _all;

    public ObservableCollection<LogEntry> Recent { get; } = new();

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private string _logPath = "";
    public string LogPath { get => _logPath; set => Set(ref _logPath, value); }

    public ICommand RevertAllCommand { get; }
    public ICommand RefreshCommand { get; }
    public ICommand OpenLogFolderCommand { get; }

    public BackupViewModel(
        TweakEngine engine,
        ILogger log,
        IDialogService dialog,
        IEnumerable<ITweak> all)
    {
        _engine = engine; _log = log; _dialog = dialog;
        _all = all.ToList();
        LogPath = log.LogFilePath;

        RevertAllCommand = new AsyncRelayCommand(RevertAllAsync);
        RefreshCommand = new AsyncRelayCommand(RefreshAsync);
        OpenLogFolderCommand = new RelayCommand(OpenLogFolder);
    }

    public Task RefreshAsync()
    {
        Recent.Clear();
        foreach (var e in _log.Recent(200).Reverse()) Recent.Add(e);
        return Task.CompletedTask;
    }

    public async Task RevertAllAsync()
    {
        if (!_dialog.Confirm("Reverter tudo",
            "Isto vai reverter TODOS os ajustes do painel para o estado anterior.\n" +
            "Acoes que a limpeza fez (apagar arquivos) nao podem ser desfeitas.\n\nContinuar?"))
            return;

        Busy = true;
        try
        {
            var report = await _engine.RevertAllAsync(_all, new Progress<string>(p => Progress = p));
            await RefreshAsync();
            _dialog.Info("Reverter tudo",
                $"Revertidos: {report.Applied}\n" +
                $"Ja no estado original: {report.Skipped}\n" +
                $"Falhas: {report.Failed}");
        }
        finally { Busy = false; Progress = ""; }
    }

    public void OpenLogFolder()
    {
        try
        {
            var dir = Path.GetDirectoryName(_log.LogFilePath);
            if (dir is not null && Directory.Exists(dir))
                System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo("explorer.exe", dir) { UseShellExecute = true });
        }
        catch { }
    }
}