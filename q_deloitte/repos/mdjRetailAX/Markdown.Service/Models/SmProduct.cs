using System;
using System.Linq;
using System.Collections.Generic;
using Markdown.Common.Enums;
using Serilog;

using Markdown.Data.Entity.Ephemeral;

namespace Markdown.Service.Models
{
    public class SmProduct
    {
        public int ProductId { get; set; }
        public int HierarchyId { get; set; }
        public string HierarchyName { get; set; }
        public string HierarchyPath { get; set; }
        public string Name { get; set; }
        public int CurrentMarkdownCount { get; set; }
        public int CurrentStock { get; set; }
        public decimal CurrentCostPrice { get; set; }
        public int CurrentSalesQuantity { get; set; }
        public decimal CurrentSellingPrice { get; set; }
        public decimal OriginalSellingPrice { get; set; }
        public Tuple<int, decimal> SalesTax { get; private set; }
        public decimal SellThrough { get; set; }
        public SmProductPriceLadder PriceLadder { get; set; }
        public decimal CurrentCover { get; set; }
        public int? ProductScheduleMask { get; set; }
        public int? ProductMaxMarkdown { get; set; }

        public decimal[] SalesFlexFactor { get; set; }
        public MarkdownType[] MarkdownTypeConstraint { get; set; }
        public decimal MinimumAbsolutePriceChange { get; set; }
        public decimal[] MinimumRelativePercentagePriceChange { get; set; }
        public decimal[] MinDiscountsNew { get; set; }
        public decimal[] MinDiscountsFurther { get; set; }
        public decimal[] MaxDiscountsNew { get; set; }
        public decimal[] MaxDiscountsFurther { get; set; }
        public MarkdownType CurrentMarkdownType { get; set; }
        public int ProductHasExceededFlowlineThreshold { get; set; }

        // TODO return errors here to SmCalcProduct
        public static SmProduct Build(ILogger logger, Product entity, List<ProductHierarchy> productHierarchies,
            List<ProductPriceLadder> productPriceLadders, List<SmPriceLadder> priceLadders,
            Dictionary<int, decimal> hierarchySellThrough, Dictionary<int, Tuple<int, decimal>> productSalesTax,
            List<ProductParameterValues> productParameterValues, List<ProductMarkdownConstraint> productMarkdownConstraint, 
            List<ProductSalesFlexFactor> salesFlexFactor, List<ProductMinimumAbsolutePriceChange> productMinimumAbsolutePriceChange, 
            List<ProductWeekParameterValues> productWeekParameterValues, List<ProductWeekMarkdownTypeParameterValues> productWeekMarkdownTypeParameterValues)
        {
            if (entity == null)
                return null;

            try
            {
                // TODO support multiple hierarchies
                var hierarchy = productHierarchies.FirstOrDefault(x => x.ProductId == entity.ProductId);
                if (hierarchy == null)
                {
                    logger.Error("Product {ProductId} is missing a ProductHierarchy entry", entity.ProductId);
                    return null;
                }

                // TODO support multiple price ladders
                var priceLadderId = productPriceLadders.Where(x => x.ProductId == entity.ProductId)
                    .Select(x => x.PriceLadderId).FirstOrDefault();
                if (priceLadderId == 0)
                {
                    logger.Error("Product {ProductId} is missing a ProductPriceLadder entry", entity.ProductId);
                    return null;
                }

                var ladder = priceLadders.FirstOrDefault(x => x.PriceLadderId == priceLadderId);
                if (ladder == null)
                {
                    logger.Error("PriceLadders is missing price ladder {PriceLadderId} for product {ProductId}",
                        priceLadderId, entity.ProductId);
                    return null;
                }

                var parameterValues = productParameterValues.FirstOrDefault(x => x.ProductId == entity.ProductId);

                var markdownTypeConstraints = productMarkdownConstraint.Where(x => x.ProductId == entity.ProductId)
                    .GroupBy(x => new {x.ProductId, x.Week, x.MarkdownTypeId})
                    .OrderBy(y => y.Key.Week)
                    .Select(y => y.Key.MarkdownTypeId)
                    .ToArray();

                var flexFactors = salesFlexFactor
                                    .Where(x => x.ProductId == entity.ProductId)
                                    .OrderBy(x => x.Week)
                                    .Select(x => x.FlexFactor)
                                    .ToArray();

                if (!flexFactors.Any())
                {
                    logger.Error("Product {ProductId} is missing a SalesFlexFactor entry", entity.ProductId);
                    return null;
                }

                var minimumAbsolutePriceChange = productMinimumAbsolutePriceChange.FirstOrDefault(x => x.ProductId == entity.ProductId);

                var minimumRelativePercentagePriceChanges = productWeekParameterValues
                    .Where(x => x.ProductId == entity.ProductId)
                    .GroupBy(x => new {x.ProductId, x.Week, x.MinimumRelativePercentagePriceChange})
                    .OrderBy(y => y.Key.Week)
                    .Select(y => y.Key.MinimumRelativePercentagePriceChange)
                    .ToArray();

                var minDiscountsNew = productWeekMarkdownTypeParameterValues
                    .Where(x => x.ProductId == entity.ProductId && x.MarkdownTypeId == MarkdownType.New)
                    .GroupBy(x => new { x.ProductId, x.Week, x.MarkdownTypeId, x.MinDiscountPercentage })
                    .OrderBy(y => y.Key.Week)
                    .Select(y => y.Key.MinDiscountPercentage)
                    .ToArray();

                var minDiscountsFurther = productWeekMarkdownTypeParameterValues
                    .Where(x => x.ProductId == entity.ProductId && x.MarkdownTypeId == MarkdownType.Further)
                    .GroupBy(x => new { x.ProductId, x.Week, x.MarkdownTypeId, x.MinDiscountPercentage })
                    .OrderBy(y => y.Key.Week)
                    .Select(y => y.Key.MinDiscountPercentage)
                    .ToArray();

                var maxDiscountsNew = productWeekMarkdownTypeParameterValues
                    .Where(x => x.ProductId == entity.ProductId && x.MarkdownTypeId == MarkdownType.New)
                    .GroupBy(x => new { x.ProductId, x.Week, x.MarkdownTypeId, x.MaxDiscountPercentage })
                    .OrderBy(y => y.Key.Week)
                    .Select(y => y.Key.MaxDiscountPercentage)
                    .ToArray();

                var maxDiscountsFurther = productWeekMarkdownTypeParameterValues
                    .Where(x => x.ProductId == entity.ProductId && x.MarkdownTypeId == MarkdownType.Further)
                    .GroupBy(x => new { x.ProductId, x.Week, x.MarkdownTypeId, x.MaxDiscountPercentage })
                    .OrderBy(y => y.Key.Week)
                    .Select(y => y.Key.MaxDiscountPercentage)
                    .ToArray();

                var result = new SmProduct
                {
                    ProductId = entity.ProductId,
                    CurrentCostPrice = entity.CurrentCostPrice,
                    CurrentMarkdownCount = entity.CurrentMarkdownCount,
                    CurrentSalesQuantity = entity.CurrentSalesQuantity,
                    CurrentSellingPrice = entity.CurrentSellingPrice,
                    CurrentStock = entity.CurrentStock,
                    HierarchyId = hierarchy.HierarchyId,
                    HierarchyPath = hierarchy.HierarchyPath,
                    HierarchyName = hierarchy.HierarchyName,
                    Name = entity.Name,
                    OriginalSellingPrice = entity.OriginalSellingPrice,
                    PriceLadder = SmProductPriceLadder.Build(ladder),
                    CurrentCover = entity.CurrentCover,
                    ProductScheduleMask = parameterValues?.Mask,
                    ProductMaxMarkdown = parameterValues?.MaxMarkdown,
                    SalesFlexFactor = flexFactors,
                    MarkdownTypeConstraint = markdownTypeConstraints,
                    MinimumAbsolutePriceChange = minimumAbsolutePriceChange.MinimumAbsolutePriceChange,
                    MinimumRelativePercentagePriceChange = minimumRelativePercentagePriceChanges,
                    MinDiscountsNew = minDiscountsNew,
                    MinDiscountsFurther = minDiscountsFurther,
                    MaxDiscountsNew = maxDiscountsNew,
                    MaxDiscountsFurther = maxDiscountsFurther,
                    CurrentMarkdownType = entity.CurrentMarkdownType,
                    ProductHasExceededFlowlineThreshold = parameterValues.HasExceededFlowlineThreshold
                };

                if (productSalesTax.TryGetValue(entity.ProductId, out Tuple<int, decimal> salesTax))
                    result.SalesTax = salesTax;
               
                if (hierarchySellThrough.TryGetValue(hierarchy.HierarchyId, out decimal sellThrough))
                    result.SellThrough = sellThrough;

                return result;
            }
            catch (Exception e)
            {
                logger.Error(e, "There was an error building product {ProductId} from partition {PartitionNumber}",
                    entity.ProductId, entity.PartitionNumber);
                throw;
            }
        }

        public static List<SmProduct> Build(ILogger logger, List<Product> products,
            List<ProductHierarchy> productHierarchies, List<ProductPriceLadder> productPriceLadders,
            List<PriceLadderValue> priceLadderValues, Dictionary<int, decimal> hierarchySellThrough,
            Dictionary<int, Tuple<int, decimal>> productSalesTax, List<ProductParameterValues> productParameterValues, 
            List<ProductMarkdownConstraint> productMarkdownConstraint, List<ProductSalesFlexFactor> salesFlexFactor, 
            List<ProductMinimumAbsolutePriceChange> productMinimumAbsolutePriceChange, 
            List<ProductWeekParameterValues> productWeekParameterValues,
            List<ProductWeekMarkdownTypeParameterValues> productWeekMarkdownTypeParameterValues)
        {
            var priceLadders = SmPriceLadder.Build(priceLadderValues);
            return products?
                .Select(x => Build(logger, x, productHierarchies, productPriceLadders, priceLadders,
                    hierarchySellThrough, productSalesTax, productParameterValues, productMarkdownConstraint, salesFlexFactor, productMinimumAbsolutePriceChange, productWeekParameterValues, productWeekMarkdownTypeParameterValues))
                .Where(x => x != null)
                .ToList();
        }
    }
}