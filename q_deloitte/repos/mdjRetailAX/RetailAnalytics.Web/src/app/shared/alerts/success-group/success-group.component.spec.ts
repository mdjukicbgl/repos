import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SuccessGroupComponent } from './success-group.component';

describe('SuccessGroupComponent', () => {
  let component: SuccessGroupComponent;
  let fixture: ComponentFixture<SuccessGroupComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SuccessGroupComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SuccessGroupComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
