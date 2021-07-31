trigger LPL_AccountContactRelation on AccountContactRelation (after delete, after insert, after update, before delete, before insert, before update) {
    Boolean isOff  = False;
    Map<String, Trigger_Support__c> supportMap = Trigger_Support__c.getAll();
    
    List<AccountContactRelation> acr = Trigger.New;
    List<AccountContactRelation> acrOld = Trigger.Old;
    
    if(!Trigger.isDelete){
        if(supportMap.keyset().Contains(acr[0].Logged_In_User_Profile__c)){
            isOff = supportMap.get(acr[0].Logged_In_User_Profile__c).Off_Trigger__c;
        }
    }else {
        if(supportMap.keyset().Contains(acrOld[0].Logged_In_User_Profile__c)){
            isOff = supportMap.get(acrOld[0].Logged_In_User_Profile__c).Off_Trigger__c;
        } 
    }
    
     if(!isOff){
        TriggerFactory.createHandler(AccountContactRelation.sObjectType);
     }
}