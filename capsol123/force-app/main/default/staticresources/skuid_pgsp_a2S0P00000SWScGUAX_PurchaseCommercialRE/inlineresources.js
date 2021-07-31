(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    var paramId = skuid.page.params.id;
    	if(paramId){
    	    queryApplication(paramId);
    	}else{
    	    var newRow = skuid.model.getModel('PurchaseCSApplication').createRow({});   
            var newPSRow = skuid.model.getModel('PaymentStreamForPCSApp').createRow({});
    	}   
	});
})(skuid);

function queryApplication(id){
    var applicationModel = skuid.model.getModel('PurchaseCSApplication');
    var appIdCondition = applicationModel.getConditionByName('AppId');
    applicationModel.setCondition(appIdCondition,id);
    
    var paymentStreamModel = skuid.model.getModel('PaymentStreamForPCSApp');
    var psAppIdCondition = paymentStreamModel.getConditionByName('genesis__Application__c');
    paymentStreamModel.setCondition(psAppIdCondition,id);
    
    skuid.model.updateData([applicationModel,paymentStreamModel],function(){
        if(!(paymentStreamModel.data && paymentStreamModel.data.length > 0)){
            var newPSRow = paymentStreamModel.createRow({
                additionalConditions: [
                    { field: 'genesis__Application__c', value: id },
                ]
            });
        }
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
var productRow = skuid.model.getModel('PurchaseCSProduct').getFirstRow();	
var applicationModel = skuid.model.getModel('PurchaseCSApplication');
if(applicationModel && applicationModel.data && applicationModel.data[0] && productRow){
    applicationModel.data[0].genesis__CL_Product__c = productRow.Id;
}
var paymentStreamRows = skuid.model.getModel('PaymentStreamForPCSApp');

var result = {
    'genesis__Applications__c' : applicationModel,
    'genesis__Payment_Stream__c' : paymentStreamRows,
};

return result;
});
}(window.skuid));