namespace FpsLatencyPanel.Core.Abstractions;

public enum TweakCategory
{
    Mouse,
    Keyboard,
    Power,
    Games,
    TimerResolution,
    Network,
    Cleanup,
    Startup
}

public enum ExpectedImpact
{
    Mensuravel,
    Marginal,
    Situacional
}

public enum RiskLevel
{
    Baixo,
    Medio,
    Alto
}

public enum TweakStateKind
{
    Aplicado,
    NaoAplicado,
    Parcial,
    Desconhecido,
    NaoAplicavel
}

public sealed record TweakState(TweakStateKind Kind, string Detalhe)
{
    public static readonly TweakState Aplicado     = new(TweakStateKind.Aplicado, "Ja aplicado.");
    public static readonly TweakState NaoAplicado  = new(TweakStateKind.NaoAplicado, "Nao aplicado.");
    public static readonly TweakState NaoAplicavel = new(TweakStateKind.NaoAplicavel, "Nao aplicavel neste sistema.");
    public static TweakState Desconhecido(string d) => new(TweakStateKind.Desconhecido, d);
    public static TweakState Parcial(string d)      => new(TweakStateKind.Parcial, d);
}

public interface ITweak
{
    string Id { get; }
    string Name { get; }
    TweakCategory Category { get; }
    ExpectedImpact Impact { get; }
    RiskLevel Risk { get; }
    bool AffectsLaptop { get; }
    bool RequiresReboot { get; }
    string Description { get; }
    string HowToUndo { get; }

    bool IncludeInRecommendedProfile => true;

    Task<TweakState> DetectAsync(CancellationToken ct = default);
    Task<TweakResult> ApplyAsync(CancellationToken ct = default);
    Task<TweakResult> RevertAsync(CancellationToken ct = default);
}