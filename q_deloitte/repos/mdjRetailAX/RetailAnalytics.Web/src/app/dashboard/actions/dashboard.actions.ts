import { Action } from '@ngrx/store';
import { type } from '../../shared/utils/type';

/**
 * For each action type in an action group, make a simple
 * enum object for all of this group's action types.
 *
 * The 'type' utility function coerces strings into string
 * literal types and runs a simple check to guarantee all
 * action types in the application are unique.
 */
export const ActionTypes = {

    LOAD_DASHBOARD: type('[Dashboard] Load Dashboard'),
    LOAD_DASHBOARD_COMPLETE: type('[Dashboard] Load Dashboard Complete'),
    LOAD_DASHBOARD_FAILED: type('[Dashboard] Load Dashboard Failed'),
    LOAD_SCENARIOS: type('[Dashboard] Load Scenarios'),
    LOAD_SCENARIOS_COMPLETE: type('[Dashboard] Load Scenarios Complete'),
    LOAD_SCENARIOS_FAILED: type('[Dashboard] Load Scenarios Failed'),

};

// /**
//  * Every action is comprised of at least a type and an optional
//  * payload. Expressing actions as classes enables powerful
//  * type checking in reducer functions.
//  *
//  * See Discriminated Unions: https://www.typescriptlang.org/docs/handbook/advanced-types.html#discriminated-unions
//  */

export class LoadDashboardAction implements Action {
    type = ActionTypes.LOAD_DASHBOARD;

    constructor() { }
}

export class LoadScenariosAction implements Action {
    type = ActionTypes.LOAD_SCENARIOS;

    constructor(public payload: string) { }
}
