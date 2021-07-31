trigger LPL_EventTrigger on Event (before insert, before update, before delete, after insert, after update , after delete) {
         HandleTrigger.Run(new New_EventTriggerHandler());
}