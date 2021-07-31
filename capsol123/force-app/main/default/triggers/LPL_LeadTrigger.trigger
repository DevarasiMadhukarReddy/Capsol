trigger LPL_LeadTrigger on Lead (after delete, after insert, after update, before delete, before insert, before update) {
    Map<String, Trigger_Support__c> supportMap = Trigger_Support__c.getAll();
    List<Lead> Led = Trigger.New;
    List<Lead> LedOld = Trigger.Old;
    Boolean isOff = false;
    if(!Trigger.isDelete){
        if(supportMap.keyset().Contains(Led[0].Logged_In_User_Profile__c)){
            isOff = supportMap.get(Led[0].Logged_In_User_Profile__c).Off_Trigger__c; 
        }
    }else {
        if(supportMap.keyset().Contains(LedOld[0].Logged_In_User_Profile__c)){
            isOff = supportMap.get(LedOld[0].Logged_In_User_Profile__c).Off_Trigger__c; 
        }
    }
    
    if(!isOff){
        TriggerFactory.createHandler(Lead.sObjectType);
    }
}