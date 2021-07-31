@isTest
public class LPL_UpdateAllianceNameAndAdvisor_BatchT {
    
    @testSetup static void testDataSetup() {
        List<Contact> conList = new List<Contact>();
        Contact con1 = new Contact(Lastname = 'TestOSJ123', OSJ_ID__c = '00D1');
        conList.add(con1);
        Contact con2 = new Contact(Lastname = 'TestBranch123', Branch_Id__c = '1JB6');
        conList.add(con2);
        Contact con3 = new Contact(Lastname = 'Test123', Branch_Id__c = '');
        conList.add(con3);
        insert conList;
    }
    static testMethod void batchExecute() {
        OSJ_ID__mdt OSJmdt = [Select MasterLabel,QualifiedApiName,OSJ_Name__c,Type__c 
                              FROM OSJ_ID__mdt
                              WHERE Active__c = true limit 1];
        Contact conOSJ = [SELECT Id,OSJ_ID__c FROM Contact WHERE lastname ='TestOSJ123' and OSJ_id__c ='00D1'];
        Contact conBranch = [SELECT Id,Branch_Id__c FROM Contact WHERE lastname ='TestBranch123' and Branch_Id__c ='1JB6'];
        Contact con = [SELECT Id,Branch_Id__c FROM Contact WHERE lastname ='Test123' AND Branch_Id__c =''];
        
        test.startTest();
         LPL_UpdateAllianceNameAndAdvisor_Batch batchjob =new LPL_UpdateAllianceNameAndAdvisor_Batch();
         Database.executeBatch(batchjob);
        test.stopTest();
    }
    
}