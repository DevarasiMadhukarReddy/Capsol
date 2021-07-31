global class Schedulable_Email_Task_weekly implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     
     Batch_Email_Tasks clsBatchItUpSon = new Batch_Email_Tasks ();
     ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);

      
    }
}