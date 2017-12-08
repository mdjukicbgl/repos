
import { Component, ElementRef, OnDestroy } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { IHeaderAngularComp } from 'ag-grid-angular/main';
import { IHeaderParams } from 'ag-grid/main';
import { Subscription } from 'rxjs/Rx';

interface MyParams extends IHeaderParams {
  translationKey: string;
  align: string;
  suppressOffset: boolean;
}

@Component({
  moduleId: module.id,

  template: `<div class="simple-header"
                [ngStyle]="{'text-align': params.align ? params.align : 'left'}"
                [ngClass]="{'suppressOffset': params.suppressOffset}">
                {{headerName}}
             </div>`,
  styles: [`
    .simple-header {
      margin-top: 0.5rem;
      margin-left: 1.7rem;
    }
    .suppressOffset {
      margin-left: 0rem;
    }
    `]
})

export class SimpleHeaderComponent implements OnDestroy, IHeaderAngularComp {
  public params: MyParams;
  private elementRef: ElementRef;
  public headerName: string;
  private _subscriptions: Array<Subscription> = [];

  constructor(elementRef: ElementRef, private translate: TranslateService) {
      this.elementRef = elementRef;
  }

  agInit(params: MyParams): void {
    this.params = params;
    this._subscriptions.push(this.translate.onLangChange.subscribe((event) => {
      this.getHeaderName();
    }));
    this.getHeaderName();
  }

  getHeaderName() {
    this._subscriptions.push(this.translate.get(this.params.translationKey).subscribe((res: string) => {
      this.headerName = res;
    }));
  }

  ngOnDestroy() {}
}
