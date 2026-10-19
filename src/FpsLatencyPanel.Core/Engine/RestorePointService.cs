namespace FpsLatencyPanel.Core.Engine;

using System.Management;
using FpsLatencyPanel.Core.Abstractions;
using Microsoft.Win32;

public sealed class RestorePointService : IRestorePointService
{
    private readonly ILogger _log;
    public RestorePointService(ILogger log) => _log = log;

    public Task<bool> IsSystemRestoreEnabledAsync(CancellationToken ct = default)
    {
        return Task.Run(() =>
        {
            try
            {
                using var key = Registry.LocalMachine.OpenSubKey(
                    @"SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore");
                var disable = key?.GetValue("DisableSR")?.ToString();
                if (string.Equals(disable, "1")) return false;

                try
                {
                    using var searcher = new ManagementObjectSearcher(
                        @"\\.\root\default", "SELECT * FROM SystemRestore");
                    searcher.Get();
                }
                catch { }

                return true;
            }
            catch (Exception ex)
            {
                _log.Warn("RestorePointService", "Falha ao checar System Restore.", ex.Message);
                return false;
            }
        }, ct);
    }

    public Task<bool> TryCreateAsync(string description, CancellationToken ct = default)
    {
        return Task.Run(() =>
        {
            try
            {
                var scope = new ManagementScope(@"\\.\root\default");
                using var cls = new ManagementClass(scope, new ManagementPath("SystemRestore"), null);
                var inParams = cls.GetMethodParameters("CreateRestorePoint");
                inParams["Description"] = description;
                inParams["RestorePointType"] = 0;
                inParams["EventType"] = 100;

                var outParams = cls.InvokeMethod("CreateRestorePoint", inParams, null);
                var ret = Convert.ToInt32(outParams?["ReturnValue"] ?? -1);
                if (ret == 0) { _log.Info("RestorePointService", $"Ponto criado: {description}"); return true; }

                _log.Warn("RestorePointService", $"CreateRestorePoint retornou {ret}.");
                return false;
            }
            catch (Exception ex)
            {
                _log.Error("RestorePointService", "Falha ao criar ponto de restauracao.", ex);
                return false;
            }
        }, ct);
    }
}