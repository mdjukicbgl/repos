import { Action } from '@ngrx/store';
import { type } from '../../utils/type';

export const ActionTypes = {
    REQUEST_UNIQUE_LIST: type('[SetFilter] Request Unique List'),
    REQUEST_UNIQUE_LIST_COMPLETE: type('[SetFilter] Request Unique List Complete'),
    REQUEST_UNIQUE_LIST_FAILED: type('[SetFilter] Request Unique List Failed'),
};

export class RequestUniqueList implements Action {
    type = ActionTypes.REQUEST_UNIQUE_LIST;
    
    constructor(public scenarioId: number, public colId: string) {}
}