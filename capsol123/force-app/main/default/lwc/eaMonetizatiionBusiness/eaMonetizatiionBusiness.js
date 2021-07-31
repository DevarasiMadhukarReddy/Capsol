import {
    LightningElement,
    api,
    track
} from 'lwc';

export default class EaRetentionBusiness extends LightningElement {
    @api legalEntity = [];
    @api loanPurpose = [];

    @api quickAction = false;
    @api editRecord = false;
    @api showHeader = false;
    @api lastPage = false;

    @api businessData = {
        'CaseNumber': '',
        'CaseIdLink': '',
        'BussinessName': '',
        'Advisor': '',
        'Entity': ''

    };

    BusinessNameChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'BussinessName': event.target.value
            }
        }));
    }
    EntityChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'Entity': event.target.value
            }
        }));
    }
    AdvisorChange(event) {
        //alert(event.target.value);
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'Advisor': (event.target.value == undefined || event.target.value == '') ? '' : event.target.value
            }
        }));
    }
    checkNumberlength(event) {
        if (event.target.value.length > 18) {
            event.preventDefault();
        }
    }
}