import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { UserPreferencesService } from '../../user-preferences/services/user-preferences.service';

@Component({
    selector: 'app-header',
    templateUrl: './header.component.html',
    styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {

    _router: Router;
    constructor(private router: Router,
                private userPreferences: UserPreferencesService) {
      this._router = router;
    }

    ngOnInit() {
    }
    
    getLastScenarioId() {
        return this.userPreferences.getLastScenarioId();
    }
}
