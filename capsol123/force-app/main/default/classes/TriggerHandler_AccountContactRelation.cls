Public class TriggerHandler_AccountContactRelation {
    
    public Void handleContactUpdate(List<AccountContactRelation> acRelList, Map<ID, AccountContactRelation> acMap){
        
        Map<ID, AccountContactRelation> conACMap = new Map<ID, AccountContactRelation>();
        Set<ID> accMapID = new Set<ID>();
        Map<ID, Account> accNameMap = new Map<ID, Account>();
        
        for(AccountContactRelation acRel : acRelList){
            conACMap.put(acRel.ContactID, acRel);
            accMapID.add(acRel.AccountID);    
        }
        
        for(Account acc: [Select id , Name from Account where Id in: accMapID]){
            accNameMap.put(acc.Id, acc);
        }
        
        List<Contact> conList = [Select Id, Institutional_Group__c, Is_Institutional_Group_Updated__c from Contact where Id in:  conACMap.keyset()];
        
        List<Contact> updConList = new List<Contact>();
        
        if(conList.size() != 0){
            for(Contact con : conList){
                if(con.Is_Institutional_Group_Updated__c == false){
                    con.Institutional_Group__c = accNameMap.get(conACMap.get(con.ID).AccountID).Name;
                    updConList.add(con);
                }
            }
            
            if(updConList.size() != 0){
                update updConList;
            }
        }
        
        
    }
    
   
    
}