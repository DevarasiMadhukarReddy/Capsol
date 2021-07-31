import {
    LightningElement,
    api,
    track
} from 'lwc';
import collectForgivableProposal from '@salesforce/apex/LoanApplicationController.collectForgivableProposal';
import collectRecordDetail from '@salesforce/apex/LoanApplicationController.collectRecordDetail';
import createNote from '@salesforce/apex/LoanApplicationController.createNote';
import saveOffer from '@salesforce/apex/LoanApplicationController.saveOffer';
//Bhanu Start 9-9-2020  CS-1999-
import updateProposalData from '@salesforce/apex/LoanApplicationController.updateProposalData';
import fetchRecordTypeValues from '@salesforce/apex/RecordTypeSelector.fetchRecordTypeValues';

//Ends
import {
    NavigationMixin
} from 'lightning/navigation';
export default class WcProposalPage extends NavigationMixin(LightningElement) {
    @track loading = false;
    @api recordId;
    @track activeSection = ['Repayable', 'Application_Info'];
    @track forgivable;
    @track lData;
    @api classic = false;
    @api RepayableSection='';
    //Bhanu Start 9-9-2020  CS-1999-
    @api forgivableMsg = false;
    @api forgivableMsg1 = false;
     //-Bhanu CS-2517 Start
    @api ApprovedAmntMsg = false;
     //-Bhanu CS-2517 ends
    @track disabledRepayable = true;
    @track ProposalRecordType;
    @track ShowAcceptedLoanAmount=false;
    //Ends
    getForgivableList() {
        collectForgivableProposal({
                'ParentId': this.recordId
            })
            .then(result => {
                console.log(result);
                this.forgivable = result;
                if (this.forgivable.OfferSelected) {
                    this.disabled = true;
                    this.ShowAcceptedLoanAmount=false;
                    let aq = setInterval(() => {
                        clearInterval(aq);
                        this.template.querySelector('[data-id="' + this.forgivable.OfferId + '"]').style = 'background-color:#E7F1FA';
                    }, 500);

                }else
                //CS-1999 Bhanu New changes
                    {
                   //   alert(this.forgivable.AcceptedLoanAmount1);
                       if(this.forgivable.AcceptedLoanAmount1 == 0 ){
                          this.ShowAcceptedLoanAmount = false;
                       }else if(this.forgivable.AcceptedLoanAmount1 > 0 ){
                           this.ShowAcceptedLoanAmount = true;
   
                      }
   
                   }   //Ends

            }).catch(err => {
                // alert('IIII');
                // alert(err);
            });

    }
    //Bhanu Start 9-9-2020  CS-1999
    loadProposalRecordTypes() {
        this.loading = true;
        fetchRecordTypeValues({
                'objectName': 'Proposal_Offer__c'
            })
            .then(res => {
                this.ProposalRecordType = {
                    ...res
                };
                this.loading = false;
            })
            .catch(err => {
                this.loading = false;
                alert('Unable to get Record Types, Please contact your Administrator ');
            });
    }
    //Ends

    loadData() {
        this.loading = true;
        this.loading = true;
        collectRecordDetail({
                'recId': this.recordId
            })
            .then(res => {
                console.log(JSON.stringify(res));
                this.lData = {
                    ...res
                };
                 if(this.lData.zz.loan.RecordType.Name == 'Monetization' || this.lData.zz.loan.RecordType.Name == 'Retention Loan' || this.lData.zz.loan.RecordType.Name == 'Backend TA')
                {
                    this.RepayableSection='Forgivable';
                }else  if(this.lData.zz.loan.RecordType.Name == 'Working Capital' ){
        
                    this.RepayableSection='Repayable';
                }
        
                this.loading = false;
            })
            .catch(Er => {
                // alert('Unable to loadData');
                this.loading = false;
            });

    }
    connectedCallback() {
        this.loadData();

       
        //Bhanu Start 9-9-2020  CS-1999
        this.loadProposalRecordTypes();
       //Ends
        this.getForgivableList();
        let aqz = setInterval(() => {
            clearInterval(aqz);
            this.activeSection = ['Repayable', 'Application_Info'];
            this.activeSection = ['Repayable', 'Application_Info'];

        }, 1000);

    }



    closmNoteListWindow() {
        this.showNoteList = false;
    }
    shwRNoteListWindow(event) {
        let zz = event.target.id.split('-')[1];

        this.Nlist = this.forgivable.NoteList;
        if (this.Nlist.length > 0) {
            this.showNoteList = true;
        }

    }

    shwNoteListWindow(event) {
        let zz = event.target.id.split('-')[1];
        Object.keys(this.Offers).forEach(element => {
            if (this.Offers[element].OfferId == zz) {
                this.Nlist = this.Offers[element].NoteList;
            }
        });
        if (this.Nlist.length > 0) {
            this.showNoteList = true;
        }

    }
    handleChange(event) {
        console.log('+event.target.value'+event.target.value);
               // madhu added handlechange event this.AdditionalComments= event.target.value;
                this.note= event.target.value;
            }
    closeNoteWindow1() {
        this.showNote = false;
    }
    closeNoteWindow() {
        
         //Madhu added CS-3154 and CS-3348 The characters included are alpha-numeric, full stops, commas, and space
        // var regex = new RegExp('^(?!.*(?:__|\\.\\.\\.))[^\\\\" ]+$');
        var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
         var key3 = this.note;
        // alert('key3'+key3);
    let searchAddtionalCom1 = this.template.querySelector(".Addnote"); 
   if( key3 != null && key3 != '' && !regex.test(key3)){ 
            searchAddtionalCom1.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");  
            searchAddtionalCom1.reportValidity(); 
        }
   else {
       
      searchAddtionalCom1.setCustomValidity("");   
      searchAddtionalCom1.reportValidity();
        if (this.template.querySelector('[data-id="note"]').value != '') {
            createNote({
                    'Body': this.template.querySelector('[data-id="note"]').value,
                    'ParentId': this.selectedNote
                }).then(res => {
                    //alert(res);
                    //this.getOffersList();closeNoteWindow
                    this.getForgivableList();
                })
                .catch(err => {
                    //alert(err);
                });
        }
        this.showNote = false;
    }
    }
    showNoteWindow(event) {
        this.selectedNote = event.target.id.split('-')[1];
        this.showNote = true;
    }
    showNoteWindowforgivable(event) {
        this.selectedNote = event.target.id.split('-')[1];
        this.showNote = true;
        //alert(this.selectedNote);
    }

    closeWindow() {
        this.showConfirm = false;
         this.forgivableMsg1 = false;
         this.ShowAcceptedLoanAmount =false;
          //-Bhanu CS-2517 Start
         this.ApprovedAmntMsg = false;
          //-Bhanu CS-2517 ends
         this.disabledRepayable = false;
    }


    onselectOfferForgivable() {

    }



    confirmWindow() {

        if (this.forgivable != null) {
            if (this.forgivable.OfferId == this.selectedOffer) {
                this.forgivable['OfferSelected'] = true;
            }
        }



//Bhanu Start 9-9-2020 CS-1999
        if (this.forgivable != null) {
            if (this.forgivable.OfferId == this.selectedOffer) {
                
                let OfferData = [];
                let AcceptedLoanAmountElement=  this.template.querySelector('[data-id="AcceptedLoanAmount"]');
                if(AcceptedLoanAmountElement == null && this.ShowAcceptedLoanAmount==false)
                {
                    this.disabledRepayable = false;
                    this.forgivableMsg = true;
                    return;
                }


                let AcceptedLoanAmount=0;
                if(this.ShowAcceptedLoanAmount==false){
                 AcceptedLoanAmount = this.template.querySelector('[data-id="AcceptedLoanAmount"]').value;
               if (AcceptedLoanAmount == undefined || AcceptedLoanAmount == null || AcceptedLoanAmount == '' || AcceptedLoanAmount == '0') {
                    this.forgivableMsg = true;
                    return;
                } else {
                    this.forgivableMsg = false;
                }
            }  
             else{
                AcceptedLoanAmount=this.forgivable.AcceptedLoanAmount1;
            }
 //-Bhanu CS-2517 Start

            
            let ApprovedLoanAmount = 0; 
            if (this.forgivable.LoanAmount !=0)
            {
                ApprovedLoanAmount= this.template.querySelector('[data-id="ApprovedLoanAmount"]').value;
            }
            
           
            if(AcceptedLoanAmount > ApprovedLoanAmount)
            {
                this.ApprovedAmntMsg = true;
                return;
            }
 //-Bhanu CS-2517 Ends
                this.forgivable['OfferSelected'] = true;
                this.disabledRepayable = true;
                this.ShowAcceptedLoanAmount = false;
               
                let ProposalGeneralRecordTypeId = '';
                for (var RecordTypekey in this.ProposalRecordType) {
                    if (this.ProposalRecordType.hasOwnProperty(RecordTypekey)) {
                        var RecordTypeName = this.ProposalRecordType[RecordTypekey];
                        if (RecordTypeName == 'General Proposal') {
                            ProposalGeneralRecordTypeId = RecordTypekey;

                        }
                    }

                }
                this.forgivable.AcceptedLoanAmount1=this.forgivable.AcceptedLoanAmount;
                let offData1 = {
                    'Id': this.forgivable.OfferId,
                    'TA_Amount__c': (AcceptedLoanAmount == undefined || AcceptedLoanAmount == null || AcceptedLoanAmount == '') ? null : parseFloat(AcceptedLoanAmount),
                    'RecordTypeId': ProposalGeneralRecordTypeId

                }

                OfferData.push(offData1);


                if (OfferData.length > 0) {
                    updateProposalData({
                            'PropData': JSON.stringify(OfferData)
                        })
                        .then(res => {
                            if (res) {} else {
                                alert('Unable to save Proposal please check with Administrator');
                            }

                        })
                        .catch(err => {
                            alert('Unable to save Proposal please check with Administrator');
                        })
                }




            }
        }

//Ends
        saveOffer({
                'recId': this.selectedOffer,
                'loanId': this.recordId
            }).then(res => {
                // alert(res);
                // this.getOffersList();
                this.getForgivableList();
            })
            .catch(err => {
                // alert(err);
            });
        this.showConfirm = false;
    }
    recordlink() {
        //alert(this.classic);
        if (this.classic) {
            window.location.reload();
        } else {
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
    onselectOffer(event) {
         //-Bhanu CS-2517 Start
        this.ApprovedAmntMsg = false;
         //-Bhanu CS-2517 ends
        this.selectedOffer = event.target.id.split('-')[1];
        //Bhanu Start 9-9-2020  CS-1999
        this.forgivableMsg = false;
        //ends
if(this.ShowAcceptedLoanAmount==true)
{  if (this.forgivable.AcceptedLoanAmount1 != undefined && this.forgivable.AcceptedLoanAmount1 != null && this.forgivable.AcceptedLoanAmount1 != '' || this.forgivable.AcceptedLoanAmount1 != '0')
    {        
      this.forgivableMsg1 = true;
    }    
       }
        this.showConfirm = true;
    }
    @track selectedOffer;
    @track disabled = false;
    @track showConfirm = false;
    @track showNote = false;
    @track selectedNote;
    @track showNoteList = false;
    @track Nlist = [];

}