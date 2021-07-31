/*
Class Name              :LPL_RecoverDeletedChildRecords_batch
Description             :To recover the records deleted from Demand tool
Developer Name          :Manila Agnihotri
Created Date            :20/9/2018
*/
global class LPL_RecoverDeletedChildRecords_batch implements Database.Batchable<sObject> {
    
    ID laConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    Date today = system.today();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        
        String query='Select Id, RecordTypeId, Hire_Date__c, Next_Anniversary_Date__c from Contact where RecordtypeId=:laConRecordTypeId AND Firstname LIKE \'%' + 'DELETE***' + '%\' AND IsDeleted = True ALL ROWS';
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC,List<Contact> conList) {
        try 
        {  
            if(conList.size()!=0)
            {
                UnDelete conList;
            } 
        }
        catch(exception e) {
            
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Deletechildrecords_batch ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
    }
    global void finish(Database.BatchableContext BC){
        
    }
}