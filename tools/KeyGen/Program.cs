using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace FpsLatencyPanel.KeyGen;

internal static class Program
{
    private static readonly JsonSerializerOptions JsonOpts = new() { WriteIndented = false };
    private const string ProductName = "ZZK BOOST";

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
        Console.WriteLine($"KeyGen - {ProductName}");
        Console.WriteLine("  KeyGen init");
        Console.WriteLine("  KeyGen issue --name \"Joao Silva\" [--email joao@x.com] [--serial 000123]");
        Console.WriteLine("                [--expires 2026-12-31] [--hwid abcdef0123456789]");
        Console.WriteLine("  KeyGen inspect --key <base64>");
        return 1;
    }

    private static int Init()
    {
        using var rsa = RSA.Create(2048);
        File.WriteAllText("private.xml", rsa.ToXmlString(true));
        File.WriteAllText("public.xml",  rsa.ToXmlString(false));
        Console.WriteLine("Par de chaves gerado.");
        Console.WriteLine("AVISO: private.xml - NUNCA SAIA DESTA MAQUINA.");
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

        if (string.IsNullOrWhiteSpace(name)) { Console.Error.WriteLine("--name e obrigatorio."); return 1; }
        if (!File.Exists("private.xml")) { Console.Error.WriteLine("Rode `KeyGen init` primeiro."); return 1; }

        var payload = new LicensePayload
        {
            Version = 1,
            Product = ProductName,
            CustomerName = name,
            CustomerEmail = email,
            IssuedAtUtc = DateTime.UtcNow.ToString("O"),
            ExpiresAtUtc = string.IsNullOrWhiteSpace(expires) ? null : DateTimeOffset.Parse(expires + "T23:59:59Z").ToString("O"),
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

        var key = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(signed, JsonOpts)));

                // Salva em arquivo (elimina problema de copy/paste do terminal)
        var outPath = Path.Combine(Directory.GetCurrentDirectory(), "key.txt");
        File.WriteAllText(outPath, key, new UTF8Encoding(false));

        Console.WriteLine();
        Console.WriteLine("=== KEY GERADA ===");
        Console.WriteLine("Salva em: " + outPath);
        Console.WriteLine("(O painel agora pode ler direto desse arquivo.)");
        Console.WriteLine("=== FIM ===");
        return 0;
    }

    private static int Inspect(string[] args)
    {
        var key = GetArg(args, "--key");
        if (string.IsNullOrWhiteSpace(key)) { Console.Error.WriteLine("--key obrigatorio."); return 1; }
        try
        {
            var json = Encoding.UTF8.GetString(Convert.FromBase64String(key));
            var signed = JsonSerializer.Deserialize<SignedLicense>(json, JsonOpts)!;
            var payloadBytes = Convert.FromBase64String(signed.PayloadBase64);
            var payload = JsonSerializer.Deserialize<LicensePayload>(payloadBytes, JsonOpts)!;
            Console.WriteLine($"Cliente: {payload.CustomerName}");
            Console.WriteLine($"Produto: {payload.Product}");
            Console.WriteLine($"Serial:  {payload.Serial}");
            Console.WriteLine($"Expira:  {payload.ExpiresAtUtc ?? "nunca"}");
            Console.WriteLine($"HWID:    {payload.HardwareId ?? "nao travado"}");
            return 0;
        }
        catch (Exception ex) { Console.Error.WriteLine("Falha: " + ex.Message); return 1; }
    }

    private static string? GetArg(string[] args, string name)
    {
        for (int i = 0; i < args.Length - 1; i++)
            if (args[i].Equals(name, StringComparison.OrdinalIgnoreCase)) return args[i + 1];
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