import { LightningElement,api } from 'lwc';

export default class TestWC extends LightningElement {
    @api recordId;
    @api classic;
}