import { Component, OnInit } from '@angular/core';

import { TranslateService } from "@ngx-translate/core";
import { Auth } from '../../auth/auth.service';

@Component({
  selector: 'app-profile-dropdown',
  templateUrl: './profile-dropdown.component.html',
  styleUrls: ['./profile-dropdown.component.scss']
})
export class ProfileDropdownComponent implements OnInit {

  public userName = 'Unknown';
  public translate: TranslateService;

  constructor( private auth: Auth, translate: TranslateService ) {
    this.translate = translate;
  }

  ngOnInit() {

  }

  changeLanguage(lang) {
    this.translate.use(lang);
  }

  logout() {
    this.auth.logout();
  }

  getUsername() {
    return this.auth.getName();
  }

}
