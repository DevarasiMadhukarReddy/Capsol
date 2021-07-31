/*
#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
Ch-1   Fixed an exception error by introducing null check                 Garvita Rai                    16 Jan 2019
        
*/
trigger CampaignMember_Contact_Update on CampaignMember (before insert,before update) {
    
    Set<Id> ContactId = new set<Id>();   
    Map<String,CampaignMember> cmMap = new Map<String,CampaignMember>();
    for(CampaignMember fin : trigger.new){
        ContactId.add(fin.ContactId);        
        if(!(cmMap.containsKey(fin.ContactId)))   
            cmMap.put(fin.ContactId, fin);
    }  
    
    if(ContactId.size() != 0){
        Map<id, Contact> conMap = new Map<id, Contact>([Select Advisory_Segment__c,Advisory_Territory__c From Contact Where (id in :ContactId)]);
        for (CampaignMember CamMem: cmMap.values()){   
            if(CamMem.ContactId!= null && conMap.containsKey(CamMem.ContactId)){ //Ch-1 Added null check for map containing key
                CamMem.Advisory_Segmentation__c = conMap.get(CamMem.ContactId).Advisory_Segment__c;
                CamMem.Advisory_Territory__c = conMap.get(CamMem.ContactId).Advisory_Territory__c;
            }
        } 
    }
    
}