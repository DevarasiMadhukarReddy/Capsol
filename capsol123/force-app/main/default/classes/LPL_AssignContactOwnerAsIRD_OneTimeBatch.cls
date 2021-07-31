/*
CH-01 - This is a one time batch for the new requirement to update the Contact record Owner with the IRD value.			Vaibhav Jain		21 Nov 2018
*/

global class LPL_AssignContactOwnerAsIRD_OneTimeBatch implements Database.Batchable<sObject> {
    
    List<Contact> recordsToUpdate = new List<Contact>();
    ID ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select id,FirstName,LastName,Internal_Recruiter_IRD__c,OwnerId from Contact where RecordtypeId=:ConRecordTypeId';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<Contact> conList){
        try{
            for(Contact con:conList){
                if(con.Internal_Recruiter_IRD__c!=null){
                    con.OwnerId = con.Internal_Recruiter_IRD__c;
                    recordsToUpdate.add(con);                                        
                }
            }
            update recordsToUpdate;
        }
        catch(Exception e){
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_AssignContactOwnerAsIRD_OneTimeBatch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    global void finish(Database.BatchableContext bc){}
}