(function(skuid){
skuid.snippet.register('pullCreditForParty',function(args) {var $ = skuid.$;
var partyModel = skuid.model.getModel('Party');
var partyRow = partyModel.data[0];
if(!partyRow.clcommon__Contact__c){
    alert('Contact is null');
}

$.blockUI({
    message: 'Fetching Credit Report from Meridian Link...',
    onBlock:function(){
        var result = sforce.apex.execute('genesis.SkuidCreditPullCtrl','doCreditPullForParty',
        {   
            applicationId : partyRow.genesis__Application__c,
            contactId : partyRow.clcommon__Contact__c
        });
        
        $.unblockUI();
        alert(result); 
        window.location.reload();
   }
   
});
});
skuid.snippet.register('massCreditPull',function(args) {var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){ 
        return item.row; 
    }); 

if (records[0] === null) { 
    alert("Please select at least one party"); 
} 
else{ 
    var resultArr = new Array();
    var result;
    records.forEach(function(entry) {
        result = sforce.apex.execute('genesis.SkuidCreditPullCtrl','doCreditPullForParty',
        {   
            applicationId : entry.genesis__Application__c,
            contactId : entry.clcommon__Contact__c
        });
        resultArr.push(result + '- ' + entry.clcommon__Contact__r.Name + "\n" );
    });
    alert(resultArr);
}
window.location.reload();
});
}(window.skuid));