import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { BehaviorSubject, Observable, Subject } from 'rxjs/Rx';
import { ProfileDropdownComponent } from '../profile-dropdown/profile-dropdown.component';
import { HeaderComponent } from './header.component';
import { RouterTestingModule } from '@angular/router/testing';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';
import { Auth } from '../../auth/auth.service';
import { UserPreferencesModule } from '../../user-preferences/user-preferences.module';
import { UserPreferencesModel } from '../../user-preferences/models/user-preferences.model';
import { UserPreferencesService } from '../../user-preferences/services/user-preferences.service';

class MockUserPreferencesService {
  getLastScenarioId = () => {};
};

describe('HeaderComponent', () => {
  let component: HeaderComponent;
  let fixture: ComponentFixture<HeaderComponent>;

  let AuthStub = {
    logout() {},
    getName() {
      return 'David';
    }
  }  

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HeaderComponent, ProfileDropdownComponent ],
      providers:    [ {provide: Auth, useValue: AuthStub } ],
      imports: [
        RouterTestingModule,
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        UserPreferencesModule
      ]
    })
    .overrideComponent(HeaderComponent, {
      set: {
        providers: [
          { provide: UserPreferencesService, useClass: MockUserPreferencesService }
        ]
      }
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HeaderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

