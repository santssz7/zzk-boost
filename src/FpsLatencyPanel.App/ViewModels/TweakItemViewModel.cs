namespace FpsLatencyPanel.App.ViewModels;

using FpsLatencyPanel.Core.Abstractions;

public sealed class TweakItemViewModel : ViewModelBase
{
    public ITweak Tweak { get; }

    private DateTime _lastManualSet = DateTime.MinValue;
    private bool _stickyApplied;

    private TweakStateKind _state = TweakStateKind.Desconhecido;
    public TweakStateKind State
    {
        get => _state;
        private set
        {
            if (Set(ref _state, value))
            {
                OnPropertyChanged(nameof(StateText));
                OnPropertyChanged(nameof(IsApplied));
            }
        }
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
        // Guarda contra corrida: se acabou de aplicar/reverter, não sobrescreve por 10s
        if ((DateTime.UtcNow - _lastManualSet).TotalSeconds < 10)
            return;

        // Se foi marcado como Ativo e o Detect retornar Inativo, só "solta" depois de 2 checagens
        Busy = true;
        try
        {
            try
            {
                var s = await Tweak.DetectAsync(ct).WaitAsync(TimeSpan.FromSeconds(5), ct);

                // Se estava sticky applied e o detect diz aplicado, mantém sticky (tudo certo)
                // Se estava sticky applied e o detect diz NÃO aplicado, libera o sticky
                if (_stickyApplied && s.Kind == TweakStateKind.Aplicado)
                {
                    State = s.Kind;
                    StateDetail = s.Detalhe;
                }
                else
                {
                    _stickyApplied = false;
                    State = s.Kind;
                    StateDetail = s.Detalhe;
                }
            }
            catch (TimeoutException)
            {
                State = TweakStateKind.Desconhecido;
                StateDetail = "Tempo esgotado ao detectar.";
            }
            catch (OperationCanceledException) { }
            catch (Exception ex)
            {
                State = TweakStateKind.Desconhecido;
                StateDetail = ex.Message;
            }
        }
        finally { Busy = false; }
    }

    public void MarkAsApplied(string detail = "Aplicado.")
    {
        _lastManualSet = DateTime.UtcNow;
        _stickyApplied = true;
        State = TweakStateKind.Aplicado;
        StateDetail = detail;
    }

    public void MarkAsNotApplied(string detail = "Revertido.")
    {
        _lastManualSet = DateTime.UtcNow;
        _stickyApplied = false;
        State = TweakStateKind.NaoAplicado;
        StateDetail = detail;
    }

    public void MarkAsNotApplicable(string detail = "Não aplicável.")
    {
        _lastManualSet = DateTime.UtcNow;
        _stickyApplied = false;
        State = TweakStateKind.NaoAplicavel;
        StateDetail = detail;
    }
}