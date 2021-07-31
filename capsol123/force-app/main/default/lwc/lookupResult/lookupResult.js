import {
    LightningElement,
    track,
    api
} from 'lwc';

export default class LookupResult extends LightningElement {
    @api acc;
    @track accFlag;
    @api record;
    @api
    onClickRecord() {
        return this.record;
    }

}