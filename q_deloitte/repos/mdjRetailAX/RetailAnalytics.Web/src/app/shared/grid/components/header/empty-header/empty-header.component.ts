
import { Component, ElementRef, OnDestroy } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { IHeaderAngularComp } from 'ag-grid-angular/main';
import { IHeaderParams } from 'ag-grid/main';
import { Subscription } from 'rxjs/Rx';

interface MyParams extends IHeaderParams {
  translationKey: string;
}

@Component({
    moduleId: module.id,
    template: `<span></span>`,
})
export class EmptyHeaderComponent implements OnDestroy, IHeaderAngularComp {
    public params: MyParams;
    private elementRef: ElementRef;

    constructor(elementRef: ElementRef) {
        this.elementRef = elementRef;
    }

    agInit(params: MyParams): void {
      this.params = params;
    }

    ngOnDestroy() {

    }

}
