import { Component, OnInit, Input } from '@angular/core';
import { GridUtils } from '../../../../utils/grid-utils';

@Component({
  selector: 'app-showhide-tab',
  templateUrl: './showhide-tab.component.html',
})
export class ShowHideTabComponent implements OnInit {

  @Input() componentParent;
  public showHideColumns = [];

  constructor( private gridUtils: GridUtils ) {
    this.gridUtils = gridUtils;
  }

  ngOnInit() {
    this.getShowHideColumns();
  }

  getShowHideColumns() {
    this.showHideColumns = this.gridUtils.getColumnsForShowHide(this.componentParent.gridOptions);
  }

  toggleColumnVisibility(column, show) {
    this.gridUtils.setColumnVisible(this.componentParent.gridOptions, column.colId, show);
    this.gridUtils.sizeColumnsToFit(this.componentParent.gridOptions);
  }

}
