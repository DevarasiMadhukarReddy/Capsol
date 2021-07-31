public with sharing class LPL_AccountConRelationTriggerHandler implements ITrigger{
    
    LPL_AccountConRelationTriggerGateway aconGatewy = new LPL_AccountConRelationTriggerGateway();
    public LPL_AccountConRelationTriggerHandler(){}
    
    public void bulkBefore(){}
    public void beforeInsert(SObject so){}
    
    public void beforeUpdate(SObject oldSo, SObject so){}
    
    public void beforeDelete(SObject so){}
    
    public void bulkAfter(){
        if(Trigger.isUpdate|| Trigger.isInsert){
            aconGatewy.collectRecordToProcess(Trigger.New);
        } 
        if(Trigger.isDelete){
            aconGatewy.collectRecordToProcess(Trigger.Old);
        } 
    }
    public void afterInsert(SObject so){
        AccountContactRelation acr = (AccountContactRelation)so;
        if(acr.IsDirect == false){
            aconGatewy.handleContactUpdate();
        }
        aconGatewy.addContactCount();
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        AccountContactRelation acr = (AccountContactRelation)so;
        AccountContactRelation oldAcr = (AccountContactRelation)oldSo;
        if(acr.IsDirect == false){
            aconGatewy.handleContactUpdate();
        }
    }
    public void afterDelete(SObject so){System.debug('Ins delete');
        aconGatewy.reduceCountAccountContactRelationship(Trigger.Old);
    }
    public void andFinally(){
        aconGatewy.processFinally();
    }
}