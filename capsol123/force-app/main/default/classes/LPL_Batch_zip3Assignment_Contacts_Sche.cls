global class LPL_Batch_zip3Assignment_Contacts_Sche implements Schedulable{
    
    global void execute(SchedulableContext sc) {
                        
        LPL_Batch_zip3Assignment_Contacts batch=new LPL_Batch_zip3Assignment_Contacts();
        Database.executeBatch(batch,200); 
        
    }
}