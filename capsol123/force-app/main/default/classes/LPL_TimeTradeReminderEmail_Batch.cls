/*
         * @Method Name    : timeTradeEmail
         * @date           : 20 November, 2020
         * @description    : This batch is written to send Email for TimeTrade Meeting Reminder
 */
global class LPL_TimeTradeReminderEmail_Batch implements Database.Batchable<sObject>,Database.Stateful {
    public integer count = 0;
	global Database.QueryLocator start( Database.BatchableContext BC ) {
        //Id lplAdvisorId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        String scheduled = 'Scheduled';
        //DateTime meetingDate = dateTime.today().addDays(1);
        String query = 'SELECT Id, TimeTrade_SF1__Meeting__c,StartDateTime,TimeTrade_SF1__Meeting__r.TimeTrade_SF1__Meeting_Status__c FROM Event WHERE TimeTrade_SF1__Meeting__c != null AND TimeTrade_SF1__Meeting__r.TimeTrade_SF1__Meeting_Status__c =: scheduled AND StartDateTime > today';
        return database.getQueryLocator(query);
    }

    global void execute( Database.BatchableContext BC , List<Event> eventList ){
        List<Event> eventUpdateList =new List<Event>();
        Set<Id> timetrademeetingId = new Set<Id>();
        Date meetingDate = date.today().addDays(1);
        List<Id> EventID = new List<Id>();
        List<string> toAddressesEmailId= new List<string>();
        string fromAddressesEmailId;
        string fromAddressesName;
        
        for(Event eve : eventList)
        {
            Datetime dt = (Datetime)eve.StartDateTime; 
			Date eventDate = dt.date();
            system.debug('Event Date'+eventDate);
            system.debug('Meeting date'+meetingDate);
            if(eventDate == meetingDate)
            {
                 EventID.add(eve.id);
            }
         }
        if(EventID != null)
        {
            List<TimeTrade_SF1__Meeting__c> meetingList = [SELECT id,TimeTrade_SF1__Event_Id__c 
			                                               FROM TimeTrade_SF1__Meeting__c  
														   WHERE TimeTrade_SF1__Event_Id__c IN: EventID];
         	if(meetingList != null && meetingList.size()>0)
            {
                for(TimeTrade_SF1__Meeting__c meeting : meetingList)
                {
                    timetrademeetingId.add(meeting.id);
                } 
             }
            	
            if(timetrademeetingId != null)
            {
				List<TimeTrade_SF1__Internal_Attendee__c> internalList = [SELECT id,TimeTrade_SF1__Meeting__c,TimeTrade_SF1__Meeting__r.TimeTrade_SF1__Event_Id__c,TimeTrade_SF1__Email__c,
                                                                         TimeTrade_SF1__Invitation__c,TimeTrade_SF1__Name__r.name,TimeTrade_SF1__Organizer__c,TimeTrade_SF1__Name__c
                                                                         FROM TimeTrade_SF1__Internal_Attendee__c
                                                                         WHERE TimeTrade_SF1__Meeting__c IN: timetrademeetingId];
				List<TimeTrade_SF1__Customer_Attendee__c> customerList = [SELECT ID,TimeTrade_SF1__Attendee_Email__c,TimeTrade_SF1__Contact__c,TimeTrade_SF1__Invitation__c
																		  FROM TimeTrade_SF1__Customer_Attendee__c 
																		  WHERE TimeTrade_SF1__Meeting__c IN: timetrademeetingId]; 
            if(internalList.size()>0 && customerList.size()>0)
			{
					system.debug('@@@@@@@'+internalList);
                system.debug('@@$$$$$$$$'+customerList);
				for(TimeTrade_SF1__Customer_Attendee__c customer: customerList )
                {
                    toAddressesEmailId.add(customer.TimeTrade_SF1__Attendee_Email__c);
                }
				for(TimeTrade_SF1__Internal_Attendee__c internal: internalList )
				{
                	toAddressesEmailId.add(internal.TimeTrade_SF1__Email__c);
					if(internal.TimeTrade_SF1__Organizer__c = true){
					fromAddressesEmailId = internal.TimeTrade_SF1__Email__c;
					fromAddressesName = internal.TimeTrade_SF1__Name__r.Name;
                   
					}
				}
                system.debug('$$$$$$fromAddressesEmailId'+fromAddressesEmailId);
                system.debug('$$$$fromAddressesName'+fromAddressesName);
				
                EmailTemplate emailTemplate = [SELECT Id,Name,Subject,Description,HtmlValue,DeveloperName,Body 
										       FROM EmailTemplate 
										       WHERE Name = 'TimeTrade Meeting Reminder'];  
            	ID templateId = emailTemplate.Id;       
            
                for(Event tm : [select id,whoId,OwnerId,subject from event where id in:EventID])
                {
                    Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(templateId,tm.WhoId,tm.Id);
                    message.setTargetObjectId(tm.OwnerId);
                    message.setSenderDisplayName(fromAddressesName); 
                    message.setReplyTo(fromAddressesEmailId);
                    message.setUseSignature(false); 
                    message.setBccSender(false); 
                    message.setSaveAsActivity(false);
                    message.toAddresses = toAddressesEmailId;
                    messaging.Email[] emails = new messaging.Email[]{message};
                    messaging.sendEmail(emails);
                 }
			  }
          }
       }
       try{
      		database.saveresult[] ds =  Database.update(eventList,false);
    			for(database.SaveResult d : ds)
                {
        			if(d.issuccess())
                    {
                        System.debug('Email Send successfullt to Event ID: ' + d.getId());
            		    count++;
        		    }
        
    		   }
		}
        catch(exception e){
        	system.debug('update failed');
        }
        
   }
   
    global void finish( Database.BatchableContext BC ) {
     	system.debug(count);
        //Send an email to the User after your batch completes
        /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'rinku.yadav@lpl.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Apex Job is Completed');
        mail.setPlainTextBody('Total' +'  '+ count +'  '+ 'Records updated sucessfully');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
        }
}