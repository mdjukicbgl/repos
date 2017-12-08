import { TestBed, inject } from '@angular/core/testing';
import { ActionReducer, Action } from '@ngrx/store';
import * as RecommendationsActions from '../actions/recommendations.actions';

import { RecommendationsState, RecommendationsReducer, initialState } from './recommendations.reducer';