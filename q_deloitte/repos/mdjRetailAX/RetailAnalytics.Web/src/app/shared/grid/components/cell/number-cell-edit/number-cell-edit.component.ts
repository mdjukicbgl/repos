import { Component } from '@angular/core';

@Component({
  selector: 'app-number-cell-edit',
  template: `<input type="text" class="form-control" [(ngModel)]="params.value"/>`,
  styles: [`.form-control {
    height: 20px;
    margin-top: -2px;
    margin-left: -1.5em;
  }`]
})
export class NumberCellEditComponent {
    params: any;

    agInit(params: any): void {
        this.params = params;
    }
}
