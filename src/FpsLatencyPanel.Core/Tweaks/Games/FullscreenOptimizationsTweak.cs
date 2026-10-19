namespace FpsLatencyPanel.Core.Tweaks.Games;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class FullscreenOptimizationsTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private const string SubKey = @"Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers";
    private const string FlagValue = "~ DISABLEDXMAXIMIZEDWINDOWEDMODE";

    public IList<string> Targets { get; } = new List<string>();

    public FullscreenOptimizationsTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "games.fsopt";
    public string Name => "Desativar otimizacoes de tela cheia (por executavel)";
    public TweakCategory Category => TweakCategory.Games;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Desativa o FSO do Windows para os executaveis escolhidos. Faz o jogo usar " +
        "tela cheia EXCLUSIVA de verdade. Voce precisa escolher os .exe.";

    public string HowToUndo =>
        "Reverter pelo painel remove o flag do registro.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        if (Targets.Count == 0)
            return Task.FromResult(TweakState.NaoAplicavel);

        int applied = 0;
        foreach (var t in Targets)
        {
            var loc = new RegLocation(Hive.CurrentUser, SubKey, t, true);
            var v = _reg.ReadValue(loc)?.ToString();
            if (v is not null && v.Contains("DISABLEDXMAXIMIZEDWINDOWEDMODE", StringComparison.OrdinalIgnoreCase))
                applied++;
        }

        if (applied == 0)             return Task.FromResult(TweakState.NaoAplicado);
        if (applied == Targets.Count) return Task.FromResult(TweakState.Aplicado);
        return Task.FromResult(TweakState.Parcial($"{applied}/{Targets.Count} executaveis com flag."));
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        if (Targets.Count == 0)
            return TweakResult.Fail("Nenhum executavel escolhido.");

        int ok = 0;
        foreach (var t in Targets)
        {
            var loc = new RegLocation(Hive.CurrentUser, SubKey, t, true);
            var before = _reg.ReadValue(loc)?.ToString() ?? "<ausente>";
            await _backup.SaveAsync(Id, "exe:" + t, before, "REG_SZ", ct);

            try
            {
                _reg.WriteValue(loc, FlagValue, RegistryValueKind.String);
                ok++;
            }
            catch (Exception ex)
            {
                _log.Error($"Tweak:{Id}", $"Falha em {t}.", ex);
            }
        }

        return ok == Targets.Count
            ? TweakResult.Ok($"Aplicado em {ok} executaveis. Feche e reabra o jogo.")
            : TweakResult.Fail($"Aplicado em {ok} de {Targets.Count} executaveis.");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        if (Targets.Count == 0)
            return TweakResult.Ok("Nada a reverter.");

        int ok = 0;
        foreach (var t in Targets)
        {
            var loc = new RegLocation(Hive.CurrentUser, SubKey, t, true);
            var b = await _backup.LoadAsync(Id, "exe:" + t, ct);

            try
            {
                if (b is null || b.Value == "<ausente>")
                    _reg.DeleteValue(loc);
                else
                    _reg.WriteValue(loc, b.Value, RegistryValueKind.String);
                ok++;
            }
            catch (Exception ex)
            {
                _log.Error($"Tweak:{Id}", $"Falha ao reverter {t}.", ex);
            }
        }

        return ok == Targets.Count
            ? TweakResult.Ok($"Revertido em {ok} executaveis.")
            : TweakResult.Fail($"Revertido em {ok} de {Targets.Count}.");
    }
}