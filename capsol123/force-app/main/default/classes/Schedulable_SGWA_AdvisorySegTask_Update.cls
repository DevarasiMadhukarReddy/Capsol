global class Schedulable_SGWA_AdvisorySegTask_Update  implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     
     Batch_SGWA_AdvisorySegTask_Update clsBatchSGWA = new Batch_SGWA_AdvisorySegTask_Update ();
     ID idBatch = Database.executeBatch(clsBatchSGWA , 200);

      
    }
}