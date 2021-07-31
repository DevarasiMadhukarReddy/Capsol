import {
    LightningElement,
    track,
    wire,
    api
} from 'lwc';
import collectWCDetails from '@salesforce/apex/wcLoanApplicationController.collectWCDetails';
import {
    loadStyle
} from 'lightning/platformResourceLoader';
import collectRecordName from '@salesforce/apex/LoanApplicationController.collectRecordName';
import LoanCSS from '@salesforce/resourceUrl/LoanCSS';
//import congratsImage from '@salesforce/resourceUrl/congratsImage';
import congratsImage from '@salesforce/resourceUrl/Congrats';
import checkExceptionLog from '@salesforce/apex/LoanSubmitApplication.checkExceptionLog';
import {
    CurrentPageReference
} from 'lightning/navigation';
import {
    registerListener,
    unregisterAllListeners,
    fireEvent
} from 'c/auraPubSub';
//Commented by madhukar reddy this method not used import createProposalfromScenarioAura from '@salesforce/apex/cls_LPL_SubmitLoanApplication.createProposalfromScenarioAura';
import createProposalFromAura from '@salesforce/apex/LoanSubmitApplication.createProposalFromAura';
import withdrawApplication from '@salesforce/apex/LoanSubmitApplication.withdrawApplication'; // Added by Amol - 11/19/2020 -  Withdraw Application fix.
import checkLoanappliction from '@salesforce/apex/wcLoanApplicationController.checkLoanappliction';
import {
    NavigationMixin
} from 'lightning/navigation';
export default class WcLoanButtonComp extends NavigationMixin(LightningElement) {
    @api recordId;
    @wire(CurrentPageReference) pageRef;
    @track EditRecord = false;
    @track RecordData;
    @track congratsImageurl;
    @track showProposal = false;
    @track isWithdraw = false; //CS-1813 Amol
    @track submitButtonClick = false;
    @track submitSuccess = false;
    @track congratsImageurl;
    @track showError = false;
    @track SubmitRecord = false;
    @track hidebutton = true;
    @track showDPError = false;
    @track showMuleError = false;
    @track submitError = false;

    @track loading = false; // Show Spinner on Confirm Submission
    @track errData = [];

    @wire(collectRecordName, {
        recId: '$recordId'
    }) Record({
        data,
        err
    }) {
        if (data) {
            // alert(JSON.stringify(data));
            if (data.CLO_Application_ID__c != null) // Madhukar Reddy is added on 11/24/2020 when loan application status is Submitted then Hide the Loan application button
                this.SubmitRecord = true;
            this.Recordname = data.Name;
            if (data.Proposals_Offers__r != null) {
                if (data.Proposals_Offers__r.length > 0) {
                    this.showProposal = true;
                }

            }

        } else if (err) {
            //alert(err);
        }
    }
    connectedCallback() {
        Promise.all([loadStyle(this, LoanCSS)]).then(() => {});
        let tt = setInterval(() => {
            clearInterval(tt);
            this.loadData();
        }, 2000);
        registerListener('CancelApplication', this.CancelRecord, this);

    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    loadData() {
        // alert(this.recordId);
        collectWCDetails({
            'recId': this.recordId
        }).then(suc => {
            // alert(suc);
            this.RecordData = suc;
            console.log('this.record' + this.RecordData.Status__c);
        }).catch(er => {
            alert('Unable to load data,please contact your Administrator!');
        });
    }

    reloadRecord() {
        window.location.reload();
    }

    onClickCancelButton() {
        fireEvent(this.pageRef, 'CancelLoanApplication', 'CancelClick');
    }
    onClickSaveButton() {

        fireEvent(this.pageRef, 'SaveLoanApplication', 'SaveClick');
    }
    onEditRecord() {
        
        this.EditRecord = true;
        fireEvent(this.pageRef, 'EditApplication', 'EditClick');
        // alert('HELLOO!!');
    }

    onClickSubmitButton() {
        this.errData = [];
        //alert(this.recordId);
        //fireEvent(this.pageRef,'SubmitApplication','SubmitClick');
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
    onClickProposalButton() {
        fireEvent(this.pageRef, 'ProposeOffer', 'ProposalClick');
        this.hidebutton = false;
    }

    onDeleteRecord() {

    }
    onCloneRecord() {

    }
    CancelRecord() {
        this.EditRecord = false;
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
    closeModal() {
        this.submitButtonClick = false;
        this.submitSuccess = false;
        this.isWithdraw = false; //CS-1813 Amol
        this.showError = false;
        this.showMuleError = false;
        this.showDPError = false;
        if (this.SubmitRecord) {
            //window.location.reload();
            let nav = {
                type: "standard__recordPage",
                attributes: {
                    recordId: this.recordId,
                    objectApiName: "Loan_Application__c",
                    actionName: "view"
                }
            };
            this[NavigationMixin.Navigate](nav);
        }
    }
    submitLoanApplication() {
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


}