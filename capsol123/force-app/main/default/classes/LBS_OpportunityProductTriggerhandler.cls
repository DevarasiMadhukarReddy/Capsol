/*
Class Name              :LBS_OpportunityProductTriggerhandler
Description             :Hanndler Class for LBS_OpportunityProductLineItemTrigger

Developer Name          : Rajnarayanan R
Created Date            : 23/6/2021 
*/
public class LBS_OpportunityProductTriggerhandler implements BaseTriggerHandler{
    public Boolean IsDisabled()
    {
        return false;
    }
    
    /******* Trigger Methods **********/
    public void BeforeInsert(List<SObject> newItems){}
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
    
    public void BeforeDelete(Map<Id, SObject> oldItems){}
    
    public void AfterInsert(Map<Id, SObject> newItems){
        LBS_OpportunityProductTriggerhandler.updateOpportunityLineItem((Map<ID,OpportunityLineItem>)trigger.newMap);
        //LBS_OpportunityProductTriggerhandler.applyOppPromoCode((List<OpportunityLineItem>) trigger.new);
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
    
    public void AfterDelete(Map<Id, SObject> oldItems){
        LBS_OpportunityProductTriggerhandler.updateOpportunityLineItem((Map<ID,OpportunityLineItem>)trigger.oldMap);
    }
    
    public void AfterUndelete(Map<Id, SObject> oldItems){}
    
    /***** Trigger Method Execution ****/
    public static void updateOpportunityLineItem(Map<Id,OpportunityLineItem> oppLineItemsMap){
        Id busSolRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        Set<Id> oppIds = new Set<Id>();
        for(OpportunityLineItem lineItem : oppLineItemsMap.values()){
            if(!oppIds.contains(lineItem.OpportunityId)){
                oppIds.add(lineItem.OpportunityId);
            } 
        }                       
        
        
        if(oppIds.size() > 0){
            List<Opportunity> oppList = new List<Opportunity>();            
            oppList = [SELECT Id,Product_Code__c,
                       (SELECT Id,ProductCode FROM OpportunityLineItems) 
                       FROM Opportunity 
                       WHERE Id IN :oppIds AND RecordTypeId = :busSolRecordTypeId];
            
            List<String> productCode = new List<String>();
            List<Opportunity> updatedOppList = new List<Opportunity>();
            
            for(Opportunity oppRecord : oppList){
                productCode.clear();
                for(OpportunityLineItem lineItem : oppRecord.OpportunityLineItems){
                    productCode.add(lineItem.ProductCode);
                }                
                oppRecord.Product_Code__c = String.join(productCode,',');
                updatedOppList.add(oppRecord);
            }
            
            if(updatedOppList.size() > 0)
                try{
                	update updatedOppList;
                }
            	catch(Exception e){
                	System.debug('DML Exception'+e.getMessage());
            	}
        }                
    } 
    /*public static void applyOppPromoCode(List<OpportunityLineItem> OpptyList){
    	Set<Id> oliIds = new Set<Id>();
        for(OpportunityLineItem lineItem : OpptyList){
                oliIds.add(lineItem.Id);
        } 
        LBS_OpportunityProductTriggerhandler.applyOppPromoCodeFuture(oliIds);
    }
    //@future
    public static void applyOppPromoCodeFuture(Set<Id> oli){
    	List<OpportunityLineItem> oliList =[Select id,name,opportunityId,Opportunity.amount,opportunity.stageName,Product2Id from OpportunityLineItem where id in : oli];    
        for(OpportunityLineItem ol:oliList){
            System.debug('ol -->'+ol);
            OpportunityLineItem oliExisting =[Select id,name,product2.Name,opportunityId from OpportunityLineItem where Product2.name ='Promo Code' and opportunityId =:ol.opportunityId];
            oliExisting.Unitprice = -((ol.Opportunity.Amount*20)/100);
            update oliExisting;
        }
    }*/
}