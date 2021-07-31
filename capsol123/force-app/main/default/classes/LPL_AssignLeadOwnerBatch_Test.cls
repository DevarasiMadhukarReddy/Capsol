/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Test class for Batch - LPL_AssignLeadOwnerAsIRD_OneTimeBatch         Garvita Rai                  22 November 2018


*/

@isTest
public class LPL_AssignLeadOwnerBatch_Test{
    
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
    
    public static testmethod void leadDataUpdateBatchTest() {
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
        
        User u1= [SELECT Id,Email,Name from User Where Email ='ashish.gupta@lpl.com' limit 1];
        
        Account acc1 = new Account();
        acc1.Name = 'Account 1';
        insert acc1;
        
        IAS_Recruiter_Assignment__c  iasRec = LPL_testDataSetUpUtility.createIAS(u1.id);
        insert iasRec;
        List<Lead> ledList= new List<Lead>();
        for(Integer i=0; i<=3;i++){
            Lead led = LPL_testDataSetUpUtility.createLead('Test Lead '+i);
            led.PostalCode= '12345';
            ledList.add(led);
        }
        ledList[0].PostalCode ='';
        insert ledList;
        test.startTest();
        LPL_AssignLeadOwnerAsIRD_OneTimeBatch batchjob =new LPL_AssignLeadOwnerAsIRD_OneTimeBatch();
        Database.executeBatch(batchjob);
        test.stopTest();
        List<Lead> ledDataList = new List<Lead>([SELECT id,Name,OwnerId from Lead where (Name = 'Test Lead 1')]);
        system.assertEquals(ledDataList[0].OwnerId,u1.id);
    }
    
}