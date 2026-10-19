namespace FpsLatencyPanel.App.Services;

using System.Linq;
using System.Windows;
using FpsLatencyPanel.App.Views;

public interface IDialogService
{
    bool Confirm(string title, string message);
    void Info(string title, string message);
    void Error(string title, string message);
}

public sealed class DialogService : IDialogService
{
    private static Window? GetOwner()
    {
        // Pega a janela ativa no momento (MainWindow, ActivationWindow, ou nenhuma)
        return Application.Current?.Windows
            .OfType<Window>()
            .FirstOrDefault(w => w.IsActive)
            ?? Application.Current?.MainWindow;
    }

    public bool Confirm(string title, string message)
    {
        var dlg = new ConfirmDialog(title, message, DialogKind.Question);
        var owner = GetOwner();
        if (owner is not null && owner.IsVisible) dlg.Owner = owner;
        return dlg.ShowDialog() == true;
    }

    public void Info(string title, string message)
    {
        var dlg = new ConfirmDialog(title, message, DialogKind.Info, showCancel: false);
        var owner = GetOwner();
        if (owner is not null && owner.IsVisible) dlg.Owner = owner;
        dlg.ShowDialog();
    }

    public void Error(string title, string message)
    {
        var dlg = new ConfirmDialog(title, message, DialogKind.Error, showCancel: false);
        var owner = GetOwner();
        if (owner is not null && owner.IsVisible) dlg.Owner = owner;
        dlg.ShowDialog();
    }
}