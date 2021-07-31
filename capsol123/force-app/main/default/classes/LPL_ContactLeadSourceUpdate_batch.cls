/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
CH-01           Lead Source - MI & RI- Update Lead source on                        Manila Agnihotri                    05 March 2018
Contact with either MI or RI Considering the most recent
from “Marketing Initiated (MI)" and Recruiter Initiated (RI).                                       
*/
global class LPL_ContactLeadSourceUpdate_batch implements Database.Batchable<sObject>, Database.Stateful{
    
     global Set<Id> ContactproccessedID = new Set<Id>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //Getting qualified contacts if they is available
        String allRecordTobBeProcessed= Label.LeadSourceAndType;
        
        if(allRecordTobBeProcessed == 'true'){
            String query='Select ID,FirstName, IsReferral__c,Referral_Override__c,LastName,lastModifiedDate ,LeadSource,Lead_source__c,Marketing_Category__c from Contact where ((Marketing_Category__c =\'\' OR Marketing_Category__c =  \'Dormant\') AND (RecordType.Name=\'Contact Prospect\') AND (Lead_source__c = null)) AND Lastmodifieddate =Today order by LastModifiedDate DESC';
            return database.getQueryLocator(query);  
        }
        else{
            String query='Select ID,FirstName, IsReferral__c,Referral_Override__c,LastName,lastModifiedDate ,LeadSource,Lead_source__c,Marketing_Category__c from Contact where ((Marketing_Category__c =\'\' OR Marketing_Category__c =  \'Dormant\') AND (RecordType.Name=\'Contact Prospect\') AND (Lead_source__c = null)) order by LastModifiedDate DESC';
            return database.getQueryLocator(query);  
        }
        
    }
    global void execute(Database.BatchableContext BC,List<Contact> conUpdateList) {
        
        Set<Id> conIds = new Set<Id>();
        Map<Id,contact> contactsMap =new Map<Id,contact>();//for contact map
        Map<Id,datetime> markActivityCon=new Map<Id,datetime>();//for storing created date of marketing Activity having contact
        Map<Id,datetime> taskCon=new Map<Id,datetime>();
        List<Contact> contactList = new List<Contact>();
        List<Contact> fetchMACreateDate = new List<Contact>();       
        List<Contact> fetchTaskCreateDate= new List<Contact>();
        Map<Id,Boolean> contactopp= new  Map<Id,Boolean>();
        List<Contact> con1 = new List<contact>();
        
        List<Contact> con3 = new List<contact>();
        datetime taskCreateDate;
        datetime maCreatedDate;
        
        for(Contact con : conUpdateList){
                conIds.add(con.Id);
            }
            
            fetchMACreateDate = [Select Id, LeadSource,Lead_Source__c, IsReferral__c,Referral_Override__c, Marketing_Category__c,(SELECT OpportunityId FROM OpportunityContactRoles Limit 1), (Select Id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,WhoId from Tasks WHERE Status = 'Completed' and (Department__c='Business Development' and ((Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='BDA Touch') and ( Category__c!='Left Message – Prospecting' and  Category__c!='Mailed information' and  Category__c!='Email – Prospecting' and  Category__c!='Referral to Branch' and  Category__c!='Referral to Core' and  Category__c!='Referral to IS' and  Category__c!='Referral to Masters' and Category__c!='Other'))) ORDER BY CreatedDate DESC limit 1),(Select Id, Name, ELOQUA__Activity_Type__c, CreatedDate, ELOQUA__Contact__c from R00N30000000rPtwEAE__r  where (Name LIKE '%Marketing Campaign Response%' OR Name LIKE '%BD_DisruptionEM%' OR Name LIKE '%BD_DripEM%' OR Name LIKE '%BD_Agile%') AND ELOQUA__Activity_Type__c!='Email Sent' ORDER BY CreatedDate DESC limit 1 ) from Contact where ID in:conIds];
            
            for(Contact maLoop: fetchMACreateDate){
                if(maLoop.ELOQUA__R00N30000000rPtwEAE__r.size()>0){
                    maCreatedDate = maLoop.ELOQUA__R00N30000000rPtwEAE__r[0].CreatedDate;
                    markActivityCon.put(maLoop.Id, maLoop.ELOQUA__R00N30000000rPtwEAE__r[0].CreatedDate);
                }
            }
            
            for(Contact taskLoop: fetchMACreateDate){ 
                if(taskLoop.Tasks.size()>0){
                    taskCreateDate = taskLoop.Tasks[0].CreatedDate;     
                    taskCon.put(taskLoop.Id, taskLoop.Tasks[0].CreatedDate);
                }
            }
        for(Contact opploop: fetchMACreateDate){
           if(opploop.OpportunityContactRoles.size()>0 && !opploop.OpportunityContactRoles.isEmpty()){
               contactopp.put(opploop.id,true);
             }
             else
             {
                 contactopp.put(opploop.id,false);
             }
        }
        
        
        for(Contact c: conUpdateList)
        {
            datetime recentactivitydate = markActivityCon.get(c.id);
            datetime Recentaskdate = taskCon.get(c.id);
            Boolean presentopp =contactopp.get(c.id);
         If(Recentaskdate!=null && recentactivitydate!=null)
            {
                if(Recentaskdate > recentactivitydate)
                {
                    c.Lead_source__c = 'Recruiter Initiated';
                }
                else if(Recentaskdate < recentactivitydate){
                    c.Lead_source__c = 'Marketing Initiated';
                }
                else if(Recentaskdate == recentactivitydate){
                    c.Lead_source__c ='Marketing Initiated';
                }
                 con1.add(c);
              ContactproccessedID.add(c.Id);
            }
            else if(Recentaskdate == null && recentactivitydate!= null){
                c.Lead_source__c = 'Marketing Initiated';
                  con1.add(c);
              ContactproccessedID.add(c.Id);
            }
            else if (Recentaskdate != null && recentactivitydate== null){
                c.Lead_source__c = 'Recruiter Initiated';
                  con1.add(c);
              ContactproccessedID.add(c.Id);
            }
            else if(Recentaskdate == null && recentactivitydate== null)
            {
                if(presentopp)
                {
                  c.Lead_Source__c = 'Transitions';  
                    con1.add(c);
              ContactproccessedID.add(c.Id);
                }
                  
            }
            else{
                //do nothing
            }
       
              //con1.add(c);
              //ContactproccessedID.add(c.Id);
           
        }
        if(!con1.isEmpty() && con1.size()>0)
        {
        update con1;
        }
    }
    global void finish(Database.BatchableContext BC){
        system.debug('>>>>>>>>>>>>>>>>>>>' + ContactproccessedID);
      if(ContactproccessedID.size() > 0) 
        {
        system.debug('ContactproccessedID' + ContactproccessedID);
        LPL_SourcetypeUpdate_batch batch2 =new  LPL_SourcetypeUpdate_batch(ContactproccessedID);
        Database.executeBatch(batch2,200);
        }
    }
}