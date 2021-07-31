public with sharing class LPL_FinancialsTriggerHandler implements ITrigger{
    
    Map<Id, Financials__c> finMap = new Map<Id,Financials__c>();
    LPL_FinancialsTriggerGateway finGaty = new LPL_FinancialsTriggerGateway();
    
    Map<Id, Opportunity> conMap= new Map<Id,Opportunity>();
    public void bulkBefore()
    {
        // If this a delete trigger Cache a list of Account Id's that are 'in use'
        if (Trigger.isInsert || Trigger.isUpdate)
        {
            finMap = LPL_FinancialsTriggerGateway.findFinancialsRecInUse(Trigger.New); 
            //added by Subhash
            //Start 
            conMap = LPL_FinancialsTriggerGateway.findOpportunityInUse(finMap);  
            //End  
        }
    }
    
    public LPL_FinancialsTriggerHandler(){
    }
    
    public void bulkAfter(){}
        
    public void beforeInsert(SObject so){
        Financials__c myFin = (Financials__c)so; 
        finGaty.processFinancials(conMap,finMap);   
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Financials__c myFin = (Financials__c)so; 
        finGaty.processFinancials(conMap,finMap);   
    }
    
    public void beforeDelete(SObject so)
    {   
        // Cast the SObject to an Account
        //Account myAccount = (Account)so;
    }
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){}
    
    public void afterDelete(SObject so){}
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally(){}

}