/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Scheduler Class for LPL_Account_to_Contact_Update_batch             Manila Agnihotri                    27 April 2018
                to Schedule the batch on daily basis.                             

*/
global class LPL_Account_to_Contact_Update_scheduler implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        LPL_Account_to_Contact_Update_batch con=new  LPL_Account_to_Contact_Update_batch();
        
        Database.executeBatch(con,200); 
        
    }

}