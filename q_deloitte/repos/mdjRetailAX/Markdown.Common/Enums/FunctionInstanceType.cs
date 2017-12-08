namespace Markdown.Common.Enums
{
    public enum FunctionInstanceType
    {
        None,

        ModelStarting,
        ModelRunning,
        ModelFinished,
        ModelError,

        PartitionStarting,
        PartitionRunning,
        PartitionFinished,
        PartitionError,

        CalculateStarting,
        CalculateRunning,
        CalculateFinished,
        CalculateError,

        UploadStarting,
        UploadRunning,
        UploadFinished,
        UploadError
    }
}