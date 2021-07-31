/*

Batch class Name              : LPL_Update_BSStatus_Batch

Description                   : This batch class updates the status of LPL Advisor contact record to 'Terminated' on the Termination date. If the value of Termination date for Admin Solution
                                Marketing solution and CFO solution is updated to a future date through LBS system, then on that particular date the Admin Solution Status,Marketing Solution Status and CFO Solution Status
                                should be set to 'Terminated'

Created By                    : Ishan Nigam
Created Date                  : 10-Sep-2020

#####additional requirement added for future Active date update on 18-Sep-2020 ########## 

Description                   : This Batch updates the status of LPL Advisor contact record to 'Active' on the active date. If the value of Active date for Admin Solution
                                Marketing solution and CFO solution is updated to a future date through LBS system, then on that particular date the Admin Solution Status,Marketing Solution Status and CFO Solution Status
                                should be set to 'Active'.


#############################Change History####################
CH No.      Requirement                                                       Developer Name                   Date

CH-0        Implemented the logic for the description above.                   Ishan Nigam                     10-Sep-2020   
*/
//CH-0 STARTS
global class LPL_Update_BSStatus_Batch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //Getting LPL Advisors with  Active / Termination dates today
        
        ID LPLAdvisorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        String query = 'SELECT Id,Name,RecordTypeId,Admin_Solutions_Active_Date__c,Marketing_Solutions_Active_Date__c,CFO_Solutions_Active_Date__c,Admin_Solutions_Termination_Date__c,CFO_Solutions_Termination_Date__c,Marketing_Solutions_Termination_Date__c,IAO_Advisor_Interest__c,Experiment_s__c,CFO_Solutions_Status__c  FROM Contact WHERE RecordTypeId =: LPLAdvisorRecordTypeId AND ( Admin_Solutions_Active_Date__c = TODAY OR CFO_Solutions_Active_Date__c = TODAY OR Marketing_Solutions_Active_Date__c = TODAY OR Admin_Solutions_Termination_Date__c = TODAY OR Marketing_Solutions_Termination_Date__c = TODAY OR CFO_Solutions_Termination_Date__c =TODAY )';
        //string query = 'select id,name,RecordTypeId,Admin_Solutions_Termination_Date__c, CFO_Solutions_Termination_Date__c, Marketing_Solutions_Termination_Date__c, IAO_Advisor_Interest__c, Experiment_s__c, CFO_Solutions_Status__c  from contact where RecordTypeId =: LPLAdvisorRecordTypeId and (Admin_Solutions_Termination_Date__c = TODAY or Marketing_Solutions_Termination_Date__c = TODAY or CFO_Solutions_Termination_Date__c = Today)';
         
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,list<contact> lstContacts){
        
        //Setting the status of Admin,Marketing and CFo solutions to Active / Terminated.
        
        try
        {
            List<Contact> lstToUpdate = new List<Contact>();
            String activecustomlabel = System.Label.LPL_BS_Active_Status; 
            String terminatedCustomLabel = System.Label.LPL_BS_Terminated_Status;
            
            for(Contact con : lstContacts)
            {
                if(con.Admin_Solutions_Active_Date__c == System.today() && con.IAO_Advisor_Interest__c != activecustomlabel 
                   && (con.Admin_Solutions_Termination_Date__c == NULL || con.Admin_Solutions_Termination_Date__c > System.Today()))
                {
                    con.IAO_Advisor_Interest__c = activecustomlabel;
                }
                else if(con.Admin_Solutions_Termination_Date__c == System.today() && con.IAO_Advisor_Interest__c != terminatedCustomLabel)
                {
                    con.IAO_Advisor_Interest__c = terminatedCustomLabel;
                }
                
                
                if(con.Marketing_Solutions_Active_Date__c == System.today() && con.Experiment_s__c != activecustomlabel
                   && (con.Marketing_Solutions_Termination_Date__c == NULL|| con.Marketing_Solutions_Termination_Date__c > System.Today()))
                {
                    con.Experiment_s__c = activecustomlabel;
                }
                else if(con.Marketing_Solutions_Termination_Date__c == System.today() && con.Experiment_s__c != terminatedCustomLabel)
                {
                    con.Experiment_s__c = terminatedCustomLabel;
                }
                
                
                if(con.CFO_Solutions_Active_Date__c == System.today() && con.CFO_Solutions_Status__c != activecustomlabel
                   && (con.CFO_Solutions_Termination_Date__c == NULL|| con.CFO_Solutions_Termination_Date__c > System.Today()))
                {
                    con.CFO_Solutions_Status__c = activecustomlabel;
                }   
                else if(con.CFO_Solutions_Termination_Date__c == System.today() && con.CFO_Solutions_Status__c != terminatedCustomLabel)
                {
                    con.CFO_Solutions_Status__c = terminatedCustomLabel;
                }
                
                lstToUpdate.add(con);
            }
            if(lstToUpdate.size() > 0)
            {
                update lstToUpdate;
            }
            
        }
        catch(exception e)
        {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Update_BSStatus_Batch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
        
    }
    global void finish(Database.BatchableContext BC){
        
    }
}//CH-0 ENDS