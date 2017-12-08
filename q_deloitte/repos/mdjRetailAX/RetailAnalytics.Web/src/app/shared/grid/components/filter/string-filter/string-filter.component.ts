import { GridUtils } from '../../../utils/grid-utils';
import { Component, ViewChild, ViewContainerRef } from '@angular/core';
import { IFilterParams, IDoesFilterPassParams, RowNode } from 'ag-grid/main';
import { IFilterAngularComp } from 'ag-grid-angular/main';

@Component({
    selector: 'filter-cell',
    templateUrl: 'string-filter.component.html'
})
export class StringFilterComponent implements IFilterAngularComp {
    private params: any;
    private valueGetter: (rowNode: RowNode) => any;
    public text = '';
    public types: Array<any> = [
      { value: 'equals', name: 'Equals' },
      { value: 'notEqual', name: 'Not equal' },
      { value: 'startsWith', name: 'Starts with' },
      { value: 'endsWith', name: 'Ends with' },
      { value: 'contains', name: 'Contains' },
      { value: 'notContains', name: 'Not contains' }
    ];
    public selectedType = 'equals';

    constructor( private gridUtils: GridUtils ) {
      this.gridUtils = gridUtils;
    }

    agInit(params: any): void {
        this.params = params;
        this.valueGetter = params.valueGetter;
    }

    isFilterActive(): boolean {
        return this.text !== null && this.text !== undefined && this.text !== '';
    }

    doesFilterPass(params: IDoesFilterPassParams): boolean {
      if(!this.params.isClientSide){
        return true;
      }
      var value = this.valueGetter(params.node);
      return this.performFilterCheck(value)
    }

    performFilterCheck(value: string) {
      let passed = false;
      switch(this.selectedType) {
        case 'equals':
            return value.toLowerCase() === this.text.toLowerCase();
        case 'notEqual':
            return value.toLowerCase() !== this.text.toLowerCase();
        case 'startsWith':
            return value.toLowerCase().startsWith(this.text.toLowerCase(), 0);
        case 'endsWith':
            return value.toLowerCase().endsWith(this.text.toLowerCase(), 0);
        case 'contains':
            return value.toLowerCase().includes(this.text.toLowerCase());
        case 'notContains':
            return !value.toLowerCase().includes(this.text.toLowerCase());
        default:
            break;
      }

      return passed;
    }

    getModel(): any {
        if (this.isFilterActive()) {
          return {
            filter: this.text,
            filterType: 'text',
            type: this.selectedType
          };
        }
        return null;
    }

    setModel(model: any): void {
      if (model && model.value) {
        this.text = model.value;
      }
    }

    onClear() {
      this.text = '';
      this.selectedType = 'equals';
      this.onFilter();
    }

    onFilter() {
      this.params.filterChangedCallback();
    }
}


