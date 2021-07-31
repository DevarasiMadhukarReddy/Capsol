global class LPL_Batch_Delete_Pardot_Contacts_Sche implements Schedulable {
    
     
    global void execute(SchedulableContext sc) {
                        
        LPL_Batch_Delete_Pardot_Contacts con=new LPL_Batch_Delete_Pardot_Contacts();
        Database.executeBatch(con,200); 
        
    }

}