namespace Markdown.Common.Enums
{
    public enum RecommendationSubStatus
    {
        None,
        Ok,
        NoSchedules,
        NoSchedulesMatchProductMask,
        MaxMarkdownCountMet,
        NoRecommendations,
        HighPrediction,
        NegativeRevenue,
        InvalidCsp,
        InvalidMarkdownType,
        InvalidElasticityHierarchy,
        InvalidDecayHierarchy,
        MinimumAbsolutePriceChangeNotMet,
        MinimumRelativePercentagePriceChangeNotMet,
        DiscountPercentageOutsideAllowedRange
    }
}