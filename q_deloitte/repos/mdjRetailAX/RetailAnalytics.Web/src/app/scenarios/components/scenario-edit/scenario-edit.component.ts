import { Observable } from 'rxjs/Observable';
import { Component, OnInit, ViewChild, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs/Rx';
import { ScenariosModel } from '../../models/scenarios.model';
import { CalendarWeeks } from '../../../shared/calendar-weeks/models/calendar-weeks.entity';
import { Scenario } from '../../models/scenarios.entity';
import { LinkItemType } from '../../../shared/navigation/subnav-link/models/link-item.entity';
import { TranslateService } from "@ngx-translate/core";
import { Router } from '@angular/router';

import { NgbModal } from '@ng-bootstrap/ng-bootstrap/modal/modal.module';


@Component({
    selector: 'scenario-edit',
    templateUrl: './scenario-edit.component.html',
    styleUrls: ['./scenario-edit.component.scss'],
    providers: [ ScenariosModel],
    host: { 'class': 'vertical-flex' }
})
export class ScenarioEditComponent implements OnInit, OnDestroy {
    @ViewChild('content') content: NgbModal;

    step: number = 1;

    uploadedFileGuid: string = '';
    selectedWeeks: string;
    selectedProducts: string;
    selectedProductIds: number[] = [];
    subNavLinks: Array<LinkItemType> = [];
    errors: Array<string> = [];
    scenarioName: any;
    translations: String[];

    _subscriptions: Array<Subscription> = [];

    newScenarioId$: Observable<number>;
    scenarioIsRunning$: Observable<boolean>;
    scenarioRunHasCompleted$: Observable<boolean>;
    scenarioRunHasFailed$: Observable<boolean>;

    scenarioIsSaving$: Observable<boolean>;
    scenarioSaveComplete$: Observable<boolean>;
    scenarioSaveHasFailed$: Observable<boolean>;

    _newScenarioSubscription: Subscription;
    _scenarioRunHasCompletedSubscription: Subscription;
    _scenarioSaveHasCompletedSubscription: Subscription;

    constructor(private _model: ScenariosModel, private router: Router, private modalService: NgbModal, private translate: TranslateService) {
      this.newScenarioId$ = this._model.newScenarioId$;
      this.scenarioRunHasCompleted$ = this._model.scenarioRunComplete$
      this.scenarioRunHasFailed$ = this._model.scenarioRunHasFailed$;
      this.scenarioIsRunning$ = this._model.scenarioIsRunning$;

      this.scenarioIsSaving$ = this._model.scenarioIsSaving$;
      this.scenarioSaveComplete$ = this._model.scenarioSaveComplete$;
      this.scenarioSaveHasFailed$ = this._model.scenarioSaveHasFailed$;
    }

    ngOnInit() {
      this.getTranslations();
      this._subscriptions.push(this.translate.onLangChange.subscribe(() => {
        this.getTranslations();
      }));
    }

    getTranslations() {
      this._subscriptions.push(this.translate.get([
        'SCENARIOS.EDIT.ERROR_SCENARIO_NAME_REQUIRED',
        'SCENARIOS.EDIT.ERROR_NO_WEEKS_SELECTED',
        'SCENARIOS.EDIT.ERROR_NO_PRODUCTS_SELECTED',
        'SCENARIOS.EDIT.ERROR_WEEKS_CONSECUTIVE',
      ]).subscribe((res: string[]) => {
          this.translations = res;
      }));
    }

    /* Save button calls with false, Save and Run button calls with true */
    saveScenario(andRun: boolean) {
      this.resetErrors();
      this.parseProducts();
      this.addErrors();
      this._model.resetScenarioRunHasFailed();
      this._model.resetScenarioSaveHasFailed();

      if( this.errors.length === 0 ) {
        if(andRun){
          this.openModalService();
        } else {
          this._model.saveScenario(this.scenarioName, this.selectedWeeks, this.serializeSelectedProductsIds(this.selectedProductIds), this.uploadedFileGuid);
          this.router.navigate(['/markdown/scenarios']);
        }
      }
    }

    runScenario(scenarioId: number) {
      this._model.runScenario(scenarioId);
    }

    /* Modal Functionality */

    openModalService(){
      this.modalService.open(this.content, { size: 'sm' });
    }

    modalConfirmButtonClicked(closeCallback) {
      this._newScenarioSubscription = this.newScenarioId$.skip(1).subscribe((scenarioId: number) => {
        this._newScenarioSubscription.unsubscribe();
        this.runScenario(scenarioId);
      });

      this._scenarioRunHasCompletedSubscription = this.scenarioRunHasCompleted$.skip(1).subscribe((scenarioRunComplete: any) => {
        if (scenarioRunComplete){
          this._scenarioRunHasCompletedSubscription.unsubscribe();
          closeCallback();
          this.router.navigate(['/markdown/scenarios']);
        }
      });

      this._model.saveScenario(this.scenarioName, this.selectedWeeks, this.serializeSelectedProductsIds(this.selectedProductIds), this.uploadedFileGuid);
    }

    modalCancelButtonClicked(closeCallback) {
      /* Avoids infinite modal loop */
      if (this._scenarioSaveHasCompletedSubscription){
        this._scenarioSaveHasCompletedSubscription.unsubscribe();
      }

      this._scenarioSaveHasCompletedSubscription = this.scenarioSaveComplete$.skip(1).subscribe((scenarioSaveComplete: any) => {
        if (scenarioSaveComplete){
          this._scenarioSaveHasCompletedSubscription.unsubscribe();
          closeCallback();
          this.router.navigate(['/markdown/scenarios']);
        }
      });
      this._model.saveScenario(this.scenarioName, this.selectedWeeks, this.serializeSelectedProductsIds(this.selectedProductIds), this.uploadedFileGuid);
    }

    close(closeCallback){
      closeCallback();
    }

    /* Functionality to prepare scenario for saving */

    serializeSelectedProductsIds(productIds) {
      let result = '';
      productIds.forEach((id)=> {
        result += '&hierarchyIds=' + id;
      });
      return result;
    }

    setSelectedWeeks($event) {
      this.selectedWeeks = $event;
    }

    parseProducts() {
      this.selectedProductIds = [];
      if ( this.selectedProducts ) {
        var stringArray: Array<string> = this.selectedProducts.split(',');
        stringArray.forEach((str) => {
          var product = parseInt(str.trim());
          if (!isNaN(product)){
            this.selectedProductIds.push(product);
          }
        })
      };
    }

    addErrors() {
      if( !this.scenarioName ){
        this.errors.push(this.translations['SCENARIOS.EDIT.ERROR_SCENARIO_NAME_REQUIRED']);
      }
      if( !this.selectedWeeks ){
        this.errors.push(this.translations['SCENARIOS.EDIT.ERROR_NO_WEEKS_SELECTED']);
      } else if (this.hasConsecutiveWeeks(this.selectedWeeks)) {
        this.errors.push(this.translations['SCENARIOS.EDIT.ERROR_WEEKS_CONSECUTIVE']);
      }
      if( (!this.selectedProductIds || this.selectedProductIds.length === 0) && (this.uploadedFileGuid === '') ){
        this.errors.push(this.translations['SCENARIOS.EDIT.ERROR_NO_PRODUCTS_SELECTED']);
      }
    }

    resetErrors() {
      this.errors = [];
    }

    hasConsecutiveWeeks(selectedWeeks) {
      return selectedWeeks.includes('11');
    }

    confirmToRunScenario(closeCallback) {

      this._newScenarioSubscription = this.newScenarioId$.skip(1).subscribe((scenarioId: number) => {
        this._newScenarioSubscription.unsubscribe();
        this.runScenario(scenarioId);
      });

      this._scenarioRunHasCompletedSubscription = this.scenarioRunHasCompleted$.skip(1).subscribe((scenarioRunComplete: any) => {
        if (scenarioRunComplete){
          this._scenarioRunHasCompletedSubscription.unsubscribe();
          closeCallback();
          this.router.navigate(['/markdown/scenarios']);
        }
      });

      this._model.saveScenario(this.scenarioName, this.selectedWeeks, this.serializeSelectedProductsIds(this.selectedProductIds), this.uploadedFileGuid);

    }

    setUploadedFileGuid($event) {
      this.uploadedFileGuid = '&uploadedFile=' + $event;
    }

    nextStep() {
      if (this.step !== 4) {
        this.step +=1;
      }
    }

    backStep() {
      if (this.step !== 1) {
        this.step -= 1;
      }
    }

    ngOnDestroy() {
      this._subscriptions.forEach((sub) => sub.unsubscribe());
      if (this._scenarioRunHasCompletedSubscription) {this._scenarioRunHasCompletedSubscription.unsubscribe()}
      if (this._scenarioSaveHasCompletedSubscription) {this._scenarioSaveHasCompletedSubscription.unsubscribe()}
    }

}
