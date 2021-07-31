/*--------------------------------------------------------------------------------
Description: This class is to create activities for Opportunities that were crated during
Lead converion. This class will be executed from Flow.
History
<Date>           		<Authors Name>        <Brief Description of Change>
May-10-2021		 		Indrasen			  LBSFNS-58 - Lead to Opportunity Conversion.
------------------------------------------------------------------------------------*/
public class LBS_TransferLeadActivitiesV1 {
	
		
		
	public class OppInfoFromFlow{
		
		@invocableVariable public String adminOppId;
		@invocablevariable public String assPlanOppId;
		@invocablevariable public String digOffOppId;
		@invocablevariable public String cfoSolOppId;
		@invocablevariable public String clientEngOppId;
		@invocablevariable public String mktSolOppId;
		@invocablevariable public String leadId;
        
        @invocablevariable public String bookkeeping;
        @invocablevariable public String dealSupport;
        @invocablevariable public String premiumSupport;
        @invocablevariable public String resilience;
        @invocablevariable public String sellerSupport;
        @invocablevariable public String technology;
        @invocablevariable public String contactId;
        
	}
	/**
    * Story Ref: LBSFNS-58
	* Method Name: processLBSActivities
	* Description - This method accepts list of Opportunity IDs from Flow as parameter and 
					creates activities for Opportunities.
	**/
	@InvocableMethod
	public static void processLBSActivities(List<OppInfoFromFlow> inputFromFlow){
		Set<String> oppIdSet = new Set<String>();
		List<Task> insertTaskList = new List<Task>();
		List<Event> insertEventList = new List<Event>();
		String leadContactId='';
        
		try{
			if(String.isNotBlank(inputFromFlow[0].adminOppId)) {
				oppIdSet.add(inputFromFlow[0].adminOppId);
			}
			if(String.isNotBlank(inputFromFlow[0].assPlanOppId)) {
				oppIdSet.add(inputFromFlow[0].assPlanOppId);
			}
			if(String.isNotBlank(inputFromFlow[0].digOffOppId)) {
				oppIdSet.add(inputFromFlow[0].digOffOppId);
			}
			if(String.isNotBlank(inputFromFlow[0].cfoSolOppId)) {
				oppIdSet.add(inputFromFlow[0].cfoSolOppId);
			}
			
			if(String.isNotBlank(inputFromFlow[0].clientEngOppId)) {
				oppIdSet.add(inputFromFlow[0].clientEngOppId);
			}
			
			if(String.isNotBlank(inputFromFlow[0].mktSolOppId)) {
				oppIdSet.add(inputFromFlow[0].mktSolOppId);
			}
            
                   
            if(String.isNotBlank(inputFromFlow[0].bookkeeping)) {
				oppIdSet.add(inputFromFlow[0].bookkeeping);
			}
            
            if(String.isNotBlank(inputFromFlow[0].dealSupport)) {
				oppIdSet.add(inputFromFlow[0].dealSupport);
			}
            
            if(String.isNotBlank(inputFromFlow[0].premiumSupport)) {
				oppIdSet.add(inputFromFlow[0].premiumSupport);
			}
            
            if(String.isNotBlank(inputFromFlow[0].resilience)) {
				oppIdSet.add(inputFromFlow[0].resilience);
			}
            
            if(String.isNotBlank(inputFromFlow[0].sellerSupport)) {
				oppIdSet.add(inputFromFlow[0].sellerSupport);
			}
            
            if(String.isNotBlank(inputFromFlow[0].technology)) {
				oppIdSet.add(inputFromFlow[0].technology);
			}
            if(String.isNotBlank(inputFromFlow[0].contactId)) {
				leadContactId = inputFromFlow[0].contactId;
			}
           
			//Query Lead Tasks and Create Tasks for LBS Opportunities.
			for(Task tsk: [SELECT Id, RecordTypeId, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId, Type FROM Task Where whoid=:inputFromFlow[0].leadId]) {
				System.debug('Task***'+tsk);	
                if(!oppIdSet.isEmpty()){
                       Task task;
                       System.debug('oppIdSet***'+oppIdSet);
						for(String oppId: oppIdSet){
							task = new Task(RecordTypeId=tsk.RecordTypeId,WhoId = leadContactId, WhatId=oppId, Subject=tsk.Subject, ActivityDate=tsk.ActivityDate, Status=tsk.Status, Priority=tsk.Priority, OwnerId=tsk.OwnerId);
                            System.debug('task***'+task);
							insertTaskList.add(task);
                            System.debug('insertTaskList***'+insertTaskList);
						}
					
					}
			}
					
			//Query Lead Events and Create Events for LBS Opportunities.
			for(Event evt: [SELECT Id, RecordTypeId, WhoId, WhatId, Subject, ActivityDateTime, ActivityDate, StartDateTime, EndDateTime, EndDate, Description, OwnerId, Type FROM Event Where WhoId=:inputFromFlow[0].leadId]) {
					if(!oppIdSet.isEmpty()){
						Event event;
                        for(String oppId: oppIdSet){
							event = new Event(RecordTypeId=evt.RecordTypeId, WhoId = leadContactId, WhatId=oppId, Subject=evt.Subject, ActivityDateTime=evt.ActivityDateTime, ActivityDate=evt.ActivityDate, StartDateTime=evt.StartDateTime, EndDateTime=evt.EndDateTime, Description=evt.Description, OwnerId=evt.OwnerId, Type=evt.Type);
							insertEventList.add(event);
						}
					
					}
			}
			
			insert insertTaskList;
			insert insertEventList;            
		}
		
		catch(Exception e){
			LPL_CreateExceptionLog.createErrorRecordAsync('LBS_TransferLeadActivitiesV1','processLBSActivities',e.getMessage(),e.getLineNumber(),e.getTypeName()); 
		}
	}
}