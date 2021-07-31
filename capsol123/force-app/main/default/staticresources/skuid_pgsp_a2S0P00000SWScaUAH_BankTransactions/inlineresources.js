(function(skuid){
skuid.snippet.register('callYodlee',function(args) {var $ = skuid.$;
// To start showing the message
$.blockUI({ message: 'Processing...' });
var partyModel = skuid.model.getModel('Party');
var partyRow = partyModel.data[0];

var fromDate = new Date(Date.now() + (-720 * 24 * 60 * 60 * 1000));
var toDate = new Date(); 
var result = sforce.apex.execute('genesis.SkuidYodleeCallCtrl','doYodleeCallForParty',
    {   
        applicationId : partyRow.genesis__Application__c,
        partyId : partyRow.Id ,
        fromDate : fromDate,
        toDate : toDate
        
    });
$.unblockUI();
alert(result);
window.location.reload();
});
}(window.skuid));