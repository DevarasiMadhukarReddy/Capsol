public class sendEmailTaskHandler {
    public static void taskBeforeInsert(List<task> taskList) {
        set<Id> loanIdOnThisTask = new set<Id>();
        system.debug('loanIdOnThisTask'+loanIdOnThisTask);
        List<task> updatedTaskList = new List<task>();
        String loanIdPrefix = Loan_Application__c.sObjectType.getDescribe().getKeyPrefix();
        system.debug('loanIdPrefix'+loanIdPrefix);
        for(task t :taskList){
            If(t.WhatId !=null && String.valueOf(t.WhatId).StartsWith(loanIdPrefix) && (t.Status =='Completed')){
                loanIdOnThisTask.add(t.WhatId);
            }
     }
        
        if(loanIdOnThisTask.size() > 0){        
            Map<id,Loan_Application__c> loanMap = new Map<id,Loan_Application__c>([select Id,Preparer_Email__c from Loan_Application__c WHERE id in: loanIdOnThisTask]);
            system.debug('loanMap'+loanMap);
            
            for(task t :taskList){
                if(loanMap.containsKey(t.WhatId)){
                    t.email_alert__c =loanMap.get(t.WhatId).Preparer_Email__c;
                    system.debug('email'+t.email_alert__c);
                    
                }
            }            
        }
        
    }
    
    public static void taskAfterInsertandUpdate(List<task> taskList) {
        set<Id> loanIdOnThisTask = new set<Id>();
        system.debug('loanIdOnThisTask'+loanIdOnThisTask);
        List<task> updatedTaskList = new List<task>();
        String loanIdPrefix = Loan_Application__c.sObjectType.getDescribe().getKeyPrefix();
        system.debug('loanIdPrefix'+loanIdPrefix);
        for(task t :taskList){
            If(t.WhatId !=null && String.valueOf(t.WhatId).StartsWith(loanIdPrefix) && (t.Status !='Completed')){
                loanIdOnThisTask.add(t.WhatId);
            }
     }
        
        if(loanIdOnThisTask.size() > 0){        
            Map<id,Loan_Application__c> loanMap = new Map<id,Loan_Application__c>([select Id,Assigned_Recruiter_Email__c from Loan_Application__c WHERE id in: loanIdOnThisTask]);
            system.debug('loanMap'+loanMap);
            
            for(task t :taskList){
                if(loanMap.containsKey(t.WhatId)){
                    t.email_alert__c =loanMap.get(t.WhatId).Assigned_Recruiter_Email__c;
                    system.debug('email'+t.email_alert__c);
                    
                }
            }            
        }
        
    }
}