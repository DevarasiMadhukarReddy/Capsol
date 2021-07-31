(function(skuid){
skuid.snippet.register('createPartiesForApps',function(args) {var params = arguments[0],
	$ = skuid.$;

var selectedParty = skuid.model.getModel('SelectedParentParty').getFirstRow();
var partyModel = skuid.model.getModel('NewlyCreatedPartyModel');
var selectedApplications = skuid.model.getModel('RemainingApplications').data;
if(selectedApplications){
    for (var index in selectedApplications) {
        console.log(index);
        if(selectedApplications[index] && selectedApplications[index].Id){
            var newRow = partyModel.createRow({
                additionalConditions: [
                    { field: 'clcommon__Account__c', value: selectedParty.clcommon__Account__c },
                    { field: 'clcommon__Account__r', value: selectedParty.clcommon__Account__r },
                    { field: 'genesis__Application__c', value: selectedApplications[index].Id },
                    { field: 'genesis__Application__r', value: selectedApplications[index] },
                    { field: 'genesis__Credit_Report__c', value: selectedParty.genesis__Credit_Report__c },
                    { field: 'genesis__Credit_Report__r', value: selectedParty.genesis__Credit_Report__r },
                    { field: 'genesis__Credit_Report__c', value: selectedParty.genesis__Credit_Report__c },
                    { field: 'genesis__Credit_Report__r', value: selectedParty.genesis__Credit_Report__r },
                    { field: 'clcommon__Type__c', value: selectedParty.clcommon__Type__c },
                    { field: 'clcommon__Type__r', value: selectedParty.clcommon__Type__r },
                    { field: 'clcommon__Signer_Capacity__c', value: selectedParty.clcommon__Signer_Capacity__c },
                    { field: 'clcommon__Signing_on_Behalf_of__c', value: selectedParty.clcommon__Signing_on_Behalf_of__c },
                    { field: 'clcommon__Signing_on_Behalf_of__r', value: selectedParty.clcommon__Signing_on_Behalf_of__r },
                ]
            });    
        }
    }

    skuid.model.save([partyModel], { callback: function(result){
        if (result.totalsuccess) {
            // close the frame
            closeTopLevelDialogAndRefresh({iframeIds: []});
        } else {
            var pageTitle = $('#addPartyErrorTitle');
            var editor = pageTitle.data('object').editor;
            editor.handleMessages(
                [
                   {
                      message: result.insertResults[0],
                      severity: 'ERROR'
                   },
                ]
            );
        }
    }});
}
});
}(window.skuid));