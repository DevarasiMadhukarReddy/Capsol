/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable no-alert */
import { LightningElement,api,track,wire } from 'lwc';

import createProposalfromScenarioAura from '@salesforce/apex/cls_LPL_SubmitLoanApplication.createProposalfromScenarioAura';
import congratsImage from '@salesforce/resourceUrl/congratsImage';
import{CurrentPageReference} from 'lightning/navigation';
import { registerListener,unregisterAllListeners } from 'c/auraPubSub';
export default class submitButtonCmp extends LightningElement {
    @track dataId;
    @api recordId;
    @track EditRecord=false;
    @track submitButtonClick=false;
    @track submitSuccess = false;
    @track congratsImageurl;
    @track showError = false;
    @wire(CurrentPageReference) pageRef;
    connectedCallback() {
        registerListener('SubmitApplication' ,this.submitButtonClicked, this);
    }
   
    submitButtonClicked(recId){  
        this.submitButtonClick = true;
        this.recordId = recId;
        this.congratsImageurl = congratsImage;
            console.log(this.recordId);
           console.log(this.submitButtonClick);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    closeModal() {
        window.location.reload();
        this.submitButtonClick = false;
        this.submitSuccess = false;
        this.showError = false;
        window.location.reload();
    } 
    submitLoanApplication() {
        console.log('recid'+this.recordId);
        this.submitSuccess = true;
        createProposalfromScenarioAura({'recordId':this.recordId}).then((result)=>{
        }).catch((error)=>{
            this.showError = true;
        }); 
    }
}