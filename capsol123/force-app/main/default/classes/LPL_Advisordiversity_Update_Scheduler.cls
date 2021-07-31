/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Scheduler Class for LPL_Advisordiversity_Update_batch               Manila Agnihotri                    25 may 2018
                  to Schedule the batch only once.                                 

*/
global class LPL_Advisordiversity_Update_Scheduler implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
                        
        LPL_Advisordiversity_Update_batch Adv=new  LPL_Advisordiversity_Update_batch();
        
        Database.executeBatch(Adv,200); 
        
    }

}