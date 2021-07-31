(function(skuid){
skuid.snippet.register('CreateNewAdhoc',function(args) {/**
*  Purpose: Used for setting paramemters for displaying create new ad hoc fee and hiding others
*  Where: create new Ad-hoc button
*
* @name  createNewAdhoc.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

//highlighting the selected button
$('#newCreateAdhocid').addClass('selected-btn');
$('#newCreateTemplateid').removeClass('selected-btn');
$('#showExistingChargesId').removeClass('selected-btn');

var newChargeModel = skuid.model.getModel('FeeCharge');
var newChargeRow = newChargeModel.data[0];

var newFeeModel = skuid.model.getModel('FeeDefModel');
var newFeeRow = newFeeModel.data[0];

//setting paramemts for hiding and displaying editors for creating/showing fee
if(!newChargeRow){
    var newChargeRow = newChargeModel.createRow({
        additionalConditions: [
            { field: 'NewCreateAdhoc', value:true },
            { field: 'NewCreateTemplate', value: false },
            { field: 'viewExisting', value: false },
        ]
    });

   skuid.component.getById('tableExistingId').element.hide();

}else{
    newChargeModel.updateRow(newChargeRow ,
                        { NewCreateAdhoc : true ,
                          NewCreateTemplate : false,
                          viewExisting:false });

   skuid.component.getById('tableExistingId').element.show();

}
});
skuid.snippet.register('CreateNewTemplate',function(args) {/**
*  Purpose: Used for setting paramemters for displaying create new template fee and hiding others
*  Where: create new Ad-hoc button
*
* @name  createNewTemplateFee.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

//highlighting the selected button
$('#newCreateAdhocid').removeClass('selected-btn');
$('#newCreateTemplateid').addClass('selected-btn');
$('#showExistingChargesId').removeClass('selected-btn');

var newChargeModel = skuid.model.getModel('FeeCharge');
var newChargeRow = newChargeModel.data[0];

var newFeeModel = skuid.model.getModel('FeeDefModel');
var newFeeRow = newFeeModel.data[0];


//setting param for NewCreateTemplate true
if(!newChargeRow){
    var newChargeRow = newChargeModel.createRow({
        additionalConditions: [
            { field: 'NewCreateAdhoc', value:false },
            { field: 'NewCreateTemplate', value: true },
        ]
    });

}else{
    newChargeModel.updateRow(newChargeRow ,
                        { NewCreateAdhoc : false ,
                          NewCreateTemplate : true });



}
});
skuid.snippet.register('createTemplateSnippet',function(args) {/**
*  Purpose: Used for creating rows in memory to make it editable on step 2
*  Where: apply charge button in wizard
*
* @name  createTemplateSnippet.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/



var $ = skuid.$,
action = arguments[0].action,
list = arguments[0].list,
model = arguments[0].model,
selectedItems = list.getSelectedItems();

var editor = $('#errorDisplayPopupFees ').data('object').editor;

// Handle error messages
var displayMessage = function (message, severity) {

    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};

if(!selectedItems || selectedItems.length===0){
    return displayMessage('Please select a row ', 'ERROR');
}

var wizard = $('.nx-wizard').data('object');
var currentStep = wizard.steps[wizard.currentstep];

var rowToupdates =[];
var rowUpdates ={};

    $.each( selectedItems,function( i, item ){
        rowUpdates ={};
        var row = item.row;
        $.each( row,function( f, val ){
            if ((f == 'clcommon__Amount__c')) {
                rowUpdates['genesis__Amount__c'] = val;

            }

            if ((f == 'Name')) {
                rowUpdates['Name'] = val;
            }

            if ((f == 'Id')) {
                rowUpdates['clcommon__Fee_Definition__c'] = val;
            }

            if ((f == 'clcommon__Type__c')) {
                rowUpdates['clcommon__Type__c'] = val;
            }

        });

        rowToupdates.push(rowUpdates);


    });


var newChargeModel = skuid.model.getModel('FeeChargeClone2');
newChargeModel.cancel();
var newChargeRow = newChargeModel.data[0];


$.each( rowToupdates,function( i, item ){
    newChargeModel.createRow( {
        additionalConditions: [

            { field :'clcommon__Original_Amount__c',value :item.genesis__Amount__c },
            { field :'clcommon__Fee_Definition__c',value :item.clcommon__Fee_Definition__c },
            {field : 'genesis__Application__c',value : skuid.page.params.id},
            {field : 'clcommon__Type__c',value : item.clcommon__Type__c}
        ]});

});


skuid.component.getById('saveFeeInPopUp').element.show();
skuid.component.getById('cancelFeeInPopup').element.show();

currentStep.navigate('step2');
});
skuid.snippet.register('showExistingCharges',function(args) {/**
*  Purpose: Used for showing exisiting chnarges and setting parameters for displaying
*  Where: create new Ad-hoc button
*
* @name  showExistingChrnges.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

//highlighting the selected button
$('#newCreateAdhocid').removeClass('selected-btn');
$('#newCreateTemplateid').removeClass('selected-btn');
$('#showExistingChargesId').addClass('selected-btn');


var newChargeModel = skuid.model.getModel('FeeCharge');
var newChargeRow = newChargeModel.data[0];

var newChargeCloneModel = skuid.model.getModel('FeeChargeCloneModel');
var newChargeCloneRow = newChargeCloneModel.data[0];

var newFeeModel = skuid.model.getModel('FeeDefModel');
var newFeeRow = newFeeModel.data[0];

if(!newChargeRow){
    var newChargeRow = newChargeModel.createRow({
        additionalConditions: [
            { field: 'NewCreateAdhoc', value:false },
            { field: 'NewCreateTemplate', value: false },
            { field: 'showExistingCharges', value: true },
        ]
    });
    skuid.component.getById('tableExistingId').element.show();

}else{
    newChargeModel.updateRow(newChargeRow ,
                        { NewCreateAdhoc : false ,
                          NewCreateTemplate : false , 'showExistingCharges': true});

    skuid.component.getById('tableExistingId').element.show();

}
});
skuid.snippet.register('checkRequiredFields',function(args) {/**
*  Purpose: Used for validating before save
*  Where: Create fees Modal
*
* @name  checkRequiredFields.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/



var $ = skuid.$;

var panel =  $('#errorDisplayPopupFees ');
var editor =panel.data('object').editor;
editor.messages.empty();

// Handle error messages
var displayMessage = function (message, severity) {

    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};

var newchangeMemoModel = skuid.model.getModel('FeeChargeClone2');

if(!newchangeMemoModel.data[0]){
    return displayMessage('No rows to save ', 'ERROR');
}
});
skuid.snippet.register('RenderFeeName',function(args) {var field = arguments[0],
    value = arguments[1],
	$ = skuid.$;

field.element.text(value);
});
skuid.snippet.register('resetAdhoc',function(args) {/**
*  Purpose: Used for re-setting paramemters for hiding create new ad hoc fee buttons and button color
*  Where: after save action on create new ad hoc fee
*
* @name  resetAdhoc.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   07-15-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

//highlighting the selected button
$('#newCreateAdhocid').removeClass('selected-btn');
$('#newCreateTemplateid').removeClass('selected-btn');


var newChargeModel = skuid.model.getModel('FeeCharge');
var newChargeRow = newChargeModel.data[0];

var newFeeModel = skuid.model.getModel('FeeDefModel');
var newFeeRow = newFeeModel.data[0];

var newChargeCloneModel = skuid.model.getModel('FeeChargeCloneModel');
var newChargeCloneRow = newChargeCloneModel.data[0];

//setting paramemts for hiding and displaying editors for creating/showing fee
if(!newChargeRow){
    var newChargeRow = newChargeModel.createRow({
        additionalConditions: [
            { field: 'NewCreateAdhoc', value:false },
            { field: 'NewCreateTemplate', value: false },
            { field: 'viewExisting', value: false },
        ]
    });

}else{
    newChargeModel.updateRow(newChargeRow ,
                        { NewCreateAdhoc : false ,
                          NewCreateTemplate : false,'viewExisting':false });

}
});
skuid.snippet.register('hideButtonsInPopup',function(args) {var params = arguments[0],
	$ = skuid.$;

skuid.component.getById('saveFeeInPopUp').element.hide();
skuid.component.getById('cancelFeeInPopup').element.hide();
});
skuid.snippet.register('resetButtonsColors',function(args) {/**
*  Purpose: Used for setting paramemters for displaying create new template fee and hiding others
*  Where: create new Ad-hoc button
*
* @name  resetButtonsColor.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   07-15-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

//highlighting the selected button
$('#newCreateAdhocid').removeClass('selected-btn');
$('#newCreateTemplateid').removeClass('selected-btn');
});
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
	$ = skuid.$;
closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe','loan-details-iframe']});
});
}(window.skuid));