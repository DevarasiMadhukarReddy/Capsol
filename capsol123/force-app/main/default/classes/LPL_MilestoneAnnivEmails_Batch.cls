/*Batch class Name			: LPL_MilestoneAnnivEmails_Batch
Description					: This batch class is activating LPL Milestone Anniversary emails for IS Program Managers and IAS Advisors, RIA IFA, and RIA Hybrid contacts
Developer Name				: Justin Lonh
Created Date				: 24-May-2021
*/
global class LPL_MilestoneAnnivEmails_Batch implements Database.Batchable<sObject> {
    
    ID advisorConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
    ID pmConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('PM/Executive').getRecordTypeId();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //Getting Contacts
        String query = 'Select Id, RecordTypeId, Hire_Date__c, Anniv_Day_for_Workflow__c, Branch_Channel__c, Role__c, Rep_Type__c from Contact where Hire_Date__c != null AND (RecordTypeId =: advisorConRecordTypeId OR RecordTypeId =: pmConRecordTypeId)';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> conList) {
		try {  
            List<Contact> updateCon = new List<Contact>();
            List<String> contactRTypes = new List<String>{'RIA IFA Advisor', 'RIA Hybrid Advisor', 'IAS Advisor'};
            
            for(Contact con: conList) {
                
                if(((con.Branch_Channel__c == 'IS' || con.Branch_Channel__c == 'IAS&IS') && con.Role__c == 'Program Manager') || contactRTypes.contains(con.Rep_Type__c)) {
                    
                    Integer conAgeInTwoWeeks = system.today().addDays(14).year() - con.Hire_Date__c.year();
                    if(system.today().addDays(14) == con.Anniv_Day_for_Workflow__c &&
                       conAgeInTwoWeeks > 0 &&
                       (math.mod(conAgeInTwoWeeks, 5) == 0 || conAgeInTwoWeeks == 1 || conAgeInTwoWeeks > 45)) {
                        	con.Reset_Anniversary_Email_System__c = false;
                        	updateCon.add(con);
                    }
                }
            }
            
            if(!updateCon.isEmpty() && updateCon.size() >0) {
                update updateCon;
            }
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_MilestoneAnnivEmails_Batch ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
    }
    
    global void finish(Database.BatchableContext BC) {
    }

}