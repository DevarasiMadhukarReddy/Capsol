trigger LPL_CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if(!LPL_UpdateCaseResult_Batch.stopCaseTrigger &&!LPL_OpportunityTriggerGateway.stopCaseTrigTAUpdate) {
        
        TriggerFactory.createHandler(Case.SobjectType);
        
    }
}