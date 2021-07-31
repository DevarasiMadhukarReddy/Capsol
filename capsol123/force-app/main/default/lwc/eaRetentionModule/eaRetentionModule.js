/*
 *
 * Modified by Amol - CS - 1812 - Defect: Retention Loan application functions - 8 / 20 / 2020 - Ch01
 * 
 */

import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';
import populateDefaultinformation from '@salesforce/apex/EALoanApplicationController.populateDefaultinformation';
import checkContactStatus from '@salesforce/apex/wcLoanApplicationController.checkContactStatus';
import saveRecord from '@salesforce/apex/EALoanApplicationController.saveRecord';
import {
    NavigationMixin
} from 'lightning/navigation';
export default class EaRetentionModule extends NavigationMixin(LightningElement) {
    @api recordId;
    @api classic;

    @api casedetail; //Ch01

    @track Pageno = 0;
    @track TotalPage = 5;
    @track FirstPage = true;
    @track MidPage = false;
    @track LastPage = false;
    @track Page_Section = {
        'Page1': {
            'active': true,
            'width': '0%',
            'background': 'green',
            'displayicon': true
        },
        'Page2': {
            'active': false,
            'width': '25%',
            'background': 'green',
            'displayicon': false
        },
        'Page3': {
            'active': false,
            'width': '50%',
            'background': 'green',
            'displayicon': false
        },
        'Page4': {
            'active': false,
            'width': '75%',
            'background': 'green',
            'displayicon': false
        },
        'Page5': {
            'active': false,
            'width': '100%',
            'background': 'green',
            'displayicon': false
        }
    };
    @track ActiveCSS = "slds-path__item slds-is-current slds-is-active";
    @track CompleteCSS = "slds-path__item slds-is-complete";
    @track IncompleteCSS = "slds-path__item slds-is-incomplete";
    @track RecordType = "Retention";

    @track LoanPurpose = [];
    @track LegalEntity = [];
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    @track hideWizard = true;
    @track loading = false; // Show Spinner on Save
    //End

    @track pageCSS = {
        "P1": "slds-path__item slds-is-current slds-is-active",
        "P2": "slds-path__item slds-is-incomplete",
        "P3": "slds-path__item slds-is-incomplete",
        "P4": "slds-path__item slds-is-incomplete",
        "P5": "slds-path__item slds-is-incomplete"
    };
    @track quickAction = true;
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    connectedCallback() {
        this.Pageno = 1;
        this.TotalPage = 4;
        this.MidPage = true;
        this.LastPage = false;
        this.Data.BorrowerInfo.push({
            ContactId: null,
            Contact: null,
            MasterRepId: null,
            MasterRType: null,
            YTDGDC: null,
            PYGDC: null,
            GPROA: null,
            primary: false,
            Uname: 'Bow1',
            avail: false,
            loanSplit: 0
        });
        //this.Data.ContactId = this.recordId; - Commneted as part of Ch01
        //Start Ch01
        this.Data.CaseId = this.recordId;
        this.Data.BusinessInfo.CaseNumber = this.casedetail != null ? this.casedetail.CaseNumber : null;
        //End Ch01
    } //End
    nextPage() {
      //Madhu added CS-3154 and CS-3348 to prevent dots commas and spaces special characters    
        //  var regex = new RegExp("^[a-zA-Z0-9 ,.]*$");
       // var regex = new RegExp("^$|[a-zA-Z0-9 ,.\n\r]+");
            var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
        var key = this.Data.BusinessInfo.BussinessName; 
       
        if(key != null && key != '' && !regex.test(key)){ 
            this.template.querySelector("c-ea-retention-business").handleValidation(true,'BusinessName'); 
            } 
  else{
    // this.template.querySelector("c-ea-retention-business").handleValidation(false); 
    console.log('pageno'+this.Pageno);
        if (this.Pageno === 3) {
            this.MidPage = false;
            this.LastPage = true;
        } else {
            this.MidPage = true;
        }
        this.Pageno += 1;
        this.displayPage();
        this.nextlogic();
      }
    
    }
    prevPage() {
        if (this.Pageno === 1) {
            this.dispatchEvent(new CustomEvent('parentdata'));
        } else {
            this.MidPage = true;
            this.LastPage = false;
            this.Pageno -= 1;
            this.displayPage();
            this.nextlogic();
        }
    }
    displayPage() {
        Object.keys(this.Page_Section).forEach(element => {
            if (element === 'Page' + this.Pageno) {
                this.Page_Section[element].active = true;
            } else {
                this.Page_Section[element].active = false;
            }
        });
    }
    nextlogic() {
        Object.keys(this.pageCSS).forEach(element => {
            if (element === 'P' + this.Pageno) {
                this.pageCSS[element] = this.ActiveCSS;

            } else {
                // eslint-disable-next-line radix
                if (parseInt(element.replace('P', '')) < this.Pageno) {
                    this.pageCSS[element] = this.CompleteCSS;
                } else {
                    this.pageCSS[element] = this.IncompleteCSS;
                }
            }
        });

    }
    //change to accept advisor value as null ---06/27
    @track Data = {
        'BusinessInfo': {
            'CaseNumber': '', //Ch01
            'BussinessName': '',
            'Entity': '',
            'Advisor': ''
        },
        FinancialData: {
            'LoanAmount': 0,
            'IntrestRate': 0,
            'LoanTerm': '',
            'FundingDate': null
        },
        BorrowerInfo: [],
        AdditionalComments: null,
        CaseId: null // Ch01
        // ContactId: null - Commneted as part of Ch01
    };

    @wire(populateDefaultinformation)
    picklistData({
        error,
        data
    }) {
        if (data) {
            //alert(JSON.stringify(data));
            this.LoanPurpose = data.LoanPurposeList;
            this.LegalEntity = data.LoanEntityList;
        } else if (error) {
            alert('Please refresh page.Unable to load Picklis tData');
        }
    }
    handleAdditionalComment(event) {
        this.Data.AdditionalComments = event.target.value;
    }

    handlebusinessdata(event) {
        let Arr = Object.keys(event.detail)[0];
        Object.keys(this.Data.BusinessInfo).forEach(element => {
            if (element == Arr) {
                this.Data.BusinessInfo[element] = event.detail[Arr];
            }
        });
    }
    handlefinancedata(event) {
        let Arr = Object.keys(event.detail)[0];
        Object.keys(this.Data.FinancialData).forEach(element => {
            if (element == Arr) {
                if (element == 'FundingDate') {
                    if (event.detail[Arr] == "" || event.detail[Arr] == undefined || event.detail[Arr] == null) {
                        this.Data.FinancialData[element] = null;
                    } else {
                        this.Data.FinancialData[element] = event.detail[Arr];
                    }
                } else {
                    this.Data.FinancialData[element] = event.detail[Arr];
                }
            }
        });
    }
    handleBorrower(event) {
        //alert(JSON.stringify(event.detail));
        this.Data.BorrowerInfo = event.detail;
        this.configureBorrower();
    }
    configureBorrower() {
        let Arr = [];
        let count = 0;
        this.Data.BorrowerInfo.forEach(Element => {
            if (count == 0) {
                Element.avail = false;
            } else {
                Element.avail = true;
            }
            count++;
            Arr.push(Element);
        });
        this.Data.BorrowerInfo = Arr;
    }
    getPrimaryContact() {
        var prime;
        this.Data.BorrowerInfo.forEach(Element => {
            if (Element.ContactId != null) {
                if (Element.primary) {
                    prime = Element.ContactId;
                }
            }
        });
        return prime;
    }
    
    saveLoanApplication() {
        //Madhu added CS-3154 and CS-3348 to prevent dots commas and spaces special characters    
        //var regex = new RegExp("^[a-zA-Z0-9 ,.]*$"); commented now it owrking
          var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
        var key = this.Data.BusinessInfo.BussinessName; 
      //  var key1 = this.businessDetails.currentCustodian;       
        var key2 = this.Data.AdditionalComments; 
        var searchAddtionalCom = this.template.querySelector(".Addcomment");   
      //  if ((key != null && key != '' && !regex.test(key)) || (key1 != null && key1 != '' && !regex.test(key1))) { 
         // if ((key2 != null && key2 != '' && !regex.test(key2))) { 
          
      //  }
      this.template.querySelector("c-ea-retention-business").handleValidation(true,'BusinessName'); 
      this.template.querySelector("c-ea-retention-business").handleValidation(false,'BusinessName');   
               /* if(searchAddtionalCom !=null){
                searchAddtionalCom.setCustomValidity("");  
                searchAddtionalCom.reportValidity();  
                }*/
        if ((key != null && key != '' && !regex.test(key)) || (key2 != null && key2 != '' && !regex.test(key2))) {

        if(key2 != null && key2 != '' && !regex.test(key2)){ 
        
            searchAddtionalCom.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");  
            searchAddtionalCom.reportValidity(); 
            }
        else if(searchAddtionalCom !=null){
                searchAddtionalCom.setCustomValidity("");  
                searchAddtionalCom.reportValidity();  
            }
        if(key != null && key != '' && !regex.test(key)){ 
            
            this.template.querySelector("c-ea-retention-business").handleValidation(true,'BusinessName'); 
            }
            else if(key != null && key !=''){
                console.log('SaveKey' );
                this.template.querySelector("c-ea-retention-business").handleValidation(false,'BusinessName');   
            }
        }
        

        // madhu ended 3/39/2021
    else{
        
           /* if(key2 != null && key2 !=''){
                
                console.log('SaveKey2' );
                searchAddtionalCom.setCustomValidity("");  
                searchAddtionalCom.reportValidity();  
            }
            
            if(key != null && key !=''){
                console.log('SaveKey' );
                this.template.querySelector("c-ea-retention-business").handleValidation(false,'BusinessName');   
            }*/
            
        if (this.Data.FinancialData.IntrestRate != undefined && this.Data.FinancialData.IntrestRate != 0 && this.Data.FinancialData.IntrestRate > 100) {
            alert('Please check Interest Rate');
            return;
        }
        // alert(JSON.stringify(this.Data));

        //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
        let validatebrw = false;
        this.Data.BorrowerInfo.forEach(Element => {

            if (Element.loanSplit > 100) {
                alert('% Split of Sub Loan should be less than 100');
                validatebrw = true;
                this.loading = false;
                return;
            }

        });
        if (validatebrw) {
            this.loading = false;
            return;
        } //End
        var PrimeId = this.getPrimaryContact();
        if (PrimeId != undefined || PrimeId != null) {
            checkContactStatus({
                    'ContactId': PrimeId,
                    'RecordTypeName': 'Retention Loan'
                })
                .then(suc => {
                    if (suc) {
                        alert('This Customer already has an opened Loan Application or this Contact is Terminated.');
                    } else {
                        this.saveLA();
                    }
                })
                .catch(er => {
                    //Commented by Amol 09/08
                    //alert('Unable to create Loan App');
                });
        } else {
            this.saveLA();
        }
       }
     }
     saveLA() {
        let dataz;
        dataz = Object.assign({}, this.Data);
        dataz.BorrowerInfo.forEach(Element => {
            if (Element.Contact != null && Element.Contact.Name != null) {
                Element['BName'] = Element.Contact.Name;
            }

            delete Element.Contact;
        });
        console.log(JSON.stringify(dataz));
        this.loading = true; // Show Spinner
        saveRecord({
                "JSONDATA": JSON.stringify(dataz)
            })
            .then(suc => {
                if (suc != 'ERROR') {
                    if (window.location.href.indexOf(".lightning.force.com") > 0) {
                        let nav = {
                            type: "standard__recordPage",
                            attributes: {
                                recordId: suc,
                                objectApiName: "Loan_Application__c",
                                actionName: "view"
                            }
                        };
                        this[NavigationMixin.Navigate](nav);
                    } else {
                        let oldURL = window.location.href;
                        oldURL = oldURL.replace("--c.visualforce.com/apex/customUIVF", ".lightning.force.com/lightning/r/Loan_Application__c/" + suc + "/view");
                        //window.location.assign(oldURL);
                        window.parent.location = '/' + suc; //used to view record in Classic View
                    }
                }
            })
            .catch(err => {
                if (err.body.message.includes('You cant edit the loan application because status is Declined')) {
                    alert('You can\'t edit the loan application because status is Declined');
                } else if (err.body.message.includes('This loan application cannot be edited because it is inactive')) {
                    alert("Unable to Save Loan Application. This loan application cannot be edited because it is inactive. Create new application");
                } else if (err.body.message.includes('This loan application cannot be edited because contact is terminated')) {
                    alert("Unable to Save Loan Application. This loan application cannot be edited because contact is terminated");
                } else if (err.body.message.includes('This contact has been terminated, a loan application cannot be created')) {
                    alert('Unable to Save Loan Application. This contact has been terminated, a loan application cannot be created');

                } else {
                    alert('Unable to Save Loan Application');
                }
            });


    }




}