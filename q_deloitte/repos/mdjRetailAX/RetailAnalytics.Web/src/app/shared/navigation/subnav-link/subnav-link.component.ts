import { Component, OnInit, Input, ElementRef, Renderer } from '@angular/core';
import { LinkItemType } from './models/link-item.entity';

@Component({
  selector: 'app-subnav-link',
  templateUrl: './subnav-link.component.html',
  styleUrls: ['./subnav-link.component.scss'],
  host: {'class': 'nav-item sub-nav__item'}
})
export class SubNavLinkComponent implements OnInit {

  @Input() title: string;
  @Input() link: string;
  @Input() isFirstRight: boolean;
  @Input() icon: boolean;

  hasLink: boolean;
  hasIcon: boolean;

  constructor(public elementRef: ElementRef, private renderer: Renderer) {
  }

  ngOnInit() {
    this.hasLink = this.link !== undefined ? true : false;
    this.hasIcon = this.icon !== undefined ? true : false;
    this.renderer.setElementClass(this.elementRef.nativeElement, 'ml-auto', this.isFirstRight);
  }

}
