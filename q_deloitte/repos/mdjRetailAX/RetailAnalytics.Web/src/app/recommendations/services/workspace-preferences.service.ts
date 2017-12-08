import { Injectable } from '@angular/core';
import { GridOptions } from 'ag-grid';
import { UserPreferencesService } from '../../shared/user-preferences/services/user-preferences.service';

@Injectable()
export class WorkspacePreferencesService {

    private mask: Array<String>;

    constructor(private userPreferencesService: UserPreferencesService) {

    }

    setWorkspaceGridState(gridOptions: GridOptions, mask): void {
        if (this.userPreferencesService.getScenarioGridState() && gridOptions.columnApi) {
            this.mask = mask;
            gridOptions.columnApi.setColumnState(this.setMask(this.userPreferencesService.getScenarioGridState()));
        }
        this.userPreferencesService.dataLoaded = true;
    }

    setWorkspaceSortState(params) {
        if (this.userPreferencesService.getScenarioSortModel().dir) {
            var sort = this.userPreferencesService.getScenarioSortModel();
            params.sortModel = [{ colId: sort.prop, sort: sort.dir }];
        }
    }

    private setMask(columnState) {
        let workspaceStart: string = 'discount1';
        let discount1Location = 0;
        let found: boolean = false;
        columnState.filter(element => {
            if (!found && !element.colId.startsWith(workspaceStart)) {
                discount1Location++;
            } else {
                found = true;
            }
        });
        this.mask.forEach((value: string, i: number) => {
            columnState[discount1Location + i].hide = !parseInt(value);
            columnState[discount1Location + this.mask.length + i].hide = !parseInt(value);
        })
        return columnState;
    }

    setScenarioGridState(gridState: Object) {
        this.userPreferencesService.debounceSetScenarioGridState(gridState);
    }

    setScenarioSortModel(headerName: string, sortDirection: string) {
        this.userPreferencesService.setScenarioSortModel(headerName, sortDirection);
    }

    getScenarioSortModel() {
        return this.userPreferencesService.getScenarioSortModel();
    }

    setLastScenarioId(scenarioId: number) {
        this.userPreferencesService.setLastScenarioId(scenarioId);
    }

    clearScenario(gridOptions: GridOptions) {
        this.userPreferencesService.clearScenario(gridOptions);
        gridOptions.columnApi.setColumnState(this.setMask(gridOptions.columnApi.getColumnState()));
    }

}