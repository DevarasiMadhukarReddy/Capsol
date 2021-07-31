trigger LPL_ContactTrigger on Contact (after delete, after insert, after update, before delete, before insert, before update) {
    HandleTrigger.Run(new New_ContactTriggerHandler());
   /* Boolean isOff  = False;
   Trigger_Bypass__c triggerByPass =  Trigger_Bypass__c.getInstance('Contact');
    if(Trigger.isDelete){
   //     isOff = LPL_ContactTriggerGateway.triggerByPass(trigger.Old, false);        
    }
    else{
  //      isOff =  LPL_ContactTriggerGateway.triggerByPass(trigger.New, true);  
    }
    if(triggerByPass.isOff__c == False)
    {
        if(!isOff){
            
            // trigger start to execute -----------------------------------------------------------------------       
            
            if(trigger.isBefore && trigger.isInsert){
            //    LPL_ContactTriggerGateway.collectRecordToProcess(Trigger.New,Trigger.old);
             //   LPL_ContactTriggerGateway.executeIASLogic(Trigger.New, 'BEFORE_INSERT');
            //    LPL_OpportunityTriggerGateway.notrigger = false;
            }
            if(trigger.isBefore && trigger.isUpdate){
            //    LPL_ContactTriggerGateway.collectRecordToProcess(Trigger.New,Trigger.old);
             //   LPL_ContactTriggerGateway.setAtRiskLastModified(Trigger.New, Trigger.Old);
             //   LPL_ContactTriggerGateway.executeIASLogic(Trigger.New, 'BEFORE_UPDATE');
             //   LPL_OpportunityTriggerGateway.notrigger = false;  
            }
            if(trigger.isBefore && trigger.isDelete){
             //   LPL_OpportunityTriggerGateway.notrigger = false; 
            }
            if(trigger.isAfter && trigger.isInsert){
             //    LPL_ContactTriggerGateway.updateProgramManagerOnAccount(Trigger.new,null, false);
            }            
            if(trigger.isAfter && trigger.isUpdate){
             //   LPL_ContactTriggerGateway.collectRecordToProcess(Trigger.New,trigger.old);
             //   LPL_ContactTriggerGateway.callChangeEloquaEmailAddress(Trigger.New, Trigger.Old);
             //   LPL_ContactTriggerGateway.updateContactOpportunities();
            //    LPL_ContactTriggerGateway.updateLostOutcomesOnOpty();
             //   LPL_ContactTriggerGateway.updateProgramManagerOnAccount(Trigger.new,Trigger.old, false);
            }
            if(trigger.isAfter && trigger.isDelete){
             //   LPL_ContactTriggerGateway.updateContactCountOnAccount(Trigger.Old);
             //   LPL_ContactTriggerGateway.updateProgramManagerOnAccount(null,Trigger.old,true); 
            }
        }
    }*/
}