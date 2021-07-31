trigger LPL_PotentialDuplicateTrigger on CRMfusionDBR101__Potential_Duplicate__c (before insert) {
    Set<Id> conIdSet = new Set<Id>();
    
    for(CRMfusionDBR101__Potential_Duplicate__c  dupRec : trigger.new){
        conIdSet.add(dupRec.CRMfusionDBR101__Contact__c);
    }
    
    Map<Id,Contact> conDataMap = new Map<Id, Contact>([SELECT id, LastModifiedDate from Contact where id IN : conIdSet]);
        
    for(CRMfusionDBR101__Potential_Duplicate__c  dup : trigger.new){
        if(conDataMap.containsKey(dup.CRMfusionDBR101__Contact__c)){
            Long dateModifiedContact = conDataMap.get(dup.CRMfusionDBR101__Contact__c).LastModifiedDate.getTime();
            Long dateCreatedDup = System.now().getTime();
            Integer timeDifference = math.abs(Integer.valueOf(dateModifiedContact - dateCreatedDup)/1000);
            if((timeDifference)<10){
                dup.Is_Actual_Duplicate__c=true;   
            }
        }
    }
    
}