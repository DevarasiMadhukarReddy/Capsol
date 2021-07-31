trigger BaqToAppicationTriggerCL on BAQ__c (after update) {
    
    if (!loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c){
    
        BaqToAppicationTriggerHandlerCL handler = new BaqToAppicationTriggerHandlerCL(trigger.oldMap, trigger.newMap);
        handler.afterUpdateHandler();
    
    }
    
}