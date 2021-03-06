import { LightningElement,api,track } from 'lwc';
import getResults from '@salesforce/apex/lwcCustomLookupController.getResults';

export default class LwcCustomLookup extends LightningElement {
    @api objectname = 'Account';
    @api fieldname = 'Name';
    @api selectRecordId = '';
    @api selectRecordName;
    @api Label;
    @api searchRecords = [];
    @api required = false;
    @api LoadingText = false;
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track messageFlag = false;
    @track iconFlag =  true;
    @track clearIconFlag = false;
    @track inputReadOnly = false;
    
    @api
    getRecordId(){
        return this.selectRecordId;
    }

    searchField(event) {
        var currentText = event.target.value;
        this.LoadingText = true;
        
        getResults({ ObjectName: this.objectname, fieldName: this.fieldName, value: currentText  })
        .then(result => {
            this.searchRecords= result;
            this.LoadingText = false;
            
            this.txtclassname =  result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            if(currentText.length > 0 && result.length === 0) {
                this.messageFlag = true;
            }
            else {
                this.messageFlag = false;
            }

            if(this.selectRecordId != null && this.selectRecordId.length > 0) {
                this.iconFlag = false;
                this.clearIconFlag = true;
            }
            else {
                this.iconFlag = true;
                this.clearIconFlag = false;
            }
        })
        .catch(error => {
        });
        
    }
    
   setSelectedRecord(event) {
        var currentText = event.currentTarget.dataset.id;
        var selectName;
        this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.iconFlag = false;
        this.clearIconFlag = true;
        this.selectRecordName = event.currentTarget.dataset.name;
        selectName = event.currentTarget.dataset.name;
        this.selectRecordId = currentText;
        this.inputReadOnly = true;
        const selectedEvent = new CustomEvent('selected', { detail: {selectName}});
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
    @api
    setData(Name,Id){
        this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.iconFlag = false;
        this.clearIconFlag = true;
        this.selectRecordName =Name ;
        let selectName =Name;
        this.selectRecordId = Id;
        this.inputReadOnly = true;
        const selectedEvent = new CustomEvent('selected', { detail: {selectName}});
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    
    }
    
    resetData() {
        this.selectRecordName = "";
        this.selectRecordId = "";
        this.inputReadOnly = false;
        this.iconFlag = true;
        this.clearIconFlag = false;
       
    }

}