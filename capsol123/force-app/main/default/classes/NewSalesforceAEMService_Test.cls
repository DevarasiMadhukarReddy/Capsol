/**

* Description  : This is test class for NewSalesforceAEMService 
* 
* @Author      : Ashish Gupta(Cognizant)
* @version     : 1.0
* @CreatedDate : Oct 24 ,2017
* CH-01        : 11/24/2017; Naga modifed for MIC-225- Production Defect: Salesforce Integration Modification - Open Opportunity
*/

@isTest
public class NewSalesforceAEMService_Test {
    
    
    public static testMethod void testNewSalesService1(){
        try{
            Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
            insert tbp;
            
            User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',Title = 'title',Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US',
                Phone = '798799',Extension = '798799',MobilePhone = '798799'
            );
            insert u;
            
            Account a1 = new Account(Name = 'Test Account');
            insert a1;
            
            Opportunity op1 = new Opportunity(AccountId = a1.id,name = 'Test opportunity',
                                              CloseDate =  system.today(),StageName = '1 - Unscreened Contact',
                                              Zip_Code__c = '80538',GDC_Prior_12_mo__c = 200,email__c='abc@gmail.com',
                                              GRC_Status__c='Call Completed',eKit_Received__c=system.today(),
                                              Assigned_to_GRC_Analyst__c=system.today(),Integration_Manager__c=u.id,
                                              Regional_Transition_Partner__c=u.Id,Acquisition__c = 'Jaguar');
            insert op1;
            
            Test.startTest();
            NewSalesforceAEMService.getSalesforceContactInfo('',a1.id);
            NewSalesforceAEMService.getSalesforceContactInfo('',op1.id);
            NewSalesforceAEMService.getSalesforceContactInfo('','');
            NewSalesforceAEMService.getSalesforceContactInfo('jhgjhg@hjv.com','hgkjkjhhh');
            Test.stopTest();
        }
        catch(Exception e) {
            system.assertEquals(true, e.getMessage().contains('ERROR'));
        }
    }
    
   public static testMethod void testNewSalesService3(){
        try{
            Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
            insert tbp;
            
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
                LocaleSidKey = 'en_US'
                
            );
            insert u;
            
            Account a1 = new Account(Name = 'Test Account');
            insert a1;
            
            Opportunity op1 = new Opportunity(AccountId = a1.id
                                              , name = 'Test opportunity'
                                              , CloseDate =  system.today()
                                              , StageName = '1 - Unscreened Contact'
                                              , Zip_Code__c = '80538'
                                              , GDC_Prior_12_mo__c = 200
                                              ,email__c='abc@gmail.com'
                                              ,GRC_Status__c='Call Completed'
                                              ,eKit_Received__c=system.today()
                                              ,Assigned_to_GRC_Analyst__c=system.today()
                                              ,Integration_Manager__c=u.id
                                              ,Regional_Transition_Partner__c=u.Id,
                                              Hire_Date__c=system.today(),Acquisition__c = 'Jaguar');
            insert op1;
            
            Task t1 = new Task(whatid = op1.id
                               , Status = 'Not Started'
                               , Department__c = 'Business Development'
                               , Subject='Email: Can Your Firm Support Your Advisory Transition?'
                               , Activity_Type__c = 'Submit TAT Request'
                               , Category__c = 'Left Message'
                               , ownerid=u.id);
            insert t1;
            
            Test.startTest();
            NewSalesforceAEMService.getSalesforceContactInfo('abc@gmail.com','');
            NewSalesforceAEMService.getSalesforceContactInfo('abc@gmail.com',a1.id);
            test.stopTest();           
        }
        catch(Exception e) {
            system.assertEquals(e.getMessage(),e.getMessage());
        }
    }
    
    public static testMethod void testNewSalesService8(){
        try{
            Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
            insert tbp;
            
            User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',Title = 'title',
                Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',Phone='9876435720',Extension='131',MobilePhone='678698798'
            );
            insert u;
            
            Account a1 = new Account(Name = 'Test Account');
            insert a1;
            
            Id contactLPLAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
            Contact con = LPL_testDataSetUpUtility.createContact('Test Contact',a1.id,contactLPLAdvisor);
            con.Request_To_Join_As__c = LPL_StaticDataUtility.REQUEST_NLA;
            con.Channel__c ='IAS';
            insert con;
            
            List<Opportunity>  oppInsert = new List<Opportunity>();
            Opportunity op1 = new Opportunity(AccountId = a1.id,Name = 'Test opportunity',Contact__c = con.id,
                                              CloseDate =  system.today(),StageName = '1 - Unscreened Contact',
                                              Zip_Code__c = '80538',GDC_Prior_12_mo__c = 200,Email__c ='abc@gmail.com',
                                              GRC_Status__c='Call Completed',eKit_Received__c=system.today(),
                                              Assigned_to_GRC_Analyst__c=system.today(),Regional_Transition_Partner__c=u.Id,
                                              Integration_Manager__c=u.id);
            oppInsert.add(op1);
            insert oppInsert;
            
            Test.startTest();
            NewSalesforceAEMService.getSalesforceContactInfo('abc@gmail.com',op1.id);
            NewSalesforceAEMService.getSalesforceContactInfo('abcdefg@test.com','');
            Test.stopTest();
        }
        catch(Exception e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}