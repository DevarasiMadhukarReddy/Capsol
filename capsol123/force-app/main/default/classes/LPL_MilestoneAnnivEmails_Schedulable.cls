global class LPL_MilestoneAnnivEmails_Schedulable implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        
        Database.executeBatch(new LPL_MilestoneAnnivEmails_Batch(), 200); 
        
    }

}