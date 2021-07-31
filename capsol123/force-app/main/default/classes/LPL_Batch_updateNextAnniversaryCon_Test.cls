/*Batch class Name               : LPL_Batch_updateNextAnniversaryCon_Test 
Description                      : Test Clasfor coverage of LPL_Batch_updateNextAnniversaryOnContact Class
Created By                       : Manila
Created Date                     : 30-June-2018
CH01 - Modified code to send mails for Non-Club level Contacts 21 days before their 20,25,30,35,40,45,50th Anniversary
*/
@isTest(SeeAllData = false)

public class LPL_Batch_updateNextAnniversaryCon_Test {
    
    public static ID laConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
    
    public static testmethod void method1() {
        
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account acc1 = new Account();
        acc1.Name = 'Test Anniversary Account';
        acc1.Type = 'IAS';
        insert acc1;
        
        List<Contact> conlistdata=new List<Contact>();
        contact ct1=new contact(AccountId = acc1.ID, lastname = 'lastname ', Hire_Date__c = system.today() + 5, Next_Anniversary_Date__c = null, Rep_Status__c = 'Active', RecordTypeId=laConRecordTypeId, Receive_Anniversary_Emails__c = TRUE);
        conlistdata.add(ct1);
        
        contact ct2=new contact(AccountId = acc1.ID, lastname = 'lastname ', Hire_Date__c = system.today() + 5, Next_Anniversary_Date__c = null,RecordTypeId=laConRecordTypeId, Rep_Status__c = 'Active', Receive_Anniversary_Emails__c = TRUE);
        conlistdata.add(ct2);
        
        contact ct3=new contact(AccountId = acc1.ID, lastname = 'lastname ', Hire_Date__c = system.today(), Next_Anniversary_Date__c = null,RecordTypeId=laConRecordTypeId, Rep_Status__c = 'Active', Receive_Anniversary_Emails__c = TRUE,Club_Level__c='Directors Club');
        conlistdata.add(ct3);
        
        contact ct4=new contact(AccountId = acc1.ID, lastname = 'lastname ', Hire_Date__c = Date.newInstance(system.today().year() - 10, system.today().month(), system.today().Day() + 5), Next_Anniversary_Date__c = null,RecordTypeId=laConRecordTypeId, Rep_Status__c = 'Active', Receive_Anniversary_Emails__c = TRUE);
        conlistdata.add(ct4);
        insert conlistdata;
        
        test.startTest();
        LPL_Batch_updateNextAnniversaryOnContact con=new LPL_Batch_updateNextAnniversaryOnContact();
        Database.executeBatch(con,200); 
        test.stopTest();
    }
    
    public static testMethod void testschedule() {   
        Test.StartTest();
        LPL_Batch_updateNextAnniversaryCon_Sche sh1 = new LPL_Batch_updateNextAnniversaryCon_Sche();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
    }
    
}