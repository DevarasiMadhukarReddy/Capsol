/*--------------------------------------------------------------------------------
Utility Class for LBS Business Solutions.
History
<Date>           <Authors Name>        <Brief Description of Change>
May-10-2021		 Indrasen			   Utility Class for LBS Business Solutions. 
------------------------------------------------------------------------------------*/
public class LBS_Utility {

	/**
    * Story Ref: 
	* Method Name: getActiveLBSCampaign
	* Description - Method returns the active LBS Campaign.
	**/
    public static  Map<String,String> getActiveLBSCampaign(){
        Campaign lbsCampaign = new Campaign();
        Map<String,String> campMemberContactMap = new Map<String, String>();
        
        Id lbsPreOppty = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('LBS Marketing Campaign').getRecordTypeId();
        /*
        try{
            lbsCampaign = [Select Id,Name from Campaign Where isActive = true AND RecordTypeId = :lbsPreOppty Order by CreatedDate Desc limit 1];
        }
        catch(QueryException e){
            
        }
        */
        
        for(CampaignMember camMember: [SELECT Id, CampaignId, ContactId, CreatedById, CreatedDate, 
                                       		  FirstRespondedDate,HasResponded, IsDeleted, LastModifiedById, 
                                       		  LastModifiedDate, LeadId, Status, SystemModstamp 
                                         FROM CampaignMember
                                         Where Status = 'Responded' 
                                          AND ContactId != null
                                          AND CampaignId IN (SELECT Id FROM Campaign Where isActive = true AND RecordTypeId = :lbsPreOppty)]){
                                           
        	 campMemberContactMap.put(camMember.ContactId,camMember.CampaignId);                           
         }
        return campMemberContactMap;
    }
}