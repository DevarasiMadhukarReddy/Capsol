(function(skuid){
skuid.snippet.register('newSnippet',function(args) {var params = arguments[0],
	$ = skuid.$;

var parents = skuid.model.getModel('ParentApplication');
var forgivable = skuid.model.getModel('ApprovedForgivableRepApplications');
var repayable = skuid.model.getModel('RepayableChildApplication');
var osj = skuid.model.getModel('ChildOSJForgivableApplications');
var nonOsj = skuid.model.getModel('ChildNonOSJForgivableApplications');
var approved = skuid.model.getModel('ApprovedChildApplications');

var row1 = approved.data[0];
var totalTA = 0;
var totalOutlay = 0;
console.log('done2');
$.each(parents.data,function(i,row) {
    console.log('done2');
    totalTA = totalTA + (parents.getFieldValue(row,'Advisor_Current_Credit__c') === undefined?0:parents.getFieldValue(row,'Advisor_Current_Credit__c'));
    totalTA = totalTA + (parents.getFieldValue(row,'Advisor_Defered_Credit__c') === undefined?0:parents.getFieldValue(row,'Advisor_Defered_Credit__c'));
    console.log('totalTA'+totalTA);
    totalTA = totalTA + (parents.getFieldValue(row,'OSJ_Current_Credit__c') === undefined?0:parents.getFieldValue(row,'OSJ_Current_Credit__c'));
    console.log('totalTA'+totalTA);
    totalTA = totalTA + (parents.getFieldValue(row,'OSJ_Defered_Credit__c') === undefined?0:parents.getFieldValue(row,'OSJ_Defered_Credit__c'));
    console.log('totalTA'+totalTA);
    totalTA = totalTA + (parents.getFieldValue(row,'Non_OSJ_Current_Credit__c') === undefined?0:parents.getFieldValue(row,'Non_OSJ_Current_Credit__c'));
    console.log('totalTA'+totalTA);
    totalTA = totalTA + (parents.getFieldValue(row,'Non_OSJ_Defered_Credit__c') === undefined?0:parents.getFieldValue(row,'Non_OSJ_Defered_Credit__c'));
    console.log('totalTA'+totalTA);
    totalOutlay = totalOutlay + (parents.getFieldValue(row,'Referral_Credit__c') === undefined?0:parents.getFieldValue(row,'Referral_Credit__c'));
    totalOutlay = totalOutlay + (parents.getFieldValue(row,'Referral_Credit2__c') === undefined?0:parents.getFieldValue(row,'Referral_Credit2__c'));
    totalOutlay = totalOutlay + (parents.getFieldValue(row,'Referral_Credit3__c') === undefined?0:parents.getFieldValue(row,'Referral_Credit3__c'));

    
});
$.each(osj.data,function(i,row) {
    console.log('done2');
    totalTA = totalTA + (osj.getFieldValue(row,'genesis__Loan_Amount__c') === undefined?0:osj.getFieldValue(row,'genesis__Loan_Amount__c'));
     console.log('totalTA'+totalTA);
});
$.each(nonOsj.data,function(i,row) {
    console.log('done2');
    totalTA = totalTA + (nonOsj.getFieldValue(row,'genesis__Loan_Amount__c') === undefined?0:nonOsj.getFieldValue(row,'genesis__Loan_Amount__c'));
     console.log('totalTA'+totalTA);
});
$.each(forgivable.data,function(i,row) {
    console.log('done2');
    totalTA = totalTA + (forgivable.getFieldValue(row,'genesis__Loan_Amount__c') === undefined?0:forgivable.getFieldValue(row,'genesis__Loan_Amount__c'));
    console.log('totalTA'+totalTA);
});

$.each(repayable.data,function(i,row) {
    console.log('done2');
    totalOutlay = totalOutlay + (repayable.getFieldValue(row,'genesis__Loan_Amount__c') === undefined?0:repayable.getFieldValue(row,'genesis__Loan_Amount__c'));
     console.log('totalTA'+totalOutlay);
});
console.log('done1');

try{
    
    parents.updateRow(parents.getFirstRow(),
    {
        Total_TA_for_Final_Offer__c :parseFloat(totalTA),
        Total_Capital_Outlay__c : parseFloat(totalOutlay)
    });
    parents.save();
    console.log(parents);
    console.log('done');
} catch(e) {
    console.log('caught'+e);
}
});
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    
	    
        openLinksInNewTab();
    	var parents = skuid.model.getModel('ParentApplication');
        var forgivable = skuid.model.getModel('ApprovedForgivableRepApplications');
        var repayable = skuid.model.getModel('RepayableChildApplication');
        var osj = skuid.model.getModel('ChildOSJForgivableApplications');
        var nonOsj = skuid.model.getModel('ChildNonOSJForgivableApplications');
        var approved = skuid.model.getModel('ApprovedChildApplications');
        
        var row1 = approved.data[0];
        var totalTA = 0;
        var totalOutlay = 0;
        console.log('done2');
        $.each(parents.data,function(i,row) {
            console.log('done2');
            totalTA = totalTA + (parents.getFieldValue(row,'Advisor_Current_Credit__c') === undefined?0:parents.getFieldValue(row,'Advisor_Current_Credit__c'));
            totalTA = totalTA + (parents.getFieldValue(row,'Advisor_Defered_Credit__c') === undefined?0:parents.getFieldValue(row,'Advisor_Defered_Credit__c'));
            console.log('totalTA'+totalTA);
            totalTA = totalTA + (parents.getFieldValue(row,'OSJ_Current_Credit__c') === undefined?0:parents.getFieldValue(row,'OSJ_Current_Credit__c'));
            console.log('totalTA'+totalTA);
            totalTA = totalTA + (parents.getFieldValue(row,'OSJ_Defered_Credit__c') === undefined?0:parents.getFieldValue(row,'OSJ_Defered_Credit__c'));
            console.log('totalTA'+totalTA);
            totalTA = totalTA + (parents.getFieldValue(row,'Non_OSJ_Current_Credit__c') === undefined?0:parents.getFieldValue(row,'Non_OSJ_Current_Credit__c'));
            console.log('totalTA'+totalTA);
            totalTA = totalTA + (parents.getFieldValue(row,'Non_OSJ_Defered_Credit__c') === undefined?0:parents.getFieldValue(row,'Non_OSJ_Defered_Credit__c'));
            console.log('totalTA'+totalTA);
            totalOutlay = totalOutlay + (parents.getFieldValue(row,'Referral_Credit__c') === undefined?0:parents.getFieldValue(row,'Referral_Credit__c'));
            totalOutlay = totalOutlay + (parents.getFieldValue(row,'Referral_Credit2__c') === undefined?0:parents.getFieldValue(row,'Referral_Credit2__c'));
            totalOutlay = totalOutlay + (parents.getFieldValue(row,'Referral_Credit3__c') === undefined?0:parents.getFieldValue(row,'Referral_Credit3__c'));
            
        });
        $.each(osj.data,function(i,row) {
            console.log('done2');
            totalTA = totalTA + (osj.getFieldValue(row,'genesis__Loan_Amount__c') === undefined?0:osj.getFieldValue(row,'genesis__Loan_Amount__c'));
             console.log('totalTA'+totalTA);
        });
        $.each(nonOsj.data,function(i,row) {
            console.log('done2');
            totalTA = totalTA + (nonOsj.getFieldValue(row,'genesis__Loan_Amount__c') === undefined?0:nonOsj.getFieldValue(row,'genesis__Loan_Amount__c'));
             console.log('totalTA'+totalTA);
        });
        $.each(forgivable.data,function(i,row) {
            console.log('done2');
            totalTA = totalTA + (forgivable.getFieldValue(row,'genesis__Loan_Amount__c') === undefined?0:forgivable.getFieldValue(row,'genesis__Loan_Amount__c'));
            console.log('totalTA'+totalTA);
        });
        
        $.each(repayable.data,function(i,row) {
            console.log('done2');
            totalOutlay = totalOutlay + (repayable.getFieldValue(row,'genesis__Loan_Amount__c') === undefined?0:repayable.getFieldValue(row,'genesis__Loan_Amount__c'));
             console.log('totalTA'+totalOutlay);
        });
        console.log('done1');
        
        try{
            
            parents.updateRow(parents.getFirstRow(),
            {
                Total_TA_for_Final_Offer__c :parseFloat(totalTA),
                Total_Capital_Outlay__c : parseFloat(totalOutlay)
            });
            parents.save();
            console.log(approved);
            console.log('done');
        } catch(e) {
            console.log('caught'+e);
        }

	});
})(skuid);;
skuid.snippet.register('convertRepayable',function(args) {var params = arguments[0],
	$ = skuid.$;

var appModel = skuid.model.getModel('RepayableChildApplication');
var appRow = appModel.data[0];


$.blockUI({
    message: 'Please Wait.........',
    onBlock:function(){
        var result = sforce.apex.execute('ApplicationToContractConverter','convertToCLContract',
        {   
            appId : appRow.Id,
            appType : appRow.Application_Type__c,
            interestRate : appRow.genesis__Interest_Rate__c
        });
        
        $.unblockUI();
        alert(result); 
        window.location.reload();
   }
   
});
});
skuid.snippet.register('convertForgivableRep',function(args) {var params = arguments[0],
	$ = skuid.$;

var appModel = skuid.model.getModel('ApprovedForgivableRepApplications');
var appRow = appModel.data[0];
$.blockUI({
    message: 'Please Wait.........',
    onBlock:function(){
        var ret = sforce.apex.execute('genesis.ConvertApplicationCtrl','convertApplicationToContract',
        {   
        appId : appRow.Id
        });
        
        $.unblockUI();
        alert(ret); 
        window.location.reload();
   }
   
});
});
skuid.snippet.register('convertForgivableOSJ',function(args) {var params = arguments[0],
	$ = skuid.$;

var appModel = skuid.model.getModel('ChildOSJForgivableApplications');
var appRow = appModel.data[0];

$.blockUI({
    message: 'Please Wait.........',
    onBlock:function(){
        var ret = sforce.apex.execute('genesis.ConvertApplicationCtrl','convertApplicationToContract',
        {   
        appId : appRow.Id
        });
        
        $.unblockUI();
        alert(ret); 
        window.location.reload();
   }
   
});
});
skuid.snippet.register('convertForgivableNonOSJ',function(args) {var params = arguments[0],
	$ = skuid.$;

var appModel = skuid.model.getModel('ChildNonOSJForgivableApplications');
var appRow = appModel.data[0];

$.blockUI({
    message: 'Please Wait.........',
    onBlock:function(){
        var ret = sforce.apex.execute('genesis.ConvertApplicationCtrl','convertApplicationToContract',
        {   
        appId : appRow.Id
        });
        
        $.unblockUI();
        alert(ret); 
        window.location.reload();
   }
   
});
});
skuid.snippet.register('disableConvertToLoanButton',function(args) {var params = arguments[0],
	$ = skuid.$;

skuid.$("#RepayableRep").button("disable");
skuid.$("#ForgivableRep").button("disable");
skuid.$("#ForgivableOSJ").button("disable");
skuid.$("#ForgivableNonOSJ").button("disable");
});
}(window.skuid));