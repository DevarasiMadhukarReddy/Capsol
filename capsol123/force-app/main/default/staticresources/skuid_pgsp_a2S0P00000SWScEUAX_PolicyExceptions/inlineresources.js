(function(skuid){
skuid.snippet.register('createNewPolicyException',function(args) {/**
*  Purpose: Used for setting variables for creating new policy exception
*  Where: Create new policy exception button
*
* @name  createNewPolicyException.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

$('#createNewPolicyException').addClass('selected-btn');
$('#existingPolicyException').removeClass('selected-btn');

var newPolicyException = skuid.model.getModel('PolicyException');
var newPolicyExceptionRow = newPolicyException.data[0];

if(!newPolicyExceptionRow){
    var newPolicyExceptionRow = newPolicyException.createRow({
        additionalConditions: [
            { field: 'showCreatePolicyException', value:true },
            { field: 'showExistingPolicy', value: false },

        ]
    });

}else{
    newPolicyException.updateRow(newPolicyExceptionRow ,
                        { showCreatePolicyException : true ,
                          showExistingPolicy : false });

}
});
skuid.snippet.register('showExistingPolicyException',function(args) {/**
*  Purpose: Used for setting variables for displaying existing policy exception
*  Where:
*
* @name  showExistingPolicyException.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

$('#createNewPolicyException').removeClass('selected-btn');
$('#existingPolicyException').addClass('selected-btn');

var newPolicyException = skuid.model.getModel('PolicyException');
var newPolicyExceptionRow = newPolicyException.data[0];

if(!newPolicyExceptionRow){
    var newPolicyExceptionRow = newPolicyException.createRow({
        additionalConditions: [
            { field: 'showCreatePolicyException', value:false },
            { field: 'showExistingPolicy', value: true },

        ]
    });

}else{
    newPolicyException.updateRow(newPolicyExceptionRow ,
                        { showCreatePolicyException : false ,
                          showExistingPolicy : true });

}
});
skuid.snippet.register('showOfficerComments',function(args) {/**
*  Purpose: Used for hiding and showing officer comments text box based on requires approval checkbox is selected or not in the template chosen
*  Where:
*
* @name  showOfficerComments.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

var newPolicyException = skuid.model.getModel('PolicyException');
var newPolicyExceptionRow = newPolicyException.data[0];

var newPolicyExceptionCreate = skuid.model.getModel('PolicyExceptionCreate');
var newnewPolicyExceptionCreateRow = newPolicyException.data[0];

console.log('newPolicyExceptionRow approval, comments',newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__r.genesis__Requires_Approval__c,newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__r.genesis__Requires_Officer_Explanation__c);

if(newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__r.genesis__Requires_Approval__c && newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__r.genesis__Requires_Officer_Explanation__c){

    skuid.component.getById('showRequiredEditor').element.show();

}
});
skuid.snippet.register('submitAutoStatus',function(args) {/**
*  Purpose: Used for setting status to pending or approved on whether it requires approval or not
*  Where: save button of modal for creating new policy exception
*
* @name  submitAutoStatus.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

var newPolicyExceptionCreate = skuid.model.getModel('PolicyExceptionCreate');
var newnewPolicyExceptionCreateRow = newPolicyExceptionCreate.data[0];

if(!newnewPolicyExceptionCreateRow){

    if(newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__r.genesis__Requires_Approval__c){
         var newnewPolicyExceptionCreateRow = newPolicyExceptionCreate.createRow({
            additionalConditions: [
                { field: 'genesis__Status__c', value:'Pending' },

            ]
        });
    }else{
         newPolicyExceptionCreate.updateRow(newnewPolicyExceptionCreateRow ,
              { genesis__Status__c : 'Approved' ,
          });
    }

}else{

        if(newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__r.genesis__Requires_Approval__c){
            newPolicyExceptionCreate.updateRow(newnewPolicyExceptionCreateRow ,
                        { genesis__Status__c : 'Pending' ,
                          });
        }else{
            newPolicyExceptionCreate.updateRow(newnewPolicyExceptionCreateRow ,
                        { genesis__Status__c : 'Approved' ,
                          });
        }

}

skuid.model.save([newPolicyExceptionCreate]);
});
skuid.snippet.register('checkRequiredFields',function(args) {/**
*  Purpose: Used for validating all the required fields are enterd or not
*  Where: Create new policy exception modal save button
*
* @name  checkRequiredFields.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

var newPolicyExceptionCreate = skuid.model.getModel('PolicyExceptionCreate');
var newnewPolicyExceptionCreateRow = newPolicyExceptionCreate.data[0];

// Handle error messages
var displayMessage = function (message, severity) {
    //var topPanel = $('#topPanelGrid');
    var editor = $('#errorPanelCreate ').data('object').editor;
    editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};



if(!newnewPolicyExceptionCreateRow){

    if(newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__r.genesis__Requires_Officer_Explanation__c && !newnewPolicyExceptionCreateRow.genesis__Officer_Comments__c){
         return displayMessage('For selected policy exception template " Officer Comments " is mandatory  ', 'ERROR');
    }


}else{
    if(newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__c){
        if(newnewPolicyExceptionCreateRow.genesis__Policy_Exception_Definition__r.genesis__Requires_Officer_Explanation__c && !newnewPolicyExceptionCreateRow.genesis__Officer_Comments__c){
             return displayMessage('For selected policy exception template " Officer Comments " is mandatory ', 'ERROR');
        }
    }else{
        return displayMessage('Please select a policy exception template ', 'ERROR');
    }



}
});
skuid.snippet.register('clickhandler',function(args) {/**
*  Purpose: Used for clciking showExisting memos button through code
*  Where:
*
* @name  clickHandler.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

skuid.component.getById('existingPolicyException').element.click();

window.location.reload(true);
});
skuid.snippet.register('initPolicyExceptionCreate',function(args) {/**
*  Purpose:
*  Where:
*
* @name  initPolicyException.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

var newPolicyExceptionCreate = skuid.model.getModel('PolicyExceptionCreate');
var newnewPolicyExceptionCreateRow = newPolicyExceptionCreate.data[0];
});
}(window.skuid));