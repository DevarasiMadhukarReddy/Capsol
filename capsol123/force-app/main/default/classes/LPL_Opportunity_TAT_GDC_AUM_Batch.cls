/*
#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
Ch-1   Fixed an Exception related issue by removing Name field             Garvita Rai                    16 Jan 2019
        from Query
*/

global class LPL_Opportunity_TAT_GDC_AUM_Batch implements Database.Batchable<sObject> , Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext BC){
        String Query = 'Select Id, Name from Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        Map<Id,Id> junctionIdOnContactId=new Map<Id,Id>();
        Map<ID,Decimal> aumOnContactID= new Map<ID,Decimal>();
        Map<ID,Decimal> tatOnContactID= new Map<ID,Decimal>(); 
        Set<ID> accountId=new Set<ID>();
        for(Account acc : Scope){
            accountId.add(acc.Id);   
        }
        //Ch-1 Removed Name field from Query to prevent error in case of Person Account
        List<Account> accListAll = [select id,TAT_GDC__c,AUM_flat_load__c, (Select Id, ContactId,AccountId from AccountContactRelations) from Account where ID in:AccountID];
        
        List<AccountContactRelation> contactIDList =[Select Id, ContactId,AccountId from AccountContactRelation where AccountId in: accountId];
        
        for(AccountContactRelation cobj:contactIDList) {
            junctionIdOnContactId.put(cobj.ContactId,cobj.Id);
        }
        Map<ID, Contact> conMap = new Map<Id, Contact>();
        List<Contact> conList =[select Id, Approved_Expected_AUM__c,Approved_TAT_Revenue__c, accountId from Contact where ID IN:junctionIdOnContactId.keyset() and (Approved_Expected_AUM__c>0 OR Approved_TAT_Revenue__c>0)];
        for(Contact con : conList){
            conMap.put(con.Id, Con);
        }
        Decimal tat=0.0;
        Decimal aum=0.0;
        for(Account acc : accListAll ){
            if(acc.AccountContactRelations.size() > 0){
                tat=0.0;
                aum=0.0;
                for(AccountContactRelation  acr : acc.AccountContactRelations){
                    if(conMap.containsKey(acr.ContactID) && conMap.get(acr.ContactID)!= null){
                        tat = tat+ (conMap.get(acr.ContactID).Approved_TAT_Revenue__c != null? conMap.get(acr.ContactID).Approved_TAT_Revenue__c : 0);
                        aum = aum + (conMap.get(acr.ContactID).Approved_Expected_AUM__c != null? conMap.get(acr.ContactID).Approved_Expected_AUM__c : 0);
                        tatOnContactID.put(acc.ID,tat);
                        aumOnContactID.put(acc.ID,aum);
                    }
                }
            }
            if(tatOnContactID.containsKey(acc.ID)){
                acc.TAT_GDC__c=tatOnContactID.get(acc.ID);
            }
            if(aumOnContactID.containsKey(acc.ID)){
                acc.AUM_flat_load__c=aumOnContactID.get(acc.ID);
            }
            acc.Updated_TAT_and_AUM__c=true; 
            Datetime d=Datetime.now();
            acc.Last_Updated__c=d;
            
        }
        if(accListAll.size()>0){
            update accListAll;
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}