/*--------------------------------------------------------------------------------
Description: Assign time trade activities to Lead activities.
History
<Date>           <Authors Name>    <Brief Description of Change>
May-25-2021		 Rinku Yadav	    LBSFNS-31, TimeTrade Appointment to Lead w/ Activity creation in SF. 
------------------------------------------------------------------------------------*/
public class LBS_ProcessTimeTradeActivitiesQueable implements Queueable {
    
    ID LBSPreOpp = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('LBS Pre-Opportunity').getRecordTypeId();
    Integer eventTime = Integer.valueOf(System.Label.LBS_DateTime_for_TT_Event);
    DateTime dt = System.Now().addMinutes(-Integer.valueOf(eventTime));
    public Set<String> leadIdSet;
    
    public LBS_ProcessTimeTradeActivitiesQueable(Set<String> leadIdSet){
        this.leadIdSet = leadIdSet;
    }
	/**
		* Story Ref: LBSFNS-31
		* Method Name: processTimeTradeActivities
		* Description - Method updated timetrade activity with Lead as WHOID.
	**/
	public void execute(QueueableContext context) {
        System.debug('dt*******'+dt);
        set<Id> timeTradeInvitationId = new set<Id>();
        Map<Id,Event> eventMap = new Map<Id,Event>();
        List<String> emailList = new List<String>();
        List<Event> eventUpdateList = new List<Event>();
        
        Map<Id,TimeTrade_SF1__Customer_Attendee__c> customerMap = new Map<Id,TimeTrade_SF1__Customer_Attendee__c>();
		
		List<Event> eventList = [SELECT Id,createddate,whatId,WhoId,OwnerId,subject,TimeTrade_SF1__Invitation__c,TimeTrade_SF1__Meeting__c,StartDateTime,TimeTrade_SF1__Meeting__r.TimeTrade_SF1__Meeting_Status__c 
						         FROM Event 
					             WHERE TimeTrade_SF1__Invitation__c != null AND createddate >=: dt];
		System.debug('eventList*******'+eventList);
		for( Event event : eventList ) {
            timeTradeInvitationId.add(event.TimeTrade_SF1__Invitation__c);
           eventMap.put(event.Id,event);
        }
		
		if( timeTradeInvitationId.size() > 0 ) {
			List<TimeTrade_SF1__Customer_Attendee__c> customerList = [SELECT ID,TimeTrade_SF1__Attendee_Email__c,TimeTrade_SF1__Invitation__r.Id,TimeTrade_SF1__Contact__c,TimeTrade_SF1__Invitation__c
                                                                      FROM TimeTrade_SF1__Customer_Attendee__c 
                                                                      WHERE TimeTrade_SF1__Invitation__c IN :timeTradeInvitationId 
                                                                      AND CreatedDate >=: dt];
			if( customerList != null && customerList.size() >0 ) {
				for( TimeTrade_SF1__Customer_Attendee__c customerAttendee : customerList ) {
                    customerMap.put(customerAttendee.TimeTrade_SF1__Invitation__r.Id,customerAttendee);
                    emailList.add(customerAttendee.TimeTrade_SF1__Attendee_Email__c);
                }
				
				if( eventMap.size() > 0 && emailList.size() > 0 ) {
					List<Lead> leadList = [SELECT Id,Name,Email,OwnerId FROM Lead WHERE Id IN :leadIdSet AND RecordtypeId =: LBSPreOpp AND  Email IN: emailList AND createddate >=: dt];	
					system.debug('#$#$#$#$leadList'+leadList);
                    if( leadList.size() > 0) {
						for( Event eventlead : eventMap.values()) {
							for( Lead lead : leadList ) {
								
                                TimeTrade_SF1__Customer_Attendee__c customer = customerMap.get(eventlead.TimeTrade_SF1__Invitation__c);
                               
                                if( eventlead.TimeTrade_SF1__Invitation__c == customer.TimeTrade_SF1__Invitation__c && lead.Email == customer.TimeTrade_SF1__Attendee_Email__c ) {
                                    //eventlead.Subject = 'Test LBS Email';
                                    eventlead.whatId = null;
                                    eventlead.WhoId = lead.id;
                                    eventUpdateList.add(eventlead);
                                }
                            }
						}
					}
                }
				try {
                    if( eventUpdateList.size() > 0 ) {
                        Database.update(eventUpdateList);
                    }
				} catch ( Exception ex ) {
						System.debug('Exception Occured::' + ex.getTypeName() + 'Message:' +ex.getMessage() + 'LineNumber:' + ex.getLineNumber() +'Cause:' + ex.getCause());
				}
			}
		}	
	}
}