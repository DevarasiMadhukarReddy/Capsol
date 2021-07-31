/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Scheduler Class for LPL_Opportunity_task_batch               Manila Agnihotri                    21 May 2018
                  to Schedule the batch on daily basis.                                 

*/
global class LPL_Opportunity_task_Sch implements Schedulable {

global void execute(SchedulableContext sc) {
                        
        LPL_Opportunity_task_batch con=new  LPL_Opportunity_task_batch();
        
        Database.executeBatch(con,200); 
        
    }
}