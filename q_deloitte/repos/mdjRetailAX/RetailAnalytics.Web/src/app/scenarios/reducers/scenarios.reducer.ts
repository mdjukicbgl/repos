import '@ngrx/core/add/operator/select';
import { Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { AppState } from '../../../app/app.reducer';
import { ServerParams } from '../../shared/grid/models/server-params.entity';
import * as ScenariosActions from '../actions/scenarios.actions';
import {
    Scenario,
} from '../models/scenarios.entity';

export interface ScenariosState {

    scenariosInitial: Scenario[];
    scenariosInitialIsLoading: boolean;
    scenariosInitialComplete: boolean;
    scenariosInitialHasFailed: boolean;

    scenarios: Scenario[];
    scenariosIsLoading: boolean;
    scenariosComplete: boolean;
    scenariosHasFailed: boolean;

    selectedScenario: Scenario;
    selectedScenarioComplete: boolean;
    selectedScenarioIsLoading: boolean;
    selectedScenarioHasFailed: boolean;

    scenariosFilter: ServerParams;

    newScenarioId: number;
    scenarioIsRunning: boolean;
    scenarioRunComplete: boolean;
    scenarioRunHasFailed: boolean;

    scenarioIsSaving: boolean;
    scenarioSaveComplete: boolean;
    scenarioSaveHasFailed: boolean;

}

export const initialState: ScenariosState = {

    scenariosInitial: null,
    scenariosInitialIsLoading: false,
    scenariosInitialComplete: false,
    scenariosInitialHasFailed: false,

    scenarios: [],
    scenariosIsLoading: false,
    scenariosComplete: false,
    scenariosHasFailed: false,

    selectedScenario: null,
    selectedScenarioComplete: false,
    selectedScenarioIsLoading: false,
    selectedScenarioHasFailed: false,

    scenariosFilter: { sorts: [], filters: [], paging: { pageIndex:1, pageLimit:100 }},

    newScenarioId:0,
    scenarioIsRunning: false,
    scenarioRunComplete: false,
    scenarioRunHasFailed: false,

    scenarioIsSaving: false,
    scenarioSaveComplete: false,
    scenarioSaveHasFailed: false,

}

export function ScenariosReducer(state: ScenariosState = initialState, action: Action): ScenariosState {
    switch (action.type) {

        /* Scenarios Initial */
        case ScenariosActions.ActionTypes.LOAD_SCENARIOS_INITIAL: {
            return {
                ...state,
                scenariosInitialIsLoading: true,
                scenariosInitialComplete: false,
                scenariosInitialHasFailed: false,
            };
        }
        case ScenariosActions.ActionTypes.LOAD_SCENARIOS_INITIAL_COMPLETE: {
            return {
                ...state,
                scenariosInitial: injectStubbedData(action.payload.items),
                scenarios: injectStubbedData(action.payload.items),
                scenariosInitialIsLoading: false,
                scenariosInitialComplete: true,
                scenariosInitialHasFailed: false,
            }
        }
        case ScenariosActions.ActionTypes.LOAD_SCENARIOS_INITIAL_FAILED: {
            return {
                ...state,
                scenarios: [],
                scenariosInitialIsLoading: false,
                scenariosInitialComplete: false,
                scenariosInitialHasFailed: true,
            };
        }

        /* Scenarios */
        case ScenariosActions.ActionTypes.LOAD_SCENARIOS: {
            return {
                ...state,
                scenariosIsLoading: true,
                scenariosComplete: false,
                scenariosHasFailed: false,
            };
        }
        case ScenariosActions.ActionTypes.LOAD_SCENARIOS_COMPLETE: {
            return {
                ...state,
                scenarios: injectStubbedData(action.payload.items),
                scenariosIsLoading: false,
                scenariosComplete: true,
                scenariosHasFailed: false,
            };
        }
        case ScenariosActions.ActionTypes.LOAD_SCENARIOS_FAILED: {
            return {
                ...state,
                scenarios: [],
                scenariosIsLoading: false,
                scenariosComplete: false,
                scenariosHasFailed: true,
            };
        }

        /* Selected Scenario */
        case ScenariosActions.ActionTypes.LOAD_SELECTED_SCENARIO: {
            return {
                ...state,
                selectedScenarioComplete: false,
                selectedScenarioIsLoading: false,
                selectedScenarioHasFailed: false,
            };
        }

        case ScenariosActions.ActionTypes.LOAD_SELECTED_SCENARIO_IS_LOADING: {
            return {
                ...state,
                selectedScenarioComplete: false,
                selectedScenarioIsLoading: true,
                selectedScenarioHasFailed: false,
            };
        }

        case ScenariosActions.ActionTypes.LOAD_SELECTED_SCENARIO_COMPLETE: {
            return {
                ...state,
                selectedScenario: action.payload,
                selectedScenarioComplete: true,
                selectedScenarioIsLoading: false,
                selectedScenarioHasFailed: false,
            };
        }

        case ScenariosActions.ActionTypes.LOAD_SELECTED_SCENARIO_FAILED: {
            return {
                ...state,
                selectedScenario: null,
                selectedScenarioComplete: false,
                selectedScenarioIsLoading: false,
                selectedScenarioHasFailed: true,
            };
        }

        /* Scenario Run */

        case ScenariosActions.ActionTypes.RUN_SCENARIO: {
            return {
                ...state,
                scenarioRunComplete: false,
                scenarioRunHasFailed: false,
                scenarioIsRunning: true,
            };
        }

        case ScenariosActions.ActionTypes.RUN_SCENARIO_COMPLETE: {
            return {
                ...state,
                scenarioRunComplete: true,
                scenarioRunHasFailed: false,
                scenarioIsRunning: false,
            };
        }

        case ScenariosActions.ActionTypes.RUN_SCENARIO_FAILED: {
            return {
                ...state,
                scenarioRunComplete: false,
                scenarioRunHasFailed: true,
                scenarioIsRunning: false,
            };
        }

        case ScenariosActions.ActionTypes.RESET_SCENARIO_RUN_HAS_FAILED: {
            return {
                ...state,
                scenarioRunHasFailed: false,
            };
        }

        /* Scenario Save */
        case ScenariosActions.ActionTypes.SAVE_SCENARIO: {
            return {
                ...state,
                scenarioIsSaving: true,
                scenarioSaveComplete: false,
                scenarioSaveHasFailed: false
            }
        }
        case ScenariosActions.ActionTypes.SAVE_SCENARIO_COMPLETE: {
            return {
                ...state,
               newScenarioId:action.payload,
               scenarioIsSaving: false,
               scenarioSaveComplete: true,
               scenarioSaveHasFailed: false
            }
        }
        case ScenariosActions.ActionTypes.SAVE_SCENARIO_FAILED: {
            return {
                ...state,
               scenarioIsSaving: false,
               scenarioSaveComplete: false,
               scenarioSaveHasFailed: true
            }
        }

        case ScenariosActions.ActionTypes.RESET_SCENARIO_SAVE_HAS_FAILED: {
            return {
                ...state,
                scenarioSaveHasFailed: false,
            };
        }

        case ScenariosActions.ActionTypes.SET_SCENARIOS_FILTER: {
            return {
                ...state,
                scenariosFilter: (<ServerParams>action.payload)
            }
        }

    default:
        return state;
  }
}

//Stubbed
export function injectStubbedData(scenarios: Scenario[]) {

  scenarios.forEach((scenario) => {
    scenario.statusNew = randomBoolean();
    scenario.statusPublished = randomBoolean();
    scenario.statusAccepted = randomBoolean();
    scenario.statusRejected = randomBoolean();
    scenario.productGroupSummary = [{
        scenarioName: '',
        name: 'Construction',
        status: '',
        merchDecision: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }],
        current: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }],
        recommended: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }]
      },
      {
        scenarioName: '',
        status: '',
        name: 'Boys Toys',
        merchDecision: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }],
        current: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }],
        recommended: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }]
      },{
        scenarioName: '',
        status: '',
        name: 'Construction',
        merchDecision: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }],
        current: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }],
        recommended: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }]
      },
      {
        scenarioName: '',
        status: '',
        name: 'Boys Toys',
        merchDecision: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }],
        current: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }],
        recommended: [{
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 35,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        },
        {
          acceptedPercentage: 95,
          expectedStockLevelBeforePriceChange: 17000,
          markdownCostEstimate: 623,
          markdownMarginAverage: 51,
          markdownMarginOverall: 14,
          markdownWeek: 36,
          profitEstimate: 245,
          rejectedPercentage: 3,
          revisedPercentage: 5,
          salesInMarkdownPeriodEstimate: 656,
          terminalStockEstimateCost: 7435,
          terminalStockEstimateCount: 345,
          tpnBeforemMarkdown: 2,
          tpnInMardown: 50,
          unitsSoldInMarkdownPeriodEstimate: 234
        }]
      }]
  });

  scenarios = populateChildWithParentProps(scenarios);

  return scenarios;
}

export function randomBoolean() {
  return Math.random() >= 0.5
}

// Work around filter limitation
export function populateChildWithParentProps(scenarios: Scenario[]) {

  scenarios.forEach((scenario) => {
    scenario.productGroupSummary.forEach((productGroupSummary) => {
      productGroupSummary.scenarioName = scenario.scenarioName;
      productGroupSummary.status = scenario.status
    });
  });

  return scenarios;
}
