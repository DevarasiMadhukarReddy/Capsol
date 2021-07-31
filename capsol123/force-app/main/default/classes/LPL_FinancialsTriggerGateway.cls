/**
 * Class AccountGateway
 *
 * Provides finder methods for accessing data in the Account object.
 */
public without sharing class LPL_FinancialsTriggerGateway
{
    
    ID ISOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IS Opportunity').getRecordTypeId();
    ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    public static Map<Id, Financials__c> accMap = new Map<Id, Financials__c >();
    
    /*
     * Returns a Map of Id's and Financials Records
     */
    
    public static Map<Id, Financials__c> findFinancialsRecInUse(List<Financials__c> finList)
    {
        Map<Id,Financials__c> finMap = new Map<Id,Financials__c >();
        
        
        for(Financials__c fin : finList) 
        {
            finMap.put(fin.Advisor__c, fin);
            accMap.put(fin.Advisor__r.AccountID, fin);
        }  
        
        return finMap;
    }
    
    
 
   //Start 
     public static Map<Id, Opportunity> findOpportunityInUse(Map<Id, Financials__c> finMap)
    {
          Map<id, Opportunity> conMap;
         if(finMap.keyset().size() != 0){
        
            conMap = new Map<id, Opportunity>([Select Contact__C,RecordTypeId ,TAT_GDC__c From Opportunity Where (Contact__c in :finMap.keyset() ) 
            and Hire_Date__c!=null and Current_Rep_Type_Des__c!= '' limit 100000]);
            
            
            }
            
            return conMap;
       
    }
   //End 
    public void processFinancials(Map<Id, Opportunity> conMap,Map<Id, Financials__c> finMap){
           
            for (Opportunity oppIds: conMap.values()){   
                If(oppIds.RecordTypeId == ISOpp || oppIds.RecordTypeId == IASBD) {
                    finMap.get(oppIds.Contact__c).TAT_GDC__c=    oppIds.TAT_GDC__c;
                }
            }
        
    }
}