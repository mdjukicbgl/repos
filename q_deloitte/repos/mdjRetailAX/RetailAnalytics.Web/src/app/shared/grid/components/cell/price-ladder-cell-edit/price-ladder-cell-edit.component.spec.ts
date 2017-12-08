import { PriceLadder } from '../../../../../recommendations/models/recommendations.entity';
import { BehaviorSubject } from 'rxjs/Rx';
import { LoadPriceLadder } from '../../../../../recommendations/actions/recommendations.actions';
import { FormsModule } from '@angular/forms';
import { PriceLadderCellEditComponent } from './price-ladder-cell-edit.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

describe('PriceLadderCellEditComponent', () => {
  let component: any;
  let fixture: ComponentFixture<PriceLadderCellEditComponent>;
  let nativeElement: HTMLElement | null;
  let model;
  let priceLadderSource = new BehaviorSubject<PriceLadder>(null);

  let params = {
      value: '',
      context: {
        componentParent: {
          priceLadderValues: [1,2,3,4,5],
        }
      },
      column: {
        colId: 'discount5',
      },
      node: {
        data: {

          currentDiscountLadderDepth: 0.5,

          discount1: 0.1,
          discount2: 0.2,
          discount3: '',
          discount4: 0.4,
          discount5: 0.5,
          discount6: 0.6,
          discount7: 0.7,
          discount8: 0.8,

          isMarkdown1: true,
          isMarkdown2: true,
          isMarkdown3: true,
          isMarkdown4: true,
          isMarkdown5: true,
          isMarkdown6: true,
          isMarkdown7: true,
          isMarkdown8: true,

          priceLadder: {
            values: {
              priceLadderId: 1,
              priceLadderTypeId: 1,
              description: 'desc',
              values: [1,2,3,4,5]
            }
          }
        },
        setData: () => {}
      }
    }

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ PriceLadderCellEditComponent ],
      imports: [
        FormsModule,
      ],
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PriceLadderCellEditComponent);
    component = fixture.componentInstance;

    component.params = Object.assign({}, params);
    component.updatedRowData = {};

    nativeElement = fixture.nativeElement;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should fetch the price ladder on init', () => {
    spyOn(component, 'getPriceLadder');
    component.agInit(params);
    expect(component.getPriceLadder).toHaveBeenCalled();
  });

  it('should prevent editing if there are no markdown events', () => {
    let isValidSpy = spyOn(component, 'isValidForEditing').and.returnValue(false);
    component.isCancelBeforeStart();
    expect(component.cancelBeforeStart).toEqual(true);
  });

  it('should check if editing is available', () => {
    let isValid = component.isValidForEditing();
    expect(isValid).toEqual(true);
    component.params.node.data.isMarkdown1 = false;
    component.params.node.data.isMarkdown2 = false;
    component.params.node.data.isMarkdown3 = false;
    component.params.node.data.isMarkdown4 = false,
    component.params.node.data.isMarkdown5 = false,
    component.params.node.data.isMarkdown6 = false,
    component.params.node.data.isMarkdown7 = false,
    component.params.node.data.isMarkdown8 = false,
    isValid = component.isValidForEditing();
    expect(isValid).toEqual(false);
  });

  it('should fetch the price ladder if it exists on the row', () => {
    spyOn(component, 'getValidPriceLadderValues').and.returnValue([5,4,3,2,1]);
    component.getPriceLadder();
    expect(component.priceLadderValues).toEqual([5,4,3,2,1]);
  });

  it('should filter out values that are less than the current markdown', () => {
    let filtered = component.filterLessThanCurrentMarkdown([0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]);
    expect(filtered).toEqual([0.5,0.6,0.7,0.8,0.9]);
  });

  it('should filter out values that are less than the previous "weeks" markdown', () => {
    let filtered = component.filterLessThanPreviousMarkdown([0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]);
    expect(filtered).toEqual([0.4,0.5,0.6,0.7,0.8,0.9]);
  });

  it('should call both validations to filter valid values', () => {
    spyOn(component, 'filterLessThanCurrentMarkdown');
    spyOn(component, 'filterLessThanPreviousMarkdown');
    component.getValidPriceLadderValues([0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]);
    expect(component.filterLessThanCurrentMarkdown).toHaveBeenCalled();
    expect(component.filterLessThanPreviousMarkdown).toHaveBeenCalled();
  });

  it('should populate future markdowns with valid data', () => {
    component.params.column.colId = 'discount2';
    component.updatedRowData.discount3 = 0.3;
    component.updatedRowData.discount4 = 0.4;
    component.updatedRowData.discount5 = 0.5;
    component.updatedRowData.discount6 = 0.6;
    component.updatedRowData.discount7 = 0.7;
    component.updatedRowData.discount8 = 0.8;
    component.updatedRowData.isMarkdown3 = false;

    component.updatedRowData.isMarkdown4 = true,
    component.updatedRowData.isMarkdown5 = true,
    component.updatedRowData.isMarkdown6 = true,
    component.updatedRowData.isMarkdown7 = true,
    component.updatedRowData.isMarkdown8 = true,

    component.updateFutureMarkdowns(0.5);
    expect(component.updatedRowData.discount3).toEqual(0.5);
    expect(component.updatedRowData.discount4).toEqual(0.5);
    expect(component.updatedRowData.discount5).toEqual(0.5);
    expect(component.updatedRowData.discount6).toEqual(0.6);
    expect(component.updatedRowData.discount7).toEqual(0.7);
    expect(component.updatedRowData.discount8).toEqual(0.8);
  });

});
