global class LPL_Update_BSStatus_Batch_Sche implements Schedulable{
  
    global void execute(SchedulableContext sc){
        
        LPL_Update_BSStatus_Batch batch = new LPL_Update_BSStatus_Batch();
        Database.executeBatch(batch,200);
    }
}