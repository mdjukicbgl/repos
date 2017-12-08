import { Component, OnInit, Input } from '@angular/core';
import { GridUtils } from '../../../../utils/grid-utils';

@Component({
  selector: 'app-freeze-tab',
  templateUrl: './freeze-tab.component.html',
})
export class FreezeTabComponent {

  @Input() componentParent;
  @Input() column;

  constructor( private gridUtils: GridUtils ) {
    this.gridUtils = gridUtils;
  }

  onFreeze(direction: string) {
    this.gridUtils.freeze(this.componentParent.gridOptions, this.column, direction ? false : true);
  }

}
