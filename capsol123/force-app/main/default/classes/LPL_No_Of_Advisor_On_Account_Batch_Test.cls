/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Test class for Batch - LPL_No_Of_Advisor_On_Account_Batch         Garvita Rai                  14 Feb 2019
*/

@isTest(SeeAllData=False)
public class LPL_No_Of_Advisor_On_Account_Batch_Test {
    
    public static testmethod void contactDateUpdateBatchTest() {
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
        
        Id contactLPLAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
         
        Account acc = new Account();
        acc.Name = 'Account 1';
        insert acc;
        
        Contact con = LPL_testDataSetUpUtility.createContact('Test Contact ',acc.Id,contactLPLAdvisor);
        insert con;
        
        test.startTest();
        LPL_No_Of_Advisor_On_Account_Batch batchjob =new LPL_No_Of_Advisor_On_Account_Batch();
        Database.executeBatch(batchjob);
        test.stopTest();
        
        List<Account> accList = new List<Account>([SELECT id, Number_of_contacts__c from Account]);
        system.assertEquals(accList[0].Number_of_contacts__c,1);
    }
}