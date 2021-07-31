import { LightningElement,api,track } from 'lwc';

export default class EaRetentionFinancial extends LightningElement {
    @api quickAction=false;
    @api editRecord=false;
    @api showHeader=false; 
    @api lastPage=false;

    @api financialData={
        'LoanAmount':0,
        'IntrestRate':0,
        'LoanTerm':'',
        'FundingDate':''
    };
    get YearPicklistValues() {
        return [
            /*{ label: '1 Year', value: '1 Year' },
            { label: '2 Years', value: '2 Years' },
            { label: '3 Years', value: '3 Years' },
            { label: '4 Years', value: '4 Years' },*/
            { label: '5 Years', value: '5 Years' },
            /*{ label: '6 Years', value: '6 Years' },*/
            { label: '7 Years', value: '7 Years' }/*,
            { label: '8 Years', value: '8 Years' },
            { label: '9 Years', value: '9 Years' },
            { label: '10 Years', value: '10 Years' }*/
        ];
    }
    checkNumberlength(event){
        if(event.target.value.length>=15){
            event.preventDefault();
        }
        this.checkdecimalvalue(event);
    }
    checkdecimalvalue(event){
        //alert('d');
        //alert(event.target.value.split('.'));
        
        if(event.target.value.split('.').length==2){
            if(event.target.value.split('.')[1]>=3){
                event.preventDefault();
            }
        }
    }
     // start added by Madhukar Reddy Interest rate restrict to two decimal places CS-1985
    checkNumberlength1(event){
        if(event.target.value.length>=5){
            event.preventDefault();
        }
        this.checkdecimalvalue1(event);
    }
    checkdecimalvalue1(event){
        //alert('d');
        //alert(event.target.value.split('.'));
        
        if(event.target.value.split('.').length==3){
            if(event.target.value.split('.')[1]>=3){
                event.preventDefault();
            }
        }
    }
  // Ended added by Madhukar Reddy Interest rate restrict to two decimal places CS-1985
    LoanAmountChange(event){
        this.dispatchEvent(new CustomEvent('handlefinancedata',{detail:{'LoanAmount':(event.target.value==null || event.target.value==undefined || event.target.value=="")?0:parseFloat(event.target.value)}}));
    }
    IntrestRateChange(event){
        this.dispatchEvent(new CustomEvent('handlefinancedata',{detail:{'IntrestRate':(event.target.value==null || event.target.value==undefined || event.target.value=="")?0:parseFloat(event.target.value)}}));
    }
    LoanTermChange(event){
        this.dispatchEvent(new CustomEvent('handlefinancedata',{detail:{'LoanTerm':event.target.value}}));
    }
    FundingDateChange(event){
        this.dispatchEvent(new CustomEvent('handlefinancedata',{detail:{'FundingDate':event.target.value}}));
    }
}