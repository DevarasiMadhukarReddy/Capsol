@isTest
public class LPL_TimeTradeReminderEmail_BatchTest {

    public static testMethod void eventEmail(){
        List<string> toAddressesEmailId= new List<string>();
        string fromAddressesEmailId;
        string fromAddressesName;
        User user = new User(
                         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                         LastName = 'InternalTest',
                         Email = 'abcde@gmail.com',
                         Username = 'abcde@gmail.com' + System.currentTimeMillis(),
                         CompanyName = 'TestCompany',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US'
                       );
        insert user; 
       
        Contact con = new Contact();
        con.LastName = 'CustomerTest';
        insert con;
        
        Event event = new Event();
        event.Subject = 'Test Email Template';
        event.OwnerId = user.Id;
        event.startdatetime = datetime.newInstance(2020, 11, 21);
        event.DurationInMinutes = 30;
        insert event;
        
        Datetime dt = (Datetime)event.StartDateTime; 
		Date eventDate = dt.date().addDays(1);
        
        TimeTrade_SF1__Invitation__c invite = new TimeTrade_SF1__Invitation__c();
        invite.Name = event.Subject;
        insert invite;
        
        TimeTrade_SF1__Meeting__c meeting = new TimeTrade_SF1__Meeting__c();
        meeting.TimeTrade_SF1__Event_Id__c = event.Id;
        meeting.TimeTrade_SF1__Invitation__c = invite.Id;
        meeting.TimeTrade_SF1__Scheduled__c = true;
        meeting.TimeTrade_SF1__Meeting_Status__c = 'Scheduled';
        insert meeting;
        
        List<TimeTrade_SF1__Internal_Attendee__c> internalList = new List<TimeTrade_SF1__Internal_Attendee__c>();
        //internal.TimeTrade_SF1__Meeting__c = meeting.Id;
        //internal.TimeTrade_SF1__Organizer__c = true;
        //internal.TimeTrade_SF1__Name__c = user.Id;
        for(TimeTrade_SF1__Internal_Attendee__c internal : internalList){
            internal.TimeTrade_SF1__Meeting__c = meeting.Id;
        	internal.TimeTrade_SF1__Organizer__c = true;
        	internal.TimeTrade_SF1__Name__c = user.Id;
            toAddressesEmailId.add(internal.TimeTrade_SF1__Email__c);
            fromAddressesEmailId = internal.TimeTrade_SF1__Email__c;
			fromAddressesName = internal.TimeTrade_SF1__Name__r.Name;
            internalList.add(internal);
        }
         insert internalList;
        
        List<TimeTrade_SF1__Customer_Attendee__c> customerList = new List<TimeTrade_SF1__Customer_Attendee__c>();
        //customer.TimeTrade_SF1__Contact__c = con.Id;
        //customer.TimeTrade_SF1__Meeting__c = meeting.Id;
        for(TimeTrade_SF1__Customer_Attendee__c customer : customerList){
            customer.TimeTrade_SF1__Contact__c = con.Id;
            customer.TimeTrade_SF1__Meeting__c = meeting.Id;
            toAddressesEmailId.add(customer.TimeTrade_SF1__Attendee_Email__c);
            customerList.add(customer);
        }
        insert customerList;
        
        Event eventData = [SELECT ID,TimeTrade_SF1__Meeting__c
                          FROM Event
                          WHERE subject = 'Test Email Template'];
        eventData.TimeTrade_SF1__Meeting__c = meeting.Id;
        eventData.TimeTrade_SF1__Invitation__c = invite.Id;
        eventData.subject = 'Test TimeTrade Reminder';
        //eventData.startdatetime = eventDate;
        update eventData;
        system.debug('eventdata@@'+eventData);
        
        List<Event> eventList = [SELECT ID,subject,TimeTrade_SF1__Meeting__c,startdatetime,TimeTrade_SF1__Meeting__r.TimeTrade_SF1__Meeting_Status__c
                                 FROM Event
                                 WHERE subject = 'Test TimeTrade Reminder' and startdatetime > today];
        
        EmailTemplate emailTemplate = [SELECT Id,Name,Subject,Description,HtmlValue,DeveloperName,Body 
									   FROM EmailTemplate 
									   WHERE Name = 'TimeTrade Meeting Reminder'];  
         ID templateId = emailTemplate.Id;
        system.debug('eventList'+eventList);
         Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(templateId,con.id,eventData.id);
         			/*message.setTargetObjectId(con.id);
         			message.setSenderDisplayName(fromAddressesName); 
                    message.setReplyTo(fromAddressesEmailId);
                    message.setUseSignature(false); 
                    message.setBccSender(false); 
                    message.setSaveAsActivity(false);
                    message.toAddresses = toAddressesEmailId;
                    messaging.Email[] emails = new messaging.Email[]{message};
                    messaging.sendEmail(emails);*/
         test.startTest();
         LPL_TimeTradeReminderEmail_Scheduler batchjob =new LPL_TimeTradeReminderEmail_Scheduler();
         String cron = '0 0 23 * * ?';  
         String jobid = System.schedule('LPL_TimeTradeReminderEmail_Batch',cron,batchjob);
         test.stopTest();
    }
}