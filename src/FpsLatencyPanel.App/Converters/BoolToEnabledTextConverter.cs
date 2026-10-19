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