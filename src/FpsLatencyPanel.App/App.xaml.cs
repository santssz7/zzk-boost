namespace FpsLatencyPanel.App;

using System.IO;
using System.Windows;
using System.Windows.Threading;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.App.ViewModels;
using FpsLatencyPanel.App.Views;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;
using FpsLatencyPanel.Core.Infrastructure;
using FpsLatencyPanel.Core.Licensing;
using FpsLatencyPanel.Core.Tweaks.Cleanup;
using FpsLatencyPanel.Core.Tweaks.Games;
using FpsLatencyPanel.Core.Tweaks.Keyboard;
using FpsLatencyPanel.Core.Tweaks.Mouse;
using FpsLatencyPanel.Core.Tweaks.Network;
using FpsLatencyPanel.Core.Tweaks.Power;
using FpsLatencyPanel.Core.Tweaks.Startup;
using Microsoft.Extensions.DependencyInjection;

public partial class App : Application
{
    public static ServiceProvider Services { get; private set; } = null!;

    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);

        // CAPTURADOR DE CRASH (Salva o erro no crash.log)
        AppDomain.CurrentDomain.UnhandledException += (s, args) =>
        {
            File.WriteAllText(@"C:\FpsPanel\crash.log", args.ExceptionObject?.ToString() ?? "Erro desconhecido");
        };

        DispatcherUnhandledException += (s, args) =>
        {
            File.WriteAllText(@"C:\FpsPanel\crash.log", args.Exception.ToString());
            // Não marca como Handled, deixa o app fechar, mas já salvou o log.
        };

        try
        {
            var sc = new ServiceCollection();

            sc.AddSingleton<ILogger, FileLogger>();
            sc.AddSingleton<IBackupManager, BackupManager>();
            sc.AddSingleton<IRegistryAccessor, RegistryAccessor>();
            sc.AddSingleton<ISystemParametersService, SystemParametersService>();
            sc.AddSingleton<IPowerPlanService, PowerPlanService>();
            sc.AddSingleton<INetworkService, NetworkService>();
            sc.AddSingleton<IFileSystemService, FileSystemService>();
            sc.AddSingleton<IStartupService, StartupService>();
            sc.AddSingleton<IRestorePointService, RestorePointService>();
            sc.AddSingleton<IEnvironmentDetector, EnvironmentDetector>();
            sc.AddSingleton<ILicenseService, LicenseService>();

            sc.AddSingleton<TweakEngine>();

            sc.AddSingleton<ITweak, MouseAccelerationTweak>();
            sc.AddSingleton<ITweak, MouseSpeedTweak>();
            sc.AddSingleton<ITweak, MouseCurveTweak>();
            sc.AddSingleton<ITweak, KeyboardDelayTweak>();
            sc.AddSingleton<ITweak, KeyboardSpeedTweak>();
            sc.AddSingleton<ITweak, AccessibilityHotkeysTweak>();
            sc.AddSingleton<ITweak, CustomPowerPlanTweak>();
            sc.AddSingleton<ITweak, UsbSuspendTweak>();
            sc.AddSingleton<ITweak, PcieAspmTweak>();
            sc.AddSingleton<ITweak, GameModeTweak>();
            sc.AddSingleton<ITweak, GameDvrTweak>();
            sc.AddSingleton<ITweak, MmcssTweak>();
            sc.AddSingleton<ITweak, Win32PrioritySeparationTweak>();
            sc.AddSingleton<ITweak, FullscreenOptimizationsTweak>();
            sc.AddSingleton<ITweak, AutotuningTweak>();
            sc.AddSingleton<ITweak, RssTweak>();
            sc.AddSingleton<ITweak, DnsTweak>();
            sc.AddSingleton<ITweak, TempFilesCleanup>();
            sc.AddSingleton<ITweak, ShaderCacheCleanup>();
            sc.AddSingleton<ITweak, BrowserCacheCleanup>();
            sc.AddSingleton<ITweak, RecycleBinCleanup>();
                        sc.AddSingleton<StartupItemsManager>();
            sc.AddSingleton<ITweak>(sp => sp.GetRequiredService<StartupItemsManager>());

            sc.AddSingleton<IDialogService, DialogService>();
            sc.AddSingleton<ILicenseGate, LicenseGate>();

            sc.AddSingleton(sp => new ProfileRecommended(sp.GetServices<ITweak>()));

            sc.AddSingleton<HomeViewModel>();
            sc.AddSingleton<MouseKeyboardViewModel>();
            sc.AddSingleton<GamesPowerViewModel>();
            sc.AddSingleton<NetworkViewModel>();
            sc.AddSingleton<CleanupViewModel>();
            sc.AddSingleton<StartupViewModel>();
            sc.AddSingleton<BackupViewModel>();
            sc.AddSingleton<LicenseViewModel>();
            sc.AddSingleton<MainViewModel>();

            sc.AddSingleton<MainWindow>();

            Services = sc.BuildServiceProvider();

            var license = Services.GetRequiredService<ILicenseService>();
            var info = license.GetCurrentStatus();

            if (info.Status == LicenseStatus.Valid)
            {
                var win = Services.GetRequiredService<MainWindow>();
                win.DataContext = Services.GetRequiredService<MainViewModel>();
                win.Show();

                var home = Services.GetRequiredService<HomeViewModel>();
                _ = home.InitializeAsync();
            }
            else
            {
                var act = new ActivationWindow(license);
                act.Show();
            }
        }
        catch (Exception ex)
        {
            File.WriteAllText(@"C:\FpsPanel\startup-error.log", ex.ToString());
            MessageBox.Show(ex.ToString(), "Erro fatal no startup");
            Shutdown(1);
        }
    }
}