namespace Markdown.Common.Settings.Interfaces
{
    public interface IS3Settings
    {
        string S3ModelBucketName { get; }
        string S3ModelTemplate { get; }
        string S3ScenarioTemplate { get; }

        string S3ScenarioBucketName { get; }
        string S3ScenarioPartitionTemplate { get; }
    }
}