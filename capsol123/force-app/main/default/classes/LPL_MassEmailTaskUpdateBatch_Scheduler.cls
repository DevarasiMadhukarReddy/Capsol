global class LPL_MassEmailTaskUpdateBatch_Scheduler implements Schedulable{
	global void execute(SchedulableContext sc) {
      LPL_MassEmailTaskUpdateBatch batchjob =new LPL_MassEmailTaskUpdateBatch();
        Database.executeBatch(batchjob);        
    }
}