global class Lpl_Oppty_Aggregate_Data_Schedulable implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        Lpl_Oppty_Open_Aggregate_Data_Batch batch=new Lpl_Oppty_Open_Aggregate_Data_Batch();
        Database.executeBatch(batch,200); 
        
    }

}