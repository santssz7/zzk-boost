namespace FpsLatencyPanel.Core.Abstractions;

public enum LogLevel { Info, Warn, Error }

public sealed record LogEntry(
    DateTimeOffset TimestampUtc,
    LogLevel Level,
    string Source,
    string Message,
    string? ValueBefore = null,
    string? ValueAfter  = null,
    string? Exception   = null);

public interface ILogger
{
    void Write(LogEntry entry);
    void Info(string source, string message, string? before = null, string? after = null);
    void Warn(string source, string message, string? before = null, string? after = null);
    void Error(string source, string message, Exception? ex = null, string? before = null);
    IReadOnlyList<LogEntry> Recent(int max = 500);
    string LogFilePath { get; }
}