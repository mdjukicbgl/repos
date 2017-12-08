import { Component, Input, AfterViewInit, ViewChild, ComponentFactoryResolver, OnDestroy } from '@angular/core';
import { ChangeDetectorRef } from '@angular/core';

import { WidgetHostDirective } from '../../directives/widget-host.directive';
import { ScenariosWidgetComponent } from '../widget/scenarios-widget/scenarios-widget.component';
import { WidgetType } from '../../models/widget-type.enum';
import { Widget } from '../../models/widget.entity';

@Component({
  selector: 'app-widget-host',
  templateUrl: './widget-factory.component.html',
  styleUrls: ['./widget-factory.component.scss']
})
export class WidgetFactoryComponent implements AfterViewInit {
  @Input() widget: Widget;
  @ViewChild(WidgetHostDirective) widgetHost: WidgetHostDirective;

  constructor(private _componentFactoryResolver: ComponentFactoryResolver, private cdRef: ChangeDetectorRef) { }

  ngAfterViewInit() {
    this.loadComponent();

    // https://github.com/angular/angular/issues/11007
    this.cdRef.detectChanges();
  }

  loadComponent() {
    let componentFactory = this._componentFactoryResolver.resolveComponentFactory(this.getWidgetType());
    let viewContainerRef = this.widgetHost.viewContainerRef;
    viewContainerRef.clear();

    let componentRef = viewContainerRef.createComponent(componentFactory, 0);
    this.initialiseComponent(componentRef);
  }

  getWidgetType() {
    if ( this.widget ) {
      switch ( this.widget.widgetType ) {
        case WidgetType.ScenarioSummary:
          return ScenariosWidgetComponent;
        default:
          return ScenariosWidgetComponent;
      }
    }
    return ScenariosWidgetComponent;
  }

  initialiseComponent( componentRef ) {
    switch ( this.widget.widgetType ) {
      case WidgetType.ScenarioSummary:
         (<ScenariosWidgetComponent>componentRef.instance).widget = this.widget;
        break;
      default:
        (<ScenariosWidgetComponent>componentRef.instance).widget = this.widget;
    }
  }
}
