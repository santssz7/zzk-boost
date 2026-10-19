namespace FpsLatencyPanel.Core.Abstractions;

public sealed record TweakResult(
    bool Success,
    string Message,
    string? ValueBefore = null,
    string? ValueAfter  = null,
    Exception? Error    = null)
{
    public static TweakResult Ok(string msg, string? before = null, string? after = null)
        => new(true, msg, before, after);

    public static TweakResult Fail(string msg, Exception? ex = null, string? before = null)
        => new(false, msg, before, null, ex);

    public static TweakResult Skipped(string msg, string? before = null)
        => new(true, msg, before, before);
}