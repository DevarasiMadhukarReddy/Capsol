/*
Test Class Name         :LPL_CaseGateway_Test
Description             :Test Class for LPL_CaseGateway

Developer Name          : Vaibhav Wadhai
Created Date            : 

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01      Updated the recordtype name from Project J to Business Development    Ishan Nigam     02-Dec-2020
           as part of Project Wreath changes.

*/
@isTest(seeAllData = false)
public class LPL_CaseGateway_Test {
    
    public static Id caseRecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();//Ishan Nigam:Updated the name from Project J to Business Development
    public static Id oppRecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    public static Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    
    @testSetup static void testUserData() {
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',Title = 'title',Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US',UserRoleId = r.Id);
        insert u;
    }
    
    static testMethod void test1() {
        test.startTest();
        List<Opportunity>  oppList = new List<Opportunity>();
        List<Case>  caseListforInsert=new List<Case>();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 Channel_owner__c = 'IS BD', MailingPostalCode = '84081',Inactive_Reason__c='Inactive - Compliance',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' );
        insert ct1;
        
        Trigger_Bypass__c tbp1 =  Trigger_Bypass__c.getInstance('Contact');
        tbp1.IsOff__c = true;
        update tbp1;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , Contact__c = ct1.Id, RecordTypeId = oppRecordTypeId);
        oppList.add(op1);
        
        Opportunity op2 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , Contact__c = ct1.Id, RecordTypeId = oppRecordTypeId);
        oppList.add(op2);
        insert oppList;
        
        Case caseRec1=new Case(Description='Test Desc', Origin='Email',
                               Region__c='East',
                               Subject='Test Subject',status='Not Started',
                               Priority='Medium',Opportunity__c=op1.id,
                               RecordTypeId = caseRecordTypeId);
        caseListforInsert.add(caseRec1);
        
        Case caseRec2=new Case(Description='Test Desc', Origin='Email',Region__c='East'
                               
                               ,Subject='Test Subject',status='Not Started'
                               ,Priority='Medium',Opportunity__c=op2.id
                               ,RecordTypeId = caseRecordTypeId);
        caseListforInsert.add(caseRec2);
        insert caseListforInsert;
        
        Case caseRecUpdate=[Select Id ,Transition_Assist_Dollars_Offered__c from Case where id=:caseRec2.id];
        caseRecUpdate.Transition_Assist_Dollars_Offered__c=345;
        update caseRecUpdate;
        
        test.stopTest();
    }
}