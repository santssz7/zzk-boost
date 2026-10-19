namespace FpsLatencyPanel.Core.Tweaks.Games;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class Win32PrioritySeparationTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation Loc = new(
        Hive.LocalMachine, @"SYSTEM\CurrentControlSet\Control\PriorityControl",
        "Win32PrioritySeparation", true);

    private const int TargetValue  = 0x26;
    private const int WindowsDefault = 0x02;

    public Win32PrioritySeparationTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "games.w32prio";
    public string Name => "Win32PrioritySeparation = 0x26";
    public TweakCategory Category => TweakCategory.Games;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Medio;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => true;

    public string Description =>
        "Define Win32PrioritySeparation = 0x26 (38), que da ao processo em primeiro " +
        "plano quantum curto e variavel. Risco MEDIO: afeta o escalonador global. " +
        "Requer reinicio.";

    public string HowToUndo =>
        "Reverter pelo painel (e reiniciar). Padrao do Windows desktop e 0x02.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var v = _reg.ReadValue(Loc);
        if (v is null) return Task.FromResult(TweakState.NaoAplicado);
        try
        {
            var iv = Convert.ToInt32(v);
            return Task.FromResult(iv == TargetValue ? TweakState.Aplicado : TweakState.NaoAplicado);
        }
        catch { return Task.FromResult(TweakState.Desconhecido("Valor nao numerico.")); }
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var before = _reg.ReadValue(Loc)?.ToString() ?? "<ausente>";
        await _backup.SaveAsync(Id, "value", before, "REG_DWORD", ct);

        try
        {
            _reg.WriteValue(Loc, TargetValue, RegistryValueKind.DWord);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao gravar. Painel precisa estar elevado.", ex, before);
        }

        _log.Info($"Tweak:{Id}", "Win32PrioritySeparation ajustado.", before, TargetValue.ToString());
        return TweakResult.Ok("Ajustado. Reinicie para efeito.", before, TargetValue.ToString());
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "value", ct);

        if (b is null || b.Value == "<ausente>")
        {
            _reg.WriteValue(Loc, WindowsDefault, RegistryValueKind.DWord);
            return TweakResult.Ok($"Sem backup. Aplicado padrao Windows ({WindowsDefault}). Reinicie.");
        }

        if (int.TryParse(b.Value, out var v))
        {
            _reg.WriteValue(Loc, v, RegistryValueKind.DWord);
            return TweakResult.Ok($"Restaurado para {v}. Reinicie.");
        }

        return TweakResult.Fail("Backup corrompido.");
    }
}