/*
Class Name              :LPL_Deletechildrecords_batch
Description             :To delete the merge records after success in Demand Tool.
Developer Name          :Manila Agnihotri
Created Date            :20/9/2018
*/
global class LPL_Deletechildrecords_batch implements Database.Batchable<sObject>{

ID laConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
Date today = system.today();

global Database.QueryLocator start(Database.BatchableContext BC) {
  
    String query='Select Id, Name, RecordTypeId, Hire_Date__c, Next_Anniversary_Date__c from Contact where Name LIKE \'%' + 'DELETE***' + '%\' AND RecordtypeId=:laConRecordTypeId';
    System.debug(query);
    return Database.getQueryLocator(query);
    
    }

global void execute(Database.BatchableContext BC,List<Contact> conList) {
   try 
   {  
       if(conList.size()!=0)
       {
        Delete conList;
       }
   }
  
   catch(exception e) {
        LPL_CreateExceptionLog.createErrorRecordSync('LPL_Deletechildrecords_batch ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
    }  
}
global void finish(Database.BatchableContext BC){
    
}
}