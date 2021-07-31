trigger New_Trigger on Task (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    HandleTrigger.Run(new New_TaskTriggerHandler());
    
}