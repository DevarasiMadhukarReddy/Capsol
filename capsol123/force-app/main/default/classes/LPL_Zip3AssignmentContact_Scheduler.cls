global class LPL_Zip3AssignmentContact_Scheduler implements Schedulable{
	global void execute(SchedulableContext sc) {
      
        LPL_Zip3AssignmentContact_Batch batchjob =new LPL_Zip3AssignmentContact_Batch();
        Database.executeBatch(batchjob);        
    }
}