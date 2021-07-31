/*Batch class Name               :SFA_Contact_Batch
Description                      : This batch class is getting task from contact and update Marketing Category on Contact. 
Created By                       : Ashish Gupta
Created Date                     : 13-nov-2017
*/
global class SFA_Contact_Batch implements Database.Batchable<sObject> {
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //Getting qualify task for associated contact 
        String query='Select Id,(Select id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE Status = \'Completed\' and (Department__c= \'Business Development\' and ((Activity_Type__c= \'IRD Touch\' OR Activity_Type__c= \'Recruiting\' OR Activity_Type__c=\'Master Recruiting\' OR Activity_Type__c= \'BDA Touch\') and (Category__c!=\'Social Media Outreach\' and Category__c!=\'Left Message – Prospecting\'and Category__c!=\'Mailed information\' and  Category__c!= \'Email – Prospecting\' and  Category__c!=\'Referral to Branch\' and  Category__c!=\'Referral to Core\' and  Category__c!=\'Referral to IS\' and  Category__c!=\'Referral to Masters\' and Category__c!=\'other\'))) order by ActivityDate DESC limit 1) from contact where PardotActivityInput__c!=null OR Previous_PardotAcivity_Value__c != null';
        
        
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC,List<Contact> conList) {
        
        Map<Id,contact> contactsMap =new Map<Id,contact>();//for contact map
        Map<Id,datetime> conLastActivityDateMAP=new Map<Id,datetime>();
        
        List<Contact> contactList = new List<Contact>();             
      try {   
        
        for(Contact con:conList){
            if(con.tasks.isEmpty()) {
                
                con.Marketing_Category__c='new';
                contactsMap.put(con.Id,con); 
            }
            else {
                Date taskDueDate;
                Datetime taskCreationDate;
                for(task tsk:con.tasks) {
                    
                    taskCreationDate=tsk.CreatedDate;
                    Date activityCreated =taskCreationDate.date();
                    
                    System.debug('Task Creation Date>>'+activityCreated);
                    taskDueDate=tsk.ActivityDate;
                    
                    System.debug('Task due Date>>'+taskDueDate);
                    
                    if(taskDueDate>activityCreated) {
                        
                       
                        con.Marketing_Category__c='Inactive'; //task created date is greater than marketing activity created date
                        contactsMap.put(con.Id,con);
                        System.debug('If due date is greater than task creation date con Id>>'+con);
                    }
                    else {
                        if(taskDueDate.daysBetween(activityCreated)<=180 || taskDueDate==activityCreated) {
                            System.debug('If due date is equal to task creation date of 180 than con Id>>'+con);
                            con.Marketing_Category__c='Active';//task created date is previous than marketing activity created date and within 180 days 
                            contactsMap.put(con.Id,con);       //and also task created date is same as marketing activity created date
                        }
                        else {
                         
                            con.Marketing_Category__c='Inactive';//task created date is previous than marketin activity created date and more than 180 days
                            contactsMap.put(con.Id,con);
                            System.debug('inactive con Id>>'+con);
                        }
                    }
                    
                }
                
            }
            
        }
        
        contactList.addAll(contactsMap.values());
        if(contactList.size()>0){
            System.debug('contactList.size() >>'+contactList.size());
            update contactList;            
        }
      }  catch(exception e) {
        
            LPL_CreateExceptionLog.createErrorRecordSync('SFA_Contact_Batch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
    }
    global void finish(Database.BatchableContext BC){
        
    }
}