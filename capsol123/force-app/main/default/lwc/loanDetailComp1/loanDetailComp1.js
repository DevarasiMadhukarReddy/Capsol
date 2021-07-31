import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';
import {
    CurrentPageReference
} from 'lightning/navigation';
import {
    registerListener,
    unregisterAllListeners,
    fireEvent
} from 'c/auraPubSub';
import collectRelatedProposal from '@salesforce/apex/LoanApplicationController.collectRelatedProposal';
import createNote from '@salesforce/apex/LoanApplicationController.createNote';
import saveOffer from '@salesforce/apex/LoanApplicationController.saveOffer';
import collectRecordDetail from '@salesforce/apex/LoanApplicationController.collectRecordDetail';
import icon_star from '@salesforce/resourceUrl/icon_star';
import ProposalCSS from '@salesforce/resourceUrl/ProposalCSS';
import updateProposalData from '@salesforce/apex/LoanApplicationController.updateProposalData';
import checkContactStatus from '@salesforce/apex/wcLoanApplicationController.checkContactStatus';
import fetchRecordTypeValues from '@salesforce/apex/RecordTypeSelector.fetchRecordTypeValues';
import {
    loadStyle
} from 'lightning/platformResourceLoader';
import saveLoanRecord from '@salesforce/apex/LoanApplicationController.saveLoanRecord';
import collectForgivableProposal from '@salesforce/apex/LoanApplicationController.collectForgivableProposal';
import {
    NavigationMixin
} from 'lightning/navigation';
export default class LoanDetailComp extends NavigationMixin(LightningElement) {
    @api classic;
    @api forgivableMsg = false;
    @api forgivableMsgTA = false;
    @api forgivableMsg1 = false;
    @track AdditionalComments;
    @track note;
    @track BusinessName;
    @track CurrentCustodian;
    @track OSJLEName1; //madhu added 4202021
    //-Bhanu CS-2517 Start
    @api ApprovedAmntMsg = false;
    //-Bhanu CS-2517 ends
    @api ProposalEdit = false; // Added by Amol - 10/27/2020
    cancelRecord() {
        this.EditRecord = false;
        this.bEditRecord = false;
        this.edisabled = true;
        window.location.reload();
        fireEvent(this.pageRef, 'CancelApplication', 'CancelClick');
        this.loadData();
    }
    

    // Madhu added on 28/09/2020 OSJ AMount Length 16 Charater 2 decimal places
    @api financialData = {
        'OsjAmount': 0
    };
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

    saveRecord() {

        if (this.lData.zz.AW.Status == 'Funded' || this.lData.zz.AW.Status == 'Declined') {
            alert('This application cannot be saved becaused the Status is either Declined or Funded.');
            return;
        }
        try {
            this.calculateBorrower();
            console.log('@@@@SAVEBOrrower' + this.Data.BorrowerInfo);
            let mdata = {
                'RecordId': this.recordId,
                'BusinessName': this.template.querySelector('[data-id="BusinessName"]') == null ? '' : this.template.querySelector('[data-id="BusinessName"]').value,
                'Advisor': this.template.querySelector('[data-id="Advisor"]') == null ? 0 : this.template.querySelector('[data-id="Advisor"]').value,
                'EntityType': this.template.querySelector('[data-id="EntityType"]') == null ? '' : this.template.querySelector('[data-id="EntityType"]').value,
                'Registration': this.template.querySelector('[data-id="Registration"]') == null ? '' : this.template.querySelector('[data-id="Registration"]').value,
                'CurrentCustodian': this.template.querySelector('[data-id="CurrentCustodian"]') == null ? '' : this.template.querySelector('[data-id="CurrentCustodian"]').value,
                'AdditionalComment': this.template.querySelector('[data-id="AdditionalComment"]') == null ? '' : this.template.querySelector('[data-id="AdditionalComment"]').value,
                'FDATA': this.collectFA(),
                'BorrowerInfo': this.Data.BorrowerInfo,
                'ProposalDATA': this.template.querySelector('[data-id="prop"]') == null ? [] : this.template.querySelector('[data-id="prop"]').collectProposal() //,
            };
            console.log(JSON.stringify(mdata));

            if (!this.validateBorrower()) {
                alert('Please Check Borrower Contact for duplicate  or sum of all Split  % of AUM should not be greater than 100');
                return;
            }

            let validatebrw = false;
            this.Data.BorrowerInfo.forEach(Element => {

                if (Element.loanSplit > 100) {
                    alert('% Split of Sub Loan should be less than 100');
                    validatebrw = true;
                    return;
                }
                if (Element.repayableSplit > 100) {
                    alert('% Split of Repayable be less than 100');
                    validatebrw = true;
                    return;
                }
                if (Element.backendSplit > 100) {
                    alert('% Split of Backend should be less than 100');
                    validatebrw = true;
                    return;
                }

            });
            if (validatebrw) {
                return;
            } //End

            var PrimeId = this.getPrimaryContact();
            if (PrimeId != undefined || PrimeId != null) {

                checkContactStatus({
                        'ContactId': PrimeId,
                        'RecordTypeName': 'Transition Assistance',
                        'RecordId': this.recordId
                    })
                    .then(suc => {
                        if (suc) {
                            alert('This Customer already has an opened Loan Application or this Contact is Terminated.');
                        } else {
                            this.saveLA();
                        }
                    })
                    .catch(er => {

                    });
            } else {
                this.saveLA();
            }

        } catch (ex) {}
    }

    handleChangeAdditionalComments(event) {
        console.log('+event.target.value' + event.target.value);
        this.AdditionalComments = event.target.value;

    }
    handleChangenote(event) {
        console.log('+event.target.value' + event.target.value);

        this.note = event.target.value;
    }
    handleChangeBusinessName(event) {
        console.log('+event.target.value' + event.target.value);

        this.BusinessName = event.target.value;
    }
    handleChangeCurrentCustodian(event) {
        console.log('+event.target.value' + event.target.value);
        this.CurrentCustodian = event.target.value;
    }
    saveLA() {
        try {
            this.calculateBorrower();
            console.log('@@@@SAVEBOrrower' + JSON.stringify(this.Data.BorrowerInfo));
            let mdata = {
                'RecordId': this.recordId,
                'BusinessName': this.template.querySelector('[data-id="BusinessName"]') == null ? '' : this.template.querySelector('[data-id="BusinessName"]').value,
                'Advisor': this.template.querySelector('[data-id="Advisor"]') == null ? null : (this.template.querySelector('[data-id="Advisor"]').value == undefined || this.template.querySelector('[data-id="Advisor"]').value == "") ? null : this.template.querySelector('[data-id="Advisor"]').value,
                'EntityType': this.template.querySelector('[data-id="EntityType"]') == null ? '' : this.template.querySelector('[data-id="EntityType"]').value,
                'Registration': this.template.querySelector('[data-id="Registration"]') == null ? '' : this.template.querySelector('[data-id="Registration"]').value,
                'CurrentCustodian': this.template.querySelector('[data-id="CurrentCustodian"]') == null ? '' : this.template.querySelector('[data-id="CurrentCustodian"]').value,
                'AdditionalComment': this.template.querySelector('[data-id="AdditionalComment"]') == null ? '' : this.template.querySelector('[data-id="AdditionalComment"]').value,
                'FDATA': this.collectFA(),
                'BorrowerInfo': this.Data.BorrowerInfo,
                'ProposalDATA': this.template.querySelector('[data-id="prop"]') == null ? [] : this.template.querySelector('[data-id="prop"]').collectProposal() //,

            };
            var proprosalvalidation = this.template.querySelector("c-proposal-comp1").handleproposalValidation();
            console.log('proprosalvalidation' + proprosalvalidation);
            //Madhu added CS-3154 and CS-3348 The characters included are alpha-numeric, full stops, commas, and space    
            // var regex = new RegExp('.*([.]{3}).*|.*([\"]{2}).*|.*(\\\\).*');
            var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
            // var key = mdata.BusinessName;
            var key = this.BusinessName;
            var key1 = this.CurrentCustodian;
            //  var key2 = mdata.AdditionalComment;  
            var key2 = this.AdditionalComments;
            var key3 = this.note;
            var searchAddtionalCom = this.template.querySelector(".Addcomment");
            var searchbName = this.template.querySelector(".bName");
            var searchcurrentFN = this.template.querySelector(".currentFN");
            // if ((key != null && key != '' && !regex.test(key)) || (key1 != null && key1 != '' && !regex.test(key1)) ) { 
            //     fireEvent(this.pageRef, 'ErrorOnSaveLoanRecord', 'hidethespinner');
            // }
            // else  

            console.log('key' + key);
            console.log('key1' + key1);
            console.log('key2' + key2);
            if ((key != null && key != '' && !regex.test(key)) || (key1 != null && key1 != '' && !regex.test(key1)) || (key2 != null && key2 != '' && !regex.test(key2)) || !proprosalvalidation) {
                console.log('Amol@@@' + this.loading);
                if (key != null && key != '' && !regex.test(key)) {
                    //CS-3696 Fix spinner on click of saving for TA in classic
                    //Below code commented by Amol 05/12/2021
                    //this.template.querySelector("c-classic-loan-button").stopSpinner();
                    searchbName.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
                    searchbName.reportValidity();
                    //Below code commented by Amol 05/12/2021
                    console.log('classic' + this.classic);
                    if (!this.classic) {
                        fireEvent(this.pageRef, 'ErrorOnSaveLoanRecord', 'hidethespinner');

                    } else {
                        this.template.querySelector('[data-id="classicbuttonTA"]').hidethespinnerClassic();
                    }
                    // commented code by madhu  this.template.querySelector("c-classic-loan-button").stopSpinner(); //madhu added for to stopSpinner
                } else if (searchbName != null) {
                    searchbName.setCustomValidity("");
                    searchbName.reportValidity();
                }
                if (key1 != null && key1 != '' && !regex.test(key1)) {
                    //CS-3696 Fix spinner on click of saving for TA in classic
                    //Below code commented by Amol 05/12/2021
                    //this.template.querySelector("c-classic-loan-button").stopSpinner();

                    searchcurrentFN.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
                    searchcurrentFN.reportValidity();
                    //Below code commented by Amol 05/12/2021
                    if (!this.classic) {
                        fireEvent(this.pageRef, 'ErrorOnSaveLoanRecord', 'hidethespinner');

                    } else {
                        this.template.querySelector('[data-id="classicbuttonTA"]').hidethespinnerClassic();
                    }
                    // commented code by madhu  this.template.querySelector("c-classic-loan-button").stopSpinner(); //madhu added for to stopSpinner
                } else if (searchcurrentFN != null) {
                    searchcurrentFN.setCustomValidity("");
                    searchcurrentFN.reportValidity()
                }
                if (key2 != null && key2 != '' && !regex.test(key2)) {
                    //CS-3696 Fix spinner on click of saving for TA in classic
                    //Below code commented by Amol 05/12/2021
                    //this.template.querySelector("c-classic-loan-button").stopSpinner();
                    searchAddtionalCom.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
                    searchAddtionalCom.reportValidity();
                    //Below code commented by Amol 05/12/2021
                    if (!this.classic) {
                        fireEvent(this.pageRef, 'ErrorOnSaveLoanRecord', 'hidethespinner');

                    } else {
                        this.template.querySelector('[data-id="classicbuttonTA"]').hidethespinnerClassic();
                    }
                } else if (searchAddtionalCom != null) {
                    searchAddtionalCom.setCustomValidity("");
                    searchAddtionalCom.reportValidity();
                }
                if (!proprosalvalidation) {
                    //CS-3696 Fix spinner on click of saving for TA in classic
                    //Below code commented by Amol 05/12/2021
                    // this.template.querySelector("c-classic-loan-button").stopSpinner();
                    if (!this.classic) {
                        fireEvent(this.pageRef, 'ErrorOnSaveLoanRecord', 'hidethespinner');

                    } else {
                        this.template.querySelector('[data-id="classicbuttonTA"]').hidethespinnerClassic();
                    }

                }
            }
            /* else if(key2 != null && key2 != '' && !regex.test(key2)){
                 console.log('regkey2*******----' + !regex.test(key2));
                 searchAddtionalCom.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");  
                 searchAddtionalCom.reportValidity();
                 fireEvent(this.pageRef, 'ErrorOnSaveLoanRecord', 'hidethespinner');
                // commented code by madhu  this.template.querySelector("c-classic-loan-button").stopSpinner(); //madhu added for to stopSpinner
             }*/
            else {
                console.log('testtest');
                console.log('Amol@@@' + this.loading);
                //CS-3696- Amol 05/13/2021 Start
                if (this.classic) {
                    this.template.querySelector('[data-id="classicbuttonTA"]').showthespinnerClassic();
                }
                //CS-3696- Amol 05/13/2021 End
                /*searchAddtionalCom.setCustomValidity("");   
                searchAddtionalCom.reportValidity();
                searchbName.setCustomValidity("");   
                searchbName.reportValidity();
                searchcurrentFN.setCustomValidity("");   
                searchcurrentFN.reportValidity();*/
                //madhu ended added for special characters 
                saveLoanRecord({
                        'lData': JSON.stringify(mdata)
                    })

                    .then(res => {
                        console.log('Inside***');
                        if (res) {
                            //this.template.querySelector("c-classic-loan-button").stopSpinner(); //madhu added for to stopSpinner not required this line

                            this.EditRecord = false;
                            this.bEditRecord = false;
                            this.edisabled = true;
                            if (this.classic) {
                                window.location.reload();
                                //  fireEvent(this.pageRef, 'ErrorOnSaveLoanRecord', 'hidethespinner');
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
        } catch (e) {}
    }
    @track ProposalEditRecord = false;
    @track BorrowerEditRecord = false;
    @track showHeader = true;
    @track bEditRecord = false;

    @track taRecord = true;
    @track hideWizard = true;
    @track workingCapitl = false;
    @api RepayableSection = '';
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
        'BorrowerInfo': [{}],
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

    handleBorrower(event) {

        this.Data.BorrowerInfo = event.detail;
        this.calculateBorrower();
    }

    calculateBorrower() {

        let Arr = [];
        let count = 0;
        this.Data.BorrowerInfo.forEach(Element => {
            if (Element.ContactId != null) {

                Element['BName'] = Element.Contact.Name;
                console.log('>>>>' + Element['BName']);
            }

            if (this.totAUM != 0 && this.totAUM != null && Element.pAUM != 0 && Element.pAUM != null) {
                Element.AUMATT = parseFloat((this.totAUM * Element.pAUM) / 100).toFixed(2);
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
        console.log('@@@@BorrowerInfo' + JSON.stringify(this.Data.BorrowerInfo));
    }

    cancelProposalRecord() {
        this.ProposalEditRecord = false;
    }
    saveProposalRecord() {
        if (this.Offers != null || this.Offers != undefined || this.forgivable != null || this.forgivable != undefined) {
            let OfferData = [];
            let offerName = []; //CS-2320 Modified by Amol 10/13/2020
            let OSJError = []; // Bhanu CS-3779  
            let OSJValidation = []; // Bhanu CS-3779  
            //let offerName1 = []; //CS-2320 Modified by Amol 10/13/2020
            let i = 0;
            Object.keys(this.Offers).forEach(element => {
                if (this.Offers[element] != null) {
                    if (this.disabled == false) {
                        console.log(this.template.querySelector('[data-id="' + element + 'TAAmount"]'));
                        console.log(this.template.querySelector('[data-id="' + element + 'OSJAmount"]'));
                        let ProposalRecordTypeId = '';
                        let tempAmt = this.template.querySelector('[data-id="' + element + 'TAAmount"]').value;
                        //CS-2320 Modified by Amol 10/13/2020 - Start Changes
                        let MAX_TA_Amount = this.template.querySelector('[data-id="' + element + 'MAX_TA_Amount"]').value;
                        //alert(this.Offers[element].OfferName);
                        if (tempAmt > MAX_TA_Amount) {
                            offerName.push(this.Offers[element].OfferName);
                            //alert('TA Amount should be less than Max TA Amount for ' + this.Offers[element].OfferName);
                            //Event.preventDefault();
                            //return;
                        }
                        //CS-2320 Modified by Amol 10/13/2020 - End Changes
                        // Bhanu CS-3779 Start 
                        let tempOSJAmt = this.template.querySelector('[data-id="' + element + 'OSJAmount"]').value;
                        let tempOSJRepId = this.template.querySelector('[data-id="' + element + 'OSJRepId"]').value;
                        let tempCampaignOfferSelected = this.template.querySelector('[data-id="' + element + 'Campaign_Offer_Selected"]').value;

                       if (tempCampaignOfferSelected != null && tempCampaignOfferSelected != undefined && tempCampaignOfferSelected != '') {
                        
                        console.log('tempCampaignOfferSelected' + tempCampaignOfferSelected);
                    }
                        var regex1 = new RegExp("^[a-zA-Z0-9\n]*$");
                        var OSJRepId = this.template.querySelector('.OSJRepId' + i);
                        OSJRepId.setCustomValidity("");
                        OSJRepId.reportValidity();
                        // Bhanu CS-3779 Ends 
                        //Amol CS-3780 STart
                        let tempBackendDate1 = this.template.querySelector('[data-id="' + element + 'BackendDate1"]').value;
                        //console.log('tempBackendDate1' + tempBackendDate1);
                        if (tempBackendDate1 != null && tempBackendDate1 != undefined && tempBackendDate1 != '') {
                            tempBackendDate1 = tempBackendDate1.split(' ')[0];
                            console.log('tempBackendDate1' + tempBackendDate1);
                        }
                        let tempBackendDate2 = this.template.querySelector('[data-id="' + element + 'BackendDate2"]').value;
                        //console.log('tempBackendDate2' + tempBackendDate2);
                        if (tempBackendDate2 != null && tempBackendDate2 != undefined && tempBackendDate2 != '') {
                            tempBackendDate2 = tempBackendDate2.split(' ')[0];
                            console.log('tempBackendDate2' + tempBackendDate2);
                        }
                        //Amol CS-3780 End
                        // Bhanu CS-3782 Start
                      
                        if (tempOSJAmt != null && tempOSJAmt != undefined && tempOSJAmt != '' && tempOSJAmt != '0') {

                            if (tempOSJRepId == null || tempOSJRepId == undefined || tempOSJRepId == '' || tempOSJRepId == '0') {
                                OSJError.push(this.Offers[element].OfferName);

                            } // Bhanu CS-3779 Start 
                           


                            }

                if (tempOSJRepId != null && tempOSJRepId != '' && !regex1.test(tempOSJRepId)) {
                  
                                OSJRepId.setCustomValidity("Error: Check for special characters in field. Only Alpha numeric values are accepted in this field");
                                OSJRepId.reportValidity();
                    OSJValidation.push(this.Offers[element].OfferName);
                    
                } 
				else if (OSJRepId != null)
				{
                    OSJRepId.setCustomValidity("");
                    OSJRepId.reportValidity();
                }// Bhanu CS-3779 Ends 
                i++;    
                        // Bhanu CS-3782 Ends

                        //Set TA Proposal Record Id
                        for (var RecordTypekey in this.ProposalRecordType) {
                            if (this.ProposalRecordType.hasOwnProperty(RecordTypekey)) {
                                var RecordTypeName = this.ProposalRecordType[RecordTypekey];
                                if (RecordTypeName == 'TA Proposal') {
                                    ProposalRecordTypeId = RecordTypekey;

                                }
                            }

                        }
                        // Bhanu CS-3779 Start 
                        let offData = {
                            'Id': this.Offers[element].OfferId,
                            'TA_Amount__c': (tempAmt == undefined || tempAmt == null || tempAmt == '') ? null : parseFloat(tempAmt),
                            'OSJ_Amount__c': (tempOSJAmt == undefined || tempOSJAmt == null || tempOSJAmt == '') ? null : parseFloat(tempOSJAmt),
                            'Backend_Date_1__c': (tempBackendDate1 == undefined || tempBackendDate1 == null || tempBackendDate1 == '') ? null : tempBackendDate1,
                            'Backend_Date_2__c': (tempBackendDate2 == undefined || tempBackendDate2 == null || tempBackendDate2 == '') ? null : tempBackendDate2,
                            'OSJ_NON_OSJ_Rep_Id__c': (tempOSJRepId == undefined || tempOSJRepId == null || tempOSJRepId == '') ? null : tempOSJRepId,
                            'Campaign_Offer_Selected__c': (tempCampaignOfferSelected == undefined || tempCampaignOfferSelected == null || tempCampaignOfferSelected == '') ? null : tempCampaignOfferSelected,
                            'RecordTypeId': ProposalRecordTypeId
                            // Bhanu CS-3779 Ends 
                        }
                        OfferData.push(offData);
                    }
                }
            });
            // Bhanu CS-3782 Start
            if (OSJError.length != 0) {
                alert('The OSJ Rep ID is required to save this record');
                this.ProposalEdit = true;
                return;
            }
            // Bhanu CS-3782 Ends
           // Bhanu CS-3779  Start
            if (OSJValidation.length != 0) {
               this.ProposalEdit = true;
                return;
            }
             // Bhanu CS-3779  Ends

            //CS-2320 Modified by Amol 10/13/2020 -Start
            console.log('AMOL@@@@@@@@' + offerName.length);
            if (offerName.length != 0) {
                alert('Accepted TA Amount should be less than Max TA Amount for ' + offerName);
                this.ProposalEdit = true;
                return;
            }
            //CS-2320 Modified by Amol 10/13/2020 -End 

            if (this.forgivable != null || this.forgivable != undefined) {
                console.log('OfferData!!!!!!!!1111');
                if (this.template.querySelector('[data-id="AcceptedLoanAmount"]') != null) {

                    let AcceptedLoanAmount = this.template.querySelector('[data-id="AcceptedLoanAmount"]').value;
                    let ApprovedLoanAmount = this.template.querySelector('[data-id="ApprovedLoanAmount"]').value; //CS-2320 Modified by Amol 10/13/2020
                    //CS-2320 Modified by Amol 10/13/2020 -Start
                    if (AcceptedLoanAmount > ApprovedLoanAmount) {
                        let REoffName = 'Repayable Offer';
                        // offerName.push('Repayable Offer');
                        alert('Accepted Loan Amount should be less than Approved Loan Amount for Repayable Offer');
                        Event.preventDefault();
                        return;
                    }
                    //CS-2320 Modified by Amol 10/13/2020 -End
                    let ProposalGeneralRecordTypeId = '';
                    console.log('OfferData!!!!!!!!111111111');
                    for (var RecordTypekey in this.ProposalRecordType) {
                        if (this.ProposalRecordType.hasOwnProperty(RecordTypekey)) {
                            var RecordTypeName = this.ProposalRecordType[RecordTypekey];
                            // if (RecordTypeName == 'General Proposal') {// Commented by Amol 11/13/2020
                            if (RecordTypeName == 'Repayable') { //- 
                                ProposalGeneralRecordTypeId = RecordTypekey;

                            }
                        }

                    }

                    let offData1 = {
                        'Id': this.forgivable.OfferId,
                        'TA_Amount__c': (AcceptedLoanAmount == undefined || AcceptedLoanAmount == null || AcceptedLoanAmount == '') ? null : parseFloat(AcceptedLoanAmount),
                        'RecordTypeId': ProposalGeneralRecordTypeId

                    }
                    OfferData.push(offData1);

                }
            }



            console.log('OfferData!!!!!!!!' + OfferData);
            if (OfferData.length > 0) {
                updateProposalData({
                        'PropData': JSON.stringify(OfferData)
                    })
                    .then(res => {
                        if (res) {
                            this.ProposalEditRecord = false;
                            this.ProposalEdit = false;
                            // Added by Amol 11/17/2020 - To reset the Save and Cancel buttons in Classic when the Proposal record is saved.
                            if (this.classic) {
                                window.location.reload();
                            }
                            this.getOffersList();
                            this.getForgivableList();

                            fireEvent(this.pageRef, 'pCancelApplication', 'CancelClick');
                        } else {
                            alert('Unable to save Proposal please check with Administrator');
                        }

                    })
                    .catch(err => {
                        alert('Unable to save Proposal please check with Administrator');
                    })
            }


        }


    }
    // Madhu added on 28/09/2020 OSJ AMount Length 16 Charater 2 decimal places
    checkNumberlength1(event) {
        if (event.target.value.length >= 18) {
            event.preventDefault();
        }
        this.checkdecimalvalue1(event);
    }
    checkdecimalvalue1(event) {
        //alert('d');
        //alert(event.target.value.split('.'));

        if (event.target.value.split('.').length == 16) {
            if (event.target.value.split('.')[1] >= 2) {
                event.preventDefault();
            }
        }
    }
    OsjAmountChange(event) {
        this.dispatchEvent(new CustomEvent('handlefinancedata', {
            detail: {
                'OsjAmount': (event.target.value == null || event.target.value == undefined || event.target.value == "") ? 0 : parseFloat(event.target.value)
            }
        }));
    }
    // Ended by Madhu added on 28/09/2020 OSJ AMount Length 16 Charater 2 decimal places

    editProposalRecord() {
        this.ProposalEditRecord = true;
    }

    cancelBorrowerRecord() {
        this.BorrowerEditRecord = false;
    }
    saveBorrowerRecord() {
        this.BorrowerEditRecord = false;
    }
    editBorrowerRecord() {
        this.BorrowerEditRecord = true;
    }

    connectedCallback() {
        if (!this.classic) {
            registerListener('ProposeOffer', this.handleProposal, this);
            registerListener('EditApplication', this.editRecord, this);
            registerListener('SaveLoanApplication', this.saveRecord, this);
            registerListener('CancelLoanApplication', this.cancelRecord, this);
            registerListener('ProposalCancelLoanApplication', this.cancelProposalRecord, this);
            registerListener('ProposalSaveLoanApplication', this.saveProposalRecord, this);
            registerListener('ProposalEditLoanApplication', this.editProposalRecord, this);
            registerListener('BorrowerCancelLoanApplication', this.cancelBorrowerRecord, this);
            registerListener('BorrowerSaveLoanApplication', this.saveBorrowerRecord, this);
            registerListener('BorrowerEditLoanApplication', this.editBorrowerRecord, this);
        }
        Promise.all([
            loadStyle(this, ProposalCSS)
        ]).then(() => {
            //alert('Files loaded.');
        }).catch(error => {
            // alert("Error " + error.body.message);
        });

        this.loadData();
    }
    @api formData = {};
    @track edisabled = true;
    @track imgdata = icon_star;
    @api recordId;
    @api EditRecord = false;
    @api ProposalRecord = false;
    @track activeSection = ['Application_Info', 'Bussiness_Info', 'Financial_Info', 'Borrower_Info', 'Proposal_Info', 'Additional_Info', 'Additional_Contacts', 'System_Info', 'Forgivable', 'Repayable'];
    @track Offers = {
        "offer0": null,
        "offer1": null,
        "offer2": null,
        "offer3": null,
        "offer4": null
    };
    @track selectedOffer;
    @track disabled = false;
    @track disabledRepayable = false;
    @track disabledRepayable1 = true;
    @track ShowAcceptedLoanAmount = false;
    @track showConfirm = false;
    @track showNote = false;
    @track selectedNote;
    @track showNoteList = false;
    @track Nlist = [];
    @track lData;
    @track ProposalRecordType;
    LegalEntity = [{
            value: 'Individual',
            label: 'Individual'
        },
        // CS- 2536 Modified by Amol - 11/05/2020 Start
       /*  As per CS-4205 user story hiding the Business-Hybrid RIA/Bank value 
        {
            label: 'Business – Hybrid RIA/Bank',
            value: 'Business – Hybrid RIA/Bank'
        }
        , */
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

    Registration = [

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
    get CampaignOfferSelected() {
        return [
        {
            label: 'Exception',
            value: 'Exception'
        }, {
            label: 'Standard',
            value: 'Standard'
        }, {
            label: 'Premium',
            value: 'Premium'
        }, {
            label: 'Tier 1',
            value: 'Tier 1'
        }, {
            label: 'Spring',
            value: 'Spring'
        }, {
            label: 'Parker',
            value: 'Parker'
        },
        {
            label: 'Other',
            value: 'Other'
        },
        {
            label: 'EOY',
            value: 'EOY'
        },
        {
            label: 'Special',
            value: 'Special'
        }
        ,{
            label: 'RIA Platform Alternative',
            value: 'RIA Platform Alternative'
        },
        {
            label: 'Employee Advisor Experiment',
            value: 'Employee Advisor Experiment'
        },
        {
            label: 'Employee Advisor',
            value: 'Employee Advisor'
        },
        {
            label: 'Managed Rep',
            value: 'Managed Rep'
        },
        {
            label: 'RIA / IFA',
            value: 'RIA / IFA'
        },
        
        {
            label: 'Swoop',
            value: 'Swoop'
        },        
        {
            label: 'Low Churn',
            value: 'Low Churn'
        },        
        {
            label: 'JFC',
            value: 'JFC'
        },        
        {
            label: 'Strategic TA',
            value: 'Strategic TA'
        }
    ];
}
    @api
    editRecord() {
        this.EditRecord = true;
        this.bEditRecord = true;
        this.edisabled = false;
        this.loadData();

    }
    @track loading = false;
    loadData() {
        this.loading = true;
        collectRecordDetail({
                'recId': this.recordId
            })
            .then(res => {
                console.log(JSON.stringify(res));
                this.lData = {
                    ...res
                };
                //alert(JSON.stringify(this.lData));
                let hh = setInterval(() => {
                    clearInterval(hh);
                    this.setFinancialData();

                    if (this.lData.zz.PW != undefined) {
                        if (this.lData.zz.PW != null) {
                            let DATAa = [];
                            this.lData.zz.PW.forEach(Element => {
                                DATAa.push(Element);
                            });

                            this.template.querySelector('[data-id="prop"]').setData(DATAa);
                        }
                    }
                    let abc = setInterval(() => {
                        clearInterval(abc);
                        if (this.lData.zz.BorrowerInfo != null) {
                            let DATAa = [];
                            let cnt = 0;
                            this.lData.zz.BorrowerInfo.forEach(Element => {
                                Element['avail'] = cnt == 0 ? false : true;
                                DATAa.push(Element);
                                cnt++;
                            });
                            this.Data.BorrowerInfo = DATAa;

                        }

                        this.loading = false;

                    }, 9000);



                }, 6000);
            })
            .catch(err => {
                alert('Unable to Open Record Please contact your Administrator ');
            });
    }

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
    closeNoteWindow() {


        //Madhu added CS-3154 and CS-3348 The characters included are alpha-numeric, full stops, commas, and space    
        // var regex = new RegExp('.*([.]{3}).*|.*([\"]{2}).*|.*(\\\\).*');
        var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
        var key3 = this.note;
        let searchAddtionalCom1 = this.template.querySelector(".Addnote");
        if (key3 != null && key3 != '' && !regex.test(key3)) {
            searchAddtionalCom1.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            searchAddtionalCom1.reportValidity();
        } else {

            searchAddtionalCom1.setCustomValidity("");
            searchAddtionalCom1.reportValidity();

            if (this.template.querySelector('[data-id="note"]').value != '') {

                createNote({
                        'Body': this.template.querySelector('[data-id="note"]').value,
                        'ParentId': this.selectedNote
                    }).then(res => {
                        this.getOffersList();
                        this.getForgivableList();
                    })
                    .catch(err => {
                        //alert(err);
                    });
            }
            this.showNote = false;

        }
        /* Madhu ended*/

    }
    showNoteWindow(event) {
        this.selectedNote = event.target.id.split('-')[1];
        this.noteHeader = event.target.id.split('-')[2];
        this.showNote = true;
    }
    showNoteWindowforgivable(event) {
        this.selectedNote = event.target.id.split('-')[1];
        this.noteHeader = event.target.id.split('-')[2];
        this.showNote = true;
    }

    closeWindow() {
        this.showConfirm = false;
        this.forgivableMsg1 = false;
        // this.ShowAcceptedLoanAmount = false;
        //-Bhanu CS-2517 Start
        this.ApprovedAmntMsg = false;
        //-Bhanu CS-2517 ends
        if (this.forgivableMsg == true) {
            //  this.disabledRepayable1 = false;
        }
        this.disabledRepayable1 = true;
        if (this.forgivable != null) {
            if (this.forgivable.OfferId == this.selectedOffer) {
                if (this.forgivable.AcceptedLoanAmount1 == 0) {
                    //CS-2916 New changes start
                    this.ShowAcceptedLoanAmount = true;
                    //CS-2916 New changes ends
                } else if (this.forgivable.AcceptedLoanAmount1 > 0) {
                    //CS-2916 New changes start
                    this.ShowAcceptedLoanAmount = true;
                    //this.disabledRepayable1 = false;
                    //CS-2916 New changes ends

                }

            }
        }



    }
    checkData(event) {
        if (event.target.value == '0') {
            event.target.value = '';
        }
    }

    onselectOfferForgivable() {

    }
    confirmWindow() {
        this.template.querySelector('[data-id="' + this.selectedOffer + '"]').style = 'background-color:#E7F1FA';

        console.log(this.disabled);
        console.log(this.forgivable);
        console.log(this.selectedOffer);
        console.log(this.forgivableMsgTA);
        Object.keys(this.Offers).forEach(element => {
            if (this.Offers[element].OfferId == this.selectedOffer) {

                let tempAmt = this.Offers[element].TA_Amount;

                if (tempAmt == undefined || tempAmt == null || tempAmt == '' || tempAmt == '0') {
                    this.forgivableMsgTA = true;
                    return;

                }
                this.Offers[element]['OfferSelected'] = true;
                this.disabled = true;
                this.ProposalEditRecord = false;

                // this.template.querySelector('[data-id="Negotiate"]').style.display = "none";
            }
        });

        if (this.forgivableMsgTA == true) {
            return;
        }

        if (this.forgivable != null) {
            if (this.forgivable.OfferId == this.selectedOffer) {
                //CS-1999 Bhanu Start  
                let OfferData = [];
                /* CS-2916 start 
                let AcceptedLoanAmountElement = this.template.querySelector('[data-id="AcceptedLoanAmount"]');
                if (AcceptedLoanAmountElement == null && this.ShowAcceptedLoanAmount == false) {
                    //   this.disabledRepayable1 = false;
                    this.forgivableMsg = true;
                    return;
                }



                let AcceptedLoanAmount = 0;
                if (this.ShowAcceptedLoanAmount == false) {
                    AcceptedLoanAmount = this.template.querySelector('[data-id="AcceptedLoanAmount"]').value;
                    if (AcceptedLoanAmount == undefined || AcceptedLoanAmount == null || AcceptedLoanAmount == '' || AcceptedLoanAmount == '0') {

                        this.forgivableMsg = true;
                        return;

                    } else {

                        this.forgivableMsg = false;
                    }
                } else {
                    AcceptedLoanAmount = this.forgivable.AcceptedLoanAmount1;
                }*/
                let AcceptedLoanAmount = 0;
                AcceptedLoanAmount = this.forgivable.AcceptedLoanAmount1;
                if (AcceptedLoanAmount == undefined || AcceptedLoanAmount == null || AcceptedLoanAmount == '' || AcceptedLoanAmount == '0') {

                    this.forgivableMsg = true;
                    return;

                } else {

                    this.forgivableMsg = false;
                }
                //CS-2916 ends
                //-Bhanu CS-2517 Start
                let ApprovedLoanAmount = 0;
                if (this.forgivable.LoanAmount != 0) {

                    ApprovedLoanAmount = this.template.querySelector('[data-id="ApprovedLoanAmount"]').value;
                }


                if (AcceptedLoanAmount > ApprovedLoanAmount) {
                    this.ApprovedAmntMsg = true;
                    return;
                }
                //-Bhanu CS-2517 ends

                this.forgivable['OfferSelected'] = true;
                this.disabledRepayable = true;
                this.disabledRepayable1 = true;
                this.ShowAcceptedLoanAmount = false;


                let ProposalGeneralRecordTypeId = '';
                for (var RecordTypekey in this.ProposalRecordType) {
                    if (this.ProposalRecordType.hasOwnProperty(RecordTypekey)) {
                        var RecordTypeName = this.ProposalRecordType[RecordTypekey];
                        //if (RecordTypeName == 'General Proposal') { - // Commented by amol - 11/13/2020
                        if (RecordTypeName == 'Repayable') {
                            ProposalGeneralRecordTypeId = RecordTypekey;

                        }
                    }

                }
                this.forgivable.AcceptedLoanAmount1 = this.forgivable.AcceptedLoanAmount;
                let offData1 = {
                    'Id': this.forgivable.OfferId,
                    'TA_Amount__c': (AcceptedLoanAmount == undefined || AcceptedLoanAmount == null || AcceptedLoanAmount == '') ? null : parseFloat(AcceptedLoanAmount),
                    'RecordTypeId': ProposalGeneralRecordTypeId

                }

                OfferData.push(offData1);
                console.log('ProposalData' + JSON.stringify(OfferData));

                if (OfferData.length > 0) {
                    updateProposalData({
                            'PropData': JSON.stringify(OfferData)
                        })
                        .then(res => {
                            if (res) {
                                // Moved the below logic from save offer method (line 929 to line 935 ) - Amol - 11/13/2020 - Start
                                /*if (this.disabled == true) {
                                    // window.location.reload(); // COmmented by Amol 11/13/2020
                                    fireEvent(this.pageRef, 'pCancelApplication', 'CancelClick');

                                } //Bhanu CS-2366 ends
                                this.getOffersList();
                                this.getForgivableList();
                                window.location.reload(); // Added by Amol 11/13/2020*/
                                // Amol chnages end 11/13/2020
                            } else {
                                //console.log('11111111111' + res);
                                alert('Unable to save Proposal please check with Administrator');
                            }

                        })
                        .catch(err => {
                            //console.log('11111111111');
                            alert('Unable to save Proposal please check with Administrator');
                        })
                }

            }
        } //Ends

        // Commented by Amol - Moved the Save offer logic to Loan Application controller - updateProposalData method 
        saveOffer({
                'recId': this.selectedOffer,
                'loanId': this.recordId
            }).then(res => {
                //Bhanu CS-2366 Start
                if (this.disabled == true) {
                    window.location.reload(); // COmmented by Amol 11/17/2020
                    fireEvent(this.pageRef, 'pCancelApplication', 'CancelClick');

                } //Bhanu CS-2366 ends
                this.getOffersList();
                this.getForgivableList();
            })
            .catch(err => {
                console.log(err);
            });

        this.showConfirm = false;
    }
    @wire(CurrentPageReference) pageRef;


    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    handleProposal() {
        this.ProposalRecord = true;
        if (this.lData.zz.loan.RecordType.Name == 'Transition Assistance') {
            this.RepayableSection = 'Repayable (Optional)';
        } else if (this.loan.RecordType.Name == 'Working Capital') {

            this.RepayableSection = 'Repayable';
        }

        this.activeSection = ['Forgivable', 'Repayable', 'Application_Info'];
        let intt = setInterval(() => {
            this.activeSection = ['Forgivable', 'Repayable', 'Application_Info'];
            this.getOffersList();
            this.getForgivableList();
            this.loadProposalRecordTypes();
            clearInterval(intt);

        }, 1000);
        this.activeSection = ['Forgivable', 'Repayable', 'Application_Info'];
    }
    @track forgivable;
    getForgivableList() {
        collectForgivableProposal({
                'ParentId': this.recordId
            })
            .then(result => {
                let repId;
                this.forgivable = result;
                console.log('amol' + this.forgivable.OfferId);
                console.log('BBBBBBBBBB' + this.forgivable.AcceptedLoanAmount);

                if (this.forgivable.OfferSelected) {
                    this.disabledRepayable = true;
                    this.disabledRepayable1 = true;
                    this.ShowAcceptedLoanAmount = false;
                    repId = this.forgivable.OfferId
                    console.log('amol' + repId);
                    let intt = setInterval(() => {
                        console.log('forgive ID' + repId);
                        if (repId)
                            this.template.querySelector('[data-id="' + repId + '"]').style = 'background-color:#E7F1FA';
                        clearInterval(intt);
                    }, 1000);

                } else
                //CS-1999 Bhanu Start
                {

                    if (this.forgivable.AcceptedLoanAmount1 == 0) {
                        this.ShowAcceptedLoanAmount = false;
                    } else if (this.forgivable.AcceptedLoanAmount1 > 0) {
                        this.ShowAcceptedLoanAmount = true;

                    }

                } //Ends
            }).catch(err => {

                console.log(err);
            });
    }
    getOffersList() {

        collectRelatedProposal({
                'ParentId': this.recordId
            })
            .then(result => {
                console.log('ProposalData' + JSON.stringify(result)); //alert(result);
                let da;
                if (result) {
                    let DATA = {};
                    result.forEach((element, index) => {
                        if (element.OfferSelected) {
                            this.disabled = true;
                            da = element.OfferId; //this.template.querySelector('[data-id="'+element.OfferId+'"]').style='background-color:#f1f1f1';
                        }
                        DATA['offer' + index] = element;
                    });
                    this.Offers = DATA;
                    let intt = setInterval(() => {
                        console.log('forgive ID' + da);
                        if (da)
                            this.template.querySelector('[data-id="' + da + '"]').style = 'background-color:#E7F1FA';

                        clearInterval(intt);
                    }, 2000);

                }
            }).catch(err => {

                console.log(err);
            });
    }
    @track noteHeader = '';
    onselectOffer(event) {
        this.selectedOffer = event.target.id.split('-')[1];
        // Bhanu CS-2916 start
        this.forgivableMsg = false;
        this.disabledRepayable1 = true;
        this.forgivableMsg1 = false;
        // Bhanu CS-2916 ends
        //-Bhanu CS-2517 Start
        this.ApprovedAmntMsg = false;
        //-Bhanu CS-2517 ends
        this.forgivableMsgTA = false;
        if (this.forgivable != null) {
            if (this.forgivable.OfferId == this.selectedOffer) {
                if (this.ShowAcceptedLoanAmount == true) {
                    if (this.forgivable.AcceptedLoanAmount1 != undefined && this.forgivable.AcceptedLoanAmount1 != null && this.forgivable.AcceptedLoanAmount1 != '' || this.forgivable.AcceptedLoanAmount1 != '0') {
                        // Bhanu CS-2916 start
                        this.forgivableMsg1 = false;
                        // Bhanu CS-2916 ends
                    }
                }

            }
        }

        this.showConfirm = true;
    }
    recordlink() {
        window.location.reload();
    }
    //Financial 
    @api finacialDetailsData = [];
    @track totAUM = 0;
    @track totProduction = 0;

    @track mfdh = 0;
    @track mfc = 0;
    @track va = 0;
    @track fa = 0;
    @track fi = 0;
    @track eq = 0;
    @track aiuitCash = 0;
    @track totAdvAum = 0;
    @track totBAUM = 0;

    @track advRev = 0;
    @track broRev = 0;
    @track GDC = 0;
    @track AUMAttributable = 0;
    calculateAUMAttributable() {
        let aa = parseInt(this.template.querySelector('[data-id="SplitPercent"]').value);
        if (aa != null && aa != 0) {
            if (this.totAUM != 0) {
                this.AUMAttributable = ((aa) * parseInt(this.totAUM)) / 100;
            } else {
                this.AUMAttributable = 0;
            }
        } else {
            this.AUMAttributable = 0;
        }

    }
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
        'totAdvAum': 0,

        'totBAUM': 0,
        'totAUM': 0

    }
    @track TotMFC = 0;
    calculateTotalAUM(event) {
        if (event.target.name === 'mfdh') {
            this.mfdh = isNaN(this.mfdh) ? 0 : this.mfdh;
            this.totAUM = this.totAUM - this.mfdh;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.mfdh = Number(parseFloat(event.target.value).toFixed(2));
            this.mfdh = isNaN(this.mfdh) ? 0 : this.mfdh;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                mfdh: this.mfdh
            }];
            this.totAUM += this.mfdh;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
        } else if (event.target.name === 'mfc') {
            this.mfc = isNaN(this.mfc) ? 0 : this.mfc;
            this.totAUM = this.totAUM - this.mfc;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.mfc = Number(parseFloat(event.target.value).toFixed(2));
            this.mfc = isNaN(this.mfc) ? 0 : this.mfc;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                mfc: this.mfc
            }];
            this.totAUM += this.mfc;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
        } else if (event.target.name === 'va') {
            this.va = isNaN(this.va) ? 0 : this.va;
            this.totAUM = this.totAUM - this.va;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.va = Number(parseFloat(event.target.value).toFixed(2));
            this.va = isNaN(this.va) ? 0 : this.va;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                va: this.va
            }];
            this.totAUM += this.va;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
        } else if (event.target.name === 'fa') {
            this.fa = isNaN(this.fa) ? 0 : this.fa;
            this.totAUM = this.totAUM - this.fa;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.fa = Number(parseFloat(event.target.value).toFixed(2));
            this.fa = isNaN(this.fa) ? 0 : this.fa;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                fa: this.fa
            }];
            this.totAUM += this.fa;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
        } else if (event.target.name === 'fi') {
            this.fi = isNaN(this.fi) ? 0 : this.fi;
            // this.fi = 0;
            this.totAUM = this.totAUM - this.fi;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.fi = Number(parseFloat(event.target.value).toFixed(2));
            this.fi = isNaN(this.fi) ? 0 : this.fi;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                fi: this.fi
            }];
            this.totAUM += this.fi;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
        } else if (event.target.name === 'eq') {
            this.eq = isNaN(this.eq) ? 0 : this.eq;
            this.totAUM = this.totAUM - this.eq;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.eq = Number(parseFloat(event.target.value).toFixed(2));
            this.eq = isNaN(this.eq) ? 0 : this.eq;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                eq: this.eq
            }];
            this.totAUM += this.eq;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
        } else if (event.target.name === 'aiuitCash') {
            this.aiuitCash = isNaN(this.aiuitCash) ? 0 : this.aiuitCash;
            this.totAUM = this.totAUM - this.aiuitCash;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.aiuitCash = Number(parseFloat(event.target.value).toFixed(2));
            this.aiuitCash = isNaN(this.aiuitCash) ? 0 : this.aiuitCash;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                aiuitCash: this.aiuitCash
            }];
            this.totAUM += this.aiuitCash;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
        } else if (event.target.name === 'totAdvAum') {
            this.totAdvAum = isNaN(this.totAdvAum) ? 0 : this.totAdvAum;
            this.totAUM = this.totAUM - this.totAdvAum;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
            this.totAdvAum = Number(parseFloat(event.target.value).toFixed(2));
            this.totAdvAum = isNaN(this.totAdvAum) ? 0 : this.totAdvAum;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                totAdvAum: this.totAdvAum
            }];
            this.totAUM += this.totAdvAum;
            this.totAUM = isNaN(this.totAUM) ? 0 : this.totAUM;
        }


        this.calculateviaapi();
    }

    calculateTotalProduction(event) {

        if (event.target.name === 'advRev') {
            this.advRev = isNaN(this.advRev) ? 0 : this.advRev;
            this.totProduction = this.totProduction - this.advRev;
            this.totProduction = isNaN(this.totProduction) ? 0 : this.totProduction;
            this.advRev = Number(parseFloat(event.target.value).toFixed(2));
            this.advRev = isNaN(this.advRev) ? 0 : this.advRev;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                advRev: this.advRev
            }];
            this.totProduction += this.advRev;
            this.totProduction = isNaN(this.totProduction) ? 0 : this.totProduction;
        } else if (event.target.name === 'broRev') {
            this.broRev = isNaN(this.broRev) ? 0 : this.broRev;
            //this.broRev = 0;
            this.totProduction = this.totProduction - this.broRev;
            this.totProduction = isNaN(this.totProduction) ? 0 : this.totProduction;
            this.broRev = Number(parseFloat(event.target.value).toFixed(2));
            this.broRev = isNaN(this.broRev) ? 0 : this.broRev;
            this.finacialDetailsData = [...this.finacialDetailsData, {
                broRev: this.broRev
            }];
            this.totProduction += this.broRev;
            this.totProduction = isNaN(this.totProduction) ? 0 : this.totProduction;
        }
        this.calculateviaapi();


    }
    collectFA() {
        return {
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
            console.log(JSON.stringify(data));
            this.totProduction = data.advRev + data.broRev;
            this.totBAUM = data.mfc + data.mfdh + data.va + data.fi + data.fa + data.eq + data.aiuitCash;
            this.totAUM = this.totBAUM + data.totAdvAum;
            this.TotMFC = data.mfdh + data.mfc;
            try {
                this.GDC = (this.totProduction / this.totAUM) * 100; // CS-2351 MOdified BY Amol 10/13/2020
                this.GDC = isNaN(this.GDC) ? 0 : this.GDC;
            } catch (e) {
                this.GDC = 0;
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
                console.log(this.mfdh);
                console.log(this.totAUM);
                this.PercentData.mfdh = ((this.mfdh / this.totAUM) * 100).toFixed(2);
                this.PercentData.mfdh = isNaN(this.PercentData.mfdh) ? 0 : this.PercentData.mfdh;
            } catch (e) {
                this.PercentData.mfdh = 0;

            }
            try {
                this.PercentData.mfc = ((this.mfc / this.totAUM) * 100).toFixed(2);
                this.PercentData.mfc = isNaN(this.PercentData.mfc) ? 0 : this.PercentData.mfc;
            } catch (e) {
                this.PercentData.mfc = 0;

            }
            try {
                this.PercentData.totMFC = ((this.TotMFC / this.totAUM) * 100).toFixed(2);
                this.PercentData.totMFC = isNaN(this.PercentData.totMFC) ? 0 : this.PercentData.totMFC;
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

    setFinancialData() {

        this.mfdh = this.lData.zz.FW.MutualFundsDirectlyHeld ? this.lData.zz.FW.MutualFundsDirectlyHeld : 0;
        this.mfc = this.lData.zz.FW.MutualFundsCustodied ? this.lData.zz.FW.MutualFundsCustodied : 0;
        this.va = this.lData.zz.FW.VA ? this.lData.zz.FW.VA : 0;
        this.fa = this.lData.zz.FW.FA ? this.lData.zz.FW.FA : 0;
        this.fi = this.lData.zz.FW.FI ? this.lData.zz.FW.FI : 0;
        this.eq = this.lData.zz.FW.EQ ? this.lData.zz.FW.EQ : 0;
        this.aiuitCash = this.lData.zz.FW.AIUITCASH ? this.lData.zz.FW.AIUITCASH : 0;
        this.totAdvAum = this.lData.zz.FW.TotalAdvisoryAUM ? this.lData.zz.FW.TotalAdvisoryAUM : 0;

        this.advRev = this.lData.zz.FW.AdvisoryRevenue ? this.lData.zz.FW.AdvisoryRevenue : 0;
        this.broRev = this.lData.zz.FW.BrokerageRevenue ? this.lData.zz.FW.BrokerageRevenue : 0;
        //this.calculateviaapi();
        let hh1 = setInterval(() => {
            this.calculateviaapi();

            clearInterval(hh1);
        }, 2000);

    }

    @api
    setDataBW(Name, Id, splitPercent) {
        this.template.querySelector('[data-id="lookupContact"]').setData(Name, Id);
        this.template.querySelector('[data-id="SplitPercent"]').value = splitPercent;

    }
    @api
    setDataAdditionalContact(ACW) {

        if (ACW.AssignedRecruiterId != null) {
            this.template.querySelector('[data-id="lookupAssigned"]').setData(ACW.AssignedRecruiterName, ACW.AssignedRecruiterId);
        }
        if (ACW.InternalRecruiterId != null) {
            this.template.querySelector('[data-id="lookupInternal"]').setData(ACW.InternalRecruiterName, ACW.InternalRecruiterId);
        }
        if (ACW.BusinessConsultantId != null) {
            this.template.querySelector('[data-id="lookupBusiness"]').setData(ACW.BusinessConsultantName, ACW.BusinessConsultantId);
        }
        if (ACW.PreparerName != null) {
            this.template.querySelector('[data-id="PreparerName"]').value = ACW.PreparerName;
        }
        if (ACW.ServicerName != null) {
            this.template.querySelector('[data-id="ServicerName"]').value = ACW.ServicerName;
        }


    }

    @api getDataAdditionalContact() {
        return {
            'AssignedId': this.template.querySelector('[data-id="lookupAssigned"]').getRecordId(),
            'InternalId': this.template.querySelector('[data-id="lookupInternal"]').getRecordId(),
            'BusinessId': this.template.querySelector('[data-id="lookupBusiness"]').getRecordId(),
            'PreparerName': this.template.querySelector('[data-id="PreparerName"]').value,
            'ServicerName': this.template.querySelector('[data-id="ServicerName"]').value

        };
    }

    @api getDataBW() {
        return {
            'BorowwerId': this.template.querySelector('[data-id="lookupContact"]').getRecordId(),
            'SplitPercent': this.template.querySelector('[data-id="SplitPercent"]') != null ? parseInt(this.template.querySelector('[data-id="SplitPercent"]').value) : 0
        }
    }

    closeNoteWindow1() {
        this.showNote = false;
    }

    

}