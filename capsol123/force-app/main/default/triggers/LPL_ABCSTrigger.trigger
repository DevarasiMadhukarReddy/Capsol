trigger LPL_ABCSTrigger on ABCS_Sales__c (after delete, after insert, after update, before delete, before insert, before update) {

TriggerFactory.createHandler(ABCS_Sales__c.sObjectType);

}