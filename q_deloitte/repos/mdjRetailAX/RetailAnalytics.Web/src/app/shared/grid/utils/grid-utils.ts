import { Injectable } from '@angular/core';
import { GridOptions } from 'ag-grid/main';
import { FilterOperator, ServerFilter, ServerSort, SortOperator, ServerPaging } from '../models/server-params.entity';

@Injectable()
export class GridUtils {

  showLoadingOverlay(gridOptions: GridOptions) {
    if ( gridOptions && gridOptions.api ) {
      gridOptions.api.showLoadingOverlay();
    }
  }

  showNoRowsOverlay(gridOptions: GridOptions) {
    if ( gridOptions && gridOptions.api ) {
      gridOptions.api.showNoRowsOverlay();
    }
  }

  hideOverlay(gridOptions: GridOptions) {
    if ( gridOptions && gridOptions.api ) {
      gridOptions.api.hideOverlay();
    }
  }

  sizeColumnsToFit(gridOptions: GridOptions) {
    if ( gridOptions && gridOptions.api ) {
      gridOptions.api.sizeColumnsToFit();
    }
  }

  freeze(gridOptions, column, unfreeze) {
    if ( gridOptions && gridOptions.api ) {
      let found = false;
      gridOptions.columnApi.getAllGridColumns().forEach((x) => {
        if (!found) {
          gridOptions.columnApi.setColumnPinned(x.colId, 'left');
        }
        if (found && x.pinned === 'left') {
          gridOptions.columnApi.setColumnPinned(x.colId, null);
        }
        if (x.colId === column.colId) {
          found = true;
          if (unfreeze) {
            gridOptions.columnApi.setColumnPinned(x.colId, null);
          } else {
            gridOptions.columnApi.setColumnPinned(x.colId, 'left');
          }
        }
      });
    }
  }

  purgeInfiniteCache(gridOptions: GridOptions) {
    if ( gridOptions && gridOptions.api ) {
      gridOptions.api.purgeInfiniteCache();
    }
  }

  getGridFilters(sorts, filters, paging) {
    return {
      sorts: this._getSorts(sorts),
      filters: this._getFilters(filters),
      paging: {
        pageIndex: paging.pageIndex,
        pageLimit: paging.pageLimit
      }
    };
  }

  clearGridFilters(gridOptions) {
    if ( gridOptions && gridOptions.api ) {
      gridOptions.api.setFilterModel(null);
      gridOptions.api.setSortModel(null);
    }
  }

  setColumnVisible(gridOptions, colId, show) {
    if ( gridOptions && gridOptions.columnApi && colId ) {
      gridOptions.columnApi.setColumnVisible(colId, show);
    }
  }

  getColumnsForShowHide(gridOptions) {
    let columns = [];
    if ( gridOptions && gridOptions.columnApi ) {
      columns = gridOptions.columnApi.getAllGridColumns();
      columns = columns.filter(function(column){
        return column.colDef.suppressShowHide === undefined || column.colDef.suppressShowHide === false;
      });
    }
    return columns;
  }

  getHeaderSort(colID: string, sort) {
    if (sort && colID === sort.prop) {
      return sort.dir;
    }
  }

  _getSorts(columns) {
    let sorts: Array<ServerSort> = [];
    Object.keys(columns).forEach(function (prop) {
      let dir = <string>columns[prop].sort;
      sorts.push({
          prop: columns[prop].colId,
          dir: SortOperator[dir],
      });
    });
    return sorts;
  }

  _addRangeFilter(filters, column, prop) {
    filters.push({
      prop: prop,
      operator: FilterOperator.greaterThanOrEqual,
      value: column.filter
    });
    filters.push({
      prop: prop,
      operator: FilterOperator.lessThanOrEqual,
      value: column.filterTo
    });
    return filters;
  }

  _addSetFilter(filters, column, prop) {
    if (column.length > 0) {
      filters.push({
        prop: prop,
        operator: FilterOperator.inRange,
        value: column.join(',')
      });
    }
    return filters;
  }

  _addStandardFilter(filters, column, prop, operator) {
    filters.push({
      prop: prop,
      operator: FilterOperator[operator],
      value: column.filter
    });
    return filters;
  }

  _getFilters(columns) {
    let filters: Array<ServerFilter> = [];
    Object.keys(columns).forEach((prop) => {
    // 'Set' Filters come down as an array
    if ( Array.isArray(columns[prop] )) {
      filters = this._addSetFilter(filters, columns[prop], prop);
    } else {
      let operator = <string>columns[prop].type;
      if (FilterOperator[operator] === FilterOperator.inRange) {
        filters = this._addRangeFilter(filters, columns[prop], prop);
      } else {
        filters = this._addStandardFilter(filters, columns[prop], prop, operator);
      }
    }});
    return filters;
  }

}
