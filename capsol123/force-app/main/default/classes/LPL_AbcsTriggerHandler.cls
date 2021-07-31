public with sharing class LPL_AbcsTriggerHandler implements ITrigger{

    List<Financials__c> lstFinancials= new List<Financials__c>();
    
    LPL_AbcsTriggerGateway abcsTrigGateway = new LPL_AbcsTriggerGateway();      
    
    public LPL_AbcsTriggerHandler(){}
    public void bulkBefore(){
        if(Trigger.isInsert)
        abcsTrigGateway.collectRecordToProcess(Trigger.new);
    
    }
    
    public void beforeInsert(SObject so){
    
        //lstFinancials = abcsTrigGateway.doInsertOperation(); // Moved to AndFinally() due to duplicate Financials records in the list   
    
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){}
    public void beforeDelete(SObject so){}
    public void bulkAfter(){}
    public void afterInsert(SObject so){}
    public void afterUpdate(SObject oldSo, SObject so){}
    public void afterDelete(SObject so){}
    
    public void andFinally(){
    
        lstFinancials = abcsTrigGateway.doInsertOperation();  
        if(!lstFinancials .isEmpty())
        update lstFinancials;
        
    }

 
}