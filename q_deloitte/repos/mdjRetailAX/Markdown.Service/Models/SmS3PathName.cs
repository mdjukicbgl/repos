namespace Markdown.Service.Models
{
    public struct SmS3PathName
    {
        // Model generation
        public static SmS3PathName Model = new SmS3PathName("model.json");
        public static SmS3PathName ElasticityHierarchy = new SmS3PathName("elasticity_hierarchy.json");
        public static SmS3PathName DecayHierarchy = new SmS3PathName("decay_hierarchy.json");

        // Scenario
        public static SmS3PathName ScenarioBase = new SmS3PathName("");
        public static SmS3PathName Scenario = new SmS3PathName("scenario.json");
        public static SmS3PathName ScenarioHeader = new SmS3PathName("scenario_header.json");
        public static SmS3PathName PriceLadderValue = new SmS3PathName("price_ladder_value.json");
        public static SmS3PathName Hierarchy = new SmS3PathName("hierarchy.json");
        public static SmS3PathName HierarchySellThrough = new SmS3PathName("hierarchy_sell_through.json");
        public static SmS3PathName Product = new SmS3PathName("product.json");
        public static SmS3PathName ProductHierarchy = new SmS3PathName("product_hierarchy.json");
        public static SmS3PathName ProductPriceLadder = new SmS3PathName("product_price_ladder.json");
        public static SmS3PathName ProductParameterValues = new SmS3PathName("product_parameter_values.json");
        public static SmS3PathName ProductMarkdownConstraint = new SmS3PathName("product_markdown_constraint.json");
        public static SmS3PathName ProductMinimumAbsolutePriceChange = new SmS3PathName("product_minimum_absolute_price_change.json");
        public static SmS3PathName ProductSalesTax = new SmS3PathName("product_sales_tax.json");
        public static SmS3PathName ProductWeekParameterValues = new SmS3PathName("product_week_parameter_values.json");
        public static SmS3PathName ProductWeekMarkdownTypeParameterValues = new SmS3PathName("product_week_markdown_type_parameter_values.json");
        public static SmS3PathName SalesFlexFactor = new SmS3PathName("product_sales_flex_factor.json");
        public static SmS3PathName Output = new SmS3PathName("output.json");

        private readonly string _value;

        private SmS3PathName(string value)
        {
            _value = value;
        }

        public override string ToString()
        {
            return _value;
        }
    }
}