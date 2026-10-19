namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.Core.Licensing;

public sealed class MainViewModel : ViewModelBase
{
    public HomeViewModel Home { get; }
    public MouseKeyboardViewModel MouseKeyboard { get; }
    public GamesPowerViewModel GamesPower { get; }
    public NetworkViewModel Network { get; }
    public CleanupViewModel Cleanup { get; }
    public StartupViewModel Startup { get; }
    public BackupViewModel Backup { get; }
    public LicenseViewModel License { get; }

    public ObservableCollection<NavItem> Navigation { get; }

    private NavItem? _selectedNav;
    public NavItem? SelectedNav
    {
        get => _selectedNav;
        set
        {
            if (Set(ref _selectedNav, value))
            {
                OnPropertyChanged(nameof(CurrentContent));
                _ = RefreshCurrentViewAsync();
            }
        }
    }

    public object? CurrentContent => _selectedNav?.ViewModel;

    public ICommand ApplyRecommendedCommand { get; }
    public ICommand RefreshHomeCommand { get; }

    public MainViewModel(
        HomeViewModel home,
        MouseKeyboardViewModel mk,
        GamesPowerViewModel gp,
        NetworkViewModel net,
        CleanupViewModel clean,
        StartupViewModel su,
        BackupViewModel bk,
        LicenseViewModel license,
        ILicenseService licenseService)
    {
        Home = home; MouseKeyboard = mk; GamesPower = gp;
        Network = net; Cleanup = clean; Startup = su; Backup = bk; License = license;

        ApplyRecommendedCommand = new AsyncRelayCommand(() => Home.ApplyRecommendedAsync());
        RefreshHomeCommand = new AsyncRelayCommand(() => Home.RefreshAllAsync());

        Navigation = new ObservableCollection<NavItem>
        {
            new("Início",            "🏠", home),
            new("Mouse / Teclado",   "🖱️", mk),
            new("Jogos / Energia",   "🎮", gp),
            new("Rede",              "🌐", net),
            new("Limpeza",           "🗑️", clean),
            new("Inicialização",     "⚙️", su),
            new("Backup",            "💾", bk),
            new("Licença",           "🔑", license),
        };

        SelectedNav = Navigation[0];
    }

    private async Task RefreshCurrentViewAsync()
    {
        try
        {
            switch (_selectedNav?.ViewModel)
            {
                case HomeViewModel h:            await h.RefreshAllAsync(); break;
                case MouseKeyboardViewModel mk:  await mk.RefreshAllAsync(); break;
                case GamesPowerViewModel gp:     await gp.RefreshAllAsync(); break;
                case NetworkViewModel n:         await n.RefreshAllAsync(); break;
                case CleanupViewModel c:         await c.RefreshAllAsync(); break;
                case StartupViewModel s:         await s.RefreshAsync(); break;
                case BackupViewModel b:          await b.RefreshAsync(); break;
                case LicenseViewModel l:         l.Refresh(); break;
            }
        }
        catch
        {
            // silencioso — refresh não pode derrubar a UI
        }
    }
}

public sealed record NavItem(string Title, string Icon, object ViewModel);