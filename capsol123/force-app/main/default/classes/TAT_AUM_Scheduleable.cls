global class TAT_AUM_Scheduleable implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        LPL_Contact_TAT_AUM_Batch con=new LPL_Contact_TAT_AUM_Batch();
        Database.executeBatch(con,200); 
        
    }

}