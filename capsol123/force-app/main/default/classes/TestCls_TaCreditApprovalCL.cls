@isTest
private class TestCls_TaCreditApprovalCL {
    static testMethod void validateUpdateDateandUserOnCreditApproval() {
        loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        genesis__applications__c app = new genesis__applications__c();
        app.genesis__Loan_Amount__c = 1000;
        app.Advisor_Credit_Approved__c = true;
        INSERT app;
        
        List<Id> appList = new List<Id>();
        appList.add(app.Id);
        
        Cls_TaCreditApproval.updateDateandUserOnCreditApproval(appList);
    }
}