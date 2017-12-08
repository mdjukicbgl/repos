import { AfterViewInit, Component, OnDestroy, OnInit, ViewChild, ChangeDetectionStrategy, trigger, transition, style, animate } from '@angular/core';
import { LocaleUtil } from '../../../shared/utils/locale-util/locale-util';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs/Rx';
import { Observable } from 'rxjs/Observable';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap/modal/modal.module';
import { GridModule } from '../../../shared/grid/grid.module';
import { ScenariosModel } from '../../models/scenarios.model';
import { WindowSize } from '../../../shared/utils/window-size/window-size';
import { LinkItemType } from '../../../shared/navigation/subnav-link/models/link-item.entity';
import { Scenario } from '../../models/scenarios.entity';
import { GridOptions, RowNode } from 'ag-grid';
import { GridUtils } from '../../../shared/grid/utils/grid-utils';
import { ServerParams } from '../../../shared/grid/models/server-params.entity';
import { UserPreferencesService } from '../../../shared/user-preferences/services/user-preferences.service';
import { TranslateService } from '@ngx-translate/core';

import {
  StatusCellComponent,
  DateCellComponent,
  StringFilterComponent,
  NumberFilterComponent,
  SetFilterComponent,
  DateFilterComponent,
  NumberCellComponent,
  PercentageCellComponent,
  CurrencyCellComponent,
  StandardHeaderComponent,
  CreateScenarioRendererComponent,
  EmptyHeaderComponent,
  SimpleHeaderComponent,
  WorkflowIndicatorCellComponent,
  ProductGroupDetailComponent,
  MeasureCellComponent,
  StringListFilterComponent } from '../../../shared/grid';

@Component({
  selector: 'app-scenario-summary',
  templateUrl: './scenario-summary.component.html',
  styleUrls: ['./scenario-summary.component.scss'],
  providers: [ ScenariosModel, UserPreferencesService ],
  host: { 'class': 'vertical-flex' }
})

export class ScenarioSummaryComponent implements OnInit, OnDestroy {
  @ViewChild('content') content: NgbModal;

  scenariosInitial$: Observable<Scenario[]>;
  scenariosInitialIsLoading$: Observable<boolean>;
  scenariosInitialComplete$: Observable<boolean>;
  scenariosInitialHasFailed$: Observable<boolean>;

  scenarios$: Observable<Scenario[]>;
  scenariosIsLoading$: Observable<boolean>;
  scenariosComplete$: Observable<boolean>;
  scenariosHasFailed$: Observable<boolean>;

  scenarioSaveHasFailed$: Observable<boolean>;

  scenariosFilters$: Observable<ServerParams>;
  subNavLinks: Array<LinkItemType> = [];
  paginationPageSize = 100;
  translations: String[] = [];
  _subscriptions: Array<Subscription> = [];
  _subscriptionFetch: Subscription;

  rowsSelected: any[] = [];

  gridOptions: GridOptions;
  columnDefs: any[];

  selectedScenario: Scenario;

  constructor(
    private _model: ScenariosModel,
    private route: ActivatedRoute,
    private router: Router,
    private modalService: NgbModal,
    private windowSize: WindowSize,
    public gridUtils: GridUtils,
    private translate: TranslateService,
    private localeUtil: LocaleUtil,
    private userPreferencesService: UserPreferencesService,
  ) {
    this.gridUtils = gridUtils;

    this.scenariosInitial$ = _model.scenariosInitial$;
    this.scenariosInitialIsLoading$ = _model.scenariosInitialIsLoading$;
    this.scenariosInitialComplete$ = _model.scenariosInitialComplete$;
    this.scenariosInitialHasFailed$ = _model.scenariosInitialHasFailed$;

    this.scenarioSaveHasFailed$ = _model.scenarioSaveHasFailed$;

    this.scenarios$ = _model.scenarios$;
    this.scenariosIsLoading$ = _model.scenariosIsLoading$;
    this.scenariosComplete$ = _model.scenariosComplete$;
    this.scenariosHasFailed$ = _model.scenariosHasFailed$;
    this.scenariosFilters$ = _model.scenariosFilters$;
  }

  ngOnInit() {
    this.initGrid();
  }

  initGrid() {
    this.setupGridColumns();
    this.setupGridOptions();
  }

  setupGridOptions() {
    this.gridOptions = <GridOptions>{
      rowSelection: 'single',
      enableColResize: true,
      context: {
        componentParent: this,
      },
      enableSorting: true,
      onGridReady: (params) => {
        this._subscriptions.push(this.windowSize.width$.subscribe(() => {
          this.gridUtils.sizeColumnsToFit(this.gridOptions);
        }));
        this._subscriptions.push(this.scenariosInitial$.skip(1).subscribe(
          rowData => {
            this.gridOptions.api.setRowData(rowData);
            this.gridUtils.sizeColumnsToFit(this.gridOptions);
            this._subscriptions.push(this.scenarios$.skip(1).subscribe((newRowData) => {
              this.gridOptions.api.setRowData(newRowData)
            }));
            this.observeIsLoading();
          }
        ));
        this._model.loadScenariosInitial(); 
        this.userPreferencesService.setState(this.gridOptions);
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
      columnDefs: this.columnDefs
    };
  }

  observeIsLoading() {
    this._subscriptions.push(this.scenariosInitialIsLoading$.skip(1).subscribe((isLoading) => {
      isLoading ? this.gridUtils.showLoadingOverlay(this.gridOptions) : this.gridUtils.hideOverlay(this.gridOptions);
    }));
    this._subscriptions.push(this.scenariosIsLoading$.skip(1).subscribe((isLoading) => {
      isLoading ? this.gridUtils.showLoadingOverlay(this.gridOptions) : this.gridUtils.hideOverlay(this.gridOptions);
    }));
  }

  public isFullWidthCell(rowNode) {
    return rowNode.level === 1;
  }

  public getFullWidthCellRenderer() {
    return ProductGroupDetailComponent;
  }

  public getRowHeight(params) {
    var rowIsDetailRow = params.node.level === 1;
    return rowIsDetailRow ? 403 : 35;
  }

  public getNodeChildDetails(record) {
    if (record.IsChild && record.productGroupSummary) {
      return null;
    }
    else {
      record["IsChild"] = true;
      return {
        group: true,
        key: record.scenarioId,
        children: [record]
      };
    }
  }

  private onResizeGrid() {
    this.gridUtils.sizeColumnsToFit(this.gridOptions);
  }

  setupGridColumns() {
    this.columnDefs = [
      {
        headerName: 'Details',
        marryChildren: true,
        children: [
          { field: "checkbox", headerName: ' ', checkboxSelection: true, suppressSizeToFit : true, width: 50, headerComponentFramework: EmptyHeaderComponent, template: '<span></span>', suppressMovable: true, suppressShowHide: true},
          { field: "scenarioName", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'SCENARIOS.GRID_HEADERS.SCENARIO_NAME' }, filterFramework: StringFilterComponent, filterParams: { isClientSide: true }, minWidth: 190, menuTabs: ['filterMenuTab'], suppressMenu:true },
          { field: "status", headerName: ' ', headerComponentFramework: StandardHeaderComponent, headerComponentParams : { translationKey: 'SCENARIOS.GRID_HEADERS.STATUS' }, filterFramework: StringListFilterComponent, filterParams: { isClientSide: true }, minWidth: 235, maxWidth: 235, cellRendererFramework: StatusCellComponent, menuTabs: ['filterMenuTab'], suppressMenu:true},
          { field: "measure", headerName: ' ', headerComponentFramework: SimpleHeaderComponent, headerComponentParams : { translationKey: 'SCENARIOS.GRID_HEADERS.MEASURES', suppressMenu: true }, cellRendererFramework: MeasureCellComponent, minWidth: 420, maxWidth: 420 },
        ]
      },
      {
        headerName: 'Status',
        marryChildren: true,
        children: [
          { field: "statusNew", headerName: ' ', headerComponentFramework: SimpleHeaderComponent, headerComponentParams : { translationKey: 'SCENARIOS.GRID_HEADERS.STATUS_NEW' }, cellRendererFramework: WorkflowIndicatorCellComponent, minWidth: 75, maxWidth: 100 },
          { field: "statusPublished", headerName: ' ', headerComponentFramework: SimpleHeaderComponent, headerComponentParams : { translationKey: 'SCENARIOS.GRID_HEADERS.STATUS_PUBLISHED' }, cellRendererFramework: WorkflowIndicatorCellComponent, minWidth: 75, maxWidth: 100 },
          { field: "statusAccepted", headerName: ' ', headerComponentFramework: SimpleHeaderComponent, headerComponentParams : { translationKey: 'SCENARIOS.GRID_HEADERS.STATUS_ACCEPTED' }, cellRendererFramework: WorkflowIndicatorCellComponent, minWidth: 75, maxWidth: 100 },
          { field: "statusRejected", headerName: ' ', headerComponentFramework: SimpleHeaderComponent, headerComponentParams : { translationKey: 'SCENARIOS.GRID_HEADERS.STATUS_REJECTED' }, cellRendererFramework: WorkflowIndicatorCellComponent, minWidth: 75, maxWidth: 100 },
        ]
      },
      {
        headerName: 'Group',
        marryChildren: true,
        children: [
          { field: "scenarioName", headerName: ' ', headerComponentFramework: EmptyHeaderComponent, cellRenderer: 'group', cellRendererParams: { suppressCount: true, innerRenderer: function(params) {return ''} }, minWidth: 75, maxWidth: 100, suppressMovable: true, suppressShowHide: true  },
        ]
      }
    ];
  }

  private getRows(params, rows) {
    params.successCallback(rows, rows.length === this.paginationPageSize ? null : params.startRow + rows.length);
    this.gridUtils.hideOverlay(this.gridOptions);
    if ( rows.length === 0 ) {
      this.gridUtils.showNoRowsOverlay(this.gridOptions);
    }
  }

  showRunModal(node: RowNode) {
    if ( node.data ) {
      this.openRunModal(node.data.scenarioId);
    }
  }

  openRunModal(scenarioId: number) {
    this.modalService.open(this.content, { size: 'sm' }).result.then((result) => {
      if (result === 'Yes') {
        this._model.runScenario(scenarioId);
      }
    });
  }

  refreshScenarios() {
    this.selectedScenario = undefined;
    this._model.loadScenarios();
  }

  runScenario(scenarioId: number) {
    this._model.runScenario(scenarioId);
  }

  onSelectionChanged($event) {
    let nodesSelected = this.gridOptions.api.getSelectedNodes();
    if(nodesSelected.length > 0) {
      //If its the child grid, unselect
      if(Array.isArray(nodesSelected[0].data)) {
        nodesSelected[0].setSelected(false);
        this.selectedScenario = null;
      } else {
        this.selectedScenario = nodesSelected[0].data
      }
    } else {
      this.selectedScenario = null;
    }
  }

  onColumnChanged(): void {
    this.userPreferencesService.debounceSetScenarioGridState(this.gridOptions.columnApi.getColumnState());
  }

  clearState(): void {
    this.userPreferencesService.clearScenario(this.gridOptions);
  }

  onRowClicked(row) {
    row.node.setSelected(true);
  }

  dismissScenarioSaveHasFailed() {
    this._model.resetScenarioSaveHasFailed();
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }

}
