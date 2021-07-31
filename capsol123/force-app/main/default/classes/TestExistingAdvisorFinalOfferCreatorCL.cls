@isTest
private class TestExistingAdvisorFinalOfferCreatorCL {
    static testMethod void validateFinalOfferCreation() {
        loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = ConstantsCl.GROWTH_LOAN;
        INSERT clProduct;
        
        TestHelperCL.createGLcustomSetting();
        Contact c = TestHelperCL.createContact();
        c.RIA_Type__c = 'Hybrid';
        c.RIA_Firm_ID__c = c.Master_Rep_ID__c;
        UPDATE c;
        
        Case cs = new Case();
        cs.Interest_Rate__c = 10;
        cs.Loan_Amount__c = 50000;
        cs.ContactId = c.Id;
        cs.Term__c = 36;
        cs.Status = 'Final Review';
        cs.Case_Reason_Detail__c = ConstantsCl.GROWTH_LOAN;
        cs.Region__c='East';
        INSERT cs;
        
        Test.startTest();
        String result = CLSApplicationCreatorFromCase.createApplication(cs.Id);
        System.assertEquals('SUCCESS! Application has been created.', result);
        
        List<Id> caseIdsList = new List<Id>();
        caseIdsList.add(cs.Id);
        ExistingAdvisorFinalOfferCreator creator = new ExistingAdvisorFinalOfferCreator();
        ExistingAdvisorFinalOfferCreator.finalOfferCreation(caseIdsList);
        Test.stopTest();
        
    }
    
    static testMethod void validateFinalOfferCreation2() {
        loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = ConstantsCl.RETENTION_LOAN;
        INSERT clProduct;
        
        TestHelperCL.createGLcustomSetting();
        Contact c = TestHelperCL.createContact();
        c.RIA_Type__c = 'Hybrid';
        c.RIA_Firm_ID__c = c.Master_Rep_ID__c;
        UPDATE c;
        
        Case cs = new Case();
        cs.Interest_Rate__c = 10;
        cs.Loan_Amount__c = 50000;
        cs.ContactId = c.Id;
        cs.Term__c = 36;
        cs.Status = 'Final Review';
        cs.Case_Reason_Detail__c = ConstantsCl.RETENTION_LOAN;
        cs.Region__c='East';
        INSERT cs;
        
        Test.startTest();
        String result = CLSApplicationCreatorFromCase.createApplication(cs.Id);
        System.assertEquals('SUCCESS! Application has been created.', result);
        
        List<Id> caseIdsList = new List<Id>();
        caseIdsList.add(cs.Id);
        ExistingAdvisorFinalOfferCreator creator = new ExistingAdvisorFinalOfferCreator();
        ExistingAdvisorFinalOfferCreator.finalOfferCreation(caseIdsList);
        Test.stopTest();
        
    }
    
    static testMethod void validateFinalOfferCreation3() {
        loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = ConstantsCl.ACQUISITION_LOAN;
        INSERT clProduct;
        
        TestHelperCL.createGLcustomSetting();
        Contact c = TestHelperCL.createContact();
        c.RIA_Type__c = 'Hybrid';
        c.RIA_Firm_ID__c = c.Master_Rep_ID__c;
        UPDATE c;
        
        Case cs = new Case();
        cs.Interest_Rate__c = 10;
        cs.Loan_Amount__c = 50000;
        cs.ContactId = c.Id;
        cs.Term__c = 36;
        cs.Status = 'Final Review';
        cs.Case_Reason_Detail__c = ConstantsCl.ACQUISITION_LOAN;
        cs.Region__c='East';
        INSERT cs;
        
        Test.startTest();
        String result = CLSApplicationCreatorFromCase.createApplication(cs.Id);
        System.assertEquals('SUCCESS! Application has been created.', result);
        
        List<Id> caseIdsList = new List<Id>();
        caseIdsList.add(cs.Id);
        ExistingAdvisorFinalOfferCreator creator = new ExistingAdvisorFinalOfferCreator();
        ExistingAdvisorFinalOfferCreator.finalOfferCreation(caseIdsList);
        Test.stopTest();
        
    }
}