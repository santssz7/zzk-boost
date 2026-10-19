namespace FpsLatencyPanel.App.Services;

using FpsLatencyPanel.Core.Licensing;

public interface ILicenseGate
{
    bool EnsureLicensed(string actionName);
}

public sealed class LicenseGate : ILicenseGate
{
    private readonly ILicenseService _license;
    private readonly IDialogService _dialog;

    public LicenseGate(ILicenseService license, IDialogService dialog)
    {
        _license = license; _dialog = dialog;
    }

    public bool EnsureLicensed(string actionName)
    {
        var info = _license.GetCurrentStatus();
        if (info.Status == LicenseStatus.Valid) return true;

        var msg = $"Esta acao (\"{actionName}\") exige uma licenca valida.\n\n" +
                  $"Status: {info.Message}\n\n" +
                  "Abra a aba Licenca para ativar.";
        _dialog.Error("Licenca necessaria", msg);
        return false;
    }
}