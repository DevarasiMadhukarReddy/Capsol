(function(skuid){
skuid.snippet.register('calculateFinancedAmount',function(args) {var pricingAppModel = skuid.model.getModel('PricingAppModel');
var pricingAppRow = pricingAppModel.data[0]; 

var result = sforce.apex.execute('genesis.SkuidPricingCtrl','generatePricing',
{   
        applicationId : pricingAppRow.Id
});
alert(result);
window.location.reload();
});
skuid.snippet.register('selectPricingOption',function(args) {/*
var pricingAppModel = skuid.model.getModel('PricingAppModel');
var pricingAppRow = pricingAppModel.data[0]; 
var result = sforce.apex.execute('genesis.SelectPricingOnApplication','selectPricingOption',
{   
        applicationId : pricingAppRow.Id
});
alert(result);
window.location.reload();
*/


var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){ 
        return item.row; 
    }); 
console.log(records);
console.log(arguments[0].list);
if ( !records[0]  || records.length < 1) { 
    alert("Please select at least one pricing option"); 
}else if(records  && records.length > 1){
    alert("Please select at only one pricing option"); 
} else{ 
    var result = sforce.apex.execute('genesis.SelectPricingOnApplication','selectPricingOption',
    {   
            pricingId : records[0].Id
    });
    alert(result);
    window.location.reload();
}
});
skuid.snippet.register('calculateFinancedAmount1',function(args) {var pricingAppModel = skuid.model.getModel('PricingAppModel');
var pricingAppRow = pricingAppModel.data[0]; 

var result = sforce.apex.execute('genesis.SkuidPricingCtrl','generatePricing',
{   
        applicationId : pricingAppRow.Id
});

// Update pricing status
pricingAppModel.updateRow({
    Id: pricingAppRow.Id
}, {
    genesis__Status__c: "NEW - PRICING GENERATED"
});

// Save updates
pricingAppModel.save({
    callback: function (result) {
        if (result.totalsuccess) {
             //alert('New Quote Id: ' + appRow.Id); 
        } else {
            alert('Error: ' + result.insertResults[0]); 
            console.log(result.insertResults[0]);          
        }
    }
});

alert(result);
window.location.reload();
});
skuid.snippet.register('CalcPaymentsOrYield',function(args) {var $ = skuid.$
var pageTitle = $('#sk-228Y53-385');
var editor = pageTitle.data('object').editor;

var pricingAppModel = skuid.model.getModel('PricingAppModel');
var pricingAppRow = pricingAppModel.data[0];

/*
* Added IsYieldEnabled Model to check for which choiceNo to send based on selected checkbox genesis__Is_Get_Yield_Enabled__c 
*/
var isYieldEnabledModel = skuid.model.getModel('IsYieldEnabled'); 
var isYieldEnabledRow = isYieldEnabledModel.data[0];

var pAppObj = new sforce.SObject("genesis__Applications__c");
for(var key in pricingAppRow) {
   if(key.includes('__c') || key === 'Id'|| key === 'Name') {
       pAppObj[key] = pricingAppRow[key];
   }    
}

var choiceNo = 1;
if( ! isYieldEnabledRow['genesis__Is_Get_Yield_Enabled__c'] ){
    choiceNo = 2;
}

var result = sforce.apex.execute('genesis.SkuidPricingCtrl','calculatePricingFactors',
{   
        application : pAppObj,
        choice : choiceNo
});

if(result == 'Successfully computed...'){
    
    /* 
    Added extra if else to check against choiceNo to display whether yield/payment is 
    succesfully computed. Earlier in both cases only "yield calculated succesfully" was getting displayed
    */
    
    if(choiceNo == 1){
        editor.handleMessages( 
       [{
          
           message: 'Yield Calculated Successfully', 
           severity: 'INFO'
       }]
    )} else {
        editor.handleMessages( 
       [{
          
           message: 'Payment Calculated Successfully', 
           severity: 'INFO'
       }]
    )}
} else {
    editor.handleMessages(
        [{
              message: result,
              severity: 'ERROR'
        }]
    );
}
window.location.reload();
});
skuid.snippet.register('copyIsYieldEnabledValue',function(args) {/*
*  Purpose: Used to save rendering field in application object using different model name
*  Where  : Calculating Financial Amount / yield button
*
* @name   : editSaveForCalcFinanceAmt.js
* @author : Ashish Kumar Singh
* @version: 1.0
* @since  : 15-03-2017
*/
var isYieldEnabledModel = skuid.model.getModel('IsYieldEnabled'); 
var isYieldEnabledRow = isYieldEnabledModel.data[0];

console.log('isYieldEnabledRow ',isYieldEnabledRow);
isYieldEnabledModel.save();
});
}(window.skuid));