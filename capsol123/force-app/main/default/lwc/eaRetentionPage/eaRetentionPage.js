/*

*    CH.No   Description                                                                 Developer  Date
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
    *
    CH - 02  CS - 2953 Enhancement - Update Forgivable Application and related record 
             as read - only when offer accepted
                                                                                         Amol      03 / 26 / 2021 
    

*/
import {
    LightningElement,
    wire,
    api,
    track
} from 'lwc';
import collectData from '@salesforce/apex/EALoanApplicationController.collectData';
import populateDefaultinformation from '@salesforce/apex/EALoanApplicationController.populateDefaultinformation';
import checkContactStatus from '@salesforce/apex/wcLoanApplicationController.checkContactStatus';
import saveRecord from '@salesforce/apex/EALoanApplicationController.saveRecord';
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
export default class EaRetentionPage extends NavigationMixin(LightningElement) {
    @track loading = false;
    @api recordId;
    @api classic;
    @track quickAction = false;
    @track wcRecord = true;
    @api editRecord = false;
    @api editAddlnComments = false; //CH - 02
    @api DataRetention = {
        'BusinessInfo': {
            'BussinessName': '',
            'Entity': '',
            'Advisor': ''
        },
        FinancialData: {
            'LoanAmount': 0,
            'IntrestRate': 0,
            'LoanTerm': '',
            'FundingDate': ''
        },
        BorrowerInfo: [],
        AdditionalComments: '',
        ContactId: null,
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

    };
    @wire(CurrentPageReference) pageRef;
    @track ea = true;
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    @track hideWizard = true;

    //End
    @track LoanPurpose = [];
    @track LegalEntity = [];
    @track activeSection = ['Application_Info', 'Bussiness_Info', 'Financial_Info', 'Borrower_Info', 'Proposal_Info', 'Additional_Info', 'Additional_Contacts', 'System_Info'];
    //change to accept advisor value as null ---06/27
    @track Data = {
        'BusinessInfo': {
            'BussinessName': '',
            'Entity': '',
            'Advisor': ''
        },
        FinancialData: {
            'LoanAmount': 0,
            'IntrestRate': 0,
            'LoanTerm': '',
            'FundingDate': ''
        },
        BorrowerInfo: [],
        AdditionalComments: '',
        ContactId: null,
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

    };
    connectedCallback() {
        Promise.all([loadStyle(this, LoanCSS)]).then(() => {});
        let load = setInterval(() => {
            clearInterval(load);
            this.collectLoanData();
        }, 5000);
        Promise.all([
            loadStyle(this, ProposalCSS)
        ]).then(() => {
            //alert('Files loaded.');
        }).catch(error => {
            // alert("Error " + error.body.message);
        });


    }
    collectLoanData() {
        this.loading = true;
        collectData({
                recId: this.recordId
            })
            .then(suc => {
                //console.log(JSON.stringify(suc));
                //alert(JSON.stringify(suc));
                this.Data = suc;
                /*console.log('this.data' + this.Data.ApplicationInfo.Status);
                console.log('this.editrecord' + this.editRecord);
                if (this.Data.ApplicationInfo.Status == 'Documentation' || this.Data.ApplicationInfo.Status == 'Boarding & Funding' ||
                    this.Data.ApplicationInfo.Status == 'Information Requested' || this.Data.ApplicationInfo.Status == 'Information Submitted' ||
                    this.Data.ApplicationInfo.Status == 'NIGO' || this.Data.ApplicationInfo.Status == 'Funded') {
                    this.editrecord = false;
                }*/
                this.configureBorrower();
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
        //Madhu added CS-3154 and CS-3348 to prevent dots commas and spaces special characters    
        // var regex = new RegExp('.*([.]{3}).*|.*([\"]{2}).*|.*(\\\\).*');
        var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
        var key = this.Data.BusinessInfo.BussinessName;
        var key2 = this.Data.AdditionalComments;
        //this.template.querySelector("c-ea-retention-business").handleValidation(true, 'BusName');
        // this.template.querySelector("c-wc-additional-comments-comp").handleValidation(false);
        // this.template.querySelector("c-ea-retention-business").handleValidation(false, 'BusName');
        if ((key != null && key != '' && !regex.test(key)) || (key2 != null && key2 != '' && !regex.test(key2))) {

            if (key != null && key != '' && !regex.test(key)) {
                console.log('TESTearetentionbusiness');
                console.log('TESTearetentionbusinessthis.classic' + this.classic);
                this.template.querySelector("c-ea-retention-business").handleValidation(true, 'BusName');
                //CS-3696 Fix spinner on click of saving for TA in classic amol - 05/15/2021 - Start
                if (this.classic) {
                    console.log("inide");
                    //this.template.querySelector('c-ea-retention-detail-comp').hidespinnerinClassicEA();
                    const selectedEvent = new CustomEvent("hidespinner", {
                        detail: false
                    });
                    this.dispatchEvent(selectedEvent);
                    console.log("inide1" + selectedEvent);
                }
                //CS-3696 Fix spinner on click of saving for TA in classic amol - 05/15/2021 - End
            } else if (key != null && key != '' && !regex.test(key)) {
                console.log('TESTearetentionbusiness');
                this.template.querySelector("c-ea-retention-business").handleValidation(false, 'BusName');
                //CS-3696 Fix spinner on click of saving for TA in classic amol - 05/15/2021 - Start

                if (this.classic) {
                    console.log("inide");
                    //this.template.querySelector('c-ea-retention-detail-comp').hidespinnerinClassicEA();
                    const selectedEvent = new CustomEvent("hidespinner", {
                        detail: false
                    });
                    this.dispatchEvent(selectedEvent);
                    console.log("inide1" + selectedEvent);
                }
                //this.dispatchEvent(new CustomEvent('stopSpinner1', { bubbles: true }));
                //CS-3696 Fix spinner on click of saving for TA in classic amol - 05/15/2021 - End
            }
            if (key2 != null && key2 != '' && !regex.test(key2)) {
                this.template.querySelector("c-wc-additional-comments-comp").handleValidation(true);
                //CS-3696 Fix spinner on click of saving for TA in classic amol - 05/15/2021 - Start
                if (this.classic) {
                    console.log("inide");
                    //this.template.querySelector('c-ea-retention-detail-comp').hidespinnerinClassicEA();
                    const selectedEvent = new CustomEvent("hidespinner", {
                        detail: false
                    });
                    this.dispatchEvent(selectedEvent);
                    console.log("inide1" + selectedEvent);
                }
                //CS-3696 Fix spinner on click of saving for TA in classic amol - 05/15/2021 - End

            } else if (key2 != null && key2 != '' && !regex.test(key2)) {
                this.template.querySelector("c-wc-additional-comments-comp").handleValidation(false);
                //CS-3696 Fix spinner on click of saving for TA in classic amol - 05/15/2021 - Start
                if (this.classic) {
                    console.log("inide");
                    //this.template.querySelector('c-ea-retention-detail-comp').hidespinnerinClassicEA();
                    const selectedEvent = new CustomEvent("hidespinner", {
                        detail: false
                    });
                    this.dispatchEvent(selectedEvent);
                    console.log("inide1" + selectedEvent);
                }
                //CS-3696 Fix spinner on click of saving for TA in classic amol - 05/15/2021 - End

            }
        } else {
            /* console.log('TESTearetentionbusiness*****');
             this.template.querySelector("c-wc-additional-comments-comp").handleValidation(false);
             this.template.querySelector("c-ea-retention-business").handleValidation(false,'BusName');*/
            this.loading = true;
            //CS-3696- Amol 05/13/2021 Start
            if (this.classic) {
                if (this.classic) {
                    console.log("inide");
                    //this.template.querySelector('c-ea-retention-detail-comp').hidespinnerinClassicEA();
                    const selectedEvent = new CustomEvent("hidespinner", {
                        detail: true
                    });
                    this.dispatchEvent(selectedEvent);
                    console.log("inide1" + selectedEvent);
                }
            }
            //CS-3696- Amol 05/13/2021 End
            if (this.Data.FinancialData.IntrestRate != undefined && this.Data.FinancialData.IntrestRate != 0 && this.Data.FinancialData.IntrestRate > 100) {
                alert('Please check Interest Rate');
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

            });
            if (validatebrw) {
                this.loading = false;
                return;
            } //End


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
        console.log('dataz' + JSON.stringify(dataz));
        //CH - 02 Start
        //if (!this.editAddlnComments) {
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
            console.log('elemnet' + JSON.stringify(Element.Contact));
            console.log('elemnet' + this.editAddlnComments);
            console.log('elemnet1' + Element.Contact.Name);
            if (Element.Contact != null && Element.Contact.Name != null) {
                Element['BName'] = Element.Contact.Name;
            }
            if (!this.editAddlnComments) {
                delete Element.Contact;
            }

        });
        //}
        //CH - 02 End
        console.log('BorrowerInfo' + JSON.stringify(dataz.BorrowerInfo));
        console.log(JSON.stringify(dataz));
        saveRecord({
                "JSONDATA": JSON.stringify(dataz)
            })
            .then(suc => {

                console.log('suc' + suc);
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
                this.loading = false;
                console.log(err);
                //alert(err); 
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