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