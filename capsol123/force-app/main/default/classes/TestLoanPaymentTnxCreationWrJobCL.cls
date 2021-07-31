@isTest
private class TestLoanPaymentTnxCreationWrJobCL {
    static testmethod void validateExecute() {
        loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        test.startTest();
        LoanPaymentTransactionCreationWrapperJob job = new LoanPaymentTransactionCreationWrapperJob();
        job.execute(null);
        test.stopTest();
    }
    
    static testmethod void validateExecuteException() {
        test.startTest();
        LoanPaymentTransactionCreationWrapperJob job = new LoanPaymentTransactionCreationWrapperJob();
        Database.executeBatch(job);
        test.stopTest();
    }
}