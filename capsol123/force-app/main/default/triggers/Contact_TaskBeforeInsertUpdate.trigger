trigger Contact_TaskBeforeInsertUpdate on Task(before insert, before update) {

     
   Set<id> ContactWhoIds = new Set<id>();
   Set<id> LeadWhoIds = new Set<id>();   
   
   Set<String> IA_MRID = new set<String>(); 
   
   map<Id,LPL_Insurance_Associates__c> iaMap=new Map<Id,LPL_Insurance_Associates__c>();
   
   for(Task t : trigger.new) 
    {
        if(t.whoId!= null)
        {       
            if(String.valueOf(t.whoId).StartsWith('003')) ContactWhoIds.add(t.whoId);
            if(String.valueOf(t.whoId).StartsWith('00Q')) LeadWhoIds.add(t.whoId);  
             
        }
    }    
    
    
  if(ContactWhoIds.size() != 0){
    
        Map<id, Contact> conMap = new Map<id, Contact>([Select master_rep_Id__c,Advisory_Segment__c,CBSA_Metro_Area__c From Contact Where (id in :ContactWhoIds )]);           
        
     //   List<LPL_Insurance_Associates__c> lstIA= new List<LPL_Insurance_Associates__c>([Select Contact__c,Insurance_Tier__c,Fixed_Annuity_Segment__c,Variable_Annuity_Segment__c From LPL_Insurance_Associates__c Where (Contact__c in :conMap.keySet() )]);
        
        for(LPL_Insurance_Associates__c ia: [Select Contact__c,Insurance_Tier__c,Fixed_Annuity_Segment__c,Variable_Annuity_Segment__c From LPL_Insurance_Associates__c Where (Contact__c in :conMap.keySet() )])        
        {
        
         iaMap.put(ia.Contact__c,ia);
        }
        
        for(Task  t : trigger.new)
        {        
              
                Contact fin = conMap.get(t.WhoId);
                LPL_Insurance_Associates__c  IAObject= iaMap.get(t.WhoId);
                
                if(fin != null) 
                {       
                   // t.Advisory_Segment__c=fin.Advisory_Segment__c; 
                    t.master_rep_id__c=fin.master_rep_Id__c;  
                    t.CBSA_Metro_Area__c= fin.CBSA_Metro_Area__c;                
                }
                
                if(IAObject!= null) 
                {       
          
                    //t.Variable_Annuity_Segmentation__c=IAObject.Variable_Annuity_Segment__c;
                   // t.Insurance_Segmentation__c=IAObject.Insurance_Tier__c;
                   // t.Fixed_Annuity_Segmentation__c=IAObject.Fixed_Annuity_Segment__c; 
                }
                
            
        }    
        
        
    
    }
  
///

    if(LeadWhoIds.size() != 0){
    
        Map<id, Lead> leadMap = new Map<id, Lead>([Select Status From Lead Where (id in :LeadWhoIds)]);         
        
        
       for(Task  t : trigger.new)
        {        
              
                Lead Lfin = leadMap.get(t.WhoId);
                
                
                if(Lfin != null) 
                {       
                    t.lead_status__C=Lfin.Status; 
                                 
                }
                
                               
            
        }    
        
        
    
    }



}