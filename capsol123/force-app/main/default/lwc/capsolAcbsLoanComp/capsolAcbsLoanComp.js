import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';

import getLoanACBSDetails from '@salesforce/apex/clsLPLCAPSOLLoanACBSReq.getloanPayment';

export default class CapsolAcbsLoanComp extends LightningElement {
    @api recordId;
    @api acbsArr;
    @track isLoading = true; // CS-3366 Spinner added by Madhukar Reddy on 28/06/2021
    @track noRecordsFound = true; //CS- 3383 No recordsfound on UI added by Madhukar Reddy on 30/06/2021
    @track showMuleError = false;
    /*@api acbsArr = {

	masterRepID: '',
	advisorName: '',
	loanProgram: '',
	loanType: '',
	loanterm2: '',
	loanRate: '',
	loanStatus: null,
	originalAmount: 0,
	premiumperPeriod: 0,
	creationDate: 0,
	loanPayoffDate: 0,
	outstandingLoanBalance: 0,
	interestRateType: 0,
	paymentFrequency: 0,
	dueDate: 0,
	internalReferenceIdentifier: ''



}*/

    handleACBSData() {
        this.getLoanDetails();
    }
    connectedCallback() {
        this.acbsArr = [];
        this.getLoanDetails();
    }
    getLoanDetails() {
        //console.log('@@@result');
        //console.log(this.recordId);
        getLoanACBSDetails({
            'ContactId': this.recordId
            //'ContactId': '003e000001N4xSf'
        }).then((result) => {

            this.acbsArr = result.loanDetails;
            //CS-3380 added by Bhanu- Start 
            const value1 = JSON.stringify(result);
           // console.log('loanDetails1' + result["loanDetails1"]);
            console.log('result****$$$' + result["loansDetails"]);
            console.log('isArray****$$$' + Array.isArray(result["loansDetails"]));
            console.log('isArray****$$$1' + Array.isArray(this.acbsArr));
            console.log('==========BBBB======' + JSON.stringify(this.acbsArr));
            //console.log('==========BBBB****'+result[0]);
            if (result == '' || result.loanDetails == 'DataPower' || result.loanDetails == 'MuleSoft') {
                this.isLoading = false;
                this.showMuleError = true;
                this.noRecordsFound = false; // added by madhukar on 7/7/2021
            } else if (Array.isArray(this.acbsArr) == false) {
                // CS-3366 Loan Summary page spinner & CS-3383 No Load Detail Record on UI Added by Madhukar Reddy on 6/30/2021--start

                this.noRecordsFound = false;
                this.isLoading = false;
                this.showMuleError = false; //CS-3380 added by Bhanu- Start 
            } else {
                this.noRecordsFound = true;
                this.isLoading = false;
                this.showMuleError = false; //CS-3380 added by Bhanu- Start 
            }
            // CS-3366 Loan Summary page spinner & CS-3383 No Load Detail Record on UI Added by Madhukar Reddy --Endded

            let Arr = [];
            // Arr=Arr.concat(this.bowArr);
            /* this.result.loanDetails.forEach(Element => {
			 let temp = Object.assign({}, Element);
			 Arr.push(temp);
		      });

		       console.log('@@@' + Arr);
		       this.acbsArr = Arr;*/
            //CS-3380 added by Bhanu- Start 
        }).catch((error) => {

            this.isLoading = false;
            this.showMuleError = true;
            this.noRecordsFound = false;

        }); //CS-3380 added by Bhanu- End 
        
    }

    closeModal() {

        this.noRecordsFound = false;
        this.isLoading = false;
        this.showMuleError = false;

    }

    // Method for checking the null value added by Madhukar Reddy on 6/30/2021
   /* isEmpty(str) {
        console.log('str***' + str);
        return (
            !str ||
            0 === str.length ||
            str === null ||
            str === "" ||
            str === undefined
        );
    }*/
}