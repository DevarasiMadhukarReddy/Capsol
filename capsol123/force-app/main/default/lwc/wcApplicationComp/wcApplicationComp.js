import { LightningElement,api } from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';
export default class WcApplicationComp extends NavigationMixin(LightningElement) {
    @api eamon=false;
    @api recordId;
    //used to reload from link
    @api classic=false;
    @api applicationInfo={
        "ApplicationNo":'',
        "ApplicationLink":'',
        "Status":'',
        "LoanPurpose":'',
        "LoanType":'',
        "Type":'',
        "RecordType":null,
        "RecordTypeName":''
    };
    loadApplication(){
        if(this.classic){
            window.location.reload();
        }else{
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
}