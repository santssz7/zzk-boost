namespace FpsLatencyPanel.Core.Engine;

using System.Text.Json;
using FpsLatencyPanel.Core.Abstractions;

public sealed class FileLogger : ILogger
{
    private readonly object _sync = new();
    private readonly List<LogEntry> _recent = new();
    private const int RecentCap = 1000;
    private readonly string _path;

    public FileLogger(string? baseDir = null)
    {
        var dir = baseDir ?? Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "FpsLatencyPanel", "logs");
        Directory.CreateDirectory(dir);
        _path = Path.Combine(dir, $"panel-{DateTime.Now:yyyyMMdd}.log");
    }

    public string LogFilePath => _path;

    public void Write(LogEntry entry)
    {
        lock (_sync)
        {
            _recent.Add(entry);
            if (_recent.Count > RecentCap) _recent.RemoveAt(0);

            try
            {
                var line = JsonSerializer.Serialize(entry) + Environment.NewLine;
                File.AppendAllText(_path, line);
            }
            catch { }
        }
    }

    public void Info(string source, string message, string? before = null, string? after = null)
        => Write(new LogEntry(DateTimeOffset.UtcNow, LogLevel.Info, source, message, before, after));

    public void Warn(string source, string message, string? before = null, string? after = null)
        => Write(new LogEntry(DateTimeOffset.UtcNow, LogLevel.Warn, source, message, before, after));

    public void Error(string source, string message, Exception? ex = null, string? before = null)
        => Write(new LogEntry(DateTimeOffset.UtcNow, LogLevel.Error, source, message, before, null, ex?.ToString()));

    public IReadOnlyList<LogEntry> Recent(int max = 500)
    {
        lock (_sync) return _recent.TakeLast(max).ToList();
    }
}