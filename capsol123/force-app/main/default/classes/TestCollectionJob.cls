@isTest
private class TestCollectionJob {
    static testMethod void collectionJob() {
      
        Contact c = TestHelperCL.createContact();
        String sourceSystemName = 'COLLECT';
        staging__Interface_Contract__c contract = new staging__Interface_Contract__c();
        contract.Name = 'Lai000000056';
        contract.staging__Source_ID__c = '';
        contract.staging__Source_Name__c = sourceSystemName;
        contract.staging__Contact_External_ID__c = '005H';
        contract.staging__External_ID__c = 'ExIdLai000000056';
        contract.ACCOUNT_STATUS__c = 'Terminated';
        contract.Rep_ID__c = '005H';
        contract.Master_Rep_Id__c = '005H';
        contract.Total_AR_Balance__c = 1000;
        contract.staging__ACH_On__c = true;
        contract.staging__Amount_to_Current__c = 1500000;
        contract.staging__Contract_Type__c = 'Loan';
        contract.staging__Sync_Processed__c = false;
        System.debug('Contract --> ' + contract);
        insert contract;
        test.startTest();
        CollectionJob j =new CollectionJob();
        database.executeBatch(j);
        test.stopTest();
    }
    static testMethod void collectionJobfalse() {
      
        Contact c = TestHelperCL.createContact();
        
        test.startTest();
        CollectionJob j =new CollectionJob(false);
        database.executeBatch(j);
        test.stopTest();
    }
    
    
}