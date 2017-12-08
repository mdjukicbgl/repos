using Microsoft.EntityFrameworkCore.Infrastructure;
using PostgreSQLCopyHelper;

using Markdown.Data.Entity.App;
namespace Markdown.Data.Repository.Ef
{
    public interface IRecommendationProjectionRepository : IBaseEntityRepository<RecommendationProjection>
    {
	}

    public class RecommendationProjectionRepository : BaseEntityRepository<RecommendationProjection>, IRecommendationProjectionRepository
    {
        public static PostgreSQLCopyHelper<RecommendationProjection> Helper =
            new PostgreSQLCopyHelper<RecommendationProjection>("recommendation_projection")
                .MapUUID("recommendation_projection_guid", x => x.RecommendationProjectionGuid)
                .MapUUID("recommendation_guid", x => x.RecommendationGuid)

                .MapInteger("client_id", x => x.ClientId)
                .MapInteger("scenario_id", x => x.ScenarioId)

                .MapInteger("week", x => x.Week)
                .MapNumeric("discount", x => x.Discount)
                .MapNumeric("price", x => x.Price)
                .MapInteger("quantity", x => x.Quantity)
                .MapNumeric("revenue", x => x.Revenue)
                .MapInteger("stock", x => x.Stock)
                .MapNumeric("markdown_cost", x => x.MarkdownCost)
                .MapInteger("accumulated_markdown_count", x => x.AccumulatedMarkdownCount)
                .MapInteger("markdown_count", x => x.MarkdownCount)
                .MapNumeric("elasticity", x => x.Elasticity)
                .MapNumeric("decay", x => x.Decay)
                .MapInteger("markdown_type_id", x => x.MarkdownTypeId);

        public RecommendationProjectionRepository(IDbContextFactory<MarkdownEfContext> contextFactory) :
            base(contextFactory)
        {
        }
    }
}
