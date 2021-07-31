trigger CT_TaskAfterInsertUpdate on Task (after insert, after update) {

    Set<id> WhatIds = new Set<id>();
    Set<id> lastActivityWhatIds = new Set<id>();    
    Map<id, Opportunity> oppMap;    
    Map<id, Opportunity> lastActivityoppMap;    
    Map<Id, Opportunity> mOpportunity;        
    Set<id> lastActivityWhoIds = new Set<id>();
    
    Map<id, Lead> lastActivityLeadMap;   
    
    List<Opportunity> lOpportunities;
    List<Task> updateTaskstatusList = new List<Task>();
    
    
    for(Task t : trigger.new) 
    {    
        
        if(t.Status == 'Completed')
        {  
            if(t.whatId != null)
            {
                if(String.valueOf(t.WhatId).StartsWith('006')) WhatIds.add(t.WhatID);
            }
        } 
        
        /*  Start - ******** Lead Onboarding Changes **********  */
        
        //Update sttus in Days Fields on Task
        if(Trigger.OldMap != null) {
            List<Task> oldTaskList = Trigger.OldMap.values();
            if(t.whatId != null && String.valueOf(t.WhatId).StartsWith('006')){
                if(t.Status != oldTaskList[0].Status){
                    updateTaskstatusList.add(t);
                }
            }
        }
        
        /*  End - ******** Lead Onboarding Changes ********** */
        
        // Opportunity Activity
        if(trigger.isupdate && t.whatId != null )
        {
        if(t.Status!= Trigger.oldMap.get(t.Id).Status)           
        if(String.valueOf(t.WhatId).StartsWith('006')) lastActivityWhatIds.add(t.WhatID);
        } 
        
        if (trigger.isinsert && t.whatId != null) 
        {
            if(String.valueOf(t.WhatId).StartsWith('006')) lastActivityWhatIds.add(t.WhatID);
        }
        
        //Lead Activity
        
        if(trigger.isupdate && t.whoId != null)
        {
        if(t.Status!= Trigger.oldMap.get(t.Id).Status)
       
            if(String.valueOf(t.WhoId).StartsWith('00Q')) lastActivityWhoIds.add(t.WhoID);
        } 
        
        if (trigger.isinsert && t.whoId != null) 
        {
           
            if(String.valueOf(t.WhoId).StartsWith('00Q')) lastActivityWhoIds.add(t.WhoID);
        }
        
    }           
    
    if(WhatIds.size() != 0)
    oppMap = new Map<id, Opportunity>([Select id, Name, StageName From Opportunity Where (Id in :WhatIDs)]);     
    
    
    if(lastActivityWhatIds.size() != 0) 
    lastActivityoppMap = new Map<id, Opportunity>([Select id, Last_Activity_Date__c From Opportunity Where (Id in :lastActivityWhatIds)]);  
    
     if(lastActivityWhoIds.size() != 0) 
    lastActivityLeadMap = new Map<id, Lead>([Select id, Last_Activity_Date__c From Lead Where (Id in :lastActivityWhoIds)]);  
    
    /*  Start - ******** Lead Onboarding Changes **********  */
    
    //Handle status days fields
    if(updateTaskstatusList.size() != 0){
        Triggerhandler handlerTask = new Triggerhandler();
        handlerTask.handleTaskStatusDays(updateTaskstatusList, Trigger.OldMap.values());
    }
    
    /*  End - ******** Lead Onboarding Changes ********** */
             
    
    if(oppMap != NULL && oppMap.size() != 0)               
    {                       
        System.debug(Logginglevel.DEBUG,'Trigger.new == ' + trigger.new);
        System.debug(Logginglevel.DEBUG,'Trigger.new size== ' + trigger.new.size());
        System.debug(Logginglevel.DEBUG,'what Ids == ' + WhatIds);
        System.debug(Logginglevel.DEBUG,'oppMap  == ' + oppMap);
        System.debug(Logginglevel.DEBUG,'Trigger isUpdate == ' + Trigger.isUpdate);
        System.debug(Logginglevel.DEBUG,'Trigger isInsert == ' + Trigger.isInsert);
        
        mOpportunity = new Map<Id, Opportunity>();
        lOpportunities = new List<Opportunity>();
    }
    for(Task t : Trigger.new)
    {        
        if(t.Status == 'Completed' && oppMap!= NULL )
        {        
            Opportunity opp = oppMap.get(t.WhatId);
            
            if(opp != null) 
            {       
                if(t.Department__c == 'Business Development') 
                {
                    //Conditions 1
                    if(opp.StageName == '1 - Unscreened Contact'
                        && (t.Activity_Type__c == 'BDA' 
                            || t.Activity_Type__c == 'IRD Touch'
                            || t.Activity_Type__c == 'Master Recruiting'
                            || t.Activity_Type__c == 'Recruiting')
                        && (t.Category__c == 'Left Message')
                    )
                    {            
                        opp.StageName = '2 - Contact Initiated';
                        mOpportunity.put(opp.Id, opp);            
                        continue;
                    }
                    
                    //Conditions 2
                    if((opp.StageName == '1 - Unscreened Contact'
                            || opp.StageName == '2 - Contact Initiated')
                        && (t.Activity_Type__c == 'BDA')
                        && (t.Category__c == 'Call-Inbound'
                            || t.Category__c == 'Call-Outbound'
                            || t.Category__c == 'Meeting Set'
                            || t.Category__c == 'Referral to core'
                            || t.Category__c == 'Referral to Masters'
                        )
                    )
                    {
                        opp.StageName = '3 - Discussion';
                        mOpportunity.put(opp.Id, opp);            
                        continue;
                    }
                    
                    //Conditions 3
                    if((opp.StageName == '1 - Unscreened Contact'
                            || opp.StageName == '2 - Contact Initiated')
                        && (t.Activity_Type__c == 'IRD Touch')
                        && (t.Category__c == 'Call-Inbound'
                            || t.Category__c == 'Call-Outbound'
                            || t.Category__c == 'Meeting Set - 10%'
                            || t.Category__c == 'Meeting Set - 20%'
                            || t.Category__c == 'Meeting Set - 30%'
                            || t.Category__c == 'Meeting Set - 50% and above'
                        )
                    )
                    {
                        opp.StageName = '3 - Discussion';
                        mOpportunity.put(opp.Id, opp);            
                        continue;
                    }
                    
                    //Conditions 4
                    if((opp.StageName == '1 - Unscreened Contact'
                            || opp.StageName == '2 - Contact Initiated')
                        && (t.Activity_Type__c == 'Master Recruiting')
                        && (t.Category__c == 'Call-Inbound'
                            || t.Category__c == 'Call-Outbound'                        
                        )
                    )
                    {
                        opp.StageName = '3 - Discussion';
                        mOpportunity.put(opp.Id, opp);            
                        continue;
                    }          
                    
                    //Conditions 5
                    if((opp.StageName == '1 - Unscreened Contact'
                            || opp.StageName == '2 - Contact Initiated')
                        && (t.Activity_Type__c == 'Recruiting')
                        && (t.Category__c == 'Call-Inbound'
                            || t.Category__c == 'Call-Outbound'                        
                        )
                    )
                    {
                        opp.StageName = '3 - Discussion';
                        mOpportunity.put(opp.Id, opp);            
                        continue;
                    }                    
                }    
            }
        }
        
       if( lastActivityoppMap!=null && lastActivityoppMap.size() > 0 ){ 
       
           Opportunity lastActivityopp = lastActivityoppMap.get(t.WhatId); 
           
           
           if(lastActivityopp != null)
           {
               lastActivityopp.Last_Activity_Date__c = System.now();           
               lastActivityoppMap.remove(t.WhatId);           
               lastActivityoppMap.put(lastActivityopp.Id, lastActivityopp);
           
           }
       
       }       
        
        if( lastActivityLeadMap!=null && lastActivityLeadMap.size() > 0){ 
        
           Lead LeadlastActivityLead = lastActivityLeadMap.get(t.WhoId); 
           
           
           if(LeadlastActivityLead  != null){
               LeadlastActivityLead.Last_Activity_Date__c = System.now(); 
               lastActivityLeadMap.remove(t.WhatId);
               lastActivityLeadMap.put(LeadlastActivityLead.Id, LeadlastActivityLead);
           }
       }       
        
    }
    
    if(mOpportunity!= null && mOpportunity.size() > 0){
        lOpportunities = mOpportunity.values();
        System.debug(Logginglevel.DEBUG,'==== updating opporutities ===' + lOpportunities);
        update lOpportunities;
    } 
    
    if(lastActivityoppMap!= null && lastActivityoppMap.size() > 0){
    
          update lastActivityoppMap.values();
    } 
    
    
     if(lastActivityLeadMap!= null && lastActivityLeadMap.size() > 0){
     
          update lastActivityLeadMap.values();
    } 
      
}