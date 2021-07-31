(function(skuid){
skuid.snippet.register('SaveApplication',function(args) {var recordTypeId;
var sPageURL = window.location.search.substring(1);
var sURLVariables = sPageURL.split('&');
for (var i = 0; i < sURLVariables.length; i++) {
    var sParameterName = sURLVariables[i].split('=');
    if (sParameterName[0] == 'RecordType') {
         recordTypeId = sParameterName[1];
    }
}

var applicationModel = skuid.model.getModel('Application');
var appRow = applicationModel.data[0];
var contactModel = skuid.model.getModel('Contact');

var actionModel = skuid.model.getModel('Temp');
var tempRow = actionModel.data[0];

var accountModel = skuid.model.getModel('Account');
var accRow = accountModel.data[0];

var productModel = skuid.model.getModel('Product');
var productRow = productModel.data[0];

var businessModel = skuid.model.getModel('BusinessInfo');
var businessRow = businessModel.data[0];
var businessId;

if(productRow.clcommon__Class__c.toLowerCase() === 'consumer') {
    if(tempRow.genesis__New_Borrower__c) {
        skuid.model.save([contactModel], {callback: function(result){
            if (result.totalsuccess) {
                console.log('Success');
                appRow.genesis__Contact__c = contactModel.getFirstRow().Id;
                doProcess();
            } else {
              // There was a problem. Let's see what went wrong.
              alert('Error: ' + result.insertResults[0]);
              console.log(result.insertResults[0]);
            }
        }});
    } else {
        doProcess();
    }
}else if(productRow.clcommon__Class__c.toLowerCase() === 'commercial') {
    if(tempRow.genesis__New_Borrower__c) {
        skuid.model.save([accountModel, contactModel, businessModel], {callback: function(result){
            if (result.totalsuccess){
                appRow.genesis__Account__c = accountModel.getFirstRow().Id;
                appRow.genesis__Contact__c = contactModel.getFirstRow().Id;
                businessId = businessModel.getFirstRow().Id;
                doProcess();
                
            } else {
              // There was a problem. Let's see what went wrong.
              alert('Error: ' + result.insertResults[0]);
              console.log(result.insertResults[0]);
            }
        }});
    } else {
        doProcess();
    }
}

function doProcess() {
    for(var key in appRow) {
        //alert(key.search(/__c/i));
        if(key.indexOf("__c", key.length - 3) === -1) {
           //alert('key : ' + key);
           delete appRow[key];
        }    
    
    }
    for(var key in tempRow) {
        if(key.indexOf("__c", key.length - 3) === -1) {
           delete tempRow[key];
        } 
    }

    var result;
    var param = new Object();
    param.recordTypeId = recordTypeId;
   
    param.applicationStr = JSON.stringify(appRow);
    param.tempStr = JSON.stringify(tempRow);
    if(businessId !== undefined) {
        param.businessId = businessId;
    }
    try {
        result = sforce.apex.execute('genesis.SkuidNewApplication','createApplication', param);
        window.location = '/' + result;
      
    } catch (err) {
        var message = err;
        if(err.faultString !== undefined) {
            message = err.faultString.split("\n")[0];
        }
        alert(message);
        //skuid.$.unblockUI();
        return;
    }
    
}
});
skuid.snippet.register('DisplayButtons',function(args) {var $ = skuid.$;
// Enable the button
//alert('hiii');
/*var tempModel = skuid.model.getModel('Temp');
var tempRow = tempModel.data[0];
if(tempRow.genesis__New_Borrower__c === true) {
    //alert('tempRow.genesis__New_Borrower__c true : ' + $('#Save Contact and Application'));
    $('#saveContactAndApp').button('enable');
    $('#saveApp').button('disable');
} else {
    //alert('tempRow.genesis__New_Borrower__c false');
    $('#saveContactAndApp').button('disable');
  */
});
}(window.skuid));