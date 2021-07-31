/* eslint-disable vars-on-top */
/* eslint-disable no-unused-expressions */
/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
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

    //@api borrowerDataMaster = [];
    @api count = 2;
    
    @api borrowerData;

    @api rowsBrow;
    @track showDelete;

    @api recordId;
    @track RecordtypeBol=false;
    @api show=false;    
    @api formData={};
    @api display=false;
    @track aumAttributableVal=0;
    @track primaryConValue = false;
    @api displayFinan=false;
    @track TotMFC=0;
    @api myArrayBRO= [
        { label: '', value: '', index: 1 ,showBrow:false}];
    @api row;
    @api showBrow=false;
    @track value = '';
   // @api showBrow=false;
    @api myArrayBrow= [
        { conId: null, conName: null, pAUM: 0, AUMATT: 0, primary: false, Uname: 'Bow1',currentFirmName:null,currentFirmType:null}];
   /* get rowsBrow() {
        return this.myArrayBrow;
    }*/

    @api rowBrowRow;
    @api showBrowRow;
    @track valueBrowRow = '';

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
    console.log(event.currentTarget.dataset.id);
        var currentText = event.currentTarget.dataset.id;
        var selectName;
        this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.iconFlag = false;
        this.clearIconFlag = true;
        this.selectRecordName = event.currentTarget.dataset.name;
        selectName = event.currentTarget.dataset.name;
        this.selectRecordId = currentText;
        this.inputReadOnly = true;
        //this.borrowerData.BorrowerName = event.currentTarget.dataset.id;
      // this.borrowers += event.currentTarget.dataset.id;
       console.log('recordId'+this.borrowerData);
       const selectedEvent = new CustomEvent('handleborrowerdata', { detail: this.borrowerData.rowCount +{...{'BorrowerName':this.selectRecordName}}});
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

@api 
handleClickBrow(event) {
   /* console.log(event.currentTarget.dataset.id);
    var arrLength = this.myArrayBrow.length +1;
    var currentArray = this.myArrayBrow;
    //Arr.push({ ContactId: null, Contact: null, pAUM: 0, AUMATT: 0, primary: false, Uname: 'Bow' + this.count });
    var newRow = [{ ContactId: null, Contact: null, pAUM: 0, AUMATT: 0, primary: false, Uname: 'Bow' + this.count}];
    currentArray.push(newRow[0]);
    this.myArrayBrow = currentArray;
    console.log(arrLength);
    this.count++;
   // this.formData.borrowers += this.selectRecordId;
    this.dispatchEvent(new CustomEvent('handleborrowerdata', { detail: this.currentArray }));*/

    let Arr = [];
    Arr = this.myArrayBrow;
    // Arr=Arr.concat(this.bowArr);
    /*this.myArrayBrow.forEach(Element => {
        let temp = Object.assign({}, Element);
        Arr.push(temp);
    });*/

    Arr.push({ conId: null, conName: null, pAUM: 0, AUMATT: 0, primary: false, Uname: 'Bow' + this.count ,currentFirmName:null,currentFirmType:null});

    this.count++;
    console.log(this.count);
    if(this.count >= 2 ){
        this.showDelete = true;
    }else{
        this.showDelete = false;
    }
    this.myArrayBrow = Arr;
    console.log(JSON.stringify(this.myArrayBrow));
    this.dispatchEvent(new CustomEvent('handleborrowerdata', { detail: this.myArrayBrow }));
   // console.log('recordId'+this.formData.borrowers);*/
}

@api
handleDeleteBrow(event) {
   /* console.log(event.detail);
    const textVal = event.detail;
    var currentArray = this.myArrayBrow;
    var i;
    if (textVal > -1) {
        currentArray.splice(textVal-1, 1);
    }
    for (i = 0; i < currentArray.length;) {
        currentArray[i].index = ++i;
      }
    this.myArrayBrow = currentArray;

    this.dispatchEvent(new CustomEvent('handleborrowerdata', { detail: this.currentArray }));*/

    let ARR = [];
    this.myArrayBrow.forEach(Element => {
        if (event.target.id.split('-')[0] !== Element.Uname) {
            ARR.push(Element);
        }
    });
    this.myArrayBrow = ARR;
    this.dispatchEvent(new CustomEvent('handleborrowerdata', { detail: this.myArrayBrow }));
}

get options() {
    return [
        { label: 'Primary Contact', value: 'option1' }
    ];
}

@api
handleprimaryChange(event) {
   /* console.log(event.currentTarget.dataset.id);
    //event.preventDefault();
   // this.borrowers.primaryContact = true;
    this.primaryConValue = true;
    //console.log(this.borrowers.primaryContact);
    console.log(this.primaryConValue);

    this.dispatchEvent(new CustomEvent('handleborrowerdata',{detail:this.borrowerData.rowCount+{...{'PrimaryContact':event.target.value}}}));
    //const a = 1;

   /* const selectEvent = new CustomEvent('radioselect', {
        //detail: this.rowBrowRow.index
        detail: this.row.index
    });
    this.dispatchEvent(selectEvent);*/

    let ARR = [];
    let Arr = []
    Arr = Arr.concat(this.myArrayBrow);
    Arr.forEach(Element => {
        let temp = Object.assign({}, Element);
        if (event.target.id.split('-')[0] === temp.Uname) {
            temp.primary = true;
        } else {
            temp.primary = false;
        }
        ARR.push(temp);
    });
    this.myArrayBrow = ARR;
    this.dispatchEvent(new CustomEvent('handleborrowerdata', { detail: this.myArrayBrow }));
}

@api
handleSplitOfAUM(event){
    //console.log(event.currentTarget.dataset.id);
    
    /*this.borrowerData.SplitofTotalAUM = {...event.target.value};
    this.borrowerData.AUMAttributable = {...parseFloat((this.borrowerData.TotalAUM*this.borrowerData.SplitofTotalAUM)/100)};
    console.log(this.borrowerData.AUMAttributable);
    //this.formData.splitOfSumAUM = this.splitOfSumAUM;
    //this.borrowers.splitOfSumAUM = this.splitOfSumAUM;
    //console.log(this.borrowers.splitOfSumAUM);
   // this.formData.aumAttributable = this.aumAttributableVal;

    this.dispatchEvent(new CustomEvent('handleborrowerdata', { detail: this.borrowerData.rowCount +{...{'SplitofTotalAUM':event.target.value}}}));
    //this.borrowers.aumAttributable = this.aumAttributableVal;
    //console.log(this.borrowers.aumAttributable);*/


    let ARR = [];
    let Arr = []
    Arr = Arr.concat(this.myArrayBrow);
    Arr.forEach(Element => {

        let temp = Object.assign({}, Element);
        if (event.target.id.split('-')[0] === temp.Uname) {
            temp.pAUM = event.target.value == null ? 0 : (event.target.value == '' ? 0 : parseFloat(event.target.value));
            

        }
        ARR.push(temp);
    });
    this.myArrayBrow = ARR;
    this.dispatchEvent(new CustomEvent('handleborrowerdata', { detail: this.myArrayBrow }));
}

    @api
    handlelookupdata(event) {

        let ARR = [];
        let Arr = []
        Arr = Arr.concat(this.myArrayBrow);
        Arr.forEach(Element => {

            let temp = Object.assign({}, Element);

            if (event.target.id.split('-')[0] === temp.Uname) {

                if (event.detail != null) {
                    temp.Contact = event.detail;
                    temp.ContactId = event.detail.Id;
                } else {
                    temp.Contact = null;
                    temp.ContactId = null;
                }



            }
            ARR.push(temp);
        });
        this.myArrayBrow = ARR;
        this.dispatchEvent(new CustomEvent('handleborrowerdata', { detail: this.myArrayBrow }));

    }

}