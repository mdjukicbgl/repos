import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { SubNavLinkComponent } from './subnav-link.component';

describe('SubNavLinkComponent', () => {
  let component: SubNavLinkComponent;
  let fixture: ComponentFixture<SubNavLinkComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SubNavLinkComponent ],
      imports: [ RouterTestingModule ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SubNavLinkComponent);
    component = fixture.componentInstance;
    component.title = 'title';
    component.link = '/';
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
