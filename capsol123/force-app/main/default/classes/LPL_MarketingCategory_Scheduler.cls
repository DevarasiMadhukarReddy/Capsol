global class LPL_MarketingCategory_Scheduler implements Schedulable {
 global void execute(SchedulableContext sc) {
                        
        LPL_MarketingCategoryBatch con=new LPL_MarketingCategoryBatch();
        Database.executeBatch(con,200); 
        
    }

}