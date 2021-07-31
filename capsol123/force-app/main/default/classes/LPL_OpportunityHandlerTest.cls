/*
Trigger Name            :LPL_OpportunityTrigger
Description             :Test Class for LPL_OpportunityTriggerGateway

Developer Name          : Manila Agnihotri 
Created Date            : 10/8/2018 

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01        Commentted unwanted account to delete             Sai Kethu        06/15/2017
unneccessary fields    

CH-02       Create six Tasks for the user when it is           Pravin Kale        08/22/2017
selected in On boarding Technology Consultant
field in the Opportunity record 

CH-03      For Contract Accommodation:         
User Story Desc: Getting a Task created From Opportunity      Utkarsh Topre   10/12/2017
and assigned to Opportunity IRD.
Criteria :
Opportunity'sInternal_Recruiter_IRD__c is not null && 
Opportunity's StageName equals '3 - Submitted a Kit' 
and Opportunity's approved expected aum >0 && 
Opportunity's Channel Owner equals 'IAS' && Acquisition not
equals'Jaguar'then task should be created.  

CH-04   Created cases, those are connected with Opportunity and filled               Ashish Gupta     03-Oct-2018
data MAX_TA_Dollars_Allowed__c and TAT fields of Opportunity 
*/

@isTest(seeAllData = false)
public class LPL_OpportunityHandlerTest{
    
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
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        //Add the Account and opportunity executing the opportunity trigger that uses the syncWithIASRecruiterAssignment method
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        List<Opportunity>     oppInsert = new List<Opportunity>();
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200);
        oppInsert.add(op1);
        
        Opportunity op2 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , GDC_Prior_12_mo__c = 200);
        oppInsert.add(op2);
        RecordType rt = [Select Id from recordType where SobjectType = 'Opportunity' and DeveloperName = 'IAS_Business_Development' ];
        
        Opportunity op3 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 4000);
        oppInsert.add(op3);
        
        Opportunity op4 = new Opportunity(AccountId = a1.id, name = 'Test opportunity1'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = -4000
                                          , Regional_Transition_Partner__c = UserInfo.getUserId()
                                          , Investment_Transition_Consultant__c = UserInfo.getUserId()
                                          , Transition_Support_Partners__c  = UserInfo.getUserId()
                                          , Integration_Manager__c = UserInfo.getUserId());
        oppInsert.add(op4);
        
        insert oppInsert;
        
        Opportunity opp = [select id, Regional_Transition_Partner__c, Transition_Support_Partners__c,Integration_Manager__c , Investment_Transition_Consultant__c  from opportunity where name =: 'Test opportunity1' and Regional_Transition_Partner__c != null limit 1 ];
        
        List<Task> tskList = [select id, OwnerId  from Task where WhatID =: opp.id];
    //    system.assertEquals(tskList[0].OwnerId, UserInfo.getUserId() );
        User user = [select id from User where email = 'puser000@amamama.com' limit 1];
        opp.Regional_Transition_Partner__c = user.ID;
        opp.Investment_Transition_Consultant__c = user.ID;
        opp.Transition_Support_Partners__c  = user.ID;
        opp.Integration_Manager__c = user.ID;
        update opp;
        
        // Start Commented by Amol 4/17
       // Opportunity opp1 = [select id, Regional_Transition_Partner__c, Transition_Support_Partners__c  from opportunity where name = 'Test opportunity1' and Transition_Support_Partners__c != null limit 1 ];
        // List<Task> tskList1 = [select id, OwnerId from Task where WhatID =: opp1.id];
        // End Commented by Amol 4/17
    }
    
    static testMethod void test2(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                          ,Revenue_Verification_Status__c='More Info Received');
        
        insert op1;
        
        Opportunity Op11 = [select id, OBA_Pending_Prospect_Docusign_Sent_Entry__c,Kit_Reject_to_Registrations_Entry__c 
                            ,OBA_Pending_Prospect_Docusign_Sent_Exit__c,Kit_Reject_to_Registrations_Exit__c  
                            from Opportunity where id= : op1.id limit 1];
        
        system.assertEquals(Op11.OBA_Pending_Prospect_Docusign_Sent_Exit__c, null);
        system.assertEquals(Op11.Kit_Reject_to_Registrations_Exit__c , null);
        
        Op1.GRC_Status__c = 'Withdrawn';
        Op1.Review_Status__c = 'Pending NCO – Call Requested';
        Op1.StageName = '4 - Meeting';
        Op1.Revenue_Verification_Status__c='Revenue Submitted';
        Op1.Revenue_Verification_Status__c ='Revenue Approved'; 
        update op1;
        
        Opportunity op3 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                          ,Revenue_Verification_Status__c='More Info Received');
        
        insert op3;
        
        Opportunity Op13 = [select id, OBA_Pending_Prospect_Docusign_Sent_Entry__c,Kit_Reject_to_Registrations_Entry__c 
                            ,OBA_Pending_Prospect_Docusign_Sent_Exit__c,Kit_Reject_to_Registrations_Exit__c  
                            from Opportunity where id= : op3.id limit 1];
        
        Op13.Revenue_Verification_Status__c='Revenue Submitted';
        
        update op13;
        
        //Start Commented by Amol 4/17
      //  Opportunity Op12 = [select id, OBA_Pending_Prospect_Docusign_Sent_Entry__c,Kit_Reject_to_Registrations_Entry__c 
                   //         ,OBA_Pending_Prospect_Docusign_Sent_Exit__c,Kit_Reject_to_Registrations_Exit__c
                     //       from Opportunity where id= : op1.id limit 1];
        // End Commented by Amol 4/17
        
    //    system.assertEquals(Op12.OBA_Pending_Prospect_Docusign_Sent_Exit__c, System.Today());
     //   system.assertEquals(Op12.Kit_Reject_to_Registrations_Exit__c , System.Today());
        Test.startTest();
        
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
    
    static testMethod void test4(){
        Schema.DescribeSObjectResult oppRecDesc = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> rtMapByName = oppRecDesc.getRecordTypeInfosByName();
        
        Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
        Map<ID,Schema.RecordTypeInfo> rt_MapCon = Contact.sObjectType.getDescribe().getRecordTypeInfosById();
        
        ID oppRIAID = rtMapByName.get('RIA Compliance ADVantage').getRecordTypeId();
        ID oppInsuranceID = rtMapByName.get('AIS Insurance Sales').getRecordTypeId();
        Id IASBD = rtMapByName.get('IAS Business Development').getRecordTypeId();  
        
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',WMO_Division__c='East',LastName = 'Test', AccountID = a1.Id, Insurance_Territory__c = 'Test', Master_Rep_ID__c = '002D' );
        Insert Con;
        
        Contact con2 = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',WMO_Division__c='East',LastName = 'Test2', AccountID = a1.Id, Insurance_Territory__c = 'Test2');
        Insert Con2;
        User user = [select id from User where email = 'puser000@amamama.com' limit 1];
        
        LPL_Insurance_Associates__c lplIA = new LPL_Insurance_Associates__c(Name = '002D', Contact__c = con.ID);
        insert lplIA;
        
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538' , GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                          , Regional_Transition_Partner__c = user.ID
                                          , Investment_Transition_Consultant__c = user.ID
                                          , Transition_Support_Partners__c  = user.ID
                                          , Integration_Manager__c = user.ID
                                          , Contact__C = con.ID, LPL_Region__c = 'Mid West'
                                          , RecordtypeID = oppInsuranceID);
        insert op1;
        Opportunity op11 = [select id, Name,Contact__C, Lost_outcome__c, StageName from Opportunity where ID=: op1.ID limit 1];
        Op11.Lost_outcome__c = 'Compliance Reason';
        Op11.StageName = 'Closed-Lost';
        Op11.Contact__C=Con2.id;
        update op11;
        
        Test.StopTest();
    }
    
    static testMethod void test3(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent');
        insert op1;
        
        Opportunity Op11 = [select id, OBA_Pending_Prospect_Docusign_Sent_Entry__c,Kit_Reject_to_Registrations_Entry__c 
                            ,OBA_Pending_Prospect_Docusign_Sent_Exit__c,Kit_Reject_to_Registrations_Exit__c  
                            from Opportunity where id= : op1.id limit 1];
        
        system.assertEquals(Op11.OBA_Pending_Prospect_Docusign_Sent_Exit__c, null);
        system.assertEquals(Op11.Kit_Reject_to_Registrations_Exit__c , null);
        
        Op1.GRC_Status__c = 'Withdrawn';
        Op1.Review_Status__c = 'Pending NCO – Call Requested';
        update op1;
        
        // Start Commented by Amol 4/17
       /* Opportunity Op12 = [select id, OBA_Pending_Prospect_Docusign_Sent_Entry__c,Kit_Reject_to_Registrations_Entry__c 
                            ,OBA_Pending_Prospect_Docusign_Sent_Exit__c,Kit_Reject_to_Registrations_Exit__c
                            from Opportunity where id= : op1.id limit 1];*/
        // End Commented by Amol 4/17
        
     //   system.assertEquals(Op12.OBA_Pending_Prospect_Docusign_Sent_Exit__c, System.Today());
    //    system.assertEquals(Op12.Kit_Reject_to_Registrations_Exit__c , System.Today());
        Test.startTest();
        
        Op1.GRC_Status__c = 'Call Completed';
        Op1.Review_Status__c = 'Pending OBA Analyst - More Info Received';
        update op1;
        
        Op1.GRC_Status__c = 'Pending EVP Committee';
        Op1.Review_Status__c = 'Pending NCO - More Info Requested';
        update op1;
        
        Op1.GRC_Status__c = 'Approved';
        Op1.Review_Status__c = 'Assigned to OBA Analyst';
        update op1;
        
        Op1.GRC_Status__c = 'Denied';
        Op1.Review_Status__c = 'Reject to NCO';
        update op1;
        
        Op1.GRC_Status__c = 'Reject to NCO';
        Op1.Review_Status__c = 'Reject to NCO';
        update op1;
        
        Test.stopTest();
    } 
    
    /***************CH-02 - Start*****************************************/
    
    public static testMethod  void test5(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test OTC',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent');
        insert op1;
        
    }
    
    /***************CH-02 - End*****************************************/
    
    /***************** CH-03 - Start ***********************************/
    /*public static testMethod  void test6(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test OTC',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'//,
            
        );
        insert u;
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact c1 = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',LastName = 'Test Contact', channel__c='IAS',request_to_join_as__c='Hybrid OSJ');
        insert c1;
        
        Contact c2 = new Contact(Source_Type_Prospect__c ='LPL Advisor',Lead_Source__c='Referral',LastName = 'Test Contact 1', channel__c='IAS',request_to_join_as__c='Hybrid OSJ');
        c2.RecordTypeId='0120P000000AK3I';
        insert c2;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '3 - Submitted a Kit'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                          , Contact__c=c1.Id, Internal_Recruiter_IRD__c = u.Id
                                          , Assigned_Recruiter__c = u.Id
                                          , Acquisition__c = 'New Branch- Hybrid RIA'
                                          , Expected_AUM__c = 500,Target_TAT_Date__c=System.today(),
                                          Channel_Owner__c= 'IAS');
        insert op1;
        
        Opportunity op3 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '3 - Submitted a Kit'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                          , Contact__c=c1.Id, Internal_Recruiter_IRD__c = u.Id
                                          , Assigned_Recruiter__c = u.Id, Acquisition__c = 'Jaguar'
                                          , Expected_AUM__c = 500,Target_TAT_Date__c=System.today(),
                                          Channel_Owner__c= 'IAS');
        insert op3;
        
        Opportunity op4 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '3 - Submitted a Kit'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                          , Contact__c=c2.Id, Internal_Recruiter_IRD__c = u.Id
                                          , Assigned_Recruiter__c = u.Id, Acquisition__c = 'Jaguar'
                                          , Expected_AUM__c = 500,Target_TAT_Date__c=System.today(),
                                          Channel_Owner__c= 'IAS');
        insert op4;
        
        Task tsk1= new Task(whatid =op1.id , OwnerId = op1.Internal_Recruiter_IRD__c ,Status='Not Started',Subject='Contract Accommodation', ActivityDate=System.today(), Priority='High'); 
        insert tsk1;   
        
        Task tsk3= new Task(whatid =op3.id , OwnerId = op3.Internal_Recruiter_IRD__c ,Status='Not Started',Subject='Contract Accommodation', ActivityDate=System.today(), Priority='High'); 
        insert tsk3;
        
    }
    
    */
    
    /*static testMethod void test7(){
        Schema.DescribeSObjectResult oppRecDesc = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> rtMapByName = oppRecDesc.getRecordTypeInfosByName();
        
        Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
        Map<ID,Schema.RecordTypeInfo> rt_MapCon = Contact.sObjectType.getDescribe().getRecordTypeInfosById();
        
        ID oppRIAID = rtMapByName.get('RIA Compliance ADVantage').getRecordTypeId();
        ID oppInsuranceID = rtMapByName.get('AIS Insurance Sales').getRecordTypeId();
        Id IASBD = rtMapByName.get('IAS Business Development').getRecordTypeId();  
        
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',Discovery_Contact_Phone__c='789456',Discover_Zip_Code__c='41105',MailingCity ='pune',Discovery_Contact_State__c='MH',HomePhone='123456',Phone='123456',MobilePhone='1234567894',Fax='123',Email='test@test.com',LastName = 'Test', AccountID = a1.Id, Insurance_Territory__c = 'Test', Master_Rep_ID__c = '002D' );
        Insert Con;
        
        User user = [select id from User where email = 'puser000@amamama.com' limit 1];
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '3 - Submitted a Kit'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                          , Regional_Transition_Partner__c = user.ID
                                          , Investment_Transition_Consultant__c = user.ID
                                          , Transition_Support_Partners__c  = user.ID
                                          , Integration_Manager__c = user.ID
                                          , Contact__C = con.ID, RecordtypeID = IASBD);
        insert op1;
        Opportunity op11 = [select id, Name, Lost_outcome__c, StageName from Opportunity where Contact__c=: Con.Id];
        Op11.Lost_outcome__c = 'Compliance Reason';
        Op11.StageName = 'Closed-Lost';
        Op11.Home_Phone__c='123456';
        Op11.email__c='test@test.com';
        Op11.Fax__c='123';
        Op11.State__c='MH';
        Op11.Zip_Code__c='411057';
        Op11.Work_Phone__c='789456';
        Op11.Mobile__c='1234567894';
        update op11;
        
        Test.StopTest();
    }*/
    
  
    
    static testMethod void test8(){
        
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId(); 
        
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con1 = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',RecordtypeID = conRecordTypeId,Discovery_Contact_Phone__c='789456',Discover_Zip_Code__c='41105',MailingCity ='pune',Discovery_Contact_State__c='MH',HomePhone='123456',Phone='123456',MobilePhone='1234567894',Fax='123',Email='test@test.com',LastName = 'Test', AccountID = a1.Id, Insurance_Territory__c = 'Test', Master_Rep_ID__c = '002D' );
        Insert Con1;
        system.assertEquals(null,con1.Highest_Stage_Reached__c);
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today()+1, StageName = '1 - Engaged'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , Contact__C = con1.ID, RecordtypeID = IASBD);
        insert op1;
        
        Test.StopTest();
    }
    
    /*static testMethod void test9(){
        
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId(); 
        
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con2 = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',RecordtypeID = conRecordTypeId, Highest_Stage_Reached__c = '1 - Engaged', Discovery_Contact_Phone__c='789456',Discover_Zip_Code__c='41105',MailingCity ='pune',Discovery_Contact_State__c='MH',HomePhone='123456',Phone='123456',MobilePhone='1234567894',Fax='123',Email='test@test.com',LastName = 'Test', AccountID = a1.Id, Insurance_Territory__c = 'Test', Master_Rep_ID__c = '002E' );
        Insert Con2;
        system.assertEquals('1 - Engaged',con2.Highest_Stage_Reached__c);
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity  stage changed'
                                          , CloseDate =  system.today()+2
                                          , StageName = '3 - Submitted a Kit'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , Contact__C = con2.ID, RecordtypeID = IASBD);
        insert op1;
        Opportunity op2 = new Opportunity(AccountId = a1.id
                                          , name = 'Test opportunity  stage changed'
                                          , CloseDate =  system.today()+2
                                          , StageName = '2 - Hot List', Zip_Code__c = '80538'
                                          , GDC_Prior_12_mo__c = 200, Contact__C = con2.ID
                                          , RecordtypeID = IASBD);
        insert op2;
        
        Opportunity op3 = new Opportunity(AccountId = a1.id
                                          , name = 'Test opportunity  stage changed'
                                          , CloseDate =  system.today()+2
                                          , StageName = '1 - Engaged', Zip_Code__c = '80538'
                                          , GDC_Prior_12_mo__c = 200, Contact__C = con2.ID
                                          , RecordtypeID = IASBD);
        insert op3;
        Test.StopTest();
        
    }*/
    static testMethod void test11(){
        
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId(); 
        
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        Opportunity op2 = new Opportunity(AccountId = a1.id
                                          , name = 'Test opportunity name'
                                          , CloseDate =  system.today()+3
                                          , StageName = '3 - Submitted a Kit'
                                          , Target_TAT_Date__c = date.newInstance(2017, 12, 31)
                                          , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                          , Acquisition__c = 'Reject to Registrations'
                                          , Expected_AUM__c = 2
                                          , Channel_Owner__c ='IAS' 
                                          , RecordtypeID = IASBD
                                          
                                         );
        insert op2;
        Test.StopTest();
    }
    
    /********************************************************************************************************/
    
    static testMethod void test12(){
        
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        ID conprospRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId(); 
        Trigger_Bypass__c tbp1 = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp1;
        Account_Bypass__c accBypass = new Account_Bypass__c(Name='Test',AccountId__c='001U0000009jVWt');
        insert accBypass;
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact contactrec = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',Discovery_Home_Zip__c ='45123',RecordtypeID = conRecordTypeId,request_to_join_as__c='Hybrid OSJ',channel__c='IAS',Highest_Stage_Reached__c = '1 - Engaged', Discovery_Contact_Phone__c='789456',Discover_Zip_Code__c='41105',MailingCity ='pune',Discovery_Contact_State__c='MH',HomePhone='123456',Phone='123456',MobilePhone='1234567894',Fax='123',Email='test@test.com',LastName = 'Test', AccountID = a1.Id, Insurance_Territory__c = 'Test', Master_Rep_ID__c = '002E');
        Insert contactrec;
        
        
        Opportunity oppport = new Opportunity(AccountId = a1.id
                                              , name = 'Test opportunity name'
                                              , Contact__c = contactrec.id
                                              , CloseDate =  system.today()+3
                                              , StageName = '3 - Submitted a Kit'
                                              , Target_TAT_Date__c = date.newInstance(2017, 12, 31)
                                              , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                              , Acquisition__c = 'Reject to Registrations'
                                              , Expected_AUM__c = 2
                                              , Channel_Owner__c ='IAS' 
                                              , RecordtypeID = IASBD
                                              , Self_Identified_Gender__c = 'Prefer Not to Answer'
                                              , Self_Identified_Military_Service__c = 'Prefer Not to Answer'
                                              , Self_Identified_Race_Ethnicity__c = 'Prefer Not to Answer');
        insert oppport;
        
    }
    
    static testMethod void testcamp(){
        ID conprospRecordTypeId1= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        ID IASBD1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId(); 
        Trigger_Bypass__c tbp1 = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp1;
        Account_Bypass__c accBypass = new Account_Bypass__c(Name='Test',AccountId__c='001U0000009jVWt');
        insert accBypass;
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        Campaign camp=new Campaign(IsActive=true, Name='Testing',ELQ_Opportunity_Record_Type__c='IAS Business Development');
        insert camp;
        Contact contactrecpros = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',Discovery_Home_Zip__c ='45124',RecordtypeID = conprospRecordTypeId1,request_to_join_as__c='Hybrid OSJ',channel__c='IAS',Highest_Stage_Reached__c = '1 - Engaged', Discovery_Contact_Phone__c='789456',Discover_Zip_Code__c='41105',MailingCity ='pune',Discovery_Contact_State__c='MH',HomePhone='123456',Phone='123456',MobilePhone='1234567894',Fax='123',Email='test@test.com',LastName = 'Test', AccountID = a1.Id, Insurance_Territory__c = 'Test',Assigned_Recruiter__c=Userinfo.getUserId());
        Insert contactrecpros;
        CampaignMember campID = new CampaignMember(CampaignId=camp.id,contactId=contactrecpros.id,Status='responded');
        insert campID;
        Opportunity oppport1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity name'
                                               , Contact__c = contactrecpros.id
                                               , CloseDate =  system.today()+3
                                               , StageName = '3 - Submitted a Kit'
                                               , Target_TAT_Date__c = date.newInstance(2017, 12, 31)
                                               , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                               , Acquisition__c = 'Reject to Registrations'
                                               , Expected_AUM__c = 2
                                               , Channel_Owner__c ='IAS', RecordtypeID = IASBD1);
        insert oppport1;
    }
    // CH-04  start 
    static testMethod void OpportunityTarget_TAT(){
        Test.StartTest();
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId(); 
        ID LPLTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        list<contact> conList=new List<Contact>();
        
        list<Opportunity> oppList=new List<Opportunity>();
        Contact contactrec = new Contact(channel__c='IAS',Request_To_Join_As__c='CPA Partner',Discovery_Home_Zip__c ='45123',RecordtypeID = LPLTypeId, Highest_Stage_Reached__c = '1 - Engaged', Discovery_Contact_Phone__c='789456',Discover_Zip_Code__c='41105',MailingCity ='pune',Discovery_Contact_State__c='MH',HomePhone='123456',Phone='123456',MobilePhone='1234567894',Fax='123',Email='test@test.com',LastName = 'Test', AccountID = a1.Id, Insurance_Territory__c = 'Test', Master_Rep_ID__c = '002E',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' );
        conList.add(contactrec);
        
        Contact contactObj = new Contact(RecordtypeID = conRecordTypeId, Highest_Stage_Reached__c = '1 - Engaged', Fax='12443',Email='test11@test.com',LastName = 'Test1', AccountID = a1.Id, Insurance_Territory__c = 'Test',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        
        conList.add(contactObj);
        Contact contactObj2 = new Contact(Lead_Source__c='Banner',Source_Type_Prospect__c ='Transitions',Marketing_Category__c='Dormant',channel__c='IAS',Request_To_Join_As__c='CPA Partner',Discovery_Home_Zip__c ='45126',RecordtypeID = conRecordTypeId, Highest_Stage_Reached__c = 'Test',LastName = 'Test2');
        conList.add(contactObj2);
        insert conList;
        Opportunity op2 = new Opportunity(AccountId = a1.id, name = 'tat opportunity record'
                                          , CloseDate =  system.today()+3, Contact__c = contactrec.id
                                          , StageName = '3 - Submitted a Kit'
                                          , Target_TAT_Date__c = date.newInstance(2017, 12, 31)
                                          , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                          , Acquisition__c = 'Reject to Registrations'
                                          , Expected_AUM__c = 2, Channel_Owner__c ='IAS' 
                                          , RecordtypeID = IASBD,Self_Identified_Gender__c='Male'
                                          , Self_Identified_Military_Service__c='Prefer Not to Answer'
                                          ,Self_Identified_Race_Ethnicity__c='Asian');
        oppList.add(op2);
        
        Opportunity oppport = new Opportunity(AccountId = a1.id, name = 'Test opportunity name22'
                                              , Contact__c = contactObj.id, CloseDate =  system.today()+3
                                              , StageName = '2 - Hot List'
                                              , Target_TAT_Date__c = date.newInstance(2017, 12, 31)
                                              , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                              , Acquisition__c = 'Reject to Registrations'
                                              , Expected_AUM__c = 2
                                              , Channel_Owner__c ='IAS', RecordtypeID = IASBD);
        oppList.add(oppport);
        
        Opportunity oppport2 = new Opportunity(AccountId = a1.id, name = 'Test opportunity name1'
                                               , Contact__c = contactObj2.id
                                               , CloseDate =  system.today(), StageName = '1 - Engaged'
                                               , Target_TAT_Date__c = date.newInstance(2017, 12, 31)
                                               , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                               , Acquisition__c = 'Reject to Registrations'
                                               , Expected_AUM__c = 2, Channel_Owner__c ='IAS' 
                                               , RecordtypeID = IASBD);
        
        oppList.add(oppport2);
        insert oppList ;
        Test.StopTest();
    }
    
    static testMethod void updateHighestStageReached(){
        
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId(); 
        ID LPLTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        list<contact> conList=new List<Contact>();
        
        list<Opportunity> oppList=new List<Opportunity>();
        Contact contactrec = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',channel__c='IAS',Request_To_Join_As__c='CPA Partner',Discovery_Home_Zip__c ='45123',RecordtypeID = LPLTypeId,LastName = 'Test', AccountID = a1.Id);
        conList.add(contactrec);
        
        Contact contactObj = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',MailingStreet='newyork',MailingState='USA', Rep_Type__c = 'RIA Hybrid Firm',RecordtypeID = LPLTypeId, Highest_Stage_Reached__c = '1 - Engaged', Fax='12443',Email='test11@test.com',LastName = 'Test1', AccountID = a1.Id, Insurance_Territory__c = 'Test');
        
        conList.add(contactObj);
        Contact contactObj2 = new Contact(RecordtypeID = LPLTypeId, Highest_Stage_Reached__c = 'Test',LastName = 'Test2',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(contactObj2);
        
        Contact contactObj3 = new Contact(Highest_Stage_Reached__c = 'Test',LastName = 'Test2',AccountID = a1.Id,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(contactObj3);
        insert conList;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'tat opportunity record1'
                                          , CloseDate =  system.today()+3
                                          , Contact__c = contactObj.id, StageName = '3 - Submitted a Kit'
                                          , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                          , Acquisition__c = 'Reject to Registrations'
                                          , Channel_Owner__c ='IAS' , RecordtypeID = IASBD
                                          ,Self_Identified_Gender__c='Male');
        oppList.add(op1);
        Opportunity op2 = new Opportunity(AccountId = a1.id, name = 'tat opportunity record2'
                                          , CloseDate =  system.today()+3
                                          , Contact__c = contactrec.id, StageName = '3 - Submitted a Kit'
                                          , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                          , RecordtypeID = IASBD
                                          , Self_Identified_Military_Service__c='Prefer Not to Answer');
        oppList.add(op2);
        Opportunity op3 = new Opportunity(AccountId = a1.id, name = 'tat opportunity record3'
                                          , CloseDate =  system.today()+3, Contact__c = contactrec.id
                                          , StageName = '2 - Hot List'
                                          , Target_TAT_Date__c = date.newInstance(2017, 12, 31)
                                          , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                          , Acquisition__c = 'Reject to Registrations'
                                          , Expected_AUM__c = 2, Channel_Owner__c ='IAS' 
                                          , RecordtypeID = IASBD,Self_Identified_Race_Ethnicity__c='Asian'
                                          ,MAX_TA_Dollars_Allowed__c=10);
        oppList.add(op3);
        insert oppList;
        List<Case> caseList=new List<Case>();
        for(Integer i=0;i<5;i++) {
            Case c=new Case();
            c.Status='Not Started';
            c.Subject='caseSub+i';
            c.Description='Desc+i';
            c.Case_Origin_Detail__c='Email';
            c.First_Email_Sent_Date__c=System.Today();
            c.Opportunity__c=op3.Id;
            c.Region__c='East';
            c.Requesting_Department__c='Advisor Financial Solutions';
            caseList.add(c);
        }
        
        insert caseList;
        
        Opportunity Op12 = [select id, OBA_Pending_Prospect_Docusign_Sent_Entry__c,Kit_Reject_to_Registrations_Entry__c 
                            ,OBA_Pending_Prospect_Docusign_Sent_Exit__c,Kit_Reject_to_Registrations_Exit__c,MAX_TA_Dollars_Allowed__c
                            from Opportunity where id= : op3.id limit 1];
        Op12.MAX_TA_Dollars_Allowed__c=12;
        update Op12;
        
        Test.StopTest();
    }
    // CH-04 End
    
    static testMethod void testBothExitDates(){
        ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId(); 
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'tat opportunity record1',Review_Status__c='OBA Consult Requested'
                                          , GRC_Status__c='Ready for Assignment',CloseDate =  system.today()+3
                                          , StageName = '3 - Submitted a Kit'
                                          , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                          , Acquisition__c = 'Reject to Registrations'
                                          , Channel_Owner__c ='IAS' , RecordtypeID = IASBD
                                          ,Self_Identified_Gender__c='Male');
        insert op1;
        Opportunity op2 = new Opportunity(AccountId = a1.id, name = 'tat opportunity record2',Review_Status__c='Assigned to OBA Analyst'
                                          , GRC_Status__c='Assigned to GRC Analyst',CloseDate =  system.today()+3
                                          ,  StageName = '3 - Submitted a Kit'
                                          , Internal_Recruiter_IRD__c = UserInfo.getUserID()
                                          , RecordtypeID = IASBD
                                          , Self_Identified_Military_Service__c='Prefer Not to Answer');
        insert op2;
        OpportunityHandler handler=new OpportunityHandler();
        handler.getGRCExitDateAssigned(op2,op1);
        handler.getReviewExitDateAssigned(op2,op1);
        handler.getGRCExitDateAssigned(op2,op1);      
        
    }
    
    static testMethod void loanApplicationDeclinetest(){
        Schema.DescribeSObjectResult oppRecDesc = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> rtMapByName = oppRecDesc.getRecordTypeInfosByName();
        
        Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
        Map<ID,Schema.RecordTypeInfo> rt_MapCon = Contact.sObjectType.getDescribe().getRecordTypeInfosById();
        
        ID oppRIAID = rtMapByName.get('RIA Compliance ADVantage').getRecordTypeId();
        ID oppInsuranceID = rtMapByName.get('AIS Insurance Sales').getRecordTypeId();
        Id IASBD = rtMapByName.get('IAS Business Development').getRecordTypeId();  
        
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',WMO_Division__c='East',LastName = 'Test', AccountID = a1.Id, Insurance_Territory__c = 'Test', Master_Rep_ID__c = '002D' );
        Insert Con;
        
        User user = [select id from User where email = 'puser000@amamama.com' limit 1];
        
        LPL_Insurance_Associates__c lplIA = new LPL_Insurance_Associates__c(Name = '002D', Contact__c = con.ID);
        insert lplIA;
        
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538' , GDC_Prior_12_mo__c = 200
                                          , GRC_Status__c = 'Reject to Registrations'
                                          , Review_Status__c = 'Pending Prospect – Docusign Sent'
                                          , Regional_Transition_Partner__c = user.ID
                                          , Investment_Transition_Consultant__c = user.ID
                                          , Transition_Support_Partners__c  = user.ID
                                          , Integration_Manager__c = user.ID
                                          , Contact__C = con.ID, LPL_Region__c = 'Mid West'
                                          , RecordtypeID = oppInsuranceID);
        insert op1;
        
        Loan_Application__c loanApp = new Loan_Application__c();
        loanApp.Legal_Entity__c = 'Individual';
        loanApp.Advisor__c = con.id;
        loanApp.Primary_Contact__c = true;
        loanApp.Assigned_Recruiter__c = op1.Assigned_Recruiter__c;
        loanApp.Internal_Recruiter__c = userinfo.getuserid();
        loanApp.Business_Developer__c = op1.Regional_VP__c;
        loanApp.Opportunity__c = op1.Id;
        insert loanApp;
        System.debug('+=======+Beforore Closing =====');
        //Opportunity op11 = [select id, Name,Contact__C, Lost_outcome__c,Regional_VP__c,Internal_Recruiter_IRD__c,Assigned_Recruiter__c, StageName from Opportunity where ID=: op1.ID limit 1];
        op1.Assigned_Recruiter__c = op1.Regional_VP__c;
        op1.Internal_Recruiter_IRD__c =  userinfo.getuserid();
        op1.Regional_VP__c = op1.Internal_Recruiter_IRD__c;
        //update op11;
        op1.Lost_outcome__c = 'Compliance Reason';
        // Starting Commented by Madhu 4/17/2020
       // op1.StageName = 'Closed-Lost';
       // Ending Commented by Madhu 4/17/2020
        op1.Contact__C=Con.id;
         update op1;
        System.debug('Op11========'+op1);
        System.debug('+=======+executing  DML  Operation TEXT =====');
        
        Test.StopTest();
       // loanApp = [Select id, status__c from Loan_Application__c where Id =: loanApp.id];
        // System.debug('loanApp ========>'+loanApp);
       // system.assertEquals('Declined', loanApp.Status__c);
    }
}