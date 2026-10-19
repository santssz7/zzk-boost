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