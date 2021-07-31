global class LPL_Update_TotalAdvisoryAUM_Schedulable implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        LPL_Update_TotalAdvisoryAUM_Batch con=new LPL_Update_TotalAdvisoryAUM_Batch();
        Database.executeBatch(con,200); 
        
    }

}