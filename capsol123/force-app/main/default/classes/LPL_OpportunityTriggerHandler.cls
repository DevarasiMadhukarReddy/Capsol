/*
##############Change History#############
CH.No       Description                                         Developer           Date
--------------------------------------------------------------------------------------------
CH-01      Commented handleTotalAdvisoryAUM method             Vaibhav Wadhai       14 june 2017
(Used Batch class for this )
Batch Class Name:LPL_Update_TotalAdvisoryAUM_Batch
CH-02      Added boolean to avoid 101 SOQL            Manila Agnihotri       16 May 2018
*/
public class LPL_OpportunityTriggerHandler implements iTrigger{
    
    Schema.DescribeSObjectResult oppRecDesc = Schema.SObjectType.Opportunity;
    LPL_OpportunityTriggerGateway oppGateWay = new LPL_OpportunityTriggerGateway();
    
    Map<String,Schema.RecordTypeInfo> rtMapByName = oppRecDesc.getRecordTypeInfosByName();
    
    ID oppRIAID = rtMapByName.get('RIA Compliance ADVantage').getRecordTypeId();
    ID oppInsuranceID = rtMapByName.get('AIS Insurance Sales').getRecordTypeId();
    Id IASBD = rtMapByName.get('IAS Business Development').getRecordTypeId();
    
    List<Opportunity> newOpp1 = new List<Opportunity>();
    Map<ID, Opportunity> oldMap = new Map<ID, Opportunity>();
    Map<ID, Opportunity> newMap= new Map<ID, Opportunity>();
    public static Boolean Flag =true; //CH-02
    public static Boolean FinallyOnce = true;
    public static Boolean finallyBulkAfter = true;
    
    public void bulkBefore(){
        if(!Trigger.isDelete){
            oppGateWay.collectRecordToProcess(Trigger.New, null);
        }else{
            oppGateWay.collectRecordToProcess(Trigger.old, null);
        }
        
    }
    public void beforeInsert(SObject so){
        Opportunity newOpp = (Opportunity)so;
        if(newOpp.Contact__c != null && newOpp.RecordTypeId ==IASBD){
            oppGateWay.checkValidation(newOpp);
        }
        system.debug('Inside this now:::');
        oppGateWay.doInsertOperation(newOpp);
        
    }
    public void beforeUpdate(SObject oldSo, SObject so){
        Opportunity newOpp = (Opportunity)so;
        Opportunity oldOpp = (Opportunity)oldSo;
        oppGateWay.doUpdateOperation(newOpp, oldOpp);
        oppGateWay.prepareUpdateOppOperation(newOpp, oldOpp, true);
    }
    public void beforeDelete(SObject so){}
    
    public void bulkAfter(){
        try{
            Map<Id, opportunity> oppMap = new Map<Id, Opportunity>();
            List<Opportunity> oldOppList = Trigger.Old;
            if(oldOppList != null){
                for(Opportunity opp : oldOppList){
                    oppMap.put(opp.Id, Opp);
                }
            }
            if(finallyBulkAfter){
                finallyBulkAfter = false;
                if(!Trigger.isDelete){
                    oppGateWay.collectRecordToProcess(Trigger.New, oppMap);
                }else{
                    oppGateWay.collectRecordToProcess(Trigger.Old, oppMap);
                }
            }
        }
        Catch(exception e){
        } 
    }
    
    public void afterInsert(SObject so){
        Opportunity newOpp = (Opportunity)so;
        newOpp1.add(newOpp);
        oldMap= null;
        oppGateWay.doAfterInsertActivity(newOpp);
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        Opportunity newOpp = (Opportunity)so;
        Opportunity oldOpp = (Opportunity)oldSo;
        newOpp1.add(newOpp);
        oldMap.put(oldOpp.Id, oldOpp);
        newMap.put(newOpp.Id, newOpp);
        oppGateWay.FinalOfferStatusTrigger(newMap,oldMap);
        //CH-02 start
        if(Flag){
            Flag = false;
            oppGateWay.prepareUpdateOppOperation(newOpp, oldOpp, true);
        }
        //CH-02 end
    }
    public void afterDelete(SObject so){}
    
    public void andFinally(){
        if(FinallyOnce){
            FinallyOnce  = false;
            oppGateWay.processFinallyOperations();             
        }
        if(Opportunity_EmailHandler.Recursive){
            oppGateWay.handleEmailOperation(newOpp1, oldMap, True);
        }
    }
}