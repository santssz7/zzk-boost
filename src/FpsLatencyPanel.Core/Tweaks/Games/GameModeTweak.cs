namespace FpsLatencyPanel.Core.Tweaks.Games;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class GameModeTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation AutoGameMode = new(
        Hive.CurrentUser, @"Software\Microsoft\GameBar", "AutoGameModeEnabled", true);
    private static readonly RegLocation AllowAutoGameMode = new(
        Hive.CurrentUser, @"Software\Microsoft\GameBar", "AllowAutoGameMode", true);

    public GameModeTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "games.mode";
    public string Name => "Ativar Modo Jogo do Windows";
    public TweakCategory Category => TweakCategory.Games;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Liga o Modo Jogo nativo do Windows. Impacto MARGINAL: em alguns jogos ajuda " +
        "na consistencia de frametime; em outros, pode atrapalhar.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Configuracoes -> Jogos -> Modo Jogo.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var a = _reg.ReadValue(AutoGameMode);
        var b = _reg.ReadValue(AllowAutoGameMode);
        if (a is null || b is null) return Task.FromResult(TweakState.NaoAplicado);

        var av = Convert.ToInt32(a);
        var bv = Convert.ToInt32(b);
        if (av == 1 && bv == 1) return Task.FromResult(TweakState.Aplicado);
        if (av == 0 && bv == 0) return Task.FromResult(TweakState.NaoAplicado);
        return Task.FromResult(TweakState.Parcial("Apenas um dos dois valores esta ligado."));
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var aBefore = _reg.ReadValue(AutoGameMode)?.ToString() ?? "<ausente>";
        var bBefore = _reg.ReadValue(AllowAutoGameMode)?.ToString() ?? "<ausente>";

        await _backup.SaveAsync(Id, "auto", aBefore, "REG_DWORD", ct);
        await _backup.SaveAsync(Id, "allow", bBefore, "REG_DWORD", ct);

        try
        {
            _reg.WriteValue(AutoGameMode, 1, RegistryValueKind.DWord);
            _reg.WriteValue(AllowAutoGameMode, 1, RegistryValueKind.DWord);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao gravar Modo Jogo.", ex, aBefore);
        }

        _log.Info($"Tweak:{Id}", "Modo Jogo ligado.", $"{aBefore},{bBefore}", "1,1");
        return TweakResult.Ok("Modo Jogo ligado.", $"{aBefore},{bBefore}", "1,1");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        await RestoreOrDefault(AutoGameMode, "auto", defaultDword: 1);
        await RestoreOrDefault(AllowAutoGameMode, "allow", defaultDword: 1);

        _log.Info($"Tweak:{Id}", "Modo Jogo revertido.");
        return TweakResult.Ok("Modo Jogo revertido.");
    }

    private async Task RestoreOrDefault(RegLocation loc, string key, int defaultDword)
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