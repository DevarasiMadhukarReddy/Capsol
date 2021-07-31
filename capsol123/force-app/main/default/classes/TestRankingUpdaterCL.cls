@isTest
private class TestRankingUpdaterCL {
    static testMethod void validateUpdateRanking() {
        genesis__applications__c app = new genesis__applications__c();
        app.genesis__Loan_Amount__c = 1000;
        app.Ranking_Dependent_BAQ_Fields_Total__c = 900;
        INSERT app;
        
        List<Id> appList = new List<Id>();
        appList.add(app.Id);
        
        List<cls_PayOff_Grid__c> payoffList = new List<cls_PayOff_Grid__c>();
        cls_PayOff_Grid__c grid1 = new cls_PayOff_Grid__c();
        grid1.Name = 'Grid1';
        grid1.Max_Gross_Profit__c = 23.99;
        grid1.Min_Gross_Profit__c = 0;
        grid1.Ranking__c = 'Low';
        grid1.Type__c = 'Core';
        payoffList.add(grid1);
        
        cls_PayOff_Grid__c grid2 = new cls_PayOff_Grid__c();
        grid2.Name = 'Grid2';
        grid2.Max_Gross_Profit__c = 25;
        grid2.Min_Gross_Profit__c = 20;
        grid2.Ranking__c = 'Medium';
        grid2.Type__c = 'Masters';
        payoffList.add(grid2);
        
        cls_PayOff_Grid__c grid3 = new cls_PayOff_Grid__c();
        grid3.Name = 'Grid3';
        grid3.Max_Gross_Profit__c = 29;
        grid3.Min_Gross_Profit__c = 24;
        grid3.Ranking__c = 'Medium';
        grid3.Type__c = 'Core';
        payoffList.add(grid3);
        
        INSERT payoffList;
        RankingUpdater.updateRanking(appList);
        
    }
    
    static testMethod void validateUpdateRanking2() {
        genesis__applications__c app = new genesis__applications__c();
        app.genesis__Loan_Amount__c = 1000;
        app.Ranking_Dependent_BAQ_Fields_Total__c = 2000001;
        INSERT app;
        
        List<Id> appList = new List<Id>();
        appList.add(app.Id);
        
        List<cls_PayOff_Grid__c> payoffList = new List<cls_PayOff_Grid__c>();
        cls_PayOff_Grid__c grid1 = new cls_PayOff_Grid__c();
        grid1.Name = 'Grid1';
        grid1.Max_Gross_Profit__c = 23.99;
        grid1.Min_Gross_Profit__c = 0;
        grid1.Ranking__c = 'Low';
        grid1.Type__c = 'Core';
        payoffList.add(grid1);
        
        cls_PayOff_Grid__c grid2 = new cls_PayOff_Grid__c();
        grid2.Name = 'Grid2';
        grid2.Max_Gross_Profit__c = 25;
        grid2.Min_Gross_Profit__c = 20;
        grid2.Ranking__c = 'Medium';
        grid2.Type__c = 'Masters';
        payoffList.add(grid2);
        
        cls_PayOff_Grid__c grid3 = new cls_PayOff_Grid__c();
        grid3.Name = 'Grid3';
        grid3.Max_Gross_Profit__c = 29;
        grid3.Min_Gross_Profit__c = 24;
        grid3.Ranking__c = 'Medium';
        grid3.Type__c = 'Core';
        payoffList.add(grid3);
        
        INSERT payoffList;
        RankingUpdater.updateRanking(appList);
        
    }
}