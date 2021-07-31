trigger LPL_CaseCommentTrigger on Case_Comments_J__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Case_Comments_J__c.SobjectType);
}