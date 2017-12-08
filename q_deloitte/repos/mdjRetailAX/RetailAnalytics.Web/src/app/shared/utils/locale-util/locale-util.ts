import { Injectable } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Injectable()
export class LocaleUtil {
  constructor(private translate: TranslateService) {}

  getCurrentLocale = () => {
    if (this.translate.currentLang) {
      return this.translate.currentLang;
    }
    return 'en-GB';
  }
}
