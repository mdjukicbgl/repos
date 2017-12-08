import { Component } from '@angular/core';

@Component({
  selector: 'app-price-ladder-cell',
  templateUrl: 'price-ladder-cell.component.html',
  styleUrls: ['./price-ladder-cell.component.scss']
})
export class PriceLadderCellComponent {
    params: any;
    data: any;
    locale: string;

    isMarkdown = false;
    hasError = false;
    errorMessage: string;

    isMarkdownField = 'isMarkdown';
    discountField = 'discount';
    isCspField = 'isCsp';
    isPaddingField = 'isPadding';
    showMuted = false;

    columnIndex: number;

    agInit(params: any): void {
        this.params = params;
        this.data = params.node.data;
        this.locale = this.params.context.componentParent.localeUtil.getCurrentLocale();

        if (isNaN(this.params.value)) {
          this.params.value = '';
        }

        this.displayErrorMessage();

        this.columnIndex = parseFloat(this.params.column.colId.replace(this.discountField, ''));
        if (this.data) {
          this.isMarkdown = this.data[this.isMarkdownField + this.columnIndex];
          this.showMuted = this.getShowMuted();
        }
    }

    displayErrorMessage() {
      if (this.data && this.data.errorMessage) {
        this.hasError = true;
        this.errorMessage = this.data.errorMessage
      }
    }

    getShowMuted() {
      if (this.data[this.isCspField + this.columnIndex] || this.data[this.isPaddingField + this.columnIndex]) {
        return true;
      }
      return false;
    }

    onClick() {
      this.params.node.setSelected(true);
      this.params.api.startEditingCell({colKey: this.params.column.colId, rowIndex: this.params.rowIndex})
    }

}
