import { Observable } from 'rxjs/Observable';
import { BehaviorSubject } from 'rxjs/Rx';
import { RecommendationsModel } from '../../../../../recommendations/models/recommendations.model';
import { SlideToggleModule } from '../../../../slide-toggle/slide-toggle.module';
import { ApproveHeaderComponent } from './approve-header.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { LocalizationModule } from 'angular-l10n';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';

class MockRecommendationsModel {

  acceptAllRecommendationsCompleteSource = new BehaviorSubject<Boolean>(false);
  acceptAllRecommendationsComplete$: Observable<Boolean> = this.acceptAllRecommendationsCompleteSource.asObservable();

  rejectAllRecommendationsCompleteSource = new BehaviorSubject<Boolean>(false);
  rejectAllRecommendationsComplete$: Observable<Boolean> = this.rejectAllRecommendationsCompleteSource.asObservable();

  acceptAllRecommendations() {}
  rejectAllRecommendations() {}

}

describe('ApproveHeaderComponent', () => {
  let component: any;
  let fixture: ComponentFixture<ApproveHeaderComponent>;
  let nativeElement: HTMLElement | null;
  let model;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ApproveHeaderComponent ],
      imports: [
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        SlideToggleModule
      ]
    })
    .overrideComponent(ApproveHeaderComponent, {
    set: {
      providers: [
        { provide: RecommendationsModel, useClass: MockRecommendationsModel },
      ],
    }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ApproveHeaderComponent);
    component = fixture.componentInstance;
    component.params = {
      scenarioId: 1,
      suppressOffset: false,
      translationKey: 'translationKey',
      setSort: (sort, something) => { component.params.column.sort = sort},
      column: {
        sort: '',
        getSort: () => { return component.params.column.sort },

        isSortAscending: () => {
          if (component.params.column.sort === 'asc') {
            return true;
          }
          return false;
        },
        isSortDescending: () => {
          if (component.params.column.sort === 'desc') {
            return true;
          }
          return false;
        }
      },
      context: {
        componentParent: {
          refreshRecommendations: () => {},
          clearNotifications: () => {},
          setIsLoading: () => {},
        }
      }
    }
    model = fixture.debugElement.injector.get(RecommendationsModel);
    nativeElement = fixture.nativeElement;
    fixture.detectChanges();
    component.agInit(component.params);
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should call accept all when clicked', () => {
    spyOn(model, 'acceptAllRecommendations');
    component.stateChange(true);
    expect(model.acceptAllRecommendations).toHaveBeenCalledWith(1);
  });

  it('should call reject all when clicked', () => {
    spyOn(model, 'rejectAllRecommendations');
    component.stateChange(false);
    expect(model.rejectAllRecommendations).toHaveBeenCalledWith(1);
  });

  it('should refresh on accept all complete', () => {
    spyOn(component.params.context.componentParent, 'refreshRecommendations');
    model.acceptAllRecommendationsCompleteSource.next(true);
    expect(component.params.context.componentParent.refreshRecommendations).toHaveBeenCalled();
  });

  it('should refresh on reject all complete', () => {
    spyOn(component.params.context.componentParent, 'refreshRecommendations');
    model.rejectAllRecommendationsCompleteSource.next(true);
    expect(component.params.context.componentParent.refreshRecommendations).toHaveBeenCalled();
  });

  it('should NOT refresh on accept all complete is false', () => {
    spyOn(component.params.context.componentParent, 'refreshRecommendations');
    model.acceptAllRecommendationsCompleteSource.next(false);
    expect(component.params.context.componentParent.refreshRecommendations).not.toHaveBeenCalled();
  });

  it('should NOT refresh on reject all complete is false', () => {
    spyOn(component.params.context.componentParent, 'refreshRecommendations');
    model.rejectAllRecommendationsCompleteSource.next(false);
    expect(component.params.context.componentParent.refreshRecommendations).not.toHaveBeenCalled();
  });

  it('should sort in logical order', () => {
    component.onSortRequested({});
    expect(component.params.column.sort).toEqual('asc');
    component.onSortRequested({});
    expect(component.params.column.sort).toEqual('desc');
    component.onSortRequested({});
    expect(component.params.column.sort).toEqual('');
  });

});
