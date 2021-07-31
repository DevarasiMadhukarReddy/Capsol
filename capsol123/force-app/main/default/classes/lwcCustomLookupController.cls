public with sharing class lwcCustomLookupController {
    public lwcCustomLookupController() {
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        System.debug(ObjectName);
        if(ObjectName=='User'){
            if(String.isNotEmpty(value)){
                for(User so : [SELECT id, name FROM User where isActive=true and  name LIKE :value +'%']) {
                    String fieldvalue = (String)so.name;
                    String masterRepId = (String)so.Id;
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id, masterRepId));
                }
                
                
            }
            
          
            
        }
        
        else{
            
            if(String.isNotEmpty(value) )
                for(Contact so : [SELECT id, name, Master_Rep_ID__c FROM Contact where name LIKE :value +'%' LIMIT 5]) {
                    String fieldvalue = (String)so.name;
                    String masterRepId = (String)so.Master_Rep_ID__c;
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id, masterRepId));
                }
        
            
            
        }
        return sObjectResultList;
    }
    
    public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        @AuraEnabled
        public String masterRepId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp, String masterRepIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
            masterRepId = masterRepIdTemp;
        }
    }
}