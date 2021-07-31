(function(skuid){
(function(skuid){
    var $ = skuid.$;
    $('.nx-page').one('pageload',function(){
        var iframeHeight = window.innerHeight - 65;
	    $('iframe').height(iframeHeight);
        var appRow = skuid.model.getModel('LDApplication').getFirstRow();
        if(appRow.genesis__Overall_Status__c){
            console.log(appRow.genesis__Overall_Status__c);
            appRow.genesis__Overall_Status__c = appRow.genesis__Overall_Status__c.replace('Being Processed By', '');
            appRow.genesis__Overall_Status__c = appRow.genesis__Overall_Status__c.replace('Waiting for', '');
        }
        
        var showSubmitButton = sforce.apex.execute('genesis.LoanDashBoard','showSubmitToNxtDeptBtn',
            {
                    applicationId : appRow.Id
            });
            
        if(showSubmitButton == 'true'){
            $('#submitToNxtDept').button('enable');
        }else{
            $('#submitToNxtDept').button('disable');
        }
    });
})(skuid);;
skuid.snippet.register('submitToNextDepartmentJs',function(args) {var appModels = skuid.model.getModel('LDApplication');
var appRow = appModels.data[0];
var showSubmitButton = sforce.apex.execute('genesis.LoanDashBoard','submitToNextDepartment',
{
        applicationId : appRow.Id
});

toTopLevelAndRefresh({iframeIds: ['task-list-popover']});

var title = 'Submit To Next Department';
var content = '<p>' + showSubmitButton + '</p>';
var type = 'alert';
openTopLevelDialog({
    type : type,
	title: title,
	prefixHtml: content
});
});
skuid.snippet.register('LaunchTaskCreationDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = params.row.Id;
var title = 'Add Exception Task';
var skuidPage = 'TaskCreation';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));