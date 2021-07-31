/*

*    CH.No   Description                                                                 Developer  Date
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
    *
    CH - 02  CS - 2953 Enhancement - Update Forgivable Application and related record 
             as read - only when offer accepted
                                                                                         Amol      03 / 26 / 2021 *
    

*/

import {
    LightningElement,
    track,
    api,
    wire
} from 'lwc';
import collectData from '@salesforce/apex/EALoanApplicationController.collectData';
import {
    CurrentPageReference
} from 'lightning/navigation';
import {
    registerListener,
    unregisterAllListeners,
    fireEvent
} from 'c/auraPubSub';
import LoanCSS from '@salesforce/resourceUrl/LoanCSS';
import ProposalCSS from '@salesforce/resourceUrl/ProposalCSS';
import {
    loadStyle
} from 'lightning/platformResourceLoader';
import Tibco_Service_URL from '@salesforce/label/c.Tibco_Service_URL';
export default class EaRetentionDetailComp extends LightningElement {
    @track recordDetails = true;
    @api recordId;
    @api classic;
    @api hideshowspinnerEA; //CS-3696
    @track editRecord = false;
    //CH - 02 Start
    @track editAddlnComments = false;
    @track DataRetention = {
        'BusinessInfo': {
            'BussinessName': '',
            'Entity': '',
            'Advisor': ''
        },
        FinancialData: {
            'LoanAmount': 0,
            'IntrestRate': 0,
            'LoanTerm': '',
            'FundingDate': ''
        },
        BorrowerInfo: [],
        AdditionalComments: '',
        ContactId: null,
        'AdditionalContacts': {
            "AssignedRecruiter": null,
            "AssignedRecruiterLink": null,
            "InternalRecruiter": null,
            "InternalRecruiterLink": null,
            "BusinessDevelopment": null,
            "BusinessDevelopmentLink": null,
            "PreparerName": '',
            "ServicerName": ''
        },
        'ApplicationInfo': {
            "ApplicationNo": '',
            "ApplicationLink": '',
            "Status": '',
            "LoanPurpose": '',
            "LoanType": '',
            "Type": '',
            "RecordType": null,
            "RecordTypeName": ''
        },
        'SystemInfo': {
            "CreatedBy": null,
            "CreatedByLink": '',
            "CreatedDate": null,
            "LastModifiedBy": null,
            "LastModifiedByLink": '',
            "LastModifiedDate": null,
            "CLOApplicationId": null,
            "CLOCustomerGroup": null

        },
        'RecordId': null

    };
    //CH - 02 End
    @wire(CurrentPageReference) pageRef;
    connectedCallback() {
        // CH - 02 Start
        Promise.all([loadStyle(this, LoanCSS)]).then(() => {});
        let load = setInterval(() => {
            clearInterval(load);
            this.collectLoanData();
        }, 1000);
        Promise.all([
            loadStyle(this, ProposalCSS)
        ]).then(() => {
            //alert('Files loaded.');
        }).catch(error => {
            // alert("Error " + error.body.message);
        });
        // CH - 02 End
        if (!this.classic) {
            registerListener('ProposeOffer', this.handleProposal, this);
            registerListener('EditApplication', this.editRecordData, this);
            registerListener('SaveLoanApplication', this.saveRecord, this);
            registerListener('CancelLoanApplication', this.cancelRecord, this);
            registerListener('ProposalCancelLoanApplication', this.cancelProposalRecord, this);
            registerListener('ProposalSaveLoanApplication', this.saveProposalRecord, this);
            registerListener('ProposalEditLoanApplication', this.editProposalRecord, this);
            registerListener('DetailLoanApplication', this.confirmoOnSave, this);

        } else {
            //CS-3696 Fix spinner on click of saving for TA in classic

            // this.template.addEventListener('stopSpinner1', this.stopSpinner1);
        }
    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    //CS-3696 Fix spinner on click of saving for TA in classic

    @api stopSpinner1() {

        this.template.querySelector('[data-id="classicbutton"]').stopSpinner();

    }
    //CS-3696 Fix spinner on click of saving for TA in classic ends

    //CH - 02 Start
    collectLoanData() {
        collectData({
                recId: this.recordId
            })
            .then(suc => {
                console.log(JSON.stringify(suc));
                this.DataRetention = suc;
            })
            .catch(er => {
                console.log(er);

                //alert('Unable to Load Record Details Please check with your Administrator');
                // this.loading = false;
            });
    }
    configureBorrower() {
        let Arr = [];
        let count = 0;
        this.DataRetention.BorrowerInfo.forEach(Element => {
            if (count == 0) {
                Element.avail = false;
            } else {
                Element.avail = true;
            }
            count++;
            Arr.push(Element);
        });
        this.DataRetention.BorrowerInfo = Arr;
    }
    //CH - 02 End

    editRecordData() {
        //CH - 02 Start

        if (this.DataRetention.ApplicationInfo.Status == 'Documentation' || this.DataRetention.ApplicationInfo.Status == 'Boarding & Funding' ||
            this.DataRetention.ApplicationInfo.Status == 'Information Requested' || this.DataRetention.ApplicationInfo.Status == 'Information Submitted' ||
            this.DataRetention.ApplicationInfo.Status == 'NIGO' || this.DataRetention.ApplicationInfo.Status == 'Funded') {
            this.editRecord = false;
        } else {
            this.editRecord = true;
        }
        this.editAddlnComments = true;
        //CH - 02 End

        this.template.querySelector('[data-id="eaRetentionDetailPage"]').refreshData();

    }
    saveRecord() {
        this.template.querySelector('[data-id="eaRetentionDetailPage"]').saveData();
        //fireEvent(this.pageRef,'CancelApplication','CancelClick');
    }
    //CS-3696 - Amol - 05/18/2021 - Start
    @api hidespinnerinClassicEA() {
        console.log('inhere');
        this.template.querySelector('[data-id="classicbutton"]').hidethespinnerClassic();
    }

    @api showspinnerinClassicEA() {
        this.template.querySelector('[data-id="classicbutton"]').showthespinnerClassic();
    }

    handleHideSpinner(event) {
        console.log(event.detail);
        this.hideshowspinnerEA = event.detail;
    }
    //CS-3696 - Amol - 05/18/2021 - End
    confirmoOnSave() {
        this.editRecord = false;
        this.editAddlnComments = false; //CH - 02
        //alert('CCC');
        this.template.querySelector('[data-id="eaRetentionDetailPage"]').refreshData();
        if (!this.classic) {
            fireEvent(this.pageRef, 'CancelApplication', 'CancelClick');
        } else {
            this.template.querySelector('[data-id="classicbutton"]').CancelRecord();
        }
    }
    cancelRecord() {
        this.editRecord = false;
        this.editAddlnComments = false; //CH - 02
        this.template.querySelector('[data-id="eaRetentionDetailPage"]').refreshData();
        if (!this.classic) {
            fireEvent(this.pageRef, 'CancelApplication', 'CancelClick');
        } else {
            this.template.querySelector('[data-id="classicbutton"]').CancelRecord();
        }
    }
    handleProposal() {
        this.recordDetails = false;
    }
}