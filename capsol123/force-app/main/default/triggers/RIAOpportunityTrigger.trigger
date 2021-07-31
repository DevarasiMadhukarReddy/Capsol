/*
*****************Change History********************
-----------------------------------------------------------------------------------------------
Trigger to update "Firm Contact" in the RIA Compliance Advantage Opportunity section of the RIA Compliance Advantage opportunity page with corresponding contact whose
Modified R Type Description is of "RIA Hybrid Firm and maximum Off-Platform AUM value.

Modified By: Subhash Ghorpade
--------------------------------------------------------------------------------------------------

*/

trigger RIAOpportunityTrigger on Opportunity (before insert, before update) {

    if(Trigger.Isbefore){
    
        Set<Id> opp = new Set<Id>();    
        List<Opportunity> opu = new List<Opportunity>();
        Map<Id,Opportunity> OppIdAccId= new Map<Id,Opportunity>(); 
        Map<Id,Opportunity> OppIdConId= new Map<Id,Opportunity>();        
        Map<id,Contact> ConIDObj;
        
        Map<Id,Id> AccIdConId= new Map<Id,Id>(); 
        List<Id> AccId= new List<Id>();   
        List<Id> ConId= new List<Id>();
        map<Id,LPL_Insurance_Associates__c> iaMap=new Map<Id,LPL_Insurance_Associates__c>();
            
        
        RecordType RIAOpp = [SELECT Id, Name from RecordType where SobjectType = 'Opportunity' and Name='RIA Compliance ADVantage'];
        
        RecordType InsuranceOpp = [SELECT Id, Name from RecordType where SobjectType = 'Opportunity' and Name='AIS Insurance Sales'];
        
        system.debug('+++++++++++++++++++++++++++++++ RecordType: ' + RIAOpp);         
        
        For(Opportunity o : Trigger.new){ 
                
        If(trigger.isUpdate && o.RecordTypeId == RIAOpp.Id ){ 
        
            OppIdAccId.put(o.Id,o);                   
            AccId.add(o.accountId);
        
        }   
        If(trigger.isInsert && o.RecordTypeId == RIAOpp.Id) { 
        
            For(Contact con:              
            [select Id from Contact where Rep_Type__c = 'RIA Hybrid Firm' and accountId = :o.accountId limit 1 ])            
            {   
                system.debug('+++++++++++++++++++++++++++++++ Contact1111: ' + con);
                o.Firm_Contact__c= con.Id;                
            }        
        }
        
        if((trigger.isInsert || trigger.isUpdate)&&(o.RecordTypeId == InsuranceOpp.Id) ){
        
           if( trigger.isUpdate &&  (trigger.oldMap.get(o.Id).contact__c != trigger.newMap.get(o.Id).contact__c)){
        
                system.debug('+++++++++++++++++++++++++++++++ Contact__r.Insurance_Territory__c : ' + o.Contact__r.Insurance_Territory__c);    
                o.LPL_Region__c =o.Contact__r.Insurance_Territory__c;
                
                OppIdConId.put(o.Contact__C,o);                   
                ConId.add(o.Contact__C);
            }
            if(trigger.isInsert)
            {
            
                system.debug('+++++++++++++++++++++++++++++++ Contact__r.Insurance_Territory__c : ' + o.Contact__r.Insurance_Territory__c);    
                o.LPL_Region__c =o.Contact__r.Insurance_Territory__c;
                
                OppIdConId.put(o.Contact__C,o);                   
                ConId.add(o.Contact__C);
            
            }
            
        
        }
                
        }  
        
        if(AccId.size()>0)
        {         
            For(Contact con:        
            [select Id,AccountId from Contact where (Rep_Type__c = 'RIA IFA Firm' OR Rep_Type__c = 'RIA Hybrid Firm') and accountId = :AccId order by Off_Platform_AUM__c])           
            {  
            
                AccIdConId.put(con.AccountId,con.Id);
            
            }    
        
        }
        for (Id OppId: OppIdAccId.keySet()){        
            if(AccIdConId.containsKey(OppIdAccId.get(OppId).accountId))            
            {
            
                OppIdAccId.get(OppId).Firm_Contact__c=AccIdConId.get(OppIdAccId.get(OppId).accountId);
            }
        } 
        
        // Contact IAS Insurance Sales
        
        
        if(ConId.size()>0)
        {         
            ConIDObj = new Map<ID, Contact>([SELECT Id,AccountId, Insurance_Territory__c FROM Contact where id in: ConId]);
            
         for(LPL_Insurance_Associates__c ia: [Select Contact__c,Insurance_Tier__c,Fixed_Annuity_Segment__c,Variable_Annuity_Segment__c From LPL_Insurance_Associates__c Where (Contact__c in :ConId )])        
        {
        
         iaMap.put(ia.Contact__c,ia);
        }
          
          
          system.debug('+++++++++++++++++++++++++++++++ iaMap: ' + iaMap);
            
            
        /*    List<Insurance_Region_and_Rep_Info__c> insList = [select Assigned_Rep__c,Region__c from Insurance_Region_and_Rep_Info__c] ;
            
            Map<string,Id> insRegionUserMap= new Map<string,Id>(); 
 
            //Fetching Account ids
            for(Insurance_Region_and_Rep_Info__c ins: insList){
            
                if(!insRegionUserMap.containsKey(ins.Region__c))             
                insRegionUserMap.put(ins.Region__c ,ins.Assigned_Rep__c);
            }*/

        
        
        for (Id conIds: ConIDObj.keySet()){        
            if(ConIDObj.containsKey(OppIdConId.get(conIds).contact__c))            
            {
                if (ConIDObj.get(conIds).Insurance_Territory__c != null)
                OppIdConId.get(conIds).LPL_Region__c=ConIDObj.get(conIds).Insurance_Territory__c ;                
                else
                OppIdConId.get(conIds).addError('Please provide value of Insurance Territory on Contact, Insurance Territory on contact can not blank');

                OppIdConId.get(conIds).accountId=ConIDObj.get(conIds).accountId ;

                if(iaMap.containsKey(OppIdConId.get(conIds).contact__c))
                {
                    OppIdConId.get(conIds).Variable_Annuity_Segment__c=iaMap.get(conIds).Variable_Annuity_Segment__c;
                    OppIdConId.get(conIds).Insurance_Segment__c=iaMap.get(conIds).Insurance_Tier__c;
                    OppIdConId.get(conIds).Fixed_Annuity_Segment__c=iaMap.get(conIds).Fixed_Annuity_Segment__c;
                    
                     
                  }
                
            }
        } 
        
        }
           
    
    }
}