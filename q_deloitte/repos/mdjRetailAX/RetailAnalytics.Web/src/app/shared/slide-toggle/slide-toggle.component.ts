import { Component, Input, ElementRef, OnInit, Output, EventEmitter, ChangeDetectionStrategy } from '@angular/core';

@Component({
  selector: 'app-slide-toggle',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './slide-toggle.component.html',
  styleUrls: [ './slide-toggle.component.scss' ]
})
export class SlideToggleComponent implements OnInit {
  @Input() value: boolean = false;
  @Input() state: string = 'default'
  @Output() valueChange = new EventEmitter<boolean>();

  colorClass: string;

  ngOnInit() {
    this.setColor();
  }

  ngOnChanges() {
    this.setColor();
  }

  onToggle() {
    this.value = !this.value;
    this.valueChange.emit(this.value);
  }

  private setColor() {
    switch(this.state) {
      case 'REJECTED':
        this.value = false;
        this.colorClass = 'rejected'
        break;
      case 'ACCEPTED':
        this.value = true;
        this.colorClass = 'accepted'
        break;
      case 'REVISED':
        this.value = true;
        this.colorClass = 'revised'
        break;
      default:
        this.value = false;
        this.colorClass = 'default'
    }
  }
}
