import {
    LightningElement,
    wire,
    api,
    track
} from 'lwc';
import collectData from '@salesforce/apex/EA2LoanApplicationController.collectData';
import populateDefaultinformation from '@salesforce/apex/EA2LoanApplicationController.populateDefaultinformation';
import checkContactStatus from '@salesforce/apex/wcLoanApplicationController.checkContactStatus';
import saveRecord from '@salesforce/apex/EA2LoanApplicationController.saveRecord';
import {
    CurrentPageReference
} from 'lightning/navigation';
import LoanCSS from '@salesforce/resourceUrl/LoanCSS';
import ProposalCSS from '@salesforce/resourceUrl/ProposalCSS';
import {
    loadStyle
} from 'lightning/platformResourceLoader';
import {
    registerListener,
    unregisterAllListeners,
    fireEvent
} from 'c/auraPubSub';
import {
    NavigationMixin
} from 'lightning/navigation';
export default class EaMonetizationPage extends NavigationMixin(LightningElement) {
    @track loading = false;
    @api recordId;
    @api classic;
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    @track hideWizard = true;
    //End
    @track onload = false;
    @track quickAction = false;
    @track wcRecord = true;
    @api editRecord = false;
    @wire(CurrentPageReference) pageRef;
    @track ea = true;
    @track eamon = true;
    @track LoanPurpose = [];
    @track LegalEntity = [];
    @track activeSection = ['Application_Info', 'Bussiness_Info', 'Financial_Info', 'Borrower_Info', 'Proposal_Info', 'Additional_Info', 'Additional_Contacts', 'System_Info'];
    @track Data = {
        'BusinessInfo': {
            'CaseNumber': '',
            'BussinessName': '',
            'Entity': '',
            'Advisor': '',
            'CaseIdLink': ''
        },
        FinancialData: {
            'LoanAmount': 0,
            'IntrestRate': 0,
            'LoanTerm': '',
            'FundingDate': '',
            'TotalBrokerageAUM': 0,
            'TotalAUM': 0,
            'TotalAdvisoryAUM': 0
        },
        BorrowerInfo: [],
        AdditionalComments: '',
        CaseId: null,
        'AdditionalContacts': {
            "AssignedRecruiter": null,
            "AssignedRecruiterLink": null,
            "InternalRecruiter": null,
            "InternalRecruiterLink": null,
            "BusinessDevelopment": null,
            "BusinessDevelopmentLink": null,
            "CaseOwnerName": null,
            "CaseOwnerLink": null,
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

    };
    connectedCallback() {
        this.onload = true;
        Promise.all([loadStyle(this, LoanCSS)]).then(() => {});
        Promise.all([loadStyle(this, ProposalCSS)]).then(() => {});
        let load = setInterval(() => {
            clearInterval(load);
            this.collectLoanData();
        }, 5000);


    }
    collectLoanData() {
        this.loading = true;
        this.onload = true;
        collectData({
                recId: this.recordId
            })
            .then(suc => {
                //console.log(JSON.stringify(suc));
                //alert(JSON.stringify(suc));
                this.Data = suc;
                this.configureBorrower();
                this.onload = false;
                this.loading = false;
            })
            .catch(er => {
                console.log(er);
                alert('Unable to Load Record Details Please check with your Administrator');
                this.loading = false;

            });
    }
    configureBorrower() {
        let Arr = [];
        let count = 0;
        this.Data.FinancialData.TotalAUM = null;
        this.Data.FinancialData.TotalAdvisoryAUM = null;
        this.Data.FinancialData.TotalBrokerageAUM = null;
        this.Data.BorrowerInfo.forEach(Element => {
            if (count == 0) {
                Element.avail = false;
            } else {
                Element.avail = true;
            }
            if (Element.primary && Element.ContactId != null) {

                this.Data.FinancialData.TotalAUM = (Element.totAdvAUM == null || Element.totBroAUM == null) ? null : (Element.totAdvAUM + Element.totBroAUM);
                this.Data.FinancialData.TotalAdvisoryAUM = Element.totAdvAUM;
                this.Data.FinancialData.TotalBrokerageAUM = Element.totBroAUM;
            }
            count++;
            Arr.push(Element);
        });
        this.Data.BorrowerInfo = Arr;
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
            if (Arr == 'FundingDate') {
                if (event.detail[Arr] == "" || event.detail[Arr] == undefined || event.detail[Arr] == null) {
                    this.Data.FinancialData[Arr] = null;
                } else {
                    this.Data.FinancialData[Arr] = event.detail[Arr];
                }
            } else if (element == Arr) {


                this.Data.FinancialData[element] = event.detail[Arr];

            }
        });
    }
    handleBorrower(event) {
        //alert(JSON.stringify(event.detail));
        this.Data.BorrowerInfo = event.detail;
        this.configureBorrower();
    }
    handleAdditionalComment(event) {

        this.Data.AdditionalComments = event.detail;
    }

    zz() {
        if (this.editRecord) {
            this.editRecord = false;
        } else {
            this.editRecord = true;
        }

    }
    zz1() {
        //alert( this.Data.AdditionalComments);
        this.saveLoanApplication();
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
        this.loading = true;

        if ((this.Data.FinancialData.IntrestRate != undefined && this.Data.FinancialData.IntrestRate > 100) || (this.Data.FinancialData.IntrestRate != undefined && this.Data.FinancialData.IntrestRate < 0)) {
            alert('Please check Interest Rate');
            this.loading = false;

            return;
        }
        //alert(JSON.stringify(this.Data));
        var PrimeId = this.getPrimaryContact();
        if (PrimeId != undefined || PrimeId != null) {
            checkContactStatus({
                    'ContactId': PrimeId,
                    'RecordTypeName': 'Retention Loan',
                    'RecordId': this.recordId
                })
                .then(suc => {
                    if (suc) {
                        this.loading = false;

                        alert('This Customer already has an opened Loan Application or this Contact is Terminated.');
                    } else {
                        this.saveLA();
                    }
                })
                .catch(er => {
                    this.loading = false;
                    //Commneted by Amol 09/08
                    //alert('Unable to create Loan App');
                });
        } else {
            this.saveLA();
        }
    }
    saveLA() {
        let dataz;
        dataz = Object.assign({}, this.Data);
        //alert(JSON.stringify(dataz.FinancialData));
        if (dataz.SystemInfo != null) {
            delete dataz.SystemInfo;
        }

        if (dataz.AdditionalContacts != null) {
            delete dataz.AdditionalContacts;
        }
        if (dataz.ApplicationInfo != null) {
            delete dataz.ApplicationInfo;
        }
        dataz.BorrowerInfo.forEach(Element => {
            if (Element.Contact != null) {
                Element['BName'] = Element.Contact.Name;
                delete Element.Contact;
            }

        });

        //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
        let validatebrw = false;
        dataz.BorrowerInfo.forEach(Element => {

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
        } //Ends


        console.log(JSON.stringify(dataz));
        saveRecord({
                "JSONDATA": JSON.stringify(dataz)
            })
            .then(suc => {
                if (suc != 'ERROR') {
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
                this.loading = false;

            })
            .catch(err => {
                //alert(err); 
                this.loading = false;

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
    @api
    refreshData() {

        this.collectLoanData();
    }
    @api
    saveData() {
        this.saveLoanApplication();
    }
}