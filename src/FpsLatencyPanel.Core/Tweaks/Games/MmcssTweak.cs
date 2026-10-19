namespace FpsLatencyPanel.Core.Tweaks.Games;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class MmcssTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private const string SubKey =
        @"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games";

    private static readonly RegLocation Prio  = new(Hive.LocalMachine, SubKey, "Priority", true);
    private static readonly RegLocation Sched = new(Hive.LocalMachine, SubKey, "Scheduling Category", true);
    private static readonly RegLocation Sfio  = new(Hive.LocalMachine, SubKey, "SFIO Priority", true);

    private const int    TargetPrio  = 6;
    private const string TargetSched = "High";
    private const string TargetSfio  = "High";

    public MmcssTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "games.mmcss";
    public string Name => "MMCSS: prioridade alta no perfil Games";
    public TweakCategory Category => TweakCategory.Games;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => true;

    public string Description =>
        "Ajusta o perfil MMCSS Games para Priority=6, Scheduling Category=High e " +
        "SFIO Priority=High. Requer REINICIO para efeito.";

    public string HowToUndo =>
        "Reverter pelo painel (e reiniciar).";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var prio  = ReadInt(Prio);
        var sched = ReadString(Sched);
        var sfio  = ReadString(Sfio);

        if (prio is null || sched is null || sfio is null)
            return Task.FromResult(TweakState.Desconhecido("Valores MMCSS ausentes."));

        bool ok = prio.Value == TargetPrio
               && string.Equals(sched, TargetSched, StringComparison.OrdinalIgnoreCase)
               && string.Equals(sfio,  TargetSfio,  StringComparison.OrdinalIgnoreCase);

        if (ok) return Task.FromResult(TweakState.Aplicado);

        bool any = prio.Value == TargetPrio
                || string.Equals(sched, TargetSched, StringComparison.OrdinalIgnoreCase)
                || string.Equals(sfio,  TargetSfio,  StringComparison.OrdinalIgnoreCase);

        return Task.FromResult(any
            ? TweakState.Parcial("Parte dos valores ja esta no alvo.")
            : TweakState.NaoAplicado);
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var prioBefore  = _reg.ReadValue(Prio)?.ToString()  ?? "<ausente>";
        var schedBefore = _reg.ReadValue(Sched)?.ToString() ?? "<ausente>";
        var sfioBefore  = _reg.ReadValue(Sfio)?.ToString()  ?? "<ausente>";

        await _backup.SaveAsync(Id, "prio",  prioBefore,  "REG_DWORD", ct);
        await _backup.SaveAsync(Id, "sched", schedBefore, "REG_SZ", ct);
        await _backup.SaveAsync(Id, "sfio",  sfioBefore,  "REG_SZ", ct);

        try
        {
            _reg.WriteValue(Prio,  TargetPrio,  RegistryValueKind.DWord);
            _reg.WriteValue(Sched, TargetSched, RegistryValueKind.String);
            _reg.WriteValue(Sfio,  TargetSfio,  RegistryValueKind.String);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao aplicar MMCSS. Painel precisa estar elevado.", ex);
        }

        _log.Info($"Tweak:{Id}", "MMCSS ajustado.");
        return TweakResult.Ok("MMCSS ajustado. Reinicie para efeito.",
            $"{prioBefore},{schedBefore},{sfioBefore}",
            $"{TargetPrio},{TargetSched},{TargetSfio}");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        await RestoreDword(Prio,  "prio",  defaultDword: 6);
        await RestoreString(Sched, "sched", defaultStr: "High");
        await RestoreString(Sfio,  "sfio",  defaultStr: "High");

        _log.Info($"Tweak:{Id}", "MMCSS revertido.");
        return TweakResult.Ok("MMCSS revertido. Reinicie para efeito.");
    }

    private int? ReadInt(RegLocation loc)
    {
        var v = _reg.ReadValue(loc);
        if (v is null) return null;
        try { return Convert.ToInt32(v); } catch { return null; }
    }

    private string? ReadString(RegLocation loc)
        => _reg.ReadValue(loc)?.ToString();

    private async Task RestoreDword(RegLocation loc, string key, int defaultDword)
    {
        var b = await _backup.LoadAsync(Id, key);
        var val = (b is null || b.Value == "<ausente>") ? defaultDword :
                  (int.TryParse(b.Value, out var v) ? v : defaultDword);
        _reg.WriteValue(loc, val, RegistryValueKind.DWord);
    }

    private async Task RestoreString(RegLocation loc, string key, string defaultStr)
    {
        var b = await _backup.LoadAsync(Id, key);
        var val = (b is null || b.Value == "<ausente>") ? defaultStr : b.Value;
        _reg.WriteValue(loc, val, RegistryValueKind.String);
    }
}