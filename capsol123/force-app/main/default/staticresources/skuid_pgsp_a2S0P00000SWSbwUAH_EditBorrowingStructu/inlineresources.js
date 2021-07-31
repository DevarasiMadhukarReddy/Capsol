(function(skuid){
skuid.snippet.register('UpdateParty',function(args) {var params = arguments[0],
$ = skuid.$;

var newPartyModel = skuid.model.getModel('EditNGParty');
var newPartyRow = newPartyModel.data[0];

var newAccountModel = skuid.model.getModel('EditNGPartyAccount');
var newAccountRow = newAccountModel.data[0];

var newContactModel = skuid.model.getModel('EditNGPartyContact');
var newContactRow = newContactModel.data[0];

var businessInfoModel = skuid.model.getModel('EditNGAccountBusinessInfo');
var businessInfoRow = businessInfoModel.data[0];

var collateralOwnerModel = skuid.model.getModel('EditNGCollateralOwner');
var collData = [];
collateralOwnerModel.data.forEach(function (colDataObj){
    if(!collateralOwnerModel.isRowMarkedForDeletion(colDataObj) && colDataObj.clcommon__Collateral__c){
        collData.push(colDataObj);
    }
});
collateralOwnerModel.data = collData;

var pageTitle = $('#EditPartyTitlePanel');
var editor = pageTitle.data('object').editor;
if(!newPartyRow.clcommon__Type__c){
    editor.handleMessages(
        [
           {
              message: 'Select Party Type for Party.',
              severity: 'ERROR'
           },
        ]
    );
    return;
}
var partyArgs = {};
if(newContactRow && newContactRow.LastName){
    partyArgs[0] = newContactModel;
}else{
    partyArgs[0] = null;
}
if(newAccountRow && newAccountRow.Name){
    partyArgs[1] = newAccountModel;
}else{
    partyArgs[1] = null;
}


var bModel = businessInfoModel;
if (Object.keys(businessInfoModel.data[0]).length <= 2){
    bModel = null;
}

var res = saveParty(newPartyModel,partyArgs[0],partyArgs[1],bModel,collateralOwnerModel);
var resObj = JSON.parse(res);
if(resObj.status == 'SUCCESS'){
    editor.handleMessages(
        [
          {
              message: 'Record is successfully saved!',
              severity: 'INFO'
          },
        ]
    );
    closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,relationship-iframe']});
}else{
    $("#PartySaveButton").button('enable');
    editor.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          },
        ]
    );
}
});
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

closeTopLevelDialogAndRefresh();
});
}(window.skuid));