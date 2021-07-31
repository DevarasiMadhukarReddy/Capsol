/*
Batch class Name              :SFA_MarketingCategoryUpdate_batch
Description                   : A certain Marketing Activity is written to Salesforce. Object names in parenthesis(), Operators in brackets{}:
1.  (Marketing Activity) Marketing Activity Name = Marketing Campaign Response
2.  (Marketing Activity) Marketing Activity Name {Contains} “BD_DisruptionEM” or “BD_DripEM” or "BD_Agile"
AND (Marketing Activity) Activity Type {Not Equal} “Email Sent”
What happens: Code looks for certain qualifying sales activity in order to populate the value of Marketing Categorization.
Qualifying Sales Activity
Department = Business Development
Activity Type = IRD Touch, Recruiting, Master Recruiting
Category {Does Not Contain} “Social Media”, “left message”, “mailed”, “email”, “referral”, “other”

All others considered “Qualifying”

Assign Marketing Category
If qualifying activity exists:
•   If activity date (due date) is in previous six months (before marketing activity create date) then assign “Active”
•   If activity date (due date) is not in previous six months, then assign “Inactive”
If no qualifying activity exists:
Assign “New”

Developer Name                 :Vaibhav Wadhai
Created Date                   :23 may 2017
Versio No                      :1.0

##############Change History#############
CH.No       Description                                         Developer           Date
-----------------------------------------------------------------------------------------------------
CH-01       Add Marketing Activity Name "BD_Agile"              Vaibhav Wadhai      25 may 2017
(New Reqirement)
CH-02       Modified Subquery in contact and lead               Vaibhav Wadhai      30 may 2017
to solve error 'Aggregate query has to
many rows for direct Assignment'

Note : Test Coverage for This Class is covered in Test classes  : SFA_MarketingCategoryUpdate_batch_Test
*/



global class SFA_MarketingCategoryUpdate_batch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //Getting qualify task for associated contact and lead if it is available
        String query='Select ID,Name,ELOQUA__Contact__c,ELOQUA__Lead__c,createdDate,ELOQUA__Activity_Type__c from ELOQUA__Marketing_Activity__c where LastModifiedDate>=yesterday order By createdDate';
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC,List<ELOQUA__Marketing_Activity__c> marketingActivityList) {
        
        List<ELOQUA__Marketing_Activity__c> qualifyMarketingActivityList=new List<ELOQUA__Marketing_Activity__c>();
        Set<Id> conIds = new Set<Id>();
        Set<Id> ledIds = new Set<Id>();
        Map<Id,contact> contactsMap =new Map<Id,contact>();//for contact map
        Map<Id,datetime> MarkActivityCon=new Map<Id,datetime>();//for storing created date of marketing Activity having contact
        Map<Id,datetime> MarkActivitylead=new Map<Id,datetime>();//for storing created date of marketing Activity having lead    
        List<Contact> contactList = new List<Contact>();
        Map<Id,lead> leadsMap =new Map<Id,lead>();        
        List<lead> leadList=new List<lead>();
        
        if(marketingActivityList.size()>0) {
            
            for(ELOQUA__Marketing_Activity__c em1:marketingActivityList) {
                //CH - 01 -Start
                if(em1.Name.contains('Marketing Campaign Response')||((em1.Name.contains('BD_DisruptionEM')||em1.Name.contains('BD_DripEM')||em1.Name.contains('BD_Agile'))&& em1.ELOQUA__Activity_Type__c!='Email Sent')) {
                    //Ch - 01 -End
                    if(em1.ELOQUA__Contact__c!=null) {
                        
                        conIds.add(em1.ELOQUA__Contact__c);
                        MarkActivityCon.put(em1.ELOQUA__Contact__c,em1.createdDate);
                    }
                    
                    if(em1.ELOQUA__Lead__c!=null) {
                        
                        ledIds.add(em1.ELOQUA__Lead__c);
                        MarkActivitylead.put(em1.ELOQUA__Lead__c,em1.createdDate);
                    }
                }                        
            }
        }
        
        //Updating contact marketing category field to 'New' or 'Active' or 'InActive' based qualify task's activity date
        if(!conIds.isEmpty()) {
            //CH - 02-Start
            for(Contact con:[Select Id,(Select id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE Status = 'Completed' and (Department__c='Business Development' and ((Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting') and (Category__c!='Social Media Outreach' and Category__c!='Left Message – Prospecting' and  Category__c!='Mailed information' and  Category__c!='Email – Prospecting' and  Category__c!='Referral to Branch' and  Category__c!='Referral to Core' and  Category__c!='Referral to IS' and  Category__c!='Referral to Masters' and Category__c!='Other'))) order by ActivityDate DESC limit 1) from contact where Id in:conIds]) {
                //CH -02-End    
                datetime activitycreatedDate=MarkActivityCon.get(con.id);
                date activityCreated=activitycreatedDate.date();//convert into date format                
                
                if(con.tasks.isEmpty()) {
                    
                    con.Marketing_Category__c='new';
                    contactsMap.put(con.Id,con);
                }
                else {
                    
                    Date taskCreatedDate;
                    
                    for(task tsk:con.tasks) {
                        
                        taskCreatedDate=tsk.ActivityDate;
                        
                        if(taskCreatedDate>activityCreated) {
                            
                            con.Marketing_Category__c='Inactive'; //task created date is greater than marketing activity created date
                            contactsMap.put(con.Id,con);
                        }
                        else {
                            if(taskCreatedDate.daysBetween(activityCreated)<=180 || taskCreatedDate==activityCreated) {
                                
                                con.Marketing_Category__c='Active';//task created date is previous than marketing activity created date and within 180 days 
                                contactsMap.put(con.Id,con);       //and also task created date is same as marketing activity created date
                            }
                            else {
                                
                                con.Marketing_Category__c='Inactive';//task created date is previous than marketin activity created date and more than 180 days
                                contactsMap.put(con.Id,con);
                            }
                        }
                    }                    
                    
                }
            }
            contactList = new List<Contact>();
            contactList.addAll(contactsMap.values());
            update contactList;
        }
        //Ch-2
        //Updating lead's marketing category field to 'New' or 'Active' or 'InActive' based qualify task's activity date
        if(!ledIds.isEmpty()) {
            //CH - 02-Start        
            for(lead led:[Select Id,(Select id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE Status = 'Completed' and (Department__c='Business Development' and ((Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting') and (Category__c!='Social Media Outreach' and Category__c!='Left Message – Prospecting' and  Category__c!='Mailed information' and  Category__c!='Email – Prospecting' and  Category__c!='Referral to Branch' and  Category__c!='Referral to Core' and  Category__c!='Referral to IS' and  Category__c!='Referral to Masters' and Category__c!='Other'))) order by ActivityDate DESC  limit 1)from lead where Id in:ledIds]) {
                //CH -02-End  
                datetime activitycreatedDateforLead=MarkActivitylead.get(led.id);
                date activityCreatedforLead=activitycreatedDateforLead.date();//convert into date format           
                
                if(led.tasks.isEmpty()) {
                    
                    led.Marketing_Category__c='New';
                    leadsMap.put(led.id,led);
                }
                else {
                    
                    Date taskDueDateforLead;
                    
                    for(task tsk:led.tasks) {
                        
                        taskDueDateforLead=tsk.ActivityDate;
                        
                        if(taskDueDateforLead>activityCreatedforLead) {
                            
                            //task created date is greater than marketing activity created date
                            led.Marketing_Category__c='Inactive';
                            leadsMap.put(led.id,led);
                            
                        }
                        else {
                            if(taskDueDateforLead.daysBetween(activityCreatedforLead)<=180 || taskDueDateforLead == activityCreatedforLead) {
                                
                                //task created date is previous than marketing activity created date and within 180 days and also task created date is same as marketing activity                            
                                led.Marketing_Category__c='Active';
                                leadsMap.put(led.id,led);
                                
                            }
                            else {
                                
                                //task created date is previous than marketing activity created date and more than 180 days
                                led.Marketing_Category__c='Inactive';
                                leadsMap.put(led.id,led);
                            }
                        }
                    }
                    
                }
                
            }
            leadList=new list<lead>();
            leadList.addAll(leadsMap.values());                         
            update leadlist;
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}