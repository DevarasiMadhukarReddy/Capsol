global class SFA_MarketingActivityUpdate_Scheduable implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        SFA_MarketingCategoryUpdate_batch con=new SFA_MarketingCategoryUpdate_batch();
        Database.executeBatch(con,200); 
        
    }

}