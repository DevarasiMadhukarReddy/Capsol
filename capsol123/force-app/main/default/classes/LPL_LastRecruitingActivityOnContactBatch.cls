/*Batch class Name               : LPL_LastRecruitingActivityOnContact 
Description                      : This one time batch to fetch the Last Recruiting Activity (Task/Event) and populate on the Contact.
Created By                       : Vaibhav Jain
Created Date                     : 8-Mar-2019
*/
global class LPL_LastRecruitingActivityOnContactBatch implements Database.Batchable<sObject> {
    
    ID ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    List<Contact> conToUpdate = new List<Contact>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select id from Contact where RecordtypeId=:ConRecordTypeId';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> conList){
        try{
            
            Set<Id> conIdSet =new Set<Id>();
            for(Contact conRec : conList){
                conIdSet.add(conRec.id);
            }
            
            List<Contact> conDataList = new List<Contact>([Select id,(Select ActivityDate,Department__c,Activity_Type__c from ActivityHistories where (Activity_Type__c='BDA Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='IRD Touch' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='SS&E Recruiting Category') order by ActivityDate desc limit 1) from Contact where id IN : conIdSet]);
            
            for(Contact c: conDataList ){
                if(c.ActivityHistories.size()>0){
                    c.Last_Recruiting_Activity__c = c.ActivityHistories[0].ActivityDate;
                    conToUpdate.add(c);
                }
            }
            if(conToUpdate.size()>0){
                update conToUpdate;
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_LastRecruitingActivityOnContactBatch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    
    global void finish(Database.BatchableContext bc){
    }
    
}