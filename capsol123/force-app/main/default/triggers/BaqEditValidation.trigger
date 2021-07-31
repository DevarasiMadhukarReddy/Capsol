trigger BaqEditValidation on BAQ__c (before update,After insert,after update) {

if (!loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c)
    {
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            Set<String> allowedStatusList = new Set<String>{
            ConstantsCl.APPLICATION_STATUS_BAQ_SUBMITTED,
            ConstantsCl.APPLICATION_STATUS_UNDERWRITING,
            ConstantsCl.APPLICATION_STATUS_GUIDANCE,
            ConstantsCl.APPLICATION_STATUS_SUBMITTEDL_FOR_APPROVAL,
            ConstantsCl.APPLICATION_STATUS_APPROVED,
            ConstantsCl.APPLICATION_STATUS_BAQ_RESUBMITTED
            };
            Set<Id> baqIDs = Trigger.newMap.keySet();
            Map<Id, List<genesis__Applications__c>> baqAppMap = new Map<Id, List<genesis__Applications__c>>();
            List<genesis__Applications__c> appList = [SELECT Id, Name, BAQ__c, genesis__Status__c FROM genesis__Applications__c WHERE isParentApplication__c = true AND genesis__Parent_Application__c = null AND BAQ__c IN : baqIDs];
            
            if(appList != null && appList.size() > 0) {
                for(genesis__Applications__c app : appList) {
                    if(baqAppMap.containsKey(app.BAQ__c)) {
                        List<genesis__Applications__c> baqAppList = baqAppMap.get(app.BAQ__c);
                        baqAppList.add(app);
                        baqAppMap.put(app.BAQ__c, baqAppList);
                    } else {
                        List<genesis__Applications__c> baqAppList = new List<genesis__Applications__c>();
                        baqAppList.add(app);
                        baqAppMap.put(app.BAQ__c, baqAppList);
                    }
                }
            
            for(Id baqId : Trigger.newMap.keySet()) {
                if(baqAppMap.containsKey(baqId)) {
                    List<genesis__Applications__c> apps = baqAppMap.get(baqId);
                    for(genesis__Applications__c app : apps) {
                        if(!(allowedStatusList.contains((String.valueOf(app.genesis__Status__c))))) {
                            Trigger.newMap.get(baqId).addError('You can not modify this BAQ since an Application associated with this is in "Final Offer Submitted" state.');
                            break;
                        }
                    }
                }
            }
            }
        
        }
        else if(Trigger.isAfter && Trigger.isUpdate)
        {
            BaqToAppicationTriggerHandlerCL handler = new BaqToAppicationTriggerHandlerCL(trigger.oldMap, trigger.newMap);
            handler.afterUpdateHandler();
        }
    }
    if(Trigger.isAfter && Trigger.isInsert)
    {
        List<OpportunityBAQ__c>  OptyBAQList=new List<OpportunityBAQ__c>();
        try
        {
            for(BAQ__c baq:trigger.new) 
            {
                OpportunityBAQ__c opp=new OpportunityBAQ__c();
                opp.BAQ__c=baq.id;
                opp.Opportunity__c=baq.Opportunity__c;
                OptyBAQList.add(opp);
            }
        
            insert OptyBAQList; //inserting OpportunityBAQ__c object record list.
        }
        catch(DmlException e)
        {
            System.debug('Error message:'+e.getMessage());
        }
    }
    
        
    
}