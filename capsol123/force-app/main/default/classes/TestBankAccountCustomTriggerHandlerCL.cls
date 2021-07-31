@isTest
private class TestBankAccountCustomTriggerHandlerCL {
    static testMethod void validateBankAccountAfterInsertTriggerHandler() {
        Contact c = TestHelperCL.createContact();
        
        Test.startTest();
        loan__Bank_Account__c ba = new loan__Bank_Account__c();
        ba.loan__Contact__c = c.Id;
        ba.loan__Bank_Account_Number__c = '12345';
        ba.loan__Bank_Name__c = 'Test Bank';
        ba.loan__Routing_Number__c = '12';
        
        INSERT ba;
        Test.stopTest();
        
    }
}