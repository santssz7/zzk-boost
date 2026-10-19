namespace FpsLatencyPanel.App.Converters;

using System.Globalization;
using System.Windows;
using System.Windows.Data;

public sealed class StringNotEmptyToVisConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => string.IsNullOrWhiteSpace(value as string) ? Visibility.Collapsed : Visibility.Visible;

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotSupportedException();
}