/*
Batch class Name              :Lpl_Oppty_Aggregate_Stage_Data_Test 
Developer Name                :Mahender Gangu
Created Date                  :26 june 2017
Decription                    : Test class for 'Lpl_Oppty_Open_Aggregate_Data_Batch' class and 'Lpl_Oppty_isClosed_Aggregate_Data_Batch' Class

*/
@isTest
public class Lpl_Oppty_Open_Aggregate_Data_Batch_Test {
    
    public static Id conRecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    public static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    
    static testMethod void method1() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        List<IAS_Recruiter_Assignment__c>  iasList = new List<IAS_Recruiter_Assignment__c >();
        IAS_Recruiter_Assignment__c ias1 = new IAS_Recruiter_Assignment__c(Name = '84081', Lead_Type__c='Masters', State__c ='AP',
                                                                           Assigned_Recruiter__c = UserInfo.getUserID(),
                                                                           Internal_Recruiter__c = UserInfo.getUserID(),
                                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                                           GDC_Maximum__c = 100000000.0, GDC_Minimum__c=2000000.0
                                                                          );
        iasList.add(ias1);
        
        insert iasList;
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        insert oAcct;
        
        Contact ct1= new Contact(AccountId = oAcct.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 GDC_Prior_12_mo__c = 200,HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 Channel_owner__c = 'IS BD', MailingPostalCode = '84081',Inactive_Reason__c='Inactive - Compliance',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert ct1;
        
        Opportunity op1 = new Opportunity(AccountId = oAcct.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Engaged'
                                          , Zip_Code__c = '84081', GDC_Prior_12_mo__c = 200
                                          , Contact__c = ct1.Id, RecordTypeId = oppRecordTypeId);
        insert op1;
        
        Opportunity op2 = new Opportunity(AccountId = oAcct.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = 'Closed-Lost'
                                          , Zip_Code__c = '84081', GDC_Prior_12_mo__c = 200
                                          , Contact__c = ct1.Id, lost_outcome__c='Unknown',RecordTypeId = oppRecordTypeId);
        insert op2;
        test.startTest();
        Lpl_Oppty_Open_Aggregate_Data_Batch batchObj=new Lpl_Oppty_Open_Aggregate_Data_Batch();
        Database.executeBatch(batchObj);
        test.stopTest();
    }
}