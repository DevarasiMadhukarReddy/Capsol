/*
Class Name              :LPL_update
Description             :Class to set the Reset Anniversary Email System to true
Developer Name          :Manila Agnihotri
Created Date            :08/10/2018
*/
global class LPL_update implements Database.Batchable<sObject> {
    
    ID laConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId(); 
    Date today = system.today();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Getting qualify Contacts
        String query='Select Id, RecordTypeId,Reset_Anniversary_Email_System__c,Hire_Date__c,Receive_Anniversary_Emails__c,Next_Anniversary_Date__c from Contact where Hire_Date__c!=null AND RecordTypeId =: laConRecordTypeId AND Reset_Anniversary_Email_System__c =False ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<Contact> conList){
        try {  
            List<Contact> updateCon = new List<Contact>();
            
            for(Contact con: conList){
                con.Reset_Anniversary_Email_System__c =true;
                con.Next_Anniversary_Date__c = Null;
                updateCon.add(con);
            }
            if(!updateCon.isEmpty() && updateCon.size() >0){
                update updateCon;
            }
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_update','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
    }
    global void finish(Database.BatchableContext BC){
    }
    
}