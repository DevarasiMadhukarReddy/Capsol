trigger TATRevenueUpdate on Financials__c (before insert ,before update) {

  Set<Id> IA_MRID = new set<Id>();   
  
  Map<Id,Financials__c > finMap = new Map<Id,Financials__c >();
    
     for(Financials__c fin : trigger.new) 
    {
        IA_MRID.add(fin.Advisor__c);       
         system.debug('++++++++++++++++++++++++++++ fin.TAT_GDC__c ' + fin.TAT_GDC__c);     
            
        finMap.put(fin.Advisor__c, fin);
        
    }  
    
    
     RecordType ISOpp = [SELECT Id, Name from RecordType where SobjectType = 'Opportunity' and Name='IS Opportunity'];
     RecordType IASBD = [SELECT Id, Name from RecordType where SobjectType = 'Opportunity' and Name='IAS Business Development'];
    
      if(IA_MRID.size() != 0){
      
      Map<id, Opportunity> conMap = new Map<id, Opportunity>([Select Contact__C,RecordTypeId ,TAT_GDC__c From Opportunity Where (Contact__c in :IA_MRID ) 
      and Hire_Date__c!=null and Current_Rep_Type_Des__c!= '' limit 100000
      ]);
      
      system.debug('++++++++++++++++++++++++++++ conMap : ' + conMap );     
        
        for (Opportunity oppIds: conMap.values()){   
        
         system.debug('++++++++++++++++++++++++++++ finMap.get(oppIds.Contact__C): ' + finMap.get(oppIds.Contact__C));     
             If(oppIds.RecordTypeId == ISOpp.Id || oppIds.RecordTypeId == IASBD.Id) {
             
            finMap.get(oppIds.Contact__c).TAT_GDC__c=    oppIds.TAT_GDC__c;
            system.debug('++++++++++++++++++++++++++++ oppIds.TAT_GDC__c: ' + oppIds.TAT_GDC__c);     
             system.debug('++++++++++++++++++++++++++++ finMap.get(oppIds.Contact__C).TAT_GDC__c: ' + finMap.get(oppIds.Contact__C).TAT_GDC__c);     
         
            }
            
        } 
      
      
      
      }
      


}