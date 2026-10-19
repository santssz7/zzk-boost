namespace FpsLatencyPanel.App.Controls;

using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

public partial class CircularGauge : UserControl
{
    public static readonly DependencyProperty ValueProperty = DependencyProperty.Register(
        nameof(Value), typeof(double), typeof(CircularGauge),
        new PropertyMetadata(0.0, OnValueChanged));

    public double Value
    {
        get => (double)GetValue(ValueProperty);
        set => SetValue(ValueProperty, value);
    }

    public CircularGauge()
    {
        InitializeComponent();
        Loaded += (_, _) => UpdateArc();
    }

    private static void OnValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        if (d is CircularGauge gauge) gauge.UpdateArc();
    }

    private void UpdateArc()
    {
        try
        {
            if (ProgressCircle == null || PercentText == null) return;

            // Tamanho do Grid é 100. Com margem 6 e espessura 8, o raio é ~38.
            double radius = 38; 
            double perimeter = 2 * Math.PI * radius;
            
            double val = Value;
            if (val < 0) val = 0;
            if (val > 100) val = 100;

            // O DashArray funciona como: (Tamanho preenchido, Tamanho do vazio)
            double filled = (val / 100.0) * perimeter;
            double empty = perimeter - filled;

            ProgressCircle.StrokeDashArray = new DoubleCollection { filled, empty };
            
            // Offset para alinhar o final arredondado (StrokeStartLineCap/EndLineCap)
            ProgressCircle.StrokeDashOffset = 0;

            PercentText.Text = $"{Math.Round(val)}%";
        }
        catch { }
    }
}