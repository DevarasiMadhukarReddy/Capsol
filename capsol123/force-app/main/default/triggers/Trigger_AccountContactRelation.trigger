trigger Trigger_AccountContactRelation on AccountContactRelation (after Insert, after Update) {
    
    TriggerHandler_AccountContactRelation handler = new TriggerHandler_AccountContactRelation();
    
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            
            List<AccountContactRelation> acrList = Trigger.new;
            
            List<AccountContactRelation> acrListup = new List<AccountContactRelation>();
            Map<ID, AccountContactRelation> acrOldMap = new Map<ID, AccountContactRelation>();
            
            for(AccountContactRelation  acr : acrList){
                if(acr.IsDirect == false){
                    acrListup.add(acr);
                    acrOldMap.put(acr.Id, acr);
                }
            }
            
            if(acrListup.size() > 0){
                handler.handleContactUpdate(acrListup, acrOldMap);     
            }
        }
    }    
}