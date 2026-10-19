namespace FpsLatencyPanel.Core.Infrastructure;

using System.Runtime.InteropServices;

internal static class Shell32
{
    [ComImport, Guid("13709620-C279-11CE-A49E-444553540000")]
    public class Shell { }

    [ComImport, Guid("0D67C5B8-D3A0-11D1-8F9C-00C04FC2AD14"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface IShellDispatch
    {
        Folder NameSpace(object vDir);
    }

    [ComImport, Guid("BBCB4E22-7A8C-11D1-8F84-00C04FC2AD14"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface Folder
    {
        FolderItems Items();
        string GetDetailsOf(FolderItem item, int column);
    }

    [ComImport, Guid("744129E0-C8F1-11D1-9B1A-00C04FC2AD14"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface FolderItems : System.Collections.IEnumerable
    {
    }

    [ComImport, Guid("F4A76D8F-1C6C-11D2-9A36-00C04FC2AD14"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface FolderItem { }
}