(function(skuid){
skuid.snippet.register('ChangeFilterBtnColor',function(args) {var params = arguments[0],
	$ = skuid.$;
var covAppModel = skuid.model.getModel('AppForAddingCovenants');
var covAppRow = covAppModel.data[0];
if(covAppRow.NoFilters){
    $('#NoFilter').addClass('selected-btn');
}else{
    $('#NoFilter').removeClass('selected-btn');
}

if(covAppRow.ProductFilter){
    $('#ProductFilter').addClass('selected-btn');
}else{
    $('#ProductFilter').removeClass('selected-btn');
}
});
skuid.snippet.register('queryDefinitions',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('AppForAddingCovenants');
var appRow = appModel.data[0];

var covenantDefModel = skuid.model.getModel('ApplicableCovntDefinition');
covenantDefModel.cancel();
// fetch condition
var productTypeCondition = covenantDefModel.getConditionByName('clcommon__Product__c');
covenantDefModel.deactivateCondition(productTypeCondition);
if(appRow.ProductFilter){
    covenantDefModel.setCondition(productTypeCondition, appRow.genesis__CL_Product__c);
}
skuid.model.updateData([covenantDefModel],function(){ 
    var wizard = $('.nx-wizard').data('object'); 
    var currentStep = wizard.steps[wizard.currentstep];
    currentStep.navigate('step2');
});
});
skuid.snippet.register('initializeCovenants',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('AppForAddingCovenants');
var appRow = appModel.data[0];
var startDate;
if(appRow.genesis__Expected_First_Payment_Date__c){
    startDate = new Date(appRow.genesis__Expected_First_Payment_Date__c);
}else{
    startDate = new Date(appRow.genesis__Expected_Close_Date__c);
}

var otherParamsMap = {};

otherParamsMap['startDay'] = startDate.getDate();
otherParamsMap['startMonth'] = startDate.getMonth()+1;
otherParamsMap['startYear'] = startDate.getFullYear();
otherParamsMap['applicationId'] = appRow.Id;

var res = sforce.apex.execute('genesis.SkuidCovenantCtrl','generateCovenantsFromDefinitions', {
                                covenantDefinitions : JSON.stringify(params.rows) ,
                                otherParams : JSON.stringify(otherParamsMap)
                            });
var resObj = JSON.parse(res);
if(resObj.status == 'SUCCESS'){
    var newCovenantsModel = skuid.model.getModel('NewlyCreatedCovenantsForApp');
    newCovenantsModel.data = [];
    for (i = 0; i < resObj.content.length; i++) { 
        var newRow = newCovenantsModel.createRow({
            additionalConditions: [
                { field: 'clcommon__Account__c', value:resObj.content[i].clcommon__Account__c },
                { field: 'clcommon__Active__c', value:true },
                { field: 'clcommon__Covenant_Definition__c', value:resObj.content[i].clcommon__Covenant_Definition__c },
                { field: 'clcommon__Covenant_Definition__r', value:resObj.content[i].clcommon__Covenant_Definition__r },
                { field: 'clcommon__Expiration_Date__c', value:resObj.content[i].clcommon__Expiration_Date__c },
                { field: 'clcommon__Financial_Indicator__c', value:resObj.content[i].clcommon__Financial_Indicator__c },
                { field: 'clcommon__Financial_Indicator_High_Value__c', value:resObj.content[i].clcommon__Financial_Indicator_High_Value__c },
                { field: 'clcommon__Financial_Indicator_Low_Value__c', value:resObj.content[i].clcommon__Financial_Indicator_Low_Value__c },
                { field: 'clcommon__Financial_Operator__c', value:resObj.content[i].clcommon__Financial_Operator__c },
                { field: 'clcommon__Frequency__c', value:resObj.content[i].clcommon__Frequency__c },
                { field: 'clcommon__Notification_Days__c', value:resObj.content[i].clcommon__Notification_Days__c },
            ]
        });   
    }
    // move to next step
    var wizard = $('.nx-wizard').data('object');
    var currentStep = wizard.steps[wizard.currentstep];
    currentStep.navigate('step3');
}else{
    var pageTitle = $('#initializeErrorTile');
    var editor = pageTitle.data('object').editor; 
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
skuid.snippet.register('SaveCovenants',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('AppForAddingCovenants');
var appRow = appModel.data[0];
var startDate;
if(appRow.genesis__Expected_First_Payment_Date__c){
    startDate = new Date(appRow.genesis__Expected_First_Payment_Date__c);
}else{
    startDate = new Date(appRow.genesis__Expected_Close_Date__c);
}

var otherParamsMap = {};
otherParamsMap['applicationId'] = appRow.Id;
otherParamsMap['startDay'] = startDate.getDate();
otherParamsMap['startMonth'] = startDate.getMonth()+1;
otherParamsMap['startYear'] = startDate.getFullYear();

var newCovenantsModel = skuid.model.getModel('NewlyCreatedCovenantsForApp');
var res = sforce.apex.execute('genesis.SkuidCovenantCtrl','saveCovenants', {
                                covenantsJson : JSON.stringify(buildSObject(newCovenantsModel,true)) ,
                                otherParams : JSON.stringify(otherParamsMap)
                            });
var resObj = JSON.parse(res);
if(resObj.status == 'SUCCESS'){
    skuid.$('.ui-dialog-content').last().dialog('close');
}else{
    var pageTitle = $('#saveCovenantErrorTitle');
    var editor = pageTitle.data('object').editor; 
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
}(window.skuid));