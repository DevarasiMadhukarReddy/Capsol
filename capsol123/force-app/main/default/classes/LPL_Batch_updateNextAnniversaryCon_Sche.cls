global class LPL_Batch_updateNextAnniversaryCon_Sche implements Schedulable {
    
     
    global void execute(SchedulableContext sc) {
                        
        LPL_Batch_updateNextAnniversaryOnContact con=new LPL_Batch_updateNextAnniversaryOnContact();
        Database.executeBatch(con,200); 
        
    }

}