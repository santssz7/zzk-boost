# =====================================================================
# FPS Latency Panel — setup.ps1
# Gera toda a estrutura de arquivos do projeto na pasta C:\FpsPanel
# Execute uma vez. Não requer .NET instalado para gerar os arquivos.
# =====================================================================

$ErrorActionPreference = "Stop"
$root = "C:\FpsPanel"

function New-Dir([string]$path) {
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

function Write-File([string]$relativePath, [string]$content) {
    $full = Join-Path $root $relativePath
    $dir = Split-Path $full -Parent
    New-Dir $dir
    # Grava sem BOM, com UTF-8
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($full, $content, $utf8NoBom)
    Write-Host "  + $relativePath" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "=== FPS Latency Panel — setup ===" -ForegroundColor Cyan
Write-Host "Raiz: $root" -ForegroundColor Cyan
Write-Host ""

# ---- Estrutura de pastas ----
Write-Host "Criando pastas..." -ForegroundColor Yellow

$dirs = @(
    "$root",
    "$root\src",
    "$root\src\FpsLatencyPanel.Core",
    "$root\src\FpsLatencyPanel.Core\Abstractions",
    "$root\src\FpsLatencyPanel.Core\Models",
    "$root\src\FpsLatencyPanel.Core\Engine",
    "$root\src\FpsLatencyPanel.Core\Infrastructure",
    "$root\src\FpsLatencyPanel.Core\Licensing",
    "$root\src\FpsLatencyPanel.Core\Tweaks",
    "$root\src\FpsLatencyPanel.Core\Tweaks\Mouse",
    "$root\src\FpsLatencyPanel.Core\Tweaks\Keyboard",
    "$root\src\FpsLatencyPanel.Core\Tweaks\Power",
    "$root\src\FpsLatencyPanel.Core\Tweaks\Games",
    "$root\src\FpsLatencyPanel.Core\Tweaks\Network",
    "$root\src\FpsLatencyPanel.Core\Tweaks\Cleanup",
    "$root\src\FpsLatencyPanel.Core\Tweaks\Startup",
    "$root\src\FpsLatencyPanel.App",
    "$root\src\FpsLatencyPanel.App\Resources",
    "$root\src\FpsLatencyPanel.App\Converters",
    "$root\src\FpsLatencyPanel.App\Services",
    "$root\src\FpsLatencyPanel.App\ViewModels",
    "$root\src\FpsLatencyPanel.App\Views",
    "$root\src\FpsLatencyPanel.Tests",
    "$root\src\FpsLatencyPanel.Tests\Fakes",
    "$root\src\FpsLatencyPanel.Tests\Engine",
    "$root\src\FpsLatencyPanel.Tests\Tests",
    "$root\src\FpsLatencyPanel.Tests\Integration",
    "$root\tools",
    "$root\tools\KeyGen",
    "$root\build",
    "$root\docs",
    "$root\artifacts",
    "$root\artifacts\publish"
)
foreach ($d in $dirs) { New-Dir $d }
Write-Host "  OK." -ForegroundColor DarkGray
Write-Host ""

# =====================================================================
# BLOCO RAIZ
# =====================================================================

Write-Host "Bloco raiz..." -ForegroundColor Yellow

# ---- FpsLatencyPanel.sln ----
Write-File "FpsLatencyPanel.sln" @'
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio Version 17
VisualStudioVersion = 17.0.31903.59
MinimumVisualStudioVersion = 10.0.40219.1
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "FpsLatencyPanel.Core", "src\FpsLatencyPanel.Core\FpsLatencyPanel.Core.csproj", "{A1111111-1111-1111-1111-111111111111}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "FpsLatencyPanel.App", "src\FpsLatencyPanel.App\FpsLatencyPanel.App.csproj", "{A2222222-2222-2222-2222-222222222222}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "FpsLatencyPanel.Tests", "src\FpsLatencyPanel.Tests\FpsLatencyPanel.Tests.csproj", "{A3333333-3333-3333-3333-333333333333}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "KeyGen", "tools\KeyGen\KeyGen.csproj", "{A4444444-4444-4444-4444-444444444444}"
EndProject
Global
	GlobalSection(SolutionConfigurationPlatforms) = preSolution
		Debug|x64 = Debug|x64
		Release|x64 = Release|x64
	EndGlobalSection
	GlobalSection(ProjectConfigurationPlatforms) = postSolution
		{A1111111-1111-1111-1111-111111111111}.Debug|x64.ActiveCfg = Debug|x64
		{A1111111-1111-1111-1111-111111111111}.Debug|x64.Build.0 = Debug|x64
		{A1111111-1111-1111-1111-111111111111}.Release|x64.ActiveCfg = Release|x64
		{A1111111-1111-1111-1111-111111111111}.Release|x64.Build.0 = Release|x64
		{A2222222-2222-2222-2222-222222222222}.Debug|x64.ActiveCfg = Debug|x64
		{A2222222-2222-2222-2222-222222222222}.Debug|x64.Build.0 = Debug|x64
		{A2222222-2222-2222-2222-222222222222}.Release|x64.ActiveCfg = Release|x64
		{A2222222-2222-2222-2222-222222222222}.Release|x64.Build.0 = Release|x64
		{A3333333-3333-3333-3333-333333333333}.Debug|x64.ActiveCfg = Debug|x64
		{A3333333-3333-3333-3333-333333333333}.Debug|x64.Build.0 = Debug|x64
		{A3333333-3333-3333-3333-333333333333}.Release|x64.ActiveCfg = Release|x64
		{A3333333-3333-3333-3333-333333333333}.Release|x64.Build.0 = Release|x64
		{A4444444-4444-4444-4444-444444444444}.Debug|x64.ActiveCfg = Debug|Any CPU
		{A4444444-4444-4444-4444-444444444444}.Debug|x64.Build.0 = Debug|Any CPU
		{A4444444-4444-4444-4444-444444444444}.Release|x64.ActiveCfg = Release|Any CPU
		{A4444444-4444-4444-4444-444444444444}.Release|x64.Build.0 = Release|Any CPU
	EndGlobalSection
	GlobalSection(SolutionProperties) = preSolution
		HideSolutionNode = FALSE
	EndGlobalSection
EndGlobal
'@

# ---- Directory.Build.props ----
Write-File "Directory.Build.props" @'
<Project>
  <PropertyGroup>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <LangVersion>12</LangVersion>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <WarningsNotAsErrors>CS1591</WarningsNotAsErrors>
    <Version>0.1.0</Version>
    <Authors>FpsLatencyPanel</Authors>
    <Product>FPS Latency Panel</Product>
    <Copyright>© 2025</Copyright>
    <Platforms>x64</Platforms>
    <PlatformTarget>x64</PlatformTarget>
  </PropertyGroup>
</Project>
'@

# ---- FpsLatencyPanel.Core.csproj ----
Write-File "src\FpsLatencyPanel.Core\FpsLatencyPanel.Core.csproj" @'
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0-windows</TargetFramework>
    <RootNamespace>FpsLatencyPanel.Core</RootNamespace>
    <AssemblyName>FpsLatencyPanel.Core</AssemblyName>
    <RuntimeIdentifier>win-x64</RuntimeIdentifier>
    <EnableWindowsTargeting>true</EnableWindowsTargeting>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="System.Management" Version="8.0.0" />
  </ItemGroup>

</Project>
'@

# ---- FpsLatencyPanel.App.csproj ----
Write-File "src\FpsLatencyPanel.App\FpsLatencyPanel.App.csproj" @'
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <OutputType>WinExe</OutputType>
    <TargetFramework>net8.0-windows</TargetFramework>
    <UseWPF>true</UseWPF>
    <RootNamespace>FpsLatencyPanel.App</RootNamespace>
    <AssemblyName>FpsLatencyPanel</AssemblyName>
    <ApplicationManifest>app.manifest</ApplicationManifest>
    <RuntimeIdentifier>win-x64</RuntimeIdentifier>
    <EnableWindowsTargeting>true</EnableWindowsTargeting>

    <PublishSingleFile>true</PublishSingleFile>
    <SelfContained>true</SelfContained>
    <IncludeNativeLibrariesForSelfExtract>true</IncludeNativeLibrariesForSelfExtract>
    <EnableCompressionInSingleFile>true</EnableCompressionInSingleFile>
    <DebugType>none</DebugType>
    <DebugSymbols>false</DebugSymbols>
    <PublishTrimmed>false</PublishTrimmed>
    <PublishReadyToRun>false</PublishReadyToRun>
  </PropertyGroup>

  <ItemGroup>
    <ProjectReference Include="..\FpsLatencyPanel.Core\FpsLatencyPanel.Core.csproj" />
  </ItemGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.Extensions.DependencyInjection" Version="8.0.0" />
  </ItemGroup>

</Project>
'@

# ---- FpsLatencyPanel.Tests.csproj ----
Write-File "src\FpsLatencyPanel.Tests\FpsLatencyPanel.Tests.csproj" @'
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0-windows</TargetFramework>
    <IsPackable>false</IsPackable>
    <RuntimeIdentifier>win-x64</RuntimeIdentifier>
    <EnableWindowsTargeting>true</EnableWindowsTargeting>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.10.0" />
    <PackageReference Include="xunit" Version="2.9.0" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.8.2" />
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\FpsLatencyPanel.Core\FpsLatencyPanel.Core.csproj" />
  </ItemGroup>

</Project>
'@

# ---- KeyGen.csproj ----
Write-File "tools\KeyGen\KeyGen.csproj" @'
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <RootNamespace>FpsLatencyPanel.KeyGen</RootNamespace>
    <AssemblyName>KeyGen</AssemblyName>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <LangVersion>12</LangVersion>
  </PropertyGroup>

</Project>
'@

# ---- app.manifest ----
Write-File "src\FpsLatencyPanel.App\app.manifest" @'
<?xml version="1.0" encoding="utf-8"?>
<assembly manifestVersion="1.0" xmlns="urn:schemas-microsoft-com:asm.v1">
  <assemblyIdentity version="1.0.0.0" name="FpsLatencyPanel.app"/>

  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
    <security>
      <requestedPrivileges>
        <requestedExecutionLevel level="requireAdministrator" uiAccess="false" />
      </requestedPrivileges>
    </security>
  </trustInfo>

  <compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1">
    <application>
      <supportedOS Id="{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}" />
    </application>
  </compatibility>

  <application xmlns="urn:schemas-microsoft-com:asm.v3">
    <windowsSettings>
      <dpiAware xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">true/pm</dpiAware>
      <dpiAwareness xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">PerMonitorV2</dpiAwareness>
      <longPathAware xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">true</longPathAware>
    </windowsSettings>
  </application>
</assembly>
'@

Write-Host "  Bloco raiz OK." -ForegroundColor DarkGray
Write-Host ""# =====================================================================
# CORE — Abstractions
# =====================================================================

Write-Host "Core: Abstractions..." -ForegroundColor Yellow

# ---- ITweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Abstractions\ITweak.cs" @'
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
'@

# ---- TweakResult.cs ----
Write-File "src\FpsLatencyPanel.Core\Models\TweakResult.cs" @'
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
'@

# ---- IBackupManager.cs ----
Write-File "src\FpsLatencyPanel.Core\Abstractions\IBackupManager.cs" @'
namespace FpsLatencyPanel.Core.Abstractions;

public sealed record BackupEntry(
    string TweakId,
    string ValueKey,
    string Value,
    string ValueKind,
    DateTimeOffset CapturedAtUtc,
    string Sha256);

public interface IBackupManager
{
    Task SaveAsync(string tweakId, string valueKey, string value, string valueKind, CancellationToken ct = default);
    Task<BackupEntry?> LoadAsync(string tweakId, string valueKey, CancellationToken ct = default);
    Task<IReadOnlyList<BackupEntry>> LoadAllForAsync(string tweakId, CancellationToken ct = default);
    Task DeleteAsync(string tweakId, string valueKey, CancellationToken ct = default);
    Task<bool> HasAnyAsync(CancellationToken ct = default);
}
'@

# ---- ILogger.cs ----
Write-File "src\FpsLatencyPanel.Core\Abstractions\ILogger.cs" @'
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
'@

# ---- IEnvironmentDetector.cs ----
Write-File "src\FpsLatencyPanel.Core\Abstractions\IEnvironmentDetector.cs" @'
namespace FpsLatencyPanel.Core.Abstractions;

public enum DiskKind { Hdd, Ssd, Unknown }

public sealed record EnvironmentInfo(
    bool IsLaptop,
    bool HasBattery,
    DiskKind SystemDiskKind,
    string WindowsVersion,
    string WindowsBuild,
    string WindowsEdition,
    string GpuName,
    string SystemLanguage,
    bool IsSystemRestoreEnabled,
    string MachineName,
    int LogicalProcessors,
    ulong TotalRamBytes);

public interface IEnvironmentDetector
{
    Task<EnvironmentInfo> DetectAsync(CancellationToken ct = default);
}
'@

# ---- IRestorePointService.cs ----
Write-File "src\FpsLatencyPanel.Core\Abstractions\IRestorePointService.cs" @'
namespace FpsLatencyPanel.Core.Abstractions;

public interface IRestorePointService
{
    Task<bool> IsSystemRestoreEnabledAsync(CancellationToken ct = default);
    Task<bool> TryCreateAsync(string description, CancellationToken ct = default);
}
'@

# ---- IRegistryAccessor.cs ----
Write-File "src\FpsLatencyPanel.Core\Abstractions\IRegistryAccessor.cs" @'
namespace FpsLatencyPanel.Core.Abstractions;

using Microsoft.Win32;

public enum Hive { CurrentUser, LocalMachine }

public sealed record RegLocation(Hive Hive, string SubKey, string? ValueName, bool Is64BitView = true);

public interface IRegistryAccessor
{
    object? ReadValue(RegLocation loc);
    RegistryValueKind? GetValueKind(RegLocation loc);
    void WriteValue(RegLocation loc, object value, RegistryValueKind kind);
    void DeleteValue(RegLocation loc);
    bool KeyExists(RegLocation loc);
    string[] GetSubKeyNames(RegLocation loc);
    string[] GetValueNames(RegLocation loc);
}
'@

Write-Host "  Abstractions OK." -ForegroundColor DarkGray
Write-Host ""# =====================================================================
# CORE — Engine
# =====================================================================

Write-Host "Core: Engine..." -ForegroundColor Yellow

# ---- FileLogger.cs ----
Write-File "src\FpsLatencyPanel.Core\Engine\FileLogger.cs" @'
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
'@

# ---- BackupManager.cs ----
Write-File "src\FpsLatencyPanel.Core\Engine\BackupManager.cs" @'
namespace FpsLatencyPanel.Core.Engine;

using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using FpsLatencyPanel.Core.Abstractions;

public sealed class BackupManager : IBackupManager
{
    private readonly string _dir;
    private readonly ILogger _log;
    private static readonly JsonSerializerOptions JsonOpts = new() { WriteIndented = true };

    public BackupManager(ILogger log, string? baseDir = null)
    {
        _log = log;
        _dir = baseDir ?? Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "FpsLatencyPanel", "backups");
        Directory.CreateDirectory(_dir);
    }

    private string FileFor(string tweakId, string valueKey)
    {
        var safeTweak = Sanitize(tweakId);
        var safeKey   = Sanitize(valueKey);
        return Path.Combine(_dir, $"{safeTweak}__{safeKey}.json");
    }

    private static string Sanitize(string s)
    {
        var sb = new StringBuilder(s.Length);
        foreach (var c in s)
            sb.Append(char.IsLetterOrDigit(c) || c is '.' or '-' or '_' ? c : '_');
        return sb.ToString();
    }

    private static string Sha256Hex(string input)
    {
        var bytes = SHA256.HashData(Encoding.UTF8.GetBytes(input));
        return Convert.ToHexString(bytes).ToLowerInvariant();
    }

    public async Task SaveAsync(string tweakId, string valueKey, string value, string valueKind, CancellationToken ct = default)
    {
        var entry = new BackupEntry(
            tweakId, valueKey, value, valueKind,
            DateTimeOffset.UtcNow, Sha256Hex(value));

        var json = JsonSerializer.Serialize(entry, JsonOpts);
        await File.WriteAllTextAsync(FileFor(tweakId, valueKey), json, ct);
        _log.Info("BackupManager", $"Backup gravado: {tweakId}/{valueKey}", before: value);
    }

    public async Task<BackupEntry?> LoadAsync(string tweakId, string valueKey, CancellationToken ct = default)
    {
        var path = FileFor(tweakId, valueKey);
        if (!File.Exists(path)) return null;

        try
        {
            var json = await File.ReadAllTextAsync(path, ct);
            var entry = JsonSerializer.Deserialize<BackupEntry>(json, JsonOpts);
            if (entry is null) return null;

            var expected = Sha256Hex(entry.Value);
            if (!string.Equals(expected, entry.Sha256, StringComparison.OrdinalIgnoreCase))
            {
                _log.Error("BackupManager", $"Hash invalido no backup {tweakId}/{valueKey}.");
                return null;
            }
            return entry;
        }
        catch (Exception ex)
        {
            _log.Error("BackupManager", $"Falha ao ler backup {tweakId}/{valueKey}.", ex);
            return null;
        }
    }

    public async Task<IReadOnlyList<BackupEntry>> LoadAllForAsync(string tweakId, CancellationToken ct = default)
    {
        var safe = Sanitize(tweakId) + "__";
        var list = new List<BackupEntry>();
        foreach (var f in Directory.EnumerateFiles(_dir, safe + "*.json"))
        {
            try
            {
                var json = await File.ReadAllTextAsync(f, ct);
                var entry = JsonSerializer.Deserialize<BackupEntry>(json, JsonOpts);
                if (entry is not null) list.Add(entry);
            }
            catch (Exception ex)
            {
                _log.Error("BackupManager", $"Falha ao ler {f}.", ex);
            }
        }
        return list;
    }

    public Task DeleteAsync(string tweakId, string valueKey, CancellationToken ct = default)
    {
        var path = FileFor(tweakId, valueKey);
        if (File.Exists(path)) File.Delete(path);
        return Task.CompletedTask;
    }

    public Task<bool> HasAnyAsync(CancellationToken ct = default)
        => Task.FromResult(Directory.EnumerateFiles(_dir, "*.json").Any());
}
'@

# ---- EnvironmentDetector.cs ----
Write-File "src\FpsLatencyPanel.Core\Engine\EnvironmentDetector.cs" @'
namespace FpsLatencyPanel.Core.Engine;

using System.Management;
using FpsLatencyPanel.Core.Abstractions;
using Microsoft.Win32;

public sealed class EnvironmentDetector : IEnvironmentDetector
{
    private readonly ILogger _log;
    private readonly IRestorePointService _rp;

    public EnvironmentDetector(ILogger log, IRestorePointService rp)
    {
        _log = log;
        _rp = rp;
    }

    public async Task<EnvironmentInfo> DetectAsync(CancellationToken ct = default)
    {
        return await Task.Run(() =>
        {
            bool hasBattery = HasBattery();
            bool isLaptop   = hasBattery || IsLaptopByChassis();
            var (ver, build, edition) = WindowsVersionInfo();
            var gpu = GpuName();
            var lang = System.Globalization.CultureInfo.CurrentUICulture.Name;
            var disk = SystemDiskKind();
            var restore = false;
            try { restore = _rp.IsSystemRestoreEnabledAsync(ct).GetAwaiter().GetResult(); }
            catch (Exception ex) { _log.Warn("EnvironmentDetector", "Falha ao checar restore point.", ex.Message); }

            var info = new EnvironmentInfo(
                IsLaptop: isLaptop,
                HasBattery: hasBattery,
                SystemDiskKind: disk,
                WindowsVersion: ver,
                WindowsBuild: build,
                WindowsEdition: edition,
                GpuName: gpu,
                SystemLanguage: lang,
                IsSystemRestoreEnabled: restore,
                MachineName: Environment.MachineName,
                LogicalProcessors: Environment.ProcessorCount,
                TotalRamBytes: TotalRamBytes());

            _log.Info("EnvironmentDetector", "Ambiente detectado", after: info.ToString());
            return info;
        }, ct);
    }

    private static bool HasBattery()
    {
        try
        {
            using var searcher = new ManagementObjectSearcher("SELECT Name FROM Win32_Battery");
            return searcher.Get().Count > 0;
        }
        catch { return false; }
    }

    private static bool IsLaptopByChassis()
    {
        try
        {
            using var searcher = new ManagementObjectSearcher("SELECT ChassisTypes FROM Win32_SystemEnclosure");
            foreach (ManagementObject mo in searcher.Get())
            {
                if (mo["ChassisTypes"] is ushort[] types)
                    foreach (var t in types)
                        if (t is 8 or 9 or 10 or 11 or 12 or 14 or 18 or 21 or 30 or 31 or 32)
                            return true;
            }
        }
        catch { }
        return false;
    }

    private static (string version, string build, string edition) WindowsVersionInfo()
    {
        try
        {
            using var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion");
            var product = key?.GetValue("ProductName")?.ToString() ?? "Windows";
            var build   = key?.GetValue("CurrentBuildNumber")?.ToString() ?? "0";
            var edition = key?.GetValue("EditionID")?.ToString() ?? "";

            var isWin11 = int.TryParse(build, out var b) && b >= 22000;
            var version = isWin11 ? "11" : (product.Contains("Windows 10") ? "10" : "10");
            return (version, build, edition);
        }
        catch { return ("10", "0", ""); }
    }

    private static string GpuName()
    {
        try
        {
            using var searcher = new ManagementObjectSearcher(
                "SELECT Name FROM Win32_VideoController");
            foreach (ManagementObject mo in searcher.Get())
            {
                var n = mo["Name"]?.ToString();
                if (!string.IsNullOrWhiteSpace(n) && !n.Contains("Basic Display", StringComparison.OrdinalIgnoreCase))
                    return n;
            }
        }
        catch { }
        return "Desconhecida";
    }

    private static DiskKind SystemDiskKind()
    {
        try
        {
            using var scope = new ManagementScope(@"\\.\root\Microsoft\Windows\Storage");
            using var q = new ObjectQuery("SELECT MediaType FROM MSFT_PhysicalDisk WHERE DeviceId='0'");
            using var s = new ManagementObjectSearcher(scope, q);
            foreach (ManagementObject mo in s.Get())
            {
                var mt = Convert.ToInt32(mo["MediaType"] ?? 0);
                if (mt == 4) return DiskKind.Ssd;
                if (mt == 3) return DiskKind.Hdd;
            }
        }
        catch { }
        return DiskKind.Unknown;
    }

    private static ulong TotalRamBytes()
    {
        try
        {
            using var searcher = new ManagementObjectSearcher(
                "SELECT TotalPhysicalMemory FROM Win32_ComputerSystem");
            foreach (ManagementObject mo in searcher.Get())
                return Convert.ToUInt64(mo["TotalPhysicalMemory"] ?? 0UL);
        }
        catch { }
        return 0;
    }
}
'@

# ---- RestorePointService.cs ----
Write-File "src\FpsLatencyPanel.Core\Engine\RestorePointService.cs" @'
namespace FpsLatencyPanel.Core.Engine;

using System.Management;
using FpsLatencyPanel.Core.Abstractions;
using Microsoft.Win32;

public sealed class RestorePointService : IRestorePointService
{
    private readonly ILogger _log;
    public RestorePointService(ILogger log) => _log = log;

    public Task<bool> IsSystemRestoreEnabledAsync(CancellationToken ct = default)
    {
        return Task.Run(() =>
        {
            try
            {
                using var key = Registry.LocalMachine.OpenSubKey(
                    @"SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore");
                var disable = key?.GetValue("DisableSR")?.ToString();
                if (string.Equals(disable, "1")) return false;

                try
                {
                    using var searcher = new ManagementObjectSearcher(
                        @"\\.\root\default", "SELECT * FROM SystemRestore");
                    searcher.Get();
                }
                catch { }

                return true;
            }
            catch (Exception ex)
            {
                _log.Warn("RestorePointService", "Falha ao checar System Restore.", ex.Message);
                return false;
            }
        }, ct);
    }

    public Task<bool> TryCreateAsync(string description, CancellationToken ct = default)
    {
        return Task.Run(() =>
        {
            try
            {
                using var scope = new ManagementScope(@"\\.\root\default");
                using var cls = new ManagementClass(scope, new ManagementPath("SystemRestore"), null);
                var inParams = cls.GetMethodParameters("CreateRestorePoint");
                inParams["Description"] = description;
                inParams["RestorePointType"] = 0;
                inParams["EventType"] = 100;

                var outParams = cls.InvokeMethod("CreateRestorePoint", inParams, null);
                var ret = Convert.ToInt32(outParams?["ReturnValue"] ?? -1);
                if (ret == 0) { _log.Info("RestorePointService", $"Ponto criado: {description}"); return true; }

                _log.Warn("RestorePointService", $"CreateRestorePoint retornou {ret}.");
                return false;
            }
            catch (Exception ex)
            {
                _log.Error("RestorePointService", "Falha ao criar ponto de restauracao.", ex);
                return false;
            }
        }, ct);
    }
}
'@

# ---- TweakEngine.cs ----
Write-File "src\FpsLatencyPanel.Core\Engine\TweakEngine.cs" @'
namespace FpsLatencyPanel.Core.Engine;

using FpsLatencyPanel.Core.Abstractions;

public sealed record EngineOptions(
    bool CreateRestorePoint,
    bool IsLaptopUserAcknowledged);

public sealed record EngineReport(
    int Total,
    int Applied,
    int Skipped,
    int Failed,
    IReadOnlyList<(string TweakId, TweakResult Result)> Details);

public sealed class TweakEngine
{
    private readonly IBackupManager _backup;
    private readonly ILogger _log;
    private readonly IRestorePointService _rp;

    public TweakEngine(IBackupManager backup, ILogger log, IRestorePointService rp)
    {
        _backup = backup;
        _log    = log;
        _rp     = rp;
    }

    public async Task<EngineReport> ApplyManyAsync(
        IEnumerable<ITweak> tweaks,
        EngineOptions options,
        IProgress<string>? progress = null,
        CancellationToken ct = default)
    {
        var list = tweaks.ToList();
        var details = new List<(string, TweakResult)>();
        int applied = 0, skipped = 0, failed = 0;

        if (options.CreateRestorePoint)
        {
            progress?.Report("Criando ponto de restauracao...");
            var ok = await _rp.TryCreateAsync($"FPS Latency Panel - antes de aplicar ajustes em {DateTime.Now:yyyy-MM-dd HH:mm}", ct);
            if (!ok)
            {
                _log.Warn("TweakEngine", "Ponto de restauracao nao pode ser criado. Prosseguindo com backup JSON.");
            }
        }

        foreach (var tweak in list)
        {
            ct.ThrowIfCancellationRequested();
            progress?.Report($"Aplicando: {tweak.Name}");

            if (tweak.AffectsLaptop && !options.IsLaptopUserAcknowledged)
            {
                var skip = TweakResult.Skipped("Ignorado: exige confirmacao em notebook.");
                details.Add((tweak.Id, skip));
                skipped++;
                continue;
            }

            try
            {
                var state = await tweak.DetectAsync(ct);
                if (state.Kind == TweakStateKind.Aplicado)
                {
                    var s = TweakResult.Skipped("Ja aplicado.", state.Detalhe);
                    details.Add((tweak.Id, s));
                    skipped++;
                    continue;
                }
                if (state.Kind == TweakStateKind.NaoAplicavel)
                {
                    var s = TweakResult.Skipped("Nao aplicavel: " + state.Detalhe);
                    details.Add((tweak.Id, s));
                    skipped++;
                    continue;
                }

                var result = await tweak.ApplyAsync(ct);

                if (result.Success)
                {
                    applied++;
                    _log.Info($"Tweak:{tweak.Id}", $"Aplicado: {result.Message}", result.ValueBefore, result.ValueAfter);
                }
                else
                {
                    failed++;
                    _log.Error($"Tweak:{tweak.Id}", $"Falha ao aplicar: {result.Message}", result.Error, result.ValueBefore);
                    try { await tweak.RevertAsync(ct); }
                    catch (Exception ex) { _log.Error($"Tweak:{tweak.Id}", "Falha tambem no rollback.", ex); }
                }
                details.Add((tweak.Id, result));
            }
            catch (Exception ex)
            {
                failed++;
                _log.Error($"Tweak:{tweak.Id}", "Excecao nao tratada no tweak.", ex);
                details.Add((tweak.Id, TweakResult.Fail("Excecao: " + ex.Message, ex)));
                try { await tweak.RevertAsync(ct); } catch { }
            }
        }

        return new EngineReport(list.Count, applied, skipped, failed, details);
    }

    public async Task<EngineReport> RevertAllAsync(
        IEnumerable<ITweak> tweaks,
        IProgress<string>? progress = null,
        CancellationToken ct = default)
    {
        var list = tweaks.ToList();
        var details = new List<(string, TweakResult)>();
        int ok = 0, skipped = 0, failed = 0;

        foreach (var tweak in list)
        {
            ct.ThrowIfCancellationRequested();
            progress?.Report($"Revertendo: {tweak.Name}");
            try
            {
                var state = await tweak.DetectAsync(ct);
                if (state.Kind == TweakStateKind.NaoAplicado)
                {
                    details.Add((tweak.Id, TweakResult.Skipped("Nada a reverter.", state.Detalhe)));
                    skipped++;
                    continue;
                }

                var r = await tweak.RevertAsync(ct);
                if (r.Success) { ok++; _log.Info($"Tweak:{tweak.Id}", $"Revertido: {r.Message}", r.ValueBefore, r.ValueAfter); }
                else { failed++; _log.Error($"Tweak:{tweak.Id}", $"Falha ao reverter: {r.Message}", r.Error); }
                details.Add((tweak.Id, r));
            }
            catch (Exception ex)
            {
                failed++;
                _log.Error($"Tweak:{tweak.Id}", "Excecao ao reverter.", ex);
                details.Add((tweak.Id, TweakResult.Fail("Excecao: " + ex.Message, ex)));
            }
        }

        return new EngineReport(list.Count, ok, skipped, failed, details);
    }
}
'@

# ---- ProfileRecommended.cs ----
Write-File "src\FpsLatencyPanel.Core\Engine\ProfileRecommended.cs" @'
namespace FpsLatencyPanel.Core.Engine;

using FpsLatencyPanel.Core.Abstractions;

public sealed record RecommendedStep(ITweak Tweak, int Order, string WhyIncluded);

public sealed class ProfileRecommended
{
    private readonly IReadOnlyList<RecommendedStep> _steps;

    public ProfileRecommended(IEnumerable<ITweak> allTweaks)
    {
        var map = allTweaks.ToDictionary(t => t.Id, t => t);
        var order = new List<RecommendedStep>();

        void Add(string id, int orderIdx, string why)
        {
            if (map.TryGetValue(id, out var t) && t.IncludeInRecommendedProfile)
                order.Add(new RecommendedStep(t, orderIdx, why));
        }

        Add("power.customplan",  10, "Cria plano de energia dedicado sem tocar no original.");
        Add("power.usbsuspend",  20, "Evita suspensao de mouse/teclado/headset USB.");
        Add("power.pcieaspm",    30, "Reduz micro-oscilacao de latencia no barramento PCIe.");

        Add("mouse.acceleration", 40, "Elimina aceleracao de ponteiro.");
        Add("mouse.speed",        50, "Coloca em 6/11 (1:1).");
        Add("mouse.curve",        60, "Corrige curvas alteradas por tweaks antigos.");

        Add("kbd.delay",           70, "Reduz atraso antes da repeticao.");
        Add("kbd.speed",           80, "Taxa maxima de repeticao.");
        Add("kbd.accessibility",   90, "Impede Sticky/Filter/Toggle de abrir em jogo.");

        Add("games.dvr",          100, "Desliga captura em segundo plano do Game DVR.");
        Add("games.mode",         110, "Liga o Modo Jogo (marginal, mas reversivel).");

        Add("net.autotuning",     120, "Garante autotuning TCP em Normal.");
        Add("net.rss",            130, "Habilita RSS.");

        Add("clean.temp",         140, "Libera temporarios.");

        _steps = order.OrderBy(s => s.Order).ToList();
    }

    public IReadOnlyList<RecommendedStep> Steps => _steps;

    public IReadOnlyList<ITweak> Tweaks => _steps.Select(s => s.Tweak).ToList();
}
'@

Write-Host "  Engine OK." -ForegroundColor DarkGray
Write-Host ""# =====================================================================
# CORE — Infrastructure
# =====================================================================

Write-Host "Core: Infrastructure..." -ForegroundColor Yellow

# ---- RegistryAccessor.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\RegistryAccessor.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

using FpsLatencyPanel.Core.Abstractions;
using Microsoft.Win32;

public sealed class RegistryAccessor : IRegistryAccessor
{
    private static RegistryHive ToHive(Hive h) => h == Hive.CurrentUser ? RegistryHive.CurrentUser : RegistryHive.LocalMachine;

    public object? ReadValue(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        if (key is null) return null;
        return loc.ValueName is null ? null : key.GetValue(loc.ValueName, null);
    }

    public RegistryValueKind? GetValueKind(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        if (key is null || loc.ValueName is null) return null;
        try { return key.GetValueKind(loc.ValueName); }
        catch { return null; }
    }

    public void WriteValue(RegLocation loc, object value, RegistryValueKind kind)
    {
        if (loc.ValueName is null)
            throw new ArgumentException("ValueName obrigatorio para escrita.", nameof(loc));

        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.CreateSubKey(loc.SubKey, writable: true)
            ?? throw new InvalidOperationException($"Falha ao abrir/criar chave {loc.SubKey}");
        key.SetValue(loc.ValueName, value, kind);
    }

    public void DeleteValue(RegLocation loc)
    {
        if (loc.ValueName is null) return;
        try
        {
            using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
                loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
            using var key = baseKey.OpenSubKey(loc.SubKey, writable: true);
            key?.DeleteValue(loc.ValueName, throwOnMissingValue: false);
        }
        catch (UnauthorizedAccessException) { }
    }

    public bool KeyExists(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        return key is not null;
    }

    public string[] GetSubKeyNames(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        return key?.GetSubKeyNames() ?? Array.Empty<string>();
    }

    public string[] GetValueNames(RegLocation loc)
    {
        using var baseKey = RegistryKey.OpenBaseKey(ToHive(loc.Hive),
            loc.Is64BitView ? RegistryView.Registry64 : RegistryView.Registry32);
        using var key = baseKey.OpenSubKey(loc.SubKey, writable: false);
        return key?.GetValueNames() ?? Array.Empty<string>();
    }
}
'@

# ---- SafePathGuard.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\SafePathGuard.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

public static class SafePathGuard
{
    private static readonly string[] BlockedExactRoots =
    {
        @"C:\Windows",
        @"C:\Windows\System32",
        @"C:\Windows\SysWOW64",
        @"C:\Program Files",
        @"C:\Program Files (x86)",
        @"C:\ProgramData",
        @"C:\Users",
        @"C:\Recovery",
        @"C:\$Recycle.Bin"
    };

    public static bool IsSafeToDelete(string path)
    {
        if (string.IsNullOrWhiteSpace(path)) return false;

        string full;
        try { full = Path.GetFullPath(path).TrimEnd('\\'); }
        catch { return false; }

        if (full.Length == 2 && full[1] == ':') return false;

        foreach (var blocked in BlockedExactRoots)
        {
            var b = Path.GetFullPath(blocked).TrimEnd('\\');
            if (string.Equals(full, b, StringComparison.OrdinalIgnoreCase)) return false;
        }
        return true;
    }

    public static bool IsSystemCriticalPath(string path)
    {
        var full = Path.GetFullPath(path).TrimEnd('\\');
        return BlockedExactRoots.Any(b =>
            string.Equals(full, Path.GetFullPath(b).TrimEnd('\\'), StringComparison.OrdinalIgnoreCase) ||
            full.StartsWith(Path.GetFullPath(b).TrimEnd('\\') + "\\", StringComparison.OrdinalIgnoreCase));
    }
}
'@

# ---- IPowerPlanService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\IPowerPlanService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

public enum PowerSettingValue
{
    On,
    Off,
    Unknown
}

public interface IPowerPlanService
{
    Task<Guid?> GetActivePlanGuidAsync(CancellationToken ct = default);
    Task<bool> EnsureCustomPlanAsync(CancellationToken ct = default);
    Task<Guid?> FindPlanGuidByNameAsync(string name, CancellationToken ct = default);
    Task<bool> ActivateAsync(Guid guid, CancellationToken ct = default);

    Task<bool> SetSettingEnabledAsync(
        Guid planGuid,
        Guid subGroupGuid,
        Guid settingGuid,
        bool onAc,
        bool onDc,
        CancellationToken ct = default);

    Task<PowerSettingValue> GetSettingAsync(
        Guid planGuid,
        Guid subGroupGuid,
        Guid settingGuid,
        bool onAc,
        CancellationToken ct = default);
}
'@

# ---- PowerGuids.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\PowerGuids.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

public static class PowerGuids
{
    public static readonly Guid SubUsbSettings  = new("2a737441-1930-4402-8d77-b2bebba308a3");
    public static readonly Guid SettingUsbSuspend = new("48e6b7a6-50f5-4782-a5d4-53bb8f07e226");

    public static readonly Guid SubPcie         = new("501a4d13-42af-4429-9fd1-a8218c268e20");
    public static readonly Guid SettingPcieAspm = new("ee12f906-d277-404b-b6da-e5fa1a576df5");
}
'@

# ---- PowerPlanService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\PowerPlanService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

using System.Diagnostics;
using FpsLatencyPanel.Core.Abstractions;

public sealed class PowerPlanService : IPowerPlanService
{
    private readonly ILogger _log;
    public const string CustomPlanName = "FPS Panel - Performance";

    public PowerPlanService(ILogger log) => _log = log;

    public async Task<Guid?> GetActivePlanGuidAsync(CancellationToken ct = default)
    {
        return await Task.Run(() =>
        {
            try
            {
                var scope = new System.Management.ManagementScope(@"\\.\root\cimv2\power");
                var query = new System.Management.ObjectQuery(
                    "SELECT InstanceID, IsActive FROM Win32_PowerPlan");
                using var searcher = new System.Management.ManagementObjectSearcher(scope, query);
                foreach (System.Management.ManagementObject mo in searcher.Get())
                {
                    if (!(bool)(mo["IsActive"] ?? false)) continue;
                    var id = mo["InstanceID"]?.ToString() ?? "";
                    var guidStr = id.Replace("Microsoft:PowerPlan\\", "", StringComparison.OrdinalIgnoreCase).Trim('{', '}');
                    return Guid.TryParse(guidStr, out var g) ? g : (Guid?)null;
                }
                return null;
            }
            catch (Exception ex)
            {
                _log.Error("PowerPlanService", "Falha ao ler plano ativo via WMI.", ex);
                return null;
            }
        }, ct);
    }

    public async Task<bool> EnsureCustomPlanAsync(CancellationToken ct = default)
    {
        var existing = await FindPlanGuidByNameAsync(CustomPlanName, ct);
        if (existing is not null)
        {
            _log.Info("PowerPlanService", $"Plano customizado ja existe: {existing}");
            return true;
        }

        var dup = await RunPowerCfgAsync($"-duplicatescheme {WellKnownPlans.HighPerformance}", ct);
        var newGuid = ParseGuidFromOutput(dup.stdout);
        if (newGuid is null)
        {
            _log.Error("PowerPlanService", "Nao foi possivel duplicar o plano de energia.", null, null, dup.stderr);
            return false;
        }

        await RunPowerCfgAsync($"-changename {newGuid} \"{CustomPlanName}\"", ct);
        _log.Info("PowerPlanService", $"Plano customizado criado: {newGuid}");
        return true;
    }

    public async Task<Guid?> FindPlanGuidByNameAsync(string name, CancellationToken ct = default)
    {
        var r = await RunPowerCfgAsync("-list", ct);
        if (r.exit != 0) return null;
        foreach (var line in r.stdout.Split('\n'))
        {
            if (!line.Contains(name, StringComparison.OrdinalIgnoreCase)) continue;
            var idx = line.IndexOf('{');
            var end = line.IndexOf('}', idx);
            if (idx >= 0 && end > idx)
            {
                var g = line.Substring(idx + 1, end - idx - 1);
                if (Guid.TryParse(g, out var guid)) return guid;
            }
        }
        return null;
    }

    public async Task<bool> ActivateAsync(Guid guid, CancellationToken ct = default)
    {
        var r = await RunPowerCfgAsync($"-setactive {guid}", ct);
        if (r.exit == 0)
        {
            _log.Info("PowerPlanService", $"Plano ativado: {guid}");
            return true;
        }
        _log.Error("PowerPlanService", $"Falha ao ativar plano {guid}", null, null, r.stderr);
        return false;
    }

    public async Task<bool> SetSettingEnabledAsync(
        Guid planGuid, Guid subGroupGuid, Guid settingGuid,
        bool onAc, bool onDc, CancellationToken ct = default)
    {
        var acResult = await SetOneAsync(planGuid, subGroupGuid, settingGuid, onAc, dc: false, ct);
        var dcResult = await SetOneAsync(planGuid, subGroupGuid, settingGuid, onDc, dc: true, ct);
        return acResult && dcResult;
    }

    public async Task<PowerSettingValue> GetSettingAsync(
        Guid planGuid, Guid subGroupGuid, Guid settingGuid,
        bool onAc, CancellationToken ct = default)
    {
        var args = $"-query {planGuid} {subGroupGuid} {settingGuid}";
        var r = await RunPowerCfgAsync(args, ct);
        if (r.exit != 0) return PowerSettingValue.Unknown;

        var lines = r.stdout.Split('\n');
        bool wantAc = onAc;
        foreach (var raw in lines)
        {
            var line = raw.Trim();
            if (line.StartsWith("AC", StringComparison.OrdinalIgnoreCase) ||
                line.Contains("CA", StringComparison.OrdinalIgnoreCase))
            {
                if (!wantAc) continue;
                return ParseHexValue(line);
            }
            if (line.StartsWith("DC", StringComparison.OrdinalIgnoreCase) ||
                line.Contains("CC", StringComparison.OrdinalIgnoreCase))
            {
                if (wantAc) continue;
                return ParseHexValue(line);
            }
        }
        return PowerSettingValue.Unknown;
    }

    private static PowerSettingValue ParseHexValue(string line)
    {
        var idx = line.IndexOf("0x", StringComparison.OrdinalIgnoreCase);
        if (idx < 0) return PowerSettingValue.Unknown;
        var hex = line.Substring(idx + 2).Trim().TrimEnd('.', ',', '\r');
        if (hex.Length > 8) hex = hex.Substring(0, 8);
        if (!int.TryParse(hex, System.Globalization.NumberStyles.HexNumber,
                System.Globalization.CultureInfo.InvariantCulture, out var v))
            return PowerSettingValue.Unknown;
        return v == 0 ? PowerSettingValue.On : PowerSettingValue.Off;
    }

    private async Task<bool> SetOneAsync(
        Guid planGuid, Guid subGroup, Guid setting, bool enabled, bool dc, CancellationToken ct)
    {
        var args = dc
            ? $"-setdcvalueindex {planGuid} {subGroup} {setting} {(enabled ? 0 : 1)}"
            : $"-setacvalueindex {planGuid} {subGroup} {setting} {(enabled ? 0 : 1)}";

        var r = await RunPowerCfgAsync(args, ct);
        if (r.exit != 0)
        {
            _log.Error("PowerPlanService", $"powercfg falhou: {args}", null, null, r.stderr);
            return false;
        }
        return true;
    }

    private static async Task<(int exit, string stdout, string stderr)> RunPowerCfgAsync(
        string args, CancellationToken ct)
    {
        var psi = new ProcessStartInfo("powercfg.exe", args)
        {
            RedirectStandardOutput = true,
            RedirectStandardError  = true,
            UseShellExecute        = false,
            CreateNoWindow         = true
        };
        using var p = Process.Start(psi)!;
        var stdout = await p.StandardOutput.ReadToEndAsync(ct);
        var stderr = await p.StandardError.ReadToEndAsync(ct);
        await p.WaitForExitAsync(ct);
        return (p.ExitCode, stdout, stderr);
    }

    private static string? ParseGuidFromOutput(string stdout)
    {
        foreach (var line in stdout.Split('\n'))
        {
            var idx = line.IndexOf('{');
            var end = line.IndexOf('}', idx);
            if (idx >= 0 && end > idx)
            {
                var g = line.Substring(idx + 1, end - idx - 1);
                if (Guid.TryParse(g, out var guid)) return guid.ToString();
            }
        }
        return null;
    }
}

public static class WellKnownPlans
{
    public const string HighPerformance = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c";
}
'@

# ---- NativeMethods.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\NativeMethods.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

using System.Runtime.InteropServices;

internal static class NativeMethods
{
    public const uint SPI_GETMOUSE      = 0x0003;
    public const uint SPI_SETMOUSE      = 0x0004;
    public const uint SPI_GETMOUSESPEED = 0x0070;
    public const uint SPI_SETMOUSESPEED = 0x0071;

    public const uint SPIF_UPDATEINIFILE = 0x0001;
    public const uint SPIF_SENDCHANGE    = 0x0002;

    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SystemParametersInfo(
        uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);

    [DllImport("user32.dll", EntryPoint = "SystemParametersInfoW", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SystemParametersInfoArray(
        uint uiAction, uint uiParam, [In, Out] int[] pvParam, uint fWinIni);

    [DllImport("user32.dll", EntryPoint = "SystemParametersInfoW", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SystemParametersInfoInt(
        uint uiAction, uint uiParam, ref int pvParam, uint fWinIni);
}
'@

# ---- SystemParametersService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\SystemParametersService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

using FpsLatencyPanel.Core.Abstractions;

public interface ISystemParametersService
{
    (int t1, int t2, int accel)? GetMouseParams();
    bool SetMouseParams(int t1, int t2, int accel);
    int? GetMouseSpeed();
    bool SetMouseSpeed(int speed);
    void BroadcastSettingChange();
}

public sealed class SystemParametersService : ISystemParametersService
{
    private readonly ILogger _log;
    public SystemParametersService(ILogger log) => _log = log;

    public (int t1, int t2, int accel)? GetMouseParams()
    {
        try
        {
            var buf = new int[3];
            if (!NativeMethods.SystemParametersInfoArray(NativeMethods.SPI_GETMOUSE, 0, buf, 0))
            {
                _log.Warn("SystemParameters", $"SPI_GETMOUSE falhou.");
                return null;
            }
            return (buf[0], buf[1], buf[2]);
        }
        catch (Exception ex)
        {
            _log.Error("SystemParameters", "Excecao em GetMouseParams.", ex);
            return null;
        }
    }

    public bool SetMouseParams(int t1, int t2, int accel)
    {
        try
        {
            var buf = new[] { t1, t2, accel };
            var ok = NativeMethods.SystemParametersInfoArray(
                NativeMethods.SPI_SETMOUSE, 0, buf,
                NativeMethods.SPIF_UPDATEINIFILE | NativeMethods.SPIF_SENDCHANGE);
            if (!ok)
                _log.Warn("SystemParameters", "SPI_SETMOUSE retornou false.");
            return ok;
        }
        catch (Exception ex)
        {
            _log.Error("SystemParameters", "Excecao em SetMouseParams.", ex);
            return false;
        }
    }

    public int? GetMouseSpeed()
    {
        try
        {
            int speed = 0;
            if (!NativeMethods.SystemParametersInfoInt(NativeMethods.SPI_GETMOUSESPEED, 0, ref speed, 0))
            {
                _log.Warn("SystemParameters", "SPI_GETMOUSESPEED falhou.");
                return null;
            }
            return speed;
        }
        catch (Exception ex)
        {
            _log.Error("SystemParameters", "Excecao em GetMouseSpeed.", ex);
            return null;
        }
    }

    public bool SetMouseSpeed(int speed)
    {
        try
        {
            var ok = NativeMethods.SystemParametersInfo(
                NativeMethods.SPI_SETMOUSESPEED, (uint)speed, IntPtr.Zero,
                NativeMethods.SPIF_UPDATEINIFILE | NativeMethods.SPIF_SENDCHANGE);
            if (!ok)
                _log.Warn("SystemParameters", $"SPI_SETMOUSESPEED({speed}) retornou false.");
            return ok;
        }
        catch (Exception ex)
        {
            _log.Error("SystemParameters", "Excecao em SetMouseSpeed.", ex);
            return false;
        }
    }

    public void BroadcastSettingChange() { }
}
'@

# ---- INetworkService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\INetworkService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

public enum AutotuningLevel { Disabled, HighlyRestricted, Restricted, Normal, Experimental, Unknown }

public sealed record NetworkAdapterInfo(
    string Id,
    string Name,
    string Description,
    bool IsUp,
    bool IsPhysical);

public interface INetworkService
{
    Task<IReadOnlyList<NetworkAdapterInfo>> GetActiveAdaptersAsync(CancellationToken ct = default);
    Task<AutotuningLevel> GetAutotuningAsync(CancellationToken ct = default);
    Task<bool> SetAutotuningAsync(AutotuningLevel level, CancellationToken ct = default);
    Task<bool?> GetRssAsync(string adapterName, CancellationToken ct = default);
    Task<bool> SetRssAsync(string adapterName, bool enabled, CancellationToken ct = default);
    Task<IReadOnlyList<string>> GetDnsServersAsync(string adapterName, CancellationToken ct = default);
    Task<bool> SetDnsServersAsync(string adapterName, IReadOnlyList<string> servers, CancellationToken ct = default);
    Task<bool> ResetDnsServersAsync(string adapterName, CancellationToken ct = default);
}
'@

# ---- NetworkService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\NetworkService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

using System.Diagnostics;
using System.Management;
using System.Net.NetworkInformation;
using FpsLatencyPanel.Core.Abstractions;

public sealed class NetworkService : INetworkService
{
    private readonly ILogger _log;
    public NetworkService(ILogger log) => _log = log;

    public Task<IReadOnlyList<NetworkAdapterInfo>> GetActiveAdaptersAsync(CancellationToken ct = default)
    {
        return Task.Run<IReadOnlyList<NetworkAdapterInfo>>(() =>
        {
            var list = new List<NetworkAdapterInfo>();
            try
            {
                foreach (var nic in NetworkInterface.GetAllNetworkInterfaces())
                {
                    if (nic.NetworkInterfaceType == NetworkInterfaceType.Loopback) continue;
                    if (nic.NetworkInterfaceType == NetworkInterfaceType.Tunnel) continue;
                    if (nic.OperationalStatus != OperationalStatus.Up) continue;
                    if (!nic.Supports(NetworkInterfaceComponent.IPv4)) continue;

                    var desc = nic.Description ?? "";
                    bool physical = !(desc.Contains("Virtual", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("Hyper-V", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("VMware", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("TAP-", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("WireGuard", StringComparison.OrdinalIgnoreCase)
                                   || desc.Contains("OpenVPN", StringComparison.OrdinalIgnoreCase));

                    list.Add(new NetworkAdapterInfo(nic.Id, nic.Name, desc, true, physical));
                }
            }
            catch (Exception ex)
            {
                _log.Error("NetworkService", "Falha ao enumerar adaptadores.", ex);
            }
            return list;
        }, ct);
    }

    public async Task<AutotuningLevel> GetAutotuningAsync(CancellationToken ct = default)
    {
        var r = await RunAsync("netsh", "int tcp show global", ct);
        if (r.exit != 0) return AutotuningLevel.Unknown;

        foreach (var raw in r.stdout.Split('\n'))
        {
            var line = raw.Trim();
            var lower = line.ToLowerInvariant();
            if (!lower.Contains("autotuning")) continue;

            if (lower.Contains("normal"))            return AutotuningLevel.Normal;
            if (lower.Contains("disabled"))          return AutotuningLevel.Disabled;
            if (lower.Contains("highlyrestricted"))  return AutotuningLevel.HighlyRestricted;
            if (lower.Contains("restricted"))        return AutotuningLevel.Restricted;
            if (lower.Contains("experimental"))      return AutotuningLevel.Experimental;
        }
        return AutotuningLevel.Unknown;
    }

    public async Task<bool> SetAutotuningAsync(AutotuningLevel level, CancellationToken ct = default)
    {
        var name = level switch
        {
            AutotuningLevel.Disabled         => "disabled",
            AutotuningLevel.HighlyRestricted => "highlyrestricted",
            AutotuningLevel.Restricted       => "restricted",
            AutotuningLevel.Normal           => "normal",
            AutotuningLevel.Experimental     => "experimental",
            _ => throw new ArgumentOutOfRangeException(nameof(level))
        };
        var r = await RunAsync("netsh", $"int tcp set global autotuninglevel={name}", ct);
        if (r.exit != 0)
        {
            _log.Error("NetworkService", $"netsh autotuning falhou: {r.stderr}");
            return false;
        }
        return true;
    }

    public async Task<bool?> GetRssAsync(string adapterName, CancellationToken ct = default)
    {
        var r = await RunAsync("netsh", "int tcp show global", ct);
        if (r.exit == 0)
        {
            foreach (var raw in r.stdout.Split('\n'))
            {
                var line = raw.Trim().ToLowerInvariant();
                if (line.Contains("rss") || line.Contains("receive-side scaling") || line.Contains("escalonamento"))
                {
                    if (line.Contains("enabled")) return true;
                    if (line.Contains("disabled")) return false;
                }
            }
        }
        return null;
    }

    public async Task<bool> SetRssAsync(string adapterName, bool enabled, CancellationToken ct = default)
    {
        var arg = enabled ? "enabled" : "disabled";
        var r = await RunAsync("netsh", $"int tcp set global rss={arg}", ct);
        if (r.exit != 0)
        {
            _log.Error("NetworkService", $"netsh rss falhou: {r.stderr}");
            return false;
        }
        return true;
    }

    public Task<IReadOnlyList<string>> GetDnsServersAsync(string adapterName, CancellationToken ct = default)
    {
        return Task.Run<IReadOnlyList<string>>(() =>
        {
            try
            {
                var scope = new ManagementScope(@"\\.\root\cimv2");
                var q = new ObjectQuery(
                    $"SELECT DNSServerSearchOrder FROM Win32_NetworkAdapterConfiguration " +
                    $"WHERE Description = '{Escape(adapterName)}' AND IPEnabled = TRUE");
                using var s = new ManagementObjectSearcher(scope, q);
                foreach (ManagementObject mo in s.Get())
                {
                    if (mo["DNSServerSearchOrder"] is string[] arr) return arr;
                }
            }
            catch (Exception ex)
            {
                _log.Error("NetworkService", "Falha ao ler DNS via WMI.", ex);
            }
            return Array.Empty<string>();
        }, ct);
    }

    public Task<bool> SetDnsServersAsync(string adapterName, IReadOnlyList<string> servers, CancellationToken ct = default)
    {
        return Task.Run(() =>
        {
            try
            {
                var scope = new ManagementScope(@"\\.\root\cimv2");
                var q = new ObjectQuery(
                    $"SELECT * FROM Win32_NetworkAdapterConfiguration " +
                    $"WHERE Description = '{Escape(adapterName)}' AND IPEnabled = TRUE");
                using var s = new ManagementObjectSearcher(scope, q);
                foreach (ManagementObject mo in s.Get())
                {
                    var inParams = mo.GetMethodParameters("SetDNSServerSearchOrder");
                    inParams["DNSServerSearchOrder"] = servers.ToArray();
                    var outParams = mo.InvokeMethod("SetDNSServerSearchOrder", inParams, null);
                    var ret = Convert.ToInt32(outParams?["ReturnValue"] ?? -1);
                    if (ret == 0) return true;
                    _log.Error("NetworkService", $"SetDNSServerSearchOrder retornou {ret}.");
                }
            }
            catch (Exception ex)
            {
                _log.Error("NetworkService", "Falha ao aplicar DNS.", ex);
            }
            return false;
        }, ct);
    }

    public Task<bool> ResetDnsServersAsync(string adapterName, CancellationToken ct = default)
    {
        return Task.Run(() =>
        {
            try
            {
                var scope = new ManagementScope(@"\\.\root\cimv2");
                var q = new ObjectQuery(
                    $"SELECT * FROM Win32_NetworkAdapterConfiguration " +
                    $"WHERE Description = '{Escape(adapterName)}' AND IPEnabled = TRUE");
                using var s = new ManagementObjectSearcher(scope, q);
                foreach (ManagementObject mo in s.Get())
                {
                    var inParams = mo.GetMethodParameters("SetDNSServerSearchOrder");
                    inParams["DNSServerSearchOrder"] = null;
                    var outParams = mo.InvokeMethod("SetDNSServerSearchOrder", inParams, null);
                    var ret = Convert.ToInt32(outParams?["ReturnValue"] ?? -1);
                    if (ret == 0) return true;
                    _log.Error("NetworkService", $"Reset DNS retornou {ret}.");
                }
            }
            catch (Exception ex)
            {
                _log.Error("NetworkService", "Falha ao resetar DNS.", ex);
            }
            return false;
        }, ct);
    }

    private static string Escape(string s) => s.Replace("'", "''");

    private static async Task<(int exit, string stdout, string stderr)> RunAsync(
        string exe, string args, CancellationToken ct)
    {
        var psi = new ProcessStartInfo(exe, args)
        {
            RedirectStandardOutput = true,
            RedirectStandardError  = true,
            UseShellExecute        = false,
            CreateNoWindow         = true
        };
        using var p = Process.Start(psi)!;
        var stdout = await p.StandardOutput.ReadToEndAsync(ct);
        var stderr = await p.StandardError.ReadToEndAsync(ct);
        await p.WaitForExitAsync(ct);
        return (p.ExitCode, stdout, stderr);
    }
}
'@

# ---- IFileSystemService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\IFileSystemService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

public sealed record CleanupTargetResult(
    string Label,
    string Path,
    long BytesFreed,
    int FilesDeleted,
    int FilesSkipped,
    string? Error);

public interface IFileSystemService
{
    long MeasureBytes(string path);
    CleanupTargetResult CleanDirectory(string label, string path, CancellationToken ct = default);
    CleanupTargetResult EmptyRecycleBin(CancellationToken ct = default);
}
'@

# ---- FileSystemService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\FileSystemService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

using System.Runtime.InteropServices;
using FpsLatencyPanel.Core.Abstractions;

public sealed class FileSystemService : IFileSystemService
{
    private readonly ILogger _log;
    public FileSystemService(ILogger log) => _log = log;

    public long MeasureBytes(string path)
    {
        if (!Directory.Exists(path)) return 0;
        long total = 0;
        try
        {
            foreach (var f in Directory.EnumerateFiles(path, "*", SearchOption.AllDirectories))
            {
                try { total += new FileInfo(f).Length; } catch { }
            }
        }
        catch (Exception ex)
        {
            _log.Warn("FileSystemService", $"Falha ao medir {path}: {ex.Message}");
        }
        return total;
    }

    public CleanupTargetResult CleanDirectory(string label, string path, CancellationToken ct = default)
    {
        if (!Directory.Exists(path))
            return new CleanupTargetResult(label, path, 0, 0, 0, "Diretorio nao existe.");

        if (!SafePathGuard.IsSafeToDelete(path))
        {
            _log.Error("FileSystemService", $"Caminho bloqueado por SafePathGuard: {path}");
            return new CleanupTargetResult(label, path, 0, 0, 0, "Caminho bloqueado por seguranca.");
        }

        long before = MeasureBytes(path);
        int deleted = 0, skipped = 0;

        foreach (var f in SafeEnumerate(path, ct))
        {
            ct.ThrowIfCancellationRequested();
            try
            {
                File.SetAttributes(f, FileAttributes.Normal);
                File.Delete(f);
                deleted++;
            }
            catch (UnauthorizedAccessException) { skipped++; }
            catch (IOException)                  { skipped++; }
            catch (Exception ex)
            {
                skipped++;
                _log.Warn("FileSystemService", $"Falha ao apagar {f}: {ex.Message}");
            }
        }

        try
        {
            foreach (var d in Directory.EnumerateDirectories(path, "*", SearchOption.AllDirectories)
                                      .OrderByDescending(s => s.Length))
            {
                try
                {
                    if (!Directory.EnumerateFileSystemEntries(d).Any())
                        Directory.Delete(d, recursive: false);
                }
                catch { }
            }
        }
        catch { }

        long after = MeasureBytes(path);
        long freed = Math.Max(0, before - after);

        _log.Info("FileSystemService", $"Limpeza {label}: {freed} bytes liberados.",
            before.ToString(), after.ToString());

        return new CleanupTargetResult(label, path, freed, deleted, skipped, null);
    }

    public CleanupTargetResult EmptyRecycleBin(CancellationToken ct = default)
    {
        long before = MeasureRecycleBinBytes();
        int ret = SHEmptyRecycleBin(IntPtr.Zero, null, SHERB_NOCONFIRMATION | SHERB_NOPROGRESSUI | SHERB_NOSOUND);

        if (ret < 0)
        {
            _log.Error("FileSystemService", $"SHEmptyRecycleBin retornou 0x{ret:X8}.");
            return new CleanupTargetResult("Lixeira", "<shell>", 0, 0, 0, "Falha ao esvaziar Lixeira.");
        }

        long after = MeasureRecycleBinBytes();
        long freed = Math.Max(0, before - after);
        _log.Info("FileSystemService", $"Lixeira esvaziada: {freed} bytes liberados.");
        return new CleanupTargetResult("Lixeira", "<shell>", freed, 0, 0, null);
    }

    private long MeasureRecycleBinBytes()
    {
        try
        {
            var sh = new Shell32.Shell();
            var folder = sh.NameSpace(10);
            if (folder is null) return 0;
            long total = 0;
            foreach (Shell32.FolderItem item in folder.Items())
            {
                try
                {
                    var size = folder.GetDetailsOf(item, 3);
                    if (long.TryParse(size, out var s)) total += s;
                }
                catch { }
            }
            return total;
        }
        catch { return 0; }
    }

    private static IEnumerable<string> SafeEnumerate(string root, CancellationToken ct)
    {
        var stack = new Stack<string>();
        stack.Push(root);
        while (stack.Count > 0)
        {
            ct.ThrowIfCancellationRequested();
            var dir = stack.Pop();
            string[] files;
            string[] subdirs;
            try
            {
                files = Directory.GetFiles(dir);
                subdirs = Directory.GetDirectories(dir);
            }
            catch { continue; }

            foreach (var f in files) yield return f;
            foreach (var d in subdirs) stack.Push(d);
        }
    }

    private const uint SHERB_NOCONFIRMATION = 0x00000001;
    private const uint SHERB_NOPROGRESSUI   = 0x00000002;
    private const uint SHERB_NOSOUND        = 0x00000004;

    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    private static extern int SHEmptyRecycleBin(IntPtr hwnd, string? pszRootPath, uint dwFlags);
}
'@

# ---- Shell32.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\Shell32.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

using System.Runtime.InteropServices;

internal static class Shell32
{
    [ComImport, Guid("13709620-C279-11CE-A49E-444553540000")]
    public class Shell { }

    [ComImport, Guid("0D67C5B8-D3A0-11D1-8F9C-00C04FC2AD14"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface IShellDispatch
    {
        Folder NameSpace(object vDir);
    }

    [ComImport, Guid("BBCB4E22-7A8C-11D1-8F84-00C04FC2AD14"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface Folder
    {
        FolderItems Items();
        string GetDetailsOf(FolderItem item, int column);
    }

    [ComImport, Guid("744129E0-C8F1-11D1-9B1A-00C04FC2AD14"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface FolderItems : System.Collections.IEnumerable
    {
    }

    [ComImport, Guid("F4A76D8F-1C6C-11D2-9A36-00C04FC2AD14"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface FolderItem { }
}
'@

# ---- IStartupService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\IStartupService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

public enum StartupSource
{
    HkcuRun,
    HklmRun,
    HkcuRunWow64,
    HklmRunWow64,
    StartupFolderUser,
    StartupFolderCommon,
    StartupApprovedHkcu,
    StartupApprovedHklm
}

public sealed record StartupItem(
    string Id,
    string Name,
    string Command,
    StartupSource Source,
    bool IsEnabled,
    string Location,
    string ValueName);

public interface IStartupService
{
    IReadOnlyList<StartupItem> Enumerate();
    bool Disable(StartupItem item, out string? error);
    bool Enable(StartupItem item, out string? error);
}
'@

# ---- StartupService.cs ----
Write-File "src\FpsLatencyPanel.Core\Infrastructure\StartupService.cs" @'
namespace FpsLatencyPanel.Core.Infrastructure;

using System.Security.Cryptography;
using System.Text;
using FpsLatencyPanel.Core.Abstractions;
using Microsoft.Win32;

public sealed class StartupService : IStartupService
{
    private readonly ILogger _log;

    private static readonly byte[] EnabledBytes  = { 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    private static readonly byte[] DisabledBytes = { 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

    public StartupService(ILogger log) => _log = log;

    public IReadOnlyList<StartupItem> Enumerate()
    {
        var list = new List<StartupItem>();

        AddFromRunKey(list, RegistryHive.CurrentUser, RegistryView.Registry64, StartupSource.HkcuRun,
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run");

        AddFromRunKey(list, RegistryHive.LocalMachine, RegistryView.Registry64, StartupSource.HklmRun,
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run");

        AddFromRunKey(list, RegistryHive.CurrentUser, RegistryView.Registry32, StartupSource.HkcuRunWow64,
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32");

        AddFromRunKey(list, RegistryHive.LocalMachine, RegistryView.Registry32, StartupSource.HklmRunWow64,
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32");

        AddFromFolder(list, RegistryHive.CurrentUser, StartupSource.StartupFolderUser,
            Environment.GetFolderPath(Environment.SpecialFolder.Startup),
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder");

        AddFromFolder(list, RegistryHive.LocalMachine, StartupSource.StartupFolderCommon,
            Environment.GetFolderPath(Environment.SpecialFolder.CommonStartup),
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder");

        return list.OrderBy(i => i.Name, StringComparer.OrdinalIgnoreCase).ToList();
    }

    public bool Disable(StartupItem item, out string? error)
    {
        try
        {
            var (approvedPath, approvedValueName) = ApprovedFor(item);
            using var approvedKey = OpenKey(item.Source, approvedPath, writable: true);
            if (approvedKey is null) { error = "Nao foi possivel abrir chave StartupApproved."; return false; }
            approvedKey.SetValue(approvedValueName, DisabledBytes, RegistryValueKind.Binary);
            error = null;
            return true;
        }
        catch (Exception ex)
        {
            _log.Error("StartupService", $"Falha ao desativar {item.Name}.", ex);
            error = ex.Message;
            return false;
        }
    }

    public bool Enable(StartupItem item, out string? error)
    {
        try
        {
            var (approvedPath, approvedValueName) = ApprovedFor(item);
            using var approvedKey = OpenKey(item.Source, approvedPath, writable: true);
            if (approvedKey is null) { error = "Nao foi possivel abrir chave StartupApproved."; return false; }
            approvedKey.SetValue(approvedValueName, EnabledBytes, RegistryValueKind.Binary);
            error = null;
            return true;
        }
        catch (Exception ex)
        {
            _log.Error("StartupService", $"Falha ao reativar {item.Name}.", ex);
            error = ex.Message;
            return false;
        }
    }

    private void AddFromRunKey(
        List<StartupItem> list, RegistryHive hive, RegistryView view, StartupSource source,
        string runPath, string approvedPath)
    {
        try
        {
            using var baseKey = RegistryKey.OpenBaseKey(hive, view);
            using var run = baseKey.OpenSubKey(runPath, writable: false);
            if (run is null) return;

            using var approved = baseKey.OpenSubKey(approvedPath, writable: false);

            foreach (var valueName in run.GetValueNames())
            {
                var command = run.GetValue(valueName)?.ToString() ?? "";
                bool enabled = true;
                if (approved?.GetValue(valueName) is byte[] b && b.Length > 0 && b[0] == 0x03)
                    enabled = false;

                var id = MakeId(source, runPath, valueName);
                list.Add(new StartupItem(id, valueName, command, source, enabled,
                    $"{hive}\\{runPath}", valueName));
            }
        }
        catch (Exception ex)
        {
            _log.Warn("StartupService", $"Falha ao ler {hive}\\{runPath}: {ex.Message}");
        }
    }

    private void AddFromFolder(
        List<StartupItem> list, RegistryHive hive, StartupSource source,
        string folderPath, string approvedPath)
    {
        try
        {
            if (!Directory.Exists(folderPath)) return;

            var approvedRoot = hive == RegistryHive.CurrentUser
                ? Registry.CurrentUser
                : Registry.LocalMachine;

            using var approved = approvedRoot.OpenSubKey(approvedPath, writable: false);

            foreach (var file in Directory.EnumerateFiles(folderPath))
            {
                var name = Path.GetFileName(file);
                var ext = Path.GetExtension(file).ToLowerInvariant();
                if (ext != ".lnk" && ext != ".url" && ext != ".exe" && ext != ".bat" && ext != ".cmd")
                    continue;

                var attrs = File.GetAttributes(file);
                if (attrs.HasFlag(FileAttributes.Hidden)) continue;

                bool enabled = true;
                if (approved?.GetValue(name) is byte[] b && b.Length > 0 && b[0] == 0x03)
                    enabled = false;

                var id = MakeId(source, folderPath, name);
                list.Add(new StartupItem(id, name, file, source, enabled, folderPath, name));
            }
        }
        catch (Exception ex)
        {
            _log.Warn("StartupService", $"Falha ao ler pasta {folderPath}: {ex.Message}");
        }
    }

    private static (string approvedPath, string valueName) ApprovedFor(StartupItem item)
    {
        var approvedPath = item.Source switch
        {
            StartupSource.HkcuRun       => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
            StartupSource.HklmRun       => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
            StartupSource.HkcuRunWow64  => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32",
            StartupSource.HklmRunWow64  => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32",
            StartupSource.StartupFolderUser   => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder",
            StartupSource.StartupFolderCommon => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder",
            _ => @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
        };
        return (approvedPath, item.ValueName);
    }

    private static RegistryKey? OpenKey(StartupSource source, string path, bool writable)
    {
        var hive = source switch
        {
            StartupSource.HkcuRun or StartupSource.HkcuRunWow64 or StartupSource.StartupFolderUser
                => RegistryHive.CurrentUser,
            _ => RegistryHive.LocalMachine
        };
        var view = source is StartupSource.HkcuRunWow64 or StartupSource.HklmRunWow64
            ? RegistryView.Registry32
            : RegistryView.Registry64;

        try
        {
            var baseKey = RegistryKey.OpenBaseKey(hive, view);
            return writable ? baseKey.CreateSubKey(path, writable: true) : baseKey.OpenSubKey(path, false);
        }
        catch { return null; }
    }

    private static string MakeId(StartupSource source, string location, string name)
    {
        var raw = $"{source}|{location}|{name}".ToLowerInvariant();
        var hash = SHA1.HashData(Encoding.UTF8.GetBytes(raw));
        return $"{source}:{Convert.ToHexString(hash)[..12].ToLowerInvariant()}";
    }
}
'@

Write-Host "  Infrastructure OK." -ForegroundColor DarkGray
Write-Host ""# =====================================================================
# CORE — Tweaks: Mouse
# =====================================================================

Write-Host "Core: Tweaks (Mouse)..." -ForegroundColor Yellow

# ---- MouseAccelerationTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Mouse\MouseAccelerationTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Mouse;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class MouseAccelerationTweak : ITweak
{
    private readonly ISystemParametersService _spi;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation RegMirror = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "MouseThreshold1", true);

    private static readonly RegLocation RegMirror2 = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "MouseThreshold2", true);

    private static readonly RegLocation RegAccel = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "MouseSpeed", true);

    public MouseAccelerationTweak(ISystemParametersService spi, IBackupManager backup, ILogger log)
    {
        _spi = spi; _backup = backup; _log = log;
    }

    public string Id => "mouse.acceleration";
    public string Name => "Desligar \"Melhorar precisao do ponteiro\"";
    public TweakCategory Category => TweakCategory.Mouse;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Desliga a aceleracao de ponteiro do Windows. Movimento do mouse passa a ser " +
        "linear em relacao ao deslocamento fisico. Jogos com RAW INPUT (WM_INPUT) " +
        "IGNORAM esta configuracao - o ganho e real apenas em jogos/menus que usam " +
        "WM_MOUSEMOVE (ex: alguns menus, RTS antigos, emuladores).";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Painel de Controle -> Mouse -> Opcoes de Ponteiro -> " +
        "marcar \"Melhorar precisao do ponteiro\".";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var p = _spi.GetMouseParams();
        if (p is null) return Task.FromResult(TweakState.Desconhecido("SPI_GETMOUSE falhou."));
        return Task.FromResult(p.Value.accel == 0
            ? TweakState.Aplicado
            : TweakState.NaoAplicado);
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var p = _spi.GetMouseParams();
        if (p is null)
            return TweakResult.Fail("Nao foi possivel ler o estado atual (SPI_GETMOUSE).");

        var before = $"{p.Value.t1},{p.Value.t2},{p.Value.accel}";

        await _backup.SaveAsync(Id, "spi", before, "spi-triple", ct);
        var mirrorT1 = ReadMirror(RegMirror);
        var mirrorT2 = ReadMirror(RegMirror2);
        var mirrorAcc = ReadMirror(RegAccel);
        await _backup.SaveAsync(Id, "reg.t1", mirrorT1, "string", ct);
        await _backup.SaveAsync(Id, "reg.t2", mirrorT2, "string", ct);
        await _backup.SaveAsync(Id, "reg.accel", mirrorAcc, "string", ct);

        var ok = _spi.SetMouseParams(p.Value.t1, p.Value.t2, 0);

        if (!ok)
            return TweakResult.Fail("SPI_SETMOUSE falhou.", before: before);

        var after = _spi.GetMouseParams();
        var afterStr = after is null ? "?" : $"{after.Value.t1},{after.Value.t2},{after.Value.accel}";
        _log.Info($"Tweak:{Id}", "Aceleracao desligada.", before, afterStr);
        return TweakResult.Ok("Aceleracao desligada.", before, afterStr);
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var spi = await _backup.LoadAsync(Id, "spi", ct);
        if (spi is null)
        {
            var okDefault = _spi.SetMouseParams(6, 10, 1);
            return okDefault
                ? TweakResult.Ok("Sem backup. Aplicado padrao do Windows (6,10,1).")
                : TweakResult.Fail("Sem backup e SPI_SETMOUSE falhou.");
        }

        var parts = spi.Value.Split(',');
        if (parts.Length != 3 ||
            !int.TryParse(parts[0], out var t1) ||
            !int.TryParse(parts[1], out var t2) ||
            !int.TryParse(parts[2], out var accel))
        {
            return TweakResult.Fail("Backup SPI corrompido.");
        }

        var ok2 = _spi.SetMouseParams(t1, t2, accel);
        if (!ok2) return TweakResult.Fail("Falha ao restaurar valores originais.");

        return TweakResult.Ok("Restaurado.", before: "accel=0", after: $"accel={accel}");
    }

    private static string ReadMirror(RegLocation loc)
    {
        try
        {
            using var key = Microsoft.Win32.Registry.CurrentUser.OpenSubKey(loc.SubKey);
            return key?.GetValue(loc.ValueName!)?.ToString() ?? "<ausente>";
        }
        catch { return "<erro>"; }
    }
}
'@

# ---- MouseSpeedTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Mouse\MouseSpeedTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Mouse;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class MouseSpeedTweak : ITweak
{
    private readonly ISystemParametersService _spi;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private const int TargetSpeed = 6;

    public MouseSpeedTweak(ISystemParametersService spi, IBackupManager backup, ILogger log)
    {
        _spi = spi; _backup = backup; _log = log;
    }

    public string Id => "mouse.speed";
    public string Name => "Velocidade do mouse 6/11 (1:1)";
    public TweakCategory Category => TweakCategory.Mouse;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Define a velocidade do ponteiro para 6/11, o unico valor em que 1 pixel " +
        "contado = 1 pixel movido (quando a aceleracao esta desligada). Valores " +
        "diferentes introduzem multiplicacao nao-linear. Jogos com RAW INPUT " +
        "ignoram - util para menus e jogos com WM_MOUSEMOVE.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Painel de Controle -> Mouse -> Opcoes de Ponteiro -> " +
        "mover o slider para o centro (6/11).";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var s = _spi.GetMouseSpeed();
        if (s is null) return Task.FromResult(TweakState.Desconhecido("SPI_GETMOUSESPEED falhou."));
        return Task.FromResult(s.Value == TargetSpeed ? TweakState.Aplicado : TweakState.NaoAplicado);
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var cur = _spi.GetMouseSpeed();
        if (cur is null)
            return TweakResult.Fail("Nao foi possivel ler a velocidade atual (SPI_GETMOUSESPEED).");

        await _backup.SaveAsync(Id, "speed", cur.Value.ToString(), "int", ct);

        var ok = _spi.SetMouseSpeed(TargetSpeed);
        if (!ok) return TweakResult.Fail("SPI_SETMOUSESPEED falhou.", before: cur.Value.ToString());

        var after = _spi.GetMouseSpeed();
        _log.Info($"Tweak:{Id}", $"Velocidade ajustada para {TargetSpeed}.", cur.Value.ToString(), after?.ToString());
        return TweakResult.Ok("Velocidade 6/11 aplicada.", cur.Value.ToString(), after?.ToString());
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "speed", ct);
        var target = TargetSpeed;
        if (b is not null && int.TryParse(b.Value, out var v)) target = v;

        var ok = _spi.SetMouseSpeed(target);
        return ok
            ? TweakResult.Ok($"Restaurado para {target}.", after: target.ToString())
            : TweakResult.Fail("Falha ao restaurar velocidade.");
    }
}
'@

# ---- MouseCurveTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Mouse\MouseCurveTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Mouse;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class MouseCurveTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation XCurve = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "SmoothMouseXCurve", true);
    private static readonly RegLocation YCurve = new(
        Hive.CurrentUser, @"Control Panel\Mouse", "SmoothMouseYCurve", true);

    private static readonly byte[] DefaultX = new byte[]
    {
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0xC0,0xCC,0x0C,0x00,0x00,0x00,0x00,0x00,
        0x80,0x99,0x19,0x00,0x00,0x00,0x00,0x00,
        0x40,0x66,0x26,0x00,0x00,0x00,0x00,0x00,
        0x00,0x33,0x33,0x00,0x00,0x00,0x00,0x00
    };

    private static readonly byte[] DefaultY = new byte[]
    {
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x38,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x70,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0xA8,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0xE0,0x00,0x00,0x00,0x00,0x00
    };

    public MouseCurveTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "mouse.curve";
    public string Name => "Restaurar curvas SmoothMouseX/Y padrao do Windows";
    public TweakCategory Category => TweakCategory.Mouse;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Restaura SmoothMouseXCurve e SmoothMouseYCurve para os valores originais do " +
        "Windows. Essas curvas so afetam o comportamento quando a aceleracao esta " +
        "LIGADA. Ferramentas de tweak antigas substituiam essas curvas para simular " +
        "\"aceleracao mais suave\", e o resultado ficava torto. Aqui garantimos estado " +
        "limpo.";

    public string HowToUndo =>
        "Reverter pelo painel restaura o que estava antes (se havia sido alterado). " +
        "Se nada estava alterado, o tweak nao faz mudanca.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var x = _reg.ReadValue(XCurve) as byte[];
        var y = _reg.ReadValue(YCurve) as byte[];

        if (x is null || y is null)
            return Task.FromResult(TweakState.Desconhecido("Curvas ausentes no registro."));

        bool xOk = x.Length == DefaultX.Length && x.AsSpan().SequenceEqual(DefaultX);
        bool yOk = y.Length == DefaultY.Length && y.AsSpan().SequenceEqual(DefaultY);

        if (xOk && yOk) return Task.FromResult(TweakState.Aplicado);
        if (!xOk && !yOk) return Task.FromResult(TweakState.NaoAplicado);
        return Task.FromResult(TweakState.Parcial("Apenas uma das curvas esta fora do padrao."));
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var xb = _reg.ReadValue(XCurve) as byte[];
        var yb = _reg.ReadValue(YCurve) as byte[];

        await _backup.SaveAsync(Id, "x", xb is null ? "<ausente>" : Convert.ToHexString(xb), "bytes", ct);
        await _backup.SaveAsync(Id, "y", yb is null ? "<ausente>" : Convert.ToHexString(yb), "bytes", ct);

        _reg.WriteValue(XCurve, DefaultX, RegistryValueKind.Binary);
        _reg.WriteValue(YCurve, DefaultY, RegistryValueKind.Binary);

        _log.Info($"Tweak:{Id}", "Curvas restauradas ao padrao.");
        return TweakResult.Ok("Curvas restauradas ao padrao do Windows.");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var x = await _backup.LoadAsync(Id, "x", ct);
        var y = await _backup.LoadAsync(Id, "y", ct);

        RestoreCurve(XCurve, x);
        RestoreCurve(YCurve, y);

        _log.Info($"Tweak:{Id}", "Curvas revertidas.");
        return TweakResult.Ok("Curvas revertidas.");
    }

    private void RestoreCurve(RegLocation loc, BackupEntry? entry)
    {
        if (entry is null || entry.Value == "<ausente>")
        {
            _reg.DeleteValue(loc);
            return;
        }
        try
        {
            var bytes = Convert.FromHexString(entry.Value);
            _reg.WriteValue(loc, bytes, RegistryValueKind.Binary);
        }
        catch (Exception ex)
        {
            _log.Error($"Tweak:{Id}", "Falha ao restaurar curva.", ex);
        }
    }
}
'@

# =====================================================================
# CORE — Tweaks: Keyboard
# =====================================================================

Write-Host "Core: Tweaks (Keyboard)..." -ForegroundColor Yellow

# ---- KeyboardDelayTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Keyboard\KeyboardDelayTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Keyboard;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class KeyboardDelayTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation Loc = new(
        Hive.CurrentUser, @"Control Panel\Keyboard", "KeyboardDelay", true);

    private const string TargetValue = "0";
    private const string WindowsDefault = "1";

    public KeyboardDelayTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "kbd.delay";
    public string Name => "Reduzir atraso antes da repeticao de tecla";
    public TweakCategory Category => TweakCategory.Keyboard;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Define KeyboardDelay = 0 (~250 ms), o menor tempo que o Windows espera antes " +
        "de comecar a repetir uma tecla mantida pressionada. Nao afeta o jogo em si, " +
        "mas melhora digitacao e menus.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Painel de Controle -> Teclado.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var v = _reg.ReadValue(Loc)?.ToString();
        if (v is null) return Task.FromResult(TweakState.Desconhecido("Valor ausente no registro."));
        return Task.FromResult(v == TargetValue ? TweakState.Aplicado : TweakState.NaoAplicado);
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var before = _reg.ReadValue(Loc)?.ToString() ?? "<ausente>";
        await _backup.SaveAsync(Id, "delay", before, "REG_SZ", ct);

        try
        {
            _reg.WriteValue(Loc, TargetValue, RegistryValueKind.String);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao gravar KeyboardDelay.", ex, before);
        }

        _log.Info($"Tweak:{Id}", "KeyboardDelay ajustado.", before, TargetValue);
        return TweakResult.Ok("Atraso reduzido.", before, TargetValue);
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "delay", ct);
        var target = b?.Value ?? WindowsDefault;

        try
        {
            _reg.WriteValue(Loc, target, RegistryValueKind.String);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao restaurar KeyboardDelay.", ex);
        }

        _log.Info($"Tweak:{Id}", "KeyboardDelay restaurado.", before: TargetValue, after: target);
        return TweakResult.Ok("Restaurado.", before: TargetValue, after: target);
    }
}
'@

# ---- KeyboardSpeedTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Keyboard\KeyboardSpeedTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Keyboard;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;
using Microsoft.Win32;

public sealed class KeyboardSpeedTweak : ITweak
{
    private readonly IRegistryAccessor _reg;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    private static readonly RegLocation Loc = new(
        Hive.CurrentUser, @"Control Panel\Keyboard", "KeyboardSpeed", true);

    private const string TargetValue = "31";
    private const string WindowsDefault = "31";

    public KeyboardSpeedTweak(IRegistryAccessor reg, IBackupManager backup, ILogger log)
    {
        _reg = reg; _backup = backup; _log = log;
    }

    public string Id => "kbd.speed";
    public string Name => "Aumentar taxa de repeticao de tecla";
    public TweakCategory Category => TweakCategory.Keyboard;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Define KeyboardSpeed = 31, a taxa maxima de repeticao do Windows (~30 Hz). " +
        "Na maioria das instalacoes Win10/11 esse ja e o padrao.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Painel de Controle -> Teclado.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var v = _reg.ReadValue(Loc)?.ToString();
        if (v is null) return Task.FromResult(TweakState.Desconhecido("Valor ausente no registro."));
        return Task.FromResult(v == TargetValue ? TweakState.Aplicado : TweakState.NaoAplicado);
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var before = _reg.ReadValue(Loc)?.ToString() ?? "<ausente>";
        await _backup.SaveAsync(Id, "speed", before, "REG_SZ", ct);

        try
        {
            _reg.WriteValue(Loc, TargetValue, RegistryValueKind.String);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao gravar KeyboardSpeed.", ex, before);
        }

        _log.Info($"Tweak:{Id}", "KeyboardSpeed ajustado.", before, TargetValue);
        return TweakResult.Ok("Taxa de repeticao ajustada.", before, TargetValue);
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "speed", ct);
        var target = b?.Value ?? WindowsDefault;

        try
        {
            _reg.WriteValue(Loc, target, RegistryValueKind.String);
        }
        catch (Exception ex)
        {
            return TweakResult.Fail("Falha ao restaurar KeyboardSpeed.", ex);
        }

        _log.Info($"Tweak:{Id}", "KeyboardSpeed restaurado.", before: TargetValue, after: target);
        return TweakResult.Ok("Restaurado.", before: TargetValue, after: target);
    }
}
'@

# ---- AccessibilityHotkeysTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Keyboard\AccessibilityHotkeysTweak.cs" @'
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
    public string Name => "Desativar atalhos de acessibilidade (Sticky/Filter/Toggle)";
    public TweakCategory Category => TweakCategory.Keyboard;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Desliga os gatilhos de teclado dos recursos de acessibilidade: Sticky Keys " +
        "(Shift 5x), Filter Keys (Shift direito 8s) e Toggle Keys (Num Lock 5s). " +
        "Esses atalhos abrem uma janela no meio do jogo. As FUNCOES em si continuam " +
        "disponiveis em Configuracoes -> Acessibilidade; so o atalho de teclado e " +
        "removido.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Configuracoes -> Acessibilidade -> Teclado -> " +
        "reativar cada atalho individualmente.";

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
'@

# =====================================================================
# CORE — Tweaks: Power
# =====================================================================

Write-Host "Core: Tweaks (Power)..." -ForegroundColor Yellow

# ---- CustomPowerPlanTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Power\CustomPowerPlanTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Power;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class CustomPowerPlanTweak : ITweak
{
    private readonly IPowerPlanService _power;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public CustomPowerPlanTweak(IPowerPlanService power, IBackupManager backup, ILogger log)
    {
        _power = power; _backup = backup; _log = log;
    }

    public string Id => "power.customplan";
    public string Name => "Criar e ativar plano de energia \"FPS Panel - Performance\"";
    public TweakCategory Category => TweakCategory.Power;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => true;
    public bool RequiresReboot => false;

    public string Description =>
        "Cria um plano de energia NOVO (derivado do Alto Desempenho), chamado " +
        "\"FPS Panel - Performance\", e o ativa. O plano original do Windows NAO e " +
        "alterado nem removido. Em notebooks, isso aumenta consumo de bateria e " +
        "aquecimento enquanto estiver ativo.";

    public string HowToUndo =>
        "Reverter pelo painel reativa o plano anterior. Voce tambem pode abrir " +
        "powercfg.cpl e escolher manualmente outro plano a qualquer momento.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var customGuid = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (customGuid is null) return TweakState.NaoAplicado;

        var active = await _power.GetActivePlanGuidAsync(ct);
        if (active is null) return TweakState.Desconhecido("Nao foi possivel ler o plano ativo.");
        return active.Value == customGuid.Value
            ? TweakState.Aplicado
            : TweakState.Parcial("Plano existe, mas nao e o ativo.");
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var previous = await _power.GetActivePlanGuidAsync(ct);
        if (previous is null)
            return TweakResult.Fail("Nao foi possivel ler o plano ativo atual.");

        await _backup.SaveAsync(Id, "previous", previous.Value.ToString(), "guid", ct);

        if (!await _power.EnsureCustomPlanAsync(ct))
            return TweakResult.Fail("Falha ao criar plano customizado.", before: previous.Value.ToString());

        var customGuid = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (customGuid is null)
            return TweakResult.Fail("Plano criado mas GUID nao encontrado.", before: previous.Value.ToString());

        await _backup.SaveAsync(Id, "custom", customGuid.Value.ToString(), "guid", ct);

        if (!await _power.ActivateAsync(customGuid.Value, ct))
            return TweakResult.Fail("Falha ao ativar plano customizado.", before: previous.Value.ToString());

        _log.Info($"Tweak:{Id}", "Plano customizado ativado.", previous.Value.ToString(), customGuid.Value.ToString());
        return TweakResult.Ok("Plano ativado.", previous.Value.ToString(), customGuid.Value.ToString());
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "previous", ct);
        if (b is null || !Guid.TryParse(b.Value, out var previousGuid))
            return TweakResult.Fail("Sem backup do plano anterior. Reative manualmente via powercfg.cpl.");

        var ok = await _power.ActivateAsync(previousGuid, ct);
        if (!ok) return TweakResult.Fail("Falha ao reativar plano anterior.");

        _log.Info($"Tweak:{Id}", "Plano anterior reativado.", after: previousGuid.ToString());
        return TweakResult.Ok("Plano anterior reativado.", after: previousGuid.ToString());
    }
}
'@

# ---- UsbSuspendTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Power\UsbSuspendTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Power;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class UsbSuspendTweak : ITweak
{
    private readonly IPowerPlanService _power;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public UsbSuspendTweak(IPowerPlanService power, IBackupManager backup, ILogger log)
    {
        _power = power; _backup = backup; _log = log;
    }

    public string Id => "power.usbsuspend";
    public string Name => "Desligar suspensao seletiva USB (na tomada)";
    public TweakCategory Category => TweakCategory.Power;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => true;
    public bool RequiresReboot => false;

    public string Description =>
        "Desativa a Suspensao Seletiva USB no plano customizado, na TOMADA. Evita " +
        "que dispositivos USB (mouse, teclado, headset) entrem em suspensao e " +
        "acordem com micro-atraso. Na BATERIA, mantemos ligado para nao drenar. " +
        "So e aplicado no plano \"FPS Panel - Performance\" - seu plano original fica " +
        "intocado.";

    public string HowToUndo =>
        "Reverter pelo painel reativa o valor original no plano customizado.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var plan = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (plan is null) return TweakState.NaoAplicavel;

        var ac = await _power.GetSettingAsync(
            plan.Value, PowerGuids.SubUsbSettings, PowerGuids.SettingUsbSuspend, onAc: true, ct);

        return ac switch
        {
            PowerSettingValue.Off => TweakState.Aplicado,
            PowerSettingValue.On  => TweakState.NaoAplicado,
            _ => TweakState.Desconhecido("Nao foi possivel ler configuracao USB.")
        };
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var plan = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (plan is null)
            return TweakResult.Fail("Plano customizado nao existe. Aplique primeiro o ajuste \"power.customplan\".");

        var acBefore = await _power.GetSettingAsync(
            plan.Value, PowerGuids.SubUsbSettings, PowerGuids.SettingUsbSuspend, onAc: true, ct);

        await _backup.SaveAsync(Id, "acBefore", acBefore.ToString(), "enum", ct);
        await _backup.SaveAsync(Id, "planGuid", plan.Value.ToString(), "guid", ct);

        var ok = await _power.SetSettingEnabledAsync(
            plan.Value, PowerGuids.SubUsbSettings, PowerGuids.SettingUsbSuspend,
            onAc: false, onDc: true, ct);

        if (!ok) return TweakResult.Fail("Falha ao aplicar configuracao USB.", before: acBefore.ToString());

        _log.Info($"Tweak:{Id}", "USB selective suspend desligado em AC.", acBefore.ToString(), "Off");
        return TweakResult.Ok("USB suspend desligado na tomada.", acBefore.ToString(), "Off");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "planGuid", ct);
        var plan = b is not null && Guid.TryParse(b.Value, out var g)
            ? g
            : await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct) ?? Guid.Empty;
        if (plan == Guid.Empty) return TweakResult.Fail("Plano customizado nao encontrado.");

        var acB = await _backup.LoadAsync(Id, "acBefore", ct);
        bool onAc = acB?.Value == nameof(PowerSettingValue.On);

        var ok = await _power.SetSettingEnabledAsync(
            plan, PowerGuids.SubUsbSettings, PowerGuids.SettingUsbSuspend,
            onAc: onAc, onDc: true, ct);

        return ok
            ? TweakResult.Ok($"Restaurado (AC={(onAc ? "On" : "Off")}).")
            : TweakResult.Fail("Falha ao restaurar USB.");
    }
}
'@

# ---- PcieAspmTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Power\PcieAspmTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Power;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class PcieAspmTweak : ITweak
{
    private readonly IPowerPlanService _power;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public PcieAspmTweak(IPowerPlanService power, IBackupManager backup, ILogger log)
    {
        _power = power; _backup = backup; _log = log;
    }

    public string Id => "power.pcieaspm";
    public string Name => "Desligar PCIe ASPM (na tomada)";
    public TweakCategory Category => TweakCategory.Power;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => true;
    public bool RequiresReboot => false;

    public string Description =>
        "Desativa o gerenciamento de energia de estados ativos do barramento PCI " +
        "Express no plano customizado, na TOMADA. Em algumas placas-mae e GPUs isso " +
        "reduz micro-oscilacoes de latencia; em muitas outras e imperceptivel. " +
        "Aplicado somente no plano \"FPS Panel - Performance\".";

    public string HowToUndo =>
        "Reverter pelo painel reativa o valor original.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var plan = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (plan is null) return TweakState.NaoAplicavel;

        var ac = await _power.GetSettingAsync(
            plan.Value, PowerGuids.SubPcie, PowerGuids.SettingPcieAspm, onAc: true, ct);

        return ac switch
        {
            PowerSettingValue.Off => TweakState.Aplicado,
            PowerSettingValue.On  => TweakState.NaoAplicado,
            _ => TweakState.Desconhecido("Nao foi possivel ler configuracao PCIe.")
        };
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var plan = await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct);
        if (plan is null)
            return TweakResult.Fail("Plano customizado nao existe. Aplique primeiro o ajuste \"power.customplan\".");

        var acBefore = await _power.GetSettingAsync(
            plan.Value, PowerGuids.SubPcie, PowerGuids.SettingPcieAspm, onAc: true, ct);

        await _backup.SaveAsync(Id, "acBefore", acBefore.ToString(), "enum", ct);
        await _backup.SaveAsync(Id, "planGuid", plan.Value.ToString(), "guid", ct);

        var ok = await _power.SetSettingEnabledAsync(
            plan.Value, PowerGuids.SubPcie, PowerGuids.SettingPcieAspm,
            onAc: false, onDc: true, ct);

        if (!ok) return TweakResult.Fail("Falha ao aplicar configuracao PCIe.", before: acBefore.ToString());

        _log.Info($"Tweak:{Id}", "PCIe ASPM desligado em AC.", acBefore.ToString(), "Off");
        return TweakResult.Ok("PCIe ASPM desligado na tomada.", acBefore.ToString(), "Off");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "planGuid", ct);
        var plan = b is not null && Guid.TryParse(b.Value, out var g)
            ? g
            : await _power.FindPlanGuidByNameAsync(PowerPlanService.CustomPlanName, ct) ?? Guid.Empty;
        if (plan == Guid.Empty) return TweakResult.Fail("Plano customizado nao encontrado.");

        var acB = await _backup.LoadAsync(Id, "acBefore", ct);
        bool onAc = acB?.Value == nameof(PowerSettingValue.On);

        var ok = await _power.SetSettingEnabledAsync(
            plan, PowerGuids.SubPcie, PowerGuids.SettingPcieAspm,
            onAc: onAc, onDc: true, ct);

        return ok
            ? TweakResult.Ok($"Restaurado (AC={(onAc ? "On" : "Off")}).")
            : TweakResult.Fail("Falha ao restaurar PCIe.");
    }
}
'@

# =====================================================================
# CORE — Tweaks: Games
# =====================================================================

Write-Host "Core: Tweaks (Games)..." -ForegroundColor Yellow

# ---- GameModeTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Games\GameModeTweak.cs" @'
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
        "Liga o Modo Jogo nativo do Windows. Ele suprime notificacoes e prioriza o " +
        "jogo em primeiro plano. Impacto MARGINAL e SITUACIONAL: em alguns jogos ajuda " +
        "na consistencia de frametime; em outros, especialmente com overlays de " +
        "terceiros, a propria Microsoft ja reconheceu que pode atrapalhar.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Configuracoes -> Jogos -> Modo Jogo -> desligar.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var a = _reg.ReadValue(AutoGameMode);
        var b = _reg.ReadValue(AllowAutoGameMode);
        if (a is null || b is null) return TweakState.NaoAplicado;

        var av = Convert.ToInt32(a);
        var bv = Convert.ToInt32(b);
        if (av == 1 && bv == 1) return TweakState.Aplicado;
        if (av == 0 && bv == 0) return TweakState.NaoAplicado;
        return TweakState.Parcial("Apenas um dos dois valores esta ligado.");
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
        return TweakResult.Ok("Modo Jogo revertido (ou deixado no padrao).");
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
'@

# ---- GameDvrTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Games\GameDvrTweak.cs" @'
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
        "Isso libera CPU, GPU e disco que o Windows usaria para gravar clipes. " +
        "Impacto MENSURAVEL quando a captura estava ativa. Voce perde o botao " +
        "\"gravar os ultimos 30s\" - se usa isso, nao aplique.";

    public string HowToUndo =>
        "Reverter pelo painel, ou: Configuracoes -> Jogos -> Capturas -> reativar.";

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
'@

# ---- MmcssTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Games\MmcssTweak.cs" @'
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
        "Ajusta o perfil MMCSS \"Games\" para Priority=6, Scheduling Category=High " +
        "e SFIO Priority=High. MMCSS e o servico multimidia do Windows; ele reserva " +
        "CPU para threads registradas. Impacto SITUACIONAL: so muda algo em jogos que " +
        "registram threads via MMCSS. Requer REINICIO para ter efeito.";

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
            return TweakResult.Fail("Falha ao aplicar MMCSS. Painel precisa estar elevado (admin).", ex);
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
'@

# ---- Win32PrioritySeparationTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Games\Win32PrioritySeparationTweak.cs" @'
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
    public string Name => "Win32PrioritySeparation = 0x26 (foreground com quantum curto)";
    public TweakCategory Category => TweakCategory.Games;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Medio;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => true;

    public string Description =>
        "Define Win32PrioritySeparation = 0x26 (38), que da ao processo em primeiro " +
        "plano quantum curto e variavel. Impacto SITUACIONAL: em PCs com poucos nucleos " +
        "e multitarefa, tende a ajudar; em PCs com muitos nucleos e carga leve, e " +
        "imperceptivel. Risco MEDIO: afeta o escalonador global do Windows. Requer " +
        "reinicio.";

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
'@

# ---- FullscreenOptimizationsTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Games\FullscreenOptimizationsTweak.cs" @'
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
        "Desativa o FSO (Fullscreen Optimizations) do Windows para os executaveis " +
        "escolhidos. Isso faz o jogo usar tela cheia EXCLUSIVA de verdade em vez de " +
        "janela maximizada sem borda. Efeito MENSURAVEL: reduz o input lag em jogos " +
        "que respeitam o modo exclusivo. Voce precisa escolher os .exe (nao e global). " +
        "Feche e reabra o jogo apos aplicar.";

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
'@

Write-Host "  Tweaks (Mouse/Keyboard/Power/Games) OK." -ForegroundColor DarkGray
Write-Host ""# =====================================================================
# CORE — Tweaks: Network
# =====================================================================

Write-Host "Core: Tweaks (Network)..." -ForegroundColor Yellow

# ---- AutotuningTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Network\AutotuningTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Network;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class AutotuningTweak : ITweak
{
    private readonly INetworkService _net;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public AutotuningTweak(INetworkService net, IBackupManager backup, ILogger log)
    {
        _net = net; _backup = backup; _log = log;
    }

    public string Id => "net.autotuning";
    public string Name => "TCP autotuning no nivel \"Normal\"";
    public TweakCategory Category => TweakCategory.Network;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Garante que o ajuste automatico da janela TCP esteja em \"Normal\", que e o " +
        "padrao do Windows 10/11. Ferramentas antigas de otimizacao costumavam " +
        "desativar isso, o que PIORA throughput em links com latencia. NAO aumenta a " +
        "velocidade da internet.";

    public string HowToUndo =>
        "Reverter pelo painel reaplica o valor original.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var lvl = await _net.GetAutotuningAsync(ct);
        return lvl switch
        {
            AutotuningLevel.Normal => TweakState.Aplicado,
            AutotuningLevel.Unknown => TweakState.Desconhecido("Nao foi possivel ler autotuning."),
            _ => TweakState.NaoAplicado
        };
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var before = await _net.GetAutotuningAsync(ct);
        await _backup.SaveAsync(Id, "level", before.ToString(), "enum", ct);

        if (!await _net.SetAutotuningAsync(AutotuningLevel.Normal, ct))
            return TweakResult.Fail("Falha ao definir autotuninglevel=normal. Painel precisa estar elevado.",
                before: before.ToString());

        var after = await _net.GetAutotuningAsync(ct);
        _log.Info($"Tweak:{Id}", "Autotuning = Normal.", before.ToString(), after.ToString());
        return TweakResult.Ok("Autotuning definido como Normal.", before.ToString(), after.ToString());
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var b = await _backup.LoadAsync(Id, "level", ct);
        var target = AutotuningLevel.Normal;
        if (b is not null && Enum.TryParse<AutotuningLevel>(b.Value, out var parsed))
            target = parsed;

        if (!await _net.SetAutotuningAsync(target, ct))
            return TweakResult.Fail($"Falha ao restaurar {target}.");

        _log.Info($"Tweak:{Id}", $"Autotuning restaurado para {target}.");
        return TweakResult.Ok($"Autotuning restaurado para {target}.");
    }
}
'@

# ---- RssTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Network\RssTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Network;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class RssTweak : ITweak
{
    private readonly INetworkService _net;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public RssTweak(INetworkService net, IBackupManager backup, ILogger log)
    {
        _net = net; _backup = backup; _log = log;
    }

    public string Id => "net.rss";
    public string Name => "Habilitar RSS (Receive Side Scaling)";
    public TweakCategory Category => TweakCategory.Network;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Habilita o Receive Side Scaling, que distribui o processamento de pacotes " +
        "de rede por varios nucleos de CPU. Em links Gigabit ou mais rapidos com " +
        "muita carga, ajuda a evitar que um unico nucleo vire gargalo. Em links " +
        "domesticos tipicos, impacto e imperceptivel. NAO aumenta a velocidade da " +
        "internet.";

    public string HowToUndo =>
        "Reverter pelo painel restaura o valor anterior.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null) return TweakState.NaoAplicavel;

        var rss = await _net.GetRssAsync(physical.Name, ct);
        if (rss is null) return TweakState.Desconhecido("Nao foi possivel ler RSS.");
        return rss.Value ? TweakState.Aplicado : TweakState.NaoAplicado;
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null)
            return TweakResult.Fail("Nenhum adaptador fisico ativo encontrado.");

        var before = await _net.GetRssAsync(physical.Name, ct);
        await _backup.SaveAsync(Id, "rss", (before ?? true).ToString(), "bool", ct);

        if (!await _net.SetRssAsync(physical.Name, true, ct))
            return TweakResult.Fail("Falha ao habilitar RSS.", before: before?.ToString());

        _log.Info($"Tweak:{Id}", "RSS habilitado.", before?.ToString(), "True");
        return TweakResult.Ok("RSS habilitado.", before?.ToString(), "True");
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null) return TweakResult.Fail("Nenhum adaptador fisico ativo.");

        var b = await _backup.LoadAsync(Id, "rss", ct);
        bool target = true;
        if (b is not null && bool.TryParse(b.Value, out var v)) target = v;

        if (!await _net.SetRssAsync(physical.Name, target, ct))
            return TweakResult.Fail($"Falha ao restaurar RSS para {target}.");

        return TweakResult.Ok($"RSS restaurado para {target}.");
    }
}
'@

# ---- DnsTweak.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Network\DnsTweak.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Network;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public enum DnsProvider { Cloudflare, Google, Automatic }

public sealed class DnsTweak : ITweak
{
    private readonly INetworkService _net;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public DnsProvider Provider { get; set; } = DnsProvider.Cloudflare;

    private static readonly string[] CloudflareServers = { "1.1.1.1", "1.0.0.1" };
    private static readonly string[] GoogleServers     = { "8.8.8.8", "8.8.4.4" };

    public DnsTweak(INetworkService net, IBackupManager backup, ILogger log)
    {
        _net = net; _backup = backup; _log = log;
    }

    public string Id => "net.dns";
    public string Name => "Trocar DNS do adaptador ativo";
    public TweakCategory Category => TweakCategory.Network;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Troca o servidor DNS do adaptador de rede fisico ativo. DNS afeta o tempo " +
        "para RESOLVER nomes (ex: \"google.com\" -> IP), nao a velocidade do download. " +
        "Nao aumenta Mbps.";

    public string HowToUndo =>
        "Reverter pelo painel restaura o DNS anterior.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null) return TweakState.NaoAplicavel;

        var current = await _net.GetDnsServersAsync(physical.Name, ct);
        if (current.Count == 0) return TweakState.NaoAplicado;

        var target = ServersFor(Provider);
        if (target is null) return TweakState.NaoAplicavel;

        return current.SequenceEqual(target) ? TweakState.Aplicado : TweakState.NaoAplicado;
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var adapters = await _net.GetActiveAdaptersAsync(ct);
        var physical = adapters.FirstOrDefault(a => a.IsPhysical);
        if (physical is null)
            return TweakResult.Fail("Nenhum adaptador fisico ativo.");

        var before = await _net.GetDnsServersAsync(physical.Name, ct);
        await _backup.SaveAsync(Id, "adapterId", physical.Id, "string", ct);
        await _backup.SaveAsync(Id, "adapterName", physical.Name, "string", ct);
        await _backup.SaveAsync(Id, "before", string.Join(",", before), "csv", ct);
        await _backup.SaveAsync(Id, "beforeEmpty", (before.Count == 0 ? "1" : "0"), "flag", ct);

        if (Provider == DnsProvider.Automatic)
        {
            var okReset = await _net.ResetDnsServersAsync(physical.Name, ct);
            return okReset
                ? TweakResult.Ok("DNS restaurado para automatico.", string.Join(",", before), "DHCP")
                : TweakResult.Fail("Falha ao restaurar DNS automatico.");
        }

        var target = ServersFor(Provider);
        if (target is null) return TweakResult.Fail("Provedor DNS invalido.");

        var ok = await _net.SetDnsServersAsync(physical.Name, target, ct);
        if (!ok) return TweakResult.Fail("Falha ao definir DNS.", before: string.Join(",", before));

        _log.Info($"Tweak:{Id}", $"DNS definido para {Provider}.",
            string.Join(",", before), string.Join(",", target));
        return TweakResult.Ok($"DNS definido para {Provider}.", string.Join(",", before), string.Join(",", target));
    }

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var nameB = await _backup.LoadAsync(Id, "adapterName", ct);
        var wasEmptyB = await _backup.LoadAsync(Id, "beforeEmpty", ct);
        var beforeB = await _backup.LoadAsync(Id, "before", ct);

        if (nameB is null)
            return TweakResult.Fail("Sem backup do adaptador. Restaure DNS manualmente.");

        if (wasEmptyB?.Value == "1")
        {
            var ok = await _net.ResetDnsServersAsync(nameB.Value, ct);
            return ok
                ? TweakResult.Ok("DNS restaurado para automatico.")
                : TweakResult.Fail("Falha ao restaurar DNS automatico.");
        }

        if (beforeB is null || string.IsNullOrWhiteSpace(beforeB.Value))
            return TweakResult.Fail("Backup de DNS invalido.");

        var servers = beforeB.Value.Split(',', StringSplitOptions.RemoveEmptyEntries);
        var ok2 = await _net.SetDnsServersAsync(nameB.Value, servers, ct);
        return ok2
            ? TweakResult.Ok($"DNS restaurado ({beforeB.Value}).")
            : TweakResult.Fail("Falha ao restaurar DNS.");
    }

    private string[]? ServersFor(DnsProvider p) => p switch
    {
        DnsProvider.Cloudflare => CloudflareServers,
        DnsProvider.Google     => GoogleServers,
        DnsProvider.Automatic  => null,
        _ => null
    };
}
'@

# =====================================================================
# CORE — Tweaks: Cleanup
# =====================================================================

Write-Host "Core: Tweaks (Cleanup)..." -ForegroundColor Yellow

# ---- TempFilesCleanup.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Cleanup\TempFilesCleanup.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Cleanup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class TempFilesCleanup : ITweak
{
    private readonly IFileSystemService _fs;
    private readonly ILogger _log;

    public TempFilesCleanup(IFileSystemService fs, ILogger log)
    {
        _fs = fs; _log = log;
    }

    public string Id => "clean.temp";
    public string Name => "Limpar arquivos temporarios";
    public TweakCategory Category => TweakCategory.Cleanup;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public string Description =>
        "Apaga arquivos temporarios do usuario (%TEMP%), do Windows " +
        "(C:\\Windows\\Temp) e do LocalAppData. Arquivos em uso sao PULADOS, nao " +
        "forcados - nada quebra por estar aberto. Impacto MENSURAVEL em espaco em " +
        "disco; em FPS, so e sentido em SSD quase cheio.";

    public string HowToUndo =>
        "Nao ha como restaurar arquivos temporarios apagados.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var total = Targets().Sum(t => _fs.MeasureBytes(t.path));
        return Task.FromResult(total < 100L * 1024 * 1024
            ? TweakState.Aplicado
            : TweakState.NaoAplicado);
    }

    public Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var results = new List<CleanupTargetResult>();
        foreach (var (label, path) in Targets())
        {
            try { results.Add(_fs.CleanDirectory(label, path, ct)); }
            catch (Exception ex)
            {
                _log.Error($"Tweak:{Id}", $"Falha em {label}.", ex);
            }
        }

        long total = results.Sum(r => r.BytesFreed);
        int files = results.Sum(r => r.FilesDeleted);
        int skipped = results.Sum(r => r.FilesSkipped);

        var summary = $"Liberado: {FormatBytes(total)} em {files} arquivos " +
                      $"(pulados: {skipped}).";
        _log.Info($"Tweak:{Id}", summary);
        return Task.FromResult(TweakResult.Ok(summary));
    }

    public Task<TweakResult> RevertAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped(
            "Limpeza e irreversivel por natureza. Nada a restaurar."));

    private static IEnumerable<(string label, string path)> Targets()
    {
        yield return ("TEMP do usuario", Path.GetTempPath().TrimEnd('\\'));
        yield return ("LocalAppData\\Temp",
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Temp"));
        yield return ("Windows\\Temp",
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Windows), "Temp"));
    }

    internal static string FormatBytes(long bytes)
    {
        string[] units = { "B", "KB", "MB", "GB", "TB" };
        double v = bytes;
        int u = 0;
        while (v >= 1024 && u < units.Length - 1) { v /= 1024; u++; }
        return $"{v:0.##} {units[u]}";
    }
}
'@

# ---- ShaderCacheCleanup.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Cleanup\ShaderCacheCleanup.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Cleanup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class ShaderCacheCleanup : ITweak
{
    private readonly IFileSystemService _fs;
    private readonly IEnvironmentDetector _env;
    private readonly ILogger _log;

    public ShaderCacheCleanup(IFileSystemService fs, IEnvironmentDetector env, ILogger log)
    {
        _fs = fs; _env = env; _log = log;
    }

    public string Id => "clean.shader";
    public string Name => "Limpar cache de shaders (DirectX / NVIDIA / AMD)";
    public TweakCategory Category => TweakCategory.Cleanup;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Apaga o cache de shaders compilados (DirectX, NVIDIA DXCache/GLCache, AMD). " +
        "Util quando ha corrupcao de cache causando artefatos ou crashes, ou apos " +
        "atualizacao de driver. AVISO: o jogo vai RECOMPILAR shaders no proximo " +
        "lancamento - espere alguns segundos de stutter na primeira partida. Em HDD, " +
        "o tweak e recusado.";

    public string HowToUndo =>
        "Nao ha backup. O cache e recriado automaticamente pelos drivers.";

    public async Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var env = await _env.DetectAsync(ct);
        if (env.SystemDiskKind == DiskKind.Hdd)
            return TweakState.NaoAplicavel;

        var total = Targets().Where(t => Directory.Exists(t.path)).Sum(t => _fs.MeasureBytes(t.path));
        return total < 500L * 1024 * 1024
            ? TweakState.Aplicado
            : TweakState.NaoAplicado;
    }

    public async Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var env = await _env.DetectAsync(ct);
        if (env.SystemDiskKind == DiskKind.Hdd)
            return TweakResult.Fail("Cache de shader e ignorado em HDD: recompilacao piora a experiencia.");

        var results = new List<CleanupTargetResult>();
        foreach (var (label, path) in Targets())
        {
            if (!Directory.Exists(path)) continue;
            try { results.Add(_fs.CleanDirectory(label, path, ct)); }
            catch (Exception ex) { _log.Error($"Tweak:{Id}", $"Falha em {label}.", ex); }
        }

        long total = results.Sum(r => r.BytesFreed);
        var summary = $"Liberado: {TempFilesCleanup.FormatBytes(total)}. " +
                      $"Recompilacao de shaders ocorrera no proximo lancamento.";
        _log.Info($"Tweak:{Id}", summary);
        return TweakResult.Ok(summary);
    }

    public Task<TweakResult> RevertAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped(
            "Limpeza e irreversivel. O cache e reconstruido pelo driver automaticamente."));

    private static IEnumerable<(string label, string path)> Targets()
    {
        var local = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);

        yield return ("D3DSCache", Path.Combine(local, "D3DSCache"));
        yield return ("NVIDIA DXCache", Path.Combine(local, "NVIDIA", "DXCache"));
        yield return ("NVIDIA GLCache", Path.Combine(local, "NVIDIA", "GLCache"));
        yield return ("AMD DxCache", Path.Combine(local, "AMD", "DxCache"));
        yield return ("AMD DxcCache", Path.Combine(local, "AMD", "DxcCache"));
        yield return ("AMD GLCache", Path.Combine(local, "AMD", "GLCache"));
    }
}
'@

# ---- BrowserCacheCleanup.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Cleanup\BrowserCacheCleanup.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Cleanup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class BrowserCacheCleanup : ITweak
{
    private readonly IFileSystemService _fs;
    private readonly ILogger _log;

    public BrowserCacheCleanup(IFileSystemService fs, ILogger log)
    {
        _fs = fs; _log = log;
    }

    public string Id => "clean.browser";
    public string Name => "Limpar cache de navegadores (Chrome / Edge / Firefox)";
    public TweakCategory Category => TweakCategory.Cleanup;
    public ExpectedImpact Impact => ExpectedImpact.Marginal;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Apaga APENAS as pastas de cache (Cache, Cache2, Code Cache, GPUCache) de " +
        "Chrome, Edge e Firefox. NAO toca em cookies, historico, senhas, favoritos ou " +
        "sessoes. Voce continuara logado. Primeiras paginas recarregam mais devagar ate " +
        "o cache reconstruir. Nenhum efeito em FPS.";

    public string HowToUndo =>
        "Nao ha como restaurar. Cache e descartavel por definicao.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var total = Targets().Where(t => Directory.Exists(t.path)).Sum(t => _fs.MeasureBytes(t.path));
        return Task.FromResult(total < 200L * 1024 * 1024
            ? TweakState.Aplicado
            : TweakState.NaoAplicado);
    }

    public Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var results = new List<CleanupTargetResult>();
        foreach (var (label, path) in Targets())
        {
            if (!Directory.Exists(path)) continue;
            try { results.Add(_fs.CleanDirectory(label, path, ct)); }
            catch (Exception ex) { _log.Error($"Tweak:{Id}", $"Falha em {label}.", ex); }
        }

        long total = results.Sum(r => r.BytesFreed);
        var summary = $"Liberado: {TempFilesCleanup.FormatBytes(total)} em cache de navegadores.";
        _log.Info($"Tweak:{Id}", summary);
        return Task.FromResult(TweakResult.Ok(summary));
    }

    public Task<TweakResult> RevertAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped(
            "Limpeza e irreversivel. O cache e reconstruido ao navegar."));

    private static IEnumerable<(string label, string path)> Targets()
    {
        var local = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
        var roaming = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);

        var chrome = Path.Combine(local, "Google", "Chrome", "User Data");
        foreach (var profile in ProfilesOf(chrome, "Default", "Profile 1", "Profile 2", "Profile 3"))
        {
            yield return ($"Chrome {Path.GetFileName(profile)}/Cache", Path.Combine(profile, "Cache"));
            yield return ($"Chrome {Path.GetFileName(profile)}/Code Cache", Path.Combine(profile, "Code Cache"));
            yield return ($"Chrome {Path.GetFileName(profile)}/GPUCache", Path.Combine(profile, "GPUCache"));
        }

        var edge = Path.Combine(local, "Microsoft", "Edge", "User Data");
        foreach (var profile in ProfilesOf(edge, "Default", "Profile 1", "Profile 2", "Profile 3"))
        {
            yield return ($"Edge {Path.GetFileName(profile)}/Cache", Path.Combine(profile, "Cache"));
            yield return ($"Edge {Path.GetFileName(profile)}/Code Cache", Path.Combine(profile, "Code Cache"));
            yield return ($"Edge {Path.GetFileName(profile)}/GPUCache", Path.Combine(profile, "GPUCache"));
        }

        var ffRoot = Path.Combine(roaming, "Mozilla", "Firefox", "Profiles");
        if (Directory.Exists(ffRoot))
        {
            foreach (var profile in Directory.EnumerateDirectories(ffRoot))
            {
                yield return ($"Firefox {Path.GetFileName(profile)}/cache2",
                    Path.Combine(profile, "cache2"));
            }
        }
    }

    private static IEnumerable<string> ProfilesOf(string root, params string[] candidates)
    {
        if (!Directory.Exists(root)) yield break;
        foreach (var c in candidates)
        {
            var p = Path.Combine(root, c);
            if (Directory.Exists(p)) yield return p;
        }
    }
}
'@

# ---- RecycleBinCleanup.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Cleanup\RecycleBinCleanup.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Cleanup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class RecycleBinCleanup : ITweak
{
    private readonly IFileSystemService _fs;
    private readonly ILogger _log;

    public RecycleBinCleanup(IFileSystemService fs, ILogger log)
    {
        _fs = fs; _log = log;
    }

    public string Id => "clean.recyclebin";
    public string Name => "Esvaziar Lixeira";
    public TweakCategory Category => TweakCategory.Cleanup;
    public ExpectedImpact Impact => ExpectedImpact.Mensuravel;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Esvazia a Lixeira. Arquivos apagados por este comando NAO PODEM SER " +
        "RESTAURADOS. Impacto MENSURAVEL em espaco em disco. Nenhum efeito em FPS.";

    public string HowToUndo =>
        "Nao ha como restaurar. A Lixeira e definitiva apos este comando.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
        => Task.FromResult(TweakState.NaoAplicado);

    public Task<TweakResult> ApplyAsync(CancellationToken ct = default)
    {
        var r = _fs.EmptyRecycleBin(ct);
        if (r.Error is not null)
            return Task.FromResult(TweakResult.Fail(r.Error));

        var summary = $"Lixeira esvaziada. Liberado: {TempFilesCleanup.FormatBytes(r.BytesFreed)}.";
        _log.Info($"Tweak:{Id}", summary);
        return Task.FromResult(TweakResult.Ok(summary));
    }

    public Task<TweakResult> RevertAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped("Irreversivel por natureza."));
}
'@

# =====================================================================
# CORE — Tweaks: Startup
# =====================================================================

Write-Host "Core: Tweaks (Startup)..." -ForegroundColor Yellow

# ---- StartupItemsManager.cs ----
Write-File "src\FpsLatencyPanel.Core\Tweaks\Startup\StartupItemsManager.cs" @'
namespace FpsLatencyPanel.Core.Tweaks.Startup;

using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Infrastructure;

public sealed class StartupItemsManager : ITweak
{
    private readonly IStartupService _startup;
    private readonly IBackupManager _backup;
    private readonly ILogger _log;

    public StartupItemsManager(IStartupService startup, IBackupManager backup, ILogger log)
    {
        _startup = startup; _backup = backup; _log = log;
    }

    public string Id => "startup.manager";
    public string Name => "Gerenciar programas de inicializacao";
    public TweakCategory Category => TweakCategory.Startup;
    public ExpectedImpact Impact => ExpectedImpact.Situacional;
    public RiskLevel Risk => RiskLevel.Baixo;
    public bool AffectsLaptop => false;
    public bool RequiresReboot => false;

    public bool IncludeInRecommendedProfile => false;

    public string Description =>
        "Lista os programas que abrem com o Windows (registro Run/Run32 e pastas de " +
        "Inicializacao). VOCE decide o que desativar - o painel NUNCA desativa nada " +
        "sozinho, nem no perfil recomendado. A desativacao usa o mecanismo oficial do " +
        "Windows (StartupApproved, o mesmo que o Gerenciador de Tarefas usa).";

    public string HowToUndo =>
        "Reative cada item pelo painel, ou: Gerenciador de Tarefas -> Inicializar.";

    public Task<TweakState> DetectAsync(CancellationToken ct = default)
    {
        var items = _startup.Enumerate();
        int disabled = items.Count(i => !i.IsEnabled);
        if (items.Count == 0) return Task.FromResult(TweakState.Desconhecido("Nenhum item de inicializacao."));
        if (disabled == 0) return Task.FromResult(TweakState.Aplicado);
        return Task.FromResult(TweakState.Parcial($"{disabled} item(ns) desabilitado(s)."));
    }

    public Task<TweakResult> ApplyAsync(CancellationToken ct = default)
        => Task.FromResult(TweakResult.Skipped(
            "Gerenciamento de inicializacao e sempre manual. Abra a aba Inicializacao."));

    public async Task<TweakResult> RevertAsync(CancellationToken ct = default)
    {
        var items = _startup.Enumerate();
        int reEnabled = 0, failed = 0;

        foreach (var item in items.Where(i => !i.IsEnabled))
        {
            var b = await _backup.LoadAsync(Id, "item:" + item.Id);
            if (b is null) continue;

            if (_startup.Enable(item, out var err))
            {
                reEnabled++;
                _log.Info($"Tweak:{Id}", $"Reativado: {item.Name}");
            }
            else
            {
                failed++;
                _log.Error($"Tweak:{Id}", $"Falha ao reativar {item.Name}: {err}");
            }
        }

        return failed == 0
            ? TweakResult.Ok($"Reativados {reEnabled} item(ns).")
            : TweakResult.Fail($"Reativados {reEnabled}, falha em {failed}.");
    }

    public IReadOnlyList<StartupItem> List() => _startup.Enumerate();

    public async Task<TweakResult> DisableItemAsync(StartupItem item, CancellationToken ct = default)
    {
        if (!item.IsEnabled)
            return TweakResult.Skipped("Item ja esta desativado.");

        await _backup.SaveAsync(Id, "item:" + item.Id, "enabledBefore", "flag", ct);

        if (!_startup.Disable(item, out var err))
            return TweakResult.Fail($"Falha ao desativar {item.Name}: {err}");

        _log.Info($"Tweak:{Id}", $"Desativado: {item.Name}");
        return TweakResult.Ok($"Desativado: {item.Name}.");
    }

    public async Task<TweakResult> EnableItemAsync(StartupItem item, CancellationToken ct = default)
    {
        if (item.IsEnabled)
            return TweakResult.Skipped("Item ja esta ativado.");

        if (!_startup.Enable(item, out var err))
            return TweakResult.Fail($"Falha ao reativar {item.Name}: {err}");

        await _backup.DeleteAsync(Id, "item:" + item.Id, ct);
        _log.Info($"Tweak:{Id}", $"Reativado: {item.Name}");
        return TweakResult.Ok($"Reativado: {item.Name}.");
    }
}
'@

# =====================================================================
# CORE — Licensing
# =====================================================================

Write-Host "Core: Licensing..." -ForegroundColor Yellow

# ---- LicensingConstants.cs ----
Write-File "src\FpsLatencyPanel.Core\Licensing\LicensingConstants.cs" @'
namespace FpsLatencyPanel.Core.Licensing;

public static class LicensingConstants
{
    public const string PublicKeyXml = @"<RSAKeyValue>
  <Modulus>SUBSTITUA_AQUI_PELO_MODULUS_GERADO</Modulus>
  <Exponent>AQAB</Exponent>
</RSAKeyValue>";

    public const string ProductName = "FPS Latency Panel";

    public const string KeyPrefix = "FPSLP";
}
'@

# ---- LicensePayload.cs ----
Write-File "src\FpsLatencyPanel.Core\Licensing\LicensePayload.cs" @'
namespace FpsLatencyPanel.Core.Licensing;

using System.Text.Json.Serialization;

public sealed class LicensePayload
{
    [JsonPropertyName("v")]  public int Version { get; set; } = 1;
    [JsonPropertyName("p")]  public string Product { get; set; } = LicensingConstants.ProductName;
    [JsonPropertyName("n")]  public string CustomerName { get; set; } = "";
    [JsonPropertyName("e")]  public string CustomerEmail { get; set; } = "";
    [JsonPropertyName("i")]  public string IssuedAtUtc { get; set; } = "";
    [JsonPropertyName("x")]  public string? ExpiresAtUtc { get; set; }
    [JsonPropertyName("h")]  public string? HardwareId { get; set; }
    [JsonPropertyName("s")]  public string Serial { get; set; } = "";
}

public sealed class SignedLicense
{
    [JsonPropertyName("payload")]   public string PayloadBase64 { get; set; } = "";
    [JsonPropertyName("signature")] public string SignatureBase64 { get; set; } = "";
}
'@

# ---- MachineFingerprint.cs ----
Write-File "src\FpsLatencyPanel.Core\Licensing\MachineFingerprint.cs" @'
namespace FpsLatencyPanel.Core.Licensing;

using System.Management;
using System.Security.Cryptography;
using System.Text;

public static class MachineFingerprint
{
    public static string GetMachineId()
    {
        var parts = new List<string>
        {
            GetCpuId(),
            GetMotherboardSerial(),
            GetSystemVolumeSerial()
        };

        var raw = string.Join("|", parts.Where(p => !string.IsNullOrWhiteSpace(p)));
        if (string.IsNullOrWhiteSpace(raw)) raw = Environment.MachineName;

        var hash = SHA256.HashData(Encoding.UTF8.GetBytes(raw));
        return Convert.ToHexString(hash).Substring(0, 16).ToLowerInvariant();
    }

    private static string GetCpuId()
    {
        try
        {
            using var s = new ManagementObjectSearcher("SELECT ProcessorId FROM Win32_Processor");
            foreach (ManagementObject mo in s.Get())
                return mo["ProcessorId"]?.ToString() ?? "";
        }
        catch { }
        return "";
    }

    private static string GetMotherboardSerial()
    {
        try
        {
            using var s = new ManagementObjectSearcher("SELECT SerialNumber FROM Win32_BaseBoard");
            foreach (ManagementObject mo in s.Get())
                return mo["SerialNumber"]?.ToString()?.Trim() ?? "";
        }
        catch { }
        return "";
    }

    private static string GetSystemVolumeSerial()
    {
        try
        {
            var sysDrive = Path.GetPathRoot(Environment.SystemDirectory) ?? "C:\\";
            using var s = new ManagementObjectSearcher(
                $"SELECT VolumeSerialNumber FROM Win32_LogicalDisk WHERE DeviceID='{sysDrive.TrimEnd('\\')}'");
            foreach (ManagementObject mo in s.Get())
                return mo["VolumeSerialNumber"]?.ToString() ?? "";
        }
        catch { }
        return "";
    }
}
'@

# ---- ILicenseService.cs ----
Write-File "src\FpsLatencyPanel.Core\Licensing\ILicenseService.cs" @'
namespace FpsLatencyPanel.Core.Licensing;

public enum LicenseStatus
{
    Valid,
    Missing,
    InvalidSignature,
    Expired,
    HardwareMismatch,
    Corrupted
}

public sealed record LicenseInfo(
    LicenseStatus Status,
    string? CustomerName,
    string? CustomerEmail,
    DateTimeOffset? ExpiresAtUtc,
    string? MachineId,
    string Message);

public interface ILicenseService
{
    string GetMachineId();
    LicenseInfo Activate(string key);
    LicenseInfo GetCurrentStatus();
    void Deactivate();
    string LicenseFilePath { get; }
}
'@

# ---- LicenseValidator.cs ----
Write-File "src\FpsLatencyPanel.Core\Licensing\LicenseValidator.cs" @'
namespace FpsLatencyPanel.Core.Licensing;

using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

public static class LicenseValidator
{
    private static readonly JsonSerializerOptions JsonOpts = new() { WriteIndented = false };

    public static LicenseInfo Validate(string key, string currentMachineId)
    {
        if (string.IsNullOrWhiteSpace(key))
            return Fail(LicenseStatus.Missing, "Nenhuma licenca informada.");

        SignedLicense? signed;
        try
        {
            var json = Encoding.UTF8.GetString(Convert.FromBase64String(key.Trim()));
            signed = JsonSerializer.Deserialize<SignedLicense>(json, JsonOpts);
        }
        catch
        {
            return Fail(LicenseStatus.Corrupted, "Formato de licenca invalido.");
        }

        if (signed is null || string.IsNullOrWhiteSpace(signed.PayloadBase64) || string.IsNullOrWhiteSpace(signed.SignatureBase64))
            return Fail(LicenseStatus.Corrupted, "Licenca incompleta.");

        try
        {
            var payloadBytes = Convert.FromBase64String(signed.PayloadBase64);
            var signatureBytes = Convert.FromBase64String(signed.SignatureBase64);

            using var rsa = RSA.Create();
            rsa.FromXmlString(LicensingConstants.PublicKeyXml);

            if (!rsa.VerifyData(payloadBytes, signatureBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1))
                return Fail(LicenseStatus.InvalidSignature, "Assinatura da licenca nao confere. Key nao e autentica.");
        }
        catch (Exception ex)
        {
            return Fail(LicenseStatus.InvalidSignature, "Falha ao verificar assinatura: " + ex.Message);
        }

        LicensePayload? payload;
        try
        {
            var payloadBytes = Convert.FromBase64String(signed.PayloadBase64);
            payload = JsonSerializer.Deserialize<LicensePayload>(payloadBytes, JsonOpts);
        }
        catch
        {
            return Fail(LicenseStatus.Corrupted, "Payload da licenca corrompido.");
        }
        if (payload is null)
            return Fail(LicenseStatus.Corrupted, "Payload vazio.");

        if (!string.IsNullOrWhiteSpace(payload.ExpiresAtUtc))
        {
            if (DateTimeOffset.TryParse(payload.ExpiresAtUtc, out var exp) && exp < DateTimeOffset.UtcNow)
                return new LicenseInfo(LicenseStatus.Expired, payload.CustomerName, payload.CustomerEmail,
                    exp, payload.HardwareId, $"Licenca expirada em {exp:yyyy-MM-dd}.");
        }

        if (!string.IsNullOrWhiteSpace(payload.HardwareId))
        {
            if (!string.Equals(payload.HardwareId, currentMachineId, StringComparison.OrdinalIgnoreCase))
                return new LicenseInfo(LicenseStatus.HardwareMismatch, payload.CustomerName, payload.CustomerEmail,
                    ParseNullableDate(payload.ExpiresAtUtc), payload.HardwareId,
                    "Esta licenca e vinculada a outro computador. Machine ID atual: " + currentMachineId);
        }

        return new LicenseInfo(LicenseStatus.Valid, payload.CustomerName, payload.CustomerEmail,
            ParseNullableDate(payload.ExpiresAtUtc), payload.HardwareId,
            "Licenca valida.");
    }

    private static DateTimeOffset? ParseNullableDate(string? s)
        => DateTimeOffset.TryParse(s, out var d) ? d : null;

    private static LicenseInfo Fail(LicenseStatus st, string msg)
        => new(st, null, null, null, null, msg);
}
'@

# ---- LicenseService.cs ----
Write-File "src\FpsLatencyPanel.Core\Licensing\LicenseService.cs" @'
namespace FpsLatencyPanel.Core.Licensing;

using System.Text;
using FpsLatencyPanel.Core.Abstractions;

public sealed class LicenseService : ILicenseService
{
    private readonly ILogger _log;
    private readonly string _path;

    public LicenseService(ILogger log, string? baseDir = null)
    {
        _log = log;
        var dir = baseDir ?? Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "FpsLatencyPanel");
        Directory.CreateDirectory(dir);
        _path = Path.Combine(dir, "license.dat");
    }

    public string LicenseFilePath => _path;

    public string GetMachineId() => MachineFingerprint.GetMachineId();

    public LicenseInfo Activate(string key)
    {
        var machineId = GetMachineId();
        var info = LicenseValidator.Validate(key, machineId);

        if (info.Status == LicenseStatus.Valid)
        {
            try
            {
                File.WriteAllText(_path, key.Trim(), Encoding.UTF8);
                _log.Info("License", $"Licenca ativada para {info.CustomerName ?? "-"}.");
            }
            catch (Exception ex)
            {
                _log.Error("License", "Falha ao salvar licenca.", ex);
                return new LicenseInfo(LicenseStatus.Corrupted, info.CustomerName, info.CustomerEmail,
                    info.ExpiresAtUtc, info.MachineId, "Licenca valida, mas nao foi possivel salvar: " + ex.Message);
            }
        }
        else
        {
            _log.Warn("License", $"Ativacao rejeitada: {info.Status} - {info.Message}");
        }

        return info;
    }

    public LicenseInfo GetCurrentStatus()
    {
        if (!File.Exists(_path))
            return new LicenseInfo(LicenseStatus.Missing, null, null, null, GetMachineId(),
                "Nenhuma licenca ativada.");

        string key;
        try { key = File.ReadAllText(_path).Trim(); }
        catch (Exception ex)
        {
            _log.Error("License", "Falha ao ler licenca.", ex);
            return new LicenseInfo(LicenseStatus.Corrupted, null, null, null, GetMachineId(),
                "Falha ao ler arquivo de licenca.");
        }

        return LicenseValidator.Validate(key, GetMachineId());
    }

    public void Deactivate()
    {
        try
        {
            if (File.Exists(_path)) File.Delete(_path);
            _log.Info("License", "Licenca removida.");
        }
        catch (Exception ex)
        {
            _log.Error("License", "Falha ao remover licenca.", ex);
        }
    }
}
'@

# ---- KeyGen/Program.cs ----
Write-File "tools\KeyGen\Program.cs" @'
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace FpsLatencyPanel.KeyGen;

internal static class Program
{
    private static readonly JsonSerializerOptions JsonOpts = new() { WriteIndented = false };

    private static int Main(string[] args)
    {
        if (args.Length == 0) return Help();

        var cmd = args[0].ToLowerInvariant();
        return cmd switch
        {
            "init"    => Init(),
            "issue"   => Issue(args.Skip(1).ToArray()),
            "inspect" => Inspect(args.Skip(1).ToArray()),
            _ => Help()
        };
    }

    private static int Help()
    {
        Console.WriteLine("KeyGen - FPS Latency Panel");
        Console.WriteLine();
        Console.WriteLine("Uso:");
        Console.WriteLine("  KeyGen init");
        Console.WriteLine("  KeyGen issue --name \"Joao Silva\" [--email joao@x.com] [--serial 000123]");
        Console.WriteLine("                [--expires 2026-12-31] [--hwid abcdef0123456789]");
        Console.WriteLine("  KeyGen inspect --key <base64>");
        return 1;
    }

    private static int Init()
    {
        using var rsa = RSA.Create(2048);
        var privateXml = rsa.ToXmlString(true);
        var publicXml  = rsa.ToXmlString(false);

        File.WriteAllText("private.xml", privateXml);
        File.WriteAllText("public.xml", publicXml);

        Console.WriteLine("Par de chaves gerado.");
        Console.WriteLine();
        Console.WriteLine("AVISO: private.xml - NUNCA SAIA DESTA MAQUINA. Faca backup offline.");
        Console.WriteLine("       public.xml  - copie para LicensingConstants.cs (PublicKeyXml).");
        return 0;
    }

    private static int Issue(string[] args)
    {
        var name    = GetArg(args, "--name");
        var email   = GetArg(args, "--email") ?? "";
        var serial  = GetArg(args, "--serial") ?? DateTime.UtcNow.ToString("yyyyMMddHHmmss");
        var expires = GetArg(args, "--expires");
        var hwid    = GetArg(args, "--hwid");

        if (string.IsNullOrWhiteSpace(name))
        {
            Console.Error.WriteLine("--name e obrigatorio.");
            return 1;
        }

        if (!File.Exists("private.xml"))
        {
            Console.Error.WriteLine("private.xml nao encontrado. Rode `KeyGen init` primeiro.");
            return 1;
        }

        var payload = new LicensePayload
        {
            Version = 1,
            Product = "FPS Latency Panel",
            CustomerName = name,
            CustomerEmail = email,
            IssuedAtUtc = DateTime.UtcNow.ToString("O"),
            ExpiresAtUtc = string.IsNullOrWhiteSpace(expires)
                ? null
                : DateTimeOffset.Parse(expires + "T23:59:59Z").ToString("O"),
            HardwareId = string.IsNullOrWhiteSpace(hwid) ? null : hwid,
            Serial = serial
        };

        var payloadJson = JsonSerializer.Serialize(payload, JsonOpts);
        var payloadBytes = Encoding.UTF8.GetBytes(payloadJson);

        using var rsa = RSA.Create();
        rsa.FromXmlString(File.ReadAllText("private.xml"));
        var signature = rsa.SignData(payloadBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

        var signed = new SignedLicense
        {
            PayloadBase64 = Convert.ToBase64String(payloadBytes),
            SignatureBase64 = Convert.ToBase64String(signature)
        };

        var signedJson = JsonSerializer.Serialize(signed, JsonOpts);
        var key = Convert.ToBase64String(Encoding.UTF8.GetBytes(signedJson));

        Console.WriteLine();
        Console.WriteLine("=== KEY GERADA ===");
        Console.WriteLine(key);
        Console.WriteLine("=== FIM ===");
        Console.WriteLine();
        Console.WriteLine($"Cliente: {name}");
        if (!string.IsNullOrWhiteSpace(email)) Console.WriteLine($"Email:   {email}");
        Console.WriteLine($"Serial:  {serial}");
        Console.WriteLine($"Expira:  {(payload.ExpiresAtUtc ?? "nunca")}");
        Console.WriteLine($"HWID:    {(payload.HardwareId ?? "nao travado")}");
        return 0;
    }

    private static int Inspect(string[] args)
    {
        var key = GetArg(args, "--key");
        if (string.IsNullOrWhiteSpace(key))
        {
            Console.Error.WriteLine("--key obrigatorio.");
            return 1;
        }

        try
        {
            var json = Encoding.UTF8.GetString(Convert.FromBase64String(key));
            var signed = JsonSerializer.Deserialize<SignedLicense>(json, JsonOpts)!;
            var payloadBytes = Convert.FromBase64String(signed.PayloadBase64);
            var payload = JsonSerializer.Deserialize<LicensePayload>(payloadBytes, JsonOpts)!;

            Console.WriteLine($"Cliente:  {payload.CustomerName}");
            Console.WriteLine($"Email:    {payload.CustomerEmail}");
            Console.WriteLine($"Serial:   {payload.Serial}");
            Console.WriteLine($"Emitido:  {payload.IssuedAtUtc}");
            Console.WriteLine($"Expira:   {payload.ExpiresAtUtc ?? "nunca"}");
            Console.WriteLine($"HWID:     {payload.HardwareId ?? "nao travado"}");
            return 0;
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine("Falha: " + ex.Message);
            return 1;
        }
    }

    private static string? GetArg(string[] args, string name)
    {
        for (int i = 0; i < args.Length - 1; i++)
            if (args[i].Equals(name, StringComparison.OrdinalIgnoreCase))
                return args[i + 1];
        return null;
    }

    private sealed class LicensePayload
    {
        [System.Text.Json.Serialization.JsonPropertyName("v")] public int Version { get; set; }
        [System.Text.Json.Serialization.JsonPropertyName("p")] public string Product { get; set; } = "";
        [System.Text.Json.Serialization.JsonPropertyName("n")] public string CustomerName { get; set; } = "";
        [System.Text.Json.Serialization.JsonPropertyName("e")] public string CustomerEmail { get; set; } = "";
        [System.Text.Json.Serialization.JsonPropertyName("i")] public string IssuedAtUtc { get; set; } = "";
        [System.Text.Json.Serialization.JsonPropertyName("x")] public string? ExpiresAtUtc { get; set; }
        [System.Text.Json.Serialization.JsonPropertyName("h")] public string? HardwareId { get; set; }
        [System.Text.Json.Serialization.JsonPropertyName("s")] public string Serial { get; set; } = "";
    }

    private sealed class SignedLicense
    {
        [System.Text.Json.Serialization.JsonPropertyName("payload")]   public string PayloadBase64 { get; set; } = "";
        [System.Text.Json.Serialization.JsonPropertyName("signature")] public string SignatureBase64 { get; set; } = "";
    }
}
'@

Write-Host "  Tweaks (Network/Cleanup/Startup) + Licensing OK." -ForegroundColor DarkGray
Write-Host ""# =====================================================================
# APP — WPF (Converters, Services, ViewModels, Views, App.xaml)
# =====================================================================

Write-Host "App: WPF..." -ForegroundColor Yellow

# ---- App.xaml ----
Write-File "src\FpsLatencyPanel.App\App.xaml" @'
<Application x:Class="FpsLatencyPanel.App.App"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:converters="clr-namespace:FpsLatencyPanel.App.Converters"
             ShutdownMode="OnMainWindowClose">
    <Application.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="Resources/DarkTheme.xaml"/>
            </ResourceDictionary.MergedDictionaries>

            <BooleanToVisibilityConverter x:Key="BoolToVis"/>
            <converters:BytesToReadableConverter x:Key="BytesConverter"/>
            <converters:TweakStateToBrushConverter x:Key="StateBrush"/>
            <converters:ImpactToTextConverter x:Key="ImpactText"/>
            <converters:RiskToTextConverter x:Key="RiskText"/>
            <converters:StringNotEmptyToVisConverter x:Key="StringNotEmptyToVis"/>
            <converters:BoolToEnabledTextConverter x:Key="BoolToEnabledText"/>
        </ResourceDictionary>
    </Application.Resources>
</Application>
'@

# ---- App.xaml.cs ----
Write-File "src\FpsLatencyPanel.App\App.xaml.cs" @'
namespace FpsLatencyPanel.App;

using System.Windows;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.App.ViewModels;
using FpsLatencyPanel.App.Views;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;
using FpsLatencyPanel.Core.Infrastructure;
using FpsLatencyPanel.Core.Licensing;
using FpsLatencyPanel.Core.Tweaks.Cleanup;
using FpsLatencyPanel.Core.Tweaks.Games;
using FpsLatencyPanel.Core.Tweaks.Keyboard;
using FpsLatencyPanel.Core.Tweaks.Mouse;
using FpsLatencyPanel.Core.Tweaks.Network;
using FpsLatencyPanel.Core.Tweaks.Power;
using FpsLatencyPanel.Core.Tweaks.Startup;
using Microsoft.Extensions.DependencyInjection;

public partial class App : Application
{
    public static ServiceProvider Services { get; private set; } = null!;

    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);

        var sc = new ServiceCollection();

        sc.AddSingleton<ILogger, FileLogger>();
        sc.AddSingleton<IBackupManager, BackupManager>();
        sc.AddSingleton<IRegistryAccessor, RegistryAccessor>();
        sc.AddSingleton<ISystemParametersService, SystemParametersService>();
        sc.AddSingleton<IPowerPlanService, PowerPlanService>();
        sc.AddSingleton<INetworkService, NetworkService>();
        sc.AddSingleton<IFileSystemService, FileSystemService>();
        sc.AddSingleton<IStartupService, StartupService>();
        sc.AddSingleton<IRestorePointService, RestorePointService>();
        sc.AddSingleton<IEnvironmentDetector, EnvironmentDetector>();
        sc.AddSingleton<ILicenseService, LicenseService>();

        sc.AddSingleton<TweakEngine>();

        sc.AddSingleton<ITweak, MouseAccelerationTweak>();
        sc.AddSingleton<ITweak, MouseSpeedTweak>();
        sc.AddSingleton<ITweak, MouseCurveTweak>();
        sc.AddSingleton<ITweak, KeyboardDelayTweak>();
        sc.AddSingleton<ITweak, KeyboardSpeedTweak>();
        sc.AddSingleton<ITweak, AccessibilityHotkeysTweak>();
        sc.AddSingleton<ITweak, CustomPowerPlanTweak>();
        sc.AddSingleton<ITweak, UsbSuspendTweak>();
        sc.AddSingleton<ITweak, PcieAspmTweak>();
        sc.AddSingleton<ITweak, GameModeTweak>();
        sc.AddSingleton<ITweak, GameDvrTweak>();
        sc.AddSingleton<ITweak, MmcssTweak>();
        sc.AddSingleton<ITweak, Win32PrioritySeparationTweak>();
        sc.AddSingleton<ITweak, FullscreenOptimizationsTweak>();
        sc.AddSingleton<ITweak, AutotuningTweak>();
        sc.AddSingleton<ITweak, RssTweak>();
        sc.AddSingleton<ITweak, DnsTweak>();
        sc.AddSingleton<ITweak, TempFilesCleanup>();
        sc.AddSingleton<ITweak, ShaderCacheCleanup>();
        sc.AddSingleton<ITweak, BrowserCacheCleanup>();
        sc.AddSingleton<ITweak, RecycleBinCleanup>();
        sc.AddSingleton<ITweak, StartupItemsManager>();

        sc.AddSingleton<IDialogService, DialogService>();
        sc.AddSingleton<ILicenseGate, LicenseGate>();

        sc.AddSingleton(sp => new ProfileRecommended(sp.GetServices<ITweak>()));

        sc.AddSingleton<HomeViewModel>();
        sc.AddSingleton<MouseKeyboardViewModel>();
        sc.AddSingleton<GamesPowerViewModel>();
        sc.AddSingleton<NetworkViewModel>();
        sc.AddSingleton<CleanupViewModel>();
        sc.AddSingleton<StartupViewModel>();
        sc.AddSingleton<BackupViewModel>();
        sc.AddSingleton<LicenseViewModel>();
        sc.AddSingleton<MainViewModel>();

        sc.AddSingleton<MainWindow>();

        Services = sc.BuildServiceProvider();

        var win = Services.GetRequiredService<MainWindow>();
        win.DataContext = Services.GetRequiredService<MainViewModel>();
        win.Show();

        var home = Services.GetRequiredService<HomeViewModel>();
        _ = home.InitializeAsync();
    }
}
'@

# ---- DarkTheme.xaml ----
Write-File "src\FpsLatencyPanel.App\Resources\DarkTheme.xaml" @'
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">

    <Color x:Key="BgColor">#FF101418</Color>
    <Color x:Key="PanelColor">#FF181D22</Color>
    <Color x:Key="BorderColor">#FF252C33</Color>
    <Color x:Key="TextColor">#FFE8ECEF</Color>
    <Color x:Key="MutedColor">#FF9AA6AF</Color>
    <Color x:Key="AccentColor">#FF3B9EFF</Color>

    <SolidColorBrush x:Key="BgBrush"     Color="{StaticResource BgColor}"/>
    <SolidColorBrush x:Key="PanelBrush"  Color="{StaticResource PanelColor}"/>
    <SolidColorBrush x:Key="BorderBrush" Color="{StaticResource BorderColor}"/>
    <SolidColorBrush x:Key="TextBrush"   Color="{StaticResource TextColor}"/>
    <SolidColorBrush x:Key="MutedBrush"  Color="{StaticResource MutedColor}"/>
    <SolidColorBrush x:Key="AccentBrush" Color="{StaticResource AccentColor}"/>

    <Style TargetType="Window">
        <Setter Property="Background" Value="{StaticResource BgBrush}"/>
        <Setter Property="Foreground" Value="{StaticResource TextBrush}"/>
        <Setter Property="FontFamily" Value="Segoe UI"/>
        <Setter Property="FontSize" Value="13"/>
    </Style>

    <Style TargetType="TextBlock">
        <Setter Property="Foreground" Value="{StaticResource TextBrush}"/>
    </Style>
    <Style x:Key="H1" TargetType="TextBlock">
        <Setter Property="FontSize" Value="22"/>
        <Setter Property="FontWeight" Value="SemiBold"/>
        <Setter Property="Margin" Value="0,0,0,12"/>
    </Style>
    <Style x:Key="H2" TargetType="TextBlock">
        <Setter Property="FontSize" Value="15"/>
        <Setter Property="FontWeight" Value="SemiBold"/>
        <Setter Property="Margin" Value="0,0,0,6"/>
    </Style>
    <Style x:Key="Muted" TargetType="TextBlock">
        <Setter Property="Foreground" Value="{StaticResource MutedBrush}"/>
        <Setter Property="TextWrapping" Value="Wrap"/>
    </Style>

    <Style TargetType="Button">
        <Setter Property="Background" Value="{StaticResource PanelBrush}"/>
        <Setter Property="Foreground" Value="{StaticResource TextBrush}"/>
        <Setter Property="BorderBrush" Value="{StaticResource BorderBrush}"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="Padding" Value="14,8"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border x:Name="bd" Background="{TemplateBinding Background}"
                            BorderBrush="{TemplateBinding BorderBrush}"
                            BorderThickness="{TemplateBinding BorderThickness}"
                            CornerRadius="6">
                        <ContentPresenter HorizontalAlignment="Center"
                                          VerticalAlignment="Center"
                                          Margin="{TemplateBinding Padding}"/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter TargetName="bd" Property="Background" Value="#FF1F262E"/>
                        </Trigger>
                        <Trigger Property="IsEnabled" Value="False">
                            <Setter Property="Opacity" Value="0.5"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>

    <Style x:Key="PrimaryButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
        <Setter Property="Background" Value="{StaticResource AccentBrush}"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderBrush" Value="{StaticResource AccentBrush}"/>
        <Setter Property="FontWeight" Value="SemiBold"/>
        <Setter Property="Padding" Value="18,10"/>
    </Style>

    <Style x:Key="DangerButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Foreground" Value="#FFE5484D"/>
        <Setter Property="BorderBrush" Value="#FFE5484D"/>
    </Style>

    <Style x:Key="Card" TargetType="Border">
        <Setter Property="Background" Value="{StaticResource PanelBrush}"/>
        <Setter Property="BorderBrush" Value="{StaticResource BorderBrush}"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="CornerRadius" Value="8"/>
        <Setter Property="Padding" Value="16"/>
        <Setter Property="Margin" Value="0,0,0,10"/>
    </Style>

    <Style x:Key="Badge" TargetType="Border">
        <Setter Property="CornerRadius" Value="10"/>
        <Setter Property="Padding" Value="8,3"/>
        <Setter Property="Margin" Value="0,0,6,0"/>
    </Style>
    <Style x:Key="BadgeText" TargetType="TextBlock">
        <Setter Property="FontSize" Value="11"/>
        <Setter Property="FontWeight" Value="SemiBold"/>
        <Setter Property="Foreground" Value="White"/>
    </Style>

    <Style TargetType="ListBox">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="BorderThickness" Value="0"/>
        <Setter Property="Foreground" Value="{StaticResource TextBrush}"/>
        <Setter Property="ScrollViewer.HorizontalScrollBarVisibility" Value="Disabled"/>
    </Style>

    <Style TargetType="CheckBox">
        <Setter Property="Foreground" Value="{StaticResource TextBrush}"/>
        <Setter Property="VerticalContentAlignment" Value="Center"/>
    </Style>

    <Style TargetType="ScrollViewer">
        <Setter Property="Background" Value="Transparent"/>
    </Style>

    <Style TargetType="ProgressBar">
        <Setter Property="Background" Value="{StaticResource BorderBrush}"/>
        <Setter Property="Foreground" Value="{StaticResource AccentBrush}"/>
        <Setter Property="Height" Value="6"/>
    </Style>

</ResourceDictionary>
'@

# ---- Converters ----
Write-File "src\FpsLatencyPanel.App\Converters\TweakStateToBrushConverter.cs" @'
namespace FpsLatencyPanel.App.Converters;

using System.Globalization;
using System.Windows.Data;
using System.Windows.Media;
using FpsLatencyPanel.Core.Abstractions;

public sealed class TweakStateToBrushConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        return value switch
        {
            TweakStateKind.Aplicado    => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#3ED17B")),
            TweakStateKind.NaoAplicado => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#9AA6AF")),
            TweakStateKind.Parcial     => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#F4B740")),
            TweakStateKind.Desconhecido => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#F4B740")),
            TweakStateKind.NaoAplicavel => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#4A5560")),
            _ => Brushes.Gray
        };
    }
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotSupportedException();
}
'@

Write-File "src\FpsLatencyPanel.App\Converters\ImpactToTextConverter.cs" @'
namespace FpsLatencyPanel.App.Converters;

using System.Globalization;
using System.Windows.Data;
using FpsLatencyPanel.Core.Abstractions;

public sealed class ImpactToTextConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => value switch
        {
            ExpectedImpact.Mensuravel  => "Impacto mensuravel",
            ExpectedImpact.Marginal    => "Impacto marginal",
            ExpectedImpact.Situacional => "Impacto situacional",
            _ => ""
        };
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotSupportedException();
}
'@

Write-File "src\FpsLatencyPanel.App\Converters\RiskToTextConverter.cs" @'
namespace FpsLatencyPanel.App.Converters;

using System.Globalization;
using System.Windows.Data;
using FpsLatencyPanel.Core.Abstractions;

public sealed class RiskToTextConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => value switch
        {
            RiskLevel.Baixo => "Risco baixo",
            RiskLevel.Medio => "Risco medio",
            RiskLevel.Alto  => "Risco alto",
            _ => ""
        };
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotSupportedException();
}
'@

Write-File "src\FpsLatencyPanel.App\Converters\BytesToReadableConverter.cs" @'
namespace FpsLatencyPanel.App.Converters;

using System.Globalization;
using System.Windows.Data;

public sealed class BytesToReadableConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        if (value is not long bytes || bytes <= 0) return "0 B";
        string[] units = { "B", "KB", "MB", "GB", "TB" };
        double v = bytes; int u = 0;
        while (v >= 1024 && u < units.Length - 1) { v /= 1024; u++; }
        return $"{v:0.##} {units[u]}";
    }
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotSupportedException();
}
'@

Write-File "src\FpsLatencyPanel.App\Converters\StringNotEmptyToVisConverter.cs" @'
namespace FpsLatencyPanel.App.Converters;

using System.Globalization;
using System.Windows;
using System.Windows.Data;

public sealed class StringNotEmptyToVisConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => string.IsNullOrWhiteSpace(value as string) ? Visibility.Collapsed : Visibility.Visible;

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotSupportedException();
}
'@

Write-File "src\FpsLatencyPanel.App\Converters\BoolToEnabledTextConverter.cs" @'
namespace FpsLatencyPanel.App.Converters;

using System.Globalization;
using System.Windows.Data;

public sealed class BoolToEnabledTextConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => value is true ? "Ativo" : "Desativado";
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotSupportedException();
}
'@

# ---- Services ----
Write-File "src\FpsLatencyPanel.App\Services\DialogService.cs" @'
namespace FpsLatencyPanel.App.Services;

using System.Windows;

public interface IDialogService
{
    bool Confirm(string title, string message);
    void Info(string title, string message);
    void Error(string title, string message);
}

public sealed class DialogService : IDialogService
{
    public bool Confirm(string title, string message)
        => MessageBox.Show(message, title, MessageBoxButton.OKCancel, MessageBoxImage.Question)
           == MessageBoxResult.OK;

    public void Info(string title, string message)
        => MessageBox.Show(message, title, MessageBoxButton.OK, MessageBoxImage.Information);

    public void Error(string title, string message)
        => MessageBox.Show(message, title, MessageBoxButton.OK, MessageBoxImage.Warning);
}
'@

Write-File "src\FpsLatencyPanel.App\Services\ILicenseGate.cs" @'
namespace FpsLatencyPanel.App.Services;

using FpsLatencyPanel.Core.Licensing;

public interface ILicenseGate
{
    bool EnsureLicensed(string actionName);
}

public sealed class LicenseGate : ILicenseGate
{
    private readonly ILicenseService _license;
    private readonly IDialogService _dialog;

    public LicenseGate(ILicenseService license, IDialogService dialog)
    {
        _license = license; _dialog = dialog;
    }

    public bool EnsureLicensed(string actionName)
    {
        var info = _license.GetCurrentStatus();
        if (info.Status == LicenseStatus.Valid) return true;

        var msg = $"Esta acao (\"{actionName}\") exige uma licenca valida.\n\n" +
                  $"Status: {info.Message}\n\n" +
                  "Abra a aba Licenca para ativar.";
        _dialog.Error("Licenca necessaria", msg);
        return false;
    }
}
'@

Write-Host "  App: converters + services OK." -ForegroundColor DarkGray
Write-Host ""# =====================================================================
# APP — ViewModels
# =====================================================================

Write-Host "App: ViewModels..." -ForegroundColor Yellow

Write-File "src\FpsLatencyPanel.App\ViewModels\ViewModelBase.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.ComponentModel;
using System.Runtime.CompilerServices;

public abstract class ViewModelBase : INotifyPropertyChanged
{
    public event PropertyChangedEventHandler? PropertyChanged;

    protected void OnPropertyChanged([CallerMemberName] string? name = null)
        => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));

    protected bool Set<T>(ref T field, T value, [CallerMemberName] string? name = null)
    {
        if (EqualityComparer<T>.Default.Equals(field, value)) return false;
        field = value;
        OnPropertyChanged(name);
        return true;
    }
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\RelayCommand.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Windows.Input;

public sealed class RelayCommand : ICommand
{
    private readonly Action _execute;
    private readonly Func<bool>? _canExecute;
    public RelayCommand(Action execute, Func<bool>? canExecute = null)
    { _execute = execute; _canExecute = canExecute; }
    public bool CanExecute(object? parameter) => _canExecute?.Invoke() ?? true;
    public void Execute(object? parameter) => _execute();
    public event EventHandler? CanExecuteChanged;
}

public sealed class AsyncRelayCommand : ICommand
{
    private readonly Func<Task> _execute;
    private readonly Func<bool>? _canExecute;
    private bool _running;

    public AsyncRelayCommand(Func<Task> execute, Func<bool>? canExecute = null)
    { _execute = execute; _canExecute = canExecute; }

    public bool CanExecute(object? parameter) => !_running && (_canExecute?.Invoke() ?? true);

    public async void Execute(object? parameter)
    {
        _running = true;
        CanExecuteChanged?.Invoke(this, EventArgs.Empty);
        try { await _execute(); }
        finally { _running = false; CanExecuteChanged?.Invoke(this, EventArgs.Empty); }
    }

    public event EventHandler? CanExecuteChanged;
}

public sealed class AsyncRelayCommand<T> : ICommand
{
    private readonly Func<T, Task> _execute;
    private bool _running;
    public AsyncRelayCommand(Func<T, Task> execute) => _execute = execute;
    public bool CanExecute(object? parameter) => !_running;
    public async void Execute(object? parameter)
    {
        _running = true; CanExecuteChanged?.Invoke(this, EventArgs.Empty);
        try { if (parameter is T t) await _execute(t); }
        finally { _running = false; CanExecuteChanged?.Invoke(this, EventArgs.Empty); }
    }
    public event EventHandler? CanExecuteChanged;
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\TweakItemViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using FpsLatencyPanel.Core.Abstractions;

public sealed class TweakItemViewModel : ViewModelBase
{
    public ITweak Tweak { get; }

    private TweakStateKind _state = TweakStateKind.Desconhecido;
    public TweakStateKind State
    {
        get => _state;
        private set { if (Set(ref _state, value)) { OnPropertyChanged(nameof(StateText)); OnPropertyChanged(nameof(IsApplied)); } }
    }

    private string _stateDetail = "";
    public string StateDetail
    {
        get => _stateDetail;
        private set => Set(ref _stateDetail, value);
    }

    private bool _busy;
    public bool Busy
    {
        get => _busy;
        set => Set(ref _busy, value);
    }

    public bool IsApplied => _state == TweakStateKind.Aplicado;
    public bool IsNotApplicable => _state == TweakStateKind.NaoAplicavel;

    public string StateText => _state switch
    {
        TweakStateKind.Aplicado     => "Ativo",
        TweakStateKind.NaoAplicado  => "Inativo",
        TweakStateKind.Parcial      => "Parcial",
        TweakStateKind.NaoAplicavel => "N/A",
        _ => "Verificando..."
    };

    public TweakItemViewModel(ITweak tweak) => Tweak = tweak;

    public async Task RefreshAsync(CancellationToken ct = default)
    {
        Busy = true;
        try
        {
            var s = await Tweak.DetectAsync(ct);
            State = s.Kind;
            StateDetail = s.Detalhe;
        }
        catch (Exception ex)
        {
            State = TweakStateKind.Desconhecido;
            StateDetail = ex.Message;
        }
        finally { Busy = false; }
    }
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\MainViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.Core.Licensing;

public sealed class MainViewModel : ViewModelBase
{
    public HomeViewModel Home { get; }
    public MouseKeyboardViewModel MouseKeyboard { get; }
    public GamesPowerViewModel GamesPower { get; }
    public NetworkViewModel Network { get; }
    public CleanupViewModel Cleanup { get; }
    public StartupViewModel Startup { get; }
    public BackupViewModel Backup { get; }
    public LicenseViewModel License { get; }

    public ObservableCollection<NavItem> Navigation { get; }

    private NavItem? _selectedNav;
    public NavItem? SelectedNav
    {
        get => _selectedNav;
        set
        {
            if (Set(ref _selectedNav, value))
                OnPropertyChanged(nameof(CurrentContent));
        }
    }

    public object? CurrentContent => _selectedNav?.ViewModel;

    public ICommand ApplyRecommendedCommand { get; }
    public ICommand RefreshHomeCommand { get; }

    public MainViewModel(
        HomeViewModel home,
        MouseKeyboardViewModel mk,
        GamesPowerViewModel gp,
        NetworkViewModel net,
        CleanupViewModel clean,
        StartupViewModel su,
        BackupViewModel bk,
        LicenseViewModel license,
        ILicenseService licenseService)
    {
        Home = home; MouseKeyboard = mk; GamesPower = gp;
        Network = net; Cleanup = clean; Startup = su; Backup = bk; License = license;

        ApplyRecommendedCommand = new AsyncRelayCommand(() => Home.ApplyRecommendedAsync());
        RefreshHomeCommand = new AsyncRelayCommand(() => Home.RefreshAllAsync());

        Navigation = new ObservableCollection<NavItem>
        {
            new("Inicio",            home),
            new("Mouse / Teclado",   mk),
            new("Jogos / Energia",   gp),
            new("Rede",              net),
            new("Limpeza",           clean),
            new("Inicializacao",     su),
            new("Backup",            bk),
            new("Licenca",           license),
        };

        SelectedNav = Navigation[0];
    }
}

public sealed record NavItem(string Title, object ViewModel);
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\HomeViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Text;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class HomeViewModel : ViewModelBase
{
    private readonly IEnvironmentDetector _env;
    private readonly ProfileRecommended _profile;
    private readonly TweakEngine _engine;
    private readonly ILogger _log;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private EnvironmentInfo? _envInfo;
    public EnvironmentInfo? EnvInfo { get => _envInfo; set => Set(ref _envInfo, value); }

    private string _envSummary = "Detectando...";
    public string EnvSummary { get => _envSummary; set => Set(ref _envSummary, value); }

    private string _profileSummary = "";
    public string ProfileSummary { get => _profileSummary; set => Set(ref _profileSummary, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _createRestorePoint = true;
    public bool CreateRestorePoint { get => _createRestorePoint; set => Set(ref _createRestorePoint, value); }

    public HomeViewModel(
        IEnvironmentDetector env,
        ProfileRecommended profile,
        TweakEngine engine,
        ILogger log,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _env = env; _profile = profile; _engine = engine; _log = log; _dialog = dialog; _gate = gate;
    }

    public async Task InitializeAsync(CancellationToken ct = default)
    {
        Busy = true;
        try
        {
            EnvInfo = await _env.DetectAsync(ct);
            EnvSummary = BuildEnvSummary(EnvInfo!);

            Items.Clear();
            foreach (var step in _profile.Steps)
                Items.Add(new TweakItemViewModel(step.Tweak));

            await RefreshAllAsync(ct);

            ProfileSummary = $"Perfil recomendado: {_profile.Steps.Count} ajustes seguros.";
        }
        catch (Exception ex)
        {
            _log.Error("HomeViewModel", "Falha na inicializacao.", ex);
            EnvSummary = "Falha ao detectar ambiente: " + ex.Message;
        }
        finally { Busy = false; }
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var item in Items)
            await item.RefreshAsync(ct);
    }

    public async Task ApplyRecommendedAsync()
    {
        if (!_gate.EnsureLicensed("Aplicar perfil recomendado")) return;

        var pending = Items.Where(i => !i.IsApplied && !i.IsNotApplicable).ToList();
        if (pending.Count == 0) { _dialog.Info("Perfil recomendado", "Todos os ajustes ja estao aplicados."); return; }

        var sb = new StringBuilder();
        sb.AppendLine($"Serao aplicados {pending.Count} ajustes:");
        foreach (var p in pending) sb.AppendLine($"  - {p.Tweak.Name}");
        sb.AppendLine();
        sb.AppendLine("Backup automatico por ajuste. Nada e apagado sem possibilidade de reverter.");

        if (!_dialog.Confirm("Aplicar perfil recomendado", sb.ToString())) return;

        Busy = true;
        try
        {
            var prog = new Progress<string>(p => Progress = p);
            bool laptopAck = EnvInfo?.IsLaptop != true ||
                _dialog.Confirm("Notebook detectado", "Aplicar ajustes de energia mesmo em bateria?");
            var opts = new EngineOptions(CreateRestorePoint, laptopAck);
            var report = await _engine.ApplyManyAsync(_profile.Tweaks, opts, prog);

            await RefreshAllAsync();

            _dialog.Info("Perfil recomendado",
                $"Aplicados: {report.Applied}\n" +
                $"Ja aplicados: {report.Skipped}\n" +
                $"Falhas: {report.Failed}");
        }
        catch (Exception ex)
        {
            _log.Error("HomeViewModel", "Falha ao aplicar perfil recomendado.", ex);
            _dialog.Error("Erro", "Falha ao aplicar: " + ex.Message);
        }
        finally { Busy = false; Progress = ""; }
    }

    private static string BuildEnvSummary(EnvironmentInfo e)
    {
        var kind = e.SystemDiskKind switch
        {
            DiskKind.Ssd => "SSD",
            DiskKind.Hdd => "HDD",
            _ => "Disco desconhecido"
        };
        var tipo = e.IsLaptop ? "Notebook" : "Desktop";
        return $"{tipo} | {e.LogicalProcessors} nucleos | " +
               $"{e.TotalRamBytes / (1024UL * 1024 * 1024)} GB RAM | " +
               $"{kind} no sistema | Windows {e.WindowsVersion} ({e.WindowsBuild}) | " +
               $"GPU: {e.GpuName}";
    }
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\MouseKeyboardViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class MouseKeyboardViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    public ICommand ApplyItemCommand { get; }
    public ICommand RevertItemCommand { get; }

    public MouseKeyboardViewModel(
        IEnumerable<ITweak> all,
        TweakEngine engine,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _engine = engine; _dialog = dialog; _gate = gate;
        foreach (var t in all.Where(x => x.Category is TweakCategory.Mouse or TweakCategory.Keyboard))
            Items.Add(new TweakItemViewModel(t));

        ApplyItemCommand  = new AsyncRelayCommand<TweakItemViewModel>(ApplyItemAsync);
        RevertItemCommand = new AsyncRelayCommand<TweakItemViewModel>(RevertItemAsync);
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var i in Items) await i.RefreshAsync(ct);
    }

    public async Task ApplyItemAsync(TweakItemViewModel item)
    {
        if (!_gate.EnsureLicensed("Aplicar " + item.Tweak.Name)) return;

        if (item.Tweak.AffectsLaptop &&
            !_dialog.Confirm("Confirmacao", $"{item.Tweak.Name} afeta notebook. Aplicar?"))
            return;

        if (!_dialog.Confirm("Aplicar", $"Aplicar \"{item.Tweak.Name}\"?\n\n{item.Tweak.Description}")) return;

        Busy = true;
        try
        {
            var opts = new EngineOptions(CreateRestorePoint: false, IsLaptopUserAcknowledged: true);
            await _engine.ApplyManyAsync(new[] { item.Tweak }, opts, new Progress<string>(p => Progress = p));
            await item.RefreshAsync();
        }
        finally { Busy = false; Progress = ""; }
    }

    public async Task RevertItemAsync(TweakItemViewModel item)
    {
        if (!_dialog.Confirm("Reverter", $"Reverter \"{item.Tweak.Name}\"?")) return;
        Busy = true;
        try
        {
            await _engine.RevertAllAsync(new[] { item.Tweak }, new Progress<string>(p => Progress = p));
            await item.RefreshAsync();
        }
        finally { Busy = false; Progress = ""; }
    }
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\GamesPowerViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class GamesPowerViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _rebootNotice = "";
    public string RebootNotice { get => _rebootNotice; set => Set(ref _rebootNotice, value); }

    public ICommand ApplyItemCommand { get; }
    public ICommand RevertItemCommand { get; }
    public ICommand ApplyAllSafeCommand { get; }
    public ICommand RefreshCommand { get; }

    public GamesPowerViewModel(
        IEnumerable<ITweak> all,
        TweakEngine engine,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _engine = engine; _dialog = dialog; _gate = gate;
        foreach (var t in all.Where(x => x.Category is TweakCategory.Games or TweakCategory.Power))
            Items.Add(new TweakItemViewModel(t));

        ApplyItemCommand    = new AsyncRelayCommand<TweakItemViewModel>(ApplyItemAsync);
        RevertItemCommand   = new AsyncRelayCommand<TweakItemViewModel>(RevertItemAsync);
        ApplyAllSafeCommand = new AsyncRelayCommand(ApplyAllSafeAsync);
        RefreshCommand      = new AsyncRelayCommand(() => RefreshAllAsync());
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var i in Items) await i.RefreshAsync(ct);
        var reboot = Items.Where(i => i.Tweak.RequiresReboot && i.IsApplied).ToList();
        RebootNotice = reboot.Count > 0
            ? $"Reinicio necessario para: {string.Join(", ", reboot.Select(r => r.Tweak.Name))}"
            : "";
    }

    public async Task ApplyItemAsync(TweakItemViewModel item)
    {
        if (!_gate.EnsureLicensed("Aplicar " + item.Tweak.Name)) return;

        if (item.Tweak.AffectsLaptop &&
            !_dialog.Confirm("Notebook detectado",
                $"{item.Tweak.Name} afeta consumo em bateria. Aplicar mesmo assim?"))
            return;

        if (!_dialog.Confirm("Aplicar", $"Aplicar \"{item.Tweak.Name}\"?\n\n{item.Tweak.Description}")) return;

        Busy = true;
        try
        {
            var opts = new EngineOptions(false, IsLaptopUserAcknowledged: true);
            await _engine.ApplyManyAsync(new[] { item.Tweak }, opts, new Progress<string>(p => Progress = p));
            await RefreshAllAsync();
        }
        finally { Busy = false; Progress = ""; }
    }

    public async Task RevertItemAsync(TweakItemViewModel item)
    {
        if (!_dialog.Confirm("Reverter", $"Reverter \"{item.Tweak.Name}\"?")) return;
        Busy = true;
        try
        {
            await _engine.RevertAllAsync(new[] { item.Tweak }, new Progress<string>(p => Progress = p));
            await RefreshAllAsync();
        }
        finally { Busy = false; Progress = ""; }
    }

    public async Task ApplyAllSafeAsync()
    {
        if (!_gate.EnsureLicensed("Aplicar ajustes seguros")) return;

        var pending = Items.Where(i =>
            !i.IsApplied && !i.IsNotApplicable
            && !i.Tweak.RequiresReboot
            && i.Tweak.Risk == RiskLevel.Baixo).ToList();
        if (pending.Count == 0) { _dialog.Info("Jogos / Energia", "Nada pendente de baixo risco."); return; }
        if (!_dialog.Confirm("Aplicar seguros",
            $"Aplicar {pending.Count} ajustes de baixo risco, sem reboot?")) return;

        Busy = true;
        try
        {
            var opts = new EngineOptions(false, IsLaptopUserAcknowledged: true);
            await _engine.ApplyManyAsync(pending.Select(p => p.Tweak), opts, new Progress<string>(p => Progress = p));
            await RefreshAllAsync();
        }
        finally { Busy = false; Progress = ""; }
    }
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\NetworkViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;
using FpsLatencyPanel.Core.Tweaks.Network;

public sealed class NetworkViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    public ICommand ApplyItemCommand { get; }
    public ICommand SetDnsCloudflareCommand { get; }
    public ICommand SetDnsGoogleCommand { get; }
    public ICommand SetDnsAutoCommand { get; }

    public NetworkViewModel(
        IEnumerable<ITweak> all,
        TweakEngine engine,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _engine = engine; _dialog = dialog; _gate = gate;
        foreach (var t in all.Where(x => x.Category == TweakCategory.Network))
            Items.Add(new TweakItemViewModel(t));

        ApplyItemCommand = new AsyncRelayCommand<TweakItemViewModel>(ApplyItemAsync);
        SetDnsCloudflareCommand = new AsyncRelayCommand(() => SetDnsAsync(DnsProvider.Cloudflare));
        SetDnsGoogleCommand     = new AsyncRelayCommand(() => SetDnsAsync(DnsProvider.Google));
        SetDnsAutoCommand       = new AsyncRelayCommand(() => SetDnsAsync(DnsProvider.Automatic));
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var i in Items) await i.RefreshAsync(ct);
    }

    public async Task ApplyItemAsync(TweakItemViewModel item)
    {
        if (!_gate.EnsureLicensed("Aplicar " + item.Tweak.Name)) return;
        if (!_dialog.Confirm("Aplicar", $"{item.Tweak.Name}\n\n{item.Tweak.Description}")) return;
        Busy = true;
        try
        {
            await _engine.ApplyManyAsync(new[] { item.Tweak }, new EngineOptions(false, true),
                new Progress<string>(p => Progress = p));
            await item.RefreshAsync();
        }
        finally { Busy = false; Progress = ""; }
    }

    public async Task SetDnsAsync(DnsProvider provider)
    {
        if (!_gate.EnsureLicensed("Trocar DNS")) return;

        var dns = Items.Select(i => i.Tweak).OfType<DnsTweak>().FirstOrDefault();
        if (dns is null) { _dialog.Error("DNS", "Tweak de DNS nao encontrado."); return; }
        dns.Provider = provider;

        if (!_dialog.Confirm("DNS", $"Definir DNS para {provider}?\n\n{dns.Description}")) return;

        Busy = true;
        try
        {
            await _engine.ApplyManyAsync(new[] { (ITweak)dns }, new EngineOptions(false, true),
                new Progress<string>(p => Progress = p));
            await RefreshAllAsync();
        }
        finally { Busy = false; Progress = ""; }
    }
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\CleanupViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class CleanupViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<TweakItemViewModel> Items { get; } = new();

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _lastResult = "";
    public string LastResult { get => _lastResult; set => Set(ref _lastResult, value); }

    public ICommand ApplyItemCommand { get; }

    public CleanupViewModel(
        IEnumerable<ITweak> all,
        TweakEngine engine,
        IDialogService dialog,
        ILicenseGate gate)
    {
        _engine = engine; _dialog = dialog; _gate = gate;
        foreach (var t in all.Where(x => x.Category == TweakCategory.Cleanup))
            Items.Add(new TweakItemViewModel(t));

        ApplyItemCommand = new AsyncRelayCommand<TweakItemViewModel>(ApplyItemAsync);
    }

    public async Task RefreshAllAsync(CancellationToken ct = default)
    {
        foreach (var i in Items) await i.RefreshAsync(ct);
    }

    public async Task ApplyItemAsync(TweakItemViewModel item)
    {
        if (!_gate.EnsureLicensed("Limpar " + item.Tweak.Name)) return;

        var msg = $"{item.Tweak.Name}\n\n{item.Tweak.Description}\n\nProsseguir?";
        if (!_dialog.Confirm("Confirmar limpeza", msg)) return;

        Busy = true;
        try
        {
            var r = await _engine.ApplyManyAsync(new[] { item.Tweak }, new EngineOptions(false, true),
                new Progress<string>(p => Progress = p));
            LastResult = r.Details.FirstOrDefault().Result.Message ?? "";
            await item.RefreshAsync();
        }
        finally { Busy = false; Progress = ""; }
    }
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\StartupViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Infrastructure;
using FpsLatencyPanel.Core.Tweaks.Startup;

public sealed class StartupViewModel : ViewModelBase
{
    private readonly StartupItemsManager _manager;
    private readonly IDialogService _dialog;
    private readonly ILicenseGate _gate;

    public ObservableCollection<StartupItemVM> Items { get; } = new();

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _hint =
        "Voce decide o que desativar. O painel nunca mexe sozinho. " +
        "A desativacao usa o mesmo mecanismo do Gerenciador de Tarefas e e reversivel.";

    public string Hint { get => _hint; set => Set(ref _hint, value); }

    public ICommand ToggleCommand { get; }
    public ICommand RefreshCommand { get; }

    public StartupViewModel(StartupItemsManager manager, IDialogService dialog, ILicenseGate gate)
    {
        _manager = manager; _dialog = dialog; _gate = gate;
        ToggleCommand = new AsyncRelayCommand<StartupItemVM>(ToggleAsync);
        RefreshCommand = new AsyncRelayCommand(RefreshAsync);
    }

    public Task RefreshAsync()
    {
        Items.Clear();
        foreach (var i in _manager.List())
            Items.Add(new StartupItemVM(i));
        return Task.CompletedTask;
    }

    public async Task ToggleAsync(StartupItemVM vm)
    {
        if (!_gate.EnsureLicensed(vm.Item.IsEnabled ? "Desativar item" : "Reativar item")) return;

        Busy = true;
        try
        {
            if (vm.Item.IsEnabled)
            {
                if (!_dialog.Confirm("Desativar", $"Desativar \"{vm.Item.Name}\"?\n\n{vm.Item.Command}")) return;
                var r = await _manager.DisableItemAsync(vm.Item);
                if (!r.Success) _dialog.Error("Erro", r.Message);
            }
            else
            {
                var r = await _manager.EnableItemAsync(vm.Item);
                if (!r.Success) _dialog.Error("Erro", r.Message);
            }
            await RefreshAsync();
        }
        finally { Busy = false; }
    }
}

public sealed class StartupItemVM
{
    public StartupItem Item { get; }
    public StartupItemVM(StartupItem item) => Item = item;
    public string Name => Item.Name;
    public string Command => Item.Command;
    public string Location => Item.Location;
    public bool IsEnabled => Item.IsEnabled;
    public string ToggleText => Item.IsEnabled ? "Desativar" : "Reativar";
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\BackupViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Collections.ObjectModel;
using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Abstractions;
using FpsLatencyPanel.Core.Engine;

public sealed class BackupViewModel : ViewModelBase
{
    private readonly TweakEngine _engine;
    private readonly ILogger _log;
    private readonly IDialogService _dialog;
    private readonly IReadOnlyList<ITweak> _all;

    public ObservableCollection<LogEntry> Recent { get; } = new();

    private bool _busy;
    public bool Busy { get => _busy; set => Set(ref _busy, value); }

    private string _progress = "";
    public string Progress { get => _progress; set => Set(ref _progress, value); }

    private string _logPath = "";
    public string LogPath { get => _logPath; set => Set(ref _logPath, value); }

    public ICommand RevertAllCommand { get; }
    public ICommand RefreshCommand { get; }
    public ICommand OpenLogFolderCommand { get; }

    public BackupViewModel(
        TweakEngine engine,
        ILogger log,
        IDialogService dialog,
        IEnumerable<ITweak> all)
    {
        _engine = engine; _log = log; _dialog = dialog;
        _all = all.ToList();
        LogPath = log.LogFilePath;

        RevertAllCommand = new AsyncRelayCommand(RevertAllAsync);
        RefreshCommand = new AsyncRelayCommand(RefreshAsync);
        OpenLogFolderCommand = new RelayCommand(OpenLogFolder);
    }

    public Task RefreshAsync()
    {
        Recent.Clear();
        foreach (var e in _log.Recent(200).Reverse()) Recent.Add(e);
        return Task.CompletedTask;
    }

    public async Task RevertAllAsync()
    {
        if (!_dialog.Confirm("Reverter tudo",
            "Isto vai reverter TODOS os ajustes do painel para o estado anterior.\n" +
            "Acoes que a limpeza fez (apagar arquivos) nao podem ser desfeitas.\n\nContinuar?"))
            return;

        Busy = true;
        try
        {
            var report = await _engine.RevertAllAsync(_all, new Progress<string>(p => Progress = p));
            await RefreshAsync();
            _dialog.Info("Reverter tudo",
                $"Revertidos: {report.Applied}\n" +
                $"Ja no estado original: {report.Skipped}\n" +
                $"Falhas: {report.Failed}");
        }
        finally { Busy = false; Progress = ""; }
    }

    public void OpenLogFolder()
    {
        try
        {
            var dir = Path.GetDirectoryName(_log.LogFilePath);
            if (dir is not null && Directory.Exists(dir))
                System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo("explorer.exe", dir) { UseShellExecute = true });
        }
        catch { }
    }
}
'@

Write-File "src\FpsLatencyPanel.App\ViewModels\LicenseViewModel.cs" @'
namespace FpsLatencyPanel.App.ViewModels;

using System.Windows.Input;
using FpsLatencyPanel.App.Services;
using FpsLatencyPanel.Core.Licensing;

public sealed class LicenseViewModel : ViewModelBase
{
    private readonly ILicenseService _license;
    private readonly IDialogService _dialog;

    public ICommand ActivateCommand { get; }
    public ICommand DeactivateCommand { get; }
    public ICommand CopyMachineIdCommand { get; }

    private string _keyInput = "";
    public string KeyInput { get => _keyInput; set => Set(ref _keyInput, value); }

    private string _machineId = "";
    public string MachineId { get => _machineId; set => Set(ref _machineId, value); }

    private LicenseStatus _status = LicenseStatus.Missing;
    public LicenseStatus Status
    {
        get => _status;
        set { if (Set(ref _status, value)) { OnPropertyChanged(nameof(StatusText)); OnPropertyChanged(nameof(StatusColor)); } }
    }

    private string _statusMessage = "";
    public string StatusMessage { get => _statusMessage; set => Set(ref _statusMessage, value); }

    private string _customerName = "";
    public string CustomerName { get => _customerName; set => Set(ref _customerName, value); }

    private string _expiresText = "";
    public string ExpiresText { get => _expiresText; set => Set(ref _expiresText, value); }

    public string StatusText => Status switch
    {
        LicenseStatus.Valid            => "Licenca ativa",
        LicenseStatus.Missing          => "Nao ativada",
        LicenseStatus.Expired          => "Expirada",
        LicenseStatus.HardwareMismatch => "Outro computador",
        LicenseStatus.InvalidSignature => "Key invalida",
        LicenseStatus.Corrupted        => "Arquivo corrompido",
        _ => "-"
    };

    public string StatusColor => Status switch
    {
        LicenseStatus.Valid => "#3ED17B",
        LicenseStatus.Missing => "#9AA6AF",
        _ => "#E5484D"
    };

    public LicenseViewModel(ILicenseService license, IDialogService dialog)
    {
        _license = license;
        _dialog = dialog;
        ActivateCommand = new RelayCommand(Activate);
        DeactivateCommand = new RelayCommand(Deactivate);
        CopyMachineIdCommand = new RelayCommand(CopyMachineId);

        Refresh();
    }

    public void Refresh()
    {
        MachineId = _license.GetMachineId();
        var info = _license.GetCurrentStatus();
        Status = info.Status;
        StatusMessage = info.Message;
        CustomerName = info.CustomerName ?? "-";
        ExpiresText = info.ExpiresAtUtc is null
            ? "Sem prazo de expiracao"
            : $"Expira em {info.ExpiresAtUtc.Value.ToLocalTime():dd/MM/yyyy}";
    }

    private void Activate()
    {
        if (string.IsNullOrWhiteSpace(KeyInput))
        {
            _dialog.Error("Licenca", "Cole a key recebida.");
            return;
        }

        var info = _license.Activate(KeyInput.Trim());
        Refresh();

        if (info.Status == LicenseStatus.Valid)
        {
            _dialog.Info("Licenca ativada", $"Obrigado, {info.CustomerName}!\n\n{info.Message}");
            KeyInput = "";
        }
        else
        {
            _dialog.Error("Falha na ativacao", info.Message);
        }
    }

    private void Deactivate()
    {
        if (!_dialog.Confirm("Desativar licenca",
            "Isso remove a licenca deste computador. Voce podera ativa-la em outro PC depois.\n\nContinuar?"))
            return;

        _license.Deactivate();
        Refresh();
        _dialog.Info("Licenca", "Licenca removida.");
    }

    private void CopyMachineId()
    {
        try
        {
            System.Windows.Clipboard.SetText(MachineId);
            _dialog.Info("Copiado", "Machine ID copiado. Envie para o vendedor.");
        }
        catch { }
    }
}
'@

Write-Host "  App: ViewModels OK." -ForegroundColor DarkGray
Write-Host ""# =====================================================================
# APP — Views
# =====================================================================

Write-Host "App: Views..." -ForegroundColor Yellow

Write-File "src\FpsLatencyPanel.App\Views\MainWindow.xaml" @'
<Window x:Class="FpsLatencyPanel.App.Views.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="FPS Latency Panel" Width="1100" Height="720"
        WindowStartupLocation="CenterScreen"
        MinWidth="900" MinHeight="600">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="220"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <Border Grid.Column="0" Background="#FF0B0E11" BorderBrush="{StaticResource BorderBrush}"
                BorderThickness="0,0,1,0">
            <StackPanel>
                <TextBlock Text="FPS Latency Panel" Margin="18,20,18,20"
                           FontSize="15" FontWeight="SemiBold" Foreground="{StaticResource AccentBrush}"/>

                <ListBox ItemsSource="{Binding Navigation}"
                         SelectedItem="{Binding SelectedNav, Mode=TwoWay}">
                    <ListBox.ItemTemplate>
                        <DataTemplate>
                            <Border Padding="18,10" Margin="8,1">
                                <TextBlock Text="{Binding Title}" FontSize="13"/>
                            </Border>
                        </DataTemplate>
                    </ListBox.ItemTemplate>
                </ListBox>

                <TextBlock Margin="18,20,18,0" FontSize="11"
                           Foreground="{StaticResource MutedBrush}"
                           TextWrapping="Wrap">
                    Backup automatico por ajuste. Nada e aplicado sem confirmacao.
                </TextBlock>
            </StackPanel>
        </Border>

        <ContentControl Grid.Column="1" Content="{Binding CurrentContent}"/>
    </Grid>
</Window>
'@

Write-File "src\FpsLatencyPanel.App\Views\MainWindow.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows;

public partial class MainWindow : Window
{
    public MainWindow() => InitializeComponent();
}
'@

Write-File "src\FpsLatencyPanel.App\Views\HomeView.xaml" @'
<UserControl x:Class="FpsLatencyPanel.App.Views.HomeView"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ScrollViewer VerticalScrollBarVisibility="Auto" Padding="24">
        <StackPanel>
            <TextBlock Text="Inicio" Style="{StaticResource H1}"/>

            <Border Style="{StaticResource Card}">
                <StackPanel>
                    <TextBlock Text="Seu sistema" Style="{StaticResource H2}"/>
                    <TextBlock Text="{Binding EnvSummary}" Style="{StaticResource Muted}"/>
                </StackPanel>
            </Border>

            <Border Style="{StaticResource Card}">
                <StackPanel>
                    <TextBlock Text="Perfil recomendado" Style="{StaticResource H2}"/>
                    <TextBlock Text="{Binding ProfileSummary}" Style="{StaticResource Muted}" Margin="0,0,0,12"/>
                    <TextBlock Style="{StaticResource Muted}" Margin="0,0,0,12"
                               Text="Todos os ajustes do perfil sao de risco baixo, reversiveis com 1 clique, e possuem backup automatico. Nada aqui promete FPS: sao ajustes para reduzir latencia de input, eliminar interferencia em jogo e evitar consumo desnecessario."/>

                    <CheckBox Content="Criar ponto de restauracao do sistema antes (recomendado)"
                              IsChecked="{Binding CreateRestorePoint}" Margin="0,0,0,12"/>

                    <StackPanel Orientation="Horizontal">
                        <Button Style="{StaticResource PrimaryButton}"
                                Content="Aplicar perfil recomendado"
                                Command="{Binding DataContext.ApplyRecommendedCommand, RelativeSource={RelativeSource AncestorType=Window}}"/>
                        <Button Content="Atualizar status" Margin="10,0,0,0"
                                Command="{Binding DataContext.RefreshHomeCommand, RelativeSource={RelativeSource AncestorType=Window}}"/>
                    </StackPanel>

                    <ProgressBar Height="4" Margin="0,12,0,0"
                                 Visibility="{Binding Busy, Converter={StaticResource BoolToVis}}"/>
                    <TextBlock Text="{Binding Progress}" Style="{StaticResource Muted}" Margin="0,6,0,0"/>
                </StackPanel>
            </Border>

            <TextBlock Text="Ajustes do perfil" Style="{StaticResource H2}"/>
            <ItemsControl ItemsSource="{Binding Items}">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <Border Style="{StaticResource Card}">
                            <StackPanel>
                                <TextBlock Text="{Binding Tweak.Name}" FontWeight="SemiBold"/>
                                <TextBlock Text="{Binding Tweak.Description}" Style="{StaticResource Muted}" Margin="0,4,0,6"/>
                                <StackPanel Orientation="Horizontal">
                                    <Border Style="{StaticResource Badge}" Background="{Binding State, Converter={StaticResource StateBrush}}">
                                        <TextBlock Text="{Binding StateText}" Style="{StaticResource BadgeText}"/>
                                    </Border>
                                    <Border Style="{StaticResource Badge}" Background="#FF2A3038">
                                        <TextBlock Text="{Binding Tweak.Impact, Converter={StaticResource ImpactText}}" Style="{StaticResource BadgeText}"/>
                                    </Border>
                                    <Border Style="{StaticResource Badge}" Background="#FF2A3038">
                                        <TextBlock Text="{Binding Tweak.Risk, Converter={StaticResource RiskText}}" Style="{StaticResource BadgeText}"/>
                                    </Border>
                                </StackPanel>
                            </StackPanel>
                        </Border>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
        </StackPanel>
    </ScrollViewer>
</UserControl>
'@

Write-File "src\FpsLatencyPanel.App\Views\HomeView.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows.Controls;

public partial class HomeView : UserControl
{
    public HomeView() => InitializeComponent();
}
'@

Write-File "src\FpsLatencyPanel.App\Views\MouseKeyboardView.xaml" @'
<UserControl x:Class="FpsLatencyPanel.App.Views.MouseKeyboardView"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ScrollViewer Padding="24">
        <StackPanel>
            <TextBlock Text="Mouse / Teclado" Style="{StaticResource H1}"/>
            <TextBlock Style="{StaticResource Muted}" Margin="0,0,0,16"
                Text="Jogos com RAW INPUT (WM_INPUT) ignoram as configuracoes de mouse do Windows. O ganho do ajuste de aceleracao e real apenas em jogos/menus que usam WM_MOUSEMOVE."/>

            <ItemsControl ItemsSource="{Binding Items}">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <Border Style="{StaticResource Card}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="{Binding Tweak.Name}" FontWeight="SemiBold"/>
                                    <TextBlock Text="{Binding Tweak.Description}" Style="{StaticResource Muted}" Margin="0,4,0,8"/>
                                    <StackPanel Orientation="Horizontal">
                                        <Border Style="{StaticResource Badge}" Background="{Binding State, Converter={StaticResource StateBrush}}">
                                            <TextBlock Text="{Binding StateText}" Style="{StaticResource BadgeText}"/>
                                        </Border>
                                        <Border Style="{StaticResource Badge}" Background="#FF2A3038">
                                            <TextBlock Text="{Binding Tweak.Impact, Converter={StaticResource ImpactText}}" Style="{StaticResource BadgeText}"/>
                                        </Border>
                                    </StackPanel>
                                </StackPanel>
                                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                                    <Button Content="Aplicar" Style="{StaticResource PrimaryButton}"
                                            Command="{Binding DataContext.ApplyItemCommand, RelativeSource={RelativeSource AncestorType=UserControl}}"
                                            CommandParameter="{Binding}"/>
                                    <Button Content="Reverter" Margin="8,0,0,0"
                                            Command="{Binding DataContext.RevertItemCommand, RelativeSource={RelativeSource AncestorType=UserControl}}"
                                            CommandParameter="{Binding}"/>
                                </StackPanel>
                            </Grid>
                        </Border>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
        </StackPanel>
    </ScrollViewer>
</UserControl>
'@

Write-File "src\FpsLatencyPanel.App\Views\MouseKeyboardView.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows.Controls;

public partial class MouseKeyboardView : UserControl
{
    public MouseKeyboardView() => InitializeComponent();
}
'@

Write-File "src\FpsLatencyPanel.App\Views\GamesPowerView.xaml" @'
<UserControl x:Class="FpsLatencyPanel.App.Views.GamesPowerView"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ScrollViewer Padding="24">
        <StackPanel>
            <TextBlock Text="Jogos / Energia" Style="{StaticResource H1}"/>

            <Border Style="{StaticResource Card}" Background="#FF1E1A0E" BorderBrush="#FF3A2E12">
                <TextBlock Foreground="#FFF4B740" TextWrapping="Wrap"
                           Text="Os tweaks de MMCSS e Win32PrioritySeparation exigem REINICIO para efeito. Os de Energia afetam consumo em notebook - pediremos confirmacao extra."/>
            </Border>

            <TextBlock Text="{Binding RebootNotice}" Foreground="#FFF4B740" Margin="0,6,0,10"/>

            <StackPanel Orientation="Horizontal" Margin="0,0,0,14">
                <Button Style="{StaticResource PrimaryButton}"
                        Content="Aplicar seguros (sem reboot)"
                        Command="{Binding ApplyAllSafeCommand}"/>
                <Button Content="Atualizar status" Margin="10,0,0,0"
                        Command="{Binding RefreshCommand}"/>
            </StackPanel>

            <ItemsControl ItemsSource="{Binding Items}">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <Border Style="{StaticResource Card}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="{Binding Tweak.Name}" FontWeight="SemiBold"/>
                                    <TextBlock Text="{Binding Tweak.Description}" Style="{StaticResource Muted}" Margin="0,4,0,8"/>
                                    <StackPanel Orientation="Horizontal">
                                        <Border Style="{StaticResource Badge}" Background="{Binding State, Converter={StaticResource StateBrush}}">
                                            <TextBlock Text="{Binding StateText}" Style="{StaticResource BadgeText}"/>
                                        </Border>
                                        <Border Style="{StaticResource Badge}" Background="#FF2A3038">
                                            <TextBlock Text="{Binding Tweak.Impact, Converter={StaticResource ImpactText}}" Style="{StaticResource BadgeText}"/>
                                        </Border>
                                        <Border Style="{StaticResource Badge}" Background="#FF2A3038">
                                            <TextBlock Text="{Binding Tweak.Risk, Converter={StaticResource RiskText}}" Style="{StaticResource BadgeText}"/>
                                        </Border>
                                    </StackPanel>
                                </StackPanel>
                                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                                    <Button Content="Aplicar" Style="{StaticResource PrimaryButton}"
                                            Command="{Binding DataContext.ApplyItemCommand, RelativeSource={RelativeSource AncestorType=UserControl}}"
                                            CommandParameter="{Binding}"/>
                                    <Button Content="Reverter" Margin="8,0,0,0"
                                            Command="{Binding DataContext.RevertItemCommand, RelativeSource={RelativeSource AncestorType=UserControl}}"
                                            CommandParameter="{Binding}"/>
                                </StackPanel>
                            </Grid>
                        </Border>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
        </StackPanel>
    </ScrollViewer>
</UserControl>
'@

Write-File "src\FpsLatencyPanel.App\Views\GamesPowerView.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows.Controls;

public partial class GamesPowerView : UserControl
{
    public GamesPowerView() => InitializeComponent();
}
'@

Write-File "src\FpsLatencyPanel.App\Views\NetworkView.xaml" @'
<UserControl x:Class="FpsLatencyPanel.App.Views.NetworkView"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ScrollViewer Padding="24">
        <StackPanel>
            <TextBlock Text="Rede" Style="{StaticResource H1}"/>

            <Border Style="{StaticResource Card}" Background="#FF1E1A0E" BorderBrush="#FF3A2E12">
                <TextBlock Foreground="#FFF4B740" TextWrapping="Wrap"
                           Text="DNS nao aumenta a velocidade da sua internet. Autotuning e RSS sao ajustes de TCP - so afetam casos especificos (rede com perda, link saturado)."/>
            </Border>

            <Border Style="{StaticResource Card}">
                <StackPanel>
                    <TextBlock Text="DNS" Style="{StaticResource H2}"/>
                    <TextBlock Style="{StaticResource Muted}" Margin="0,0,0,10"
                               Text="Escolha um DNS. A mudanca e reversivel a qualquer momento."/>
                    <StackPanel Orientation="Horizontal">
                        <Button Content="Cloudflare (1.1.1.1)" Command="{Binding SetDnsCloudflareCommand}"/>
                        <Button Content="Google (8.8.8.8)" Margin="8,0,0,0" Command="{Binding SetDnsGoogleCommand}"/>
                        <Button Content="Restaurar automatico" Margin="8,0,0,0" Command="{Binding SetDnsAutoCommand}"/>
                    </StackPanel>
                </StackPanel>
            </Border>

            <ItemsControl ItemsSource="{Binding Items}">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <Border Style="{StaticResource Card}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="{Binding Tweak.Name}" FontWeight="SemiBold"/>
                                    <TextBlock Text="{Binding Tweak.Description}" Style="{StaticResource Muted}" Margin="0,4,0,8"/>
                                    <StackPanel Orientation="Horizontal">
                                        <Border Style="{StaticResource Badge}" Background="{Binding State, Converter={StaticResource StateBrush}}">
                                            <TextBlock Text="{Binding StateText}" Style="{StaticResource BadgeText}"/>
                                        </Border>
                                    </StackPanel>
                                </StackPanel>
                                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                                    <Button Content="Aplicar" Style="{StaticResource PrimaryButton}"
                                            Command="{Binding DataContext.ApplyItemCommand, RelativeSource={RelativeSource AncestorType=UserControl}}"
                                            CommandParameter="{Binding}"/>
                                </StackPanel>
                            </Grid>
                        </Border>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
        </StackPanel>
    </ScrollViewer>
</UserControl>
'@

Write-File "src\FpsLatencyPanel.App\Views\NetworkView.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows.Controls;

public partial class NetworkView : UserControl
{
    public NetworkView() => InitializeComponent();
}
'@

Write-File "src\FpsLatencyPanel.App\Views\CleanupView.xaml" @'
<UserControl x:Class="FpsLatencyPanel.App.Views.CleanupView"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ScrollViewer Padding="24">
        <StackPanel>
            <TextBlock Text="Limpeza" Style="{StaticResource H1}"/>

            <Border Style="{StaticResource Card}" Background="#FF1E1A0E" BorderBrush="#FF3A2E12">
                <TextBlock Foreground="#FFF4B740" TextWrapping="Wrap"
                           Text="Limpeza NAO aumenta FPS. Ela libera espaco em disco. Arquivos em uso sao pulados (nada quebra). Limpeza e irreversivel por natureza."/>
            </Border>

            <Border Style="{StaticResource Card}"
                    Visibility="{Binding LastResult, Converter={StaticResource StringNotEmptyToVis}}">
                <StackPanel>
                    <TextBlock Text="Ultimo resultado" Style="{StaticResource H2}"/>
                    <TextBlock Text="{Binding LastResult}" Style="{StaticResource Muted}"/>
                </StackPanel>
            </Border>

            <ItemsControl ItemsSource="{Binding Items}">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <Border Style="{StaticResource Card}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="{Binding Tweak.Name}" FontWeight="SemiBold"/>
                                    <TextBlock Text="{Binding Tweak.Description}" Style="{StaticResource Muted}" Margin="0,4,0,8"/>
                                    <StackPanel Orientation="Horizontal">
                                        <Border Style="{StaticResource Badge}" Background="{Binding State, Converter={StaticResource StateBrush}}">
                                            <TextBlock Text="{Binding StateText}" Style="{StaticResource BadgeText}"/>
                                        </Border>
                                    </StackPanel>
                                </StackPanel>
                                <Button Grid.Column="1" Content="Limpar"
                                        Style="{StaticResource PrimaryButton}"
                                        VerticalAlignment="Center"
                                        Command="{Binding DataContext.ApplyItemCommand, RelativeSource={RelativeSource AncestorType=UserControl}}"
                                        CommandParameter="{Binding}"/>
                            </Grid>
                        </Border>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
        </StackPanel>
    </ScrollViewer>
</UserControl>
'@

Write-File "src\FpsLatencyPanel.App\Views\CleanupView.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows.Controls;

public partial class CleanupView : UserControl
{
    public CleanupView() => InitializeComponent();
}
'@

Write-File "src\FpsLatencyPanel.App\Views\StartupView.xaml" @'
<UserControl x:Class="FpsLatencyPanel.App.Views.StartupView"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ScrollViewer Padding="24">
        <StackPanel>
            <TextBlock Text="Inicializacao" Style="{StaticResource H1}"/>
            <TextBlock Text="{Binding Hint}" Style="{StaticResource Muted}" Margin="0,0,0,14"/>

            <Button Content="Atualizar lista" HorizontalAlignment="Left" Margin="0,0,0,14"
                    Command="{Binding RefreshCommand}"/>

            <ItemsControl ItemsSource="{Binding Items}">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <Border Style="{StaticResource Card}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="{Binding Name}" FontWeight="SemiBold"/>
                                    <TextBlock Text="{Binding Command}" Style="{StaticResource Muted}"
                                               Margin="0,4,0,4" TextTrimming="CharacterEllipsis"/>
                                    <TextBlock Text="{Binding Location}" FontSize="11"
                                               Foreground="{StaticResource MutedBrush}"/>
                                </StackPanel>
                                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                                    <Border Style="{StaticResource Badge}" Margin="0,0,10,0" Background="#FF9AA6AF">
                                        <TextBlock Text="{Binding IsEnabled, Converter={StaticResource BoolToEnabledText}}"
                                                   Style="{StaticResource BadgeText}"/>
                                    </Border>
                                    <Button Content="{Binding ToggleText}"
                                            Command="{Binding DataContext.ToggleCommand, RelativeSource={RelativeSource AncestorType=UserControl}}"
                                            CommandParameter="{Binding}"/>
                                </StackPanel>
                            </Grid>
                        </Border>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
        </StackPanel>
    </ScrollViewer>
</UserControl>
'@

Write-File "src\FpsLatencyPanel.App\Views\StartupView.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows.Controls;

public partial class StartupView : UserControl
{
    public StartupView() => InitializeComponent();
}
'@

Write-File "src\FpsLatencyPanel.App\Views\BackupView.xaml" @'
<UserControl x:Class="FpsLatencyPanel.App.Views.BackupView"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ScrollViewer Padding="24">
        <StackPanel>
            <TextBlock Text="Backup" Style="{StaticResource H1}"/>

            <Border Style="{StaticResource Card}">
                <StackPanel>
                    <TextBlock Text="Reverter tudo" Style="{StaticResource H2}"/>
                    <TextBlock Style="{StaticResource Muted}" Margin="0,0,0,10"
                               Text="Desfaz TODOS os ajustes feitos pelo painel. Limpeza nao e reversivel (arquivos apagados nao voltam). Reversao nao exige reboot."/>
                    <Button Style="{StaticResource DangerButton}"
                            Content="Reverter todos os ajustes"
                            HorizontalAlignment="Left"
                            Command="{Binding RevertAllCommand}"/>
                </StackPanel>
            </Border>

            <Border Style="{StaticResource Card}">
                <StackPanel>
                    <TextBlock Text="Log de operacoes" Style="{StaticResource H2}"/>
                    <TextBlock Text="{Binding LogPath}" Style="{StaticResource Muted}" Margin="0,0,0,10"/>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                        <Button Content="Atualizar" Command="{Binding RefreshCommand}"/>
                        <Button Content="Abrir pasta do log" Margin="8,0,0,0" Command="{Binding OpenLogFolderCommand}"/>
                    </StackPanel>

                    <ListBox ItemsSource="{Binding Recent}" MaxHeight="400">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <Border Padding="6" BorderBrush="{StaticResource BorderBrush}" BorderThickness="0,0,0,1">
                                    <StackPanel>
                                        <TextBlock FontFamily="Consolas" FontSize="11">
                                            <Run Text="{Binding TimestampUtc, StringFormat=HH:mm:ss}"/>
                                            <Run Text="  ["/>
                                            <Run Text="{Binding Level}"/>
                                            <Run Text="] "/>
                                            <Run Text="{Binding Source}" FontWeight="SemiBold"/>
                                        </TextBlock>
                                        <TextBlock Text="{Binding Message}" TextWrapping="Wrap" FontSize="12" Margin="0,2,0,0"/>
                                    </StackPanel>
                                </Border>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>
            </Border>
        </StackPanel>
    </ScrollViewer>
</UserControl>
'@

Write-File "src\FpsLatencyPanel.App\Views\BackupView.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows.Controls;

public partial class BackupView : UserControl
{
    public BackupView() => InitializeComponent();
}
'@

Write-File "src\FpsLatencyPanel.App\Views\LicenseView.xaml" @'
<UserControl x:Class="FpsLatencyPanel.App.Views.LicenseView"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ScrollViewer Padding="24">
        <StackPanel>
            <TextBlock Text="Licenca" Style="{StaticResource H1}"/>

            <Border Style="{StaticResource Card}">
                <StackPanel>
                    <TextBlock Text="Status" Style="{StaticResource H2}"/>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,8">
                        <Border Style="{StaticResource Badge}" Background="{Binding StatusColor}">
                            <TextBlock Text="{Binding StatusText}" Style="{StaticResource BadgeText}"/>
                        </Border>
                    </StackPanel>
                    <TextBlock Text="{Binding StatusMessage}" Style="{StaticResource Muted}"/>
                    <TextBlock Text="{Binding CustomerName}" Margin="0,8,0,0"/>
                    <TextBlock Text="{Binding ExpiresText}" Style="{StaticResource Muted}"/>
                </StackPanel>
            </Border>

            <Border Style="{StaticResource Card}">
                <StackPanel>
                    <TextBlock Text="Machine ID deste computador" Style="{StaticResource H2}"/>
                    <TextBlock Style="{StaticResource Muted}" Margin="0,0,0,8"
                               Text="Se voce comprou uma licenca vinculada ao computador, envie este ID para o vendedor."/>
                    <StackPanel Orientation="Horizontal">
                        <Border Background="#FF0B0E11" Padding="10,6" CornerRadius="4"
                                BorderBrush="{StaticResource BorderBrush}" BorderThickness="1">
                            <TextBlock Text="{Binding MachineId}" FontFamily="Consolas" FontSize="13"/>
                        </Border>
                        <Button Content="Copiar" Margin="10,0,0,0" Command="{Binding CopyMachineIdCommand}"/>
                    </StackPanel>
                </StackPanel>
            </Border>

            <Border Style="{StaticResource Card}">
                <StackPanel>
                    <TextBlock Text="Ativar licenca" Style="{StaticResource H2}"/>
                    <TextBlock Style="{StaticResource Muted}" Margin="0,0,0,8"
                               Text="Cole a key recebida por email. A validacao e 100% offline - o painel nao acessa a internet."/>
                    <TextBox Text="{Binding KeyInput, UpdateSourceTrigger=PropertyChanged}"
                             Height="70" AcceptsReturn="True" TextWrapping="Wrap"
                             VerticalScrollBarVisibility="Auto"
                             Background="#FF0B0E11" Foreground="{StaticResource TextBrush}"
                             BorderBrush="{StaticResource BorderBrush}" Padding="8"
                             FontFamily="Consolas" FontSize="11" Margin="0,0,0,10"/>
                    <StackPanel Orientation="Horizontal">
                        <Button Style="{StaticResource PrimaryButton}" Content="Ativar" Command="{Binding ActivateCommand}"/>
                        <Button Content="Desativar (trocar de PC)" Margin="10,0,0,0"
                                Style="{StaticResource DangerButton}"
                                Command="{Binding DeactivateCommand}"/>
                    </StackPanel>
                </StackPanel>
            </Border>
        </StackPanel>
    </ScrollViewer>
</UserControl>
'@

Write-File "src\FpsLatencyPanel.App\Views\LicenseView.xaml.cs" @'
namespace FpsLatencyPanel.App.Views;

using System.Windows.Controls;

public partial class LicenseView : UserControl
{
    public LicenseView() => InitializeComponent();
}
'@

# DataTemplates de mapeamento ViewModel -> View
Write-File "src\FpsLatencyPanel.App\Views\ViewModelMappings.xaml" @'
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                    xmlns:vm="clr-namespace:FpsLatencyPanel.App.ViewModels"
                    xmlns:v="clr-namespace:FpsLatencyPanel.App.Views">

    <DataTemplate DataType="{x:Type vm:HomeViewModel}">
        <v:HomeView/>
    </DataTemplate>
    <DataTemplate DataType="{x:Type vm:MouseKeyboardViewModel}">
        <v:MouseKeyboardView/>
    </DataTemplate>
    <DataTemplate DataType="{x:Type vm:GamesPowerViewModel}">
        <v:GamesPowerView/>
    </DataTemplate>
    <DataTemplate DataType="{x:Type vm:NetworkViewModel}">
        <v:NetworkView/>
    </DataTemplate>
    <DataTemplate DataType="{x:Type vm:CleanupViewModel}">
        <v:CleanupView/>
    </DataTemplate>
    <DataTemplate DataType="{x:Type vm:StartupViewModel}">
        <v:StartupView/>
    </DataTemplate>
    <DataTemplate DataType="{x:Type vm:BackupViewModel}">
        <v:BackupView/>
    </DataTemplate>
    <DataTemplate DataType="{x:Type vm:LicenseViewModel}">
        <v:LicenseView/>
    </DataTemplate>

</ResourceDictionary>
'@

Write-Host "  App: Views OK." -ForegroundColor DarkGray
Write-Host ""

# Registrar mappings no App.xaml
$appXamlPath = Join-Path $root "src\FpsLatencyPanel.App\App.xaml"
if (Test-Path $appXamlPath) {
    $content = Get-Content $appXamlPath -Raw
    $content = $content -replace '<ResourceDictionary Source="Resources/DarkTheme.xaml"/>',
        '<ResourceDictionary Source="Resources/DarkTheme.xaml"/><ResourceDictionary Source="Views/ViewModelMappings.xaml"/>'
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($appXamlPath, $content, $utf8NoBom)
    Write-Host "  App.xaml: mappings registrados." -ForegroundColor DarkGray
}