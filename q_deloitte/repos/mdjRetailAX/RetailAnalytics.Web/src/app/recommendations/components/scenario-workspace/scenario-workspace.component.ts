import { NodeData } from '@angular/core/src/view/types';
import { RowNode } from 'ag-grid/main';
import { GridUtils } from '../../../shared/grid/utils/grid-utils';
import { ServerParams } from '../../../shared/grid/models/server-params.entity';
import { WindowSize } from '../../../shared/utils/window-size/window-size';
import { RecommendationsModel } from '../../models/recommendations.model';
import { PriceLadder, ScenarioProductRecommendation, GridRecommendations } from '../../models/recommendations.entity';
import { AfterViewInit, Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { GridOptions } from 'ag-grid/main';
import { Observable } from 'rxjs/Observable';
import { Subscription } from 'rxjs/Rx';
import { TranslateService } from '@ngx-translate/core';
import { LocaleUtil } from '../../../shared/utils/locale-util/locale-util';
import { LocalizationModule } from 'angular-l10n';
import { HttpModule } from '@angular/http';
import { WorkspacePreferencesService } from '../../services/workspace-preferences.service';


import { ScenarioWorkspaceTotalsComponent } from '../scenario-workspace-totals/scenario-workspace-totals.component';
import {
    ScenarioWorkspaceNotificationsComponent,
} from '../scenario-workspace-notifications/scenario-workspace-notifications.component';

import {
  ApproveCellComponent,
  StringFilterComponent,
  NumberFilterComponent,
  NumberCellComponent,
  SetFilterComponent,
  SimpleHeaderComponent,
  StandardHeaderComponent,
  PriceLadderCellComponent,
  PriceLadderCellEditComponent,
  PercentageCellComponent,
  CurrencyCellComponent,
  EmptyHeaderComponent,
  StringListFilterComponent,
  ApproveHeaderComponent } from '../../../shared/grid';

@Component({
  selector: 'workspace',
  templateUrl: './scenario-workspace.component.html',
  styleUrls: ['./scenario-workspace.component.scss'],
  providers: [ RecommendationsModel ],
  host: { 'class': 'vertical-flex' }
})

export class ScenarioWorkspaceComponent implements OnInit, OnDestroy {

  @ViewChild(ScenarioWorkspaceTotalsComponent) totalsComponent:ScenarioWorkspaceTotalsComponent;
  @ViewChild(ScenarioWorkspaceNotificationsComponent) notificationsComponent:ScenarioWorkspaceNotificationsComponent;

  priceField = 'price';
  discountField = 'discount';

  recommendations$: Observable<GridRecommendations>;
  recommendationsFilters$: Observable<ServerParams>;
  updatedRecommendations$: Observable<ScenarioProductRecommendation[]>;
  reviseHasFailed$: Observable<Boolean>;
  acceptAllRecommendationsHasFailed$: Observable<Boolean>;
  rejectAllRecommendationsHasFailed$: Observable<Boolean>;
  priceLadder$: Observable<PriceLadder>;

  hasNoSelectedScenario = false;
  paginationPageSize = 100;
  translations: String[];
  _subscriptions: Array<Subscription> = [];

  gridOptions: GridOptions;
  columnDefs: any[];
  gridInitialized = false;
  showGrid = false;
  isLoading = false
  datasource: any;

  selectedScenarioId: number;
  selectedRecommendations: RowNode[];
  priceLadderValues: number[] = null;
  initialLoaded = false;

  constructor(
    private _model: RecommendationsModel,
    private route: ActivatedRoute,
    private router: Router,
    private windowSize: WindowSize,
    private gridUtils: GridUtils,
    private translate: TranslateService,
    private localeUtil: LocaleUtil,
    private workspacePreferencesService: WorkspacePreferencesService
    ) {
    this.gridUtils = gridUtils;
    this.recommendations$ = this._model.recommendations$;
    this.recommendationsFilters$ = _model.recommendationsFilters$;
    this.updatedRecommendations$ = _model.updatedRecommendations$;
    this.reviseHasFailed$ = _model.reviseHasFailed$;
    this.acceptAllRecommendationsHasFailed$ = _model.acceptAllRecommendationsHasFailed$;
    this.rejectAllRecommendationsHasFailed$ = _model.rejectAllRecommendationsHasFailed$;
    this.priceLadder$ = _model.priceLadder$;
  }

  ngOnInit() {
    this.getSelectedScenario();
    this.initGrid();
    this.observeErrors();
  }

  initGrid() {
    this.observeRecommendationsFilters();
    this.setupGridDataSource();
    this.setupGridOptions();
  }

  setupGridOptions() {
    this.gridOptions = <GridOptions>{
      rowSelection: 'multiple',
      paginationPageSize: this.paginationPageSize,
      maxConcurrentRequests: 1,
      infiniteInitialRowCount: 1,
      maxBlocksInCache: 10,
      rowModelType: 'infinite',
      context: {
        componentParent: this,
      },
      onGridReady: (params) => {
        this._subscriptions.push(this.windowSize.width$.subscribe(() => {
          this.gridUtils.sizeColumnsToFit(this.gridOptions);
        }));
        this.gridOptions.api.setDatasource(this.datasource);
        this.observeUpdatedRecommendations();
      },
      onDisplayedColumnsChanged: (params) => {
        this.onColumnChanged();
      },
      onColumnResized: (params) => {
        this.onColumnChanged();
      },
      onColumnPinned: (params) => {
        this.onColumnChanged();
      },
      getRowNodeId: function(item) {
        return item.productId.toString();
      },
      columnDefs: this.columnDefs
    };
  }

  observeRecommendationsFilters() {
    this._subscriptions.push(this.recommendationsFilters$.skip(1)
    .subscribe((filters) => {
      this._model.loadRecommendationsFiltered(this.selectedScenarioId, filters);
    }));
  }

  observeErrors() {

    let combined = Observable.combineLatest(
      this.reviseHasFailed$,
      this.acceptAllRecommendationsHasFailed$,
      this.rejectAllRecommendationsHasFailed$
    );

    this._subscriptions.push(combined.skip(1).subscribe(latestValues => {
      const [
        reviseHasFailed,
        acceptAllRecommendationsHasFailed,
        rejectAllRecommendationsHasFailed,
        ] = latestValues;
        if (reviseHasFailed || acceptAllRecommendationsHasFailed || rejectAllRecommendationsHasFailed) {
          this.setIsLoading(false);
        }
    }));

  }

  observeUpdatedRecommendations() {
    this._subscriptions.push(this.updatedRecommendations$.skip(1)
      .subscribe((updates) => {
        updates.forEach(update => {
          this.gridOptions.api.forEachNode((node) => {
            if (node.data.productId === update.productId) {
              node.setData(update);
              return;
            }
          })
        });
      this.setIsLoading(false);
      this.totalsComponent.loadSelectedScenario();
      })
    );
  }

  getPriceLadder(priceLadderId) {
    if ( !this.priceLadderValues ) {
      this._subscriptions.push(this.priceLadder$.skip(1).first()
      .subscribe((priceLadder) => {
        this.priceLadderValues = priceLadder.values;
      }));
      this._model.loadPriceLadder(priceLadderId);
    }
  }

  getSelectedScenario() {
    this.selectedScenarioId = this.route.snapshot.params['scenarioId'];
    if (!this.selectedScenarioId) {
      this.hasNoSelectedScenario = true;
    } else {
      this.hasNoSelectedScenario = false;
      this.workspacePreferencesService.setLastScenarioId(this.selectedScenarioId);
    }
  }

  private setupGridDataSource() {
    this.datasource = {
      rowCount: null,
      getRows: (params) => {
        this.setIsLoading(true);
        this.recommendations$.skip(1).first().subscribe((data) => {
          this.getPriceLadder(data.priceLadderId);
          this.bindColumns(data.projectionCount, data.scheduleMask);
          params.successCallback(data.items, data.items.length === this.paginationPageSize ? null : params.startRow + data.items.length);
          this.setIsLoading(false);
          if ( data.items.length === 0 ) {
            this.gridUtils.showNoRowsOverlay(this.gridOptions);
          }
          this.gridUtils.sizeColumnsToFit(this.gridOptions);
          console.log('Loading Grid options');
          this.workspacePreferencesService.setWorkspaceGridState(this.gridOptions, data.scheduleMask);
        });
        this.workspacePreferencesService.setWorkspaceSortState(params);
        this.filter(params);
      }
    };
  }

  private bindColumns(projectionCount, scheduleMask) {
    if (!this.gridInitialized) {
      this.columnDefs = this.createGridColumns(projectionCount);
      if ( this.gridOptions.api ) {
        this.gridOptions.api.setColumnDefs(this.columnDefs);
      }
      if ( scheduleMask ) {
        [...scheduleMask].forEach((element, index) => {
          if (element === '1') {
            this.gridOptions.columnApi.setColumnsVisible([this.discountField + (index + 1), this.priceField + (index + 1)], true)
          }
        });
      }
      this.gridInitialized = true;
    }
  }

  private filter(params) {
    let newFilter = this.gridUtils.getGridFilters(
      params.sortModel,
      params.filterModel,
      {
        pageLimit: params.endRow - params.startRow,
        pageIndex: (params.endRow / this.paginationPageSize)
      }
    );
    this._model.setRecommendationsFilter(newFilter);
    this.initialLoaded = true;
  }

  clearNotifications() {
    this.notificationsComponent.dismissAllNotifications();
  }

  createColumnDefs() {
    if(this.workspacePreferencesService.getScenarioSortModel()) {
      var sort = this.workspacePreferencesService.getScenarioSortModel();
    }
    return [
      {
          headerName: 'Sale',
          marryChildren: true,
          children: [
            { field: "checkbox", headerName: ' ', checkboxSelection: true, suppressSizeToFit : true, width: 50, headerComponentFramework: EmptyHeaderComponent, template: '<span></span>', suppressMovable: true, suppressShowHide: true, pinned: 'left'},
            { field: "productId", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.PRODUCT_ID' }, filterFramework: NumberFilterComponent, minWidth: 160, pinned: 'left', filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, cellRenderer: function(params) {if (params.value !== undefined) { return params.value; } else { return '<i class="fa fa-circle-o-notch fa-spin fa-fw"></i>' } }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('productId', sort),  },
            { field: "productName", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.PRODUCT_NAME' }, filterFramework: StringFilterComponent, minWidth: 190, pinned: 'left', filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('productName', sort) },
            { field: "hierarchyName", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.HIERARCHY_NAME' }, filterFramework: StringListFilterComponent, minWidth: 190, pinned: 'left', filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep', scenarioId: this.selectedScenarioId }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('hierarchyName', sort) },
            { field: "originalSellingPrice", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.ORIGINAL_SELLING_PRICE' }, filterFramework: NumberFilterComponent, cellRendererFramework: CurrencyCellComponent, minWidth: 220, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('originalSellingPrice', sort) },
            { field: "currentSellingPrice", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.CURRENT_SELLING_PRICE' }, filterFramework: NumberFilterComponent, cellRendererFramework: CurrencyCellComponent, minWidth: 190, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('currentSellingPrice', sort) },
          ]
      },
      {
          headerName: 'Forecast',
          marryChildren: true,
          children: [
            { field: "sellThroughTarget", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.MAX_STOCK_TARGET' },  filterFramework: NumberFilterComponent, cellRendererFramework: NumberCellComponent, minWidth: 190, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('sellThroughTarget', sort) },
            { field: "terminalStockUnits", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.TERMINAL_STOCK' }, filterFramework: NumberFilterComponent, cellRendererFramework: NumberCellComponent, minWidth: 190, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('terminalStockUnits', sort) },
            { field: "totalRevenue", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.TOTAL_REVENUE' },  filterFramework: NumberFilterComponent, cellRendererFramework: CurrencyCellComponent, cellRendererParams : { format: '1.0-0' }, minWidth: 190, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('totalRevenue', sort) },
            { field: "markdownCost", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.MARKDOWN_COST' },  filterFramework: NumberFilterComponent, cellRendererFramework: CurrencyCellComponent, minWidth: 190, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('markdownCost', sort) },
            { field: "status", headerName: ' ', headerComponentFramework: ApproveHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.STATUS', scenarioId: this.selectedScenarioId },  filterFramework: SetFilterComponent, minWidth: 120, pinned: 'right', cellRendererFramework: ApproveCellComponent, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep', values: ['Approved', 'Rejected'] }, suppressMovable: true, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('status', sort) },
          ]
      },
      {
          headerName: 'Projections',
          marryChildren: true,
          children: []
      }
    ];
  }

  createGridColumns(projectionCount: number) {
    if(this.workspacePreferencesService.getScenarioSortModel()) {
      var sort = this.workspacePreferencesService.getScenarioSortModel();
    }
    let tempColumns: any = this.createColumnDefs();
    if (projectionCount && projectionCount > 0) {
      for (let i = 0; i < projectionCount; i++) {
        tempColumns[2].children.push({
          field: 'discount' + (i + 1), headerName: ' ', hide: true, headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.DISCOUNT', indexToAppend: (i + 1) }, filterFramework: NumberFilterComponent, cellRendererFramework: PriceLadderCellComponent, minWidth: 120, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' } , suppressMovable: true, suppressShowHide: true, editable: true, cellEditorFramework: PriceLadderCellEditComponent, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('discount' + (i + 1), sort)
        });
      }
      for (let i = 0; i < projectionCount; i++) {
        tempColumns[2].children.push({
          field: 'price' + (i + 1), headerName: ' ', hide: true, headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'WORKSPACE.GRID_HEADERS.PRICE', indexToAppend: (i + 1) }, filterFramework: NumberFilterComponent, cellRendererFramework: CurrencyCellComponent, minWidth: 120, filterParams: { applyButton: true, clearButton: true, apply: true, newRowsAction: 'keep' }, suppressMovable: true, suppressShowHide: true, menuTabs: ['filterMenuTab'], suppressMenu:true, sort: this.gridUtils.getHeaderSort('price' + (i + 1), sort)
        });
      }
    }

    return tempColumns;
  }

  updateShowGrid(show) {
    this.showGrid = show;
  }

  refreshRecommendations() {
    this.gridUtils.purgeInfiniteCache(this.gridOptions);
    this.totalsComponent.loadSelectedScenario();
  }

  onSelectionChanged() {
    let nodesSelected = this.gridOptions.api.getSelectedNodes();
    if ( nodesSelected && nodesSelected.length > 0) {
      this.selectedRecommendations = nodesSelected;
    } else {
      this.selectedRecommendations = null;
    }
  }

  setIsLoading(isLoading: boolean) {
    this.isLoading = isLoading;
    this.isLoading ? this.gridUtils.showLoadingOverlay(this.gridOptions) : this.gridUtils.hideOverlay(this.gridOptions)
  }

  onColumnChanged(): void {
    this.workspacePreferencesService.setScenarioGridState(this.gridOptions.columnApi.getColumnState());
  }

  clearState(): void {
    this.workspacePreferencesService.clearScenario(this.gridOptions);
  }

  onRowClicked(row) {
    row.node.setSelected(true);
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }  
}
