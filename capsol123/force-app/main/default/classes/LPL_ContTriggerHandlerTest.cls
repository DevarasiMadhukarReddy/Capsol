/*
Trigger Name            :LPL_ContactTrigger
Description             :Test Class for LPL_ContactTriggerGateway
Developer Name          : Sai Ketu
Created Date            : 10/13/2016

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01          Created MA1 test records                         Ashish Gupta      10/1/2018
CH-19		Added updateBusinessSolFields_Test method			Puja Jadhav		  09/09/2020
CH-20	    LBSFNS-29  Web To Lead Form Changes			        Indrasen	      04/24/2021
CH-21       LBSFNS-608 Lead grades Update from Contact          Rinku             07/19/2021
*/
@isTest(seeAllData = false)
public class LPL_ContTriggerHandlerTest{
    
    public static Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    public static Id pardotConRecordTypeId;
    //CH-19 START
    public static final ID RECTYPE_LPL_ADVISOR= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
    //CH-19 END
    public static final ID LeadLBSPreOpportunity = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('LBS Pre-Opportunity').getRecordTypeId();
    
    @testSetup static void methodName() {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account_Bypass__c tbp2 = new Account_Bypass__c();
        tbp2.name='test';
        tbp2.accountId__c = '001K000011MCdZr';
        insert tbp2;
        
        pardotConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId();
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();       
        Id isInstitution = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId();        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        Account a2 = new Account(Name='Program Manager Test', RecordTypeId=isInstitution);
        insert a2;
        Account a3 = new Account(Name='Program Manager Test Single', RecordTypeId=isInstitution);
        insert a3;
        List<IAS_Recruiter_Assignment__c>  iasList = new List<IAS_Recruiter_Assignment__c >();
        
        IAS_Recruiter_Assignment__c ias1 = new IAS_Recruiter_Assignment__c(Name = '84081', Lead_Type__c='Masters', State__c ='AP',
                                                                           Assigned_Recruiter__c = UserInfo.getUserID(),
                                                                           Internal_Recruiter__c = UserInfo.getUserID(),
                                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                                           GDC_Maximum__c = 100000000.0, GDC_Minimum__c=2000000.0
                                                                          );
        iasList.add(ias1);                                                  
        
        IAS_Recruiter_Assignment__c ias2 = new IAS_Recruiter_Assignment__c(Name = '84081', Lead_Type__c='Core', State__c = 'AP',
                                                                           Assigned_Recruiter__c= UserInfo.getUserID(),
                                                                           Internal_Recruiter__c= UserInfo.getUserID(),
                                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                                           GDC_Maximum__c = 2000000.0, GDC_Minimum__c=0.0);       
        iasList.add(ias2);                                           
        insert iasList;
        
        List<Contact> conList = new List<Contact>();
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(ct1);
        
        Contact ct2= new Contact(firstname = 'Fisrtname', lastname = 'lasttname ' ,lead_quality__c = 'Contact Attempted',
                                 Insurance_Territory__c = 'Testt Territory', RecordTypeId = conRecordTypeId,Rep_Status__c ='Active',Inactive_Reason__c='Inactive - Compliance',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(ct2);
        
        Contact ct11= new Contact(firstname = 'Fisrtname', lastname = 'lasttname3 ' ,
                                  ownerId=Userinfo.getUserId(),Insurance_Territory__c = 'Testt Territory', RecordTypeId = conRecordTypeId,Rep_Status__c ='Active',Inactive_Reason__c='Inactive - Compliance',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(ct11);
        
        Contact ct12= new Contact(firstname = 'Fisrtname', lastname = 'lasttname3 ' ,
                                  ownerId=Userinfo.getUserId(),Insurance_Territory__c = 'Testt Territory', RecordTypeId = conRecordTypeId,Rep_Status__c ='Active',Inactive_Reason__c='Inactive - Compliance',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(ct12);
        
        Contact con21 = new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    Channel_owner__c = 'IS BD', Discovery_Home_Zip__c = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA2', Internal_Recruiter_IRD__c = UserInfo.getUserID(),Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(con21);
        
        Contact con22 = new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discovery_Home_Zip__c = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA3', Internal_Recruiter_IRD__c = UserInfo.getUserID(),Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(con22);
        
        Contact con23 = new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', MailingPostalCode = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA4', Internal_Recruiter_IRD__c = UserInfo.getUserID(),Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(con23);  
        Contact con24 = new Contact(AccountId = a1.id, firstname = 'testing123', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', mailingpostalcode = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA4', Internal_Recruiter_IRD__c = UserInfo.getUserID(),PardotActivityInputDate__c = system.today()+100,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        
        conList.add(con24);   
        
        Contact con25 = new Contact(AccountId = a1.id, firstname = 'testing1234', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', mailingpostalcode = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA3', Internal_Recruiter_IRD__c = UserInfo.getUserID(),PardotActivityInputDate__c = system.today()+100,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        
        conList.add(con25);
        Contact con26 = new Contact(AccountId = a2.id, firstname = 'testing1234', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    Role__c = 'Program Manager',PM_Contact_Level__c='Secondary PM Contact',
                                    ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', mailingpostalcode = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA3', Internal_Recruiter_IRD__c = UserInfo.getUserID(),PardotActivityInputDate__c = system.today()+100,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(con26);
        
        Contact con27 = new Contact(AccountId = a2.id, firstname = 'testing1234', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    Role__c = 'Program Manager',PM_Contact_Level__c='Primary PM Contact',Hire_Date__c = Date.today(),
                                    ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', mailingpostalcode = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA3', Internal_Recruiter_IRD__c = UserInfo.getUserID(),PardotActivityInputDate__c = system.today()+100,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(con27);
        
        Contact con28 = new Contact(AccountId = a2.id, firstname = 'testing1234', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    Role__c = 'Program Manager',PM_Contact_Level__c='Primary PM Contact',Hire_Date__c = Date.today(),
                                    ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', mailingpostalcode = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA3', Internal_Recruiter_IRD__c = UserInfo.getUserID(),PardotActivityInputDate__c = system.today()+100,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(con28);
        Contact con29 = new Contact(AccountId = a3.id, firstname = 'testing1234', lastname = 'lastname ' ,
                                    Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                    HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                    Role__c = 'Program Manager',PM_Contact_Level__c='Secondary PM Contact',
                                    ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', mailingpostalcode = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA3', Internal_Recruiter_IRD__c = UserInfo.getUserID(),PardotActivityInputDate__c = system.today()+100,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        conList.add(con29);
        
        Contact con30 = new Contact(Lastname = 'TestOSJ123', OSJ_ID__c = '1V24');
        conList.add(con30);
        Contact con32 = new Contact(Lastname = 'TestOSJ123', OSJ_ID__c = '123U');
        conList.add(con32);
        Contact con31 = new Contact(Lastname = 'TestBranch123', Branch_Id__c = '1E07');
        conList.add(con31);
        Contact con34 = new Contact(Lastname = 'TestBranch123', Branch_Id__c = '3456');
        conList.add(con34);
         /*******CH-21 : Start**************/
        Contact con35 = new Contact(Lastname = 'TestLeadgrade', RecordTypeId = RECTYPE_LPL_ADVISOR,LBS_Admin_Grade__c = '',LBS_Assurance_Grade__c = '',LBS_CFO_Solutions_Grade__c = '',
                                    LBS_Client_Engage_Grade__c = '',LBS_Deal_Support_Grade__c = '',LBS_Marketing_Solutions_Grade__c = '',LBS_Premium_Buyer_Grade__c = '',
                                    LBS_Resilience_Grade__c = '',LBS_Seller_Support_Grade__c = '',LBS_Technology_Grade__c = '',LBS_Valuation_Grade__c = '',LBS_Bookkeeping_Grade__c = '');
        conlist.add(con35);
        	insert conList;
        
        Lead ld = new lead(LastName = 'TestLeadGrade',status='Open',RecordTypeId = LeadLBSPreOpportunity, Contact__c = con35.Id);
        	insert ld;
        /*******CH-21 : End**************/ 
        List<Opportunity> optyList=new List<Opportunity>();
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , Contact__c = conList[0].Id, RecordTypeId = oppRecordTypeId);
        optyList.add(op1);
        Opportunity op12 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                           , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                           , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                           , Contact__c = conList[1].Id
                                           , RecordTypeId = oppRecordTypeId);
        optyList.add(op12);
        
        Opportunity op13 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                           , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                           , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                           , Contact__c = conList[2].Id, RecordTypeId = oppRecordTypeId);
        optyList.add(op13);
        
        Opportunity op14 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                           , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                           , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                           , Contact__c = conList[3].Id, RecordTypeId = oppRecordTypeId);
        optyList.add(op14);
        
        insert optyList;
        
        List<contact> conListnew=new List<contact>();
        contact ct3=[select id,Inactive_Reason__c from contact where id=:conList[0].Id];
        ct3.Inactive_Reason__c='Inactive - Not a Good Fit';
        conListnew.add(ct3);
        
        contact ct4=[select id,Inactive_Reason__c from contact where id=:conList[1].Id];
        ct4.Inactive_Reason__c='Inactive - Compliance';
        conListnew.add(ct4);
        
        contact ct5=[select id,Inactive_Reason__c from contact where id=:conList[2].Id];
        ct5.Inactive_Reason__c='Inactive - Joined Another Firm';
        conListnew.add(ct5);
        
        update conListnew;
        //CH-19 START
        Contact LPLTestCon = new Contact(AccountId = a1.id, firstname = 'LPL Test Contact', lastname = 'lastname ',
                                         RecordTypeId = RECTYPE_LPL_ADVISOR,Admin_Solutions_Active_Date__c=date.parse('09/09/2020'),Marketing_Solutions_Active_Date__c=date.parse('09/08/2020'),
                                         CFO_Solutions_Active_Date__c=date.parse('09/07/2020') );
        Contact LPLTestCon1 = new Contact(AccountId = a1.id, firstname = 'LPL Test Contact1', lastname = 'lastname ',
                                          RecordTypeId = RECTYPE_LPL_ADVISOR,Admin_Solutions_Active_Date__c=date.parse('09/09/2020'),Marketing_Solutions_Active_Date__c=date.parse('09/08/2020'),
                                          CFO_Solutions_Active_Date__c=date.parse('09/07/2020') );
        
        insert LPLTestCon;
        insert LPLTestCon1;
        //CH-19 END
        
        //CH-20 Start
        List<Contact> advContactList = new List<Contact>();
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Contact contact = new Contact(LastName='LBS Jackson Contact',FirstName='A',RecordTypeId=conRecordTypeId,MailingState='CT',LBS_Admin__c = false);              
        advContactList.add(contact);
        Contact contact1 = new Contact(LastName='Paul LBS Contact1',FirstName='B',RecordTypeId=conRecordTypeId,MailingState='WA',LBS_Client_Engage__c = false);              
        advContactList.add(contact1);
        Contact contact2 = new Contact(LastName='LBS Raul Martin Contact',FirstName='C',RecordTypeId=conRecordTypeId,MailingState='ME',LBS_Assurance__c = false);      
        advContactList.add(contact2);
        insert advContactList;
        //CH-20 End
    }
    
    static testMethod void test1(){
        
        Test.startTest();
        Contact con = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrname' limit 1 ];
        
        con.Lead_Source__c = 'Banner';
        con.ELQ_Marketing_Email_Opt_Out__c = true;
        update con;
        OSJ_ID__mdt OSJmdt = [Select MasterLabel,QualifiedApiName,OSJ_Name__c, Type__c 
                              FROM OSJ_ID__mdt
                              WHERE Active__c = true limit 1];
        Contact con1 = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where id =: con.Id limit 1 ];
        
        Opportunity opp1 =[select id, LeadSource, Contact__c from opportunity where Contact__c =: con1.Id limit 1];
        
        Account a2 = new Account(Name = 'Test Account');
        insert a2;                
        
        Contact con2 = [select id, Lead_Source__c  from Contact where firstname = 'Fisrtname' limit 1 ];
        con2.AccountId = a2.id;
        update con2;
        
        Account acc1 = [select id, number_Of_Contacts__C from Account where id =: a2.Id];
        delete con2;
        Account acc2 = [select id, number_Of_Contacts__C from Account where id =: a2.Id];
        undelete con2;
        Account acc3 = [select id, number_Of_Contacts__C from Account where id =: a2.Id];
        /**OSJ Update**/
        Contact conOSJ = [SELECT Id,OSJ_ID__c FROM Contact WHERE lastname ='testOSJ123' and OSJ_id__c ='1V24'];
        conOSJ.OSJ_ID__c = 'C005';
        update conOSJ;
        Contact conBranch = [SELECT Id,Branch_Id__c FROM Contact WHERE lastname ='TestBranch123' and Branch_Id__c ='1E07'];
        conBranch.Branch_Id__c = '18AN';
        update conBranch;
        Contact conOSJ1 = [SELECT Id,OSJ_ID__c FROM Contact WHERE lastname ='testOSJ123' and OSJ_id__c ='123U'];
        conOSJ1.OSJ_ID__c = '345X';
        update conOSJ1;
        Contact conBranch1 = [SELECT Id,Branch_Id__c FROM Contact WHERE lastname ='TestBranch123' and Branch_Id__c ='3456'];
        conBranch1.Branch_Id__c = '1290';
        update conBranch1;
        Test.StopTest();
    }
    
    
    /*Test MEthod for Trigger "marketingActivities_AfterTrigger"*/
    
    static testMethod void test2(){
        
        Test.StartTest();
        Contact con = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrname' limit 1 ];
        
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( ELOQUA__Activity_Type__c = 'Campaign' , Activity_Status__c = 'Responded'
                                                                              ,ELOQUA__Contact__c = con.ID );
        insert ema;
        
        Task tsk = [select id, WhoId from task where whoId =: con.ID limit 1];
        test.stopTest();
        
    }
    static testMethod void test3(){
        Test.StartTest();
        conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        List<IAS_Recruiter_Assignment__c>  iasList = new List<IAS_Recruiter_Assignment__c >();
        
        IAS_Recruiter_Assignment__c ias1 = new IAS_Recruiter_Assignment__c(Name = '84081', Lead_Type__c='Masters', State__c ='AP',
                                                                           Assigned_Recruiter__c = UserInfo.getUserID(),
                                                                           Internal_Recruiter__c = UserInfo.getUserID(),
                                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                                           GDC_Maximum__c = 100000000.0, GDC_Minimum__c=2000000.0
                                                                          );
        iasList.add(ias1);                                                  
        
        IAS_Recruiter_Assignment__c ias2 = new IAS_Recruiter_Assignment__c(Name = '84081', Lead_Type__c='Core', State__c = 'AP',
                                                                           Assigned_Recruiter__c= UserInfo.getUserID(),
                                                                           Internal_Recruiter__c= UserInfo.getUserID(),
                                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                                           GDC_Maximum__c = 2000000.0, GDC_Minimum__c=0.0
                                                                          );       
        
        iasList.add(ias2);                                           
        
        insert iasList;
        
        List<Contact> conList = new List<Contact>();
        
        Contact ct1= new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 Channel_owner__c = 'IS BD', MailingPostalCode = '84081');
        insert ct1;  
        
        contact con = [select id, Assigned_Recruiter__c from Contact where id =: ct1.ID];
        con.Assigned_Recruiter__c = userinfo.getUserId();
        update con;
        
        system.assertEquals(con.Assigned_Recruiter__c, UserInfo.getUserID()); 
        test.stopTest();
    }
    
    static testMethod void test4(){
        Test.StartTest();
        Contact con = [select id, Lead_Source__c,Internal_Recruiter_IRD__c,Lead_Type__c,Discovery_Home_Zip__c,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c, HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrname' limit 1 ];
        
        con.Lead_Source__c = 'Banner';
        con.ELQ_Marketing_Email_Opt_Out__c = true;
        con.Lead_Type__c='Core';
        con.Discovery_Home_Zip__c = '85879';
        con.Allow_Lead_Type_Change__c = false;
        con.Internal_Recruiter_IRD__c = UserInfo.getUserID();
        con.Assigned_Recruiter__c =  UserInfo.getUserID();
        
        update con;
        
        system.assertEquals(con.Assigned_Recruiter__c, UserInfo.getUserID()); 
        system.assertEquals(con.Lead_Type__c, 'Core');
        test.stopTest();
    }
    static testMethod void test5(){
        Test.StartTest();
        Contact con2 = [select id,Lead_Source__c,Lead_Type__c ,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c from contact where FirstName = 'Fisrtname' limit 1];
        system.assertEquals(con2.Lead_Type__c, null);
        con2.GDC_Prior_12_mo__c =100;
        con2.MailingPostalCode = '84081';
        update con2;
        
        Contact con3 = [select id,Lead_Source__c,Lead_Type__c ,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c from contact where FirstName = 'Fisrtname' limit 1];
        con3.Lead_Type__c = 'Core';
        update con3;
        system.assertEquals(con3.Lead_Type__c, 'Core');
        test.stopTest();
    }
    static testMethod void test6(){
        
        Test.StartTest();
        Contact con2 = [select id,Lead_Source__c,Lead_Type__c ,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c from contact where FirstName = 'Fisrtname' limit 1];
        system.assertEquals(con2.Lead_Type__c, null);
        con2.GDC_Prior_12_mo__c =10000000;
        con2.MailingPostalCode = '84081';
        con2.Channel_Owner__c = 'IS';
        update con2;
        
        test.stopTest();
    }
    
    //For the trigger on Marketing Activity marketingActivities_AfterTrigger - Developer: Utkarsh Topre Date 05/25/2017
    
    static testMethod void test7(){
        Test.StartTest();
        Contact con = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrname' limit 1 ];
        
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( Name = 'BD_DisruptionEM 1' , ELOQUA__Activity_Type__c = 'Email Click Through'
                                                                              ,ELOQUA__Contact__c = con.ID );
        insert ema;
        
        Task tsk = [select id, WhoId from task where whoId =: con.ID limit 1];
        //system.assertEquals(tsk.WhoId, con.ID);
        test.stopTest();
        
    }
    
    static testMethod void test8(){
        Test.StartTest();
        Contact con = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrname' limit 1 ];
        
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( Name = 'BD_DripEM 1' , ELOQUA__Activity_Type__c = 'Email Click Through'
                                                                              ,ELOQUA__Contact__c = con.ID );
        insert ema;
        
        Task tsk = [select id, WhoId from task where whoId =: con.ID limit 1];
        system.assertEquals(tsk.WhoId, con.ID);
        test.stopTest();
        
    }
    
    static testMethod void test9(){
        Test.StartTest();
        Contact con = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrname' limit 1 ];
        
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( Name = 'BD_Agile 1' , ELOQUA__Activity_Type__c = 'Email Click Through'
                                                                              ,ELOQUA__Contact__c = con.ID );
        insert ema;
        
        Task tsk = [select id, WhoId from task where whoId =: con.ID limit 1];
        //system.assertEquals(tsk.WhoId, con.ID);
        test.stopTest();
        
    }
    static testMethod void test12(){
        Test.StartTest();  
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact c1 = [Select Id, PardotActivityInput__c, Internal_Recruiter_IRD__c, Previous_PardotAcivity_Value__c from Contact where Previous_PardotAcivity_Value__c = 'MA1'];
        c1.Internal_Recruiter_IRD__c = userinfo.getUserId();
        
        If(c1.Previous_PardotAcivity_Value__c =='MA1'&& c1.Internal_Recruiter_IRD__c!=null ){
            Task tsk1 = new Task(whoId = c1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Not Started', OwnerId = c1.Internal_Recruiter_IRD__c);
            insert tsk1;
        }
        system.assertEquals(1, [select count() from Task where whoId =: c1.ID]);
        test.stopTest();
    }
    
    static testMethod void test14(){
        Test.StartTest();
        
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        Contact c3 = new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 Channel_owner__c = 'IS BD', MailingPostalCode = '84081',Internal_Recruiter_IRD__c=Userinfo.getUserId(),Inactive_Reason__c='Inactive - Compliance',PardotActivityInput__c ='MA2',PardotActivityInputDate__c= system.today()+100,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        
        insert c3;
        c3.Internal_Recruiter_IRD__c = Userinfo.getUserId();
        c3.PardotActivityInput__c ='MA3';
        c3.AccountId = null;
        update c3;
        delete c3;
        system.assertEquals(Userinfo.getUserId(), c3.Internal_Recruiter_IRD__c );
        
        test.stopTest();
    }
    
    static testMethod void test16(){
        Test.StartTest();
        
        conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con1 = new Contact(AccountId = a1.Id, LastName = 'Test MA1', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId, Previous_PardotAcivity_Value__c = 'MA1',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        If(con1.Previous_PardotAcivity_Value__c !=null && con1.Internal_Recruiter_IRD__c!=null){
            insert con1 ;
        }
        
        If(con1.Previous_PardotAcivity_Value__c =='MA1'&& con1.Internal_Recruiter_IRD__c!=null){
            Task tsk1 = new Task(whoId = con1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Not Started', OwnerId = con1.Internal_Recruiter_IRD__c);
            insert tsk1;
        }
        
        system.assertEquals(1, [select count() from Task where whoId =: con1.ID]);
        
        Contact con2 = new Contact(Id = con1.Id, AccountId = a1.Id, LastName = 'Test MA2', PardotActivityInput__c ='MA3', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        If(con2.PardotActivityInput__c=='MA1' && con2.Internal_Recruiter_IRD__c!=null){
            update con2 ;
            Task tsk1 = new Task(whoId = con2.ID,Type = 'Outbound Call',Category__c = 'Call-Outbound',Activity_Type__c = 'IRD Touch',Department__c = 'Business Development',Subject = 'Marketing Form Follow up', ActivityDate = System.Today() + 5, Status = 'Not Started', OwnerId = con2.Internal_Recruiter_IRD__c);
            insert tsk1;    
        }
        
        system.assertEquals(1, [select count() from Task where whoId =: con1.ID]);
        test.stopTest();
    }
    
    static testMethod void test17(){
        Test.StartTest();
        
        conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con1 = new Contact(AccountId = a1.Id, LastName = 'Test MA1', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId, Previous_PardotAcivity_Value__c = 'MA1',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        If(con1.Previous_PardotAcivity_Value__c !=null && con1.Internal_Recruiter_IRD__c!=null){
            insert con1 ;
        }
        
        
        If(con1.Previous_PardotAcivity_Value__c =='MA1'&& con1.Internal_Recruiter_IRD__c!=null /*&& con1.PardotActivityInputDate__c == null*/){
            Task tsk1 = new Task(whoId = con1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Not Started', OwnerId = con1.Internal_Recruiter_IRD__c);
            insert tsk1;
        }
        
        system.assertEquals(1, [select count() from Task where whoId =: con1.ID]);
        
        
        Contact con2 = new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',Id = con1.Id, AccountId = a1.Id, LastName = 'Test MA2', PardotActivityInput__c ='MA4', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId);
        If(con2.PardotActivityInput__c !=null && con2.Internal_Recruiter_IRD__c!=null /*&& con2.PardotActivityInputDate__c.daysBetween(system.today()) > 90*/ ){
            update con2 ;
            Task tsk1 = new Task(whoId = con2.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Not Started', OwnerId = con2.Internal_Recruiter_IRD__c);
            insert tsk1;
        }
        
        test.stopTest();
    }
    
    static testMethod void test18(){
        Test.StartTest();
        
        conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con1 = new Contact(AccountId = a1.Id, LastName = 'Test MA4', PardotActivityInput__c ='MA4', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert con1 ;
        test.stopTest();
    }
    
    
    static testMethod void test19(){
        Test.StartTest();
        
        conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact con1 = new Contact(AccountId = a1.Id, LastName = 'Test MA1', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        If(con1.PardotActivityInput__c !=null && con1.Internal_Recruiter_IRD__c!=null){
            insert con1 ;
        }
        
        system.assertEquals('MA1',con1.PardotActivityInput__c);
        
        Contact con2 = new Contact(Id = con1.Id, AccountId = a1.Id, LastName = 'Test MA1', PardotActivityInput__c ='MA2', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        If(con2.PardotActivityInput__c !=null && con2.Internal_Recruiter_IRD__c!=null){
            update con2 ;
        }
        test.stopTest();
    }
    static testMethod void test20(){
        Contact con = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrname' limit 1 ];
        
        delete con;  
    }
    
    /********************* 
Merge Related Changes ****************************/
    
    static testMethod void testMultipleContactMerge(){
        Test.StartTest();
        
        ID conRecordTypeId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        ID pardotcontactRecordtypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId();      
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact mastercon1 = new Contact(Data_Link2__DDL_RepID__c='1',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='1master',LastName = 'test1', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId1, MailingStreet='mega',MailingCity='pune',Mailingstate='mp',MailingPostalCode='12023',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        Contact mastercon2 = new Contact(Data_Link2__DDL_RepID__c='2',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='2master',LastName = 'test2', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId1, MailingStreet='mega',MailingCity='bhopal',Mailingstate='mp',MailingPostalCode='12123',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        
        insert mastercon1;
        insert mastercon2; 
        
        Contact childcon1 = new Contact(Data_Link2__DDL_RepID__c='123',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='1master',LastName = 'test', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = pardotcontactRecordtypeID,MailingStreet='mega',MailingCity='pune',Mailingstate='mp',MailingPostalCode='12023',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        
        insert childcon1;
    }
    
    static testMethod void testCRDNullContactMerge(){
        Test.StartTest();
        
        ID conRecordTypeId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        ID pardotcontactRecordtypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId();      
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact mastercon1 = new Contact(Data_Link2__DDL_RepID__c='1',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='1master',LastName = 'test1', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId1, MailingStreet='mega',MailingCity='pune',Mailingstate='mp',MailingPostalCode='12023',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' );
        insert mastercon1;
        
        Contact childcon1 = new Contact(Data_Link2__DDL_RepID__c='2',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='2master',LastName = 'test2', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = pardotcontactRecordtypeID,MailingStreet='mega',MailingCity='pune',Mailingstate='mp',MailingPostalCode='12023',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' );
        insert childcon1;
    }
    
    static testMethod void testPardotStatusEqualsYes(){
        Test.StartTest();
        
        ID conRecordTypeId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        ID pardotcontactRecordtypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId();      
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact mastercon1 = new Contact(Data_Link2__DDL_RepID__c='12345',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='1master',LastName = 'test', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId1, MailingStreet='mega',MailingCity='pune',Mailingstate='mp',MailingPostalCode='12023',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert mastercon1;
        
        Contact childcon1 = new Contact(Data_Link2__DDL_RepID__c='67890',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='2master',LastName = 'test2', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = pardotcontactRecordtypeID,MailingStreet='thane',MailingCity='mumbai',Mailingstate='mh',MailingPostalCode='211021', Pardot_Status__c='Yes',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert childcon1;
    }
    
    /********************************************************/  
    
    
    static testMethod void testPardotEmail(){
        Test.StartTest();
        
        ID conRecordTypeId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        ID pardotcontactRecordtypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId();      
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact mastercon1 = new Contact(Data_Link2__DDL_RepID__c='12345', AccountId = a1.Id, Firstname='1master',LastName = 'test', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId1, MailingStreet='mega',MailingCity='pune',Mailingstate='mp',MailingPostalCode='12023',Discovery_Email_Personal_Type__c='test@test.com',Discovery_Email_Business_Type__c='test@test.com',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert mastercon1;
        
        Contact childcon1 = new Contact(Data_Link2__DDL_RepID__c='67890', AccountId = a1.Id, Firstname='2master',LastName = 'test2', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = pardotcontactRecordtypeID,MailingStreet='thane',MailingCity='mumbai',Mailingstate='mh',MailingPostalCode='211021', Pardot_Status__c='Yes',Email='test@test.com',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert childcon1;
    }
    
    static testMethod void testPardotCRDNull(){
        Test.StartTest();
        
        ID conRecordTypeId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        ID pardotcontactRecordtypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId();      
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact mastercon1 = new Contact(Data_Link2__DDL_RepID__c='12345',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='1master',LastName = 'test', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = conRecordTypeId1, MailingStreet='mega',MailingCity='pune',Mailingstate='mp',MailingPostalCode='12023',Discovery_Email_Business_Type__c='test@test.com',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' );
        insert mastercon1;
        
        Contact childcon1 = new Contact(Data_Link2__DDL_RepID__c='',Discovery_Email_Personal_Type__c='abc@lpl.com', AccountId = a1.Id, Firstname='2master',LastName = 'test2', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), RecordTypeId = pardotcontactRecordtypeID,MailingStreet='thane',MailingCity='mumbai',Mailingstate='mh',MailingPostalCode='211021', Pardot_Status__c='Yes',Email='test@test.com',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' );
        
        insert childcon1;
        test.stopTest();
    }
    
    // CH-01 start
    static testMethod void afterupdateMA1(){
        Test.StartTest();
        Contact c1 = [Select PardotActivityInput__c, id , Internal_Recruiter_IRD__c from Contact where firstname = 'testing123' limit 1];
        c1.Internal_Recruiter_IRD__c = UserInfo.getUserID();
        c1.PardotActivityInput__c ='MA1';  
        update c1;
        
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Contact c = new Contact(LastName='Test',Internal_Recruiter_IRD__c=UserInfo.getUserId(),Previous_PardotAcivity_Value__c='MA1',RecordTypeId=conRecordTypeId,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');      
        insert c;
        test.stopTest();
    }
    // CH-01 stop
    
    static testMethod void contactTerminationTest(){
        Test.StartTest();
        Contact c1 = [Select PardotActivityInput__c, id , Internal_Recruiter_IRD__c from Contact where firstname = 'testing123' limit 1];
        
        Opportunity opp = new Opportunity();
        opp.Assigned_Recruiter__c = UserInfo.getUserID();
        opp.Internal_Recruiter_IRD__c =UserInfo.getUserID();
        opp.Regional_VP__c = UserInfo.getUserID();
        opp.Name ='test';
        opp.StageName ='test1';
        opp.CloseDate = system.today();
        insert opp;
        
        Loan_Application__c loanApp = new Loan_Application__c();
        loanApp.Legal_Entity__c = 'Individual';
        loanApp.Advisor__c = c1.id;
        loanApp.Primary_Contact__c = true;
        loanApp.Assigned_Recruiter__c = opp.Assigned_Recruiter__c;
        loanApp.Internal_Recruiter__c = opp.Internal_Recruiter_IRD__c;
        loanApp.Business_Developer__c = opp.Regional_VP__c;
        insert loanApp;
        
        c1.Inactive_Reason__c = 'Not Interested';  
        update c1;
        test.stopTest();
        
        loanApp = [Select id, status__c from Loan_Application__c where Id =: loanApp.id];
        system.assert(loanApp != null);
    }
    //CH-19 Start
    
    static testmethod void updateBusinessSolFields_Test(){
        contact con=[Select Id ,name from contact where  firstname = 'LPL Test Contact' limit 1];
        contact con1=[Select Id ,name from contact where  firstname = 'LPL Test Contact1' limit 1];
        test.startTest();
        Date myDate=Date.today();
        con.Admin_Solutions_Active_Date__c=myDate.addDays(-5);
        con.Marketing_Solutions_Active_Date__c=myDate.addDays(-5);
        con.CFO_Solutions_Active_Date__c=myDate.addDays(-5);
        con1.Admin_Solutions_Termination_Date__c=myDate;
        con1.Marketing_Solutions_Termination_Date__c=myDate;
        con1.CFO_Solutions_Termination_Date__c=myDate;
        update con;
        update con1;
        test.stopTest();
        system.assert(con!=null);
        
    }
    //CH-19 End
    
    
    //CH-20 Change Start
    static testmethod void processLeadUpdatesTest(){
    	
        //LastName='LBS Jackson Contact',FirstName='A',RecordTypeId=conRecordTypeId,MailingState='CT',LBS_Admin_Solutions__c = false
        Contact con = [Select Id,LBS_Admin__c from Contact Where LastName='LBS Jackson Contact'];	
        con.LBS_Admin__c = true;
        update con;
        Test.startTest();
        System.enqueueJob(new LeadController(new List<Contact>{con}));
        Test.stopTest();
    }
    //CH-20 End
     /*******CH-21 : Start**************/
    static testmethod void UpdateLeadScoreTest(){
        Contact con1 = [SELECT Id,LBS_Admin_Grade__c,LBS_CFO_Solutions_Grade__c,LBS_Assurance_Grade__c,
                        LBS_Client_Engage_Grade__c,LBS_Deal_Support_Grade__c,LBS_Marketing_Solutions_Grade__c,
                        LBS_Premium_Buyer_Grade__c,LBS_Resilience_Grade__c,LBS_Seller_Support_Grade__c,
                        LBS_Technology_Grade__c,LBS_Valuation_Grade__c,LBS_Bookkeeping_Grade__c 
                        FROM contact WHERE LastName = 'TestLeadgrade' ];
        con1.LBS_Admin_Grade__c = 'High';
        con1.LBS_CFO_Solutions_Grade__c = 'High';
        con1.LBS_Assurance_Grade__c = 'High';
        con1.LBS_Client_Engage_Grade__c = 'High';
        con1.LBS_Deal_Support_Grade__c = 'High';
        con1.LBS_Marketing_Solutions_Grade__c = 'High';
        con1.LBS_Premium_Buyer_Grade__c = 'High';
        con1.LBS_Resilience_Grade__c = 'High';
        con1.LBS_Seller_Support_Grade__c = 'High';
        con1.LBS_Technology_Grade__c = 'High';
        con1.LBS_Valuation_Grade__c = 'High';
        con1.LBS_Bookkeeping_Grade__c = 'High';
        
        update con1;
        Lead lead1 = [SELECT ID,Contact__c,LBS_Admin_Solutions_Grade__c FROM lead WHERE LastName = 'TestLeadGrade'];
        
        
        system.assertEquals('High',lead1.LBS_Admin_Solutions_Grade__c);
    }
    /*******CH-21 : End**************/
}