/*
Trigger Name            :OpportunityHandler_Test
Description             :Test Class for OpportunityHandler

Developer Name          : 
Created Date            : 

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01        Commentted unwanted account to delete             Sai Kethu        06/15/2017
             unneccessary fields    

*/

@isTest(seeAllData = false)
public class OpportunityHandler_Test{

    @testSetup static void testData(){
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
            insert r;
        
        User u = new User(
                         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                         LastName = 'last',
                         Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         UserRoleId = r.Id
                    );
        insert u;
     }
    
    static testMethod void test1(){
        //Create User 
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.Name = 'Contact';
        tbp.IsOff__c = false;
        insert tbp;
        
        List<IAS_Recruiter_Assignment__c> iasList = new List<IAS_Recruiter_Assignment__c>();
        //Creat IAS Recruiter data
        IAS_Recruiter_Assignment__c ias
          = new IAS_Recruiter_Assignment__c(Regional_VP__c = UserInfo.getUserId()
                                          , Lead_Type__c = 'Core'
                                          , name = 'C80538'
                                          , Internal_Recruiter__c = UserInfo.getUserId()
                                          , GDC_Minimum__c = 0
                                          , GDC_Maximum__c = 1000
                                          , External_Id__c  = 'XXX'
                                          , Assigned_Recruiter__c = UserInfo.getUserId());
        iasList.add(ias);
        
        IAS_Recruiter_Assignment__c ias2
          = new IAS_Recruiter_Assignment__c(Regional_VP__c = UserInfo.getUserId()
                                          , Lead_Type__c = 'Master'
                                          , name = 'M80538'
                                          , Internal_Recruiter__c = UserInfo.getUserId()
                                          , GDC_Minimum__c = 1001
                                          , GDC_Maximum__c = 2000
                                          , External_Id__c  = 'YYY'
                                          , Assigned_Recruiter__c = UserInfo.getUserId());
        iasList.add(ias2);
        
        IAS_Recruiter_Assignment__c ias3
          = new IAS_Recruiter_Assignment__c(Regional_VP__c = UserInfo.getUserId()
                                          , Lead_Type__c = 'Master'
                                          , name = '80538'
                                          , Internal_Recruiter__c = UserInfo.getUserId()
                                          , GDC_Minimum__c = 1001
                                          , GDC_Maximum__c = 2000
                                          , External_Id__c  = 'YYX'
                                          , Assigned_Recruiter__c = UserInfo.getUserId());
        iasList.add(ias3);
        
        insert iasList;
        
        //Add the Account and opportunity executing the opportunity trigger that uses the syncWithIASRecruiterAssignment method
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
         List<Opportunity>     oppInsert = new List<Opportunity>();
         
         
        Opportunity op1 = new Opportunity(AccountId = a1.id
                                        , name = 'Test opportunity'
                                        , CloseDate =  system.today()
                                        , StageName = '1 - Unscreened Contact'
                                        , Zip_Code__c = '80538'
                                        , GDC_Prior_12_mo__c = 200);
        oppInsert.add(op1);
        
        Opportunity op2 = new Opportunity(AccountId = a1.id
                                        , name = 'Test opportunity'
                                        , CloseDate =  system.today()
                                        , StageName = '1 - Unscreened Contact'
                                        , GDC_Prior_12_mo__c = 200);
        oppInsert.add(op2);
        
        RecordType rt = [Select Id from recordType where SobjectType = 'Opportunity' and DeveloperName = 'IAS_Business_Development' ];
        
        Opportunity op3 = new Opportunity(AccountId = a1.id
                                        , name = 'Test opportunity'
                                        , CloseDate =  system.today()
                                        , StageName = '1 - Unscreened Contact'
                                        , Zip_Code__c = '80538'
                                        , GDC_Prior_12_mo__c = 4000);
        oppInsert.add(op3);
        
        Opportunity op4 = new Opportunity(AccountId = a1.id
                                        , name = 'Test opportunity'
                                        , CloseDate =  system.today()
                                        , StageName = '1 - Unscreened Contact'
                                        , Zip_Code__c = '80538'
                                        , GDC_Prior_12_mo__c = -4000
                                        , Regional_Transition_Partner__c = UserInfo.getUserId()
                                        , Investment_Transition_Consultant__c = UserInfo.getUserId()
                                        , Transition_Support_Partners__c  = UserInfo.getUserId()
                                        , Integration_Manager__c = UserInfo.getUserId());
        oppInsert.add(op4);
        
        insert oppInsert;
        
        Opportunity opp = [select id, Regional_Transition_Partner__c, Transition_Support_Partners__c,Integration_Manager__c , Investment_Transition_Consultant__c  from opportunity where name = 'Test opportunity' and Regional_Transition_Partner__c != null limit 1 ];
        
        List<Task> tskList = [select id, OwnerId  from Task where WhatID =: opp.id];
   //     system.assertEquals(tskList[0].OwnerId, UserInfo.getUserId() );
        
        User user = [select id from User where email = 'puser000@amamama.com' limit 1];
        
        opp.Regional_Transition_Partner__c = user.ID;
        opp.Investment_Transition_Consultant__c = user.ID;
        opp.Transition_Support_Partners__c  = user.ID;
        opp.Integration_Manager__c = user.ID;
        update opp;
        
    }
    
    static testMethod void test2(){
        Test.startTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.Name = 'Contact';
        tbp.IsOff__c = false;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
               
        Opportunity op1 = new Opportunity(AccountId = a1.id
                                        , name = 'Test opportunity'
                                        , CloseDate =  system.today()
                                        , StageName = '1 - Unscreened Contact'
                                        , Zip_Code__c = '80538'
                                        , GDC_Prior_12_mo__c = 200
                                        , GRC_Status__c = 'Reject to Registrations'
                                        , OBA_Pending_Prospect_Docusign_Sent_Entry__c = System.today()
                                        , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                        , Kit_Reject_to_Registrations_Entry__c = system.today());  
        insert op1;
        
        Opportunity Op11 = [select id, OBA_Pending_Prospect_Docusign_Sent_Entry__c,Kit_Reject_to_Registrations_Entry__c 
                                ,OBA_Pending_Prospect_Docusign_Sent_Exit__c,Kit_Reject_to_Registrations_Exit__c  
                                from Opportunity where id= : op1.id limit 1];
        
        system.assertEquals(Op11.OBA_Pending_Prospect_Docusign_Sent_Entry__c, System.today());
        system.assertEquals(Op11.OBA_Pending_Prospect_Docusign_Sent_Exit__c, null);
        system.assertEquals(Op11.Kit_Reject_to_Registrations_Exit__c , null);
        
        
        
        
        Op1.GRC_Status__c = 'Withdrawn';
        Op1.Review_Status__c = 'Pending NCO – Call Requested';
        update op1;
        
        /*Opportunity Op12 = [select id, OBA_Pending_Prospect_Docusign_Sent_Entry__c,Kit_Reject_to_Registrations_Entry__c 
                                ,OBA_Pending_Prospect_Docusign_Sent_Exit__c,Kit_Reject_to_Registrations_Exit__c
                                from Opportunity where id= : op1.id limit 1];
        
        system.assertEquals(Op12.OBA_Pending_Prospect_Docusign_Sent_Exit__c, System.Today());
        system.assertEquals(Op12.Kit_Reject_to_Registrations_Exit__c , System.Today());*/

        Op1.GRC_Status__c = 'Assigned to GRC Analyst';
        Op1.Review_Status__c = 'Withdrawn';
        update op1;
        
        Op1.GRC_Status__c = 'Assigned Resubmit to GRC Analyst';
        Op1.Review_Status__c = 'OBA Review Completed';
        update op1;
        
        Op1.GRC_Status__c = 'Pending GRC - More Info Received';
        Op1.Review_Status__c = 'Pending OBA Committee';
        update op1;
        
        Op1.GRC_Status__c = 'GRC Escalated';
        Op1.Review_Status__c = 'Call Completed';
        update op1;
        
        Test.stopTest();
    }

}