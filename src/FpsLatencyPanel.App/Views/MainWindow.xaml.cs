namespace FpsLatencyPanel.App.Views;

using System.Windows;
using System.Windows.Input;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }

    private void TitleBar_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    {
        if (e.ClickCount == 2)
        {
            WindowState = WindowState == WindowState.Maximized
                ? WindowState.Normal
                : WindowState.Maximized;
            return;
        }

        if (e.ButtonState == MouseButtonState.Pressed)
            DragMove();
    }

    private void Minimize_Click(object sender, RoutedEventArgs e)
    {
        WindowState = WindowState.Minimized;
    }

    private void Maximize_Click(object sender, RoutedEventArgs e)
    {
        WindowState = WindowState == WindowState.Maximized
            ? WindowState.Normal
            : WindowState.Maximized;
    }

    private void Close_Click(object sender, RoutedEventArgs e)
    {
        Close();
    }

    private void Window_StateChanged(object sender, EventArgs e)
    {
        if (WindowState == WindowState.Maximized)
        {
            // Corrige o bug de maximização cobrir a barra de tarefas
            MaxHeight = SystemParameters.WorkArea.Height + 14;
            MaxWidth = SystemParameters.WorkArea.Width + 14;

            MaximizeButton.Content = "❐";
            MaximizeButton.ToolTip = "Restaurar";
            RootBorder.BorderThickness = new Thickness(0);
        }
        else
        {
            MaxHeight = double.PositiveInfinity;
            MaxWidth = double.PositiveInfinity;

            MaximizeButton.Content = "▢";
            MaximizeButton.ToolTip = "Maximizar";
            RootBorder.BorderThickness = new Thickness(1);
        }
    }
}