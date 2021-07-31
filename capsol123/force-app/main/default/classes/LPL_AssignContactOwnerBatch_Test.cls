/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Test class for Batch - LPL_AssignContactOwnerAsIRD_OneTimeBatch        Garvita Rai                  22 November 2018


*/

@isTest
public class LPL_AssignContactOwnerBatch_Test{
    
    @testSetup static void testData() {
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'IAS RMBC');
        insert r;
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS User'].Id,
            FirstName='ashish',
            LastName = 'gupta',
            Email = 'ashish.gupta@lpl.com',
            Username = 'ashish.gupta@lpl.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'Internal Regional Director',
            Alias = 'agupt',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        insert u1;
    }
    
    public static testmethod void contactDateUpdateBatchTest() {
        
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
        Account_Bypass__c accBypass = new Account_Bypass__c(Name='Test',AccountId__c='001U0000009jVWt');
        insert accBypass;

        User u1= [SELECT Id,Email,Name from User Where Email ='ashish.gupta@lpl.com' limit 1];

        IAS_Recruiter_Assignment__c  ias = LPL_testDataSetUpUtility.createIAS(u1.id);
        insert ias;
        Id contactProspect = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        Account acc1 = new Account(Name='Test Account');
        insert acc1;
        
        List<Contact> conList = new List<Contact>();
        for(Integer i=0; i<=3;i++){
            Contact con = LPL_testDataSetUpUtility.createContact('Test Contact '+i,acc1.Id,contactProspect);
            con.MailingPostalCode = '12345';
            conList.add(con);
        }
        insert conList;
        test.startTest();
        LPL_AssignContactOwnerAsIRD_OneTimeBatch batchjob =new LPL_AssignContactOwnerAsIRD_OneTimeBatch();
        Database.executeBatch(batchjob);
        test.stopTest();
    }
}