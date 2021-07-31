import {
    LightningElement,
    track
} from 'lwc';

export default class LWCModalBoxDemo extends LightningElement {
    @track openmodel = false;
    openmodal() {
        this.openmodel = true
    }
    closeModal() {
        this.openmodel = false
    }
    saveMethod() {
        // eslint-disable-next-line no-alert
        //alert('save method invoked');
        this.closeModal();
    }
}