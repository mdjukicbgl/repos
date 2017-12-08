import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ErrorGroupComponent } from './error-group.component';

describe('ErrorGroupComponent', () => {
  let component: ErrorGroupComponent;
  let fixture: ComponentFixture<ErrorGroupComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ErrorGroupComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ErrorGroupComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
