/* eslint-disable no-loop-func */
/* eslint-disable guard-for-in */
/* eslint-disable no-undef */
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable vars-on-top */
/* eslint-disable no-dupe-class-members */
/* eslint-disable no-empty */
/* eslint-disable radix */
/* eslint-disable no-console */
/* eslint-disable no-const-assign */
/* eslint-disable no-constant-condition */
/* eslint-disable no-unused-vars */
/* eslint-disable no-cond-assign */
/* eslint-disable no-restricted-globals */
/* eslint-disable no-alert */
/* eslint-disable eqeqeq */
/*CS - 2755 TA Application Performance Improvement - Sprint 21 Amol - 01/14/2021 CH01*/
import {
    LightningElement,
    track,
    api,
    wire
} from 'lwc';
import getResults from '@salesforce/apex/lwcCustomLookupController.getResults';
import saveLoanRec from '@salesforce/apex/clsCustomUIController.saveLoanAppObj';
import checkContactStatus from '@salesforce/apex/wcLoanApplicationController.checkContactStatus';
import GetLoanObjectInformtion from '@salesforce/apex/RecordTypeSelector.GetLoanObjectInformtion';
//Modified By Bhanu 8/11/2020 changes Start-->  
import GetOpportunityDetails from '@salesforce/apex/RecordTypeSelector.GetOpportunityDetails';
//Ends
import {
    NavigationMixin
} from 'lightning/navigation';

import {
    getObjectInfo
} from 'lightning/uiObjectInfoApi';
import LOAN_APPLICATION_OBJECT from '@salesforce/schema/Loan_Application__c';
export default class LoanQuickAction extends NavigationMixin(LightningElement) {
    @api recordId;
    @api classic = false;
    @track
    _businessLegalNameDBAVal = '';
    get businessLegalNameDBAVal() {
        return this._businessLegalNameDBAVal;
    }
    set businessLegalNameDBAVal(value) {
        this._businessLegalNameDBAVal = value;
    }
    @track noOfAdvisors = 0;
   // @track legalEntity = '';
    @track currentRegistration = '';
    @track currentCustodianVal = '';
    @api objectApiName;
    @api sfObjectApi = 'Loan_Application__c';

    @track RecordtypeBol = false;
    //@api splitOfSumAUM='';

    @api show = false;
    @api recordTypeID;
    @track borrowerDataMaster = [];

    @track businessDetails = {
        businessLegalNameDBA: '',
        noOfAdvisors: 0,
        legalEntity: 'Individual', // Updated Default value ,CS-4205 Update Legal Entity field on TA application by Madhukar Reddy on 6/15/2021
        currentRegistration: '',
        currentCustodian: ''
    }; // CH01

    @track bEditRecord = true;
    @track pEditRecord = true;
    @track fEditRecord = true;
    @track showHeader = true;
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    @track taRecord = false;
    @track hideWizard = false;
    @track workingCapitl = false;
    //End 
    @track BorrowerData = {
        'borrowerData': {
            'BorrowerName': '',
            'SplitofTotalAUM': '',
            'AUMAttributable': '',
            'PrimaryContact': false,
            'TotalAUM': '',
            'BorrowerId': '',
            'rowCount': 1,
            'avail': false
        }

    }

    @api borrowerIndex;

    @api formData = {};


    @api display = false;

    @api finacialDetailsData = [];
    @track totAUM = 0.00;
    @track totProduction = 0.00;

    @track mfdh = 0.00;
    @track mfc = 0.00;
    @track va = 0;
    @track fa = 0;
    @track fi = 0;
    @track eq = 0;
    @track aiuitCash = 0;
    @track totAdvAum = 0;
    @track totBAUM = 0;

    @track aumAttributableVal = 0;
    @track primaryConValue = false;

    @api displayFinan = false;

    @track advRev = 0;
    @track broRev = 0;
    @track GDC = 0;
    @track PercentData = {
        'mfdh': 0,
        'mfc': 0,
        'va': 0,
        'fa': 0,
        'fi': 0,
        'eq': 0,
        'aiuitCash': 0,
        'broRev': 0,
        'advRev': 0,
        'totAdvAum': 0
    }
    @track TotMFC = 0;

    @api myArrayBRO = [{
        label: '',
        value: '',
        index: 1,
        showBrow: false
    }];

    @api row;
    @api showBrow = false;

    @track value = '';

    // @api showBrow=false;
    @api myArrayBrow = [{
        label: '',
        value: '',
        index: 1,
        showBrow: false
    }];
    get rowsBrow() {
        return this.myArrayBrow;
    }

    @api rowBrowRow;
    @api showBrowRow;
    @track valueBrowRow = '';
    //@api borrowers = [];

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
    @track iconFlag = true;
    @track clearIconFlag = false;
    @track inputReadOnly = false;
    @track loading = false; // Show Spinner on Save
    @api showPro = false;
    @api proposalData1Pro = [];
    @api finalProposalArrayPro = [];
    @track myArrayPro = [{
        label: '',
        value: '',
        index: 1,
        showPro: false
    }];
    get rowsPro() {
        return this.myArrayPro;
    }

    @api proposalDataProRow = {};


    @api showProRow = false;
    @api showProRow2 = false;
    @api showProRow3 = false;
    @api showProRow4 = false;
    @api showProRow5 = false;
    //Modified By Bhanu 9/9/2020 changes Start  1891
    @track uWTypePicklist5Disabled = true;
    @track uWTypePicklist1Disabled = true;
    @track uWTypePicklist2Disabled = true;
    @track uWTypePicklist3Disabled = true;
    @track uWTypePicklist4Disabled = true;

    //Changes ends

    @track osjLEName1; //madhu added 4242021
    @track osjLEName2; //madhu added 4242021
    @track osjLEName3; //madhu added 4242021
    @track osjLEName4; //madhu added 4242021
    @track osjLEName5; //madhu added 4242021
    @track osjLEName11;
    @track osjLEName22;
    @api AdditionalComments = '';
    @track objectInfo;
    @wire(getObjectInfo, {
        objectApiName: LOAN_APPLICATION_OBJECT
    }) objectInfo;
    get platformPicklistValues() {
        return [{
                label: 'Corp',
                value: 'Corp'
            },
            {
                label: 'Hybrid',
                value: 'Hybrid'
            },
            {
                label: 'Premium',
                value: 'Premium'
            },
            // CS- 2536 Modified by Amol - 11/05/2020 Start
            {
                label: 'Linsco/Employee Model',
                value: 'Linsco/Employee Model'
            }
            // CS- 2536 Modified by Amol - 11/05/2020 End
        ];
    }

    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    clear() {
        // CH01 Start
        /*this.businessDetails = [];
        this.businessDetails.push({
            'businessLegalNameDBA': null,
            'noOfAdvisors': 0,
            'legalEntity': null,
            'currentRegistration': null,
            'currentCustodian': null
        });*/
        //this.businessDetails.businessLegalNameDBA = '';
        // this.businessDetails.currentCustodian = '';
        //console.log('onload' + this.businessDetails.businessLegalNameDBA);
        // console.log('onload' + this.businessDetails.currentCustodian);
        // CH01 End
        this.borrowerDataMaster = [];
        this.borrowerDataMaster.push({
            ContactId: null,
            Contact: null,
            pAUM: 0,
            AUMATT: 0,
            primary: false,
            Uname: 'Bow1',
            loanSplit: 0,
            backendSplit: 0,
            repayableSplit: 0
        }); //End
        this.businessLegalNameDBAVal = '';
        this.noOfAdvisors = 0;
        this.legalEntity = '';
        this.currentRegistration = '';
        this.currentCustodianVal = '';
        this.BorrowerData = {
            'borrowerData': {
                'BorrowerName': '',
                'SplitofTotalAUM': '',
                'AUMAttributable': '',
                'PrimaryContact': false,
                'TotalAUM': '',
                'BorrowerId': '',
                'rowCount': 1,
                'avail': false
            }

        };
        this.display = false;
        this.formData = {};
        this.finacialDetailsData = [];
        this.totAUM = 0.00;
        this.totProduction = 0.00;

        this.mfdh = 0.00;
        this.mfc = 0.00;
        this.va = 0;
        this.fa = 0;
        this.fi = 0;
        this.eq = 0;
        this.aiuitCash = 0;
        this.totAdvAum = 0;
        this.totBAUM = 0;

        this.aumAttributableVal = 0;
        this.primaryConValue = false;

        this.displayFinan = false;

        this.advRev = 0;
        this.broRev = 0;
        this.GDC = 0;
        this.PercentData = {
            'mfdh': 0,
            'mfc': 0,
            'va': 0,
            'fa': 0,
            'fi': 0,
            'eq': 0,
            'aiuitCash': 0,
            'broRev': 0,
            'advRev': 0,
            'totAdvAum': 0
        };
        this.proposalData1Pro = [];
        this.finalProposalArrayPro = [];
        this.proposalDataProRow = {};
        this.showPro = false;
        this.showProRow = false;
        this.showProRow2 = false;
        this.showProRow3 = false;
        this.showProRow4 = false;
        this.showProRow5 = false;
    }

    get branchPicklistValues() {
        return [{
                label: 'In-branch / LE',
                value: 'In-branch / LE'
            },
            {
                label: 'New Branch / HOS',
                value: 'New Branch / HOS'
            }
        ];
    }
    get CampaignPicklistValues() {
        return [{
                label: 'Wirehouse Experiment',
                value: 'Wirehouse Experiment'
            },
            // CS- 2536 Modified by Amol - 11/05/2020 Start
            /* {
                label: 'EOY',
                value: 'EOY'
            },*/
            // CS- 2536 Modified by Amol - 11/05/2020 End
            {
                label: 'Other',
                value: 'Other'
            }
        ];
    }

    get termLengthPicklistValues() {
        return [
            // CS- 2536 Modified by Amol - 11/05/2020 Start
            /* {
                label: '3 Years',
                value: '3 Years'
            },
            {
                label: '5 Years',
                value: '5 Years'
            },*/
            // CS- 2536 Modified by Amol - 11/05/2020 End
            {
                label: '7 Years',
                value: '7 Years'
            },
            //madhu added 9 years on 27/08/2020 CS-1991
            {
                label: '9 Years',
                value: '9 Years'
            },
            {
                label: '10 Years',
                value: '10 Years'
            }

        ];
    }

    get uWTypePicklistValues() {
        return [{
                label: 'Standard',
                value: 'Standard'
            },

            {
                label: 'Enhanced',
                value: 'Enhanced'
            },

            {
                label: 'Campaign',
                value: 'Campaign'
            }
        ];
    }

    get legalEntityValues() {
        console.log('businessDetails789'+JSON.stringify(this.businessDetails));
        return [{
                label: 'Individual',
                value: 'Individual'
            },
            // CS- 2536 Modified by Amol - 11/05/2020 Start
            /* As per CS-4205 user story hiding the Business-Hybrid RIA/Bank value 
            {
                label: 'Business – Hybrid RIA/Bank',
                value: 'Business – Hybrid RIA/Bank'
            }
            ,*/
            // CS-4205 Update Legal Entity field on TA application by Madhukar Reddy on 6/15/2021 Start
                        {
                            label: 'Sole Proprietorship',
                            value: 'Sole Proprietorship'
                        },
                        {
                            label: 'Partnership',
                            value: 'Partnership'
                        },
                        {
                            label: 'Corporation',
                            value: 'Corporation'
                        },
                        {
                            label: 'Limited Liability Company',
                            value: 'Limited Liability Company'
                        }
            // CS-4205 Update Legal Entity field on TA application by Madhukar Reddy on 6/15/2021 Ended
            // CS- 2536 Modified by Amol - 11/05/2020 End
        ];
    }

    get currentRegistrationValues() {
        return [
            // { label: 'IRA Only', value: 'IRA Only' },
            // { label: 'Broker/Dealer', value: 'Broker/Dealer' },
            // { label: 'Hybrid IRA/Dual-Registered', value: 'Hybrid IRA/Dual-Registered' }

            //CS-2522 Modified by Amol 11_09_2020 Start
            {
                label: 'Independent',
                value: 'Independent'
            }, {
                label: 'Wirehouse/Regional',
                value: 'Wirehouse/Regional'
            }, {
                label: 'Bank Advisor',
                value: 'Bank Advisor'
            }, {
                label: 'Institutional',
                value: 'Institutional'
            }, {
                label: 'Insurance',
                value: 'Insurance'
            }, {
                label: 'Termed Advisor',
                value: 'Termed Advisor'
            }
            /*{
                label: 'Broker dealer',
                value: 'Broker dealer'
            },
            {
                label: 'RIA',
                value: 'RIA'
            },
            {
                label: 'Dual Registered',
                value: 'Dual Registered'
            }*/
            //CS - 2522 Modified by Amol 11 _09_2020 End
        ];
    }


    /*@api platform;
    @api branch;
    @api OSJLEName;
    @api termLength;
    @api UWType;
    @api campaignName;*/
    // businessLegalNameDBAValue = '';
    noOfAdvisors = 0;
    legalEntity = '';
    currentRegistration = '';
    //currentCustodianValue = '';
    mutualFundsDirectlyHeld = '';
    mutualFundsCustodied = '';
    variableAnnuties = '';
    fixedAnnuties = '';
    fixedIncome = '';
    equity = '';
    aiUITCash = '';
    totalAdvisoryAUM = '';
    advisoryRevenue = ''
    brokerageRevenue = '';
    totalAUM = 0;
    totalProduction = 0;
    percentMfdh = '';
    percentMfc = '';
    percentTotMFC = '';
    percentVA = '';
    percentFA = '';
    percentFI = '';
    percentEQ = '';
    percentAIUITCash = '';
    percentTotAdvAUM = '';
    percentAdvRev = '';
    percentBroRev = '';
    percentGDC = '';
    borrowerName = '';
    borrowerId = '';
    splitOfSumAUM = '';
    aumAttributable = '';
    primaryContact = true;
    borrowers = [];

    /* @api formData=[{
        businessLegalNameDBA : this.businessLegalNameDBA,
        noOfAdvisors : this.noOfAdvisors,
        legalEntityType:this.legalEntityType,
        currentRegistration:this.currentRegistration,
        currentCustodian:this.currentCustodian,
        mutualFundsDirectlyHeld:this.mutualFundsDirectlyHeld,
        mutualFundsCustodied:this.mutualFundsCustodied,
        variableAnnuties:this.variableAnnuties,
        fixedAnnuties:this.fixedAnnuties,
        fixedIncome:this.fixedIncome,
        equity:this.equity,
        aiUITCash:this.aiUITCash,
        totalAdvisoryAUM:this.totalAdvisoryAUM,
        advisoryRevenue:this.advisoryRevenue,
        brokerageRevenue:this.brokerageRevenue,
        totalAUM:this.totalAUM,
        totalProduction:this.totalProduction,
        borrowersData:this.borrowersData,
        proposalOffers:this.proposalOffers
    }]
    @api borrowersData=[{
        borrowerName:'',
        splitOfSumAUM:'',
        aumAttributable:'',
        primaryContact:true
    
    }] */
    @track Pageno = 0;
    @track TotalPage = 5;
    @track FirstPage = true;
    @track MidPage = false;
    @track LastPage = false;
    @track PageSection = {
        'Page0': true,
        'Page1': false,
        'Page2': false,
        'Page3': false,
        'Page4': false,
        'Page5': false
    };
    @track selectedloan;
    @track progressbar;
    @track istyle;
    @track hstyle;
    @track Page_Section = {
        'Page0': {
            'active': true,
            'width': '0%',
            'background': 'green',
            'displayicon': true
        },
        'Page1': {
            'active': false,
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
    @track PageData = {
        "D1": null,
        "D2": null,
        "D3": null,
        "D4": null
    };
    @track pageValidation = true;
    @track ActiveCSS = "slds-path__item slds-is-current slds-is-active";
    @track CompleteCSS = "slds-path__item slds-is-complete";
    @track IncompleteCSS = "slds-path__item slds-is-incomplete";
    @track pageCSS = {
        "P1": "slds-path__item slds-is-current slds-is-active",
        "P2": "slds-path__item slds-is-incomplete",
        "P3": "slds-path__item slds-is-incomplete",
        "P4": "slds-path__item slds-is-incomplete",
        "P5": "slds-path__item slds-is-incomplete"
    };


    /*  handlebusinessLegalNameDBA(event) {
    
        this.businessLegalNameDBAVal = event.target.value;
        //this.formData.businessLegalNameDBA = this.businessLegalNameDBAVal;
        //this.formData.push({businessLegalNameDBA:this.businessLegalNameDBAVal});
        //this.formData = [...this.formData,{businessLegalNameDBA:this.businessLegalNameDBAVal}];
        this.formData.businessLegalNameDBA = event.target.value;
        /* this.formData.forEach(_element => { 
            if(_element.name = 'businessLegalNameDBA'){
                _element.value = this.businessLegalNameDBA;
                this.formData.push(_element);
                this.businessLegalNameDBA = _element.value;
            }
        });*/
    /*const selectedbusinessLegalNameDBA = new CustomEvent("businessLegalNameDBAchange", {
        detail: this.formData
    });
    
    // Dispatches the event.
    this.dispatchEvent(selectedbusinessLegalNameDBA);*/
    //console.log(this.formData);
    /*}
    handlenoOfAdvisors(event) {
        this.noOfAdvisorsVal = event.target.value;
        //this.formData.noOfAdvisors = this.noOfAdvisorsVal;
        //this.formData.push({noOfAdvisors:this.noOfAdvisorsVal});
        //this.formData = [...this.formData,{noOfAdvisors:this.noOfAdvisorsVal}];
        this.formData.noOfAdvisors = this.noOfAdvisorsVal;
    
        const selectednoOfAdvisors = new CustomEvent("noOfAdvisorschange", {
            detail: this.formData
        });
    
        // Dispatches the event.
        this.dispatchEvent(selectednoOfAdvisors);
    
        // console.log(this.formData);
    }
    handlelegalEntityType(event) {
        this.formData.legalEntity = event.target.value;
        /*this.formData.legalEntityType = event.target.value;
        //this.formData.push({legalEntityType:this.legalEntityTypeVal});
        //this.formData = [...this.formData,{legalEntityType:this.legalEntityTypeVal}];
        this.formData.legalEntityType = this.legalEntityTypeVal;
    
        const selectedlegalEntityType = new CustomEvent("legalEntityTypechange", {
            detail: this.formData
        });
    
        // Dispatches the event.
        this.dispatchEvent(selectedlegalEntityType);
    
        //console.log(this.formData);*/
    /*}
    handlecurrentRegistration(event) {
        this.formData.currentRegistration = event.target.value;
        /*this.formData.currentRegistration = event.target.value;
        
    // this.formData.push({currentRegistration:this.currentRegistrationVal});
    // this.formData = [...this.formData,{currentRegistration:this.currentRegistrationVal}];
    this.formData.currentRegistration = this.currentRegistrationVal;
    
    const selectedCurrentRegistration = new CustomEvent("currentRegistrationchange", {
        detail: this.formData
    });
    
    // Dispatches the event.
    this.dispatchEvent(selectedCurrentRegistration);
    // console.log(this.formData);*/
    /*}
    @api
    handlecurrentCustodian(event) {
        event.preventDefault();
        this.currentCustodianVal = event.target.value;
        //this.formData.currentCustodian = event.target.value;
        //this.formData.push({currentCustodian:this.currentCustodianVal});
        // this.formData = [...this.formData,{currentCustodian:this.currentCustodianVal}];
        this.formData.currentCustodian = this.currentCustodianVal;
        // console.log(this.formData);
        const selectedCurrentCustodian = new CustomEvent("currentCustodianchange", {
            detail: this.formData,
            bubbles: true,
            composed: true
    
        });
    
        // Dispatches the event.
        this.dispatchEvent(selectedCurrentCustodian);
        //console.log(this.formData);
    }*/
    validateBorrower() {
        let AUMTOT = 0;
        let ContactIDSet = {};
        let bolz = false;
        this.formData.borrowers.forEach(Element => {
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
        this.formData.borrowers.forEach(Element => {
            if (Element.ContactId != null) {
                if (Element.primary) {
                    prime = Element.ContactId;
                }
            }
        });
        return prime;
    }


    handleChange(event) {
        console.log('+event.target.value' + event.target.value);
        this.AdditionalComments = event.target.value;
    }
    saveFormData(event) {
       
        //Madhu added CS-3154 and CS-3348 The characters included are alpha-numeric, full stops, commas, and space
        // var regex = new RegExp('.*([.]{3}).*|.*([\"]{2}).*|.*(\\\\).*');
        console.log('businessDetailsSaveFormData***'+JSON.stringify(this.businessDetails));
        
        var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
        var key = this.businessDetails.businessLegalNameDBA;
        var key1 = this.businessDetails.currentCustodian;
        var key2 = this.AdditionalComments;
        var key5 = this.formData.osjLEName1; //madhu added 4232021
        var key6 = this.formData.osjLEName2; //madhu added 4232021
        var key7 = this.formData.osjLEName3; //madhu added 4232021
        var key8 = this.formData.osjLEName4; //madhu added 4232021
        var key9 = this.formData.osjLEName5; //madhu added 4232021

        var searchAddtionalCom = this.template.querySelector(".Addcomment");


        var searchAddosjLEName1 = this.template.querySelector(".AddosjLEName1");
        var searchAddosjLEName2 = this.template.querySelector(".AddosjLEName2");
        var searchAddosjLEName3 = this.template.querySelector(".AddosjLEName3");
        var searchAddosjLEName4 = this.template.querySelector(".AddosjLEName4");
        var searchAddosjLEName5 = this.template.querySelector(".AddosjLEName5");

        var saveRecord = true;
        //var searchAddosjLEName11 = this.template.querySelector(".AddosjLEName11");

        // if ((key != null && key != '' && !regex.test(key)) || (key1 != null && key1 != '' && !regex.test(key1))) { 
        // if ((key2 != null && key2 != '' && !regex.test(key2))) { 
        //   console.log('******key');  
        // }
        // console.log('Businessnamenotsaved'+this.template.querySelector("c-t-a-business-details").showError(''));
        if (this.template.querySelector("c-t-a-business-details") != null && this.template.querySelector("c-t-a-business-details") != undefined) {
            this.template.querySelector("c-t-a-business-details").showError('');
        }


        if ((key2 != null && key2 != '' && !regex.test(key2))) {
            saveRecord = false;
            searchAddtionalCom.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddtionalCom.reportValidity();
        } else if (searchAddtionalCom != null) {
            searchAddtionalCom.setCustomValidity("");
            searchAddtionalCom.reportValidity();

        }
        // madhu added key5 to key9 on 4223021 below lines

        if ((key5 != null && key5 != '' && !regex.test(key5))) {
            saveRecord = false;
            searchAddosjLEName1.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName1.reportValidity();
        } else if (searchAddosjLEName1 != null) {
            searchAddosjLEName1.setCustomValidity("");
            searchAddosjLEName1.reportValidity();
        }

        if ((key6 != null && key6 != '' && !regex.test(key6))) {
            saveRecord = false;
            searchAddosjLEName2.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName2.reportValidity();
        } else if (searchAddosjLEName2 != null) {
            searchAddosjLEName2.setCustomValidity("");
            searchAddosjLEName2.reportValidity();
        }

        if ((key7 != null && key7 != '' && !regex.test(key7))) {
            saveRecord = false;
            searchAddosjLEName3.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName3.reportValidity();

        } else if (searchAddosjLEName3 != null) {
            searchAddosjLEName3.setCustomValidity("");
            searchAddosjLEName3.reportValidity();
        }

        if ((key8 != null && key8 != '' && !regex.test(key8))) {
            saveRecord = false;
            searchAddosjLEName4.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName4.reportValidity();
        } else if (searchAddosjLEName4 != null) {
            searchAddosjLEName4.setCustomValidity("");
            searchAddosjLEName4.reportValidity();
        }

        if ((key9 != null && key9 != '' && !regex.test(key9))) {
            saveRecord = false;
            searchAddosjLEName5.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName5.reportValidity();

        } else if (searchAddosjLEName5 != null) {
            searchAddosjLEName5.setCustomValidity("");
            searchAddosjLEName5.reportValidity();
        }

        if ((key != null && key != '' && !regex.test(key)) || (key1 != null && key1 != '' && !regex.test(key1))) {

            var business = '';
            var firmName = '';
            if (key1 != null && key1 != '' && !regex.test(key1)) {
                saveRecord = false;
                firmName = 'currentCustodian';
            }
            if (key != null && key != '' && !regex.test(key)) {
                saveRecord = false;
                business = 'businessLegalNameDBA';
            }

            this.template.querySelector("c-t-a-business-details").showError(business, firmName);
        }
        if (saveRecord == true) {

            // this.formData.AdditionalComment = this.template.querySelector('[data-id="AdditionalComment"]') == null ? '' : this.template.querySelector('[data-id="AdditionalComment"]').value;
            this.formData.AdditionalComment = this.AdditionalComments;
            // CS-4205 Update Legal Entity field on TA application by Madhukar Reddy on 6/15/2021 Start
            
           if(this.formData["legalEntity"] ==null){
            this.formData["legalEntity"] ="Individual";
           }
           // CS-4205 Update Legal Entity field on TA application by Madhukar Reddy on 6/15/2021 Ended
            console.log('this.formData----' + JSON.stringify(this.formData));
            console.log('this.recordId----' + JSON.stringify(this.recordId));
            let finalArr;
            this.loading = true;
            finalArr = Object.assign({}, this.formData);
            console.log('finalArr.borrowers@@@' + finalArr.borrowers)
            if (finalArr.borrowers != null) {
                if (!this.validateBorrower()) {
                    this.loading = false;
                    alert('Please Check Borrower Contact for duplicate  or sum of all Split  % of AUM should not be greater than 100');
                    return;
                }


                var PrimeId = this.getPrimaryContact();
                if (PrimeId != undefined || PrimeId != null) {


                    checkContactStatus({
                            'ContactId': PrimeId,
                            'RecordTypeName': 'Transition Assistance'
                        })
                        .then(suc => {
                            if (suc) {
                                this.loading = false;
                                alert('This Customer already has an opened Loan Application or this Contact is Terminated.');
                            } else {
                                if (this.pageValidation) {

                                    this.saveLA();
                                }
                            }
                        })
                        .catch(er => {
                            //Commented by Amol 09/08
                            //alert('Unable to create Loan App');
                        });
                } else {

                    if (this.pageValidation) {

                        this.saveLA();
                    }
                }
            } else {

                if (this.pageValidation) {

                    this.saveLA();
                }
            }
        }
    }
    saveLA() {

        this.formData.AdditionalComment = this.template.querySelector('[data-id="AdditionalComment"]') == null ? '' : this.template.querySelector('[data-id="AdditionalComment"]').value;
        console.log('this.formData----' + JSON.stringify(this.formData));
        console.log('this.recordId----' + JSON.stringify(this.recordId));
        let finalArr;

        finalArr = Object.assign({}, this.formData);
        console.log('finalArr.borrowers@@@' + finalArr.borrowers)
        if (finalArr.borrowers != null) {
            if (!this.validateBorrower()) {
                this.loading = false;
                alert('Please Check Borrower Contact for duplicate  or sum of all Split  % of AUM should not be greater than 100');
                return;
            }
            finalArr.borrowers.forEach(Element => {
                if (Element.pAUM > 100) {
                    this.loading = false;
                    alert('% Split of AUM should be less than 100');
                    return;
                }
                //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
                if (Element.loanSplit > 100) {
                    this.loading = false;
                    alert('% Split of Sub Loan should be less than 100');
                    return;
                }
                if (Element.repayableSplit > 100) {
                    this.loading = false;
                    alert('% Split of Repayable be less than 100');
                    return;
                }
                if (Element.backendSplit > 100) {
                    this.loading = false;
                    alert('% Split of Backend should be less than 100');
                    return;
                }
                if (Element.Contact != null && Element.Contact.Name != null) {
                    Element['BName'] = Element.Contact.Name;
                } //End

                delete Element.Contact;
            });
        }
        console.log('$$$$$$$$$$$$$$' + JSON.stringify(finalArr));
        //alert(JSON.stringify(finalArr));
        this.loading = true; // Show Spinner
        saveLoanRec({
            loanobj: JSON.stringify(finalArr),
            opportunity: this.recordId
        }).then(res => {
            console.log('res' + res);
            if (res != null) {
                //if (document.referrer.indexOf(".lightning.force.com") > 0) {
                if (window.location.href.indexOf(".lightning.force.com") > 0) {
                    let nav = {
                        type: "standard__recordPage",
                        attributes: {
                            recordId: res,
                            objectApiName: "Loan_Application__c",
                            actionName: "view"
                        }
                    };
                    this[NavigationMixin.Navigate](nav);
                } else {
                    // https://lplmainorg--finance.lightning.force.com/lightning/r/Loan_Application__c/a000R000002oLXkQAM/view
                    // window.location.assign('');
                    console.log('--' + window.location.href);
                    let oldURL = window.location.href;
                    console.log('--' + window.location.protocol + '//' + window.location.host);
                    //let urltemp =window.location.protocol+'//'+window.location.href ;
                    oldURL = oldURL.replace("--c.visualforce.com/apex/customUIVF", ".lightning.force.com/lightning/r/Loan_Application__c/" + res + "/view");
                    console.log('--->' + oldURL);
                    //window.location.assign(oldURL);
                    window.parent.location = '/' + res; //used to view record in Classic View
                }
            } else {
                alert('Unable to Save Loan Application');
            }

        }).catch(err => {
            // alert('test');
            // alert(JSON.stringify(err));
            //console.log('err.body' + err.body.message);
            if (err.body.message == "Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, This Customer already has an Opened Loan Application: []") {
                alert("Unable to Save Loan Application. This Customer already has an Opened Loan Application");
            } else {
                alert('Unable to Save Loan Application');
                //alert(err.body.message);
            }
        });
    }

    calculateTotalAUM(event) {
        /* this.mfdh = 0;
        this.mfc = 0;
        this.va = 0;
        this.fa = 0;
        this.fi = 0;
        this.eq = 0;
        this.aiuitCash = 0;
        this.totAdvAum = 0;*/
        //event.preventdefault();

        // eslint-disable-next-line no-unused-vars
        if (event.target.name === 'mfdh') {
            this.mfdh = isNaN(this.mfdh) ? 0 : this.mfdh;

            this.totAUM = this.totAUM - this.mfdh;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.mfdh = Number(parseFloat(event.target.value).toFixed(2));
            this.mfdh = isNaN(this.mfdh) ? 0 : this.mfdh;
            //this.finacialDetailsData = [...this.finacialDetailsData,{mfdh:this.mfdh}];
            this.formData.mutualFundsDirectlyHeld = this.mfdh;
            this.totAUM += this.mfdh;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAUM = this.totAUM.toFixed(2);
            this.formData.advisorTotalAUM = this.totAUM;
            this.BorrowerData.borrowerData.TotalAUM = this.totAUM;
            //console.log(parseInt(this.mfdh));
        } else if (event.target.name === 'mfc') {
            this.mfc = isNaN(this.mfc) ? 0 : this.mfc;

            //this.mfc = 0;
            this.totAUM = this.totAUM - this.mfc;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.mfc = Number(parseFloat(event.target.value).toFixed(2));
            this.mfc = isNaN(this.mfc) ? 0 : this.mfc;
            // this.finacialDetailsData = [...this.finacialDetailsData,{mfc:this.mfc}];
            this.formData.mutualFundsCustodied = this.mfc;
            this.totAUM += this.mfc;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAUM = this.totAUM.toFixed(2);
            this.formData.advisorTotalAUM = this.totAUM;
            this.BorrowerData.borrowerData.TotalAUM = this.totAUM;
        } else if (event.target.name === 'va') {
            this.va = isNaN(this.va) ? 0 : this.va;

            //this.va = 0;
            this.totAUM = this.totAUM - this.va;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.va = Number(parseFloat(event.target.value).toFixed(2));
            this.va = isNaN(this.va) ? 0 : this.va;
            // this.finacialDetailsData = [...this.finacialDetailsData,{va:this.va}];
            this.formData.variableAnnuties = this.va;
            this.totAUM += this.va;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAUM = this.totAUM.toFixed(2);
            this.formData.advisorTotalAUM = this.totAUM;
            this.BorrowerData.borrowerData.TotalAUM = this.totAUM;
        } else if (event.target.name === 'fa') {
            this.fa = isNaN(this.fa) ? 0 : this.fa;

            //this.fa = 0;
            this.totAUM = this.totAUM - this.fa;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.fa = Number(parseFloat(event.target.value).toFixed(2));
            this.fa = isNaN(this.fa) ? 0 : this.fa;
            //this.finacialDetailsData = [...this.finacialDetailsData,{fa:this.fa}];
            this.formData.fixedAnnuties = this.fa;
            this.totAUM += this.fa;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.formData.advisorTotalAUM = this.totAUM;
            this.BorrowerData.borrowerData.TotalAUM = this.totAUM;
        } else if (event.target.name === 'fi') {
            this.fi = isNaN(this.fi) ? 0 : this.fi;

            // this.fi = 0;
            this.totAUM = this.totAUM - this.fi;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.fi = Number(parseFloat(event.target.value).toFixed(2));
            this.fi = isNaN(this.fi) ? 0 : this.fi;
            //this.finacialDetailsData = [...this.finacialDetailsData,{fi:this.fi}];
            this.formData.fixedIncome = this.fi;
            this.totAUM += this.fi;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAUM = this.totAUM.toFixed(2);
            this.formData.advisorTotalAUM = this.totAUM;
            this.BorrowerData.borrowerData.TotalAUM = this.totAUM;
            console.log('BBBBBBBB-------' + this.fi);
        } else if (event.target.name === 'eq') {
            this.eq = isNaN(this.eq) ? 0 : this.eq;

            // this.eq = 0;
            this.totAUM = this.totAUM - this.eq;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.eq = Number(parseFloat(event.target.value).toFixed(2));
            this.eq = isNaN(this.eq) ? 0 : this.eq;
            //this.finacialDetailsData = [...this.finacialDetailsData,{eq:this.eq}];
            this.formData.equity = this.eq;
            this.totAUM += this.eq;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAUM = this.totAUM.toFixed(2);
            this.formData.advisorTotalAUM = this.totAUM;
            this.BorrowerData.borrowerData.TotalAUM = this.totAUM;
        } else if (event.target.name === 'aiuitCash') {
            this.aiuitCash = isNaN(this.aiuitCash) ? 0 : this.aiuitCash;

            //this.aiuitCash = 0;
            this.totAUM = this.totAUM - this.aiuitCash;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.aiuitCash = Number(parseFloat(event.target.value).toFixed(2));
            this.aiuitCash = isNaN(this.aiuitCash) ? 0 : this.aiuitCash;
            //this.finacialDetailsData = [...this.finacialDetailsData,{aiuitCash:this.aiuitCash}];
            this.formData.aiUITCash = this.aiuitCash;
            this.totAUM += this.aiuitCash;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAUM = this.totAUM.toFixed(2);
            this.formData.advisorTotalAUM = this.totAUM;
            this.BorrowerData.borrowerData.TotalAUM = this.totAUM;
        } else if (event.target.name === 'totAdvAum') {
            this.totAdvAum = isNaN(this.totAdvAum) ? 0 : this.totAdvAum;

            //this.totAdvAum = 0;
            this.totAUM = this.totAUM - this.totAdvAum;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAdvAum = Number(parseFloat(event.target.value).toFixed(2));
            this.totAdvAum = isNaN(this.totAdvAum) ? 0 : this.totAdvAum;
            //this.finacialDetailsData = [...this.finacialDetailsData,{totAdvAum:this.totAdvAum}];
            this.formData.totalAdvisoryAUM = this.totAdvAum;
            this.totAUM += this.totAdvAum;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAUM = this.totAUM.toFixed(2);
            this.formData.advisorTotalAUM = this.totAUM;
            this.BorrowerData.borrowerData.TotalAUM = this.totAUM;
        }

        //this.totAUM = this.mfdh+this.mfc+this.va+this.fa+this.fi+this.eq+this.aiuitCash+this.totAdvAum;
        /* this.totAUM = parseInt(this.mfdh)+
                        parseInt(this.mfc)+
                        parseInt(this.va)+
                        parseInt(this.fa)+
                        parseInt(this.fi)+
                        parseInt(this.eq)+
                        parseInt(this.aiuitCash)+
                        parseInt(this.totAdvAum);*/
        // console.log(parseInt(this.totAUM));
        this.calculateviaapi();
        this.calculateBorrower();
    }

    calculateTotalProduction(event) {

        if (event.target.name === 'advRev') {
            this.advRev = isNaN(this.advRev) ? 0 : this.advRev;
            this.totProduction = this.totProduction - this.advRev;
            this.totProduction = isNaN(this.totProduction) ? 0 : this.totProduction;
            this.advRev = Number(parseFloat(event.target.value).toFixed(2));
            this.advRev = isNaN(this.advRev) ? 0 : this.advRev;
            //this.finacialDetailsData = [...this.finacialDetailsData,{advRev:this.advRev}];
            this.formData.advisoryRevenue = this.advRev;
            this.totProduction += this.advRev;
            this.totProduction = isNaN(this.totProduction) ? 0 : this.totProduction;
            this.totProduction = this.totProduction.toFixed(2);
            this.formData.totalProduction = this.totProduction;
            //console.log(parseInt(this.advRev));
        } else if (event.target.name === 'broRev') {
            this.broRev = isNaN(this.broRev) ? 0 : this.broRev;
            //this.broRev = 0;
            this.totProduction = this.totProduction - this.broRev;
            this.totProduction = isNaN(this.totProduction) ? 0 : this.totProduction;
            this.broRev = Number(parseFloat(event.target.value).toFixed(2));
            this.broRev = isNaN(this.broRev) ? 0 : this.broRev;
            //this.finacialDetailsData = [...this.finacialDetailsData,{broRev:this.broRev}];
            this.formData.brokerageRevenue = this.broRev;
            this.totProduction += this.broRev;
            this.totProduction = isNaN(this.totProduction) ? 0 : this.totProduction;
            this.totProduction = this.totProduction.toFixed(2);
            this.formData.totalProduction = this.totProduction;
        }
        this.calculateviaapi();

    }
    @api
    calculateviaapi() {
        try {
            //alert('u called mr ');
            let data = {
                'mfdh': this.template.querySelector('[data-id="mfdh"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="mfdh"]').value),
                'mfc': this.template.querySelector('[data-id="mfc"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="mfc"]').value),
                'totMFC': this.template.querySelector('[data-id="mfdh"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="mfdh"]').value) + this.template.querySelector('[data-id="mfc"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="mfc"]').value),
                'va': this.template.querySelector('[data-id="va"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="va"]').value),
                'fa': this.template.querySelector('[data-id="fa"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="fa"]').value),
                'fi': this.template.querySelector('[data-id="fi"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="fi"]').value),
                'eq': this.template.querySelector('[data-id="eq"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="eq"]').value),
                'aiuitCash': this.template.querySelector('[data-id="aiuitCash"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="aiuitCash"]').value),
                'broRev': this.template.querySelector('[data-id="broRev"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="broRev"]').value),
                'advRev': this.template.querySelector('[data-id="advRev"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="advRev"]').value),
                'totAdvAum': this.template.querySelector('[data-id="totAdvAum"]').value == 0 ? 0 : parseInt(this.template.querySelector('[data-id="totAdvAum"]').value)
            };
            //alert(JSON.stringify(data));
            this.totProduction = data.advRev + data.broRev;
            this.totBAUM = data.mfc + data.mfdh + data.va + data.fi + data.fa + data.eq + data.aiuitCash;
            this.totAUM = this.totBAUM + data.totAdvAum;
            this.TotMFC = data.mfdh + data.mfc;
            try {
                this.GDC = (this.totProduction / this.totAUM) * 100; // CS-2351 MOdified BY Amol 10/13/2020
                this.GDC = isNaN(this.GDC) ? 0 : this.GDC;
                console.log(this.GDC);
            } catch (e) {
                this.GDC = 0;
                console.log('catch' + this.GDC);
            }

            this.PercentData = {
                'mfdh': 0,
                'mfc': 0,
                'totMFC': 0,
                'va': 0,
                'fa': 0,
                'fi': 0,
                'eq': 0,
                'aiuitCash': 0,
                'broRev': 0,
                'advRev': 0,
                'totAdvAum': 0,
                'totBAUM': 0,
                'totAUM': 0
            }
            try {
                this.PercentData.mfdh = ((data.mfdh / this.totAUM) * 100).toFixed(2);
                this.PercentData.mfdh = isNaN(this.PercentData.mfdh) ? 0 : this.PercentData.mfdh;
            } catch (e) {
                this.PercentData.mfdh = 0;
            }

            try {
                console.log(this.mfdh);
                console.log(this.totAUM);
                this.PercentData.totAdvAum = ((data.totAdvAum / this.totAUM) * 100).toFixed(2);
                this.PercentData.totAdvAum = isNaN(this.PercentData.totAdvAum) ? 0 : this.PercentData.totAdvAum;
            } catch (e) {
                this.PercentData.totAdvAum = 0;

            }

            try {
                console.log("This total brokerage funds" + this.totBAUM);
                console.log("This toral aum" + this.totAUM);
                console.log("This total sume" + this.totBAUM / this.totAum);
                this.PercentData.totBAUM = (((data.mfc + data.mfdh + data.va + data.fi + data.fa + data.eq + data.aiuitCash) / this.totAUM) * 100).toFixed(2);
                this.PercentData.totBAUM = isNaN(this.PercentData.totBAUM) ? 0 : this.PercentData.totBAUM;
            } catch (e) {
                this.PercentData.totBAUM = 0;

            }
            try {
                console.log(this.mfdh);
                console.log(this.totAUM);
                this.PercentData.totAUM = ((this.totAUM / this.totAUM) * 100).toFixed(2);
                this.PercentData.totAUM = isNaN(this.PercentData.totAUM) ? 0 : this.PercentData.totAUM;
            } catch (e) {
                this.PercentData.totAUM = 0;

            }




            try {
                this.PercentData.mfc = ((data.mfc / this.totAUM) * 100).toFixed(2);
                this.PercentData.mfc = isNaN(this.PercentData.mfc) ? 0 : this.PercentData.mfc;
            } catch (e) {
                this.PercentData.mfc = 0;
            }
            try {
                this.PercentData.totMFC = ((this.TotMFC / this.totAUM) * 100).toFixed(2);
                this.PercentData.totMFC = isNaN(this.PercentData.mfc) ? 0 : this.PercentData.totMFC;
            } catch (e) {
                this.PercentData.totMFC = 0;
            }
            try {
                this.PercentData.va = ((data.va / this.totAUM) * 100).toFixed(2);
                this.PercentData.va = isNaN(this.PercentData.va) ? 0 : this.PercentData.va;
            } catch (e) {
                this.PercentData.va = 0;
            }
            try {
                this.PercentData.fa = ((data.fa / this.totAUM) * 100).toFixed(2);
                this.PercentData.fa = isNaN(this.PercentData.fa) ? 0 : this.PercentData.fa;
            } catch (e) {
                this.PercentData.fa = 0;
            }
            try {
                this.PercentData.eq = ((data.eq / this.totAUM) * 100).toFixed(2);
                this.PercentData.eq = isNaN(this.PercentData.eq) ? 0 : this.PercentData.eq;
            } catch (e) {
                this.PercentData.eq = 0;
            }
            try {
                this.PercentData.fi = ((data.fi / this.totAUM) * 100).toFixed(2);
                this.PercentData.fi = isNaN(this.PercentData.fi) ? 0 : this.PercentData.fi;
            } catch (e) {
                this.PercentData.fi = 0;
            }
            try {
                this.PercentData.aiuitCash = ((data.aiuitCash / this.totAUM) * 100).toFixed(2);
                this.PercentData.aiuitCash = isNaN(this.PercentData.aiuitCash) ? 0 : this.PercentData.aiuitCash;
            } catch (e) {
                this.PercentData.aiuitCash = 0;
            }
        } catch (e) {

        }


    }

    /*get rowsBrow() {
    return this.myArrayBrow;
    }*/

    handleClickBrow() {
        var arrLength = this.myArrayBrow.length + 1;
        var currentArray = this.myArrayBrow;

        //var newRow = [{ label: '', value: '', index: arrLength ,showBrow:true}];
        var newRow = [{
            'BorrowerName': '',
            'SplitofTotalAUM': '',
            'AUMAttributable': '',
            'PrimaryContact': false,
            index: arrLength,
            showBrow: true
        }];
        currentArray.push(newRow[0]);
        this.myArrayBrow = currentArray;
        //console.log(arrLength);
        //this.borrowerIndex = arrLength;
        this.BorrowerData.borrowerData.rowCount = arrLength;
        //this.formData.borrowers += this.selectRecordId;
        console.log(this.BorrowerData.borrowerData.rowCount);
    }


    handleDeleteBrow(event) {
        const textVal = event.detail;
        var currentArray = this.myArrayBrow;
        var i;
        if (textVal > -1) {
            currentArray.splice(textVal - 1, 1);
        }
        for (i = 0; i < currentArray.length;) {
            currentArray[i].index = ++i;
        }
        this.myArrayBrow = currentArray;
    }

    handleRadioChange(event) {
        const checkBoxValue = event.detail;
        //console.log(checkBoxValue);
    }
    deleterow(event) {
        event.preventDefault();
        //const a = 1;

        const selectEvent = new CustomEvent('inptext', {
            detail: this.rowBrowRow.index
        });
        this.dispatchEvent(selectEvent);
    }

    get options() {
        return [{
            label: 'Primary Contact',
            value: 'option1'
        }];
    }

    handleprimaryChange(event) {
        //event.preventDefault();
        this.formData.primaryContact = true;
        this.primaryConValue = true;
        //console.log(this.formData.primaryContact);
        //console.log(this.primaryConValue);
        //const a = 1;

        /* const selectEvent = new CustomEvent('radioselect', {
            //detail: this.rowBrowRow.index
            detail: this.row.index
        });
        this.dispatchEvent(selectEvent);*/
    }

    handleSplitOfAUM(event) {
        this.splitOfSumAUM = event.target.value;
        this.aumAttributableVal = parseFloat((this.totAUM * this.splitOfSumAUM) / 100);
        console.log(this.aumAttributableVal);
        this.formData.splitOfSumAUM = this.splitOfSumAUM;
        console.log(this.formData.splitOfSumAUM);
        this.formData.aumAttributable = this.aumAttributableVal;
    }

    searchField(event) {
        var currentText = event.target.value;
        this.LoadingText = true;

        getResults({
                ObjectName: this.objectName,
                fieldName: this.fieldName,
                value: currentText
            })
            .then(result => {
                this.searchRecords = result;
                this.LoadingText = false;

                this.txtclassname = result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
                if (currentText.length > 0 && result.length === 0) {
                    this.messageFlag = true;
                } else {
                    this.messageFlag = false;
                }

                if (this.selectRecordId != null && this.selectRecordId.length > 0) {
                    this.iconFlag = false;
                    this.clearIconFlag = true;
                } else {
                    this.iconFlag = true;
                    this.clearIconFlag = false;
                }
            })
            .catch(error => {});

    }

    // CH01 Start
    handletabusinessdetails(event) {

        //this.businessDetails = event.detail[0];
        let buTA = Object.keys(event.detail)[0];
        console.log('1' + buTA);
        Object.keys(this.businessDetails).forEach(element => {
            console.log('2' + element);
            if (buTA == element) {
                this.businessDetails[element] = event.detail[buTA];
                this.formData[element] = event.detail[buTA];
            }
            console.log('businessdetails' + JSON.stringify(this.businessDetails));
            console.log('businessdetials1' + this.formData);
        });
          

        //this.currentRegistration = this.businessDetails.currentRegistration;
        /* this.formData.currentRegistration = event.detail.currentRegistration;
    
        this.legalEntity = this.businessDetails.legalEntity;
        this.formData.legalEntity = event.detail.legalEntity;
    
        this.noOfAdvisors = this.businessDetails.noOfAdvisors;
        this.formData.noOfAdvisors = event.detail.noOfAdvisors;
    
        this.businessLegalNameDBA = this.businessDetails.businessLegalNameDBA;
        this.formData.businessLegalNameDBA = event.detail.businessLegalNameDBA;
    
        this.currentCustodian = this.businessDetails.currentCustodian;
        this.formData.currentCustodian = event.detail.currentCustodian;*/

    }

    handleBDBA(event) {
        console.log('dba' + event.detail);
        //this.businessLegalNameDBAVal = event.detail;
        //this.formData.businessLegalNameDBA = event.detail;

    }

    handleCurrentCustodian(event) {
        // this.currentCustodianVal = event.detail;
        // this.formData.currentCustodian = event.detail;

    }
    // CH01 End
    handleBorrower(event) {
        //alert(JSON.stringify(event.detail));
        this.borrowerDataMaster = event.detail;
        this.calculateBorrower();
    }

    calculateBorrower() {
        //alert('d');

        let Arr = [];
        let count = 0;
        //alert(JSON.stringify(this.Data.BorrowerInfo));
        if (this.borrowerDataMaster != null) {
            this.borrowerDataMaster.forEach(Element => {
                if (this.formData.advisorTotalAUM != 0 && this.formData.advisorTotalAUM != null && Element.pAUM != 0 && Element.pAUM != null) {
                    Element.AUMATT = parseFloat((this.formData.advisorTotalAUM * Element.pAUM) / 100).toFixed(2);
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
            this.borrowerDataMaster = Arr;
            this.formData.borrowers = this.borrowerDataMaster;
        }
    }
    setSelectedRecord(event) {
        var currentText = event.currentTarget.dataset.id;
        var selectName;
        this.txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.iconFlag = false;
        this.clearIconFlag = true;
        this.selectRecordName = event.currentTarget.dataset.name;
        selectName = event.currentTarget.dataset.name;
        this.selectRecordId = currentText;
        this.inputReadOnly = true;

        console.log('RecID' + this.selectRecordId + 'RecName' + this.selectRecordName + 'Name' + this.selectName + 'Text' + this.currentText);
        this.formData.borrowerId = this.selectRecordId;
        this.formData.borrowerName = this.selectRecordName;
        this.formData.primaryContact = true;
        const selectedEvent = new CustomEvent('selected', {
            detail: {
                selectName
            }
        });
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

    percentageSplitAUM(event) {


    }

    handleClickPro() {
        this.showProRow = true;
        if (this.formData.rowProRow == 1) {
            this.formData.rowProRow = 2;
            this.showProRow2 = true;
        } else if (this.formData.rowProRow == 2) {
            this.showProRow3 = true;
            this.formData.rowProRow = 3;
        } else if (this.formData.rowProRow == 3) {
            this.showProRow4 = true;
            this.formData.rowProRow = 4;
        } else if (this.formData.rowProRow == 4) {
            this.showProRow5 = true;
            this.showPRO = false;
            this.formData.rowProRow = 5;
        }
    }

    deleterowProRow2() {
        if (this.formData.rowProRow >= 3) {
            this.formData.platformPicklist2 = this.formData.platformPicklist3;
            this.formData.branchPicklist2 = this.formData.branchPicklist3;
            this.formData.osjLEName2 = this.formData.osjLEName3;
            this.formData.termLength2 = this.formData.termLength3;
            this.formData.uWTypePicklist2 = this.formData.uWTypePicklist3;
            this.formData.campaignPicklist2 = this.formData.campaignPicklist3;
        }
        if (this.formData.rowProRow >= 4) {
            this.formData.platformPicklist3 = this.formData.platformPicklist4;
            this.formData.branchPicklist3 = this.formData.branchPicklist4;
            this.formData.osjLEName3 = this.formData.osjLEName4;
            this.formData.termLength3 = this.formData.termLength4;
            this.formData.uWTypePicklist3 = this.formData.uWTypePicklist4;
            this.formData.campaignPicklist3 = this.formData.campaignPicklist4;
        }
        if (this.formData.rowProRow == 5) {
            this.formData.platformPicklist4 = this.formData.platformPicklist5;
            this.formData.branchPicklist4 = this.formData.branchPicklist5;
            this.formData.osjLEName4 = this.formData.osjLEName5;
            this.formData.termLength4 = this.formData.termLength5;
            this.formData.uWTypePicklist4 = this.formData.uWTypePicklist5;
            this.formData.campaignPicklist4 = this.formData.campaignPicklist4;
        }
        if (this.formData.rowProRow == 5) {
            this.showProRow5 = false;
            this.formData.platformPicklist5 = 'Corporate';
            this.formData.branchPicklist5 = 'Branch/LE';
            this.formData.osjLEName5 = '';
            this.formData.termLength5 = '5 Years';
            this.formData.uWTypePicklist5 = 'Standard';
            this.formData.campaignPicklist5 = 'Other';
        } else if (this.formData.rowProRow == 4) {
            this.showProRow4 = false;
            this.formData.platformPicklist4 = 'Corporate';
            this.formData.branchPicklist4 = 'Branch/LE';
            this.formData.osjLEName4 = '';
            this.formData.termLength4 = '5 Years';
            this.formData.uWTypePicklist4 = 'Standard';
            this.formData.campaignPicklist4 = 'Other';
        } else if (this.formData.rowProRow == 3) {
            this.showProRow3 = false;
            this.formData.platformPicklist3 = 'Corporate';
            this.formData.branchPicklist3 = 'Branch/LE';
            this.formData.osjLEName3 = '';
            this.formData.termLength3 = '5 Years';
            this.formData.uWTypePicklist3 = 'Standard';
            this.formData.campaignPicklist3 = 'Other';
        } else if (this.formData.rowProRow == 2) {
            this.showProRow2 = false;
            this.formData.platformPicklist2 = 'Corporate';
            this.formData.branchPicklist2 = 'Branch/LE';
            this.formData.osjLEName2 = '';
            this.formData.termLength2 = '5 Years';
            this.formData.uWTypePicklist2 = 'Standard';
            this.formData.campaignPicklist2 = 'Other';
        }
        var rowVal = this.formData.rowProRow;
        this.formData.rowProRow = rowVal - 1;
        this.showPRO = true;
    }

    deleterowProRow3() {
        if (this.formData.rowProRow >= 4) {
            this.formData.platformPicklist3 = this.formData.platformPicklist4;
            this.formData.branchPicklist3 = this.formData.branchPicklist4;
            this.formData.osjLEName3 = this.formData.osjLEName4;
            this.formData.termLength3 = this.formData.termLength4;
            this.formData.uWTypePicklist3 = this.formData.uWTypePicklist4;
            this.formData.campaignPicklist3 = this.formData.campaignPicklist4;
        }
        if (this.formData.rowProRow == 5) {
            this.formData.platformPicklist4 = this.formData.platformPicklist5;
            this.formData.branchPicklist4 = this.formData.branchPicklist5;
            this.formData.osjLEName4 = this.formData.osjLEName5;
            this.formData.termLength4 = this.formData.termLength5;
            this.formData.uWTypePicklist4 = this.formData.uWTypePicklist5;
            this.formData.campaignPicklist4 = this.formData.campaignPicklist5;
        }
        if (this.formData.rowProRow == 5) {
            this.showProRow5 = false;
            this.formData.platformPicklist5 = 'Corporate';
            this.formData.branchPicklist5 = 'Branch/LE';
            this.formData.osjLEName5 = '';
            this.formData.termLength5 = '5 Years';
            this.formData.uWTypePicklist5 = 'Standard';
            this.formData.campaignPicklist5 = 'Other';
        } else if (this.formData.rowProRow == 4) {
            this.showProRow4 = false;
            this.formData.platformPicklist4 = 'Corporate';
            this.formData.branchPicklist4 = 'Branch/LE';
            this.formData.osjLEName4 = '';
            this.formData.termLength4 = '5 Years';
            this.formData.uWTypePicklist4 = 'Standard';
            this.formData.campaignPicklist4 = 'Other';
        } else if (this.formData.rowProRow == 3) {
            this.showProRow3 = false;
            this.formData.platformPicklist3 = 'Corporate';
            this.formData.branchPicklist3 = 'Branch/LE';
            this.formData.osjLEName3 = '';
            this.formData.termLength3 = '5 Years';
            this.formData.uWTypePicklist3 = 'Standard';
            this.formData.campaignPicklist3 = 'Other';
        }
        var rowVal = this.formData.rowProRow;
        this.formData.rowProRow = rowVal - 1;
        this.showPRO = true;
    }

    deleterowProRow4() {
        if (this.formData.rowProRow == 5) {
            this.formData.platformPicklist4 = this.formData.platformPicklist5;
            this.formData.branchPicklist4 = this.formData.branchPicklist5;
            this.formData.osjLEName4 = this.formData.osjLEName5;
            this.formData.termLength4 = this.formData.termLength5;
            this.formData.uWTypePicklist4 = this.formData.uWTypePicklist5;
            this.formData.campaignPicklist4 = this.formData.campaignPicklist5;
            this.showProRow5 = false;

            this.formData.platformPicklist5 = 'Corporate';
            this.formData.branchPicklist5 = 'Branch/LE';
            this.formData.osjLEName5 = '';
            this.formData.termLength5 = '5 Years';
            this.formData.uWTypePicklist5 = 'Standard';
            this.formData.campaignPicklist5 = 'Other';
        } else if (this.formData.rowProRow == 4) {
            this.showProRow4 = false;
            this.formData.platformPicklist4 = 'Corporate';
            this.formData.branchPicklist4 = 'Branch/LE';
            this.formData.osjLEName4 = '';
            this.formData.termLength4 = '5 Years';
            this.formData.uWTypePicklist4 = 'Standard';
            this.formData.campaignPicklist4 = 'Other';
        }
        var rowVal = this.formData.rowProRow;
        this.formData.rowProRow = rowVal - 1;
        this.showPRO = true;
    }

    deleterowProRow5() {
        this.formData.platformPicklist5 = 'Corporate';
        this.formData.branchPicklist5 = 'Branch/LE';
        this.formData.osjLEName5 = '';
        this.formData.termLength5 = '5 Years';
        this.formData.uWTypePicklist5 = 'Standard';
        this.formData.campaignPicklist5 = 'Other';
        this.showProRow5 = false;
        this.formData.rowProRow = 4;
        this.showPRO = true;
    }

    platformChange(event) {
        this.formData.platformPicklist1 = event.target.value;
    }
    platformChange2(event) {
        this.formData.platformPicklist2 = event.target.value;
    }
    platformChange3(event) {
        this.formData.platformPicklist3 = event.target.value;
    }
    platformChange4(event) {
        this.formData.platformPicklist4 = event.target.value;
    }
    platformChange5(event) {
        this.formData.platformPicklist5 = event.target.value;
    }

    branchChnage(event) {
        this.formData.branchPicklist1 = event.target.value;
    }
    branchChnage2(event) {
        this.formData.branchPicklist2 = event.target.value;
    }
    branchChnage3(event) {
        this.formData.branchPicklist3 = event.target.value;
    }
    branchChnage4(event) {
        this.formData.branchPicklist4 = event.target.value;
    }
    branchChnage5(event) {
        this.formData.branchPicklist5 = event.target.value;
    }


    OSJLENameChnage1(event) {
        this.formData.osjLEName1 = event.target.value;
    }
    OSJLENameChnage2(event) {
        this.formData.osjLEName2 = event.target.value;
    }
    OSJLENameChnage3(event) {
        this.formData.osjLEName3 = event.target.value;
    }
    OSJLENameChnage4(event) {
        this.formData.osjLEName4 = event.target.value;
    }
    OSJLENameChnage5(event) {
        this.formData.osjLEName5 = event.target.value;
    }

    termLengthChange(event) {
        this.formData.termLength1 = event.target.value;
    }
    termLengthChange2(event) {
        this.formData.termLength2 = event.target.value;
    }
    termLengthChange3(event) {
        this.formData.termLength3 = event.target.value;
    }
    termLengthChange4(event) {
        this.formData.termLength4 = event.target.value;
    }
    termLengthChange5(event) {
        this.formData.termLength5 = event.target.value;
    }
    //Modified By Bhanu 9/9/2020 changes Start  1891
    UWTypePicklistChange(event) {
        this.formData.uWTypePicklist1 = event.target.value;

        if (event.target.value == 'Campaign') {

            this.uWTypePicklist1Disabled = false;

        } else {
            this.formData.campaignPicklist1 = '';
            this.uWTypePicklist1Disabled = true;

        }
    }
    UWTypePicklistChange2(event) {
        this.formData.uWTypePicklist2 = event.target.value;
        if (event.target.value == 'Campaign') {

            this.uWTypePicklist2Disabled = false;

        } else {
            this.formData.campaignPicklist2 = '';
            this.uWTypePicklist2Disabled = true;

        }

    }
    UWTypePicklistChange3(event) {
        this.formData.uWTypePicklist3 = event.target.value;

        if (event.target.value == 'Campaign') {

            this.uWTypePicklist3Disabled = false;

        } else {
            this.formData.campaignPicklist3 = '';
            this.uWTypePicklist3Disabled = true;

        }
    }
    UWTypePicklistChange4(event) {
        this.formData.uWTypePicklist4 = event.target.value;
        if (event.target.value == 'Campaign') {

            this.uWTypePicklist4Disabled = false;

        } else {
            this.formData.campaignPicklist4 = '';
            this.uWTypePicklist4Disabled = true;

        }

    }

    UWTypePicklistChange5(event) {
        this.formData.uWTypePicklist5 = event.target.value;

        if (event.target.value == 'Campaign') {

            this.uWTypePicklist5Disabled = false;

        } else {
            this.formData.campaignPicklist5 = '';
            this.uWTypePicklist5Disabled = true;

        }
    }
    //Changes ends
    campaignChnage(event) {
        this.formData.campaignPicklist1 = event.target.value;
    }

    campaignChnage2(event) {
        this.formData.campaignPicklist2 = event.target.value;
    }

    campaignChnage3(event) {
        this.formData.campaignPicklist3 = event.target.value;
    }

    campaignChnage4(event) {
        this.formData.campaignPicklist4 = event.target.value;
    }

    campaignChnage5(event) {
        this.formData.campaignPicklist5 = event.target.value;
    }

    @track WorkingCapital = false;


    connectedCallback() {
        this.Pageno = 0;
        this.TotalPage = 5;
        this.MidPage = false;
        this.LastPage = false;
        //this.progressbar='width:'+this.Page_Section['Page'+this.Pageno].width+';background:'+this.Page_Section['Page'+this.Pageno].background+';height: 100%;position: absolute;top: 0px;display:block';
        this.istyle = '';
        this.hstyle = '';
        //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
        this.borrowerDataMaster.push({
            ContactId: null,
            Contact: null,
            pAUM: 0,
            AUMATT: 0,
            primary: false,
            Uname: 'Bow1',
            loanSplit: 0,
            backendSplit: 0,
            repayableSplit: 0
        }); //End
        // CH01 Start
        /* this.businessDetails.push({
                'businessLegalNameDBA': null,
                'noOfAdvisors': 0,
                'legalEntity': null,
                'currentRegistration': null,
                'currentCustodian': null
            });*/
        //CH01 End
    }

    parentClick() {
        this.WorkingCapital = false;

    }
    nextPage(event) {
        //Madhu added CS-3154 and CS-3348 The characters included are alpha-numeric, full stops, commas, and space
        // var regex = new RegExp('.*([.]{3}).*|.*([\"]{2}).*|.*(\\\\).*');
        var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
        var key = this.businessDetails.businessLegalNameDBA;
        var key1 = this.businessDetails.currentCustodian;
        var key5 = this.formData.osjLEName1; //madhu added 4242021
        var key6 = this.formData.osjLEName2; //madhu added 4242021
        var key7 = this.formData.osjLEName3; //madhu added 4242021
        var key8 = this.formData.osjLEName4; //madhu added 4242021
        var key9 = this.formData.osjLEName5; //madhu added 4242021          


        var searchAddosjLEName1 = this.template.querySelector(".AddosjLEName1");
        var searchAddosjLEName2 = this.template.querySelector(".AddosjLEName2");
        var searchAddosjLEName3 = this.template.querySelector(".AddosjLEName3");
        var searchAddosjLEName4 = this.template.querySelector(".AddosjLEName4");
        var searchAddosjLEName5 = this.template.querySelector(".AddosjLEName5");


        var nextPage = true;
        //var searchAddosjLEName11 = this.template.querySelector(".AddosjLEName11");

        // if ((key != null && key != '' && !regex.test(key)) || (key1 != null && key1 != '' && !regex.test(key1))) { 
        // if ((key2 != null && key2 != '' && !regex.test(key2))) { 
        //   console.log('******key');  
        // }
        // console.log('Businessnamenotsaved'+this.template.querySelector("c-t-a-business-details").showError(''));
        if (this.template.querySelector("c-t-a-business-details") != null && this.template.querySelector("c-t-a-business-details") != undefined) {
            this.template.querySelector("c-t-a-business-details").showError('');
        }

        // madhu added key5 to key9 on 4223021 below lines

        if ((key5 != null && key5 != '' && !regex.test(key5))) {
            nextPage = false;
            searchAddosjLEName1.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName1.reportValidity();
        } else if (searchAddosjLEName1 != null) {
            searchAddosjLEName1.setCustomValidity("");
            searchAddosjLEName1.reportValidity();
        }

        if ((key6 != null && key6 != '' && !regex.test(key6))) {
            nextPage = false;
            searchAddosjLEName2.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName2.reportValidity();
        } else if (searchAddosjLEName2 != null) {
            searchAddosjLEName2.setCustomValidity("");
            searchAddosjLEName2.reportValidity();
        }

        if ((key7 != null && key7 != '' && !regex.test(key7))) {
            nextPage = false;
            searchAddosjLEName3.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName3.reportValidity();

        } else if (searchAddosjLEName3 != null) {
            searchAddosjLEName3.setCustomValidity("");
            searchAddosjLEName3.reportValidity();
        }

        if ((key8 != null && key8 != '' && !regex.test(key8))) {
            nextPage = false;
            searchAddosjLEName4.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName4.reportValidity();
        } else if (searchAddosjLEName4 != null) {
            searchAddosjLEName4.setCustomValidity("");
            searchAddosjLEName4.reportValidity();
        }

        if ((key9 != null && key9 != '' && !regex.test(key9))) {
            nextPage = false;
            searchAddosjLEName5.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddosjLEName5.reportValidity();

        } else if (searchAddosjLEName5 != null) {
            searchAddosjLEName5.setCustomValidity("");
            searchAddosjLEName5.reportValidity();
        }

        if ((key != null && key != '' && !regex.test(key)) || (key1 != null && key1 != '' && !regex.test(key1))) {

            var business = '';
            var firmName = '';
            if (key1 != null && key1 != '' && !regex.test(key1)) {
                nextPage = false;
                firmName = 'currentCustodian';
            }
            if (key != null && key != '' && !regex.test(key)) {
                nextPage = false;
                business = 'businessLegalNameDBA';
            }

            this.template.querySelector("c-t-a-business-details").showError(business, firmName);
        }

        if (nextPage == true) {

            this.showProRow = true;
            if (this.Pageno == 3) {
                this.formData.rowProRow = 1;
            }
            if (this.Pageno == 4) {


                console.log(this.formData);
                // this.PageData['D'+this.Pageno]=this.template.querySelector('[data-id="D'+this.Pageno+'"]').collectData();
                this.Pageno += 1;
                this.displayFinan = true;
                this.MidPage = false;
                this.istyle = 'top: -30px;';
                this.hstyle = 'top:-95px';
                /*let kk=setInterval(()=>{
                    this.template.querySelector('[data-id="p1"]').disabledata();
                    
                this.template.querySelector('[data-id="p12"]').disabledata();
                this.template.querySelector('[data-id="p13"]').disabledata();
                this.template.querySelector('[data-id="p14"]').disabledata();
                clearInterval(kk);
                },500);*/

            } else {

                console.log(this.formData);
                this.showPRO = true;
                /*
                    if(this.Pageno!=0){
                        this.PageData['D'+this.Pageno]=this.template.querySelector('[data-id="D'+this.Pageno+'"]').collectData();
                    }
                    */
                //console.log(JSON.stringify(this.PageData['D'+this.Pageno]));
                //alert(this.Pageno);
                this.Pageno += 1;
                //alert(this.Pageno);
                /*
                if(this.PageData['D'+this.Pageno]!=null){
                    let kk=setInterval(()=>{
                    //alert(JSON.stringify(this.PageData['D'+this.Pageno]));
                    this.template.querySelector('[data-id="D'+this.Pageno+'"]').setData(this.PageData['D'+this.Pageno]);
                    clearInterval(kk);
                    },500);
                }
                */
                this.MidPage = true;
                this.istyle = '';
                this.hstyle = '';


            }

            //this.Page_Section['Page'+this.Pageno].displayicon=true;
            //this.progressbar='width:'+this.Page_Section['Page'+this.Pageno].width+';background:'+this.Page_Section['Page'+this.Pageno].background+';height: 100%;position: absolute;top: 0px;display:block';
            this.displayPage();
            this.nextlogic();
        }
    }
    prevPage(event) {

        if (this.Pageno == 1) {

            console.log(this.formData);



            //  this.PageData['D'+this.Pageno]=this.template.querySelector('[data-id="D'+this.Pageno+'"]').collectData();

            this.Pageno -= 1;
            this.MidPage = false;
            this.istyle = '';
            this.hstyle = '';
        } else {

            console.log(this.formData);
            /* if(this.Pageno!=5){
                this.PageData['D'+this.Pageno]=this.template.querySelector('[data-id="D'+this.Pageno+'"]').collectData();
            }
            */
            //alert(this.Pageno);
            //alert(JSON.stringify(this.template.querySelector('[data-id="D'+this.Pageno+'"]')));
            this.Pageno -= 1;
            ///alert(this.Pageno);
            //alert(JSON.stringify(this.template.querySelector('[data-id="D'+this.Pageno+'"]')));
            /* let kk=setInterval(()=>{
                //alert(JSON.stringify(this.PageData['D'+this.Pageno]));
            this.template.querySelector('[data-id="D'+this.Pageno+'"]').setData(this.PageData['D'+this.Pageno]);
            clearInterval(kk);
            },500);*/
            this.MidPage = true;
            this.istyle = '';
            this.hstyle = '';
        }
        if (this.Pageno == 3) {
            console.log(this.formData.primaryContact);
            this.primaryConValue = true;
        }
        //this.Page_Section['Page'+(this.Pageno+1)].displayicon=false;
        //this.progressbar='width:'+this.Page_Section['Page'+this.Pageno].width+';background:'+this.Page_Section['Page'+this.Pageno].background+';height: 100%;position: absolute;top: 0px;display:block';
        this.displayPage();
        this.nextlogic();
    }
    displayPage() {
        Object.keys(this.PageSection).forEach(element => {
            if (element == 'Page' + this.Pageno) {

                this.Page_Section[element].active = true;

            } else {
                this.Page_Section[element].active = false;
            }
        });
        if (this.Pageno == 5) {


            let kk = setInterval(() => {
                clearInterval(kk);
                this.calculateviaapi();
            }, 2000);
        }


    }
    nextlogic() {
        Object.keys(this.pageCSS).forEach(element => {
            if (element == 'P' + this.Pageno) {
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

    loanTA_Type() {
        this.RecordtypeBol = false;
        this.clear();
        //this.totAUM = 0.00;
        this.selectedloan = 'Transition Assistance Loan Application'
        this.Pageno += 1;
        this.MidPage = true;
        this.Page_Section = {
            'Page0': {
                'active': true,
                'width': '0%',
                'background': 'green',
                'displayicon': true
            },
            'Page1': {
                'active': false,
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
        this.progressbar = 'width:' + this.Page_Section['Page' + this.Pageno].width + ';background:' + this.Page_Section['Page' + this.Pageno].background + ';height: 100%;position: absolute;top: 0px;display:block';
        this.displayPage();
        /*if(this.PageData['D'+this.Pageno]!=null){
                let kk=setInterval(()=>{
                //alert(JSON.stringify(this.PageData['D'+this.Pageno]));
                this.template.querySelector('[data-id="D'+this.Pageno+'"]').setData(this.PageData['D'+this.Pageno]);
                clearInterval(kk);
                },500);
            }
        */
        this.pageCSS = {
            "P1": "slds-path__item slds-is-current slds-is-active",
            "P2": "slds-path__item slds-is-incomplete",
            "P3": "slds-path__item slds-is-incomplete",
            "P4": "slds-path__item slds-is-incomplete",
            "P5": "slds-path__item slds-is-incomplete"
        };


    }
    loanWC_Type() {
        this.RecordtypeBol = true;
        this.WorkingCapital = true;
        /*this.selectedloan='Working Capital Loan Application'
        this.Pageno+=1; 
        this.MidPage=true;
        this.Page_Section={'Page0':{'active':true,'width':'0%','background':'green','displayicon':true},'Page1':{'active':false,'width':'0%','background':'green','displayicon':true},'Page2':{'active':false,'width':'25%','background':'green','displayicon':false},'Page3':{'active':false,'width':'50%','background':'green','displayicon':false},'Page4':{'active':false,'width':'75%','background':'green','displayicon':false},'Page5':{'active':false,'width':'100%','background':'green','displayicon':false}};
        this.progressbar='width:'+this.Page_Section['Page'+this.Pageno].width+';background:'+this.Page_Section['Page'+this.Pageno].background+';height: 100%;position: absolute;top: 0px;display:block';
        this.displayPage();
    /* if(this.PageData['D'+this.Pageno]!=null){
            let kk=setInterval(()=>{
            alert(JSON.stringify(this.PageData['D'+this.Pageno]));
            this.template.querySelector('[data-id="D'+this.Pageno+'"]').setData(this.PageData['D'+this.Pageno]);
            clearInterval(kk);
            },500);
        }*/
        /* this.pageCSS={
            "P1":"slds-path__item slds-is-current slds-is-active",
            "P2":"slds-path__item slds-is-incomplete",
            "P3":"slds-path__item slds-is-incomplete",
            "P4":"slds-path__item slds-is-incomplete",
            "P5":"slds-path__item slds-is-incomplete"
        };*/
    }

    cancelQuickAction() {
        /*const payload = {
            source: "QuickAction",
            messageBody: 'KillAction'
        }; 
        publish(this.context, LoanSampleMessage, payload);*/
        //loanquickAction communication to cancel model
        this.dispatchEvent(new CustomEvent('closeqa'));

    }
    disconnectedCallback() {

    }
    checkData(event) {
        //alert(event.target.value);
        if (event.target.value == '0') {
            event.target.value = '';
        }
    }
    //CS-1126 Modified By Bhanu 7/30/2020 changes Start-->  
    BackendTA_Type() {

        const rtis = this.objectInfo.data.recordTypeInfos;
        this.recordTypeID = Object.keys(rtis).find(rti => rtis[rti].name === 'Backend TA');
        this.recordTypeName = 'Growth Loan';


        if (window.location.href.indexOf(".lightning.force.com") > 0) {
            let pageURL = window.location.href;
            let lastURLSegment = pageURL.substring(pageURL.lastIndexOf('006') + 0);
            let OptyId = lastURLSegment.substring(0, 18);
            let nav = {
                type: "standard__objectPage",
                attributes: {
                    objectApiName: "Loan_Application__c",
                    actionName: "new",
                    name: "Home"

                },
                state: {
                    nooverride: '1',
                    recordTypeId: this.recordTypeID,
                    defaultFieldValues: "Opportunity__c=" + OptyId,

                }
            };
            this[NavigationMixin.Navigate](nav);
        } else {

            GetLoanObjectInformtion()
                .then(suc => {
                    this.createLoadApplication(suc);

                })
                .catch(er => {
                    console.log(er);
                });

        }

    }
    //CS-1126 Modified By Bhanu 8/11/2020 changes Start-->  
    createLoadApplication(suc) {
        let oldURL = window.location.href;
        let prefix = suc.substring(0, 3);
        let sfObjectId = suc.slice(3);

        var OptyId = oldURL.substring(oldURL.lastIndexOf('=') + 1);

        console.log('-------------OptyId--' + OptyId);
        GetOpportunityDetails({
                Id: OptyId,
            })
            .then(result => {

                oldURL = oldURL.replace(window.location.href.substring(window.location.href.lastIndexOf('/') + 1), "");
                oldURL = oldURL.replace("apex/", prefix + "/e?ent=" + sfObjectId + "&RecordType=");

                oldURL = oldURL + this.recordTypeID + '&CF' + result["OptyFieldId"] + '=' + result["OptyName"] + '&retURL=%2FaEe%2Fo';
                console.log('--------------11111-' + oldURL);
                window.location.assign(oldURL);
            })
            .catch(error => {});


    }
    //Ends

}