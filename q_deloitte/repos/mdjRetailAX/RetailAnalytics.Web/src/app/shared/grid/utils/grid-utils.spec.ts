import { ServerFilter, ServerSort } from '../models/server-params.entity';
import { GridOptions } from 'ag-grid/main';
import { GridUtils } from './grid-utils';

let gridOptions;
let gridUtils;

describe('Grid Utils', function() {

  beforeEach(function() {
    gridOptions = {
      api: {
        showLoadingOverlay: () => {},
        showNoRowsOverlay: () => {},
        hideOverlay: () => {},
        sizeColumnsToFit: () => {},
        setFilterModel: () => {},
        setSortModel: () => {},
        purgeInfiniteCache: () => {},
      },
      columnApi: {
        setColumnVisible: () => {},
        setColumnPinned: () => {},
        getAllGridColumns: () => {
          return [
            {
              colId: 'column1',
              pinned: 'left',
            },
            {
              colId: 'column2',
              pinned: 'left',
            },
            {
              colId: 'column3',
              pinned: 'left',
            },
            {
              colId: 'column4',
              pinned: undefined,
            },
            {
              colId: 'column5',
              pinned: undefined,
            },
          ];
        }
      }
    };
    gridUtils = new GridUtils();
  });

  it('should call purge infinite cache', function() {
    spyOn(gridOptions.api, 'purgeInfiniteCache');
    gridUtils.purgeInfiniteCache(gridOptions);
    expect(gridOptions.api.purgeInfiniteCache).toHaveBeenCalled();
  });

  it('should show loading overlay', function() {
    spyOn(gridOptions.api, 'showLoadingOverlay');
    gridUtils.showLoadingOverlay(gridOptions);
    expect(gridOptions.api.showLoadingOverlay).toHaveBeenCalled();
  });

  it('should show no rows overlay', function() {
    spyOn(gridOptions.api, 'showNoRowsOverlay');
    gridUtils.showNoRowsOverlay(gridOptions);
    expect(gridOptions.api.showNoRowsOverlay).toHaveBeenCalled();
  });

  it('should hide overlay', function() {
    spyOn(gridOptions.api, 'hideOverlay');
    gridUtils.hideOverlay(gridOptions);
    expect(gridOptions.api.hideOverlay).toHaveBeenCalled();
  });

  it('should size Columns To Fit', function() {
    spyOn(gridOptions.api, 'sizeColumnsToFit');
    gridUtils.sizeColumnsToFit(gridOptions);
    expect(gridOptions.api.sizeColumnsToFit).toHaveBeenCalled();
  });

  it('should clear Grid Filters', function() {
    spyOn(gridOptions.api, 'setFilterModel');
    spyOn(gridOptions.api, 'setSortModel');
    gridUtils.clearGridFilters(gridOptions);
    expect(gridOptions.api.setFilterModel).toHaveBeenCalled();
    expect(gridOptions.api.setSortModel).toHaveBeenCalled();
  });

  it('should get paging and return a params object', function() {

    // Input
    let sorts = [];
    let filters = {};
    let paging = {
      pageIndex: 0,
      pageLimit: 100
    };

    // Output
    let expectedResult = {
      sorts: [],
      filters: [],
      paging: {
        pageIndex: 0,
        pageLimit: 100
      }
    };

    let result = gridUtils.getGridFilters(sorts, filters, paging);
    expect(result).toEqual(expectedResult);
  });

  it('should parse sorts and return a ServerSort array', function() {
    let sorts = [{
      colId: 'scenarioId',
      sort: 'asc'
    }];
    var result = gridUtils._getSorts(sorts);
    expect(result).toEqual([ Object({ prop: 'scenarioId', dir: 'asc' }) ]);
    sorts = [{
      colId: 'price1',
      sort: 'desc'
    }];
    var result = gridUtils._getSorts(sorts);
    expect(result).toEqual([ Object({ prop: 'price1', dir: 'desc' }) ]);
  });

  it('should parse sorts and return an empty ServerSort array if no sorts', function() {
    let sorts = [];
    let result = gridUtils._getSorts(sorts);
    expect(result).toEqual([ ]);
  });

  it('should parse filters and return a ServerFilter array', function() {

    let filters = {
      status: ['new'],
      scenarioName: {
        filter: 'textToFind',
        filterType: 'text',
        type: 'contains'
      },
      productCount: {
        filter: '20',
        filterType: 'number',
        type: 'lessThan'
      },
      price2: {
        filter: '20',
        filterTo: '30',
        filterType: 'number',
        type: 'inRange'
      }
    };
    let result = gridUtils._getFilters(filters);
    expect(result).toEqual(
      [
        Object({ prop: 'status', operator: 'in', value: 'new' }),
        Object({ prop: 'scenarioName', operator: 'inc', value: 'textToFind' }),
        Object({ prop: 'productCount', operator: 'lt', value: '20' }),
        Object({ prop: 'price2', operator: 'ge', value: '20' }),
        Object({ prop: 'price2', operator: 'le', value: '30' })
      ]
    );
  });

  it('should parse filters and return a empty ServerFilter array if no filters', function() {
    let filters = {};
    let result = gridUtils._getFilters(filters);
    expect(result).toEqual([]);
  });

  it('should parse sort and filters and return a ServerParams object', function() {
    let sorts = [{
      colId: 'scenarioId',
      sort: 'asc'
    }];
    let filters = {
      status: ['new'],
      scenarioName: {
        filter: 'textToFind',
        filterType: 'text',
        type: 'contains'
      },
      productCount: {
        filter: '20',
        filterType: 'number',
        type: 'lessThan'
      },
      price2: {
        filter: '20',
        filterTo: '30',
        filterType: 'number',
        type: 'inRange'
      }
    };
    let paging = {
      pageIndex: 1,
      pageLimit: 100
    };
    let result = gridUtils.getGridFilters(sorts, filters, paging);
    expect(result).toEqual({
      sorts: [
        Object({ prop: 'scenarioId', dir: 'asc' })
      ],
      filters: [
        Object({ prop: 'status', operator: 'in', value: 'new' }),
        Object({ prop: 'scenarioName', operator: 'inc', value: 'textToFind' }),
        Object({ prop: 'productCount', operator: 'lt', value: '20' }),
        Object({ prop: 'price2', operator: 'ge', value: '20' }),
        Object({ prop: 'price2', operator: 'le', value: '30' }) ],
      paging: {
        pageIndex: 1,
        pageLimit: 100
      }
    });
  });

  it('should freeze all columns to the left of the column asking for the freeze left including itself', function() {
    spyOn(gridOptions.columnApi, 'setColumnPinned');
    gridUtils.freeze(gridOptions, {colId: 'column5'}, false);
    expect(gridOptions.columnApi.setColumnPinned.calls.allArgs()).toEqual(
      [
        [ 'column1', 'left' ],
        [ 'column2', 'left' ],
        [ 'column3', 'left' ],
        [ 'column4', 'left' ],
        [ 'column5', 'left' ],
        [ 'column5', 'left' ]// Double call
      ]
    );
  });

  it('should unfreeze all columns to the right of the column asking for the freeze left', function() {
    spyOn(gridOptions.columnApi, 'setColumnPinned');
    gridUtils.freeze(gridOptions, {colId: 'column2'}, false);
    expect(gridOptions.columnApi.setColumnPinned.calls.allArgs()).toEqual(
    [
      [ 'column1', 'left' ],
      [ 'column2', 'left' ],
      [ 'column2', 'left' ], // Double call
      [ 'column3', null ]
    ]);
  });

  it('should unfreeze all columns to the right of the column asking for the unfreeze including itself', function() {
    spyOn(gridOptions.columnApi, 'setColumnPinned');
    gridUtils.freeze(gridOptions, {colId: 'column2'}, true);
    expect(gridOptions.columnApi.setColumnPinned.calls.allArgs()).toEqual(
    [
      [ 'column1', 'left' ],
      [ 'column2', 'left' ],
      [ 'column2', null ],
      [ 'column3', null ]
    ]);
  });

  it('should setColumnVisible if all params passed in', function() {
    spyOn(gridOptions.columnApi, 'setColumnVisible');
    gridUtils.setColumnVisible(gridOptions, 'id123', true);
    expect(gridOptions.columnApi.setColumnVisible).toHaveBeenCalledWith('id123', true);
  });

  it('should not call setColumnVisible if params missing', function() {
    spyOn(gridOptions.columnApi, 'setColumnVisible');
    gridUtils.setColumnVisible(null, 'id123', true);
    gridUtils.setColumnVisible(gridOptions, null, true);
    expect(gridOptions.columnApi.setColumnVisible).not.toHaveBeenCalled();
  });

  it('should get available columns for show/hide', function() {
    spyOn(gridOptions.columnApi, 'getAllGridColumns').and.returnValue(
      [
        {columnId: 'column1', colDef: {suppressShowHide: true}},
        {columnId: 'column2', colDef: {suppressShowHide: null}},
        {columnId: 'column3', colDef: {}}
      ]
    );
    let results = gridUtils.getColumnsForShowHide(gridOptions);
    expect(results).toEqual([{columnId: 'column3', colDef: {}}]);
  });

});
