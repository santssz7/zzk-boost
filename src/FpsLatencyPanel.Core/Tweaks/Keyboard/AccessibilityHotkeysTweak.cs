namespace FpsLatencyPanel.Core.Tweaks.Keyboard;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class AccessibilityHotkeysTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation Sticky = new(
        Hive.CurrentUser, @"Control Panel\Accessibility\StickyKeys", "Flags", true);
    private static readonly RegLocation Filter = new(
        Hive.CurrentUser, @"Control Panel\Accessibility\Keyboard Response", "Flags", true);
    private static readonly RegLocation Toggle = new(
        Hive.CurrentUser, @"Control Panel\Accessibility\ToggleKeys", "Flags", true);

    public AccessibilityHotkeysTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "kbd.accessibility";
    public string Name => "Desativar atalhos de acessibilidade";
    public TweakCategory Category => TweakCategory.Keyboard;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Desliga os gatilhos de teclado dos recursos de acessibilidade: Sticky Keys " +
        "(Shift 5x), Filter Keys (Shift direito 8s) e Toggle Keys (Num Lock 5s).";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Configuracoes -> Acessibilidade -> Teclado.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var s = ReadFlags(Sticky);
        var f = ReadFlags(Filter);
        var t = ReadFlags(Toggle);

        if (s is null || f is null || t is null)
            return Task.FromResult(TweakState.Desconhecido("Nao foi possivel ler Flags."));

        bool stickyOff = (s.Value & 0x01) == 0;
        bool filterOff = (f.Value & 0x01) == 0;
        bool toggleOff = (t.Value & 0x01) == 0;

        if (stickyOff && filterOff && toggleOff) return Task.FromResult(TweakState.Aplicado);
        if (!stickyOff && !filterOff && !toggleOff) return Task.FromResult(TweakState.NaoAplicado);
        return Task.FromResult(TweakState.Parcial("Apenas parte dos atalhos esta desligada."));
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var s = ReadFlags(Sticky) ?? 510;
        var f = ReadFlags(Filter) ?? 126;
        var t = ReadFlags(Toggle) ?? 62;

        await _backup.SaveAsync(Id, "sticky", s.ToString(), "REG_SZ", ct);
        await _backup.SaveAsync(Id, "filter", f.ToString(), "REG_SZ", ct);
        await _backup.SaveAsync(Id, "toggle", t.ToString(), "REG_SZ", ct);

        try
        {
            WriteFlags(Sticky, s & ~0x01);
            WriteFlags(Filter, f & ~0x01);
            WriteFlags(Toggle, t & ~0x01);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao desativar atalhos.", ex);
        }

        _log.Info($"Tweak:{Id}", "Atalhos de acessibilidade desativados.");
        return TweakResult.Ok("Atalhos desativados.", $"{s},{f},{t}", $"{s & ~0x01},{f & ~0x01},{t & ~0x01}");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var sB = await _backup.LoadAsync(Id, "sticky", ct);
        var fB = await _backup.LoadAsync(Id, "filter", ct);
        var tB = await _backup.LoadAsync(Id, "toggle", ct);

        try
        {
            if (sB is not null && int.TryParse(sB.Value, out var s)) WriteFlags(Sticky, s);
            if (fB is not null && int.TryParse(fB.Value, out var f)) WriteFlags(Filter, f);
            if (tB is not null && int.TryParse(tB.Value, out var t)) WriteFlags(Toggle, t);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao restaurar atalhos.", ex);
        }

        _log.Info($"Tweak:{Id}", "Atalhos de acessibilidade restaurados.");
        return TweakResult.Ok("Restaurado.");
    }

    private int? ReadFlags(RegLocation loc)
    {
        var raw = _reg.ReadValue(loc);
        if (raw is null) return null;
        return int.TryParse(raw.ToString(), out var v) ? v : null;
    }

    private void WriteFlags(RegLocation loc, int value)
    {
        _reg.WriteValue(loc, value.ToString(), RegistryValueKind.String);
    }
}