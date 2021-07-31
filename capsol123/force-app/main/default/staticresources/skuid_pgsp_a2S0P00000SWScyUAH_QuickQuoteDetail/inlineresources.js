(function(skuid){
skuid.snippet.register('SaveQuickQuote',function(args) {var qqModel = skuid.$M('QuickQuoteModel'); 
var qqRow = qqModel.data[0];
var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;
var quickQuoteObjEq = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObjEq[key] = qqRow[key];
   }    
}

var queryQQ = true;
if(qqModel.originals){
   if(qqModel.originals[qqRow.Id]){
       if(qqModel.originals[qqRow.Id]['genesis__Payment_Frequency__c'] !== quickQuoteObjEq['genesis__Payment_Frequency__c']){
           queryQQ = false;
       }
       if(qqModel.originals[qqRow.Id]['genesis__Source__c'] !== quickQuoteObjEq['genesis__Source__c']){
           queryQQ = false;
       }
   } 
}

var result = sforce.apex.execute(
        'genesis.SkuidQQPricingCtrl',
        'generatePricingForQQ', { 
            quickQuote :  quickQuoteObjEq,
            queryQuickQuote : queryQQ,
            isEquipmentBeingAdded : false
        }
    );

var resObj = JSON.parse(result);
if(resObj.status != 'ERROR') {
    editor.handleMessages(
        [
          {
              message: 'Quick Quote Saved!',
              severity: 'INFO'
          }
        ]
    );
} else {
    editor.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          }
        ]
    );

}
if(!queryQQ){
       window.location.reload();
    }
});
skuid.snippet.register('CalcAmtsOnQQ',function(args) {var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];
var $ = skuid.$
var pageTitle = $('#errorPanelEquipment'); //$('#errorPanelEquipment'); // $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;
console.log('editor ',editor);
var quickQuoteObjEq = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObjEq[key] = qqRow[key];
   }    
}
var result = sforce.apex.execute(
        'genesis.SkuidQQPricingCtrl',
        'generatePricingForQQ', { 
            quickQuote :  quickQuoteObjEq,
            queryQuickQuote : true,
            isEquipmentBeingAdded : true
        }
    );

var resObj = JSON.parse(result);
console.log('resObj ',resObj);
if(resObj.status != 'ERROR') {
    editor.handleMessages(
        [
          {
              message: 'Equipment Saved!',
              severity: 'INFO'
          }
        ]
    );
} else {
    editor.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          }
        ]
    );
    return false;

}
window.location.reload();
});
skuid.snippet.register('GeneratePricingOnQQ',function(args) {var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];
var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;
var quickQuoteObj = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObj[key] = qqRow[key];
   }    
}
var result = sforce.apex.execute(
        'genesis.SkuidQQPricingCtrl',
        'generatePricingForQQ', { 
            quickQuote :  quickQuoteObj,
            queryQuickQuote : false,
            isEquipmentBeingAdded : false
        }
    );
var resObj = JSON.parse(result);
if(resObj.status != 'ERROR') {
    editor.handleMessages(
        [
          {
              message: 'Pricing Generated Succesfully!',
              severity: 'INFO'
          }
        ]
    );
} else {
    editor.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          }
        ]
    );

}
window.location.reload();
});
skuid.snippet.register('SelectPricing',function(args) {var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;

var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];

var quickQuoteObj = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObj[key] = qqRow[key];
   }    
}

var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){ 
        return item.row; 
    }); 

if (!records[0] || records.length < 1) { 
    editor.handleMessages(
        [
          {
              message: 'Please select at least one pricing option',
              severity: 'ERROR'
          }
        ]
    );
    
}else if(records  && records.length > 1){
    editor.handleMessages(
        [
          {
              message: 'Please select at only one pricing option',
              severity: 'ERROR'
          }
        ]
    );
    
} else{ 
    var result = sforce.apex.execute('genesis.SkuidQQPricingCtrl','selectPricingOptionOnQuickQuote',
    {   
            quickQuote : quickQuoteObj,
            pricingOptionId : records[0].Id
    });
    
    editor.handleMessages(
        [
          {
              message: result,
              severity: 'INFO'
          }
        ]
    );
    window.location.reload();
}
});
skuid.snippet.register('ConvertToApplication',function(args) {var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;

var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];

var quickQuoteObj = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObj[key] = qqRow[key];
   }    
}
var result = sforce.apex.execute(
        'genesis.QuickQuoteController',
        'convertQuickQuoteToApplication', { 
            quickQuoteObject :  quickQuoteObj
        }
    );
var resObj = JSON.parse(result);
if(resObj.status != 'ERROR') {
    editor.handleMessages(
        [
          {
              message: 'Application Created  Successfully!',
              severity: 'INFO'
          }
        ]
    );
} else {
    editor.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          }
        ]
    );
    
}
window.location.reload();
});
}(window.skuid));