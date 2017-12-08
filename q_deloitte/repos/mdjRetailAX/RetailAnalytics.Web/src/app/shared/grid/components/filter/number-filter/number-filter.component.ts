import { GridUtils } from '../../../utils/grid-utils';
import {Component, ViewChild, ViewContainerRef} from '@angular/core';
import {IFilterParams, IDoesFilterPassParams, RowNode} from 'ag-grid/main';
import {IFilterAngularComp} from 'ag-grid-angular/main';

@Component({
    selector: 'filter-cell',
    templateUrl: 'number-filter.component.html'
})
export class NumberFilterComponent implements IFilterAngularComp {
    private params: IFilterParams;
    private valueGetter: (rowNode: RowNode) => any;
    public number1 = '';
    public number2 = '';
    public types: Array<any> = [
      { value: 'equals', name: 'Equals' },
      { value: 'notEqual', name: 'Not equal' },
      { value: 'lessThan', name: 'Less than' },
      { value: 'lessThanOrEqual', name: 'Less than or equals' },
      { value: 'greaterThan', name: 'Greater than' },
      { value: 'greaterThanOrEqual', name: 'Greater than or equals' },
      // { value: 'inRange', name: 'In range' }
    ];
    public selectedType = 'equals';

    constructor( private gridUtils: GridUtils ) {
      this.gridUtils = gridUtils;
    }

    agInit(params: IFilterParams): void {
        this.params = params;
        this.valueGetter = params.valueGetter;
    }

    isFilterActive(): boolean {
        return this.number1 !== null && this.number1 !== undefined && this.number1 !== '';
    }

    doesFilterPass(params: IDoesFilterPassParams): boolean {
        return true;
    }

    getModel(): any {
        if (this.isFilterActive()) {
          if (this.selectedType === 'inRange') {
            return {
              filter: this.number1,
              filterTo: this.number2,
              filterType: 'number',
              type: this.selectedType
            };
          } else {
            return {
              filter: this.number1,
              filterType: 'number',
              type: this.selectedType
            };
          }
        }
        return null;
    }

    setModel(model: any): void {
      if (model && model.value) {
        this.number1 = model.value;
      }
    }

    onClear() {
      this.number1 = '';
      this.number2 = '';
      this.selectedType = 'equals';
      this.onFilter();
    }

    onFilter() {
      this.params.filterChangedCallback();
    }
}


