/* eslint-disable no-console */
import { LightningElement,api } from 'lwc';

export default class ProposalRow extends LightningElement {
    @api row;
    @api show;
    @api proposalData = [];
    @api platform;
    @api branch;
    @api OSJLEName;
    @api termLength;
    @api UWType;
    @api campaignName;

    deleterow(event) {
        event.preventDefault();
        //const a = 1;

        const selectEvent = new CustomEvent('inptext', {
            detail: this.row.index
        });
        this.dispatchEvent(selectEvent);
    }

    platformChange(event){
        
        if(this.platform !== ''){
            this.proposalData.splice(0);
        }
        this.platform = event.target.value;
        this.proposalData = [...this.proposalData,{platform:this.platform}];
    }
    branchChnage(event){
        if(this.branch !== ''){
            this.proposalData.splice(1);
        }
        this.branch = event.target.value;
        this.proposalData = [...this.proposalData,{branch:this.branch}];
    }
    OSJLENameChnage(event){
        if(this.OSJLEName !== ''){
            this.proposalData.splice(2);
        }
        this.OSJLEName = event.target.value;
        this.proposalData = [...this.proposalData,{OSJLEName:this.OSJLEName}];
    }
    termLengthChange(event){
        if(this.termLength !== ''){
            this.proposalData.splice(3);
        }
        this.termLength = event.target.value;
        this.proposalData = [...this.proposalData,{termLength:this.termLength}];
    }
    UWTypePicklistChange(event){
        if(this.UWType !== ''){
            this.proposalData.splice(4);
        }
        this.UWType = event.target.value;
        this.proposalData = [...this.proposalData,{UWType:this.UWType}];
    }
    campaignNameChnage(event){
        if(this.campaignName !== ''){
            this.proposalData.splice(5);
        }
        this.campaignName = event.target.value;
        this.proposalData = [...this.proposalData,{campaignName:this.campaignName}];
        console.log(this.proposalData);
    }

}