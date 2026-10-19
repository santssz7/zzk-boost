namespace FpsLatencyPanel.Core.Tweaks.Mouse;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class MouseAccelerationTweak : ITweak
{
    private readonly ISystemParametersService _spi;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation RegMirror = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "MouseThreshold1", true);

    private static readonly RegLocation RegMirror2 = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "MouseThreshold2", true);

    private static readonly RegLocation RegAccel = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "MouseSpeed", true);

    public MouseAccelerationTweak(ISystemParametersService spi, IBackupManager backup, ILogger log)
    {
        _spi = spi; _backup = backup; _log = log;
    }

    public string Id => "mouse.acceleration";
    public string Name => "Desligar Melhorar precisao do ponteiro";
    public TweakCategory Category => TweakCategory.Mouse;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Desliga a aceleracao de ponteiro do Windows. Movimento do mouse passa a ser " +
        "linear em relacao ao deslocamento fisico. Jogos com RAW INPUT ignoram esta " +
        "configuracao - o ganho e real apenas em jogos/menus que usam WM_MOUSEMOVE.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Painel de Controle -> Mouse -> Opcoes de Ponteiro.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var p = _spi.GetMouseParams();
        if (p is null) return Task.FromResult(TweakState.Desconhecido("SPI_GETMOUSE falhou."));
        return Task.FromResult(p.Value.accel == 0
            ? TweakState.Aplicado
            : TweakState.NaoAplicado);
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var p = _spi.GetMouseParams();
        if (p is null)
            return TweakResult.Fail("Nao foi possivel ler o estado atual.");

        var before = $"{p.Value.t1},{p.Value.t2},{p.Value.accel}";

        await _backup.SaveAsync(Id, "spi", before, "spi-triple", ct);
        var mirrorT1 = ReadMirror(RegMirror);
        var mirrorT2 = ReadMirror(RegMirror2);
        var mirrorAcc = ReadMirror(RegAccel);
        await _backup.SaveAsync(Id, "reg.t1", mirrorT1, "string", ct);
        await _backup.SaveAsync(Id, "reg.t2", mirrorT2, "string", ct);
        await _backup.SaveAsync(Id, "reg.accel", mirrorAcc, "string", ct);

        var ok = _spi.SetMouseParams(p.Value.t1, p.Value.t2, 0);

        if (!ok)
            return TweakResult.Fail("SPI_SETMOUSE falhou.", before: before);

        var after = _spi.GetMouseParams();
        var afterStr = after is null ? "?" : $"{after.Value.t1},{after.Value.t2},{after.Value.accel}";
        _log.Info($"Tweak:{Id}", "Aceleracao desligada.", before, afterStr);
        return TweakResult.Ok("Aceleracao desligada.", before, afterStr);
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var spi = await _backup.LoadAsync(Id, "spi", ct);
        if (spi is null)
        {
            var okDefault = _spi.SetMouseParams(6, 10, 1);
            return okDefault
                ? TweakResult.Ok("Sem backup. Aplicado padrao do Windows (6,10,1).")
                : TweakResult.Fail("Sem backup e SPI_SETMOUSE falhou.");
        }

        var parts = spi.Value.Split(',');
        if (parts.Length != 3 ||
            !int.TryParse(parts[0], out var t1) ||
            !int.TryParse(parts[1], out var t2) ||
            !int.TryParse(parts[2], out var accel))
        {
            return TweakResult.Fail("Backup SPI corrompido.");
        }

        var ok2 = _spi.SetMouseParams(t1, t2, accel);
        if (!ok2) return TweakResult.Fail("Falha ao restaurar valores originais.");

        return TweakResult.Ok("Restaurado.", before: "accel=0", after: $"accel={accel}");
    }

    private static string ReadMirror(RegLocation loc)
    {
        try
        {
            using var key = Microsoft.Win32.Registry.CurrentUser.OpenSubKey(loc.SubKey);
            return key?.GetValue(loc.ValueName!)?.ToString() ?? "<ausente>";
        }
        catch { return "<erro>"; }
    }
}