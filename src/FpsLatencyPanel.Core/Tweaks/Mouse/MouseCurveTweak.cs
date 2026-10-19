namespace FpsLatencyPanel.Core.Tweaks.Mouse;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class MouseCurveTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation XCurve = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "SmoothMouseXCurve", true);
    private static readonly RegLocation YCurve = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "SmoothMouseYCurve", true);

    private static readonly byte[] DefaultX = new byte[]
    {
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0xC0,0xCC,0x0C,0x00,0x00,0x00,0x00,0x00,
        0x80,0x99,0x19,0x00,0x00,0x00,0x00,0x00,
        0x40,0x66,0x26,0x00,0x00,0x00,0x00,0x00,
        0x00,0x33,0x33,0x00,0x00,0x00,0x00,0x00
    };

    private static readonly byte[] DefaultY = new byte[]
    {
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x38,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x70,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0xA8,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0xE0,0x00,0x00,0x00,0x00,0x00
    };

    public MouseCurveTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "mouse.curve";
    public string Name => "Restaurar curvas SmoothMouseX/Y padrao";
    public TweakCategory Category => TweakCategory.Mouse;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Restaura SmoothMouseXCurve e SmoothMouseYCurve para os valores originais. " +
        "Ferramentas antigas de tweak substituiam essas curvas e o resultado ficava torto.";

    public string HowToUndo =>
        "Reverter pelo painel restaura o que estava antes.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var x = _reg.ReadValue(XCurve) as byte[];
        var y = _reg.ReadValue(YCurve) as byte[];

        if (x is null || y is null)
            return Task.FromResult(TweakState.Desconhecido("Curvas ausentes no registro."));

        bool xOk = x.Length == DefaultX.Length && x.AsSpan().SequenceEqual(DefaultX);
        bool yOk = y.Length == DefaultY.Length && y.AsSpan().SequenceEqual(DefaultY);

        if (xOk && yOk) return Task.FromResult(TweakState.Aplicado);
        if (!xOk && !yOk) return Task.FromResult(TweakState.NaoAplicado);
        return Task.FromResult(TweakState.Parcial("Apenas uma das curvas esta fora do padrao."));
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var xb = _reg.ReadValue(XCurve) as byte[];
        var yb = _reg.ReadValue(YCurve) as byte[];

        await _backup.SaveAsync(Id, "x", xb is null ? "<ausente>" : Convert.ToHexString(xb), "bytes", ct);
        await _backup.SaveAsync(Id, "y", yb is null ? "<ausente>" : Convert.ToHexString(yb), "bytes", ct);

        _reg.WriteValue(XCurve, DefaultX, RegistryValueKind.Binary);
        _reg.WriteValue(YCurve, DefaultY, RegistryValueKind.Binary);

        _log.Info($"Tweak:{Id}", "Curvas restauradas ao padrao.");
        return TweakResult.Ok("Curvas restauradas ao padrao do Windows.");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var x = await _backup.LoadAsync(Id, "x", ct);
        var y = await _backup.LoadAsync(Id, "y", ct);

        RestoreCurve(XCurve, x);
        RestoreCurve(YCurve, y);

        _log.Info($"Tweak:{Id}", "Curvas revertidas.");
        return TweakResult.Ok("Curvas revertidas.");
    }

    private void RestoreCurve(RegLocation loc, BackupEntry? entry)
    {
        if (entry is null || entry.Value == "<ausente>")
        {
            _reg.DeleteValue(loc);
            return;
        }
        try
        {
            var bytes = Convert.FromHexString(entry.Value);
            _reg.WriteValue(loc, bytes, RegistryValueKind.Binary);
        }
        catch (Exception ex)
        {
            _log.Error($"Tweak:{Id}", "Falha ao restaurar curva.", ex);
        }
    }
}