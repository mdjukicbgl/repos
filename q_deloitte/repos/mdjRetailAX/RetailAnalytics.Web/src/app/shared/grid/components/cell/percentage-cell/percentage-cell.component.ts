import { Component } from '@angular/core';

@Component({
  selector: 'app-percentage-cell',
  templateUrl: 'percentage-cell.component.html',
})
export class PercentageCellComponent {
    params: any;
    locale: string;
    showNoValueString: boolean = false;
    showNoValueStringProperty: string;
    showNoValueStringValues: any[];

    agInit(params: any): void {
        this.params = params;
        this.locale = this.params.context.componentParent.localeUtil.getCurrentLocale();

        this.showNoValueStringProperty = params.showNoValueStringProperty;
        this.showNoValueStringValues = params.showNoValueStringValues;

        if( this.showNoValueStringProperty && this.showNoValueStringValues && params.node.data){
          if( params.node.data[this.params.showNoValueStringProperty] ){
            this.showNoValueString = this.showNoValueStringValues.indexOf(params.node.data[this.params.showNoValueStringProperty]) != -1;
          }
        }
    }
}
