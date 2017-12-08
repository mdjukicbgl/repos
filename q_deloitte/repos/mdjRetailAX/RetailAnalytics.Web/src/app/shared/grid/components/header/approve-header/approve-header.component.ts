import { RecommendationsModel } from '../../../../../recommendations/models/recommendations.model';
import { Component, ElementRef } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { IHeaderAngularComp } from 'ag-grid-angular/main';
import { IHeaderParams } from 'ag-grid/main';
import { Observable, Subscription } from 'rxjs/Rx';

interface MyParams extends IHeaderParams {
  translationKey: string;
  indexToAppend: number;
  suppressMenu: boolean;
  scenarioId: number;
}

@Component({
    moduleId: module.id,
    templateUrl: 'approve-header.component.html',
    styleUrls: ['./approve-header.component.scss'],
})
export class ApproveHeaderComponent implements IHeaderAngularComp {

    public params: MyParams;
    public sorted;
    public scenarioId: number;
    public headerName;
    public state;
    private elementRef: ElementRef;
    private _subscriptions: Array<Subscription> = [];

    acceptAllRecommendationsComplete$: Observable<boolean>;
    rejectAllRecommendationsComplete$: Observable<boolean>;

    constructor( elementRef: ElementRef, private translate: TranslateService, private _model: RecommendationsModel) {
      this.elementRef = elementRef;
      this.acceptAllRecommendationsComplete$ = _model.acceptAllRecommendationsComplete$;
      this.rejectAllRecommendationsComplete$ = _model.rejectAllRecommendationsComplete$;
    }

    agInit(params: MyParams): void {
      this.params = params;
      this._subscriptions.push(this.translate.onLangChange.subscribe((event) => {
        this.getHeaderName();
      }));
      this.getHeaderName();
      this.observeAccceptRejectAll();
    }

    observeAccceptRejectAll() {
      let combined = Observable.combineLatest(
        this.acceptAllRecommendationsComplete$,
        this.rejectAllRecommendationsComplete$,
      );

      this._subscriptions.push(combined.skip(1).subscribe(latestValues => {
        const [
          acceptAllRecommendationsComplete,
          rejectAllRecommendationsComplete,
          ] = latestValues;
          if (acceptAllRecommendationsComplete || rejectAllRecommendationsComplete) {
            this.params.context.componentParent.refreshRecommendations();
          }
      }));
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
            this.params.setSort('desc', $event.shiftKey);
        } else if (this.params.column.isSortDescending()) {
            this.params.setSort('', $event.shiftKey);
        } else {
            this.params.setSort('asc', $event.shiftKey);
        }
    };

    onMenuClick($event) {
        this.params.showColumnMenu(this.querySelector('.header-cell--menu-button'));
    }

    stateChange($event): void {
      this.params.context.componentParent.clearNotifications();
      this.params.context.componentParent.setIsLoading(true);
      switch ($event) {
        case true:
            this.state = 'ACCEPTED';
            this._model.acceptAllRecommendations(this.params.scenarioId);
            break;
        case false:
            this.state = 'REJECTED';
            this._model.rejectAllRecommendations(this.params.scenarioId);
            break;
        default:
            return;
      }

    }

    private querySelector(selector: string) {
        return <HTMLElement>this.elementRef.nativeElement.querySelector(
            '.header-cell--menu-button', selector);
    }

    OnDestroy() {
      this._subscriptions.forEach((sub) => sub.unsubscribe());
    }

}
