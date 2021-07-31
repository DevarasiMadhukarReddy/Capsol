(function(skuid){
skuid.snippet.register('loanAmountChanged',function(args) {var params = arguments[0],	$ = skuid.$,
updates = params.updates;

var monthlyPayment;
var originationFee;

if ('genesis__Loan_Amount__c' in updates || 'genesis__Interest_Rate__c' in updates || 'genesis__Origination_Fee_Points__c' in updates) {
    if ('genesis__Loan_Amount__c' in updates || 'genesis__Interest_Rate__c' in updates) {
        monthlyPayment = (params.row.genesis__Loan_Amount__c * params.row.genesis__Interest_Rate__c/100)/360 * 30 ;
        
        if (monthlyPayment) {
            params.model.updateRow(params.row,'genesis__Monthly_Interest_Payment__c',monthlyPayment);    
        }
        if(params.row.genesis__Expected_Close_Date__c) {
            var closeDate = skuid.time.parseSFDate(params.row.genesis__Expected_Close_Date__c);
            var months = closeDate.getMonth();
            var newYear = closeDate.getFullYear();
            if(months === 11) {
                newYear = newYear + 1;
            }
            var oldDate = Date.UTC(closeDate.getFullYear(), closeDate.getMonth(), closeDate.getDate());
            var newDate = Date.UTC(newYear, (months + 1)%12 , 1);
            console.log(newDate);
            console.log(oldDate);
            var diffDays = Math.floor((newDate - oldDate) / (1000 * 3600 * 24));
            console.log(diffDays);
            }
            var perDiemAmount = (params.row.genesis__Loan_Amount__c * params.row.genesis__Interest_Rate__c/100)/360 * diffDays ;
            if(perDiemAmount) {
                params.model.updateRow(params.row,'genesis__Per_Diem_Amount__c', perDiemAmount);        
            }
    }
    if('genesis__Loan_Amount__c' in updates || 'genesis__Origination_Fee_Points__c' in updates) {
        //alert('updated loan amount : ' + params.row.genesis__Origination_Fee_Points__c + ' ' + params.row.genesis__Loan_Amount__c);
        originationFee = (params.row.genesis__Loan_Amount__c * params.row.genesis__Origination_Fee_Points__c/100);
        //alert(originationFee);
        if(originationFee) {
            params.model.updateRow(params.row,'genesis__Origination_Fee__c',originationFee); 
        }
    }
    
}
});
skuid.snippet.register('cloneLOI',function(args) {//alert('clone');
var params = arguments[0],    
    row = params.item.row,
    model = params.model,
    $ = skuid.$;
var newRow = model.createRow();
if (row) {
    var rowUpdates = {};
    $.each(row,function(fieldId,val) {
        if ((fieldId != 'attributes') && (val != null) && (fieldId != 'Id')) {
           var modelField = model.getField(fieldId);
            if ((typeof val === 'object') 
            || (modelField && modelField.createable)) {
                rowUpdates[fieldId] = val;
            }
            if(fieldId === 'genesis__Status__c') {
                //alert('status');
                rowUpdates[fieldId] = 'Draft';
            }
            if(fieldId === 'genesis__Active__c') {
                //alert('active');
                rowUpdates[fieldId] = false;
            }
            if(fieldId === 'genesis__Sent_At__c') {
                //alert('active');
                rowUpdates[fieldId] = null;
            }
        }
    });
    model.updateRow(newRow,rowUpdates);
}
});
skuid.snippet.register('resetFields',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var loiRow = params.row;
var model = params.model
//alert('loiRow.Contact : ' + loiRow.Id);
var param = new Object();
param.loiId = loiRow.Id
 try {
        result = sforce.apex.execute('genesis.SkuidLOIAction','resetDependentFields', param);
        //alert(result);
        var newRow = JSON.parse(result);
        //alert('newRow.genesis__Contact__c : ' + newRow.genesis__Contact__c);
        //alert('newRow.genesis__Application__c : ' + newRow.genesis__Application__c);
        var rowUpdates = {};
        $.each(newRow,function(fieldId,val) {
            if ((fieldId != 'attributes') && (val != null) && (fieldId != 'Id')) {
               var modelField = model.getField(fieldId);
                if ((typeof val === 'object') 
                || (modelField && modelField.createable)) {
                    rowUpdates[fieldId] = val;
                }
                
            }
        });
        model.updateRow(newRow, rowUpdates);
        //alert(newRow.genesis__Loan_Amount__c);
        //alert(model.hasChanged);
    } catch (err) {
        var message = err;
        if(err.faultString !== undefined) {
            message = err.faultString.split("\n")[0];
        }
        alert(message);
        return;
    }
});
skuid.snippet.register('saveNewLOI',function(args) {//alert('called');
var loiModel = skuid.model.getModel('LOI');
//alert(loiModel.hasChanged);
loiModel.save( {callback: function() {
    //alert('data saved');
}}  );
});
}(window.skuid));