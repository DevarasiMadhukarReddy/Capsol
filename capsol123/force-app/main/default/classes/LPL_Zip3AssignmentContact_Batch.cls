/*
     * @author        : Rinku Yadav
     * @date          : 12 Dec, 2020
     * @description   : This batch class map value on contact object from Zip3 Assignment object depending upon the 
     *                  state code
*/
global class LPL_Zip3AssignmentContact_Batch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        ID conProsRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID lplAdvisorRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        String query='Select Id, MailingPostalCode,MailingState,WMO_Division__c,Insurance_Consultant__c,Annuity_Consultant__c,Financial_Planning_Consultant__c,HNW_PTC_Consultant__c,Virtual_Services_Consultant__c,Regional_Business_Solutions_Consultant__c,RecordTypeId, CreatedDate from Contact where (RecordTypeId =: conProsRecTypeId OR RecordTypeId =: lplAdvisorRecTypeId)';  
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Contact> conList) {
        String stateCode;
        List<Contact> contactList = new List<Contact>();
        Map<String,Zip3_Assignment__c> zipMap = new Map<string,Zip3_Assignment__c>();
        List<Zip3_Assignment__c> zipList = [SELECT id,Regional_Business_Solutions_Consultant__c,State__c,WMO_Division__c,Insurance_Consultant__c,
                                            Annuity_Consultant__c,Financial_Planning_Consultant__c,HNW_PTC_Consultant__c,Business_Solutions_Consultant__c
                                            FROM Zip3_Assignment__c
                                            WHERE state__c != null];
        
        system.debug('^^'+zipList);
        if(zipList != null && zipList.size()>0){
        for(Zip3_Assignment__c zip: zipList){
            zipMap.put(zip.state__c,zip);
         }
        }
        if(zipmap != null && zipmap.size()>0){
            for(Contact con : conList){
                 if(zipMap.containsKey(con.MailingState)) {
                     if(zipMap.get(con.MailingState).Regional_Business_Solutions_Consultant__c != null){
                    	con.Regional_Business_Solutions_Consultant__c = zipMap.get(con.MailingState).Regional_Business_Solutions_Consultant__c;
                     }
                     if(zipMap.get(con.MailingState).WMO_Division__c != null){
                    	con.WMO_Division__c =  zipMap.get(con.MailingState).WMO_Division__c;
                     }
                     if(zipMap.get(con.MailingState).Insurance_Consultant__c != null){
                         con.Insurance_Consultant__c = zipMap.get(con.MailingState).Insurance_Consultant__c;
                     }
                     if(zipMap.get(con.MailingState).Annuity_Consultant__c != null){
                         con.Annuity_Consultant__c = zipMap.get(con.MailingState).Annuity_Consultant__c;
                     }
                     if(zipMap.get(con.MailingState).Financial_Planning_Consultant__c != null){
                          con.Financial_Planning_Consultant__c = zipMap.get(con.MailingState).Financial_Planning_Consultant__c;
                     }
                     if(zipMap.get(con.MailingState).HNW_PTC_Consultant__c != null){
                         con.HNW_PTC_Consultant__c = zipMap.get(con.MailingState).HNW_PTC_Consultant__c;
                     }
                     if(zipMap.get(con.MailingState).Business_Solutions_Consultant__c != null){
                          con.Virtual_Services_Consultant__c = zipMap.get(con.MailingState).Business_Solutions_Consultant__c;
                     }
                     
                }
             }
        }
        try{
        	update conList;
        }
        catch( exception ex ) {
               System.debug('Exception Occurred:: '+ex.getMessage() );
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }

}