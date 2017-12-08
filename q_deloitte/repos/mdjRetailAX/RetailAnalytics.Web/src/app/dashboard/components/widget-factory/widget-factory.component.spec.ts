import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { NgSpinKitModule } from 'ng-spin-kit';
import { WidgetFactoryComponent } from './widget-factory.component';
import { ScenariosWidgetComponent } from '../widget/scenarios-widget/scenarios-widget.component';

@NgModule({
  declarations: [WidgetFactoryComponent, ScenariosWidgetComponent],
  entryComponents: [
    ScenariosWidgetComponent,
  ],
  imports: [CommonModule, NgSpinKitModule]
})
class TestModule {}

describe('ScenarioWidgetComponent', () => {
  let component: WidgetFactoryComponent;
  let fixture: ComponentFixture<WidgetFactoryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [TestModule],
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(WidgetFactoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  // TODO: Fix this test when we re-introduce the widget
  /*
  it('should create', () => {
    expect(component).toBeTruthy();
  });*/
});
