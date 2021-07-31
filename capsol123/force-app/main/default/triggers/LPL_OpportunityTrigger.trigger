/*
##############Change History#############
CH.No       Description                                              Developer         Date
------------------------------------------------------------------------------------------------
       User Story LBSFNS-226 Promo Codes on Opportunity              Anil Mannuru      06/28/2021
        Commented restrictMultipleOpties()-LBS Deployment             Indrasen         07/08/2021
        
*/

trigger LPL_OpportunityTrigger on Opportunity (before insert, before update, before delete,after insert, after update , after delete) {   
    HandleTrigger.Run(new New_Opportunity_TriggerHandler());
    
    if(trigger.isbefore && trigger.isinsert){
       // LPL_TriggerOpp_Helper.restrictMultipleOpties (trigger.new);
    }
    
    if(trigger.isBefore && trigger.isUpdate && LPL_TriggerOpp_Helper.runOnce){        
        LPL_TriggerOpp_Helper.updateOpportunityAccounts(trigger.new,trigger.oldmap);
    }    
    
    if (trigger.isAfter && trigger.isUpdate && LPL_TriggerOpp_Helper.runOnce) {
        
        LPL_TriggerOpp_Helper.OpportunityCreateandUpdate(trigger.new,trigger.Newmap,trigger.oldmap);
        LPL_TriggerOpp_Helper.OpportunityCreateandUpdateReverse(trigger.new,trigger.newmap,trigger.oldmap);
        //User Story LBSFNS-226 Promo Codes on Opportunity
        LPL_TriggerOpp_Helper.processPromoCode(trigger.new,trigger.oldmap);

    }   
}