import {
    LightningElement,
    api,
    wire,
    track
} from 'lwc';

import accordianHeader from "./capsolAcbsLoanAccordianTabHeader.html";



export default class CapsolAcbsLoanAccordianTabDetails extends LightningElement {

    @track accordianLabel = false;
    @track loanTypelabel = '| Loan Type : ';
    @track loanNumberlabel = 'Loan # : ';
    // @track loanTypeValue = 'Growth';
    @track breakLine = '<br/>';
    @api acbsValue;
    @api creationDate;
    @api originalAmount;
    @api interestRateType;
    @api loanType;
    @api loanPayoffDate;
    @api YTDTotal;
    @api loanStatus;
    @api outstandingLoanBalance;
    @api PYPrinciple;
    @api premiumperPeriod;
    @api YTDPrinciple;
    @api PYInterest;
    @api paymentFrequency;
    @api YTDInterest;
    @api PYTotal;
    @api loanProgram;
    @api loanRate;
    @api acbsLoanIdentifier;

    @track premiumperPeriodFlag;
    @track distrubutionDateFlag;
    @track loanAmountFlag;
    @track loanCategoryFlag;
    @track interestTypeFlag;
    @track maturityDateFlag;
    @track outstandingBalanceFlag;
    @track loanRateFlag;
    @track loanStatusFlag;
    @track paymentFrequencyFlag;
    @track ytdTotalPaymentsFlag;
    @track ytdPrincipalPaymentsFlag;
    @track ytdInterestPaymentsFlag;
    @track pyTotalPaymentsFlag;
    @track pyPrincipalPaymentsFlag;
    @track pyInterestPaymentsFlag;

    get accheader() {
        return this.loanNumberlabel + this.acbsLoanIdentifier + ' ' + this.loanTypelabel + this.loanProgram;
    }

    handleSectionToggle() {
        if (this.creationDate != null && this.creationDate != undefined && this.creationDate != "") {
            this.distrubutionDateFlag = true;
        } else {
            this.distrubutionDateFlag = false;
        }

        if (this.originalAmount != null && this.originalAmount != undefined && this.originalAmount != "") {
            this.loanAmountFlag = true;
        } else {
            this.loanAmountFlag = false;
        }

        if (this.loanType != null && this.loanType != undefined && this.loanType != "") {
            this.loanCategoryFlag = true;
        } else {
            this.loanCategoryFlag = false;
        }

        if (this.interestRateType != null && this.interestRateType != undefined && this.interestRateType != "") {
            this.interestTypeFlag = true;
        } else {
            this.interestTypeFlag = false;
        }

        if (this.loanPayoffDate != null && this.loanPayoffDate != undefined && this.loanPayoffDate != "") {
            this.maturityDateFlag = true;
        } else {
            this.maturityDateFlag = false;
        }

        if (this.outstandingLoanBalance != null && this.outstandingLoanBalance != undefined && this.outstandingLoanBalance != "") {
            this.outstandingBalanceFlag = true;
        } else {
            this.outstandingBalanceFlag = false;
        }

        if (this.loanRate != null && this.loanRate != undefined && this.loanRate != "") {
            this.loanRateFlag = true;
        } else {
            this.loanRateFlag = false;
        }

        if (this.loanStatus != null && this.loanStatus != undefined && this.loanStatus != "") {
            this.loanStatusFlag = true;
        } else {
            this.loanStatusFlag = false;
        }


        if (this.paymentFrequency != null && this.paymentFrequency != undefined && this.paymentFrequency != "") {
            this.paymentFrequencyFlag = true;
        } else {
            this.paymentFrequencyFlag = false;
        }


        if (this.YTDTotal != null && this.YTDTotal != undefined && this.YTDTotal != "") {
            this.ytdTotalPaymentsFlag = true;
        } else {
            this.ytdTotalPaymentsFlag = false;
        }

        if (this.YTDPrinciple != null && this.YTDPrinciple != undefined && this.YTDPrinciple != "") {
            this.ytdPrincipalPaymentsFlag = true;
        } else {
            this.ytdPrincipalPaymentsFlag = false;
        }

        if (this.YTDInterest != null && this.YTDInterest != undefined && this.YTDInterest != "") {
            this.ytdInterestPaymentsFlag = true;
        } else {
            this.ytdInterestPaymentsFlag = false;
        }

        if (this.PYTotal != null && this.PYTotal != undefined && this.PYTotal != "") {
            this.pyTotalPaymentsFlag = true;
        } else {
            this.pyTotalPaymentsFlag = false;
        }

        if (this.PYPrinciple != null && this.PYPrinciple != undefined && this.PYPrinciple != "") {
            this.pyPrincipalPaymentsFlag = true;
        } else {
            this.pyPrincipalPaymentsFlag = false;
        }

        if (this.PYInterest != null && this.PYInterest != undefined && this.PYInterest != "") {
            this.pyInterestPaymentsFlag = true;
        } else {
            this.pyInterestPaymentsFlag = false;
        }
    }
    get premiumperPeriodMethod() {
        if (this.premiumperPeriod != null && this.premiumperPeriod != undefined) {
            return this.premiumperPeriod;
        } else {
            return 'N/A';
        }
    }
    /*connectedCallback() {
        // this.acbsValue = [];
       
    }*/

    /* let table1 = document.createElement('table');
     for (var i = 1; i < 4; i++) {
         var tr = document.createElement('tr');

         var td1 = document.createElement('td');
         var td2 = document.createElement('td');

         var text1 = document.createTextNode('Text1');
         var text2 = document.createTextNode('Text2');

         td1.appendChild(text1);
         td2.appendChild(text2);
         tr.appendChild(td1);
         tr.appendChild(td2);

         table1.appendChild(tr);
     }*/
    //this.accordianLabel = accordianHeader;
}