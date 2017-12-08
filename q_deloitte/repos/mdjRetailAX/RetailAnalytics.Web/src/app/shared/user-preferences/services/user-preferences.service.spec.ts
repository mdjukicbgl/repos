import { TestBed, inject } from '@angular/core/testing';
import { GridOptions } from 'ag-grid';
import { UserPreferencesModule } from '../user-preferences.module';
import { UserPreferencesService } from './user-preferences.service';
import { GridUtils } from '../../grid/utils/grid-utils';
import { ReflectiveInjector } from '@angular/core';
import { Location, LocationStrategy } from '@angular/common';
import { Router, Routes } from '@angular/router';
import { RouterTestingModule } from '@angular/router/testing';
import { Store, provideStore } from '@ngrx/store';
import { StoreMgmtService } from '../../store-mgmt/store-mgmt.service'

let routes: Routes = [
    { path: '', loadChildren: 'app/layout/layout.module#LayoutModule'}
];
let gridOptions;
let gridUtils: GridUtils;

describe('UserPreferencesService', () => {

  let location: Location;
  let router: Router;
  let gridState: Object = [{'test':'data'}]
  beforeEach(() => {
    gridOptions = {
      api: {
        sortModel: Object,
        setSortModel: (sortModel: Object) => {
          this.sortModel = sortModel;
        },
        getSortModel: () => {
          return this.sortModel;
        },
      },
      columnApi: {
        columnState: Object,
        setColumnState: (columnState: Object) => {
          this.columnState = columnState;
        },
        getColumnState: () => {
          return this.columnState;
        },
        resetColumnState: () => {},
      }
    };
    TestBed.configureTestingModule({
      imports: [RouterTestingModule.withRoutes(routes), UserPreferencesModule],
      providers: [UserPreferencesService, provideStore({}), StoreMgmtService]
    })

    router = TestBed.get(Router);
    location = TestBed.get(Location);
  })


  it('should be created', inject([UserPreferencesService], (service: UserPreferencesService) => {
    expect(service).toBeTruthy();
  }));

  it('should store grid state in localstorage', inject([UserPreferencesService], (service: UserPreferencesService) => {
    service.dataLoaded = true;
    service.setScenarioGridState(gridState);
    expect(service.getScenarioGridState()).toEqual(gridState);
  }));

  it('should store sort model in localstorage', inject([UserPreferencesService], (service: UserPreferencesService) => {
    var expectedModel = {prop: 'test', dir: 'asc'};
    service.dataLoaded = true;
    service.setScenarioSortModel('test','asc');
    expect(service.getScenarioSortModel()).toEqual(expectedModel);
  }));

  it('should set column state and sort model on gridOptions api', inject([UserPreferencesService], (service:UserPreferencesService) => {
    service.setState(gridOptions);
    expect(gridOptions.columnApi.getColumnState() && gridOptions.api.getSortModel()).toBeTruthy();
  }));

  it('should set state',  inject([UserPreferencesService], (service: UserPreferencesService) => {
    gridState = [{"colId":"checkbox","hide":false,"aggFunc":null,"width":50,"pivotIndex":null,"pinned":"left","rowGroupIndex":null},{"colId":"productId","hide":false,"aggFunc":null,"width":160,"pivotIndex":null,"pinned":"left","rowGroupIndex":null},{"colId":"productName","hide":false,"aggFunc":null,"width":190,"pivotIndex":null,"pinned":"left","rowGroupIndex":null},{"colId":"hierarchyName","hide":false,"aggFunc":null,"width":190,"pivotIndex":null,"pinned":"left","rowGroupIndex":null},{"colId":"originalSellingPrice","hide":false,"aggFunc":null,"width":220,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"currentSellingPrice","hide":false,"aggFunc":null,"width":190,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"sellThroughTarget","hide":false,"aggFunc":null,"width":190,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"terminalStockUnits","hide":false,"aggFunc":null,"width":190,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"totalRevenue","hide":false,"aggFunc":null,"width":190,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"markdownCost","hide":false,"aggFunc":null,"width":190,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"status","hide":false,"aggFunc":null,"width":120,"pivotIndex":null,"pinned":"right","rowGroupIndex":null},{"colId":"discount1","hide":true,"aggFunc":null,"width":120,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"discount2","hide":false,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"discount3","hide":true,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"discount4","hide":false,"aggFunc":null,"width":120,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"discount5","hide":true,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"discount6","hide":false,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"discount7","hide":true,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"discount8","hide":false,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"price1","hide":true,"aggFunc":null,"width":120,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"price2","hide":false,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"price3","hide":true,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"price4","hide":false,"aggFunc":null,"width":120,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"price5","hide":true,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"price6","hide":false,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"price7","hide":true,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null},{"colId":"price8","hide":false,"aggFunc":null,"width":200,"pivotIndex":null,"pinned":null,"rowGroupIndex":null}];
    service.dataLoaded = true;
    service.setScenarioGridState(gridState);
    service.dataLoaded = false;
    service.setState(gridOptions);
    expect(service.getScenarioGridState()).toEqual(gridState);
  }));

  it('should clear scenario', inject([UserPreferencesService], (service: UserPreferencesService) => {
    service.clearScenario(gridOptions);
    expect(service.getScenarioGridState() && service.getScenarioSortModel()).toBeFalsy();
  }));

  it('should set and retrieve last workspace scenario id', inject([UserPreferencesService], (service: UserPreferencesService) => {
    var scenarioId = 100;
    service.setLastScenarioId(scenarioId);
    expect(service.getLastScenarioId() === scenarioId).toBeTruthy();
  }));
});