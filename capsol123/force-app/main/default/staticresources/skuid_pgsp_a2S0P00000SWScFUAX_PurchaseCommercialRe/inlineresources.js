(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    var paramId = skuid.page.params.id;
	    var pageName = skuid.page.params.page;
	    if(pageName && pageName == 'AddDealsToPackage'){
	        var newRow = skuid.model.getModel('PurchaseCREApplication').createRow({});   
	    }else{
    	    if(paramId){
        	    queryApplication(paramId);
        	}else{
        	    var newRow = skuid.model.getModel('PurchaseCREApplication').createRow({});   
        	}    
	    }
    	  
	});
})(skuid);

function queryApplication(id){
    var applicationModel = skuid.model.getModel('PurchaseCREApplication');
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

console.log('GET INCLUDED PAGE DATA IN PURCHASE CRE');

var productData = skuid.model.getModel('PurchaseCREProduct').getFirstRow();
var applicationModel = skuid.model.getModel('PurchaseCREApplication');
if(applicationModel && applicationModel.data && applicationModel.data[0] && productData){
    applicationModel.data[0].genesis__CL_Product__c = productData.Id;
}

var paymentStreamModel = skuid.model.getModel('PaymentStreamForPCREApp');
var result = {
    'genesis__Applications__c' : applicationModel,
    'genesis__Payment_Stream__c' : paymentStreamModel,
};

return result;
});
}(window.skuid));