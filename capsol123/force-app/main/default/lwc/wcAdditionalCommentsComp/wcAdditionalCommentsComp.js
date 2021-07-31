/*

*    CH.No   Description                                                                 Developer  Date
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
    *
    CH - 02  CS - 2953 Enhancement - Update Forgivable Application and related record 
             as read - only when offer accepted
                                                                                         Amol      03 / 26 / 2021 
    

*/
import {
    LightningElement,
    track,
    api
} from 'lwc';

export default class WcAdditionalCommentsComp extends LightningElement {
    @api additionalComments = '';
    // @api editRecord=false; // CH - 02
    @api editAddlnComments = false; // CH - 02
    @api showHeader = false;
    CommentsChange(event) {
        this.dispatchEvent(new CustomEvent('handleadditionalcomments', {
            detail: event.target.value
        }));

    }
    @api handleValidation(validFlag) {
        console.log('searchAddtionalComparent');
        var searchBusinessName = this.template.querySelector(".AdditionalComm");
        
        if (searchBusinessName != null) {
            if (validFlag) {

                searchBusinessName.setCustomValidity("Error: check for special characters in field. Only Alpha numeric, space, full stops and commas are accepted in this fields");

            } else {
                searchBusinessName.setCustomValidity("");
            }
            searchBusinessName.reportValidity();
        }
    }
}