import { RecommendationsModel } from './../models/recommendations.model';
import { ReviseService } from './revise.service';
import { TestBed, inject } from '@angular/core/testing';
import { ReflectiveInjector } from '@angular/core';

class MockRecommendationsModel {
  revise() {}
}

describe('ReviseService', () => {

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        { provide: RecommendationsModel, useClass: MockRecommendationsModel },
        ReviseService
      ]
    })
    let model = TestBed.get(RecommendationsModel);
    let service = TestBed.get(ReviseService);
    service.data = {
      currentDiscountLadderDepth: 0.5,
      discount1:0,
      discount2:0,
      discount3:0,
      discount4:0,
      discount5:0,
      discount6:0,
      discount7:0,
      discount8:0,
      price1:4.5,
      price2:4.5,
      price3:4.5,
      price4:4.5,
      price5:4.5,
      price6:4.5,
      price7:4.5,
      price8:4.5,
      isMarkdown1: true,
      isMarkdown2: true,
      isMarkdown3: true,
      isMarkdown4: true,
      isMarkdown5: true,
      isMarkdown6: true,
      isMarkdown7: true,
      isMarkdown8: true,
      hierarchyName:"FALL AND WINTER NOVELTY",
      markdownCost:0,
      priceLadderId:1,
      pricePathDiscounts:"0;0;0;0;0;0;0;0",
      pricePathPrices:"4.5000;4.5000;4.5000;4.5000;4.5000;4.5000;4.5000;4.5000",
      productId:1739194,
      productName:"W KNIT LODGE GLOVE GLV OSU RED",
      projections:[],
      recommendationGuid:"5291fe21-1fba-1c9b-f535-6189348b633f",
      revisionId:0,
      scenarioId:100,
      sellThroughTarget:26,
      status:"REJECTED",
      terminalStock:26,
      totalRevenue:0
    }
    service.node = {}

  })

  it('should be created', inject([ReviseService], (service: ReviseService) => {
    expect(service).toBeTruthy();
  }));

  it('should generate the current price ladder on revise', inject([ReviseService], (service: ReviseService) => {
    service.getSelectedPriceLadder();
    expect(service.priceLadder).toEqual([0,0,0,0,0,0,0,0]);
    service.data.discount1 = 0.1;
    service.data.discount2 = 0.2;
    service.data.discount3 = 0.3;
    service.data.discount4 = 0.4;
    service.getSelectedPriceLadder();
    expect(service.priceLadder).toEqual([0.1,0.2,0.3,0.4,0,0,0,0]);
  }));

  it('should validate one or more discounts exist and generate error messages', inject([ReviseService], (service: ReviseService) => {
    service.isValid = true;
    service.priceLadder = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8];
    service.validateOneOrMoreDiscounts();
    expect(service.isValid).toEqual(true);
    service.isValid = true;
    service.priceLadder = [];
    service.validateOneOrMoreDiscounts();
    expect(service.isValid).toEqual(false);
  }));

  it('should validate not all zeros and generate error messages', inject([ReviseService], (service: ReviseService) => {
    service.isValid = true;
    service.priceLadder = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8];
    service.validateNotAllZeros();
    expect(service.isValid).toEqual(true);
    service.isValid = true;
    service.priceLadder = [0,0,0,0,0,0,0,0];
    service.validateNotAllZeros();
    expect(service.isValid).toEqual(false);
  }));

  it('should validate discount gets deeper', inject([ReviseService], (service: ReviseService) => {
    service.isValid = true;
    service.priceLadder = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8];
    service.validateDiscountGettingDeeper();
    expect(service.isValid).toEqual(true);
    service.isValid = true;
    service.priceLadder = [0.1,0.1,0.1,0.2,0.2,0.2,0.2,0.3];
    service.validateDiscountGettingDeeper();
    expect(service.isValid).toEqual(true);
    service.isValid = true;
    service.priceLadder = [0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1];
    service.validateDiscountGettingDeeper();
    expect(service.isValid).toEqual(false);
    service.isValid = true;
    service.priceLadder = [0.1,0.2,0.3,0.2,0.4,0.5,0.6,0.7];
    service.validateDiscountGettingDeeper();
    expect(service.isValid).toEqual(false);
  }));

  it('should validate deeper than initial discount', inject([ReviseService], (service: ReviseService) => {
    service.isValid = true;
    service.data.currentMarkdownDepth = 0.5;

    service.priceLadder = [0.5,0.6,0.7,0.8,0.9];
    service.validateDeeperThanInitialDiscount();
    expect(service.isValid).toEqual(true);

    service.isValid = true;
    service.data.currentMarkdownDepth = 0.5;

    service.priceLadder = [0.4,0.5,0.6,0.7,0.8,0.9];
    service.validateDeeperThanInitialDiscount();
    expect(service.isValid).toEqual(false);
  }));

  it('should only call revise when passes validation', inject([ReviseService], (service: ReviseService) => {

    spyOn(service, 'performRevise');
    service.gridOptions = {
      api: {
        refreshCells: () => {}
      }
    } as any;
    service.isValid = true;

    service.data.currentDiscountLadderDepth = 0.5;

    service.priceLadder = [];
    service.validate();
    expect(service.performRevise).not.toHaveBeenCalled();

    service.isValid = true;
    service.priceLadder = [0,0,0,0];
    service.validate();
    expect(service.performRevise).not.toHaveBeenCalled();

    service.isValid = true;
    service.priceLadder = [0.5,0.4,0.3,0.2];
    service.validate();
    expect(service.performRevise).not.toHaveBeenCalled();

    service.isValid = true;
    service.priceLadder = [0.4,0.3,0.2];
    service.validate();
    expect(service.performRevise).not.toHaveBeenCalled();

    service.isValid = true;
    service.priceLadder = [0.5,0.6,0.7,0.8,0.9];
    service.validate();
    expect(service.performRevise).toHaveBeenCalled();

  }));

  it('should call revise with the weekly revisions', inject([ReviseService, RecommendationsModel], (service: ReviseService, model: RecommendationsModel) => {

    spyOn(model, 'revise');
    service.data.discount1 = 0.1;
    service.data.discount2 = 0.2;
    service.data.discount3 = 0.3;
    service.data.discount4 = 0.4;
    service.data.discount5 = 0.5;
    service.data.discount6 = 0.6;
    service.data.discount7 = 0.7;
    service.data.discount8 = 0.8;
    service.data.isMarkdown1 = true;
    service.data.isMarkdown2 = false;
    service.data.isMarkdown3 = true;
    service.data.isMarkdown4 = false;
    service.data.isMarkdown5 = true;
    service.data.isMarkdown6 = false;
    service.data.isMarkdown7 = true;
    service.data.isMarkdown8 = false;
    service.data.week1 = 1;
    service.data.week2 = 2;
    service.data.week3 = 3;
    service.data.week4 = 4;
    service.data.week5 = 5;
    service.data.week6 = 6;
    service.data.week7 = 7;
    service.data.week8 = 8;
    service.performRevise();
    expect(model.revise).toHaveBeenCalledWith(
        '5291fe21-1fba-1c9b-f535-6189348b633f',
        [ Object({ week: 1, discount: 0.1 }),
          Object({ week: 3, discount: 0.3 }),
          Object({ week: 5, discount: 0.5 }),
          Object({ week: 7, discount: 0.7 })] );
  }));


  it('should fetch the price ladder and validate on revise', inject([ReviseService], (service: ReviseService) => {
    spyOn(service, 'getSelectedPriceLadder');
    spyOn(service, 'validate');
    service.revise({} as any, {
      api: {
        refreshCells: () => {}
      }
    } as any);
    expect(service.getSelectedPriceLadder).toHaveBeenCalled();
    expect(service.validate).toHaveBeenCalled();
  }));


});
