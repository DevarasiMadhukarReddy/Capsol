@isTest
private class TestApplicationCreatorCL {
    static testMethod void validateCreateApplication() {
        Contact c = TestHelperCL.createContact();
        c.Lead_Source__c ='Transitions';
        c.Source_Type_Prospect__c ='Transitions';
        update c;
        Opportunity opp = TestHelperCL.createOpportunity();
        BAQ__c baq = TestHelperCL.createBAQ(c, opp);
        
        opp.BAQ__c = baq.Id;
        UPDATE opp;
        
        Test.startTest();
        String result = ApplicationCreator.createApplication(opp.Id);
        System.assertEquals(ConstantsCl.APPLICATION_CREATION_SUCCESS_MSG, result);
        Test.stopTest();
    }
    
    static testMethod void errorValidateCreateApplication() {
        Contact c = TestHelperCL.createContact();
        c.Lead_Source__c ='Transitions';
        c.Source_Type_Prospect__c ='Transitions';
        update c;
        Opportunity opp = TestHelperCL.createOpportunity();
        BAQ__c baq = TestHelperCL.createBAQ(c, opp);
        
        opp.BAQ__c = baq.Id;
        UPDATE opp;
        
        Test.startTest();
        String result = ApplicationCreator.createApplication(null);
        System.assertEquals(ConstantsCl.APPLICATION_CREATION_MISSING_FIELDS_MSG, result);
        Test.stopTest();
    }
}