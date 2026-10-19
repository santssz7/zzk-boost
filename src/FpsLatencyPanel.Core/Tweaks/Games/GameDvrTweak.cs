namespace FpsLatencyPanel.Core.Tweaks.Games;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class GameDvrTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation UserDvr = new(
        Hive.CurrentUser, @"System\GameConfigStore", "GameDVR_Enabled", true);

    private static readonly RegLocation PolicyDvr = new(
        Hive.LocalMachine, @"SOFTWARE\Policies\Microsoft\Windows\GameDVR", "AllowGameDVR", true);

    private static readonly RegLocation BgRecord = new(
        Hive.CurrentUser, @"Software\Microsoft\Windows\CurrentVersion\GameDVR", "AppCaptureEnabled", true);

    public GameDvrTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "games.dvr";
    public string Name => "Desligar Game DVR e captura em segundo plano";
    public TweakCategory Category => TweakCategory.Games;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Desliga a captura de video em segundo plano do Xbox Game Bar e do Game DVR. " +
        "Libera CPU, GPU e disco. Voce perde o botao de gravar os ultimos 30s.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Configuracoes -> Jogos -> Capturas.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var user = _reg.ReadValue(UserDvr);
        var bg   = _reg.ReadValue(BgRecord);
        var pol  = _reg.ReadValue(PolicyDvr);

        bool userOff = user is not null && Convert.ToInt32(user) == 0;
        bool bgOff   = bg   is not null && Convert.ToInt32(bg)   == 0;
        bool polOff  = pol  is not null && Convert.ToInt32(pol)  == 0;

        if (userOff && bgOff && polOff) return TweakState.Aplicado;
        if (!userOff && !bgOff) return TweakState.NaoAplicado;
        return TweakState.Parcial("Alguns valores ja estao desligados.");
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var uBefore = _reg.ReadValue(UserDvr)?.ToString() ?? "<ausente>";
        var bBefore = _reg.ReadValue(BgRecord)?.ToString() ?? "<ausente>";
        var pBefore = _reg.ReadValue(PolicyDvr)?.ToString() ?? "<ausente>";

        await _backup.SaveAsync(Id, "user", uBefore, "REG_DWORD", ct);
        await _backup.SaveAsync(Id, "bg",   bBefore, "REG_DWORD", ct);
        await _backup.SaveAsync(Id, "pol",  pBefore, "REG_DWORD", ct);
        await _backup.SaveAsync(Id, "polExisted", (_reg.KeyExists(PolicyDvr) ? "1" : "0"), "flag", ct);

        try
        {
            _reg.WriteValue(UserDvr, 0, RegistryValueKind.DWord);
            _reg.WriteValue(BgRecord, 0, RegistryValueKind.DWord);
            _reg.WriteValue(PolicyDvr, 0, RegistryValueKind.DWord);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao aplicar Game DVR.", ex, uBefore);
        }

        _log.Info($"Tweak:{Id}", "Game DVR desligado.");
        return TweakResult.Ok("Game DVR desligado.", $"{uBefore},{bBefore},{pBefore}", "0,0,0");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        await RestoreDword(UserDvr,  "user", defaultDword: 1);
        await RestoreDword(BgRecord, "bg",   defaultDword: 1);

        var polExisted = await _backup.LoadAsync(Id, "polExisted");
        if (polExisted?.Value == "1")
            await RestoreDword(PolicyDvr, "pol", defaultDword: 1);
        else
            _reg.DeleteValue(PolicyDvr);

        _log.Info($"Tweak:{Id}", "Game DVR revertido.");
        return TweakResult.Ok("Game DVR revertido.");
    }

    private async Task RestoreDword(RegLocation loc, string key, int defaultDword)
    {
        var b = await _backup.LoadAsync(Id, key);
        if (b is null || b.Value == "<ausente>")
        {
            _reg.WriteValue(loc, defaultDword, RegistryValueKind.DWord);
            return;
        }
        if (int.TryParse(b.Value, out var v))
            _reg.WriteValue(loc, v, RegistryValueKind.DWord);
    }
}