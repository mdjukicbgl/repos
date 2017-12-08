import { Component, ElementRef } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { IHeaderAngularComp } from 'ag-grid-angular/main';
import { IHeaderParams } from 'ag-grid/main';
import { Subscription } from 'rxjs/Rx';
import { UserPreferencesService } from '../../../../user-preferences/services/user-preferences.service';

interface MyParams extends IHeaderParams {
  translationKey: string;
  indexToAppend: number;
  suppressMenu: boolean;
}

@Component({
    moduleId: module.id,
    templateUrl: 'standard-header.component.html',
    styleUrls: ['./standard-header.component.scss'],
})
export class StandardHeaderComponent implements IHeaderAngularComp {

    public params: MyParams;
    public sorted = '';
    public headerName = '';
    private elementRef: ElementRef;
    private _subscriptions: Array<Subscription> = [];

    constructor( elementRef: ElementRef, private translate: TranslateService, private userPreferencesService: UserPreferencesService ) {
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
          this.headerName = this.params.indexToAppend ? res + ' ' + this.params.indexToAppend : res;
      }));
    }

    getSort() {
      return this.params.column.getSort()
    }

    onSortRequested($event) {
        if (this.params.column.isSortAscending()) {
            this.userPreferencesService.setScenarioSortModel(this.params.column.getColId(), 'desc');
            this.params.setSort('desc', false);
        } else if (this.params.column.isSortDescending()) {
            this.userPreferencesService.setScenarioSortModel(this.params.column.getColId(), '');
            this.params.setSort('', false);
        } else {
            this.userPreferencesService.setScenarioSortModel(this.params.column.getColId(), 'asc');
            this.params.setSort('asc', false);
        }
    };

    onMenuClick($event) {
        this.params.showColumnMenu(this.querySelector('.header-cell--menu-button'));
    }

    private querySelector(selector: string) {
        return <HTMLElement>this.elementRef.nativeElement.querySelector(
            '.header-cell--menu-button', selector);
    }

    OnDestroy() {
      this._subscriptions.forEach((sub) => sub.unsubscribe());
    }

}
