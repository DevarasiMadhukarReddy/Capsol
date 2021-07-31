global class Schedulable_Branch_Financial_Yearly implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     
     Batcher_Branch_Financial_Yearly clsBatchItUpSon = new Batcher_Branch_Financial_Yearly ();
     ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);

      
    }
}