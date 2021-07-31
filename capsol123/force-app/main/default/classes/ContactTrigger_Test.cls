/*  ******** Lead Onboarding Changes - Contact Trigger Chnages Test Class********** */

@isTest(seeAllData = false)
public class ContactTrigger_Test{

    public static Id conRecordTypeId;
    
    @testSetup static void methodName() {
    
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account_Bypass__c tbp2 = new Account_Bypass__c();
        tbp2.name='test';
        tbp2.accountId__c = '001K000011MCdZr';
        insert tbp2;
        
        conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();       
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();       
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Account a2 = new Account(Name = 'Test Account2');
        insert a2;
        
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
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrtname', lastname = 'lastname ' ,Lead_Type__c='Core',
                        Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                        HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                        Lpl_Attachment_Sent_Date__c = system.today(), Channel_owner__c = 'IS BD', MailingPostalCode = '84081', Assigned_Recruiter__c= UserInfo.getUserID());
        conList.add(ct1);
        
        Contact ct2= new Contact(AccountId = a2.id, firstname = 'Fisrname1', lastname = 'lastname ' ,Lead_Type__c='Masters',
                        Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                        HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                        Lpl_Attachment_Sent_Date__c = system.today(), Channel_owner__c = 'IS BD', MailingPostalCode = '84081', Assigned_Recruiter__c= UserInfo.getUserID());
        conList.add(ct2);
        
        insert conList;      
               
   }
    
    static testMethod void test1(){
    
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact con = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrtname' limit 1 ];
        System.debug('***conABC'+con);
        con.Lead_Source__c = 'Banner';
        con.ELQ_Marketing_Email_Opt_Out__c = true;
        
        update con;
       // Opportunity opp =[select id, LeadSource from opportunity where Contact__c =: con.Id limit 1];
        Test.StartTest();
        
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
        
        
        Test.StopTest();
        
    }
    
    
    /*Test MEthod for Trigger "marketingActivities_AfterTrigger"*/
    
    static testMethod void test2(){
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact con = [select id, Lead_Source__c , HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrtname' limit 1 ];
        
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( ELOQUA__Activity_Type__c = 'Campaign' , Activity_Status__c = 'Responded'
                                                    ,ELOQUA__Contact__c = con.ID );
        insert ema;
        
        Task tsk = [select id, WhoId from task where whoId =: con.ID limit 1];
        system.assertEquals(tsk.WhoId, con.ID);
        test.stopTest();
        
    }
    static testMethod void test3(){
        Test.StartTest();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
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
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                        Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                        HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                        Lpl_Attachment_Sent_Date__c = system.today(), Channel_owner__c = 'IS BD', MailingPostalCode = '84081', Assigned_Recruiter__c=UserInfo.getUserID());
        insert ct1;  
        
        contact con = [select id, Assigned_Recruiter__c from Contact where id =: ct1.ID];
        con.Assigned_Recruiter__c = userinfo.getUserId();
        update con;
        system.assertEquals(UserInfo.getUserID(),con.Assigned_Recruiter__c); 
        test.stopTest();
    }
    static testMethod void test4(){
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact con = [select id, Lead_Source__c,Lead_Type__c ,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c, HasOptedOutOfEmail,RecordTypeID, ELQ_Marketing_Email_Opt_Out__c  from Contact where firstname = 'Fisrname1' limit 1 ];
        con.Assigned_Recruiter__c = userinfo.getUserId();
        update con;
        system.assertEquals(UserInfo.getUserID(),con.Assigned_Recruiter__c); 
         
        con.Lead_Source__c = 'Banner';
        con.ELQ_Marketing_Email_Opt_Out__c = true;
        con.Lead_Type__c='Core';
        con.Allow_Lead_Type_Change__c = true;
        
        update con;
        
        system.assertEquals(con.Assigned_Recruiter__c, UserInfo.getUserID()); 
        system.assertEquals(con.Lead_Type__c, 'Core');
        test.stopTest();
    }
    static testMethod void test5(){
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact con2 = [select id,Lead_Source__c,Lead_Type__c ,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c from contact where FirstName = 'Fisrtname' limit 1];
        system.assertEquals(con2.Lead_Type__c, 'Core');
        con2.GDC_Prior_12_mo__c =100;
        con2.MailingPostalCode = '84081';
        update con2;
        
        Contact con3 = [select id,Lead_Source__c,Lead_Type__c ,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c from contact where FirstName = 'Fisrtname' limit 1];
        //system.assertEquals(con3.Lead_Type__c, 'Core');
        test.stopTest();
    }
    static testMethod void test6(){
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact con2 = [select id,Lead_Source__c,Lead_Type__c ,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c from contact where FirstName = 'Fisrtname' limit 1];
        system.assertEquals(con2.Lead_Type__c, 'Core');
        con2.GDC_Prior_12_mo__c =10000000;
        con2.MailingPostalCode = '84081';
        con2.Channel_Owner__c = 'IS';
        update con2;
        Contact con3 = [select id,Lead_Source__c,Lead_Type__c ,Assigned_Recruiter__c, MailingPostalCode, Channel_owner__c from contact where FirstName = 'Fisrname1' limit 1];
        system.assertEquals(con3.Lead_Type__c, 'Masters');
      
        test.stopTest();
    }
}