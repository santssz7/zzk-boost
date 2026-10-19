namespace FpsLatencyPanel.Core.Licensing;

using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

public static class LicenseValidator
{
    private static readonly JsonSerializerOptions JsonOpts = new() { WriteIndented = false };

    /// <summary>Remove espaços, tabs, quebras de linha e caracteres invisíveis da key.</summary>
    private static string NormalizeKey(string raw)
    {
        if (string.IsNullOrEmpty(raw)) return "";
        var sb = new StringBuilder(raw.Length);
        foreach (var c in raw)
        {
            if (char.IsWhiteSpace(c)) continue;
            if (c == '\uFEFF') continue; // BOM
            if (c == '\u200B') continue; // zero-width space
            sb.Append(c);
        }
        return sb.ToString();
    }

    public static LicenseInfo Validate(string key, string currentMachineId)
    {
        var clean = NormalizeKey(key ?? "");

        if (string.IsNullOrWhiteSpace(clean))
            return Fail(LicenseStatus.Missing, "Nenhuma licença informada.");

        SignedLicense? signed;
        try
        {
            var json = Encoding.UTF8.GetString(Convert.FromBase64String(clean));
            signed = JsonSerializer.Deserialize<SignedLicense>(json, JsonOpts);
        }
        catch
        {
            return Fail(LicenseStatus.Corrupted, "Formato de licença inválido. Verifique se copiou a key inteira, sem faltar pedaços.");
        }

        if (signed is null || string.IsNullOrWhiteSpace(signed.PayloadBase64) || string.IsNullOrWhiteSpace(signed.SignatureBase64))
            return Fail(LicenseStatus.Corrupted, "Licença incompleta.");

        try
        {
            var payloadBytes = Convert.FromBase64String(signed.PayloadBase64);
            var signatureBytes = Convert.FromBase64String(signed.SignatureBase64);

            using var rsa = RSA.Create();
            rsa.FromXmlString(LicensingConstants.PublicKeyXml);

            if (!rsa.VerifyData(payloadBytes, signatureBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1))
                return Fail(LicenseStatus.InvalidSignature, "Assinatura da licença não confere. Key não é autêntica.");
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
            return Fail(LicenseStatus.Corrupted, "Payload da licença corrompido.");
        }
        if (payload is null)
            return Fail(LicenseStatus.Corrupted, "Payload vazio.");

        if (!string.IsNullOrWhiteSpace(payload.ExpiresAtUtc))
        {
            if (DateTimeOffset.TryParse(payload.ExpiresAtUtc, out var exp) && exp < DateTimeOffset.UtcNow)
                return new LicenseInfo(LicenseStatus.Expired, payload.CustomerName, payload.CustomerEmail,
                    exp, payload.HardwareId, $"Licença expirada em {exp:yyyy-MM-dd}.");
        }

        if (!string.IsNullOrWhiteSpace(payload.HardwareId))
        {
            if (!string.Equals(payload.HardwareId, currentMachineId, StringComparison.OrdinalIgnoreCase))
                return new LicenseInfo(LicenseStatus.HardwareMismatch, payload.CustomerName, payload.CustomerEmail,
                    ParseNullableDate(payload.ExpiresAtUtc), payload.HardwareId,
                    "Esta licença é vinculada a outro computador.");
        }

        return new LicenseInfo(LicenseStatus.Valid, payload.CustomerName, payload.CustomerEmail,
            ParseNullableDate(payload.ExpiresAtUtc), payload.HardwareId,
            "Licença válida.");
    }

    private static DateTimeOffset? ParseNullableDate(string? s)
        => DateTimeOffset.TryParse(s, out var d) ? d : null;

    private static LicenseInfo Fail(LicenseStatus st, string msg)
        => new(st, null, null, null, null, msg);
}