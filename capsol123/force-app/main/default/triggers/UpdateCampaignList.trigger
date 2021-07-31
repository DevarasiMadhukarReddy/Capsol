//MFR007   Opportunity : Campaign records of contacts should tag to Opportunity
trigger UpdateCampaignList on Opportunity (after insert, after update) {
    Map<string,string> conIDToOpportunityMap = new Map<string,string>();
    Set<String> oppIds = new Set<String>();
    
    for(Opportunity opp : trigger.New)
    {
        if(opp.Contact__C != null && ((trigger.isinsert) || (trigger.isupdate && opp.Contact__C != trigger.oldmap.get(opp.ID).Contact__C ))){
            conIDToOpportunityMap.put(opp.Contact__c,opp.Id);
            oppIds.add(opp.Id);
        }
        
    }
    Map<String,CampaignMember> campaignToMemberMap = new Map<String,CampaignMember>();
    for(CampaignMember camp : [select id,CampaignId,ContactId from CampaignMember where ContactId IN : conIDToOpportunityMap.keySet()]){
        campaignToMemberMap.put(camp.CampaignId, camp);
    }
    
    
    List<Campaign> camps = [Select Id,Opportunity__c from Campaign where Id IN : campaignToMemberMap.keySet() OR Opportunity__c IN :oppIds];
    for(Campaign c : camps){
        if(campaignToMemberMap.get(c.id) != null && conIDToOpportunityMap.get(campaignToMemberMap.get(c.id).ContactId) != null){
            c.opportunity__C = conIDToOpportunityMap.get(campaignToMemberMap.get(c.id).ContactId);    
        }else{
            c.opportunity__C = null;    
        }
    }
    if(camps.size() > 0){
        update camps;
    }
}