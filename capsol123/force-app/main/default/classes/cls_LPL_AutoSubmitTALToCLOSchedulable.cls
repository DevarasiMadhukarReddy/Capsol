/*Schedulable class is for cls_LPL_AutoSubmitTALoanAppToCLO 
* Created By Bhanu 12/23/2020 CS-2516- Update TA application Offer Accepted Criteria.
*
*
*/
global class cls_LPL_AutoSubmitTALToCLOSchedulable implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
        
        cls_LPL_AutoSubmitTALoanAppToCLO con=new cls_LPL_AutoSubmitTALoanAppToCLO();
        Database.executeBatch(con,1); 
        
    }
    
}