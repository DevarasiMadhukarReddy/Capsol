global class LPL_OpportunityLeadsourceBatch implements Database.Batchable<sObject> {
    
    Set<ID> conid = new  Set<ID>();
    Map<ID, Contact> prospConMap = new Map<Id, Contact>(); 
    List<Opportunity> Oppupdate = new List<Opportunity>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {   
        String query ='SELECT Id, Contact__c,StageName, LeadSource, Source_Type__c FROM Opportunity Where Contact__c!=\'\' AND Contact__c In (Select id from Contact where Recordtype.name=\'Contact prospect\')';
        return database.getQueryLocator(query);  
        
    }
    global void execute(Database.BatchableContext BC,List<Opportunity> OppUpdateList) 
    {
        for(Opportunity con : OppUpdateList){
            conid.add(con.Contact__c);
        }
        
        for(Contact cons:[Select id,Lead_source__c from contact where Recordtype.Name='Contact prospect' and ID in:conid]){
            prospConMap.put(cons.id,cons);
        }
        
        for(Opportunity Opp :OppUpdateList)
        {  
            if(Opp.Contact__c!=null){
                if(prospConMap.size()>0){
                    if(prospConMap.get(Opp.Contact__c).Lead_Source__c != null)
                    {
                        if(Opp.LeadSource != prospConMap.get(Opp.Contact__c).Lead_Source__c ){ 
                            Opp.LeadSource = prospConMap.get(Opp.Contact__c).Lead_Source__c;
                        }
                    }
                    else 
                    {
                        Opp.LeadSource='';
                    }
                }
            }
            Oppupdate.add(Opp);
        }
        update Oppupdate;
    }
    global void finish(Database.BatchableContext BC){
        
    }
}