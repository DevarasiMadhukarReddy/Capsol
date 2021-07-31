@isTest
private class TestBaqToAppicationTriggerHandlerCL {
    static testMethod void validateAfterUpdateHandler() {
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
        
        baq.AUM_Separately_Managed_Accounts__c = 1000;
        baq.AUM_Mutual_Funds__c = 1000;
        baq.AUM_RP_Assets_BOR_Brokerage__c = 100;
        baq.AUM_TAMPs_or_3rd_Party__c = 100;
        baq.AUM_RP_Assets_BOR_Brokerage__c = 100;
        
        baq.Affiliation_1__c = 'Hybrid';
        baq.Branch_1__c = 'In Branch';
        baq.OSJ_LE_1__c = 'Test OSJ2';
        
        baq.Affiliation_2__c = 'Corp';
        baq.Branch_2__c = 'HOS';
        baq.OSJ_LE_2__c = 'Test OSJ1';
        
        baq.Affiliation_3__c = 'Hybrid';
        baq.Branch_3__c = 'In Branch';
        baq.OSJ_LE_3__c = 'Test OSJ3';
        
        baq.Affiliation_3__c = 'Hybrid';
        baq.Branch_3__c = 'In Branch';
        baq.OSJ_LE_3__c = 'Test OSJ3';
        
        baq.Affiliation_4__c = 'Hybrid';
        baq.Branch_4__c = 'In Branch';
        baq.OSJ_LE_4__c = 'Test OSJ3';
        
        baq.Affiliation_5__c = 'Hybrid';
        baq.Branch_5__c = 'In Branch';
        baq.OSJ_LE_5__c = 'Test OSJ3';
        
        baq.Affiliation_6__c = 'Hybrid';
        baq.Branch_6__c = 'In Branch';
        baq.OSJ_LE_6__c = 'Test OSJ3';
        
        UPDATE baq;
        Test.stopTest();
    }
    
    static testMethod void validateAfterUpdateHandlerWithNewAffiliation() {
        Contact c = TestHelperCL.createContact();
        c.Lead_Source__c ='Transitions';
        c.Source_Type_Prospect__c ='Transitions';
        update c;
        Opportunity opp = TestHelperCL.createOpportunity();
        
        BAQ__c baq = new BAQ__c();
        baq.Name = 'Test BAQ';
        baq.Contact__c = c.Id;
        baq.Opportunity__c = opp.Id;
        baq.Current_Custodian__c = 'Test Custodian';
        baq.Joining_RIA_or_Corporate__c = 'Corporate';
        baq.Number_of_Advisors__c = 5;
        baq.AUM_SAM_SWM__c = 1000;
        baq.AUM_Mutual_Funds__c = 1000;
        baq.GDC_Mutual_Funds__c = 1000;
        
        INSERT baq;
        
        opp.BAQ__c = baq.Id;
        UPDATE opp;
        
        Test.startTest();
        String result = ApplicationCreator.createApplication(opp.Id);
        System.assertEquals(ConstantsCl.APPLICATION_CREATION_SUCCESS_MSG, result);
        
        baq.AUM_Separately_Managed_Accounts__c = 1000;
        baq.AUM_Mutual_Funds__c = 1000;
        baq.AUM_Variable_Annuities__c = 100;
        baq.AUM_RP_Assets_BOR_Brokerage__c = 100;
        baq.AUM_TAMPs_or_3rd_Party__c = 100;
        baq.AUM_RP_Assets_BOR_Brokerage__c = 100;
        
        baq.Affiliation_1__c = 'Hybrid';
        baq.Branch_1__c = 'In Branch';
        baq.OSJ_LE_1__c = 'Test OSJ2';
        
        baq.Affiliation_2__c = 'Corp';
        baq.Branch_2__c = 'In Branch';
        baq.OSJ_LE_2__c = 'Test OSJ1';
        
        baq.Affiliation_3__c = 'Hybrid';
        baq.Branch_3__c = 'In Branch';
        baq.OSJ_LE_3__c = 'Test OSJ3';
        
        baq.Affiliation_3__c = 'Hybrid';
        baq.Branch_3__c = 'In Branch';
        baq.OSJ_LE_3__c = 'Test OSJ3';
        
        baq.Affiliation_4__c = 'Hybrid';
        baq.Branch_4__c = 'In Branch';
        baq.OSJ_LE_4__c = 'Test OSJ3';
        
        baq.Affiliation_5__c = 'Hybrid';
        baq.Branch_5__c = 'In Branch';
        baq.OSJ_LE_5__c = 'Test OSJ3';
        
        baq.Affiliation_6__c = 'Hybrid';
        baq.Branch_6__c = 'In Branch';
        baq.OSJ_LE_6__c = 'Test OSJ3';
        
        UPDATE baq;
        Test.stopTest();
    }
}