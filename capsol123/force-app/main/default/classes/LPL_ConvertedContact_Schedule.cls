global class LPL_ConvertedContact_Schedule  implements Schedulable {
    global void execute(SchedulableContext sc) {
        LPL_ConvertedContactUpdate_Batch batch = new  LPL_ConvertedContactUpdate_Batch();
        Database.executeBatch(batch,200);
    }
}