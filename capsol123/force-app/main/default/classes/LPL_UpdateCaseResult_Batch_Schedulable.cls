global class LPL_UpdateCaseResult_Batch_Schedulable implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        LPL_UpdateCaseResult_Batch con=new LPL_UpdateCaseResult_Batch();
        
        Database.executeBatch(con,200); 
        
    }

}