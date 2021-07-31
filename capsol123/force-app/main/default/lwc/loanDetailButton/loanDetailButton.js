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
// Commented by madhukar reddy on 11/05/2020 createProposalfromScenarioAura method no where is used import createProposalfromScenarioAura from '@salesforce/apex/cls_LPL_SubmitLoanApplication.createProposalfromScenarioAura';
import createProposalFromAura from '@salesforce/apex/LoanSubmitApplication.createProposalFromAura';

import checkExceptionLog from '@salesforce/apex/LoanSubmitApplication.checkExceptionLog';

import withdrawApplication from '@salesforce/apex/LoanSubmitApplication.withdrawApplication';

//import congratsImage from '@salesforce/resourceUrl/congratsImage';
// Bhanu start CS-2366
import collectProposalList from '@salesforce/apex/LoanApplicationController.collectProposalList';

import congratsImage from '@salesforce/resourceUrl/Congrats';

import {
    registerListener,
    unregisterAllListeners,
    fireEvent
} from 'c/auraPubSub';
import checkLoanappliction from '@salesforce/apex/wcLoanApplicationController.checkLoanappliction';
export default class LoanDetailButton extends LightningElement {
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
    // @track ProposalEdit = false; - Commented by Amol 10/27/2020
    @api ProposalEdit = false;
    @track submitError = false;
    @track errData = [];
    @track isWithdraw = false; //CS-1813 Amol
    @track loading = false; // Show Spinner on Confirm Submission

    onClickProposalCancelButton() {
        fireEvent(this.pageRef, 'ProposalCancelLoanApplication', 'CancelProposalClick');

        this.ProposalEdit = false
    }
    onClickProposalSaveButton() {

        fireEvent(this.pageRef, 'ProposalSaveLoanApplication', 'SaveProposalClick');

        // this.ProposalEdit = false - Commented by Amol 10/27/2020
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
        registerListener('ErrorOnSaveLoanRecord', this.hidethespinner, this);


    }

    @wire(collectRecordName, {
        recId: '$recordId'
    }) Record({
        data,
        err
    }) {
        if (data) {
            this.Recordname = data.Name;
            if (data.CLO_Application_ID__c != null) // Madhukar Reddy is added on 11/24/2020 when loan application status is Submitted then Hide the Loan application button
                this.SubmitRecord = true;
            if (data.Proposals_Offers__r != null) {
                if (data.Proposals_Offers__r.length > 0) {
                    this.showProposal = true;
                }

            }

        } else if (err) {
            //alert(err);
        }
    }

    onEditProposalRecord() {
        this.hidebutton = false;
        this.ProposalEdit = false
        this.ProposalEdit = true;
        fireEvent(this.pageRef, 'ProposalEditLoanApplication', 'EditProposalClick');

    }
   /* handleChange(event) {
        console.log('+event.target.value'+event.target.value);
                this.lData.zz.BSW.BusinessLegalNameDBA= event.target.value;
            }  */
    onClickSaveButton() {
             
      
       
        this.loading = true; // show spinner on Save
        fireEvent(this.pageRef, 'SaveLoanApplication', 'SaveClick');
        

    }
    onClickCancelButton() {
        fireEvent(this.pageRef, 'CancelLoanApplication', 'CancelClick');
    }

    onClickProposalButton() {

        // Bhanu Start CS-2366
        collectProposalList({
                'ParentId': this.recordId
            })
            .then(suc => {
                if (suc) {
                     // Bhanu Start CS-2916
                    let RepayableRecordTypeCnt = 0;
                    let RepayableSelectedItmCnt = 0;
                    let TAPSelectedRecordTypeCnt = 0;
                    let TAPSelectedItmCnt = 0;
                    suc.forEach((element, index) => {
                  if (element.RecordType == 'Repayable' ) 
                        {
                            RepayableRecordTypeCnt=RepayableRecordTypeCnt + 1;
                            if (element.OfferSelected) 
                            {
                                RepayableSelectedItmCnt=RepayableSelectedItmCnt + 1;
                             }
                        }
                        if (element.RecordType == 'TA Proposal' ) 
                        {
                            TAPSelectedRecordTypeCnt=TAPSelectedRecordTypeCnt+1;
                            if (element.OfferSelected) 
                            {
                                TAPSelectedItmCnt = TAPSelectedItmCnt + 1;
                             }
                        }
                      


                       // if (element.OfferSelected) {
                           // this.template.querySelector('[data-id="Negotiate"]').style.display = "none";
                      //  }

                    });

                    if(RepayableRecordTypeCnt == 1 )
                    {
                        if(RepayableSelectedItmCnt == 1 && TAPSelectedRecordTypeCnt > 0 && TAPSelectedItmCnt > 0 ) 
                        {
                            this.template.querySelector('[data-id="Negotiate"]').style.display = "none";
                        
                        }

                    }else
                    {
                        if(TAPSelectedRecordTypeCnt > 0 && TAPSelectedItmCnt > 0 ) 
                        {
                            this.template.querySelector('[data-id="Negotiate"]').style.display = "none";
                        
                        }

                    }   // Bhanu CS-2916 Ends 

                }
            }).catch(err => {

            }); // Bhanu Ends
        fireEvent(this.pageRef, 'ProposeOffer', 'ProposalClick');
        this.hidebutton = false;
    }
    //CS-1813 Amol Start
    onClickWithdrawButton() {
        this.isWithdraw = true;
    }
    withdrawApplication() {
        this.isWithdraw = false;
        withdrawApplication({
                'loanAppId': this.recordId
            })
            .then(suc => {
                if (suc == true) {

                    window.location.reload();
                }
            }).catch(err => {

            });
    }
    //End
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
                //Commented by Amol 09/08
                //alert('Please check with Administrator');
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
        this.isWithdraw = false; //CS - 1813 Amol
        if (this.SubmitRecord) {
            window.location.reload();
        }
    }
    submitLoanApplication() {
        //this.isLoading = true;
        this.loading = true; // show spinner on confirm
        this.submitButtonClick = false;
        createProposalFromAura({
            'loanAppId': this.recordId
        }).then((result) => {
            // createProposalfromScenarioAura({'loanAppId':this.recordId}).then((result)=>{
            // alert(result);
            let delay = setInterval(() => {
                clearInterval(delay);
                console.log(result);

                checkExceptionLog({
                    'loanAppId': this.recordId
                }).then((result1) => {
                    console.log('amol' + result1);
                    if (result1 == '') {
                        console.log('amol1' + result1);
                        //this.isLoading = false;
                        this.loading = false;
                        this.submitSuccess = true;
                        this.SubmitRecord = true;

                    } else if (result1 == 'Data Power') {
                        console.log('amol2' + result1);
                        //this.isLoading = false;
                        this.loading = false;
                        this.showDPError = true;
                        this.submitButtonClick = false;

                    } else if (result1 = 'Mule Soft') {
                        console.log('amol3' + result1);
                        //this.isLoading = false;
                        this.loading = false;
                        this.showMuleError = true;
                        this.submitButtonClick = false;
                    }
                });
            }, 8000)
        }).catch((error) => {
            //this.isLoading = false;
            this.loading = false;
            this.showError = true;
            this.submitError = true;
        });
    }

    hidethespinner(){        
        this.loading = false;
    }
}