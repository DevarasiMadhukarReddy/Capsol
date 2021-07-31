global class SFA_Contact_Batch_Scheduable implements Schedulable {
    
     
    global void execute(SchedulableContext sc) {
                        
        SFA_Contact_Batch con=new SFA_Contact_Batch();
        Database.executeBatch(con,200); 
        
    }

}