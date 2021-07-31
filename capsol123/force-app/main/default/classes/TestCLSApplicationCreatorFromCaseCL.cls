@isTest
private class TestCLSApplicationCreatorFromCaseCL {
    static testMethod void validateCreateApplication() {
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
        cs.Case_Reason_Detail__c = 'Growth Loan';
        cs.Region__c='East';
        INSERT cs;
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'Growth Loan';
        INSERT clProduct;
        
        
        Test.startTest();
        String result = CLSApplicationCreatorFromCase.createApplication(cs.Id);
        System.assertEquals('SUCCESS! Application has been created.', result);
        Test.stopTest();
    }
    
    static testMethod void validateCreateApplication2() {
        Contact c = TestHelperCL.createContact();
        c.RIA_Type__c = 'Hybrid';
        c.RIA_Firm_ID__c = '007';
        UPDATE c;
        
        Case cs = new Case();
        cs.Interest_Rate__c = 10;
        cs.Loan_Amount__c = 50000;
        cs.ContactId = c.Id;
        cs.Term__c = 36;
        cs.Status = 'Final Review';
        cs.Case_Reason_Detail__c = 'Growth Loan';
        cs.Region__c='East';
        INSERT cs;
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'Growth Loan';
        INSERT clProduct;
        
        
        Test.startTest();
        String result = CLSApplicationCreatorFromCase.createApplication(cs.Id);
        
        //System.assertEquals('Error in creating an application. No RIA Firm ID matches with Master Rep Id in Contact', result);
        Test.stopTest();
        
    }
}