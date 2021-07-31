/*
 *
 * Modified by Amol - CS - 1812 - Defect: Retention Loan application functions - 8 / 20 / 2020 - Ch01
 * 
 */


import {
    LightningElement,
    api,
    track
} from 'lwc';

export default class EaWizard extends LightningElement {
    @api recordId;
    @api classic;
    @api casedetail;

    @track wizard = true;
    @track RetentionWizard = false;
    @track MonetizationWizard = false;
    @track NNAWizard = false;

    //Start Ch01
    loanRetention_Type() {
        this.wizard = false;
        this.RetentionWizard = true;
    }
    //End Ch02
    loanMonetization_Type() {
        this.wizard = false;
        this.MonetizationWizard = true;
    }
    loanNNA_Type() {
        /* this.wizard=false;
         this.NNAWizard=true;*/
    }
    CloseQA() {
        /*const payload = {
            source: "QuickAction",
            messageBody: 'KillAction'
        }; 
        publish(this.context, LoanSampleMessage, payload);*/
        //window.location.reload();
        this.dispatchEvent(new CustomEvent('closeqa'));
    }

    parentClick() {
        this.wizard = true;
        this.RetentionWizard = false;
        this.MonetizationWizard = false;
        this.NNAWizard = false;

    }
}