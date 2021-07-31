/*
 *
 * Modified by Amol - CS - 1812 - Defect: Retention Loan application functions - 8 / 20 / 2020 - Ch01
 * 
 */

import {
    LightningElement,
    api,
    track
} from 'lwc';

export default class EaRetentionBusiness extends LightningElement {
    @api legalEntity = [];
    @api loanPurpose = [];

    @api quickAction = false;
    @api editRecord = false;
    @api showHeader = false;
    @api lastPage = false;
    //change to accept advisor value as null ---06/27
    @api businessData = {
        'CaseNumber': '', //Ch01
        'CaseIdLink': '', //Ch01
        'BussinessName': '',
        'Entity': '',
        'Advisor': null
    };
    //Madhu added CS-3154 and CS-3348 to prevent dots commas and spaces special characters    
    @api handleValidation(validFlag,classname){
        console.log('searchAddtionalComparent' );
        var searchBusinessName = this.template.querySelector("."+classname);
        console.log('searchBusinessName111'+searchBusinessName);
        if(searchBusinessName!=null){
        if(validFlag){
            console.log('displayvalideflag'+validFlag );
            
              searchBusinessName.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");
            
              }
              else{
                console.log('validFlag'+validFlag);
                searchBusinessName.setCustomValidity("");
              }
        searchBusinessName.reportValidity(); 
            }
    }
    BusinessNameChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'BussinessName': event.target.value
            }
        }));
    }
    EntityChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'Entity': event.target.value
            }
        }));
    }
    AdvisorChange(event) {
        this.dispatchEvent(new CustomEvent('handlebusinessdata', {
            detail: {
                'Advisor': (event.target.value == undefined || event.target.value == '') ? '' : event.target.value
            }
        }));
    }
    checkNumberlength(event) {
        if (event.target.value.length > 18) {
            event.preventDefault();
        }
    }
}