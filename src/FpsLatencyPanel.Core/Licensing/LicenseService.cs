namespace FpsLatencyPanel.Core.Licensing;

using System.Text;
using FpsLatencyPanel.Core.Abstractions;

public sealed class LicenseService : ILicenseService
{
    private readonly ILogger _log;
    private readonly string _path;

    public LicenseService(ILogger log, string? baseDir = null)
    {
        _log = log;
        var dir = baseDir ?? Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "FpsLatencyPanel");
        Directory.CreateDirectory(dir);
        _path = Path.Combine(dir, "license.dat");
    }

    public string LicenseFilePath => _path;

    public string GetMachineId() => MachineFingerprint.GetMachineId();

    public LicenseInfo Activate(string key)
    {
        var machineId = GetMachineId();
        var info = LicenseValidator.Validate(key, machineId);

        if (info.Status == LicenseStatus.Valid)
        {
            try
            {
                File.WriteAllText(_path, key.Trim(), Encoding.UTF8);
                _log.Info("License", $"Licenca ativada para {info.CustomerName ?? "-"}.");
            }
            catch (Exception ex)
            {
                _log.Error("License", "Falha ao salvar licenca.", ex);
                return new LicenseInfo(LicenseStatus.Corrupted, info.CustomerName, info.CustomerEmail,
                    info.ExpiresAtUtc, info.MachineId, "Licenca valida, mas nao foi possivel salvar: " + ex.Message);
            }
        }
        else
        {
            _log.Warn("License", $"Ativacao rejeitada: {info.Status} - {info.Message}");
        }

        return info;
    }

    public LicenseInfo GetCurrentStatus()
    {
        if (!File.Exists(_path))
            return new LicenseInfo(LicenseStatus.Missing, null, null, null, GetMachineId(),
                "Nenhuma licenca ativada.");

        string key;
        try { key = File.ReadAllText(_path).Trim(); }
        catch (Exception ex)
        {
            _log.Error("License", "Falha ao ler licenca.", ex);
            return new LicenseInfo(LicenseStatus.Corrupted, null, null, null, GetMachineId(),
                "Falha ao ler arquivo de licenca.");
        }

        return LicenseValidator.Validate(key, GetMachineId());
    }

    public void Deactivate()
    {
        try
        {
            if (File.Exists(_path)) File.Delete(_path);
            _log.Info("License", "Licenca removida.");
        }
        catch (Exception ex)
        {
            _log.Error("License", "Falha ao remover licenca.", ex);
        }
    }
}