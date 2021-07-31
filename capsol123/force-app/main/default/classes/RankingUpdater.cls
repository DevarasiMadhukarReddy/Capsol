public class RankingUpdater {
    @InvocableMethod
    public static void updateRanking(List<Id> applicationIds)
    {
        List<genesis__Applications__c> appList =[SELECT id, GP_ROA__c, 
                                                Ranking_Dependent_BAQ_Fields_Total__c, Ranking__c 
                                                FROM genesis__Applications__c 
                                                WHERE Id IN :applicationIds];
        if(appList != null && appList.size() > 0) {
            List<genesis__Applications__c> appsToUpdate = new List<genesis__Applications__c>();
            for(genesis__Applications__c app : appList) {
                String bucketType = '';
                if(app.Ranking_Dependent_BAQ_Fields_Total__c != null && app.Ranking_Dependent_BAQ_Fields_Total__c <= 2000000) {
                    /* Selection criteria is CORE */
                    bucketType = 'Core';
                } else if(app.Ranking_Dependent_BAQ_Fields_Total__c != null && app.Ranking_Dependent_BAQ_Fields_Total__c > 2000000) {
                    /* Selection criteria is Master */
                    bucketType = 'Master';
                }
                List<cls_PayOff_Grid__c> grid = [SELECT Id, Name, Type__c, Ranking__c, Min_Gross_Profit__c, Max_Gross_Profit__c FROM cls_PayOff_Grid__c WHERE Type__c = :bucketType AND Min_Gross_Profit__c <= :app.GP_ROA__c AND Max_Gross_Profit__c > :app.GP_ROA__c];
                if(grid != null && grid.size() > 0) {
                    app.Ranking__c = grid[0].Ranking__c;
                    appsToUpdate.add(app);
                }
            }
            
            if(appsToUpdate.size() > 0) {
                UPDATE appsToUpdate;
            }
        }
   }
}