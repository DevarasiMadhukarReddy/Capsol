import {
    LightningElement,
    track,
    api
} from 'lwc';
import saveWCRecord from '@salesforce/apex/wcLoanApplicationController.saveWCRecord';
import checkContactStatus from '@salesforce/apex/wcLoanApplicationController.checkContactStatus';
import {
    NavigationMixin
} from 'lightning/navigation';

export default class WorkingCapitalModule extends NavigationMixin(LightningElement) {
    @track quickaction = true;
    @api classic = false;
    @api opportunityId;
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
    @track bEditRecord = true;
    @track pEditRecord = true;
    @track fEditRecord = true;
    @track showHeader = true;
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    @track taRecord = false;
    @track hideWizard = false;
    @track workingCapitl = true;
    //End
    @track pageCSS = {
        "P1": "slds-path__item slds-is-current slds-is-active",
        "P2": "slds-path__item slds-is-incomplete",
        "P3": "slds-path__item slds-is-incomplete",
        "P4": "slds-path__item slds-is-incomplete",
        "P5": "slds-path__item slds-is-incomplete"
    };

    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    connectedCallback() {
        this.Pageno = 1;
        this.TotalPage = 5;
        this.MidPage = true;
        this.LastPage = false;
        this.Data.BorrowerInfo.push({
            ContactId: null,
            Contact: null,
            pAUM: 0,
            AUMATT: 0,
            primary: false,
            Uname: 'Bow1',
            avail: false,
            loanSplit: 0,
            backendSplit: 0,
            repayableSplit: 0
        });

    } //End
    nextPage() {
        if (this.Pageno === 4) {
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
    disconnectedCallback() {

    }
    cancelQuickAction() {
        window.location.reload();
    }

    @track F2display = false;
    @track F5display = true;
    @track Data = {
        'BusinessInfo': {
            'ParentLoan': null,
            'BussinessName': '',
            'AdvisorNo': '',
            'Entity': '',
            'Registration': '',
            'Custodian': '',
            'ParentId': null
        },
        'FinancialInfo': {
            'mfdh': 0,
            'mfc': 0,
            'va': 0,
            'fa': 0,
            'fi': 0,
            'eq': 0,
            'aiuitCash': 0,
            'totAdvAum': 0,
            'advRev': 0,
            'broRev': 0,
            'totAUM': 0,
            'totProduction': 0,
            'totMFC': 0,
            'pGDC': 0,
            'totBAUM': 0,
            'ptotAUM': 0,
            'ptotAdvAum': 0,
            'ptotBAUM': 0,
            'paiuitCash': 0,
            'peq': 0,
            'pfi': 0,
            'pfa': 0,
            'pva': 0,
            'pmfc': 0,
            'pmfdh': 0
        },
        'BorrowerInfo': [],
        'ProposalInfo': {
            "RequestedLoanAmount": 0,
            "RequestedTermLength": ""
        },
        'AdditionalComments': '',
        'OpportunityId': ''
    }
    @track bEdit = true;
    handleAdditionalComment(event) {
        this.Data.AdditionalComments = event.target.value;
    }
    handleproposaldata(event) {
        let bol = false;
        let Arr = Object.keys(event.detail)[0];
        Object.keys(this.Data.ProposalInfo).forEach(element => {
            if (element == Arr) {
                this.Data.ProposalInfo[element] = event.detail[Arr];
                bol = true;
            }
        });
        if (!bol) {
            this.Data.ProposalInfo[Arr] = event.detail[Arr];
        }
    }
    handlebusinessdata(event) {
        let bol = false;
        let Arr = Object.keys(event.detail)[0];
        Object.keys(this.Data.BusinessInfo).forEach(element => {
            if (element == Arr) {
                if (Arr == 'ParentLoan') {
                    if (event.detail[Arr] != null) {
                        this.Data.BusinessInfo.ParentId = event.detail[Arr].Id;
                    } else {
                        this.Data.BusinessInfo.ParentId = null;
                    }
                }
                this.Data.BusinessInfo[element] = event.detail[Arr];
                bol = true;
            }
        });
        if (!bol) {
            this.Data.BusinessInfo[Arr] = event.detail[Arr];
            if (Arr == 'ParentLoan') {
                if (event.detail[Arr] != null) {
                    this.Data.BusinessInfo.ParentId = event.detail[Arr].Id;
                } else {
                    this.Data.BusinessInfo.ParentId = null;
                }
            }
        }
    }
    handlefinancialdata(event) {
        try {
            let bol = false;
            let Arr = Object.keys(event.detail)[0];
            Object.keys(this.Data.FinancialInfo).forEach(element => {
                if (element == Arr) {
                    this.Data.FinancialInfo[element] = event.detail[Arr];
                    bol = true;
                }
            });
            if (!bol) {
                this.Data.FinancialInfo[Arr] = event.detail[Arr];
            }
            console.log(JSON.stringify(this.Data.FinancialInfo));
            this.calculateFinancialData();
        } catch (e) {
            //alert(e);
        }
    }
    calculateFinancialData() {
        try {
            this.Data.FinancialInfo['totProduction'] = this.Data.FinancialInfo.advRev + this.Data.FinancialInfo.broRev;
            this.Data.FinancialInfo.totBAUM = this.Data.FinancialInfo.mfc + this.Data.FinancialInfo.mfdh + this.Data.FinancialInfo.va + this.Data.FinancialInfo.fi + this.Data.FinancialInfo.fa + this.Data.FinancialInfo.eq + this.Data.FinancialInfo.aiuitCash;
            this.Data.FinancialInfo.totAUM = this.Data.FinancialInfo.totBAUM + this.Data.FinancialInfo.totAdvAum;
            this.Data.FinancialInfo.totMFC = this.Data.FinancialInfo.mfdh + this.Data.FinancialInfo.mfc;
            try {
                this.Data.FinancialInfo.pGDC = (this.Data.FinancialInfo.totProduction / this.Data.FinancialInfo.totAUM) * 100;
                this.Data.FinancialInfo.pGDC = isNaN(this.Data.FinancialInfo.pGDC) ? 0 : this.Data.FinancialInfo.pGDC.toFixed(2);
                console.log(this.Data.FinancialInfo.pGDC);
            } catch (e) {
                this.Data.FinancialInfo.pGDC = 0;
                console.log('catch' + this.Data.FinancialInfo.pGDC);
            }
            try {
                this.Data.FinancialInfo.pmfdh = ((this.Data.FinancialInfo.mfdh / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.pmfdh = isNaN(this.Data.FinancialInfo.pmfdh) ? 0 : this.Data.FinancialInfo.pmfdh;
            } catch (e) {
                this.Data.FinancialInfo.pmfdh = 0;
            }
            try {
                this.Data.FinancialInfo.ptotBAUM = ((this.Data.FinancialInfo.mfc + this.Data.FinancialInfo.mfdh + this.Data.FinancialInfo.va + this.Data.FinancialInfo.fi + this.Data.FinancialInfo.fa + this.Data.FinancialInfo.eq + this.Data.FinancialInfo.aiuitCash / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.ptotBAUM = isNaN(this.Data.FinancialInfo.ptotBAUM) ? 0 : this.Data.FinancialInfo.ptotBAUM;
            } catch (e) {
                this.Data.FinancialInfo.ptotBAUM = 0;
            }
            try {

                this.Data.FinancialInfo.ptotAUM = ((this.Data.FinancialInfo.totAUM / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.ptotAUM = isNaN(this.Data.FinancialInfo.ptotAUM) ? 0 : this.Data.FinancialInfo.ptotAUM;
            } catch (e) {
                this.Data.FinancialInfo.ptotAUM = 0;

            }
            try {
                this.Data.FinancialInfo.pmfc = ((this.Data.FinancialInfo.mfc / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.pmfc = isNaN(this.Data.FinancialInfo.pmfc) ? 0 : this.Data.FinancialInfo.pmfc;
            } catch (e) {
                this.Data.FinancialInfo.pmfc = 0;
            }

            try {
                this.Data.FinancialInfo.pva = ((this.Data.FinancialInfo.va / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.pva = isNaN(this.Data.FinancialInfo.pva) ? 0 : this.Data.FinancialInfo.pva;
            } catch (e) {
                this.Data.FinancialInfo.pva = 0;
            }
            try {
                this.Data.FinancialInfo.pfa = ((this.Data.FinancialInfo.fa / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.pfa = isNaN(this.Data.FinancialInfo.pfa) ? 0 : this.Data.FinancialInfo.pfa;
            } catch (e) {
                this.Data.FinancialInfo.pfa = 0;
            }
            try {
                this.Data.FinancialInfo.peq = ((this.Data.FinancialInfo.eq / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.peq = isNaN(this.Data.FinancialInfo.peq) ? 0 : this.Data.FinancialInfo.peq;
            } catch (e) {
                this.Data.FinancialInfo.peq = 0;
            }
            try {
                this.Data.FinancialInfo.pfi = ((this.Data.FinancialInfo.fi / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.pfi = isNaN(this.Data.FinancialInfo.pfi) ? 0 : this.Data.FinancialInfo.pfi;
            } catch (e) {
                this.Data.FinancialInfo.pfi = 0;
            }
            try {
                this.Data.FinancialInfo.paiuitCash = ((this.Data.FinancialInfo.aiuitCash / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.paiuitCash = isNaN(this.Data.FinancialInfo.paiuitCash) ? 0 : this.Data.FinancialInfo.paiuitCash;
            } catch (e) {
                this.Data.FinancialInfo.paiuitCash = 0;
            }

            try {

                this.Data.FinancialInfo.ptotAdvAum = ((this.Data.FinancialInfo.totAdvAum / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.ptotAdvAum = isNaN(this.Data.FinancialInfo.ptotAdvAum) ? 0 : this.Data.FinancialInfo.ptotAdvAum;
            } catch (e) {
                this.Data.FinancialInfo.ptotAdvAum = 0;

            }

            try {

                this.Data.FinancialInfo.ptotBAUM = (((this.Data.FinancialInfo.mfc + this.Data.FinancialInfo.mfdh + this.Data.FinancialInfo.va + this.Data.FinancialInfo.fi + this.Data.FinancialInfo.fa + this.Data.FinancialInfo.eq + this.Data.FinancialInfo.aiuitCash) / this.Data.FinancialInfo.totAUM) * 100).toFixed(2);
                this.Data.FinancialInfo.ptotBAUM = isNaN(this.Data.FinancialInfo.ptotBAUM) ? 0 : this.Data.FinancialInfo.ptotBAUM;
            } catch (e) {
                this.Data.FinancialInfo.ptotBAUM = 0;

            }
            this.calculateBorrower();
        } catch (e) {
            //alert(e);
        }
    }
    validateBorrower() {
        let AUMTOT = 0;
        let ContactIDSet = {};
        let bolz = false;
        this.Data.BorrowerInfo.forEach(Element => {
            AUMTOT += Element.pAUM;
            if (Element.ContactId != null) {
                if (ContactIDSet[Element.ContactId] != undefined) {
                    bolz = true;
                    return;

                } else {
                    ContactIDSet[Element.ContactId] = 1;
                }
            }

        });
        if (bolz) {
            return false;
        }
        if (AUMTOT > 100) {
            return false;
        }
        return true;
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
        if (!this.validateBorrower()) {
            alert('Please Check Borrower Contact for duplicate  or sum of all Split  % of AUM should not be greater than 100');
            return;
        }
        var PrimeId = this.getPrimaryContact();
        if (PrimeId != undefined || PrimeId != null) {


            checkContactStatus({
                    'ContactId': PrimeId,
                    'RecordTypeName': 'Working Capital'
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

    saveLA() {
        this.Data.OpportunityId = this.opportunityId;
        //alert(JSON.stringify(this.Data));
        //alert('HELLO');
        let dataz;

        dataz = Object.assign({}, this.Data);
        if (dataz.BusinessInfo.ParentLoan != null) {
            delete dataz.BusinessInfo.ParentLoan;
        }
        //alert(JSON.stringify(dataz));
        dataz.BorrowerInfo.forEach(Element => {
            if (Element.Contact != null && Element.Contact.Name != null) {
                Element['BName'] = Element.Contact.Name;
            }

            delete Element.Contact;
        });
        //alert(JSON.stringify(dataz));

        saveWCRecord({
                "JSONDATA": JSON.stringify(dataz)
            })
            .then(suc => {
                if (suc != 'ERROR') {
                    /*  let  nav = {
                          type: "standard__recordPage",
                          attributes: {
                              recordId: suc,
                              objectApiName: "Loan_Application__c",
                              actionName: "view"
                          }
                      };
                      this[NavigationMixin.Navigate](nav);*/


                    if (window.location.href.indexOf(".lightning.force.com") > 0) {

                        // alert(document.referrer.indexOf(".lightning.force.com"));
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
                        //  alert('>>2');
                        // https://lplmainorg--finance.lightning.force.com/lightning/r/Loan_Application__c/a000R000002oLXkQAM/view
                        // window.location.assign('');
                        console.log('--' + window.location.href);
                        let oldURL = window.location.href;
                        console.log('--' + window.location.protocol + '//' + window.location.host);
                        //let urltemp =window.location.protocol+'//'+window.location.href ;
                        oldURL = oldURL.replace("--c.visualforce.com/apex/customUIVF", ".lightning.force.com/lightning/r/Loan_Application__c/" + suc + "/view");
                        console.log('--->' + oldURL);
                        //window.location.assign(oldURL);
                        window.parent.location = '/' + suc; //used to view record in Classic View

                    }





                }
            })
            .catch(er => {
                //alert(er);
            });
    }

    handleBorrower(event) {
        //alert(JSON.stringify(event.detail));
        this.Data.BorrowerInfo = event.detail;
        this.calculateBorrower();
    }

    calculateBorrower() {
        //alert('d');

        let Arr = [];
        let count = 0;
        //alert(JSON.stringify(this.Data.BorrowerInfo));
        this.Data.BorrowerInfo.forEach(Element => {

            if (this.Data.FinancialInfo.totAUM != 0 && this.Data.FinancialInfo.totAUM != null && Element.pAUM != 0 && Element.pAUM != null) {
                Element.AUMATT = parseFloat((this.Data.FinancialInfo.totAUM * Element.pAUM) / 100).toFixed(2);
            } else {
                Element.AUMATT = 0;
            }
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


}