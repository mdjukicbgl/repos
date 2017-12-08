import { PriceLadder } from '../../../../../recommendations/models/recommendations.entity';

import { AfterViewInit, Component, ViewChild, ViewContainerRef } from '@angular/core';
import { ICellEditorAngularComp } from 'ag-grid-angular/main';
import { Observable, Subscription } from 'rxjs/Rx';

@Component({
  selector: 'price-ladder-cell-edit',
  templateUrl: './price-ladder-cell-edit.component.html',
  styles: [`.form-control {
    width: auto !important;
    height: 24px !important;
    margin: -4px -8px;
  }`]
})
export class PriceLadderCellEditComponent implements ICellEditorAngularComp, AfterViewInit {

    @ViewChild('container', {read: ViewContainerRef}) public container;

    private params: any;
    public value: number;
    private cancelBeforeStart = false;
    _subscriptions: Array<Subscription> = [];
    discountField = 'discount';
    isMarkdownField = 'isMarkdown';
    isCspField = 'isCsp';
    priceLadderValues: number[] = null;
    updatedRowData: any;

    ngAfterViewInit() {
      this.container.element.nativeElement.children[0].focus();
    }

    agInit(params: any): void {
      this.params = params;
      this.value = this.params.value;
      this.updatedRowData = this.params.node.data;
      if (this.isValidForEditing()) {
        this.getPriceLadder();
      }
    }

    getValue(): any {
      return this.value;
    }

    isCancelBeforeStart(): boolean {
      this.cancelBeforeStart = !this.isValidForEditing();
      return this.cancelBeforeStart;
    }

    isValidForEditing() {
      let index = parseFloat(this.params.column.colId.replace(this.discountField, ''))
      if (this.params.node.data[this.isMarkdownField + index] === true) {
        return true;
      }
      return false;
    }

    getPriceLadder() {
      this.priceLadderValues = this.getValidPriceLadderValues(this.params.context.componentParent.priceLadderValues)
    }

    getValidPriceLadderValues(values: number[]) {
      values = this.filterLessThanCurrentMarkdown(values);
      values = this.filterLessThanPreviousMarkdown(values);
      return values;
    }

    filterLessThanCurrentMarkdown(values: number[]) {
      return values.filter( x => {
        return x >= this.params.node.data.currentDiscountLadderDepth;
      });
    }

    filterLessThanPreviousMarkdown(values: number[]) {
      let discountIndex = parseFloat(this.params.column.colId.replace(this.discountField, ''))
      let previousDiscount;
      while (discountIndex > 1) {
        discountIndex--;
        if (this.params.node.data[this.discountField + discountIndex] !== '') {
          previousDiscount = parseFloat(this.params.node.data[this.discountField + discountIndex]);
          break;
        }
      }
      if (previousDiscount) {
        values = values.filter( x => {
          return x >= previousDiscount;
        });
      }
      return values;
    }

    onChange(newValue) {
      this.updateFutureMarkdowns(parseFloat(newValue));
    }

    updateFutureMarkdowns(newValue) {
      let discountIndex = parseFloat(this.params.column.colId.replace(this.discountField, ''));
      this.updatedRowData[this.discountField + discountIndex] = newValue;
      this.updatedRowData[this.isCspField + discountIndex] = false;
      discountIndex++;
      while ( this.updatedRowData[this.discountField + discountIndex] !== undefined &&
              this.updatedRowData[this.discountField + discountIndex] < newValue ) {
        this.updatedRowData[this.discountField + discountIndex] = newValue;
        discountIndex++;
      }
    }

    onClick($event) {
      $event.stopPropagation();
      this.params.api.stopEditing(true);
    }

    onSelectClick($event) {
      $event.stopPropagation();
    }

    OnDestroy() {
      if (this.updatedRowData) {
        this.params.node.setData(this.updatedRowData);
      }
      this._subscriptions.forEach((sub) => sub.unsubscribe());
    }
}
