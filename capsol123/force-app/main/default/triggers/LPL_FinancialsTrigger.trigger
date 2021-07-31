trigger LPL_FinancialsTrigger on Financials__c(after delete, after insert, after update, before delete, before insert, before update)
{
    TriggerFactory.createHandler(Financials__c.sObjectType);
}