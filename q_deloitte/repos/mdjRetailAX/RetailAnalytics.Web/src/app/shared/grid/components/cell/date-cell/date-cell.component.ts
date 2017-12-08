import { Component } from '@angular/core';

@Component({
  selector: 'app-date-cell',
  template: `<span *ngIf="params.value != null">{{ params.value |  localeDate:locale: 'shortDate' }}</span>`
})
export class DateCellComponent {
    params: any;
    locale: string;

    agInit(params: any): void {
        this.params = params;
        this.locale = this.params.context.componentParent.localeUtil.getCurrentLocale();
    }
}
