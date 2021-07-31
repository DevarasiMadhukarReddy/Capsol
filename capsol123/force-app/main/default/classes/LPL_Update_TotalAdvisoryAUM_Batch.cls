/*
Batch class Name              :LPL_Update_TotalAdvisoryAUM_Batch
Developer Name                :Vaibhav Wadhai
Created Date                  :14 june 2017
Versio No                     :1.0 

Note:Test class-LPL_Update_TotalAdvisoryAUM_Batch_Test
*/

global class LPL_Update_TotalAdvisoryAUM_Batch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Set<Id> recordTypeIds=new set<Id>();
        Id oppRecordTypeIBDid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();       
        //Id oppRecordTypeBCid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IS Business Consulting').getRecordTypeId();
        Id oppRecordTypeISid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IS Opportunity').getRecordTypeId();
        recordTypeIds.add(oppRecordTypeIBDid);
        //recordTypeIds.add(oppRecordTypeBCid);
        recordTypeIds.add(oppRecordTypeISid);
        
        String query;
        query='Select Id,Total_Advisory_AUM__c,AccountId from Opportunity where RecordTypeId in : recordTypeIds';                                       
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Opportunity> OpportunityList) {
        
        try {
        System.debug('In OpportunityList '+OpportunityList);
        
        set<Id> accountIds=new set<Id>();
        List<Branch_Inst_Financial__c> listOfBIF = new List<Branch_Inst_Financial__c>();
        Map<Id,Branch_Inst_Financial__c> mapBranch = new Map<Id,Branch_Inst_Financial__c>();
        List<Opportunity> OptyAccountList=new List<Opportunity>();
        Map<Id,Opportunity> OptyAccountMap=new Map<Id,Opportunity>();
        Map<Id,Opportunity> TotalAdvisoryOptyMap=new Map<Id,Opportunity>();
        
        for(Opportunity opp:OpportunityList) {
            
            if(opp.AccountId!=null && opp.Total_Advisory_AUM__c==null) {
            
                //accountIds.add(opp.AccountId);
                OptyAccountMap.put(opp.AccountId,opp);//getting the opportunities those has accound and Total_Advisory_AUM__c is equal to null 
                
                System.debug('OptyAccountMap'+OptyAccountMap);
            }
        }
        
        if(OptyAccountMap.size()>0 ) {//getting the required data from Branch_Inst_Financial__c where accountId is present
            
            listOfBIF = [select id,name,Account__c,Total_Advisory_AUM__c from Branch_Inst_Financial__c where Account__c In:OptyAccountMap.keyset()];
        }
        
        for(Branch_Inst_Financial__c b:listOfBIF) {
        
                if(b.name.contains('-OSJ')) {//checking records in 'listOfBIF' list contains string '-OSJ'
          
                      if(b.Account__c != null) {//checking account is present or not
                         
                         mapBranch.put(b.Account__c,b);
                         System.debug('mapBranch'+mapBranch);      
                    }
                }
        }
          if(mapBranch.size()>0){
        
            for(Opportunity opp:OpportunityList){
        
                if(opp.AccountId != null) {
                
                    if(mapBranch.Containskey(opp.AccountId)) {
                       
                       if(mapBranch.get(opp.AccountId).Account__c != null){ 
                       
                           if(opp.AccountId  == mapBranch.get(opp.AccountId).Account__c) {
                           
                               opp.Total_Advisory_AUM__c = mapBranch.get(opp.AccountId).Total_Advisory_AUM__c;//getting data from Branch_Inst_Financial__c and 
                                                                                                              //store into opportunity
                               TotalAdvisoryOptyMap.put(opp.id,opp);
                               System.debug('TotalAdvisoryOptyMap'+TotalAdvisoryOptyMap);  
                           }
                        
                        }
                    }
                }
            }
        }
        
        OptyAccountList=new List<Opportunity>();
        OptyAccountList.addAll(TotalAdvisoryOptyMap.values());
        
        if(OptyAccountList.size()>0) {
        
            System.debug('OptyAccountList'+OptyAccountList.size()+OptyAccountList);
            Database.update(OptyAccountList);
            
        }
        
        }
        catch(exception e) {
        
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Update_TotalAdvisoryAUM_Batch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}