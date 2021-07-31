(function(skuid){
skuid.snippet.register('submitToNextDepartmentJs',function(args) {var appModels = skuid.model.getModel('LDApplication');
var appRow = appModels.data[0]; 
var showSubmitButton = sforce.apex.execute('genesis.LoanDashBoard','submitToNextDepartment',
{   
        applicationId : appRow.Id
});

alert(showSubmitButton);
window.location.reload();
});
(function(skuid){          
    var $ = skuid.$;
    
    // Register a snippet to run 
    skuid.snippet.registerSnippet('EnableDisableSubmitButton', function(){
        var appModels = skuid.model.getModel('LDApplication');
        var appRow = appModels.data[0]; 
        var showSubmitButton = sforce.apex.execute('genesis.LoanDashBoard','showSubmitToNxtDeptBtn',
            {   
                    applicationId : appRow.Id
            });
        if(showSubmitButton == 'true'){
            $('#submitToNxtDept').button('enable');
        }else{
            $('#submitToNxtDept').button('disable');
        }

       // var oStatus = sforce.apex.execute('genesis.LoanDashBoard','getOverallStatus',
       // {   
       //         applicationId : appRow.Id
       // });
        
        //var pageTitle = $('#clpageTitle');
        //var editor = pageTitle.data('object').editor;
        //if(oStatus != "ERROR"){
           // editor.element.find('div.nx-editor-header div.nx-pagetitle-maintitle').html('Processed By ' + oStatus);    
        //}
        
        
        
    });
    
    // Run the snippet initially on page load
    $('.nx-page').one('pageload',function(){
        skuid.snippet.getSnippet('EnableDisableSubmitButton')();
    });
})(skuid);;
skuid.snippet.register('rejectApplication',function(args) {var appModels = skuid.model.getModel('LDApplication');
var appRow = appModels.data[0]; 

var processModel = skuid.model.getModel('DummyObj');
var processRow = processModel.data[0]; 

var comt = processRow.genesis__Description__c;
if(comt){
    var result = sforce.apex.execute('genesis.LoanDashBoard','rejectApplication',
    {       
            applicationId : appRow.Id,
            comments : comt
    });
    alert(result);
    skuid.$('.ui-dialog-content').dialog('close');
    window.location.reload();
}else{
    alert('Enter comments');
}
});
skuid.snippet.register('IsClosingStatusReached',function(args) {var orgParamModel    = skuid.model.getModel('OrgParameters');
var orgParamModelRow = orgParamModel.getFirstRow();

var closingStatus = orgParamModelRow.genesis__Closed_Satus__c;
console.log('closingStatus type ... ',typeof(closingStatus, 'object'));

var appModels = skuid.model.getModel('LDApplication');
var appRow = appModels.data[0]; 

if(closingStatus.indexOf(appRow.genesis__Status__c) !== -1){
    return false;
} else if(appRow.genesis__Status__c == 'REJECTED') {
    return false;
}

return true;
});
}(window.skuid));