@isTest(SeeAllData=false)
public class LPL_RecoverDeleted_batch_test {
    
    @testSetup
    public static void testDataSetup(){

        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account acc = new Account(Name='Test');
        insert acc;

        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        List<Contact> conList = new List<Contact>();
        for(Integer i = 1;i<=5;i++){
            conList.add(new Contact(AccountId = acc.id, Firstname = 'DELETE***'+i, Lastname = 'Test', RecordTypeId = recordTypeId));
        }
        insert conList;
         Set<ID>delID=New Set<ID>();
            delete conList;
      }
     static testmethod void getContactRecords(){
        Test.startTest();
            LPL_RecoverDeletedChildRecords_batch bc = new LPL_RecoverDeletedChildRecords_batch();
            Database.executeBatch(bc);
        Test.stopTest();
    }
     
}