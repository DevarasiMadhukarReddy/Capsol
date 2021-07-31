/* eslint-disable no-empty-function */
/* eslint-disable getter-return */
/* eslint-disable no-constant-condition */
/* eslint-disable no-cond-assign */
/* eslint-disable no-return-assign */
/* eslint-disable no-console */
/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */
import {
    LightningElement,
    track,
    api,
    wire
} from 'lwc';
 

import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';



export default class Communityexample extends LightningElement {
    @api show=false;
    @api businessLegalNameDBAVal='';
    @api noOfAdvisorsVal=0;
    @api legalEntityTypeVal = '';
    @api currentRegistrationVal = '';
    @api currentCustodianVal = '';
    @api formData=[];

   /* @api formData=[{
        businessLegalNameDBA : '',
        noOfAdvisors : '',
        legalEntityType:'',
        currentRegistration:'',
        currentCustodian:'',
        mutualFundsDirectlyHeld:'',
        mutualFundsCustodied:'',
        variableAnnuties:'',
        fixedAnnuties:'',
        fixedIncome:'',
        equity:'',
        aiUITCash:'',
        totalAdvisoryAUM:'',
        advisoryRevenue:'',
        brokerageRevenue:'',
        totalAUM:'',
        totalProduction:'',
        borrowersData:'',
        proposalOffers:''
    }]
    @api borrowersData=[{
        borrowerName:'',
        splitOfSumAUM:'',
        aumAttributable:'',
        primaryContact:true

    }]
    @api proposalOffers=[{
        platform:'',
        osjLEName:'',
        termLength:'',
        uwType:'',
        campaignName:'',
    }]*/

   /* get businessLegalNameDBA(){
        return this.businessLegalNameDBA;
    }

    set businessLegalNameDBA(value){
        this.businessLegalNameDBA = value;
        this.formData.businessLegalNameDBAVal = value;
    }
    get noOfAdvisors(){
        return this.noOfAdvisors;
    }
    set noOfAdvisors(value){
        this.noOfAdvisors = value;
        this.formData.noOfAdvisorsVal = value;
    }
*/
    handlebusinessLegalNameDBA(event) {
     
            this.businessLegalNameDBAVal =  event.target.value;
            //this.formData.businessLegalNameDBA = this.businessLegalNameDBAVal;
            //this.formData.push({businessLegalNameDBA:this.businessLegalNameDBAVal});
            this.formData = [...this.formData,{businessLegalNameDBA:this.businessLegalNameDBAVal}];
       /* this.formData.forEach(_element => { 
            if(_element.name = 'businessLegalNameDBA'){
                _element.value = this.businessLegalNameDBA;
                this.formData.push(_element);
                this.businessLegalNameDBA = _element.value;
            }
        });*/
        const selectedbusinessLegalNameDBA = new CustomEvent("businessLegalNameDBAchange", {
            detail: this.formData
          });
      
          // Dispatches the event.
          this.dispatchEvent(selectedbusinessLegalNameDBA);
        //console.log(this.formData);
    }
    handlenoOfAdvisors(event) {
        this.noOfAdvisorsVal = event.target.value;
        //this.formData.noOfAdvisors = this.noOfAdvisorsVal;
        //this.formData.push({noOfAdvisors:this.noOfAdvisorsVal});
        this.formData = [...this.formData,{noOfAdvisors:this.noOfAdvisorsVal}];

        const selectednoOfAdvisors = new CustomEvent("noOfAdvisorschange", {
            detail: this.formData
          });
      
          // Dispatches the event.
          this.dispatchEvent(selectednoOfAdvisors);

       // console.log(this.formData);
    }
    handlelegalEntityType(event) {
        this.legalEntityTypeVal = event.target.value;
            //this.formData.legalEntityType = event.target.value;
            //this.formData.push({legalEntityType:this.legalEntityTypeVal});
            this.formData = [...this.formData,{legalEntityType:this.legalEntityTypeVal}];

            const selectedlegalEntityType = new CustomEvent("legalEntityTypechange", {
                detail: this.formData
              });
          
              // Dispatches the event.
              this.dispatchEvent(selectedlegalEntityType);
    
            //console.log(this.formData);
    }
    handlecurrentRegistration(event) {
        this.currentRegistrationVal = event.target.value;
            //this.formData.currentRegistration = event.target.value;
            
           // this.formData.push({currentRegistration:this.currentRegistrationVal});
           this.formData = [...this.formData,{currentRegistration:this.currentRegistrationVal}];

           const selectedCurrentRegistration = new CustomEvent("currentRegistrationchange", {
            detail: this.formData
          });
      
          // Dispatches the event.
          this.dispatchEvent(selectedCurrentRegistration);
           // console.log(this.formData);
    }
    @api
    handlecurrentCustodian(event) {
        event.preventDefault();
        this.currentCustodianVal = event.target.value;
            //this.formData.currentCustodian = event.target.value;
            //this.formData.push({currentCustodian:this.currentCustodianVal});
            this.formData = [...this.formData,{currentCustodian:this.currentCustodianVal}];
           // console.log(this.formData);
            const selectedCurrentCustodian = new CustomEvent("currentCustodianchange", {
                detail: this.formData,
                bubbles:true,
                composed:true
                
              });
          
              // Dispatches the event.
              this.dispatchEvent(selectedCurrentCustodian);
            //console.log(this.formData);
    }

    set finaldata(value){

        this.formData = value;

    }
    @api loanWrapperObj;
   
 
    
}