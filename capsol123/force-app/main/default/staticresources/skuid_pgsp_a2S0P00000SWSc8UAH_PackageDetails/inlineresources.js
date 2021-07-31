(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    var paramId = skuid.page.params.id;
    	if(paramId){
    	    queryApplication(paramId);
    	}else{
    	    var newRow = skuid.model.getModel('SelectedPackageApplication').createRow({});   
    	}   
	});
})(skuid);

function queryApplication(id){
    var applicationModel = skuid.model.getModel('SelectedPackageApplication');
    var appIdCondition = applicationModel.getConditionByName('AppId');
    applicationModel.setCondition(appIdCondition,id);
    skuid.model.updateData([applicationModel],function(){
        
    });
};
skuid.snippet.register('fieldsRenderMode',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
if(renderMode && renderMode == "read"){
    skuid.ui.fieldRenderers[field.metadata.displaytype].read(field, value);
}else{
    skuid.ui.fieldRenderers[field.metadata.displaytype].edit(field, value);
}
});
skuid.snippet.register('getIncludedPageData',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var applicationModel = skuid.model.getModel('SelectedPackageApplication');
var paymentStreamModel = skuid.model.getModel('SelectedPaymentStreams');
var result = {
    'genesis__Applications__c' : applicationModel,
};

return result;
});
}(window.skuid));