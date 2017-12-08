import { NO_ERRORS_SCHEMA } from '@angular/core';
import { GridUtils } from '../../../utils/grid-utils';
import { ApproveCellComponent } from './approve-cell.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';

describe('ApproveCellComponent', () => {
  let component: any;
  let fixture: ComponentFixture<ApproveCellComponent>;
  let nativeElement: HTMLElement | null;
  let model;

   beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ApproveCellComponent ],
      imports: [],
      providers: [ GridUtils ],
      schemas: [ NO_ERRORS_SCHEMA ],
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ApproveCellComponent);
    component = fixture.componentInstance;
    component.params = {
      data: {
        recommendationGuid: 'guid',
        scenarioId: 99
      },
      value: 'ACCEPTED',
      context: {
        componentParent: {
          updateRowData: () => {},
          gridOptions: {

          },
          _model: {
            acceptRecommendation: () => {},
            rejectRecommendation: () => {},
          }
        }
      }
    };
    component.data = {
      recommendationGuid: 'guid',
      scenarioId: 99
    }
    nativeElement = fixture.nativeElement;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should on state change from rejected to call approve', () => {
    spyOn(component.params.context.componentParent._model, 'acceptRecommendation');
    component.state = 'REJECTED';
    component.stateChange()
    expect(component.params.context.componentParent._model.acceptRecommendation).toHaveBeenCalled();
  });

  it('should on state change from accepted to call reject', () => {
    spyOn(component.params.context.componentParent._model, 'rejectRecommendation');
    component.state = 'ACCEPTED';
    component.stateChange()
    expect(component.params.context.componentParent._model.rejectRecommendation).toHaveBeenCalled();
  });

  it('should on state change from revised to call reject', () => {
    spyOn(component.params.context.componentParent._model, 'rejectRecommendation');
    component.state = 'REVISED';
    component.stateChange()
    expect(component.params.context.componentParent._model.rejectRecommendation).toHaveBeenCalled();
  });



});
