import { SimpleChange } from '@angular/core/core';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-success-group',
  templateUrl: './success-group.component.html',
  styleUrls: ['./success-group.component.scss']
})
export class SuccessGroupComponent {

  @Input() successes: Array<string>;

}
