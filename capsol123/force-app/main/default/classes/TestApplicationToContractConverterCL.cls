@isTest
private class TestApplicationToContractConverterCL {
    static testMethod void validateConvertToCLContract() {
        loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'Repayable';
        INSERT clProduct;
        
        clcommon__CL_Product__c clProduct2 = new clcommon__CL_Product__c();
        clProduct2.clcommon__Product_Name__c = 'Forgivable';
        INSERT clProduct2;
        
        TestHelperCL.createGLcustomSetting();
        Contact c = TestHelperCL.createContact();
        c.Lead_Source__c ='Transitions';
        c.Source_Type_Prospect__c ='Transitions';
        update c;
        Opportunity opp = TestHelperCL.createOpportunity();
        
        opp.Credit_To_Rep__c = 1000;
        opp.Credit_to_OSJ__c = 1000;
        opp.Credit_to_Non_OSJ_Advisor__c = 1000;
        opp.Referral_Fee__c = 1000;
        UPDATE opp;
        
        BAQ__c baq = TestHelperCL.createBAQ(c, opp);
        opp.BAQ__c = baq.Id;
        UPDATE opp;
        
        Test.startTest();
        String result = ApplicationCreator.createApplication(opp.Id);
        System.assertEquals(ConstantsCl.APPLICATION_CREATION_SUCCESS_MSG, result);
        
        List<genesis__Applications__c> parentAppList = [SELECT Id, Name, Application_Type__c, 
                                                        Final_Offer__c, Note_Length__c, TA_Amount__c, genesis__parent_application__c, Approved_Name__c
                                                        FROM genesis__Applications__c 
                                                        WHERE isParentApplication__c = true LIMIT 1];
        
        List<genesis__Applications__c> childAppList = [SELECT Id, Name, Application_Type__c, 
                                                       Final_Offer__c, Note_Length__c, TA_Amount__c, genesis__parent_application__c
                                                       FROM genesis__Applications__c 
                                                       WHERE isParentApplication__c = false AND Application_Type__c != :ConstantsCl.REPAYABLE_LOAN LIMIT 1];
        
        if(parentAppList != null) {
            genesis__Applications__c pApp = parentAppList.get(0);
            pApp.Approved__c = true;
            pApp.Approved_Name__c = UserInfo.getName();
            UPDATE pApp;
        }
        
        List<Id> parentAppID = new List<Id>();
        genesis__Applications__c app;
        if(childAppList != null) {
            app = childAppList.get(0);
            parentAppID.add(app.genesis__parent_application__c);
            app.Application_Type__c = ConstantsCl.REPAYABLE_LOAN;
            app.genesis__Loan_Amount__c = 10000;
            app.genesis__Term__c = 36;
            app.genesis__Interest_Rate__c = 9;
            app.TA_Amount__c = 10000;
            app.Final_Offer__c = true;
            UPDATE app;
        }
        ApplicationToContractConverter.convertToCLContract(app.Id, app.Application_Type__c, String.valueOf(app.genesis__Interest_Rate__c));
        Test.stopTest();
    }
}