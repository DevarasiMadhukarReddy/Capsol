import { LightningElement,api } from 'lwc';

export default class WcProposalComp extends LightningElement {
    @api editRecord=false;
    @api showHeader=false;
    @api quickaction=false;
    @api classic=false;
    get YearPicklistValues() {
        return [
           // { label: '1 Year', value: '1' },
           // { label: '2 Years', value: '2' },
            { label: '3 Years', value: '3' },
           // { label: '4 Years', value: '4' },
            { label: '5 Years', value: '5' },
           // { label: '6 Years', value: '6' },
            { label: '7 Years', value: '7' },
           // { label: '8 Years', value: '8' },
           // Madhu added 9 years on 27/08/2020 CS-1991
            { label: '9 Years', value: '9' },
           // { label: '10 Years', value: '10' }
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
    @api proposalInfo={
        "RequestedLoanAmount":0,
        "RequestedTermLength":""
    }
    handleLoanAmount(event){
        this.dispatchEvent(new CustomEvent('handleproposaldata',{detail:{'RequestedLoanAmount': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));

    }
    handleTermLength(event){
        this.dispatchEvent(new CustomEvent('handleproposaldata',{detail:{'RequestedTermLength': event.target.value==null?'':event.target.value}}));
    }
}