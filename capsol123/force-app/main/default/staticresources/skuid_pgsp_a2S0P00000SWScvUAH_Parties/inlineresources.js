(function(skuid){
skuid.snippet.register('AddParty',function(args) {// var params = arguments[0],
//	$ = skuid.$;

var item    = arguments[0].item,
    list    = arguments[0].list,
    model   = arguments[0].model;
    var partyRow = arguments[0].row;
//console.log(partyRow);    
    
var businessInfoModel = skuid.model.getModel('BusinessInfo');
var bRow = businessInfoModel.data[0];
//console.log(bRow);

var accountModel = skuid.model.getModel('AccountM');
var accRow = accountModel.data[0];
//console.log(accRow);

var contactModel = skuid.model.getModel('ContactM');
var contactRow = contactModel.data[0];
//console.log(contactRow);

var rowUpdates = new Object();
//console.log('legal name : ' + bRow.genesis__Business_Legal_Name__c);
if(bRow.genesis__Business_Legal_Name__c) {
    console.log(businessInfoModel.hasChanged);
    businessInfoModel.save({callback : function(result) {
        if(result.totalsuccess) {
            //console.log('businessInfo model saved');
            rowUpdates['Name'] = bRow.genesis__Business_Legal_Name__c;
            rowUpdates['genesis__Business_Information__c'] = bRow.Id;
            rowUpdates['genesis__Business_Information__r'] = bRow;
            
            accountModel.updateRow(accRow, rowUpdates);
            accountModel.save( {callback: function(result) {
                if(result.totalsuccess) {
                    //alert('data saved');
                    if(contactRow.LastName) {
                        var contactUpdates = new Object();
                        contactUpdates['AccountId'] = accId;
                        contactUpdates['Account'] = accountModel.data[0];
                        contactModel.updateRow(contactRow, contactUpdates);
                        contactModel.save({});
                    }
                    var accId = accountModel.data[0].Id;
                    //alert(' accId : ' + accId);
                    
                    var partyUpdates = new Object();
                    //alert('before update : ' + partyRow.genesis__Application__c + ' ' + partyRow.clcommon__Account__c);
                    partyUpdates['clcommon__Account__c'] = accId;
                    partyUpdates['clcommon__Account__r'] = accountModel.data[0];
                    var partyModel = skuid.model.getModel('Party')
                    partyModel.updateRow(partyRow, partyUpdates);
                    partyModel.save({callback: function(result) {
                        if(result.totalsuccess) {
                        //alert('party data saved');
                        }
                    }});
                    //console.log('partyRow : ' + partyRow);
                    //alert('updated : ' + partyRow.clcommon__Account__c);
                }
            }}  );
        }
    }});
} else if(contactRow.LastName) {
     contactModel.save({callback: function(result) {
        if(result.totalsuccess) {
            //console.log('contact data saved');
            var partyUpdates = new Object();
            //alert('before update : ' + partyRow.genesis__Application__c + ' ' + partyRow.clcommon__Account__c);
            partyUpdates['clcommon__Contact__c'] = contactModel.data[0].Id;
            partyUpdates['clcommon__Contact__r'] = contactModel.data[0];
            var partyModel = skuid.model.getModel('Party')
            partyModel.updateRow(partyRow, partyUpdates);
            partyModel.save({callback: function(result) {
                if(result.totalsuccess) {
                    //alert('party data saved');
                }
            }});
        }
    }});
}


//partyRow.genesis__Account__c
//window.location.reload();
});
}(window.skuid));