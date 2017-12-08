import { Action } from '@ngrx/store';
import { type } from '../../shared/utils/type';
import { ServerParams } from "../../shared/grid/models/server-params.entity";

export const ActionTypes = {
    LOAD_SCENARIOS_INITIAL: type('[Scenarios] Load Initial Scenarios'),
    LOAD_SCENARIOS_INITIAL_COMPLETE: type('[Scenarios] Load Initial Scenarios Complete'),
    LOAD_SCENARIOS_INITIAL_FAILED: type('[Scenarios] Load Initial Scenarios Failed'),
    LOAD_SCENARIOS: type('[Scenarios] Load Scenarios'),
    LOAD_SCENARIOS_COMPLETE: type('[Scenarios] Load Scenarios Complete'),
    LOAD_SCENARIOS_FAILED: type('[Scenarios] Load Scenarios Failed'),
    LOAD_SELECTED_SCENARIO: type('[Scenarios] Load Selected Scenario'),
    LOAD_SELECTED_SCENARIO_IS_LOADING: type('[Scenarios] Load Selected Scenario Is Loading'),
    LOAD_SELECTED_SCENARIO_COMPLETE: type('[Scenarios] Load Selected Scenario Complete'),
    LOAD_SELECTED_SCENARIO_FAILED: type('[Scenarios] Load Selected Scenario Has Failed'),
    SAVE_SCENARIO: type('[Scenarios] Save Scenario'),
    SAVE_SCENARIO_COMPLETE: type('[Scenarios] Save Scenario Complete'),
    SAVE_SCENARIO_FAILED: type('[Scenarios] Save Scenario Failed'),
    RESET_SCENARIO_SAVE_HAS_FAILED: type ('[Scenarios] Reset Scenario Save Has Failed'),
    RUN_SCENARIO: type('[Scenarios] Run Scenario'),
    RUN_SCENARIO_COMPLETE: type('[Scenarios] Run Scenario Complete'),
    RUN_SCENARIO_FAILED: type('[Scenarios] Run Scenario Failed'),
    RESET_SCENARIO_RUN_HAS_FAILED: type('[Scenarios] Reset Scenario Run Has Failed'),
    SET_SCENARIOS_FILTER: type('[Scenarios] Set Scenarios Filter'),
};

export class LoadScenariosInitialAction implements Action {
    type = ActionTypes.LOAD_SCENARIOS_INITIAL;
    constructor(public payload: string) { }
}

export class LoadScenariosAction implements Action {
    type = ActionTypes.LOAD_SCENARIOS;

    constructor(public payload: string) { }
}

export class LoadSelectedScenario implements Action {
    type = ActionTypes.LOAD_SELECTED_SCENARIO;

    constructor(public scenarioId: number) {}
}

export class LoadSelectedScenarioIsLoading implements Action {
    type = ActionTypes.LOAD_SELECTED_SCENARIO_IS_LOADING;

    constructor(public scenarioId: number) {}
}

export class LoadSelectedScenarioComplete implements Action {
    type = ActionTypes.LOAD_SELECTED_SCENARIO_COMPLETE;

    constructor(public scenarioId: number) {}
}

export class LoadSelectedScenarioHasFailed implements Action {
    type = ActionTypes.LOAD_SELECTED_SCENARIO_FAILED;

    constructor(public scenarioId: number) {}
}

export class SetScenariosFilter implements Action {
    type = ActionTypes.SET_SCENARIOS_FILTER;

    constructor(public payload: ServerParams) {}
}

export class SaveScenario implements Action {
    type = ActionTypes.SAVE_SCENARIO;

    constructor(public name: string, public scheduleMask: number, public hierarchyIds: string, public fileGuid ) { }
}

export class ResetScenarioSaveHasFailed implements Action {
    type = ActionTypes.RESET_SCENARIO_SAVE_HAS_FAILED;

    constructor(){}
}

export class RunScenario implements Action {
    type = ActionTypes.RUN_SCENARIO;

    constructor(public payload: number) {}
}

export class ResetScenarioRunHasFailed implements Action {
    type = ActionTypes.RESET_SCENARIO_RUN_HAS_FAILED;

    constructor(){}
}
