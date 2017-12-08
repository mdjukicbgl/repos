import { RecommendationsModel } from '../models/recommendations.model';
import { GridOptions, RowNode } from 'ag-grid/main';
import { GridUtils } from '../../shared/grid/utils/grid-utils';
import { Injectable } from '@angular/core';

@Injectable()
export class ReviseService {

    discountField = 'discount';
    weekField = 'week';
    isMarkdownField = 'isMarkdown';

    params: any;
    priceLadder: any[] = [];
    isValid = true;
    isEnabled = false;

    gridOptions: GridOptions;
    data: any;
    node: RowNode;

    constructor( private _model: RecommendationsModel ) { }

    revise(rowNode: RowNode, gridOptions: GridOptions) {
      this.node = rowNode;
      this.data = rowNode.data;
      this.gridOptions = gridOptions
      this.getSelectedPriceLadder();
      return this.validate();
    }

    validate() {

      this.isValid = true;
      this.data.errorMessage = undefined;

      this.validateOneOrMoreDiscounts();
      this.validateNotAllZeros();
      this.validateDiscountGettingDeeper();
      this.validateDeeperThanInitialDiscount();

      this.gridOptions.api.refreshCells({rowNodes: [this.node]});

      if ( this.isValid ) {
        return this.performRevise();
      }

      return false;
    }

    validateOneOrMoreDiscounts() {
      if (this.priceLadder.length === 0) {
        this.isValid = false;
        this.data.errorMessage = 'WORKSPACE.PRICE_LADDER.DISCOUNT_REQUIRED';
        return;
      }
    }

    validateNotAllZeros() {
      let allZeros = true;
      this.priceLadder.forEach(price => {
        if (price !== 0) {
          allZeros = false;
          return;
        }
      });
      if (allZeros) {
        this.isValid = false;
        this.data.errorMessage = 'WORKSPACE.PRICE_LADDER.NO_DISCOUNTS';
        return;
      }
    }

    validateDiscountGettingDeeper() {
      let gettingDeeper = true;
      let currentDiscount = 0;
      this.priceLadder.forEach(price => {
        if (price < currentDiscount) {
          gettingDeeper = false;
          return;
        }
        currentDiscount = price;
      })

      if (!gettingDeeper) {
        this.isValid = false;
        this.data.errorMessage = 'WORKSPACE.PRICE_LADDER.DISCOUNT_SAME_OR_DEEPER_THAN_PREVIOUS';
        return;
      }
    }

    validateDeeperThanInitialDiscount() {
      let deeperThanInitialDiscount = true;
      this.priceLadder.forEach(price => {
        if (price < this.data.currentMarkdownDepth) {
          deeperThanInitialDiscount = false;
          return;
        }
      })

      if (!deeperThanInitialDiscount) {
        this.isValid = false;
        this.data.errorMessage = 'WORKSPACE.PRICE_LADDER.DISCOUNT_SAME_OR_DEEPER_THAN_EXISTING';
        return;
      }
    }

    getSelectedPriceLadder() {
      let i = 1;
      this.priceLadder = [];
      while (this.data[this.discountField + i] !== undefined) {
        if (this.data[this.discountField + i] !== '' && this.data[this.isMarkdownField + i] === true) {
          this.priceLadder.push(parseFloat(this.data[this.discountField + i]))
        }
        i++;
      }
    }

    performRevise() {
      let i = 1;
      let revisions = [];
      while (this.data[this.discountField + i] !== undefined) {
        if (this.data[this.isMarkdownField + i] && this.data[this.discountField + i] !== this.data.currentMarkdownDepth) {
          revisions.push({
            week: this.data[this.weekField + i],
            discount: parseFloat(this.data[this.discountField + i])
          })
        }
        i++;
      }
      if (revisions.length > 0) {
        this._model.revise(this.data.recommendationGuid, revisions)
        return true;
      }

      return false;
    }

}
