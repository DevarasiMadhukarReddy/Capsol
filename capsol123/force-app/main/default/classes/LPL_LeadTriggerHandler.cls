public with sharing class LPL_LeadTriggerHandler implements ITrigger{

        
    //Fetching RecordTypeId by name
    Schema.DescribeSObjectResult leadRecDesc = Schema.SObjectType.Lead;
    Map<String,Schema.RecordTypeInfo> rtMapByName = leadRecDesc.getRecordTypeInfosByName();
    
    Map<Id, Lead> leadMap = new Map<Id, Lead>();
    map<string,string> emailsToChangeInEloqua = new map<string,string>(); 
    LPL_LeadTriggerGateway leadTrigGateway = new LPL_LeadTriggerGateway();    
    
    public static boolean executeOnce = true;
    
    public LPL_LeadTriggerHandler(){}
    
    public void bulkBefore(){
        if(!Trigger.isDelete){
            leadTrigGateway.collectRecordToProcess(Trigger.new, Trigger.Old);    
        }else{
            leadTrigGateway.collectRecordToProcess(Trigger.old,null);    
        }
        
    }
    
    public void beforeInsert(SObject so){
        Lead newLead = (Lead)so;
        leadTrigGateway.doInsertOperation(newLead);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
    
        Lead newLead = (Lead)so;
        Lead oldLead = (Lead)oldSo;
        
        leadTrigGateway.doUpdateOperation(newLead, oldLead);
        
        leadTrigGateway.updateContAndOpty();//Added by Pravin as a part of Lead Conversion Issue 
                
    }
    
    public void beforeDelete(SObject so){}
    public void bulkAfter(){
        
        List<Lead> leadLst = System.Trigger.new;
               
        if(Trigger.IsUpdate){
        leadTrigGateway.collectRecordToProcessAfter(leadLst);  
        for (Lead objLead : leadLst)
        {
        if((objLead .RecordTypeId == rtMapByName.get('Discovery Database Lead').getRecordTypeId() ||
           objLead .RecordTypeId == rtMapByName.get('Create New Manual Lead').getRecordTypeId() ||
           objLead .RecordTypeId == rtMapByName.get('IS BD Lead').getRecordTypeId()) 
           ){
           
           if(objLead .IsConverted == true){
               //system.debug('**********'+oldLead.IsConverted);
               leadMap.put(objLead.id, objLead );
               //system.debug('ConvertedContactId*****TrigBulk*****'+ objLead .ConvertedContactId);  
            }
           
        }
        }
        }
    }
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){
    
        Lead newLead = (Lead)so;
        Lead oldLead = (Lead)oldSo;
        //system.debug('**********'+newLead.IsConverted);
        //system.debug('**********'+oldLead.IsConverted);
        /*if((newLead.RecordTypeId == rtMapByName.get('Discovery Database Lead').getRecordTypeId() ||
           newLead.RecordTypeId == rtMapByName.get('Create New Manual Lead').getRecordTypeId() ||
           newLead.RecordTypeId == rtMapByName.get('IS BD Lead').getRecordTypeId()) 
           ){
           
           if((newLead.IsConverted == true && oldLead.IsConverted == false )){
               system.debug('**********'+oldLead.IsConverted);
               leadMap.put(oldLead.id, oldLead);
               system.debug('ConvertedContactId*****Trig*****'+ OldLead.ConvertedContactId);  
            }
           
        } */
        
        leadTrigGateway.updateElqMrktAct(); //Added by Pravin as a part of Lead Conversion Issue 
        
        //only when changing it do we check 
        if((newLead.email != oldLead.email) &&
        (newLead.email != null && newLead.email != '')) {
            //system.debug ('add records ' + l.email + ' and ' + trigger.oldMap.get( c.id ).email);
            emailsToChangeInEloqua.put(oldLead.email, newLead.email);
        }
    
    }
    
    public void afterDelete(SObject so){}
    
    public void andFinally(){
        
        
        
        /* //Moved piece of code from Finally to Respective DML Events
            leadTrigGateway.updateContAndOpty();
            
            if(!leadMap.isEmpty())
            leadTrigGateway.updateElqMrktAct(leadMap);*/
        
            
            leadTrigGateway.processFinally();
        
        
        if(!emailsToChangeInEloqua.isEmpty())
        ChangeEloquaEmailAddressCls.ChangeEloquaEmailAddress(emailsToChangeInEloqua);
           
        
    }

 
}