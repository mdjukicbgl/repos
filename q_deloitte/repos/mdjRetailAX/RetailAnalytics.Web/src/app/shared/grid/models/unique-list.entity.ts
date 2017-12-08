export class UniqueList {

    constructor(colId, list) {
        this.colId = colId;
        this.list = list;
    }

    colId: string;
    list: Array<String>;
}