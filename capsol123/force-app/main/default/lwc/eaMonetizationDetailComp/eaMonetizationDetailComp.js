import { LightningElement,track,api,wire } from 'lwc';
import{CurrentPageReference} from 'lightning/navigation';
import { registerListener,unregisterAllListeners,fireEvent } from 'c/auraPubSub';
export default class EaMonetizationDetailComp extends LightningElement {
    @track recordDetails=true;
    @api recordId;
    @api classic;
    @track editRecord=false;
    @wire(CurrentPageReference) pageRef;
    connectedCallback(){
        if(!this.classic){
        registerListener('ProposeOffer' ,this.handleProposal, this);
        registerListener('EditApplication' ,this.editRecordData, this);
        registerListener('SaveLoanApplication' ,this.saveRecord, this);
        registerListener('CancelLoanApplication' ,this.cancelRecord, this);
        registerListener('ProposalCancelLoanApplication' ,this.cancelProposalRecord, this);
        registerListener('ProposalSaveLoanApplication' ,this.saveProposalRecord, this);
        registerListener('ProposalEditLoanApplication' ,this.editProposalRecord, this);
        registerListener('DetailLoanApplication' ,this.confirmoOnSave, this);
        }
    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    editRecordData(){
        this.editRecord=true;
        
        this.template.querySelector('[data-id="eaMonetizationDetailPage"]').refreshData();
        
    }
    saveRecord(){
        this.template.querySelector('[data-id="eaMonetizationDetailPage"]').saveData();
    }
    confirmoOnSave(){
        this.editRecord=false; 
        //alert('CCC');
        this.template.querySelector('[data-id="eaMonetizationDetailPage"]').refreshData();
        if(!this.classic){
            fireEvent(this.pageRef,'CancelApplication','CancelClick');
            }else{
                this.template.querySelector('[data-id="classicbutton"]').CancelRecord();
            }
    }
    cancelRecord(){
        this.editRecord=false; 
        this.template.querySelector('[data-id="eaMonetizationDetailPage"]').refreshData();
        if(!this.classic){
        fireEvent(this.pageRef,'CancelApplication','CancelClick');
        }else{
            this.template.querySelector('[data-id="classicbutton"]').CancelRecord();
        }
    }
    handleProposal(){
        this.recordDetails=false;
    }
 }