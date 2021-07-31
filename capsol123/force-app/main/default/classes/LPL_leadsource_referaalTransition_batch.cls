/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
CH-01           Lead Source - Referral and Transition                               Manila Agnihotri                    09 March 2018

****************************** Class commented as it is not used *****************************************
*/

  
global class LPL_leadsource_referaalTransition_batch implements Database.Batchable<sObject> {
 
    List<Contact> fetchMACreateDate = new List<Contact>();  
    List<Contact> con = new List<contact>();
    Set<ID> conIds = new Set<ID>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        //Getting qualified contacts if they is available
        String allRecordTobBeProcessed= Label.LeadSourceAndType;
        
        if(allRecordTobBeProcessed == 'true'){
            String query='Select ID,FirstName, IsReferral__c,Referral_Override__c,LastName, LeadSource,Lead_source__c,Marketing_Category__c from Contact where (RecordType.Name=\'Contact Prospect\')';
            return database.getQueryLocator(query);  
        }
        else{
            String query='Select ID,FirstName, IsReferral__c,Referral_Override__c,LastName, LeadSource,Lead_source__c,Marketing_Category__c from Contact where (RecordType.Name=\'Contact Prospect\') AND Lastmodifieddate >=Yesterday';
            return database.getQueryLocator(query);  
        }
 
    }
    global void execute(Database.BatchableContext BC,List<Contact> conUpdateList){
        
        for(Contact con : conUpdateList){
            conIds.add(con.Id);
        }
        
        fetchMACreateDate = [Select Id, LeadSource,Lead_Source__c,(SELECT OpportunityId FROM OpportunityContactRoles Limit 1), IsReferral__c,Referral_Override__c, Marketing_Category__c, (Select Id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,WhoId from Tasks WHERE Status != 'Completed' and (Department__c='Business Development' and ((Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='BDA Touch') and ( Category__c!='Left Message – Prospecting' and  Category__c!='Mailed information' and  Category__c!='Email – Prospecting' and  Category__c!='Referral to Branch' and  Category__c!='Referral to Core' and  Category__c!='Referral to IS' and  Category__c!='Referral to Masters' and Category__c!='Other'))) ORDER BY CreatedDate DESC limit 1),(Select Id, Name, ELOQUA__Activity_Type__c, CreatedDate, ELOQUA__Contact__c from R00N30000000rPtwEAE__r  where (Name LIKE '%Marketing Campaign Response%' OR Name LIKE '%BD_DisruptionEM%' OR Name LIKE '%BD_DripEM%' OR Name LIKE '%BD_Agile%') AND ELOQUA__Activity_Type__c!='Email Sent' ORDER BY CreatedDate DESC limit 1 ) from Contact where ID in:conIds];
        
       
        
        for(Contact cont: fetchMACreateDate)
        {
            if(String.isNotEmpty(cont.IsReferral__c) && (cont.Lead_Source__c == 'Marketing Initiated (MI)' || cont.Lead_Source__c == 'Recruiter Initiated (RI)') && cont.Referral_Override__c == true){
                cont.Lead_Source__c='Referral';
            }
            else if(String.isNotEmpty(cont.IsReferral__c) && (cont.Lead_Source__c != 'Marketing Initiated (MI)' &&  cont.Lead_Source__c != 'Recruiter Initiated (RI)' && cont.Lead_Source__c != 'Transitions') ){
                cont.Lead_Source__c ='Referral';
            }
            else if(String.isEmpty(cont.Lead_Source__c) && String.isEmpty(cont.IsReferral__c)) {
                if(cont.OpportunityContactRoles.size()>0){
                    cont.Lead_Source__c = 'Transitions';
                }
            }
            con.add(cont);
        }
        update con;
   
    }
    
    global void finish(Database.BatchableContext BC){
        //LPL_SourcetypeUpdate_batch batch2 = new LPL_SourcetypeUpdate_batch();
        //Database.executeBatch(batch2,200);
    }

}