/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Test class for Batch - LPL_Account_to_Contact_Update_batch         Manila Agnihotri                    27 APRIL 2018
                                            

*/

@isTest(SeeAllData = False)
public class LPL_Account_to_Contact_Update_batchtest {
   
      public static testmethod void method1() {
     Id accRT1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Broker Dealer Firm (Discovery)').getRecordTypeId();
       Id ConProspect= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        List<Account> accList = new List<Account>();
              User u = new User(
                         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                         LastName = 'last',
                         Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US'
                         //UserRoleId = r.Id
                    );
        insert u;
          
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact_Merge_User_Assignment__c mergeCon =new Contact_Merge_User_Assignment__c();
        mergeCon.Name='Kara Mackie';
        mergeCon.User_ID__c='005U0000004h0p7';
        insert mergeCon;
        String userAssign=Contact_Merge_User_Assignment__c.getInstance('Kara Mackie').User_ID__c;
          
        Account acc1 = new Account();
        acc1.Name = 'Account 1';
        acc1.RecordTypeId = accRT1;
        acc1.Sell_Against_Details__c ='This is for testing purpose ';
        acc1.Last_BC_Client_Contact__c = system.today();
        acc1.Field_Insert_Updated__c=true;
        insert acc1;
          
              
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc1.Id;
        con.Internal_Recruiter_IRD__c=userAssign;
        insert con;
       
        Contact con2 = new Contact();
        con2.LastName = 'Test Contact2';
        con2.AccountId = acc1.Id;
        con2.Internal_Recruiter_IRD__c=userAssign;
        insert con2;
          
         test.startTest();
         LPL_Account_to_Contact_Update_batch batchjob =new LPL_Account_to_Contact_Update_batch();
         Database.executeBatch(batchjob);
         test.stopTest();
       }
}