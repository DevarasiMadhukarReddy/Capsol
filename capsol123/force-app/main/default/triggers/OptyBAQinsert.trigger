/*
Trigger Name            :OptyBAQinsert 
Description             :This Trigger is mainly focus on creating record of OpportunityBAQ__c when Baq__c object record gets created.
Developer Name          :Vaibhav Wadhai
Created Date            :7th july 2017                               
*/
trigger OptyBAQinsert on BAQ__c (After insert) {
    
    List<OpportunityBAQ__c>  OptyBAQList=new List<OpportunityBAQ__c>();
    try{
    for(BAQ__c baq:trigger.new) {
        
        OpportunityBAQ__c opp=new OpportunityBAQ__c();
        opp.BAQ__c=baq.id;
        opp.Opportunity__c=baq.Opportunity__c;
        OptyBAQList.add(opp);
    }
    
    insert OptyBAQList; //inserting OpportunityBAQ__c object record list.
    }
    catch(DmlException e){
        
        System.debug('Error message:'+e.getMessage());
    }
    
    
    
    }