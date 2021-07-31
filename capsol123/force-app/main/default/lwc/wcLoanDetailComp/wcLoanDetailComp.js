import { LightningElement,track,api,wire } from 'lwc';
import { registerListener,unregisterAllListeners,fireEvent } from 'c/auraPubSub';
import{CurrentPageReference} from 'lightning/navigation';

export default class WcLoanDetailComp extends LightningElement {
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
        
        this.template.querySelector('[data-id="wcDetailPage"]').refreshData();
        
    }
    saveRecord(){
        this.template.querySelector('[data-id="wcDetailPage"]').saveData();
    }
    confirmoOnSave(){
        this.editRecord=false; 
        //alert('CCC');
        this.template.querySelector('[data-id="wcDetailPage"]').refreshData();
        if(!this.classic){
            fireEvent(this.pageRef,'CancelApplication','CancelClick');
            }else{
                this.template.querySelector('[data-id="classicbutton"]').CancelRecord();
            }
        //fireEvent(this.pageRef,'CancelApplication','CancelClick'); 
    }
    cancelRecord(){
        this.editRecord=false; 
        this.template.querySelector('[data-id="wcDetailPage"]').refreshData();
        if(!this.classic){
            fireEvent(this.pageRef,'CancelApplication','CancelClick');
            }else{
                this.template.querySelector('[data-id="classicbutton"]').CancelRecord();
            }
        //fireEvent(this.pageRef,'CancelApplication','CancelClick');
    }
    handleProposal(){
        this.recordDetails=false;
    }

    
  
}