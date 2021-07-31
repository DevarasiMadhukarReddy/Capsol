@isTest
private class TestCls_UpdateDateandUserCL {
    static testMethod void validateUpdateDateandUser() {
        loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        Contact c = TestHelperCL.createContact();
        c.Lead_Source__c='Transitions';
        c.Source_Type_Prospect__c = 'Transitions';
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
        
        List<genesis__Applications__c> parentAppList = [SELECT Id, Name, Application_Type__c, Approved__c,
                                                        Final_Offer__c, Note_Length__c, TA_Amount__c, genesis__parent_application__c, Approved_Name__c
                                                        FROM genesis__Applications__c 
                                                        WHERE isParentApplication__c = true LIMIT 1];
        
        if(parentAppList != null) {
            genesis__Applications__c pApp = parentAppList.get(0);
            pApp.Approved__c = true;
            UPDATE pApp;
        }
        
        List<Id> appList = new List<Id>();
        appList.add(parentAppList.get(0).Id);
        Cls_UpdateDateandUser.updateDateandUser(appList);
        
        Test.stopTest();
    }
    
    static testMethod void validateUpdateDateandUser2() {
        loan.TestHelper.createSeedDataForTesting();
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        Contact c = TestHelperCL.createContact();
        c.Lead_Source__c='Transitions';
        c.Source_Type_Prospect__c = 'Transitions';
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
        
        List<genesis__Applications__c> parentAppList = [SELECT Id, Name, Application_Type__c, Guidance__c, Deffered_Repayable_Approved__c,
                                                        Final_Offer__c, Note_Length__c, TA_Amount__c, genesis__parent_application__c, Approved_Name__c
                                                        FROM genesis__Applications__c 
                                                        WHERE isParentApplication__c = true LIMIT 1];
        
        if(parentAppList != null) {
            genesis__Applications__c pApp = parentAppList.get(0);
            pApp.Guidance__c = true;
            pApp.Deffered_Repayable_Approved__c = true;
            UPDATE pApp;
        }
        
        List<Id> appList = new List<Id>();
        appList.add(parentAppList.get(0).Id);
        Cls_UpdateDateandUser.updateDateandUser(appList);
        
        Test.stopTest();
    }
}