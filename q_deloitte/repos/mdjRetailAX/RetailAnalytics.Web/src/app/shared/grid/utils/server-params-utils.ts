import { Injectable } from '@angular/core';
import { FilterOperator, ServerFilter, ServerParams, ServerSort, ServerPaging } from '../models/server-params.entity';

@Injectable()
export class ServerParamsUtils {

  static getQuery(serverParams: ServerParams) {
    let url = '';
    if (serverParams) {
      url += '?';
      url += this._appendPaging(serverParams.paging);
      url += this._appendSorts(serverParams.sorts);
      url += this._appendFilters(serverParams.filters);
    }
    return url.slice(0, -1);
  }

  static _appendPaging(paging: ServerPaging) {
    let url = '';
    if ( paging ) {
      if ( paging.pageIndex || paging.pageIndex === 0) {
          url += 'pageIndex=' + paging.pageIndex + '&';
      }
      if ( paging.pageLimit ) {
          url += 'pageLimit=' + paging.pageLimit + '&';
      }
    }
    return url;
  }

  static _appendSorts(sorts: Array<ServerSort>) {
    let url = '';
    if ( sorts ) {
      sorts.forEach((sort) => {
        url += 'sort=' + sort.prop + ':' + sort.dir + '&';
      });
    }
    return url;
  }

  static _appendFilters(filters: Array<ServerFilter>) {
    let url = '';
    if ( filters ) {
      filters.forEach((filter) => {
        url += filter.prop + '=' + filter.operator + ':' + filter.value + '&';
      });
    }
    return url;
  }

}

export default ServerParamsUtils;
