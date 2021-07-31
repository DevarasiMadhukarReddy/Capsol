@isTest
private class TestGenerateAMZBatchJob {
    static testMethod void validateAMZCreation() {
      loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                    
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        //Create a dummy Loan Product
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(dummyOffice,
                            dummyAccount, 
                            curr, 
                            dummyFeeSet);
        
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();        
        
        loan__Client__c dummyClient = loan.TestHelper.createClient(dummyOffice);  
        
        Contact c = TestHelperCL.createContact();
        c.loan__Payment_Mode__c = 'ACH';
        UPDATE c;
        
        //Create a dummy Loan Account
        loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccount(dummyLP,
                                                    dummyClient,
                                                    dummyFeeSet,
                                                    dummyLoanPurpose,
                                                    dummyOffice);
        
        loan__Payment_Mode__c pm = new loan__Payment_Mode__c();
        pm.Name = 'ACH';
        INSERT pm;
        Delete[Select id,name,loan__RSS_Loan_Account__c from loan__Repayment_Schedule_Summary__c where loan__RSS_Loan_Account__c =: loanAccount.id];
        loanAccount.loan__Contact__c = c.Id;
        loanAccount.is_migrated__c = TRUE;
        loanAccount.loan__Payment_Mode__c = pm.id;
        UPDATE loanAccount;
        
        loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
        Date curSysDate = loanFacade.getCurrentSystemDate();
        
        loan__Loan_Disbursal_Transaction__c disbTxn = new loan__Loan_Disbursal_Transaction__c();
        disbTxn.loan__Disbursal_Date__c = curSysDate;
        disbTxn.loan__Disbursed_Amt__c = loanAccount.loan__Loan_Amount__c;
        disbTxn.loan__Loan_Account__c = loanAccount.id;
        disbTxn.loan__Mode_of_Payment__c =  pm.id;
        
        INSERT disbTxn;
        disbTxn.loan__Cleared__c =true;
        UPDATE disbTxn;   
        
        test.startTest();
        GenerateAMZ_BatchJob job = new GenerateAMZ_BatchJob();
        Database.executeBatch(job);
        test.stopTest();
    }
    
    
}