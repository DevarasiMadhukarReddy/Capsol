trigger LBS_OpportunityProductLineItemTrigger on OpportunityLineItem (after insert, after delete) {    
    HandleTrigger.Run(new LBS_OpportunityProductTriggerhandler());
}