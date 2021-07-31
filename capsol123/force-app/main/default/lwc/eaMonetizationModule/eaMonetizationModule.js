import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';
import populateDefaultinformation from '@salesforce/apex/EA2LoanApplicationController.populateDefaultinformation';
import checkContactStatus from '@salesforce/apex/wcLoanApplicationController.checkContactStatus';
import saveRecord from '@salesforce/apex/EA2LoanApplicationController.saveRecord';
import {
    NavigationMixin
} from 'lightning/navigation';
export default class EaRetentionModule extends NavigationMixin(LightningElement) {
    @api recordId;
    @api classic;
    @api casedetail;
    //CS-1811-Bhanu Start
    @track hideWizard = true;
    //End   

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

    @track pageCSS = {
        "P1": "slds-path__item slds-is-current slds-is-active",
        "P2": "slds-path__item slds-is-incomplete",
        "P3": "slds-path__item slds-is-incomplete",
        "P4": "slds-path__item slds-is-incomplete",
        "P5": "slds-path__item slds-is-incomplete"
    };
    @track quickAction = true;
    //CS-1811-Bhanu Start
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
        this.Data.CaseId = this.recordId;
        this.Data.BusinessInfo.CaseNumber = this.casedetail != null ? this.casedetail.CaseNumber : null;
    } //End  
    nextPage() {
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
    @track Data = {
        'BusinessInfo': {
            'CaseNumber': '',
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
        CaseId: null
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

        if ((this.Data.FinancialData.IntrestRate != undefined && this.Data.FinancialData.IntrestRate > 100) || (this.Data.FinancialData.IntrestRate != undefined && this.Data.FinancialData.IntrestRate < 0)) {
            alert('Please check Interest Rate');
            return;
        }
        // alert(JSON.stringify(this.Data));
        var PrimeId = this.getPrimaryContact();
        if (PrimeId != undefined || PrimeId != null) {
            //checkContactStatus({'ContactId':PrimeId,'RecordTypeName':'Retention Loan'})
            checkContactStatus({
                    'ContactId': PrimeId,
                    'RecordTypeName': 'Monetization'
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
                    // alert('Unable to create Loan App');
                });
        } else {
            this.saveLA();
        }
    }
    saveLA() {
        let dataz;
        dataz = Object.assign({}, this.Data);
        dataz.BorrowerInfo.forEach(Element => {
            if (Element.Contact != undefined) {
                Element['BName'] = Element.Contact.Name;
            }

            delete Element.Contact;
        });
        console.log(JSON.stringify(dataz));
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