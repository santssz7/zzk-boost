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