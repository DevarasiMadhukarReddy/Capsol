/*
     * @author        : Rinku Yadav
     * @date          : 3rd Dec, 2020
     * @description   : This batch class is written to map Account to Contact for LPL Advisor where account and 
     *                  contact Branch ID are same and converted by informatica is true on contact.
*/global class LPL_ConvertedContactUpdate_Batch implements Database.Batchable<sObject>{
	global Database.QueryLocator start( Database.BatchableContext BC ) {
        Id lplAdvisorId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        String query = 'SELECT Id, Branch_Id__c,Converted_By_Informatica__c FROM Contact WHERE Converted_By_Informatica__c = true AND Branch_Id__c != NULL AND RecordtypeId =: lplAdvisorId';
        return database.getQueryLocator(query);
    }

    global void execute( Database.BatchableContext BC , List<Contact> contactList ) {
        List<Contact> conupdate = new List<contact>();
        Map<String, Id> branchIdToAccIdMap = new Map<String, Id>();
        
        List<Account> accList = [SELECT Id, Branch_Id__c FROM Account WHERE Branch_Id__c != null];
        if ( accList != null && accList.size() > 0 ) {
            for ( Account acc : accList ) {
                branchIdToAccIdMap.put( acc.Branch_Id__c , acc.Id );
            }
        }

        if ( branchIdToAccIdMap != null && !branchIdToAccIdMap.isEmpty() && contactList != null && contactList.size() > 0 ) {
            for ( Contact con: contactList ) {
                if ( branchIdToAccIdMap.containsKey( con.Branch_Id__c ) ) {
                    con.AccountId = branchIdToAccIdMap.get( con.Branch_Id__c );
                    con.Converted_By_Informatica__c = false;
                }
            }

            try {
                update contactList;
            }
            catch( exception ex ) {
                System.debug('Exception Occurred:: '+ex.getMessage() );
            }
        }
    }
   
    global void finish( Database.BatchableContext BC ) {
    
    }
}