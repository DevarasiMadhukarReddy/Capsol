import {
    LightningElement,
    track,
    api
} from 'lwc';
import ProposalCSS from '@salesforce/resourceUrl/ProposalCSS';
import {
    loadStyle
} from 'lightning/platformResourceLoader';

export default class WcBusinessDetailComp extends LightningElement {
    @api quickAction = false;
    @api wcRecord = false;
    @api editRecord = false;
    @api showHeader = false;
    get legalEntityValues() {
        return [{
                label: 'Individual',
                value: 'Individual'
            },
            // CS- 2536 Modified by Amol - 11/05/2020 Start
            {
                label: 'Business – Hybrid RIA/Bank',
                value: 'Business – Hybrid RIA/Bank'
            }
            /*,
                        {
                            label: 'Sole Proprietorship',
                            value: 'Sole Proprietorship'
                        },
                        {
                            label: 'Partnership',
                            value: 'Partnership'
                        },
                        {
                            label: 'Corporation',
                            value: 'Corporation'
                        },
                        {
                            label: 'Limited Liability Company',
                            value: 'Limited Liability Company'
                        }*/
            // CS- 2536 Modified by Amol - 11/05/2020 End
        ];
    }

    get currentRegistrationValues() {
        return [
            // { label: 'IRA Only', value: 'IRA Only' },
            // { label: 'Broker/Dealer', value: 'Broker/Dealer' },
            // { label: 'Hybrid IRA/Dual-Registered', value: 'Hybrid IRA/Dual-Registered' }
            //CS-2522 Modified by Amol 11_09_2020 Start
            {
                label: 'Independent',
                value: 'Independent'
            }, {
                label: 'Wirehouse/Regional',
                value: 'Wirehouse/Regional'
            }, {
                label: 'Bank Advisor',
                value: 'Bank Advisor'
            }, {
                label: 'Institutional',
                value: 'Institutional'
            }, {
                label: 'Insurance',
                value: 'Insurance'
            }, {
                label: 'Termed Advisor',
                value: 'Termed Advisor'
            }
            /*{
                label: 'Broker dealer',
                value: 'Broker dealer'
            },
            {
                label: 'RIA',
                value: 'RIA'
            },
            {
                label: 'Dual Registered',
                value: 'Dual Registered'
            }*/
            //CS - 2522 Modified by Amol 11 _09_2020 End
        ];
    }

    BusinessNameChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'BussinessName': event.target.value
            }
        }));
    }
    checkNumberlength(event) {
        if (event.target.value.length > 18) {
            event.preventDefault();
        }
    }
    AdvisorChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'AdvisorNo': event.target.value
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
    RegistrationChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'Registration': event.target.value
            }
        }));
    }
    CustodianChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'Custodian': event.target.value
            }
        }));
    }
    handlelookupdata(event) {
        //alert(JSON.stringify(event.detail));
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'ParentLoan': event.detail
            }
        }));
    }

    @api businessData = {
        'ParentLoan': null,
        'BussinessName': '',
        'AdvisorNo': '',
        'Entity': '',
        'Registration': '',
        'Custodian': ''
    };
    connectedCallback() {
        if (this.quickAction) {
            Promise.all([
                loadStyle(this, ProposalCSS)
            ]).then(() => {
                //alert('Files loaded.');
            }).catch(error => {
                // alert("Error " + error.body.message);
            });
        }
    }

}