import { Component } from '@angular/core';

@Component({
  selector: 'app-number-cell',
  templateUrl: 'number-cell.component.html'
})
export class NumberCellComponent {
    params: any;
    locale: string;

    showNoValueString: boolean = false;

    agInit(params: any): void {
        this.params = params;
        this.locale = this.params.context.componentParent.localeUtil.getCurrentLocale();

        this.showNoValueString = this.hasNoValueString();
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
