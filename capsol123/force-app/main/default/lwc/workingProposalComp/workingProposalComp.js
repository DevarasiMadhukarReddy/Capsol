import { LightningElement } from 'lwc';

export default class WorkingProposalComp extends LightningElement {
    get YearPicklistValues() {
        return [
            { label: '1', value: '1' },
            { label: '2', value: '2' },
            { label: '3', value: '3' },
            { label: '4', value: '4' },
            { label: '5', value: '5' },
            { label: '6', value: '6' },
            { label: '7', value: '7' },
            { label: '8', value: '8' },
            { label: '9', value: '9' },
            { label: '10', value: '10' }
        ];
    }
    setData(data){
        this.template.querySelector('[data-id="RequestedLoanAmount"]').value=data.RequestedLoanAmount;
        this.template.querySelector('[data-id="RequestedTermLength"]').value=data.RequestedTermLength;
    }
    getData(){
        return {
            'RequestedLoanAmount':this.template.querySelector('[data-id="RequestedLoanAmount"]').value,
            'RequestedTermLength':this.template.querySelector('[data-id="RequestedTermLength"]').value
        }
    }

}