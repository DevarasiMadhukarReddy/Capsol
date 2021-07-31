global class LPL_AccountToContactAssociation_Schedule implements Schedulable {
    global void execute(SchedulableContext sc) {
                        
        LPL_AccountToContactAssociation_Batch batch = new  LPL_AccountToContactAssociation_Batch();
        
        Database.executeBatch(batch,200);
        
    }

}