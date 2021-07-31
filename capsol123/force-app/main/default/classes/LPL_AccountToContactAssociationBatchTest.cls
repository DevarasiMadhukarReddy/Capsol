@isTest
public class LPL_AccountToContactAssociationBatchTest {

    public static testmethod void contacttoaccounttest(){
        Id lplAdvisorId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.recordtypeId = lplAdvisorId;
        con.Branch_ID__c = 'E12G';
        insert con;
        
        Account acc = new Account();
        acc.Name = 'Test Contact';
        acc.Branch_ID__c = 'E12G';
        insert acc;
        
         test.startTest();
         LPL_AccountToContactAssociation_Schedule batchjob =new LPL_AccountToContactAssociation_Schedule();
         String cron = '0 0 23 * * ?';  
         String jobid = System.schedule('LPL_AccountToContactAssociation_Batch',cron,batchjob);
         test.stopTest();
            
    }
}