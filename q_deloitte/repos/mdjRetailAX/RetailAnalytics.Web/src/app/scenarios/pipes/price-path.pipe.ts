import { Pipe, PipeTransform } from '@angular/core';

@Pipe({name: 'pricePath'})
export class PricePathPipe implements PipeTransform {
    transform(value: string, osp: number, csp: number): number[] {
        let depths = value.split(';');
        return depths.map(x => {
            if (+x > 0) {
                return Math.round((csp * (1 - (+x))) * 100) / 100;
            } else {
                return csp;
            }
        });
    }
}
