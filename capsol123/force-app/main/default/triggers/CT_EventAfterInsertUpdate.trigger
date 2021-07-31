trigger CT_EventAfterInsertUpdate on Event (after insert, after update) {

    Set<id> WhatIds = new Set<id>();
    
    for(Event e : trigger.new) 
    {
        if(e.whatId != null)
        {       
            if(String.valueOf(e.WhatId).StartsWith('006')) WhatIds.add(e.WhatID);            
        }
    }           
    
    if(WhatIds.size() == 0) return;
    
    Map<id, Opportunity> oppMap = new Map<id, Opportunity>([Select id, Name, StageName From Opportunity Where (Id in :WhatIDs)]);           

    if(oppMap.size() == 0) return;
                           
    System.debug(Logginglevel.DEBUG,'Trigger.new == ' + trigger.new);
    System.debug(Logginglevel.DEBUG,'what Ids == ' + WhatIds);
    
    List<Opportunity> lOpportunities = new List<Opportunity>();
     
    for(Event e : Trigger.new)
    {        
        Opportunity opp = oppMap.get(e.WhatId);
        
        if(opp != null) 
        {       
            if(e.Department__c == 'Business Development') 
            {
                //Conditions 1
                if(opp.StageName == '1 - Unscreened Contact'
                    && (e.Activity_Type__c == 'BDA' 
                        || e.Activity_Type__c == 'IRD Touch'
                        || e.Activity_Type__c == 'Master Recruiting'
                        || e.Activity_Type__c == 'Recruiting')
                    && (e.Category__c == 'Left Message')
                )
                {            
                    opp.StageName = '2 - Contact Initiated';
                    lOpportunities.add(opp);            
                    continue;
                }
                
                //Conditions 2
                if((opp.StageName == '1 - Unscreened Contact'
                        || opp.StageName == '2 - Contact Initiated')
                    && (e.Activity_Type__c == 'BDA')
                    && (e.Category__c == 'Call-Inbound'
                        || e.Category__c == 'Call-Outbound'
                        || e.Category__c == 'Meeting Set'
                        || e.Category__c == 'Referral to core'
                        || e.Category__c == 'Referral to Masters'
                    )
                )
                {
                    opp.StageName = '3 - Discussion';
                    lOpportunities.add(opp);                    
                    continue;
                }
                
                //Conditions 3
                if((opp.StageName == '1 - Unscreened Contact'
                        || opp.StageName == '2 - Contact Initiated')
                    && (e.Activity_Type__c == 'IRD Touch')
                    && (e.Category__c == 'Call-Inbound'
                        || e.Category__c == 'Call-Outbound'
                        || e.Category__c == 'Meeting Set - 10%'
                        || e.Category__c == 'Meeting Set - 20%'
                        || e.Category__c == 'Meeting Set - 30%'
                        || e.Category__c == 'Meeting Set - 50% and above'
                    )
                )
                {
                    opp.StageName = '3 - Discussion';
                    lOpportunities.add(opp);                    
                    continue;
                }
                
                //Conditions 4
                if((opp.StageName == '1 - Unscreened Contact'
                        || opp.StageName == '2 - Contact Initiated')
                    && (e.Activity_Type__c == 'Master Recruiting')
                    && (e.Category__c == 'Call-Inbound'
                        || e.Category__c == 'Call-Outbound'                        
                    )
                )
                {
                    opp.StageName = '3 - Discussion';
                    lOpportunities.add(opp);                    
                    continue;
                }          
                
                //Conditions 5
                if((opp.StageName == '1 - Unscreened Contact'
                        || opp.StageName == '2 - Contact Initiated')
                    && (e.Activity_Type__c == 'Recruiting')
                    && (e.Category__c == 'Call-Inbound'
                        || e.Category__c == 'Call-Outbound'                        
                    )
                )
                {
                    opp.StageName = '3 - Discussion';
                    lOpportunities.add(opp);                    
                    continue;
                }                    
            }    
        }
    }
    
    if(lOpportunities.size() > 0)
    {
        System.debug(Logginglevel.DEBUG,'==== updating opporutities ===' + lOpportunities);
        update lOpportunities;
    }   
}