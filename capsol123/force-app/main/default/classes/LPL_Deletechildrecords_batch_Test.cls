@isTest(SeeAllData=false)
public class LPL_Deletechildrecords_batch_Test {
    
    static testmethod void getcontactsmethod() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = true;
        insert tbp;
        
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        List<Contact> conList = new List<Contact>();
        for(Integer i = 1;i<=5;i++){
            conList.add(new Contact( AccountId = a1.id , Firstname = 'Test', Lastname = 'DELETE*** '+i, RecordTypeId = recordTypeId));
        }
        insert conList;
        
        Test.startTest();
        LPL_Deletechildrecords_batch bc = new LPL_Deletechildrecords_batch();
        Database.executeBatch(bc);
        Test.stopTest();
    }
}