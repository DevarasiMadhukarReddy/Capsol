/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Scheduler Class for LPL_contactLeadSourceUpdate_batch               Manila Agnihotri                    05 March 2018
                  to Schedule the batch on daily basis.                                 

*/
global class LPL_ContactLeadsourceUpdate_Scheduler implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        LPL_ContactLeadSourceUpdate_batch con=new  LPL_ContactLeadSourceUpdate_batch();
        
        Database.executeBatch(con,200); 
        
    }

}