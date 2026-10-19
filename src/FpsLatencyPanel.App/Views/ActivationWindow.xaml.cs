namespace FpsLatencyPanel.App.Views;

using System.Diagnostics;
using System.IO;
using System.Text;
using System.Windows;
using System.Windows.Input;
using FpsLatencyPanel.Core.Licensing;
using Microsoft.Extensions.DependencyInjection;

public partial class ActivationWindow : Window
{
    private const string BuyUrl = "https://wa.me/5500000000000";
    private readonly ILicenseService _license;

    public string MachineId { get; }

    public ActivationWindow(ILicenseService license)
    {
        InitializeComponent();
        _license = license;
        MachineId = _license.GetMachineId();
        DataContext = this;
    }

    private void TopBar_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    {
        if (e.ButtonState == MouseButtonState.Pressed)
            DragMove();
    }

    private void Minimize_Click(object sender, RoutedEventArgs e) => WindowState = WindowState.Minimized;

    private void Maximize_Click(object sender, RoutedEventArgs e)
        => WindowState = WindowState == WindowState.Maximized ? WindowState.Normal : WindowState.Maximized;

    private void Window_StateChanged(object sender, EventArgs e)
    {
        if (WindowState == WindowState.Maximized)
        {
            MaxHeight = SystemParameters.WorkArea.Height + 14;
            MaxWidth = SystemParameters.WorkArea.Width + 14;
            MaximizeButton.Content = "❐";
            MaximizeButton.ToolTip = "Restaurar";
        }
        else
        {
            MaxHeight = double.PositiveInfinity;
            MaxWidth = double.PositiveInfinity;
            MaximizeButton.Content = "□";
            MaximizeButton.ToolTip = "Maximizar";
        }
    }

    private void Close_Click(object sender, RoutedEventArgs e) => Application.Current.Shutdown();

    private void CopyMachineId_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            Clipboard.SetText(MachineId);
            ShowStatus("Machine ID copiado.", isError: false);
        }
        catch
        {
            ShowStatus("Não foi possível copiar.", isError: true);
        }
    }

    /// <summary>
    /// Lê a key do arquivo key.txt. Procura em vários lugares para facilitar.
    /// </summary>
    private void LoadKeyFile_Click(object sender, RoutedEventArgs e)
    {
        var candidates = new[]
        {
            Path.Combine(AppContext.BaseDirectory, "key.txt"),
            Path.Combine(Environment.CurrentDirectory, "key.txt"),
            @"C:\FpsPanel\tools\KeyGen\key.txt",
            @"C:\FpsPanel\key.txt"
        };

        foreach (var path in candidates)
        {
            if (File.Exists(path))
            {
                try
                {
                    var content = File.ReadAllText(path, Encoding.UTF8).Trim();
                    if (!string.IsNullOrWhiteSpace(content))
                    {
                        KeyTextBox.Text = content;
                        ShowStatus("Key carregada de: " + Path.GetFileName(path), isError: false);
                        return;
                    }
                }
                catch { }
            }
        }

        ShowStatus("Arquivo 'key.txt' não encontrado. Rode `dotnet run -- issue ...` no KeyGen e tente novamente.", isError: true);
    }

    private void Activate_Click(object sender, RoutedEventArgs e)
    {
        var key = KeyTextBox.Text?.Trim() ?? "";
        if (string.IsNullOrWhiteSpace(key))
        {
            ShowStatus("Cole a key recebida por email.", isError: true);
            return;
        }

        LicenseInfo info;
        try
        {
            info = _license.Activate(key);
        }
        catch (Exception ex)
        {
            ShowStatus("Erro inesperado ao validar: " + ex.Message, isError: true);
            return;
        }

        if (info.Status == LicenseStatus.Valid)
        {
            ShowStatus("Licença ativada! Abrindo painel...", isError: false);

            var main = App.Services.GetRequiredService<MainWindow>();
            main.DataContext = App.Services.GetRequiredService<ViewModels.MainViewModel>();
            main.Show();

            var home = App.Services.GetRequiredService<ViewModels.HomeViewModel>();
            _ = home.InitializeAsync();

            Close();
        }
        else if (info.Status == LicenseStatus.Corrupted)
        {
            ShowStatus("Key inválida. Tente o botão 'Carregar key.txt' para pegar a key sem erros de cópia.", isError: true);
        }
        else if (info.Status == LicenseStatus.HardwareMismatch)
        {
            ShowStatus("Esta key é de outro computador. Gere uma nova com o Machine ID atual.", isError: true);
        }
        else
        {
            ShowStatus(info.Message, isError: true);
        }
    }

    private void Buy_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            Process.Start(new ProcessStartInfo(BuyUrl) { UseShellExecute = true });
        }
        catch
        {
            ShowStatus("Não foi possível abrir o link.", isError: true);
        }
    }

    private void ShowStatus(string message, bool isError)
    {
        StatusText.Text = message;
        StatusText.Foreground = isError
            ? (System.Windows.Media.Brush)FindResource("DangerBrush")
            : (System.Windows.Media.Brush)FindResource("OkBrush");
        StatusText.Visibility = Visibility.Visible;
    }
}