import { EmptyHeaderComponent } from './empty-header.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

describe('EmptyHeaderComponent', () => {
  let component: any;
  let fixture: ComponentFixture<EmptyHeaderComponent>;
  let nativeElement: HTMLElement | null;
  let model;

   beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EmptyHeaderComponent ],
      imports: []
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EmptyHeaderComponent);
    component = fixture.componentInstance;
    nativeElement = fixture.nativeElement;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

});
