/*--------------------------------------------------------------------------------
This class holds the method implemenaitons for the Base class LeadController.
History
<Date>           		<Authors Name>        <Brief Description of Change>
APR-24-2021		 		Indrasen			   LBSFNS-29 - WEB FORM To Lead.

Change Details:
CH-1/May-10-2021        Indrasen			   Assigned Active Campaing ID.
CH-2/May-26-2021        Rinku                  LBSFNS-31-Added the enqueue job.
------------------------------------------------------------------------------------*/

public class LBS_LeadControllerHandler{
	
    /**
    * Story Ref: LBSFNS-29
	* Method Name: createLead
	* Description - This method accepts list of Contacts as parameter and creates LBS Lead for each Contact.
	**/
	public static void createLead(List<Contact> contList){
		Lead lead;
		List<Lead> newLeadList = new List<Lead>();
        Set<String> leadIDSet = new Set<String>();
        Id lbsPreOppty = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('LBS Pre-Opportunity').getRecordTypeId();
		AssignmentRule leadAssignmentRule = new AssignmentRule();
		/*leadAssignmentRule = [select Id from AssignmentRule 
               Where SobjectType = 'Lead' 
                 AND Active = true 
                 AND Name = 'LBS Lead Assignment' limit 1]; */
        
        //new assignment rule created as part of LBSFNS - 493
        leadAssignmentRule = [select Id from AssignmentRule 
                              Where SobjectType = 'Lead' 
                              AND Active = true 
                              /*AND Name = 'LBS Lead Assignment Rules' */limit 1];

		//Creating the DMLOptions for "Assign using active assignment rules" checkbox
		Database.DMLOptions dmlOpts = new Database.DMLOptions();
		dmlOpts.assignmentRuleHeader.assignmentRuleId= leadAssignmentRule.id;
		dmlOpts.EmailHeader.triggerAutoResponseEmail = true; 
        Map<String, String> comapignContactMap = LBS_Utility.getActiveLBSCampaign();
        try{
			for(Contact ct: contList){
				lead = new Lead(LBS_Assurance__c = ct.LBS_Assurance__c,
                                LBS_Admin__c = ct.LBS_Admin__c,
                                LBS_Marketing_Solutions__c = ct.LBS_Marketing_Solutions__c,
                                LBS_CFO_Solutions__c = ct.LBS_CFO_Solutions__c,
                                LBS_Client_Engage__c = ct.LBS_Client_Engage__c,
                                
                                // added for LBSFNS - 448 : Sprint 9 : Lead product set enhancement
                                // //LBS_Digital_Office__c = ct.LBS_Digital_Office__c,
                                LBS_Bookkeeping__c = ct.LBS_Bookkeeping__c,
                                LBS_Premium_Buyer__c = ct.LBS_Premium_Buyer__c,
                                LBS_Valuation__c = ct.LBS_Valuation__c,
                                LBS_Resilience__c = ct.LBS_Resilience__c,
                                LBS_Deal_Support__c = ct.LBS_Deal_Support__c,
                                LBS_Seller_Support__c = ct.LBS_Seller_Support__c,
                                LBS_Technology__c = ct.LBS_Technology__c,
                                // end of LBSFNS - 448 : Sprint 9 : Lead product set enhancement
                                
                                Contact__c = ct.Id,
                                LeadSource = 'LBS Website Lead',
                                FirstName= ct.FirstName,
                                LastName= ct.LastName,
                                Email = ct.Email,
                                State = ct.MailingState,
                                Phone = ct.Phone,
                                RecordTypeId = lbsPreOppty,
                                //pi__campaign__c = ct.pi__campaign__c
                                LBS_Campaign__c = comapignContactMap.containsKey(ct.Id) ? comapignContactMap.get(ct.Id) : null
                                );
                lead.setOptions(dmlOpts);
				newLeadList.add(lead);
                system.debug(' newLeadList '+newLeadList);
			}	
			List<Database.upsertResult> upsertResults = Database.upsert(newLeadList, false);
			for(Database.upsertResult result: upsertResults){
                system.debug(' result '+result);
				if(result.isSuccess() && result.isCreated()){
					//Update Contact.
				     leadIDSet.add((String)result.getId());
				}
			
            }
            /*******CH-2********/
            ID jobID = System.enqueueJob(new LBS_ProcessTimeTradeActivitiesQueable(leadIDSet));
		}
		Catch(Exception e){
			LPL_CreateExceptionLog.createErrorRecordAsync('LBS_LeadControllerHandler','createLead',e.getMessage(),e.getLineNumber(),e.getTypeName()); 
        }
        
       
        
        
	}
}