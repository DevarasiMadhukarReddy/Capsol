trigger UpdateCampaignMemberStatus on Campaign (after insert) {
    List<CampaignMemberStatus> newCampaignMemberStatus = new List<CampaignMemberStatus>();
    List<CampaignMemberStatus> oldCampaignMemberStatus = new List<CampaignMemberStatus>();
    Set<String> checkdefaultstatus = new Set<String>();
    Set<Id> removecids = new Set<Id> ();
    
    For (CampaignMemberStatus excms: [Select Id, CampaignId, Label from CampaignMemberStatus where CampaignId IN :trigger.new]){
    checkdefaultstatus.add(excms.CampaignId + excms.Label); 
    }

    for (Campaign c : trigger.new) {
    if(c.RecordTypeId =='012U0000000Z3zx')
    {
        // Add campaign ids to list for removal of campaign member status values
        if (checkdefaultstatus.contains(c.Id + 'Sent')){
        removecids.add(c.id);      
        }
        
         if (!checkdefaultstatus.contains(c.Id + 'Marketing Selected')) {// Add campaign member status for "Marketing Selected"
        newCampaignMemberStatus.add (new CampaignMemberStatus(
        CampaignId=c.id,
        HasResponded=FALSE,
        IsDefault=TRUE,
        Label='Marketing Selected',
        SortOrder=3)); 
        }
                             
          if (!checkdefaultstatus.contains(c.Id + 'Communication Sent')) {// Add campaign member status for "Communication Sent"
        newCampaignMemberStatus.add (new CampaignMemberStatus(
        CampaignId=c.id,
        HasResponded=FALSE,
        IsDefault=FALSE,
        Label='Communication Sent',
        SortOrder=4)); 
        }
    
     if (!checkdefaultstatus.contains(c.Id + 'Cancelled')) {// Add campaign member status for "Cancelled"
            newCampaignMemberStatus.add (new CampaignMemberStatus(
            CampaignId=c.id,
            HasResponded=FALSE,
            IsDefault=FALSE,
            Label='Cancelled',
            SortOrder=5));
            }
    
      if (!checkdefaultstatus.contains(c.Id + 'Attended')) {// Add campaign member status for "Attended"
            newCampaignMemberStatus.add (new CampaignMemberStatus(
            CampaignId=c.id,
            HasResponded=TRUE,
            IsDefault=FALSE,
            Label='Attended',
            SortOrder=6));
            }
    
      if (!checkdefaultstatus.contains(c.Id + 'Responded')) {// Add campaign member status for "Responded"
            newCampaignMemberStatus.add (new CampaignMemberStatus(
            CampaignId=c.id,
            HasResponded=TRUE,
            IsDefault=FALSE,
            Label='Responded',
            SortOrder=7));
            }    
        
        }         
}//end loop
                
    // SOQL query to retrieve the default campaign member status values which will be removed after the new values are inserted.
    oldCampaignMemberStatus = [select cms.id from CampaignMemberStatus cms where cms.CampaignId in :removecids];
    insert newCampaignMemberStatus;
    delete oldCampaignMemberStatus;
} //end trigger