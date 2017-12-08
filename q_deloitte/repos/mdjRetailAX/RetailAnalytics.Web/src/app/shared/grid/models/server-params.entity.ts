export interface ServerParams {
  sorts: Array<ServerSort>;
  filters: Array<ServerFilter>;
  paging: ServerPaging;
}

export interface ServerSort {
  dir: SortOperator;
  prop: string;
}

export interface ServerPaging {
  pageIndex: number;
  pageLimit: number;
}

export interface ServerFilter {
  prop: string;
  operator: FilterOperator;
  value: string;
}

export enum FilterOperator {
  equals             = <any>'eq',
  notEqual           = <any>'neq',
  lessThan           = <any>'lt',
  lessThanOrEqual    = <any>'le',
  greaterThan        = <any>'gt',
  greaterThanOrEqual = <any>'ge',
  inRange            = <any>'in',
  startsWith         = <any>'sw',
  endsWith           = <any>'ew',
  contains           = <any>'inc',
  notContains        = <any>'ninc',
  before             = <any>'lt',
  after              = <any>'gt',
  sameOrBefore       = <any>'le',
  sameOrAfter        = <any>'ge',
}

export enum SortOperator {
  asc         = <any>'asc',
  desc        = <any>'desc',
}
