import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';

//import getLoanACBSDetails from '@salesforce/apex/clsLPLCAPSOLLoanACBSReq.getLoanACBSDetails';
export default class cAPSOL_ACBS_Loan_Comp extends LightningElement {
    @api recordId; //Bhanu CS-3367 Get ACBS Loan Details
    @api acbsArr = {
        'Details': {
            'masterRepID': '',
            'advisorName': '',
            'loanProgram': '',
            'loanType': '',
            'loanterm2': '',
            'loanRate': '',
            'loanStatus': null,
            'originalAmount': 0,
            'premiumperPeriod': 0,
            'creationDate': 0,
            'loanPayoffDate': 0,
            'outstandingLoanBalance': 0,
            'interestRateType': 0,
            'paymentFrequency': 0,
            'dueDate': 0
        }


    }

}