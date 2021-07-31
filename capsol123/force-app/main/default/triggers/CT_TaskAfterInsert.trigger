trigger CT_TaskAfterInsert on Task (after insert) {    
    
    system.debug('*****Trigger execution starts');

    Set<id> WhatIds = new Set<id>();
    Set<id> conWhoIds= new Set<id>();
    
    Map<Id, Contact> conMap = new Map<Id, Contact>();
    Map<Id, Group> groupMap = new Map<Id, Group>();
    List<String> emailIds = new List<String>();
    
    for(Task t : trigger.new) 
    {
        system.debug('*****Trigger execution starts in for loop');
        if(t.Subject == 'Apex')
        {  
            if(t.whatId != null)
            {
                if(String.valueOf(t.WhatId).StartsWith('006')) WhatIds.add(t.WhatID);
            }
        }
        
        if(t.whoId!= null && String.valueOf(t.whoId).StartsWith('003'))
        {
            conWhoIds.add(t.whoId);
            system.debug('******Collecting contacts'+conWhoIds);
        }
            
    }           
    
    if(WhatIds.size() == 0) {
        if(conWhoIds.size() != 0) {
            emailAlert();
        }
     return;   
    }
    
    Map<id, Opportunity> oppMap = new Map<id, Opportunity>([Select id, apex__c From Opportunity Where (Id in :WhatIDs)]);           
    
    if(oppMap.size() == 0) return;               
                           
    Map<Id, Opportunity> mOpportunity = new Map<Id, Opportunity>();
    List<Opportunity> lOpportunities = new List<Opportunity>();
    
    for(Task t : Trigger.new)
    {        
          
            Opportunity opp = oppMap.get(t.WhatId);
            
            if(opp != null) 
            {       
                opp.apex__c = true;
                mOpportunity.put(opp.Id, opp);      
            }
        
    }
    
    if(mOpportunity.size() > 0)
    {
        lOpportunities = mOpportunity.values();
        System.debug(Logginglevel.DEBUG,'==== updating opporutities ===' + lOpportunities);
        update lOpportunities;
    }
    
    
    //Cehck the Email sent to Advisor is sent or Not
    public void emailAlert() {
    Group grp1;
    system.debug('******Contact is valid*********');
    if(conWhoIds.size() > 0) {
    system.debug('******Contact is valid');
        //groupMap = new Map<Id, Group>([Select Id, Name From Group Where DeveloperName = 'LPL_Log_a_Call_Advisor_Group']);
        
        grp1 = [Select Id, Name From Group Where DeveloperName = 'LPL_Log_a_Call_Advisor_Group' limit 1];
        system.debug('Group Members'+groupMap );
        conMap = new Map<Id, Contact>([Select Id, Lpl_Attachment_Sent__c,Lpl_Attachment_Sent_Date__c, Email  From Contact Where (Id in :conWhoIds)]);   
        system.debug('GContact Members'+conMap);
    }   
    Set<Id> userGroupIds = GetUserIdsFromGroup(grp1.Id);
    ID userID = UserInfo.getUserId();
    Integer countDays;
    boolean executeUpdate = false;
    
    for(Task newTaskObj : Trigger.new) {
        if(conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent_Date__c != null) {
        system.debug('******date is Present');
            countDays = conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent_Date__c.daysBetween(System.Today());
        }
        
        if(userGroupIds.contains(userID)) {
            if(conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent__c == false ) {
               conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent__c = true; 
               conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent_Date__c = System.Today();
               executeUpdate = true;
            } else if(conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent__c == true && countDays > 90 ) {
               conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent_Date__c = System.Today();
               executeUpdate = true;
            }
        }
    }
    
    if(conMap.size() != 0 && executeUpdate == true) {
        update conMap.values();
    }
    
    }
    
    public static Set<id> GetUserIdsFromGroup(Id groupId)
    {
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        
        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :groupId])
        {
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType))
            {
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            // Note: there may be a problem with governor limits if this is called too many times
            else if (((String)m.UserOrGroupId).startsWith(groupType))
            {
                // Call this function again but pass in the group found within this group
                result.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
            }
        }
        
        return result;  
    }
   
    
}