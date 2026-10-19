namespace FpsLatencyPanel.Core.Infrastructure;

using FpsLatencyPanel.Core.Abstractions;

public interface ISystemParametersService
{
    (int t1, int t2, int accel)? GetMouseParams();
    bool SetMouseParams(int t1, int t2, int accel);
    int? GetMouseSpeed();
    bool SetMouseSpeed(int speed);
    void BroadcastSettingChange();
}

public sealed class SystemParametersService : ISystemParametersService
{
    private readonly ILogger _log;
    public SystemParametersService(ILogger log) => _log = log;

    public (int t1, int t2, int accel)? GetMouseParams()
    {
        try
        {
            var buf = new int[3];
            if (!NativeMethods.SystemParametersInfoArray(NativeMethods.SPI_GETMOUSE, 0, buf, 0))
            {
                _log.Warn("SystemParameters", "SPI_GETMOUSE falhou.");
                return null;
            }
            return (buf[0], buf[1], buf[2]);
        }
        catch (Exception ex)
        {
            _log.Error("SystemParameters", "Excecao em GetMouseParams.", ex);
            return null;
        }
    }

    public bool SetMouseParams(int t1, int t2, int accel)
    {
        try
        {
            var buf = new[] { t1, t2, accel };
            var ok = NativeMethods.SystemParametersInfoArray(
                NativeMethods.SPI_SETMOUSE, 0, buf,
                NativeMethods.SPIF_UPDATEINIFILE | NativeMethods.SPIF_SENDCHANGE);
            if (!ok)
                _log.Warn("SystemParameters", "SPI_SETMOUSE retornou false.");
            return ok;
        }
        catch (Exception ex)
        {
            _log.Error("SystemParameters", "Excecao em SetMouseParams.", ex);
            return false;
        }
    }

    public int? GetMouseSpeed()
    {
        try
        {
            int speed = 0;
            if (!NativeMethods.SystemParametersInfoInt(NativeMethods.SPI_GETMOUSESPEED, 0, ref speed, 0))
            {
                _log.Warn("SystemParameters", "SPI_GETMOUSESPEED falhou.");
                return null;
            }
            return speed;
        }
        catch (Exception ex)
        {
            _log.Error("SystemParameters", "Excecao em GetMouseSpeed.", ex);
            return null;
        }
    }

    public bool SetMouseSpeed(int speed)
    {
        try
        {
            var ok = NativeMethods.SystemParametersInfo(
                NativeMethods.SPI_SETMOUSESPEED, (uint)speed, IntPtr.Zero,
                NativeMethods.SPIF_UPDATEINIFILE | NativeMethods.SPIF_SENDCHANGE);
            if (!ok)
                _log.Warn("SystemParameters", $"SPI_SETMOUSESPEED({speed}) retornou false.");
            return ok;
        }
        catch (Exception ex)
        {
            _log.Error("SystemParameters", "Excecao em SetMouseSpeed.", ex);
            return false;
        }
    }

    public void BroadcastSettingChange() { }
}