import { LightningElement,api,track,wire } from 'lwc';
import GetLoanObjectInformtion from '@salesforce/apex/RecordTypeSelector.GetLoanObjectInformtion';
import {
    NavigationMixin
} from 'lightning/navigation';
import {
    getObjectInfo
} from 'lightning/uiObjectInfoApi';
import LOAN_APPLICATION_OBJECT from '@salesforce/schema/Loan_Application__c';
export default class EaWizard extends NavigationMixin(LightningElement) {
    @api recordId;
    @api classic;
    @api recordTypeID;
    @api loanApplicationObjectID;
    @api objectApiName;
    @api sfObjectApi = 'Loan_Application__c';
   
    @track wizard=true;
    @track RetentionWizard=false;
    @track RefinanceWizard=false;
    @track LOCWizard=false;
    @track GrowthWizard=false;
    @track AcquisitionWizard=false;

    @track objectInfo;

    @wire(getObjectInfo, { objectApiName: LOAN_APPLICATION_OBJECT}) objectInfo;
    loanRetention_Type(){
        this.wizard=false;
        this.RetentionWizard=true;
    }
    loanGrowth_Type(){
     
        const rtis = this.objectInfo.data.recordTypeInfos;
        this.recordTypeID= Object.keys(rtis).find(rti => rtis[rti].name === 'Growth Loan');
        this.recordTypeName='Growth Loan';
      
        if (window.location.href.indexOf(".lightning.force.com") > 0) {
            let nav = {
                type: "standard__objectPage",
                attributes: {
                  objectApiName: "Loan_Application__c",
                    actionName: "new",
                    name: "Home"

                },
                state : {
                    nooverride: '1',
                    recordTypeId: this.recordTypeID,
                }
            };
            this[NavigationMixin.Navigate](nav);
        } else {
           
            GetLoanObjectInformtion()
            .then(suc=>{
                this.createLoadApplication(suc);

            })
            .catch(er=>{
                console.log(er);
            });
 
        }

    }
    loanAcquisition_Type(){
        const rtis = this.objectInfo.data.recordTypeInfos;
        this.recordTypeID= Object.keys(rtis).find(rti => rtis[rti].name === 'Acquisition Loan');
         if (window.location.href.indexOf(".lightning.force.com") > 0) {
            let nav = {
                type: "standard__objectPage",
                attributes: {
                  objectApiName: "Loan_Application__c",
                    actionName: "new"
                },
                state : {
                    nooverride: '1',
                    recordTypeId: this.recordTypeID
                }
            };
            this[NavigationMixin.Navigate](nav);
        } else 
        {
                     
            GetLoanObjectInformtion()
            .then(suc=>{
                this.createLoadApplication(suc);

            })
            .catch(er=>{
                console.log(er);
            });
 
        }
    }
    loanRefinance_Type(){
       const rtis = this.objectInfo.data.recordTypeInfos;
        this.recordTypeID= Object.keys(rtis).find(rti => rtis[rti].name === 'Refinance Loan');
        if (window.location.href.indexOf(".lightning.force.com") > 0) {
            let nav = {
                type: "standard__objectPage",
                attributes: {
                  objectApiName: "Loan_Application__c",
                    actionName: "new"
                },
                state : {
                    nooverride: '1',
                   recordTypeId:  this.recordTypeID
                }
            };
            this[NavigationMixin.Navigate](nav);
        } else {
                     
            GetLoanObjectInformtion()
            .then(suc=>{
                this.createLoadApplication(suc);

            })
            .catch(er=>{
                console.log(er);
            });
 
        }
    }
    loanLOC_Type(){
        const rtis = this.objectInfo.data.recordTypeInfos;
        this.recordTypeID= Object.keys(rtis).find(rti => rtis[rti].name === 'Line of Credit');
        if (window.location.href.indexOf(".lightning.force.com") > 0) {
            let nav = {
                type: "standard__objectPage",
                attributes: {
                  objectApiName: "Loan_Application__c",
                    actionName: "new"
                },
                state : {
                    nooverride: '1',
                    recordTypeId: this.recordTypeID
                }
            };
            this[NavigationMixin.Navigate](nav);
        } else {
           
            GetLoanObjectInformtion()
            .then(suc=>{
                this.createLoadApplication(suc);

            })
            .catch(er=>{
                console.log(er);
            });
 
         
        }
    }
    parentClick() {
        this.wizard=true;
        this.RetentionWizard=false;
        this.RefinanceWizard=false;
        this.LOCWizard=false;
        this.GrowthWizard=false;
        this.AcquisitionWizard=false;
    }

    createLoadApplication(suc){
                    let oldURL = window.location.href;
                    let prefix=suc.substring(0, 3);
                    let sfObjectId=suc.slice(3);
                
                   oldURL = oldURL.replace(window.location.href.substring(window.location.href.lastIndexOf('/') + 1), "");
                   oldURL = oldURL.replace("apex/",prefix+ "/e?ent="+sfObjectId+"&RecordType=");
                        
                   oldURL=oldURL+this.recordTypeID +'&retURL=%2FaEe%2Fo';
       
                   window.location.assign(oldURL);
    }
     CloseQA() {
        /*const payload = {
            source: "QuickAction",
            messageBody: 'KillAction'
        }; 
        publish(this.context, LoanSampleMessage, payload);*/
        //window.location.reload();
        //EA2Wizard  communication to cancel record
        this.dispatchEvent(new CustomEvent('closeqa'));
    }
}