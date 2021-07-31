public class RecordTypeSelector{

    public static Map<Id, String> recordtypemap;

     @AuraEnabled        

    public static Map<Id, String> fetchRecordTypeValues(String objectName){

        List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos();    

        recordtypemap = new Map<Id, String>();

        for(RecordTypeInfo rt : recordtypes){

            if(rt.getName() != 'Master' && rt.getName().trim() != '' && rt.getName().trim() != 'Working Capital' && rt.getName().trim() != 'Transition Assistance')

            recordtypemap.put(rt.getRecordTypeId(), rt.getName());

        }        

        return recordtypemap;

    }
    
    
     @AuraEnabled        
    public static Id  GetLoanObjectInformtion(){
 
       SObject sfObject= [SELECT Id FROM Loan_Application__c LIMIT 1];

        return sfObject.Id;

    }
    
    //Start Added by Bhanu
    @AuraEnabled (cacheable=true )      
    public static Map<String, Object> GetOpportunityDetails(String Id){
    Map<String, Object> returnMap = new Map<String, Object>();
       Opportunity Opty= [SELECT Name FROM Opportunity where Id=:Id LIMIT 1];
       returnMap.put('OptyName',Opty.Name);
       
     
        returnMap.put('OptyFieldId',Label.Backend_TA_Opportunity_Field);
        return returnMap ;

    }
    //End

}