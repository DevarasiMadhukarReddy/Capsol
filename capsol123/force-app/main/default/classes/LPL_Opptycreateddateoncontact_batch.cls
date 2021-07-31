/*Batch class Name               : LPL_Opptycreateddateoncontact_batch 
Description                      : This batch class updates Contact based on Opportunity created date. 
Created By                       : Manila
Created Date                     : 1- oct-2018
*/


global class LPL_Opptycreateddateoncontact_batch implements Database.Batchable<sObject>{
    ID ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query='Select id,Lastname,Opportunity_created_date__c from contact where RecordtypeId=:ConRecordTypeId';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Contact> conList){
        
        List<Contact> upcon=new List<Contact>();
        Set<ID> conId = new Set<ID>();
        Map<Id, List<Opportunity>> mapCon= new  Map<Id, List<Opportunity>>();
        
        try { 
            for(Contact conup:conList){
                conId.add(conup.id);
            }
            List<Opportunity> oppList=new List<opportunity>([Select id, createddate,Contact__c from Opportunity where Contact__c in:conId order by createddate DESC]);
            if(oppList.size()>0){
                for(Opportunity opp: oppList){
                    if(mapCon.containskey(opp.contact__c)){
                    }
                    else{
                        mapCon.put(opp.contact__c,new List<opportunity>{opp});
                    }
                }
            } 
            for(Contact conup:conList){
                if(mapCon.containskey(conup.id)){
                    for(Opportunity opp:mapCon.get(conup.id)){
                        conup.Opportunity_created_date__c  = opp.CreatedDate;
                        upcon.add(conup);
                    }
                }
            }
            if(upcon.size()>0){
                update upcon; 
            }
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Opptycreateddateoncontact_batch ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
    }
    global void finish(Database.BatchableContext BC){
    }
}