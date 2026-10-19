namespace FpsLatencyPanel.App.Views;

using System.Windows;
using System.Windows.Input;
using System.Windows.Media;

public enum DialogKind { Question, Info, Warning, Error, Success }

public partial class ConfirmDialog : Window
{
    private readonly Color AccentCyan = (Color)ColorConverter.ConvertFromString("#FF00D9FF");
    private readonly Color WarnAmber  = (Color)ColorConverter.ConvertFromString("#FFF5B740");
    private readonly Color ErrorRed   = (Color)ColorConverter.ConvertFromString("#FFEF4A5A");
    private readonly Color OkGreen    = (Color)ColorConverter.ConvertFromString("#FF3FD17B");
    private readonly Color DarkText   = (Color)ColorConverter.ConvertFromString("#FF00131A");

    public ConfirmDialog(string title, string message, DialogKind kind = DialogKind.Question, bool showCancel = true)
    {
        InitializeComponent();
        TitleText.Text = title;
        MessageText.Text = message;

        ApplyKind(kind);

        if (!showCancel)
            CancelBtn.Visibility = Visibility.Collapsed;
    }

    private void ApplyKind(DialogKind kind)
    {
        string symbol;
        Color bg;
        Color iconFg;
        string confirmText = "Confirmar";
        bool dangerConfirm = false;

        switch (kind)
        {
            case DialogKind.Question:
                symbol = "?"; bg = AccentCyan; iconFg = DarkText; break;
            case DialogKind.Info:
                symbol = "i"; bg = AccentCyan; iconFg = DarkText; confirmText = "OK"; break;
            case DialogKind.Warning:
                symbol = "!"; bg = WarnAmber; iconFg = DarkText; break;
            case DialogKind.Error:
                symbol = "✕"; bg = ErrorRed; iconFg = Colors.White; confirmText = "OK"; dangerConfirm = true; break;
            case DialogKind.Success:
                symbol = "✓"; bg = OkGreen; iconFg = DarkText; confirmText = "OK"; break;
            default:
                symbol = "?"; bg = AccentCyan; iconFg = DarkText; break;
        }

        IconText.Text = symbol;
        IconText.Foreground = new SolidColorBrush(iconFg);
        IconBorder.Background = new SolidColorBrush(bg);

        ConfirmBtn.Content = confirmText;

        // Botão confirmar vermelho em caso de erro
        if (dangerConfirm)
        {
            ConfirmBtn.Background = new SolidColorBrush(ErrorRed);
            ConfirmBtn.Foreground = Brushes.White;
        }
    }

    private void TitleBar_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    {
        if (e.ButtonState == MouseButtonState.Pressed)
            DragMove();
    }

    private void Confirm_Click(object sender, RoutedEventArgs e)
    {
        DialogResult = true;
        Close();
    }

    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        DialogResult = false;
        Close();
    }
}