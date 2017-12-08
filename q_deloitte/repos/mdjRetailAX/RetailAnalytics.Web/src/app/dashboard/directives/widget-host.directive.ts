import { Directive, ViewContainerRef } from '@angular/core';

@Directive({
  selector: '[widgetHost]',
})
export class WidgetHostDirective {
  constructor(public viewContainerRef: ViewContainerRef) { }
}

