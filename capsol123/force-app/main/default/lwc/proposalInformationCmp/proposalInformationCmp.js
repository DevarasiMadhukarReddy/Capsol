/* eslint-disable no-console */
import { LightningElement,track,api } from 'lwc';

export default class ProposalInformationCmp extends LightningElement {
    @api show=false;
    @api proposalData1 = [];
    @api finalProposalArray = [];
    @track myArray= [
        { label: '', value: '', index: 1,show:false }];
    get rows() {
        return this.myArray;
    }

    handleClick() {
        var arrLength = this.myArray.length +1;
        var currentArray = this.myArray;
        
        var newRow = [{ label: '', value: '', index: arrLength ,show:true}];
        currentArray.push(newRow[0]);
        
        for(let i=0;i<this.myArray.length;i++){
            this.proposalData1[i] = this.template.querySelector('c-proposal-row').proposalData;
            console.log(this.proposalData1[i]);
            this.finalProposalArray.push(this.proposalData1[i]);
        }
        this.myArray = currentArray;
        //console.log(this.template.querySelector('c-proposal-row'));#ffffff
        console.log('INF'+this.finalProposalArray);
    }

    handleDelete(event) {
        const textVal = event.detail;
        var currentArray = this.myArray;
        var i;
        if (textVal > -1) {
            currentArray.splice(textVal-1, 1);
        }
        for (i = 0; i < currentArray.length;) {
            currentArray[i].index = ++i;
          }
        this.myArray = currentArray;
    }
    
    
}