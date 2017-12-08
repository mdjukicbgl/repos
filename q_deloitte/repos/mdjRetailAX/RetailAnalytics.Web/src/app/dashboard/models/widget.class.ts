import { ScenarioWidget } from './scenario-widget.entity';
import { WidgetType } from './widget-type.enum';
import { Widget } from './widget.entity';

export class WidgetImpl implements Widget {

    title: string;
    dashboardId: number;
    widgetId: number;
    widgetInstanceId: number;
    widgetType: WidgetType;
    json: any;
    jsonVersion: number;
    order: number;
    isVisible: number;

    getWidget(): ScenarioWidget {
        switch (this.widgetType) {
            case WidgetType.ScenarioSummary:
                return <ScenarioWidget>JSON.parse(this.json);
            default:
                throw 'An error occured parsing the DashboardItemType';
        }
    }
}
