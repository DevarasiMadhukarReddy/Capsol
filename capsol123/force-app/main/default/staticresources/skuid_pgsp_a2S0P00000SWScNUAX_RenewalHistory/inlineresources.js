(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
		var historyModel = skuid.model.getModel('RenewalHistoryObj'); 
        var historyRow = historyModel.data[0];
        var result = sforce.apex.execute('genesis.SkuidRenewalCtrl','generateRenewalHistory',
     	{   
            sourceId : skuid.page.params.id,
        });
        var resObj = JSON.parse(result);
        if(resObj.status == 'SUCCESS'){
            var resList = resObj.content;
            $.each(resList , function (index, historyObj) {
                var newRow = historyModel.createRow({
                    additionalConditions: [
                        { field: 'genesis__Close_Date__c', value:historyObj.genesis__Close_Date__c },
                        { field: 'genesis__Loan_Number__c', value: historyObj.genesis__Loan_Number__c },
                        { field: 'genesis__Renewal_Amount__c', value: historyObj.genesis__Renewal_Amount__c },
                        { field: 'genesis__Renewal_Date__c', value: historyObj.genesis__Renewal_Date__c },
                        { field: 'genesis__Renewed_From_Contract__c', value: historyObj.genesis__Renewed_From_Contract__c },
                        { field: 'Name', value: historyObj.Name },
                        { field: 'Id', value: historyObj.Id },
                    ]
                });
            });
        }
	});
})(skuid);;
}(window.skuid));