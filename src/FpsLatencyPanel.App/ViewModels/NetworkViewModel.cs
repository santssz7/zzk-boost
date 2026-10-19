namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;
using FpsLatencyPanel.Core.Tweaks.Network;

public sealed class NetworkViewModel : ViewModelBase
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
    public ICommand SetDnsCloudflareCommand { get; }
    public ICommand SetDnsGoogleCommand { get; }
    public ICommand SetDnsAutoCommand { get; }

    public NetworkViewModel(
        IEnumerable<ITweak> all,
        TweakEngine engine,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _engine = engine; _dialog = dialog; _gate = gate;
        foreach (var t in all.Where(x => x.Category == TweakCategory.Network))
            Items.Add(new TweakItemViewModel(t));

        ApplyItemCommand = new AsyncRelayCommand<TweakItemViewModel>(ApplyItemAsync);
        SetDnsCloudflareCommand = new AsyncRelayCommand(() => SetDnsAsync(DnsProvider.Cloudflare));
        SetDnsGoogleCommand     = new AsyncRelayCommand(() => SetDnsAsync(DnsProvider.Google));
        SetDnsAutoCommand       = new AsyncRelayCommand(() => SetDnsAsync(DnsProvider.Automatic));
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var i in Items) await i.RefreshAsync(ct);
    }

    public async Task ApplyItemAsync(TweakItemViewModel item)
    {
        if (!_gate.EnsureLicensed("Aplicar " + item.Tweak.Name)) return;
        if (!_dialog.Confirm("Aplicar", $"{item.Tweak.Name}\n\n{item.Tweak.Description}")) return;
        Busy = true;
        try
        {
            var report = await _engine.ApplyManyAsync(new[] { item.Tweak },
                new EngineOptions(false, true), new Progress<string>(p => Progress = p));

            var result = report.Details.FirstOrDefault().Result;
            if (result.Success)
                item.MarkAsApplied(result.Message ?? "Aplicado.");
            else
                await item.RefreshAsync();
        }
        finally { Busy = false; Progress = ""; }
    }

    public async Task SetDnsAsync(DnsProvider provider)
    {
        if (!_gate.EnsureLicensed("Trocar DNS")) return;

        var dns = Items.Select(i => i.Tweak).OfType<DnsTweak>().FirstOrDefault();
        if (dns is null) { _dialog.Error("DNS", "Tweak de DNS não encontrado."); return; }
        dns.Provider = provider;

        if (!_dialog.Confirm("DNS", $"Definir DNS para {provider}?\n\n{dns.Description}")) return;

        Busy = true;
        try
        {
            var report = await _engine.ApplyManyAsync(new[] { (ITweak)dns },
                new EngineOptions(false, true), new Progress<string>(p => Progress = p));

            var dnsItem = Items.FirstOrDefault(i => i.Tweak.Id == "net.dns");
            var result = report.Details.FirstOrDefault().Result;

            if (result.Success && dnsItem is not null)
                dnsItem.MarkAsApplied(result.Message ?? "Aplicado.");
            else if (dnsItem is not null)
                await dnsItem.RefreshAsync();
        }
        finally { Busy = false; Progress = ""; }
    }
}