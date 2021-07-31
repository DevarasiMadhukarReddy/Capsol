(function(skuid){
skuid.snippet.register('fieldValidation',function(args) {/**
*  Purpose: Used for validating required fields in step 3 of wizard .Displays error message accordingly on violation
*  Where: step 3 Next button click snippet
*
* @name  Fieldvalidation.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/

//params will contail all the info about the context of call like which record data calles it,what condition,etc
var params = arguments[0],
	$ = skuid.$;

var newCollateralModel = skuid.model.getModel('Collateral');

var newCollateralRow = newCollateralModel.data[0];

//fetch the wizard object
var wizard = $('.nx-wizard').data('object');
//fetch wizard current step
var currentStep = wizard.steps[wizard.currentstep];

// Handle error messages
var displayMessage = function (message, severity) {

    var editor = $('#detailsPage ').data('object').editor;
    editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];

if(!newAppCollRow){
    var newAppCollRow = newAppCollModel.createRow();
}

//validation condition
if(newCollateralRow.NewCollateral){

    if(newCollateralRow.clcommon__Collateral_Name__c && newCollateralRow.clcommon__Collateral_Code__c ){
        currentStep.navigate('step4');
    }
    else{
         return displayMessage('Fill all the fields marked in red ', 'ERROR');
    }

}
else{
    //navigate to step 4 in wizard
    currentStep.navigate('step4');
}
});
skuid.snippet.register('newCollateral',function(args) {/**
*  Purpose: Used for creating new collateral in the system.Sets values for UI only fields for rendering
*  Where: step 1 new collateral button
*
* @name  newCollateral.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


var params = arguments[0],
$ = skuid.$;

$('#newcollateralid').addClass('selected-btn');
$('#existingCollateralId').removeClass('selected-btn');

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

//add values to UI only fields which will be used for rendering
if(!newCollateralCloneRow){
    var newCollateralCloneRow = newCollateralCloneModel.createRow({
        additionalConditions: [
            { field: 'NewCollateral', value:true },
            { field: 'ExistingCollateral', value: false },
        ]
    });

}else{
    newCollateralCloneModel.updateRow(newCollateralCloneRow ,
                        { NewCollateral : true ,
                          ExistingCollateral : false });

}
});
skuid.snippet.register('existingCollateral',function(args) {/**
*  Purpose: Used for updating existing collateral in the system.Sets values for UI only fields for rendering
*  Where: step 1 existing collateral button
*
* @name  existingCollateral.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


var params = arguments[0],
$ = skuid.$;

$('#newcollateralid').removeClass('selected-btn');
$('#existingCollateralId').addClass('selected-btn');

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

//add values to UI only fields which will be used for rendering
if(!newCollateralCloneRow){
    var newCollateralCloneRow = newCollateralCloneModel.createRow({
        additionalConditions: [
            { field: 'NewCollateral', value:false },
            { field: 'ExistingCollateral', value: true },
        ]
    });

}else{
    newCollateralCloneModel.updateRow(newCollateralCloneRow ,
                        { NewCollateral : false ,
                          ExistingCollateral : true });

}
});
skuid.snippet.register('saveCollateral',function(args) {/**
*  Purpose: This will be called on click of final save buttonin step 4. It willl call static resource function mapCollateral
*  which will create an object out of passed model rows and pass it to apex through remoting and apex then perform  CRUD on it.
*  Where: step 4 Save button
*
* @name  saveCollateral.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/

var params = arguments[0],
$ = skuid.$;

// Handle error messages
var displayMessage = function (message, severity) {
    var editor = $('#errorMessagePledgeAmountId ').data('object').editor;
    editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};


var editor = $('#errorMessagePledgeAmountId ').data('object').editor;
var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];

if(!newAppCollRow.genesis__Pledge_Amount__c ){
    return displayMessage('Enter pledge amount ', 'ERROR');
}
editor.messages.empty();
if(newAppCollRow.genesis__Pledge_Amount__c && newAppCollRow.genesis__Pledge_Amount__c===0){
    return displayMessage('Enter pledge amount greater than 0', 'ERROR');
}
newAppCollModel.updateRow(newAppCollRow, {'genesis__Application__c':skuid.page.params.id});
});
skuid.snippet.register('typeValidation',function(args) {/**
*  Purpose: Used for validation of whether user has selected any collateral type/collateral or not based on what he has chosen a
*  step before.Only allows users to goto next step if passed.
*  Where: step 2 next button
*
* @name  typeValidation.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/



var params = arguments[0],
$ = skuid.$;

var newCollateralTypeModel = skuid.model.getModel('CollateralTypeModel');
var newCollateralTypeRow = newCollateralTypeModel.data;

var valid_collaterals =[];

$.each( newCollateralTypeRow,function( i, item ){

    valid_collaterals.push(item.Name);

});

var wizard = $('.nx-wizard').data('object');
var currentStep = wizard.steps[wizard.currentstep];

var editor = $('#PanelForAll ').data('object').editor;
editor.clearMessages();

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

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var newAppCollateralCloneModel = skuid.model.getModel('ApplicationCollateralClone');
var newAppCollateralCloneRow = newAppCollateralCloneModel.data[0];


if(newCollateralCloneRow.ExistingCollateral){
    if (!newAppCollateralCloneRow.genesis__Collateral__c) {
        return displayMessage('Select a collateral ', 'ERROR');
    }
    var newAppCollCloneModel = skuid.model.getModel('ApplicationCollateralClone');
    var newAppCollCloneRow = newAppCollCloneModel.data[0];

    if(newAppCollCloneRow.genesis__Collateral__r.clcommon__Collateral_Type__c) {
         if(valid_collaterals.indexOf(newAppCollCloneRow.genesis__Collateral__r.clcommon__Collateral_Type__r.Name) < 0){
             return displayMessage('Selected collateral does not have a valid type associated ', 'ERROR');
         }
    } else {
        return displayMessage('Selected Collateral Does Not Have a Valid Type Associated . ', 'ERROR');
    }
    newAppCollCloneModel.updateRow(newAppCollCloneRow,'genesis__justForCheck__c','true');

    skuid.$C('commonEditor').render();

    if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Aircraft') {
        skuid.$C('aircraftEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Mobile Home' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Equipment') {
        skuid.$C('mobileHomeEquEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Pleasure Boat' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Receivables') {
        skuid.$C('pleaseureBotReceivablesEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Ship') {
        skuid.$C('shipEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Trailer') {
        skuid.$C('trailerEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other Titled') {
        skuid.$C('otherTitledEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Note/Instrument') {
        skuid.$C('noteinstrumentEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Securities') {
        skuid.$C('securitiesEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Savings/CD\'s') {
        skuid.$C('savingcdEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Letter of Credit') {
        skuid.$C('letterofcreditEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Receipts/Bills') {
        skuid.$C('receiptbillsEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Life Insurance') {
        skuid.$C('lifeinsuranceEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Government Contracts') {
        skuid.$C('govtContractEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'All Real Estate Types' || newCollateralRow.clcommon__Collateral_Type__r.Name == '1-4 Family' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'All Real Estate Types' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Construction' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Multi-Family' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Lot' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Land' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Farm Land' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Office' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Warehouse'  ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Retail'  ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Oil and Gas' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other RE' ) {
        skuid.$C('mixedReEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other Possessory') {
        skuid.$C('otherprocesseryEditor').render();
    }

    currentStep.navigate('step3');

}else{
    if (!newCollateralRow.clcommon__Collateral_Type__c) {
        return displayMessage('Select a Collateral Type ', 'ERROR');

    }
    if(newCollateralRow.clcommon__Collateral_Type__c && newCollateralRow.clcommon__Collateral_Type__r.Name){
         if(valid_collaterals.indexOf(newCollateralRow.clcommon__Collateral_Type__r.Name) < 0){
             return displayMessage('Selected Collateral Type Is Not Supported ', 'ERROR');
         }
    }else{
        return displayMessage('Selected Collateral Type Is Not Supported . ', 'ERROR');
    }

    skuid.$C('commonEditor').render();

    if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Aircraft') {
        skuid.$C('aircraftEditor').render();
    }
    else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Mobile Home' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Equipment') {
        skuid.$C('mobileHomeEquEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Pleasure Boat' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Receivables') {
        skuid.$C('pleaseureBotReceivablesEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Ship') {
        skuid.$C('shipEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Trailer') {
        skuid.$C('trailerEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other Titled') {
        skuid.$C('otherTitledEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Note/Instrument') {
        skuid.$C('noteinstrumentEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Securities') {
        skuid.$C('securitiesEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Savings/CD\'s') {
        skuid.$C('savingcdEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Letter of Credit') {
        skuid.$C('letterofcreditEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Receipts/Bills') {
        skuid.$C('receiptbillsEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Life Insurance') {
        skuid.$C('lifeinsuranceEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Government Contracts') {
        skuid.$C('govtContractEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'All Real Estate Types' || newCollateralRow.clcommon__Collateral_Type__r.Name == '1-4 Family' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'All Real Estate Types' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Construction' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Multi-Family' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Lot' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Land' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Farm Land' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Office' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Warehouse'  ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Retail'  ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Oil and Gas' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other RE' ) {
        skuid.$C('mixedReEditor').render();
    } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other Possessory') {
        skuid.$C('otherprocesseryEditor').render();
    }

    currentStep.navigate('step3');

}
});
skuid.snippet.register('step2PrevButton',function(args) {/**
*  Purpose: Used for refreshing the error panel when user move back to  previous step in step 3
*  Where: step 3 back button
*
* @name  step2PrevButton.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//params will contail all the info about the context of call like which record data calles it,what condition,etc
var params = arguments[0],
	$ = skuid.$;

//fetch the wizard object
var wizard = $('.nx-wizard').data('object');
//fetch wizard current step
var currentStep = wizard.steps[wizard.currentstep];

var editor = $('#PanelForAll ').data('object').editor;
editor.clearMessages();
//navigate to step 1 in wizard
currentStep.navigate('step1');
});
skuid.snippet.register('ApplicationCollateralUpdate',function(args) {/**
*  Purpose: Used for updating application and collateral junction object applicationCollateral with appId and collateralId and pledge amount
*  Where: step 4 next button
*
* @name  applicationCollateral.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/



var params = arguments[0],
	$ = skuid.$;

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];
newAppCollModel.cancel();

//get filterable off id
var appCollCondition = newAppCollModel.getConditionByName('genesis__Application__c_fil');

//setting condition value
newAppCollModel.setCondition(appCollCondition, skuid.page.params.id);

newAppCollModel.activateCondition(appCollCondition);

//updating model
newAppCollModel.updateData();
});
skuid.snippet.register('CloseCollateralDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

closeTopLevelDialogAndRefresh({divIds: ['deal-dashboard-iframe,collateral-tab','deal-dashboard-iframe,document-iframe']});
});
skuid.snippet.register('buttonHighlight',function(args) {var params = arguments[0],
	$ = skuid.$;
$('#newcollateralid').addClass('selected-btn');
$('#existingCollateralId').removeClass('selected-btn');
});
}(window.skuid));