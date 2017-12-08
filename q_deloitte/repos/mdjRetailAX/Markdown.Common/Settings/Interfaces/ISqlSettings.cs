namespace Markdown.Common.Settings.Interfaces
{
    public interface ISqlSettings
    {
        string AppConnectionString { get; }
        string EphemeralConnectionString { get; }
    }
}