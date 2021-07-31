import {
    LightningElement,
    track,
    api,
    wire
} from 'lwc';
import collectData from '@salesforce/apex/wcLoanApplicationController.collectData';
import {
    registerListener,
    unregisterAllListeners,
    fireEvent
} from 'c/auraPubSub';
import {
    CurrentPageReference
} from 'lightning/navigation';
import saveWCRecord from '@salesforce/apex/wcLoanApplicationController.saveWCRecord';
import checkContactStatus from '@salesforce/apex/wcLoanApplicationController.checkContactStatus';
import {
    NavigationMixin
} from 'lightning/navigation';
export default class WcDetailPage extends NavigationMixin(LightningElement) {
    @api recordId;
    @api classic
    @track quickAction = true;
    @track wcRecord = true;
    @api editRecord = false;
    @wire(CurrentPageReference) pageRef;
    //to display spinner --CH01--06/28
    @track loading = false;
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    @track taRecord = false;
    @track hideWizard = true;
    @track workingCapitl = true;

    //End   
    @track activeSection = ['Application_Info', 'Bussiness_Info', 'Financial_Info', 'Borrower_Info', 'Proposal_Info', 'Additional_Info', 'Additional_Contacts', 'System_Info'];
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
        'OpportunityId': '',
        'AdditionalContacts': {
            "AssignedRecruiter": null,
            "AssignedRecruiterLink": null,
            "InternalRecruiter": null,
            "InternalRecruiterLink": null,
            "BusinessDevelopment": null,
            "BusinessDevelopmentLink": null,
            "PreparerName": '',
            "ServicerName": ''
        },
        'ApplicationInfo': {
            "ApplicationNo": '',
            "ApplicationLink": '',
            "Status": '',
            "LoanPurpose": '',
            "LoanType": '',
            "Type": '',
            "RecordType": null,
            "RecordTypeName": ''
        },
        'SystemInfo': {
            "CreatedBy": null,
            "CreatedByLink": '',
            "CreatedDate": null,
            "LastModifiedBy": null,
            "LastModifiedByLink": '',
            "LastModifiedDate": null,
            "CLOApplicationId": null,
            "CLOCustomerGroup": null

        },
        'RecordId': null



    }
    @track bEdit = true;

    handleadditionalcomments(event) {
        this.Data.AdditionalComments = event.detail;
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
    }
    calculateFinancialData() {
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
    saveLoanApplication() {
        this.loading = true;
        if (this.Data.ApplicationInfo.Status == 'Funded' || this.Data.ApplicationInfo.Status == 'Declined') {
            alert('This application cannot be saved becaused the Status is either Declined or Funded.');
            this.loading = false;
            return;
        }
        //to validate 100% on AUM Field 2020-06-25
        if (!this.validateBorrower()) {
            alert('Please Check Borrower Contact for duplicate  or sum of all Split  % of AUM should not be greater than 100');
            this.loading = false;
            return;
        }



        //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
        let validatebrw = false;
        this.Data.BorrowerInfo.forEach(Element => {

            if (Element.loanSplit > 100) {
                alert('% Split of Sub Loan should be less than 100');
                validatebrw = true;
                this.loading = false;
                return;
            }
            if (Element.repayableSplit > 100) {
                alert('% Split of Repayable be less than 100');
                validatebrw = true;
                this.loading = false;
                return;
            }
            if (Element.backendSplit > 100) {
                alert('% Split of Backend should be less than 100');
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
                    'RecordTypeName': 'Working Capital',
                    'RecordId': this.recordId
                })
                .then(suc => {
                    if (suc) {
                        alert('This Customer already has an opened Loan Application or this Contact is Terminated.');
                        this.loading = false;
                    } else {
                        this.saveLA();
                    }
                })
                .catch(er => {
                    //Commented by Amol 09/08
                    //alert('Unable to create Loan App');
                    this.loading = false;
                });
        } else {
            this.saveLA();
        }
    }

    saveLA() {
        //this.Data.OpportunityId=this.opportunityId;
        // alert(JSON.stringify(this.Data));
        // alert('HELLO');
        let dataz;

        dataz = Object.assign({}, this.Data);
        // alert(JSON.stringify(dataz));

        if (dataz.SystemInfo != null) {
            delete dataz.SystemInfo;
        }
        if (dataz.BusinessInfo.ParentLoan != null) {
            delete dataz.BusinessInfo.ParentLoan;
        }
        if (dataz.BusinessInfo.Parent != null) {
            delete dataz.BusinessInfo.Parent;
        }
        if (dataz.AdditionalContacts != null) {
            delete dataz.AdditionalContacts;
        }
        if (dataz.ApplicationInfo != null) {
            delete dataz.ApplicationInfo;
        }
        dataz.BorrowerInfo.forEach(Element => {
            if (Element.Contact != null && Element.Contact.Name != null) {
                Element['BName'] = Element.Contact.Name;
            }

            delete Element.Contact;

        });
        // alert(JSON.stringify(dataz));
        // alert(this.Data.AdditionalComments);

        saveWCRecord({
                "JSONDATA": JSON.stringify(dataz)
            })
            .then(suc => {
                if (suc != 'ERROR') {
                    //alert(suc);
                    //alert(this.classic);
                    // alert(suc);
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

                    if (!this.classic) {
                        fireEvent(this.pageRef, 'DetailLoanApplication', 'DetailSaveClick');
                    } else {
                        this.dispatchEvent(new CustomEvent('detailloanapplication'));

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
                this.loading = false;
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

    connectedCallback() {
        let load = setInterval(() => {
            clearInterval(load);
            this.collectLoanData();
        }, 5000);


    }
    collectLoanData() {
        this.loading = true;
        collectData({
                recId: this.recordId
            })
            .then(suc => {
                console.log(JSON.stringify(suc));
                // alert(JSON.stringify(suc));
                this.Data = suc;
                this.calculateFinancialData();
                this.calculateBorrower();
                this.loading = false;

            })
            .catch(er => {
                console.log(er);
                this.loading = false;
                alert('Unable to Load Record Details Please check with your Administrator');
            });
    }
    @api
    refreshData() {

        this.collectLoanData();
    }
    @api
    saveData() {
        this.saveLoanApplication();
    }

}