//BFR005   Contacts qualification process to create opportunity 
public class OpportunityRecordtypeController {
public static Map<Id, String> recordtypemap {get;set;}
    
   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Opportunity.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
           if(rt.getName() != 'Master')
            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }      

    @AuraEnabled
    public static Contact getContact(String conId){
        Contact con;
        List<Contact> cons = [Select Id,Name,MobilePhone,Email,AUM_from_other_source__c,GDC_Prior_12_mo__c,AccountId,
                              Channel__c, Outside_Recruiting_Firm_Fee__c,Outside_Recruiting_Firm_Name__c,Outside_Recruiting_Firm_Payout__c,
                               Lead_Approval_Date__c,Lead_Source__c,Source_Type_Prospect__c From Contact Where Id = :conId];
        if(cons.size() > 0){
            con = cons.get(0);
        }
        return con;
    }
}