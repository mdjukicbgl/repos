import { SimpleChange } from '@angular/core/core';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-error-group',
  templateUrl: './error-group.component.html',
  styleUrls: ['./error-group.component.scss']
})
export class ErrorGroupComponent {

  @Input() errors: Array<string>;

}
