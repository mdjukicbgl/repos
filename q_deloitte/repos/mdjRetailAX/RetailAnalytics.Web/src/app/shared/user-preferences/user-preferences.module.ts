import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UserPreferencesService } from './services/user-preferences.service';
import { UserPreferencesModel } from './models/user-preferences.model';
import { UserPreferencesReducer } from './reducers/user-preferences.reducer';

@NgModule({
    providers: [
        UserPreferencesService,
        UserPreferencesModel
    ]
})
export class UserPreferencesModule {}