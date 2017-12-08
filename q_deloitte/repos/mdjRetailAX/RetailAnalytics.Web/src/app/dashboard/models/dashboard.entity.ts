import { DashboardLayoutType } from './dashboard-layout-type.enum';
import { Widget } from 'app/dashboard/models/widget.entity';

export interface Dashboard {
    dashboardId: number;
    title: string;
    layoutType: DashboardLayoutType;
    items: Widget[];
}
