import { ProductGroupSummary } from '../../../../../scenarios/models/scenarios.entity';
import { Component, AfterViewInit } from "@angular/core";
import { GridOptions } from "ag-grid/main";
import { ICellRendererAngularComp } from "ag-grid-angular/main";

@Component({
    moduleId: module.id,
    selector: 'ag-full-width-grid',
    templateUrl: 'product-group-detail.component.html',
    styleUrls: ['product-group-detail.component.scss'],
})
export class ProductGroupDetailComponent implements ICellRendererAngularComp, AfterViewInit {
    public productGroupSummary: ProductGroupSummary[];
    public rowData: any[] = [];

    // Rows
    markdownWeekRow = [];
    tpnInMardownRow = [];
    tpnBeforeMarkdownRow = [];
    markdownMarginAverageRow = [];
    markdownMarginOverallRow = [];
    expectedStockLevelBeforePriceChangeRow = [];
    terminalStockEstimateCountRow = [];
    terminalStockEstimateCostRow = [];
    unitsSoldInMarkdownPeriodEstimateRow = [];
    salesInMarkdownPeriodEstimateRow = [];
    markdownCostEstimateRow = [];
    profitEstimateRow = [];
    acceptedPercentageRow = [];
    revisedPercentageRow = [];
    rejectedPercentageRow = [];

    constructor() {

    }

    agInit(params: any): void {
      params.api.sizeColumnsToFit();
      this.productGroupSummary = params.node.parent.data.productGroupSummary;
      this.formatData();
    }

    formatData() {
      this.productGroupSummary.forEach(pgs => {
        pgs.merchDecision.forEach(x => {
          this.populateDataArrays(x);
        })
        pgs.current.forEach(x => {
          this.populateDataArrays(x);
        })
        pgs.recommended.forEach(x => {
          this.populateDataArrays(x);
        })
      })

      this.populateRows();
    }

    populateDataArrays(x: any) {
      this.markdownWeekRow.push(x.markdownWeek)
      this.tpnInMardownRow.push(x.tpnInMardown)
      this.tpnBeforeMarkdownRow.push(x.tpnBeforemMarkdown)
      this.markdownMarginAverageRow.push(x.markdownMarginAverage)
      this.markdownMarginOverallRow.push(x.markdownMarginOverall)
      this.expectedStockLevelBeforePriceChangeRow.push(x.expectedStockLevelBeforePriceChange)
      this.terminalStockEstimateCountRow.push(x.terminalStockEstimateCount)
      this.terminalStockEstimateCostRow.push(x.terminalStockEstimateCost)
      this.unitsSoldInMarkdownPeriodEstimateRow.push(x.unitsSoldInMarkdownPeriodEstimate)
      this.salesInMarkdownPeriodEstimateRow.push(x.salesInMarkdownPeriodEstimate)
      this.markdownCostEstimateRow.push(x.markdownCostEstimate)
      this.profitEstimateRow.push(x.profitEstimate)
      this.acceptedPercentageRow.push(x.acceptedPercentage)
      this.revisedPercentageRow.push(x.revisedPercentage)
      this.rejectedPercentageRow.push(x.rejectedPercentage)
    }

    populateRows() {
      this.rowData.push(this.markdownWeekRow);
      this.rowData.push(this.tpnInMardownRow);
      this.rowData.push(this.tpnBeforeMarkdownRow);
      this.rowData.push(this.markdownMarginAverageRow);
      this.rowData.push(this.markdownMarginOverallRow);
      this.rowData.push(this.expectedStockLevelBeforePriceChangeRow);
      this.rowData.push(this.terminalStockEstimateCountRow);
      this.rowData.push(this.terminalStockEstimateCostRow);
      this.rowData.push(this.unitsSoldInMarkdownPeriodEstimateRow);
      this.rowData.push(this.salesInMarkdownPeriodEstimateRow);
      this.rowData.push(this.markdownCostEstimateRow);
      this.rowData.push(this.profitEstimateRow);
      this.rowData.push(this.acceptedPercentageRow);
      this.rowData.push(this.revisedPercentageRow);
      this.rowData.push(this.rejectedPercentageRow);
    }

    ngAfterViewInit() {

    }

    refresh(params: any) {
      return false;
    }
}
