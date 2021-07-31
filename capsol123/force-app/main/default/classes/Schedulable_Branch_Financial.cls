global class Schedulable_Branch_Financial implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     
     Batcher_Branch_Financial clsBatchItUpSon = new Batcher_Branch_Financial ();
     ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);

      
    }
}