(function(skuid){
skuid.snippet.register('ChangeFilterBtnColor',function(args) {var params = arguments[0],
	$ = skuid.$;

var covPartyModel = skuid.model.getModel('NewPartyCovAddtn');
var covPartyRow = covPartyModel.data[0];

if(covPartyRow.NoFilters){
    $('#NoFilter').addClass('selected-btn');
}else{
    $('#NoFilter').removeClass('selected-btn');
}

if(covPartyRow.RelationshipFilter){
    $('#RelationshipFilter').addClass('selected-btn');
}else{
    $('#RelationshipFilter').removeClass('selected-btn');
}

if(covPartyRow.EntityFilter){
    $('#EntityFilter').addClass('selected-btn');
}else{
    $('#EntityFilter').removeClass('selected-btn');
}

if(covPartyRow.ProductFilter){
    $('#ProductFilter').addClass('selected-btn');
}else{
    $('#ProductFilter').removeClass('selected-btn');
}
});
skuid.snippet.register('queryCovenantDefinitions',function(args) {var params = arguments[0],
$ = skuid.$;
        	
var covPartyModel = skuid.model.getModel('NewPartyCovAddtn');
var covPartyRow = covPartyModel.data[0];
if(!(covPartyRow.NoFilters || covPartyRow.RelationshipFilter || covPartyRow.EntityFilter || covPartyRow.ProductFilter)){
   covPartyModel.updateRow(covPartyRow ,{ NoFilters : true ,
                                          RelationshipFilter : false,
                                          EntityFilter : false,
                                          ProductFilter : false
   });
   $('#NoFilter').addClass('selected-btn');
}

var covenantDefModel = skuid.model.getModel('ApplicableCovenantDefinition');
covenantDefModel.cancel();

// fetch all conditions
var relationshipCondition = covenantDefModel.getConditionByName('clcommon__Relationship_Type__c');
var entityTypeCondition = covenantDefModel.getConditionByName('clcommon__Legal_Entity_Type__c');
var productTypeCondition = covenantDefModel.getConditionByName('clcommon__Product__c');
// first deactivate all conditions
covenantDefModel.deactivateCondition(relationshipCondition);
covenantDefModel.deactivateCondition(entityTypeCondition);
covenantDefModel.deactivateCondition(productTypeCondition);

if(covPartyRow.RelationshipFilter){
    covenantDefModel.setCondition(relationshipCondition, covPartyRow.clcommon__Type__c);
}else if(covPartyRow.EntityFilter){
    covenantDefModel.setCondition(entityTypeCondition, covPartyRow.clcommon__Account__r.clcommon__Legal_Entity_Type__c);
}else if(covPartyRow.ProductFilter){
    covenantDefModel.setCondition(productTypeCondition, covPartyRow.genesis__Application__r.genesis__CL_Product__c);
}else{
    // no conditions
}

skuid.model.updateData([covenantDefModel],function(){ 
    var wizard = $('.nx-wizard').data('object'); 
    var currentStep = wizard.steps[wizard.currentstep];
    currentStep.navigate('step2');
});
});
skuid.snippet.register('initializeCovenants',function(args) {var params = arguments[0],
$ = skuid.$;

var covPartyModel = skuid.model.getModel('NewPartyCovAddtn');
var covPartyRow = covPartyModel.data[0];
var startDate;
if(covPartyRow.genesis__Application__r.genesis__Expected_First_Payment_Date__c){
    startDate = new Date(covPartyRow.genesis__Application__r.genesis__Expected_First_Payment_Date__c);
}else{
    startDate = new Date(covPartyRow.genesis__Application__r.genesis__Expected_Close_Date__c);
}

var otherParamsMap = {};
otherParamsMap['startDay'] = startDate.getDate();
otherParamsMap['startMonth'] = startDate.getMonth()+1;
otherParamsMap['startYear'] = startDate.getFullYear();
otherParamsMap['accountId'] = covPartyRow.clcommon__Account__c;
otherParamsMap['applicationId'] = covPartyRow.genesis__Application__r.Id;

var res = sforce.apex.execute('genesis.SkuidCovenantCtrl','generateCovenantsFromDefinitions', {
                                covenantDefinitions : JSON.stringify(params.rows) ,
                                otherParams : JSON.stringify(otherParamsMap)
                            });
var resObj = JSON.parse(res);
if(resObj.status == 'SUCCESS'){
    var newCovenantsModel = skuid.model.getModel('NewlyCreatedCovenants');
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

var covPartyModel = skuid.model.getModel('NewPartyCovAddtn');
var covPartyRow = covPartyModel.data[0];
var startDate;
if(covPartyRow.genesis__Application__r.genesis__Expected_First_Payment_Date__c){
    startDate = new Date(covPartyRow.genesis__Application__r.genesis__Expected_First_Payment_Date__c);
}else{
    startDate = new Date(covPartyRow.genesis__Application__r.genesis__Expected_Close_Date__c);
}

var otherParamsMap = {};
otherParamsMap['accountId'] = covPartyRow.clcommon__Account__c;
otherParamsMap['applicationId'] = covPartyRow.genesis__Application__c;
otherParamsMap['startDay'] = startDate.getDate();
otherParamsMap['startMonth'] = startDate.getMonth()+1;
otherParamsMap['startYear'] = startDate.getFullYear();

var newCovenantsModel = skuid.model.getModel('NewlyCreatedCovenants');
var res = sforce.apex.execute('genesis.SkuidCovenantCtrl','saveCovenants', {
                                covenantsJson : JSON.stringify(buildSObject(newCovenantsModel,true)) ,
                                otherParams : JSON.stringify(otherParamsMap)
                            });
var resObj = JSON.parse(res);
if(resObj.status == 'SUCCESS'){
    skuid.$('.ui-dialog-content').last().dialog('close');
}else{
    console.log(resObj);
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