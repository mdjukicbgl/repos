import { Action } from '@ngrx/store';
import { type } from '../../utils/type';

export const ActionTypes = {
    SET_GRID_STATE: type('[UserPreferences] Set Grid State'),
    CLEAR_GRID_STATE: type('[UserPreferences] Clear Grid State'),

    SET_SORT_STATE: type('[UserPreferences] Set Sort State'),
    CLEAR_SORT_STATE: type('[UserPreferences] Clear Sort State'),

    SET_LAST_WORKSPACE: type('[UserPreferences] Set Last Workspace')
}

export class SetGridState implements Action {
    type = ActionTypes.SET_GRID_STATE;

    constructor(public route: string, public state: Object) {}
}

export class ClearGridState implements Action {
    type = ActionTypes.CLEAR_GRID_STATE;

    constructor(public route: string) {}
}

export class SetSortState implements Action {
    type = ActionTypes.SET_SORT_STATE;

    constructor(public route: string, public state: Object) {}
}

export class ClearSortState implements Action {
    type = ActionTypes.CLEAR_SORT_STATE;

    constructor(public route: string) {}
}

export class SetLastWorkSpace implements Action {
    type = ActionTypes.SET_LAST_WORKSPACE;

    constructor(public scenarioId: number) {}
}