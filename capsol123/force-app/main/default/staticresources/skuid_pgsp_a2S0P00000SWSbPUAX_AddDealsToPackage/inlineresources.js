(function(skuid){
skuid.snippet.register('SaveDeals',function(args) {var params = arguments[0],
	$ = skuid.$;

var userActionObject = skuid.model.getModel('UserAction').getFirstRow();
var isErr = addErrorMsg('Select Application first'); 
if(isErr){
    return;
}

var selectedApplicationModel = skuid.model.getModel('SelectedAppToUpdate');
var selectedApplication = selectedApplicationModel.getFirstRow();
selectedApplication.genesis__Parent_Application__c = skuid.page.params.id;
selectedApplicationModel.save({
    callback: function (result) {
        if (result.totalsuccess) {
            closeTopLevelDialogAndRefresh({window : true});
        } else {
            addErrorMsg(result.insertResults[0]);
        }
    }
});

function addErrorMsg(errMsg){
    var pageTitle = $('#AddDealErrorPanel');
    var editor = pageTitle.data('object').editor;
    if(!userActionObject.genesis__Application__c){
        editor.handleMessages(
            [
               {
                  message: errMsg,
                  severity: 'ERROR'
               },
            ]
        );
        return true;
    } 
    return false;
}
});
skuid.snippet.register('LaunchAddNewApplicationDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

// var title = 'Add Credit Facility To Deal - ' + skuid.page.params.name;
// var skuidPage = 'ApplicationFormForComplexDeals';
// var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&parentId=' + skuid.page.params.id;

// openTopLevelDialog({
//     title: title,
//     iframeUrl: iframeUrl
// });


skuid.page.params.newdeal = true;
});
}(window.skuid));