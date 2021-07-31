global class LPL_Batch_Last_BC_Date_Enterprise_Sche implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        LPL_Batch_Last_BC_Date_Enterprise acc = new  LPL_Batch_Last_BC_Date_Enterprise();
        
        Database.executeBatch(acc,200); 
        
    }

}