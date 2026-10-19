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