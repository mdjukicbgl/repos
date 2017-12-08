import { GridUtils } from '../../../utils/grid-utils';
import { Component, ViewChild, ViewContainerRef, OnDestroy } from '@angular/core';
import { IFilterParams, IDoesFilterPassParams, RowNode } from 'ag-grid/main';
import { IFilterAngularComp } from 'ag-grid-angular/main';
import { Observable } from 'rxjs/Observable';
import { Subscription } from 'rxjs/Subscription';
import filter from 'lodash-es/filter';
import { NgSpinKitModule } from 'ng-spin-kit';

import { GridModel } from '../../../models/grid.model';

@Component({
  selector: 'filter-cell',
  templateUrl: 'string-list-filter.component.html',
  styleUrls: ['string-list-filter.component.scss'],
  providers: [GridModel]
})
export class StringListFilterComponent implements IFilterAngularComp {
  private params: any;
  private valueGetter: (rowNode: RowNode) => any;
  _subscriptions: Array<Subscription> = [];

  uniqueLists$: Observable<Array<any>>;
  uniqueListsIsLoading$: Observable<Boolean>;
  uniqueListsComplete$: Observable<Boolean>;
  uniqueListsHasFailed$: Observable<Boolean>;

  options;

  constructor(
    private gridUtils: GridUtils,
    private _model: GridModel
  ) {
    this.gridUtils = gridUtils;
    this.uniqueLists$ = _model.uniqueLists$;
    this.uniqueListsIsLoading$ = _model.uniqueListsIsLoading$;
    this.uniqueListsComplete$ = _model.uniqueListsComplete$;
    this.uniqueListsHasFailed$ = _model.uniqueListsHasFailed$;
  }

  agInit(params: IFilterParams): void {
    this.params = params;
    this.valueGetter = params.valueGetter;
    if (this.params.isClientSide) {
      this.getClientValues();
    } else {
      this.getServerValues();
    }
  }

  getClientValues() {
    let rowList = this.params.column.gridOptionsWrapper.gridOptions.api.rowModel.rowsToDisplay;
    let list: Array<String> = [];
    let field = this.params.colDef.field;
    if (rowList) {
      rowList.forEach(l => {
        if (list.indexOf(l.data[field]) == -1) { 
          list.push(l.data[field]);
        }
      })
    }
    this.setupValues(list.sort());
  }

  getServerValues() {
    this._model.requestUniqueList(this.params.scenarioId, this.params.colDef.field);
    let list: Array<String> = [];
    this._subscriptions.push(this.uniqueLists$.subscribe(data => {
      data.filter(x => {
        if (x.colId === this.params.colDef.field) {
          list = x.list;
        }
      })
      this.setupValues(list);
    }));
  }

  private setupValues(list: Array<String>) {
    this.options = [];
    if (list.length !== 0) {
      list.forEach(option => {
        this.options.push({
          checked: true,
          value: option
        })
      })
    }
  }
  
  isFilterActive(): boolean {
    // If one, but not all are unchecked
    let unchecked = filter(this.options, function (o) { return !o.checked; });
    return (unchecked.length > 0 && unchecked.length !== this.options.length);
  }

  doesFilterPass(params: IDoesFilterPassParams): boolean {
    if (!this.params.isClientSide) {
      return true;
    }
    var value = this.valueGetter(params.node);
    return (filter(this.options, function (o) { return (o.checked && o.value === value) }).length > 0);
  }

  getModel(): any {
    if (this.isFilterActive()) {
      let values = [];
      filter(this.options, function (o) { return o.checked; }).forEach(option => {
        values.push(option.value);
      });
      return values;
    }
    return null;
  }

  setModel(model: any): void {
    if (model && model[0]) {
      this.options.forEach((option) => {
        if (option.value === model[0]) {
          option.checked = true;
        } else {
          option.checked = false;
        }
      });
      this.params.filterChangedCallback();
    }
  }

  onClear() {
    this.options.forEach(option => {
      option.checked = true;
    });
    this.onFilter();
  }

  onFilter() {
    this.params.filterChangedCallback();
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }
}