export interface Scenario {
  scenarioId: number;
  duration: number;
  partitionTotal:number;
  partitionCount:number;
  partitionErrorCount:number;
  partitionSuccessCount:number;
  status:string;
  lastRunDate:Date;
  productCount:number;
  recommendationCount:number;
  clientId:number;
  scenarioName:string,
  week:number;
  scheduleMask:number;
  scheduleWeekMin:number;
  scheduleWeekMax:number;
  scheduleStageMin:number;
  scheduleStageMax:number;
  stageMax:number;
  stageOffsetMax:number;
  priceFloor:number;
  // Totals
  productsCost: number;
  productsAcceptedCost: number;
  productsAcceptedCount: number;
  productsRejectedCount: number;
  //Stubbed
  statusNew:boolean;
  statusPublished:boolean;
  statusAccepted:boolean;
  statusRejected:boolean;
  productGroupSummary: ProductGroupSummary[];
}

export interface ProductGroupSummary {
  //Workaround for filtering issues.
  scenarioName: string;
  status: string;

  name: string;
  merchDecision: ProductGroupSummaryDetails[];
  current: ProductGroupSummaryDetails[];
  recommended: ProductGroupSummaryDetails[];
}

export interface ProductGroupSummaryDetails {
  markdownWeek: number;
  tpnInMardown: number;
  tpnBeforemMarkdown: number;
  markdownMarginAverage: number;
  markdownMarginOverall: number;
  expectedStockLevelBeforePriceChange: number;
  terminalStockEstimateCount: number;
  terminalStockEstimateCost: number;
  unitsSoldInMarkdownPeriodEstimate: number;
  salesInMarkdownPeriodEstimate: number;
  markdownCostEstimate: number;
  profitEstimate: number;
  acceptedPercentage: number;
  revisedPercentage: number;
  rejectedPercentage: number;
}
