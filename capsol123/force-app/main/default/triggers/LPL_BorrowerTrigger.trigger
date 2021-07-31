trigger LPL_BorrowerTrigger on Borrowers__c (after delete, after insert, after update, before delete, before insert, before update) {
  HandleTrigger.Run(new New_BorrowerTriggerHandler());
}