trigger LPL_RelatedTrigger on Related__c (before insert, after insert, after update, after delete) {
    
    LPL_RelatedTriggerGateway relGt = new LPL_RelatedTriggerGateway();
    if(Trigger.isAfter && Trigger.isInsert){
        relGt.updateProgramManagerOnAccountRel(trigger.new, null, false);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        relGt.updateProgramManagerOnAccountRel(trigger.new, trigger.old, false);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        relGt.updateProgramManagerOnAccountRel(null, trigger.old, true);
    }
    
}