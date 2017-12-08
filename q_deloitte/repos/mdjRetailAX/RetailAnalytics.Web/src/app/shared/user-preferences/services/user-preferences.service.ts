import { Injectable, OnDestroy } from '@angular/core';
import { GridOptions } from 'ag-grid';
import { Location } from '@angular/common';
import { Observable } from 'rxjs/Observable';
import { Subscription } from 'rxjs/Rx';
import { UserPreferencesModel } from '../models/user-preferences.model';
import debounce from 'lodash-es/debounce';

@Injectable()
export class UserPreferencesService {
  dataLoaded: boolean = false;
  private route: string;
  private _subscriptions: Array<Subscription> = [];

  gridState$: Observable<Array<Object>>;
  sortState$: Observable<Array<Object>>;
  lastScenarioId$: Observable<number>;


  constructor(private location: Location,
    private _model: UserPreferencesModel) {
    this.gridState$ = _model.gridState$;
    this.sortState$ = _model.sortState$;
    this.lastScenarioId$ = _model.lastScenarioId$;
    this.route = this.location.path();
    if (this.route.includes(';scenarioId=')) {
      this.route = this.route.substring(0, this.route.indexOf(';scenarioId='));
    }
  }

  setState(gridOptions: GridOptions): void {
    if (gridOptions) {
      if (gridOptions.columnApi && this.getScenarioGridState()) {
        gridOptions.columnApi.setColumnState(this.getScenarioGridState());
      }
      if (this.getScenarioClientSortModel() && gridOptions.api) {
        gridOptions.api.setSortModel(this.getScenarioClientSortModel());
      }
      this.dataLoaded = true;
    }
  }

  debounceSetScenarioGridState = debounce(
    (gridState) => this.setScenarioGridState(gridState), 
    500
  )

  setScenarioGridState(gridState: Object): void {
    if (this.dataLoaded) {
      this._model.setGridState(this.route, gridState);
    }
  }

  getScenarioGridState(): any {    
    var gridStates: Array<any>;
    var state:any = false;
    this._subscriptions.push(this.gridState$.subscribe(data => gridStates = data));
    if (gridStates.length !== 0) { 
      gridStates.filter(x => {
        if (x.route === this.route) {
          state = x.state;
        }
      })
    }
    return state;
  }

  setScenarioSortModel(headerName: string, sortDirection: string): void {
    if (this.dataLoaded) {
      var sortModel = {};
      if (sortDirection) {
        sortModel = { prop: headerName, dir: sortDirection };
      }
      this._model.setSortState(this.route, sortModel);
    }
  }

  getScenarioSortModel() {
    var sortStates: Array<any>;
    var state:any = false;
    this._subscriptions.push(this.sortState$.subscribe(data => sortStates = data));
    if(sortStates.length !== 0) {
      sortStates.filter(x => {
        if (x.route === this.route) {
          state = x.state;
        }
      })
    }
    return state;
  }

  getScenarioClientSortModel() {
    var sortStates: Array<any>;
    var state:any = false;
    this._subscriptions.push(this.sortState$.subscribe(data => sortStates = data));
    if(sortStates.length !== 0) {
      sortStates.filter(x => {
        if (x.route === this.route) {
          state = [{ colId: x.state.prop, sort: x.state.dir }];;
        }
      })
    }
    return state;
  }

  setLastScenarioId(scenarioId: number) {
    this._model.setLastWorkspace(scenarioId);
  }

  getLastScenarioId() {
    var scenarioId:any = false;
    this._subscriptions.push(this.lastScenarioId$.subscribe((data) => scenarioId = data));
    return scenarioId;
  }

  clearScenario(gridOptions: GridOptions): void {
    this._model.clearGridState(this.route);
    this._model.clearSortState(this.route);
    gridOptions.columnApi.resetColumnState();
    gridOptions.api.setSortModel([]);
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }  

}