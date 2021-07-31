global class LPL_TimeTradeReminderEmail_Scheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        LPL_TimeTradeReminderEmail_Batch batchCon = new  LPL_TimeTradeReminderEmail_Batch();
        Database.executeBatch(batchCon,1); 
    }
}