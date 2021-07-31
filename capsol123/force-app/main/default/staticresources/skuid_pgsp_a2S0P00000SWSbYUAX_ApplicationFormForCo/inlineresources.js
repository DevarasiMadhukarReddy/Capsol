(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$('#nickname-popup').one('pageload', function() {
    	console.log(skuid.page);
    	console.log(skuid.page.params);
	});
	$(document.body).one('pageload',function(){
	    skuid.snippet.getSnippet('fetchAccountData')();
        skuid.snippet.getSnippet('fetchContactData')();  
	});
})(skuid);;
skuid.snippet.register('fetchAccountData',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var applicationRowData = skuid.model.getModel('CommonApplicationClonedModel').data[0];
var ClonedAccountModel = skuid.model.getModel('ClonedAccountModel');
var biModel = skuid.model.getModel('ClonedBusinessInforModel');

ClonedAccountModel.emptyData();
biModel.emptyData();

if(applicationRowData && applicationRowData.genesis__Account__c){
    var accountIdCondition = ClonedAccountModel.getConditionByName('CommonAccId');
    ClonedAccountModel.setCondition(accountIdCondition,applicationRowData.genesis__Account__c);
    skuid.model.updateData([ClonedAccountModel],function(){
        if(!(ClonedAccountModel.data && ClonedAccountModel.data.length > 0)){
            var newPSRow = ClonedAccountModel.createRow({ });
        }else if(ClonedAccountModel.data[0].genesis__Business_Information__c){
            // fetch business info
            var bIdCondition = biModel.getConditionByName('BusinessInfoId');
            biModel.setCondition(bIdCondition,ClonedAccountModel.data[0].genesis__Business_Information__c);
            skuid.model.updateData([biModel],function(){
                
            });
        }else{
            var newBIRow = biModel.createRow({ });
        }
    });
}else{
    if(!(ClonedAccountModel.data && ClonedAccountModel.data.length > 0)){
        var newPSRow = ClonedAccountModel.createRow({ });
        var newBIRow = biModel.createRow({ });
    } 
}
});
skuid.snippet.register('fetchContactData',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var applicationRowData = skuid.model.getModel('CommonApplicationClonedModel').data[0];
var ClonedContactModel = skuid.model.getModel('ClonedContactModel');
ClonedContactModel.emptyData();
if(applicationRowData && applicationRowData.genesis__Contact__c){
    if(applicationRowData.genesis__Contact__c){
        var contactIdCondition = ClonedContactModel.getConditionByName('CommonContactId');
        ClonedContactModel.setCondition(contactIdCondition,applicationRowData.genesis__Contact__c);
        skuid.model.updateData([ClonedContactModel],function(){
            if(!(ClonedContactModel.data && ClonedContactModel.data.length > 0)){
                var newPSRow = ClonedContactModel.createRow({ });
            }
        });
    }
}else{
    if(!(ClonedContactModel.data && ClonedContactModel.data.length > 0)){
        var newPSRow = ClonedContactModel.createRow({ });
    }
}
});
skuid.snippet.register('saveApplication',function(args) {var params = arguments[0],
	$ = skuid.$;

var newAppParams = {};
var editorWrapper = $('#AppDetailTitleHeader1'); 
var editor = editorWrapper.data('object').editor;
var fetchIncludedPageData = skuid.snippet.getSnippet('getIncludedPageData');
var result = fetchIncludedPageData();
if(!result){
    editor.handleMessages(
        [
          {
              message: 'Unable to save Application data.',
              severity: 'ERROR'
          },
        ]
    );
}

var applicationModel = result['genesis__Applications__c'];
var appRow = applicationModel.data[0];
var appRecordTypeRow = skuid.model.getModel('ApplicationRecordTypeModel').getFirstRow();
appRow.RecordTypeId = appRecordTypeRow.Id;
if(skuid.page.params.id){
    appRow.genesis__Parent_Application__c = skuid.page.params.id;    
}

var selectedProductModel = skuid.model.getModel('SelectedProductClone');
var selectedProductRow = selectedProductModel.data[0];
if(selectedProductRow.Id && selectedProductRow.Id.length > 14){
    appRow.genesis__CL_Product__c = selectedProductRow.Id;
}

var contactModel = skuid.model.getModel('ClonedContactModel');
var contactRow = contactModel.data[0];

var accountModel = skuid.model.getModel('ClonedAccountModel');
var accRow = accountModel.data[0];

var businessModel = skuid.model.getModel('ClonedBusinessInforModel');
var businessRow = businessModel.data[0];

if(!appRow.genesis__Term__c){
    appRow.genesis__Term__c = 0;
}
if(!appRow.genesis__Interest_Rate__c){
    appRow.genesis__Interest_Rate__c = 0;
}
if(!appRow.genesis__Loan_Amount__c){
    appRow.genesis__Loan_Amount__c = 0;
}
if(!appRow.genesis__Credit_Limit__c){
    appRow.genesis__Credit_Limit__c = 0;
}

newAppParams.applicationM = applicationModel;
newAppParams.businessM = businessModel;
if(accRow.Name){
    newAppParams.accountM = accountModel;
}else{
    newAppParams.accountM = null;
}

if(contactRow.LastName){
    newAppParams.contactM = contactModel;
}else{
    newAppParams.contactM = null;
}
var result = saveNGApplication(newAppParams);

var resultJSON = $.parseJSON(result[0]);
if (resultJSON.status === 'ERROR') {
    editor.handleMessages(
        [
          {
              message: resultJSON.errorMessage,
              severity: 'ERROR'
          },
        ]
    );
} else {
	closeTopLevelDialogAndRefresh({window : true});
}
});
}(window.skuid));