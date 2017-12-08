import { GridUtils } from '../../../utils/grid-utils';
import {Component, ViewChild, ViewContainerRef} from '@angular/core';
import {IFilterParams, IDoesFilterPassParams, RowNode} from 'ag-grid/main';
import {IFilterAngularComp} from 'ag-grid-angular/main';
import filter from 'lodash-es/filter';

@Component({
    selector: 'filter-cell',
    templateUrl: 'set-filter.component.html'
})
export class SetFilterComponent implements IFilterAngularComp {
    private params: any;
    private valueGetter: (rowNode: RowNode) => any;
    options = [];

    constructor( private gridUtils: GridUtils ) {
      this.gridUtils = gridUtils;
    }

    agInit(params: IFilterParams): void {
        this.params = params;
        this.valueGetter = params.valueGetter;
        this.setupValues();
    }

    setupValues() {
      (this.params as any).values.forEach(option => {
        this.options.push({
          checked: true,
          value: option
        });
      });
    }

    isFilterActive(): boolean {
      // If one, but not all are unchecked
      let unchecked = filter(this.options, function(o) { return !o.checked; });
      return (unchecked.length > 0 && unchecked.length !== this.options.length);
    }

    doesFilterPass(params: IDoesFilterPassParams): boolean {
      if(!this.params.isClientSide){
        return true;
      }
      var value = this.valueGetter(params.node);
      return (filter(this.options, function(o) { return (o.checked && o.value === value)}).length > 0);
    }

    getModel(): any {
      if (this.isFilterActive()) {
        let values = [];
        filter(this.options, function(o) { return o.checked; }).forEach(option => {
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
}

