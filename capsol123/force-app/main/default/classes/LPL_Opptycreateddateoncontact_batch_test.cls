@isTest(SeeAllData=false)
public class LPL_Opptycreateddateoncontact_batch_test {
    static testmethod void getcontactsmethod() {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = false;
        insert tbp;
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        List<Contact> conList = new List<Contact>();
        List<Opportunity> Opplist = new List<Opportunity>();
        for(Integer i = 1;i<=5;i++){
            conList.add(new Contact( AccountId = a1.id , Firstname = 'Test', Lastname = 'DELETE '+i, RecordTypeId = recordTypeId,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions'));
        }
        insert conList;
        for(Contact c:conList){
            Opplist.add(new Opportunity(AccountId = a1.id, name = 'Test opportunity', CloseDate =  system.today(), StageName = '1 - Unscreened Contact', Zip_Code__c = '80538',Contact__c=c.id, GDC_Prior_12_mo__c = 200));
        }
        insert Opplist;
        
        Test.startTest();
        LPL_Opptycreateddateoncontact_batch bc = new LPL_Opptycreateddateoncontact_batch();
        Database.executeBatch(bc);
        Test.stopTest();
    }
}