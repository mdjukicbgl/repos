import { WidgetType } from './widget-type.enum';

export interface Widget {
  title: string;
  dashboardId: number;
  widgetId: number;
  widgetInstanceId: number;
  widgetType: WidgetType;
  order: number;
  json: any;
  jsonVersion: number;
  isVisible: number;
}
