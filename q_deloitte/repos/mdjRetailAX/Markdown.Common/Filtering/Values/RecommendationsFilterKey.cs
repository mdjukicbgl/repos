using Markdown.Common.Attributes;

namespace Markdown.Common.Filtering.Values
{
    public enum RecommendationsKey
	{
        HierarchyName,
        ProductId,
        ProductName,
		OriginalSellingPrice,
        CurrentSellingPrice,
        SellThroughTarget,
	    TerminalStock,
        TotalRevenue,
        Status,

        [StringValue("DecisionRecommendation.Price1")]
        Price1,
	    [StringValue("DecisionRecommendation.Discount1")]
        Discount1,

	    [StringValue("DecisionRecommendation.Price2")]
        Price2,
	    [StringValue("DecisionRecommendation.Discount2")]
        Discount2,

	    [StringValue("DecisionRecommendation.Price3")]
        Price3,
	    [StringValue("DecisionRecommendation.Discount3")]
        Discount3,

	    [StringValue("DecisionRecommendation.Price4")]
        Price4,
	    [StringValue("DecisionRecommendation.Discount4")]
        Discount4,

	    [StringValue("DecisionRecommendation.Price5")]
        Price5,
	    [StringValue("DecisionRecommendation.Discount5")]
        Discount5,

	    [StringValue("DecisionRecommendation.Price6")]
        Price6,
	    [StringValue("DecisionRecommendation.Discount6")]
        Discount6,

	    [StringValue("DecisionRecommendation.Price7")]
        Price7,
	    [StringValue("DecisionRecommendation.Discount7")]
        Discount7,

	    [StringValue("DecisionRecommendation.Price8")]
        Price8,
	    [StringValue("DecisionRecommendation.Discount8")]
        Discount8,

	    [StringValue("DecisionRecommendation.Price9")]
        Price9,
	    [StringValue("DecisionRecommendation.Discount9")]
        Discount9,

	    [StringValue("DecisionRecommendation.Price10")]
        Price10,
	    [StringValue("DecisionRecommendation.Discount10")]
        Discount10,

	    [StringValue("DecisionRecommendation.TotalMarkdownCost")]
        MarkdownCost
	}
}
