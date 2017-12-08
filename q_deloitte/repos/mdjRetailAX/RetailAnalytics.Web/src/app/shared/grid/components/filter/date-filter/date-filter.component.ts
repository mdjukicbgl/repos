import { NgbDate } from '@ng-bootstrap/ng-bootstrap/datepicker/ngb-date';
import { GridUtils } from '../../../utils/grid-utils';
import { Component, ViewChild, ViewContainerRef } from '@angular/core';
import { IFilterParams, IDoesFilterPassParams, RowNode } from 'ag-grid/main';
import { IFilterAngularComp } from 'ag-grid-angular/main';
import { NgbdDatepickerPopup } from '../../../../ngbBootstrap/datepicker-popup/datepicker-popup';


@Component({
    selector: 'filter-cell',
    templateUrl: 'date-filter.component.html'
})
export class DateFilterComponent implements IFilterAngularComp {

    @ViewChild(NgbdDatepickerPopup) datepicker: NgbdDatepickerPopup;

    private params: IFilterParams;
    private valueGetter: (rowNode: RowNode) => any;
    public selectedDate: number;
    public types: Array<any> = [
      { value: 'equals', name: 'Same as' },
      { value: 'before', name: 'Before' },
      { value: 'after', name: 'After' },
      { value: 'sameOrBefore', name: 'Same or before' },
      { value: 'sameOrAfter', name: 'Same or after' }
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
        return this.selectedDate !== null && this.selectedDate !== undefined;
    }

    doesFilterPass(params: IDoesFilterPassParams): boolean {
        return true;
    }

    getModel(): any {
        if (this.isFilterActive()) {
          return {
            filter: this.selectedDate,
            filterType: 'date',
            type: this.selectedType
          };
        }
        return null;
    }

    setModel(model: any): void {
      if (model && model.value) {
        this.selectedDate = model.value;
      }
    }

    onClear() {
      this.selectedType = 'equals';
      this.selectedDate = null;
      this.datepicker.onClearDate();
      this.onFilter();
    }

    onFilter() {
      this.params.filterChangedCallback();
    }

    onUpdateDate(date: NgbDate) {
      this.selectedDate = new Date(`${date.year}-${date.month}-${date.day}`).getTime() / 1000; ;
    }
}


