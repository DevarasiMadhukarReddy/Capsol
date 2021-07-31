@isTest(SeeAllData=false)
public class LPL_ProgramManagerOnEnterprise_batchTest {
    
    public static void testDataSetup(){        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = true;
        insert tbp;
        
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();       
        Id isInstitution = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId();       
        Account a1 = new Account(Name='Program Manager Test1', RecordTypeId=isInstitution);
        insert a1;
        Account a2 = new Account(Name='Test2', RecordTypeId=isInstitution);
        insert a2;
        List<Contact> conList = new List<Contact>();
        Contact con7 = new Contact(AccountId = a1.id, lastname = 'lastname' ,
                                   RecordTypeId = conRecordTypeId , 
                                   Rep_Status__c ='Active', Role__c = 'Program Manager',PM_Communication_List__c = true,
                                   PM_Contact_Level__c='Primary',Hire_Date__c = System.today()+2);
        conList.add(con7);
        Contact con3 = new Contact(AccountId = a1.id, lastname = 'lastname' ,
                                   RecordTypeId = conRecordTypeId , 
                                   Rep_Status__c ='Active', Role__c = 'Program Manager',PM_Communication_List__c = true,
                                   PM_Contact_Level__c='Primary',Hire_Date__c = System.today()-2);
        conList.add(con3);
        Contact con4 = new Contact(AccountId = a1.id, lastname = 'lastname 2' ,
                                   RecordTypeId = conRecordTypeId , Rep_Status__c ='Active',
                                   Role__c = 'Program Manager',PM_Contact_Level__c='Primary PM Contact',Hire_Date__c = System.today()-3);
        conList.add(con4);
        Contact con6 = new Contact(AccountId = a1.id, lastname = 'lastname ' ,
                                   RecordTypeId = conRecordTypeId , Rep_Status__c ='Active',
                                   Role__c = 'Program Manager',PM_Contact_Level__c='Primary PM Contact');
        conList.add(con6);
        Contact con1 = new Contact(AccountId = a1.id, lastname = 'lastname 1' ,
                                   RecordTypeId = conRecordTypeId , 
                                   Rep_Status__c ='Active',Hire_Date__c = System.today()-12,
                                   Role__c = 'Program Manager',PM_Contact_Level__c='Secondary PM Contact');
        conList.add(con1);
        
        Contact con2 = new Contact(AccountId = a1.id, lastname = 'lastname' ,
                                   RecordTypeId = conRecordTypeId , 
                                   Rep_Status__c ='Active',Hire_Date__c = System.today()-10,
                                   Role__c = 'Program Manager',PM_Contact_Level__c='Secondary PM Contact');
        conList.add(con2);
        
        
        Contact con5 = new Contact(AccountId = a2.id, lastname = 'lastname ' ,
                                   RecordTypeId = conRecordTypeId , Rep_Status__c ='Active',
                                   Role__c = 'Program Manager',PM_Contact_Level__c='Primary PM Contact',Hire_Date__c = System.today());
        conList.add(con5);
        insert conList;  
    }
    
    public static testmethod void getResults(){
        Test.startTest();
        testDataSetup();
        LPL_ProgramManagerOnEnterprise_batch bc = new LPL_ProgramManagerOnEnterprise_batch();
        Database.executeBatch(bc);
        Test.stopTest();
        Date d = System.today()-12;
        Account acc = [Select id,Name,Program_Manager__c,Program_Manager__r.Name from Account where name like '%1%' limit 1];
        Contact con = [Select id,name,firstname,PM_Contact_Level__c,Hire_Date__c from Contact where AccountId=:acc.Id and lastName like '%2%' limit 1];
        System.assertEquals(con.Id,acc.Program_Manager__c);
    }
}