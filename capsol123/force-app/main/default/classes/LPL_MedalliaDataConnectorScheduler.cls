global class LPL_MedalliaDataConnectorScheduler Implements System.Schedulable {
    global void execute(SchedulableContext sc)
    {
        LPL_MedalliaDataConnectorBatch batch = New LPL_MedalliaDataConnectorBatch();
        Database.executeBatch(batch);
    }
}