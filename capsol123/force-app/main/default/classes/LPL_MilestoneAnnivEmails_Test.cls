/*
 * Class Name				: LPL_MilestoneAnnivEmails_Test
 * Description				: Test class for LPL_MilestoneAnnivEmails_Batch class
 * Developer Name			: Justin Lonh
 * Created Date				: 15-June-2021
*/
@isTest(SeeAllData = false)
public class LPL_MilestoneAnnivEmails_Test {
    
    public static ID laConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
    
    public static testmethod void method1() {
        
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account acc1 = new Account();
        acc1.Name = 'Test Milestone Account';
        acc1.Type = 'IAS&IS';
        insert acc1;
        
        List<Contact> conListData = new List<Contact>();
        // IS Program Manager, no anniversary
        Contact ct1=new Contact(AccountId = acc1.ID, lastname = 'lastname', Hire_Date__c = system.today(), Rep_Status__c = 'Active', RecordTypeId=laConRecordTypeId, Role__c = 'Program Manager');
        conListData.add(ct1);
        
        // RIA IFA Advisor, 1 year anniversary
        Contact ct2=new Contact(AccountId = acc1.ID, lastname = 'lastname', Hire_Date__c = Date.newInstance(system.today().year() - 1, system.today().month(), system.today().Day()) + 14, RecordTypeId=laConRecordTypeId, Rep_Status__c = 'Active', Rep_Type__c = 'RIA IFA Advisor');
        conListData.add(ct2);
        
        // RIA Hybrid Advisor, 5 year anniversary
        Contact ct3=new Contact(AccountId = acc1.ID, lastname = 'lastname', Hire_Date__c = Date.newInstance(system.today().year() - 5, system.today().month(), system.today().Day()) + 14, RecordTypeId=laConRecordTypeId, Rep_Status__c = 'Active', Rep_Type__c = 'RIA Hybrid Advisor');
        conListData.add(ct3);
        
        // IAS Advisor, 46 year anniversary
        Contact ct4=new Contact(AccountId = acc1.ID, lastname = 'lastname', Hire_Date__c = Date.newInstance(system.today().year() - 46, system.today().month(), system.today().Day()) + 14, RecordTypeId=laConRecordTypeId, Rep_Status__c = 'Active', Rep_Type__c = 'IAS Advisor');
        conListData.add(ct4);
        
        insert conListData;
        
        test.startTest();
        LPL_MilestoneAnnivEmails_Batch con = new LPL_MilestoneAnnivEmails_Batch();
        Database.executeBatch(con,200); 
        test.stopTest();
    }
    
    public static testMethod void testschedule() {   
        Test.StartTest();
        LPL_MilestoneAnnivEmails_Schedulable sh1 = new LPL_MilestoneAnnivEmails_Schedulable();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Milestone Anniv Email', sch, sh1); 
        Test.stopTest();
    }
    
}