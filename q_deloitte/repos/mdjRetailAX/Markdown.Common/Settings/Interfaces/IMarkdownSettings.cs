namespace Markdown.Common.Settings.Interfaces
{
    public interface IMarkdownSettings
    {
        int OrganisationId { get; }
        int UserId { get; }
        int ModelId { get; }
        int ModelRunId { get; }
        int ScenarioId { get; }
        int RevisionId { get; }
        int PartitionId { get; }
        int PartitionCount { get; }
        bool Upload { get; }
        bool Calculate { get; }
    }
}