global class LPL_Last_BC_Contact_Date_Batch_Scheduler  implements Schedulable{
     global void execute(SchedulableContext sc) {
        
        
     LPL_Last_BC_Contact_Date_Batch batchjob =new LPL_Last_BC_Contact_Date_Batch();
        Database.executeBatch(batchjob);        
    }

}