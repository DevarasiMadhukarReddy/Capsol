/* eslint-disable no-unused-vars */
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable no-alert */

import {
    LightningElement,
    api,
    wire,
    track
} from 'lwc';
import {
    loadStyle
} from 'lightning/platformResourceLoader';
import LoanCSS from '@salesforce/resourceUrl/LoanCSS';
import collectRecordName from '@salesforce/apex/LoanApplicationController.collectRecordName';
import {
    CurrentPageReference
} from 'lightning/navigation';
import createProposalfromScenarioAura from '@salesforce/apex/cls_LPL_SubmitLoanApplication.createProposalfromScenarioAura';
import createProposalFromAura from '@salesforce/apex/LoanSubmitApplication.createProposalFromAura';

import congratsImage from '@salesforce/resourceUrl/congratsImage';
import {
    registerListener,
    unregisterAllListeners,
    fireEvent
} from 'c/auraPubSub';
import checkLoanappliction from '@salesforce/apex/wcLoanApplicationController.checkLoanappliction';
export default class SubmitLoanApplication extends LightningElement {
    @api recordId;
    @track submitButtonClick = false;
    @track dataId;
    @track EditRecord = false;
    @track bEditRecord = false;
    @track submitSuccess = false;
    @track congratsImageurl;
    @track showError = false;
    @track EditRecord = false;
    @track SubmitRecord = false;
    @track showProposal = false;
    @track Recordname;
    @track hidebutton = true;

    @track isLoading = false;
    @track showDPError = false;
    @track showMuleError = false;

    @track ProposalEdit = false;


    @track submitError = false;

    @track errData = [];

    onClickProposalCancelButton() {
        fireEvent(this.pageRef, 'ProposalCancelLoanApplication', 'CancelProposalClick');

        this.ProposalEdit = false
    }
    onClickProposalSaveButton() {
        fireEvent(this.pageRef, 'ProposalSaveLoanApplication', 'SaveProposalClick');

        //this.ProposalEdit=false
    }
    pCancelRecord() {
        this.ProposalEdit = false;
    }

    recordlink() {
        window.location.reload();
    }

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        Promise.all([loadStyle(this, LoanCSS)]).then(() => {});
        registerListener('SubmitApplication', this.submitButtonClicked, this);
        registerListener('CancelApplication', this.CancelRecord, this);
        registerListener('pCancelApplication', this.pCancelRecord, this);


    }
    @wire(collectRecordName, {
        recId: '$recordId'
    }) Record({
        data,
        err
    }) {
        if (data) {
            this.Recordname = data.Name;
            if (data.Proposals_Offers__r != null) {
                if (data.Proposals_Offers__r.length > 0) {
                    this.showProposal = true;
                }

            }

        } else if (err) {
            // alert(err);
        }
    }

    onEditProposalRecord() {
        this.hidebutton = false;
        this.ProposalEdit = false
        this.ProposalEdit = true;
        fireEvent(this.pageRef, 'ProposalEditLoanApplication', 'EditProposalClick');

    }
    onClickSaveButton() {
        fireEvent(this.pageRef, 'SaveLoanApplication', 'SaveClick');
    }
    onClickCancelButton() {
        fireEvent(this.pageRef, 'CancelLoanApplication', 'CancelClick');
    }

    onClickProposalButton() {
        fireEvent(this.pageRef, 'ProposeOffer', 'ProposalClick');
        this.hidebutton = false;
    }
    onClickSubmitButton() {
        this.errData = [];
        // alert(this.recordId);
        //fireEvent(this.pageRef,'SubmitApplication','SubmitClick');
        //alert('zzzz');
        checkLoanappliction({
                'recId': this.recordId
            })
            .then(suc => {

                if (suc.length == 0) {
                    this.submitButtonClick = true;
                    this.congratsImageurl = congratsImage;
                } else {

                    this.submitError = false;
                    this.showError = true;
                    this.errData = suc;

                    //alert('Please review following fields  '+suc.join('\n'));
                }

            }).catch(err => {
                alert('Please check with Administrator');
            });
    }
    onEditRecord() {
        this.EditRecord = true;
        this.bEditRecord = true;
        fireEvent(this.pageRef, 'EditApplication', 'EditClick');
    }
    CancelRecord() {
        this.EditRecord = false;
        this.bEditRecord = false;
    }



    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    closeModal() {
        this.submitButtonClick = false
        this.submitSuccess = false
        this.showError = false;
        this.showMuleError = false;
        this.showDPError = false;
        if (this.SubmitRecord) {
            window.location.reload();
        }
    }
    submitLoanApplication() {
        this.isLoading = true;
        createProposalFromAura({
            'loanAppId': this.recordId
        }).then((result) => {
            // createProposalfromScenarioAura({'loanAppId':this.recordId}).then((result)=>{
            // alert(result);
            let delay = setInterval(() => {
                clearInterval(delay);
                console.log(result);
                if (result == '') {
                    this.isLoading = false;
                    this.submitSuccess = true;
                    this.SubmitRecord = true;

                } else if (result == 'DataPower') {
                    this.isLoading = false;
                    this.showDPError = true;
                    this.submitButtonClick = false;

                } else if (result = 'MuleSoft') {
                    this.isLoading = false;
                    this.showMuleError = true;
                    this.submitButtonClick = false;
                }
            }, 5000);

        }).catch((error) => {
            this.isLoading = false;
            this.showError = true;
            this.submitError = true;
        });
    }
}