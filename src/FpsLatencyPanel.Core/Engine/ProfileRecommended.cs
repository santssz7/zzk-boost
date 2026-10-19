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