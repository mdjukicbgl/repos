export interface GridRecommendations {
  items: ScenarioProductRecommendation[];
  projectionCount: number;
  scheduleMask: string;
  priceLadderId: number;
}

export interface ScenarioProductRecommendation {
  recommendationGuid: string;
  scenarioId: number;
  hierarchyName: string;
  productId: number;
  productName: string;
  originalSellingPrice: number;
  currentSellingPrice: number;
  sellThroughTarget: number;
  terminalStock: number;
  totalRevenue: number;
  status:number;
  projections:Projection[];
  markdownCost:number;
  priceLadderId: number;
  revisionId: number;
  currentMarkdownDepth: number;
  currentDiscountLadderDepth: number;
}

export interface PriceLadder {
  priceLadderId: number;
  priceLadderTypeId: number;
  description: string;
  values: number[];
}

export interface Projection {
  week:number;
  discount:number;
  price:number;
  quantity:number;
  revenue:number;
  schduleMask:number;
}

export interface Revision {
  week: number;
  discount: number;
}
