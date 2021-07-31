(function(skuid){
skuid.snippet.register('updateDefaultValues',function(args) {var selectRowParam = arguments[0],
	$ = skuid.$;
var newCEData = skuid.model.getModel('NewEvaluationRecord');
if(selectRowParam.rows && selectRowParam.rows[0]){
    var newRow = newCEData.createRow({
            additionalConditions: [
                { field: 'clcommon__Covenant__c', value:selectRowParam.rows[0].clcommon__Covenant__c },
                { field: 'clcommon__Covenant__r', value:selectRowParam.rows[0].clcommon__Covenant__r },
                { field: 'clcommon__Evaluate_By_Date__c', value:selectRowParam.rows[0].clcommon__Evaluate_By_Date__c },
                { field: 'clcommon__Created_Date__c', value:new Date() },
            ]
        }); 
    console.log(newRow);    
}
});
}(window.skuid));