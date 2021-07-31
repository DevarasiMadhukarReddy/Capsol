//MFR007   Opportunity : Campaign records of contacts should tag to Opportunity
trigger CampaignMemberTrigger on CampaignMember (after insert,after update) {

    Map<String,CampaignMember> cmMap = new Map<String,CampaignMember>();
    Set<String> contactIds = new Set<String>();
    Set<String> campaignIds = new Set<String>();
    for(CampaignMember cm : trigger.new){
        cmMap.put(cm.Id, cm);
        contactIds.add(cm.ContactId);
        campaignIds.add(cm.CampaignId);
    }

    Map<String,Contact> contactMap  = new Map<String,Contact>(
        [Select Id,(Select Id From Opportunities__r Where StageName NOT IN ('Closed-Joined','Closed-Lost')) 
        From Contact where Id IN :ContactIds]);
   
    
    Map<String,Campaign> campaignMap  = new Map<String,Campaign>(
        [Select Id,Opportunity__c from Campaign Where Id IN :campaignIds]);
    
    Map<Id,Campaign> camToUpdate  = new Map<Id,Campaign>();
    for(CampaignMember cm : trigger.new){
        if(campaignMap.get(cm.CampaignId) != null && contactMap.get(cm.ContactId) != null 
           && contactMap.get(cm.ContactId).Opportunities__r != null && 
           contactMap.get(cm.ContactId).Opportunities__r.size() > 0){
            Campaign cmp = campaignMap.get(cm.CampaignId);
            cmp.Opportunity__c = contactMap.get(cm.ContactId).Opportunities__r.get(0).Id;
            camToUpdate.put(cmp.id, cmp);
        }
    }
    
    if(camToUpdate.size() > 0){
        Update camToUpdate.values();
    }
}