/*
Class Name              : LBS_ProcessTimeTradeActivitiesQueable
Description             : Test Class for LBS_ProcessTimeTradeActivitiesQueable
Developer Name          : Rinku Yadav
Created Date            : 07/20/2021

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------

*/
@isTest(seeAllData = false)
public class LBS_ProcessTimeTradeActivitiesTest {
    public static ID LBSPreOpp = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('LBS Pre-Opportunity').getRecordTypeId();
    static testMethod void test1(){
        Integer eventTime = Integer.valueOf(System.Label.LBS_DateTime_for_TT_Event);
    	DateTime dt = System.Now().addMinutes(-Integer.valueOf(eventTime));
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
        
        Contact ct = new Contact(LastName = 'TestLeadTime', LBS_Admin__c = true,email ='abcde@gmail.com');
        insert ct;
       
        Lead lead = new Lead();
        lead.FirstName = 'Test Class';
        lead.LastName = 'LBS';
        lead.Email = 'abcde@gmail.com';
        lead.RecordTypeId = LBSPreOpp;
        insert lead;
        
        List<lead> leadList1 = new List<Lead>();
        leadList1.add(lead);
        update LeadList1;
        
        Lead leadList = [SELECT id,Contact__c,LBS_Admin__c FROM Lead WHERE lastname = 'LBS'];
        leadList.Contact__c = ct.Id;
        leadList.LBS_Admin__c = ct.LBS_Admin__c;
        Update leadList;
        
        set<string> LeadId = new set<string>();
        LeadId.add(leadList.id);
      
        TimeTrade_SF1__Invitation__c invitation = new TimeTrade_SF1__Invitation__c(name = 'Test Class LBS');
        insert invitation;
        
        TimeTrade_SF1__Meeting__c meeting = new TimeTrade_SF1__Meeting__c();
        meeting.TimeTrade_SF1__Invitation__c = invitation.Id;
        meeting.TimeTrade_SF1__Scheduled__c = true;
        insert meeting;
        
        Event event = new Event(subject = invitation.name, TimeTrade_SF1__Invitation__c = invitation.Id, 
                                startdatetime = system.today(), DurationInMinutes = 30,createddate = dt,
                                ownerID = user.Id);        
        insert event;
        
        Datetime dateModify = Datetime.now().addMinutes(1);
        Test.setCreatedDate(event.Id, dateModify);
        
        set<Id> timeTradeInvitationId = new set<Id>();
        timeTradeInvitationId.add(event.TimeTrade_SF1__Invitation__c);
        
        Contact con = [select id from contact where lastname = 'TestLeadTime'];
        TimeTrade_SF1__Customer_Attendee__c customer = new TimeTrade_SF1__Customer_Attendee__c();
        customer.TimeTrade_SF1__Invitation__c = invitation.Id;
        customer.TimeTrade_SF1__Attendee_Email__c = 'abcde@gmail.com';
        customer.TimeTrade_SF1__Contact__c = con.Id;
        customer.TimeTrade_SF1__Meeting__c = meeting.Id;
        customer.CreatedDate = dt;
        insert customer;
        
        Test.setCreatedDate(customer.Id, dateModify);
        
        List<TimeTrade_SF1__Customer_Attendee__c> customerList = [SELECT ID,TimeTrade_SF1__Attendee_Email__c,TimeTrade_SF1__Invitation__r.Id,TimeTrade_SF1__Contact__c,TimeTrade_SF1__Invitation__c
                                                                  FROM TimeTrade_SF1__Customer_Attendee__c 
                                                                  WHERE TimeTrade_SF1__Invitation__c IN :timeTradeInvitationId 
                                                                  AND CreatedDate =: dt];
        
        test.startTest();
        system.enqueueJob(new LBS_ProcessTimeTradeActivitiesQueable(LeadId));
        test.stopTest();
    }
}