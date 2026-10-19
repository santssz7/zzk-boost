namespace FpsLatencyPanel.App.ViewModels;

using System.Windows.Input;
using System.Windows.Media;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Licensing;

public sealed class LicenseViewModel : ViewModelBase
{
    private readonly ILicenseService _license;
    private readonly IDialogService _dialog;

    public ICommand ActivateCommand { get; }
    public ICommand DeactivateCommand { get; }
    public ICommand CopyMachineIdCommand { get; }

    private string _keyInput = "";
    public string KeyInput { get => _keyInput; set => Set(ref _keyInput, value); }

    private string _machineId = "";
    public string MachineId { get => _machineId; set => Set(ref _machineId, value); }

    private LicenseStatus _status = LicenseStatus.Missing;
    public LicenseStatus Status
    {
        get => _status;
        set
        {
            if (Set(ref _status, value))
            {
                OnPropertyChanged(nameof(StatusText));
                OnPropertyChanged(nameof(StatusBrush));
            }
        }
    }

    private string _statusMessage = "";
    public string StatusMessage { get => _statusMessage; set => Set(ref _statusMessage, value); }

    private string _customerName = "";
    public string CustomerName { get => _customerName; set => Set(ref _customerName, value); }

    private string _expiresText = "";
    public string ExpiresText { get => _expiresText; set => Set(ref _expiresText, value); }

    public string StatusText => Status switch
    {
        LicenseStatus.Valid            => "Licença ativa",
        LicenseStatus.Missing          => "Não ativada",
        LicenseStatus.Expired          => "Expirada",
        LicenseStatus.HardwareMismatch => "Outro computador",
        LicenseStatus.InvalidSignature => "Key inválida",
        LicenseStatus.Corrupted        => "Arquivo corrompido",
        _ => "-"
    };

    public Brush StatusBrush => Status switch
    {
        LicenseStatus.Valid => new SolidColorBrush(Color.FromRgb(0x3E, 0xD1, 0x7B)), // verde
        LicenseStatus.Missing => new SolidColorBrush(Color.FromRgb(0x9A, 0xA6, 0xAF)), // cinza
        _ => new SolidColorBrush(Color.FromRgb(0xE5, 0x48, 0x4D)) // vermelho
    };

    public LicenseViewModel(ILicenseService license, IDialogService dialog)
    {
        _license = license;
        _dialog = dialog;
        ActivateCommand = new RelayCommand(Activate);
        DeactivateCommand = new RelayCommand(Deactivate);
        CopyMachineIdCommand = new RelayCommand(CopyMachineId);
        Refresh();
    }

    public void Refresh()
    {
        MachineId = _license.GetMachineId();
        var info = _license.GetCurrentStatus();
        Status = info.Status;
        StatusMessage = info.Message;
        CustomerName = info.CustomerName ?? "-";
        ExpiresText = info.ExpiresAtUtc is null
            ? "Sem prazo de expiração"
            : $"Expira em {info.ExpiresAtUtc.Value.ToLocalTime():dd/MM/yyyy}";
    }

    private void Activate()
    {
        if (string.IsNullOrWhiteSpace(KeyInput))
        {
            _dialog.Error("Licença", "Cole a key recebida.");
            return;
        }

        var info = _license.Activate(KeyInput.Trim());
        Refresh();

        if (info.Status == LicenseStatus.Valid)
        {
            _dialog.Info("Licença ativada", $"Obrigado, {info.CustomerName}!\n\n{info.Message}");
            KeyInput = "";
        }
        else
        {
            _dialog.Error("Falha na ativação", info.Message);
        }
    }

    private void Deactivate()
    {
        if (!_dialog.Confirm("Desativar licença",
            "Isso remove a licença deste computador. Você poderá ativá-la em outro PC depois.\n\nContinuar?"))
            return;

        _license.Deactivate();
        Refresh();
        _dialog.Info("Licença", "Licença removida.");
    }

    private void CopyMachineId()
    {
        try
        {
            System.Windows.Clipboard.SetText(MachineId);
            _dialog.Info("Copiado", "Machine ID copiado. Envie para o vendedor.");
        }
        catch { }
    }
}