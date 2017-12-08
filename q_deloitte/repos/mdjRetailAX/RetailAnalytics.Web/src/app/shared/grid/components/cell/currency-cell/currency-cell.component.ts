import { Component } from '@angular/core';

@Component({
  selector: 'app-currency-cell',
  templateUrl: 'currency-cell.component.html'
})
export class CurrencyCellComponent {
    params: any;
    locale: string;
    hasValue: boolean = false;
    format = '1.2-2';
    showNoValueString: boolean = false;

    agInit(params: any): void {
      this.params = params;
      this.hasValue = params.value === undefined ? false : true;
      this.locale = this.params.context.componentParent.localeUtil.getCurrentLocale();

      this.showNoValueString = this.hasNoValueString();

      if (params.format) {
        this.format = params.format;
      }
    }

    hasNoValueString() {
      if( this.params.showNoValueStringProperty && this.params.showNoValueStringValues && this.params.node.data){
        if( this.params.node.data[this.params.showNoValueStringProperty] ){
          return this.params.showNoValueStringValues.indexOf(this.params.node.data[this.params.showNoValueStringProperty]) != -1;
        }
      }
      return false;
    }
}
