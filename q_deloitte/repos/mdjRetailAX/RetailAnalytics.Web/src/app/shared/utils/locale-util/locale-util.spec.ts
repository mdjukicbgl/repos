import { LocaleUtil } from './locale-util';

describe('Locale Utils', function() {

  let localeUtil;
  let translateService: any = {
    currentLang: 'bg-BG'
  };

  beforeEach(function() {
    localeUtil = new LocaleUtil(translateService);
  });

  it('should get the current locale from the translation service', function() {
    let locale = localeUtil.getCurrentLocale();
    expect( locale ).toEqual('bg-BG');
  });

  it('should default to en if no locale found', function() {
    translateService.currentLang = undefined;
    let locale = localeUtil.getCurrentLocale();
    expect( locale ).toEqual('en-GB');
  });

});
