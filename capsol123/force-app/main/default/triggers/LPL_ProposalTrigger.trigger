trigger LPL_ProposalTrigger on Proposal_Offer__c(after delete, after insert, after update, before delete, before insert, before update) {
  HandleTrigger.Run(new New_ProposalTriggerHandler());
}