@isTest 
private class Batch_Email_Tasks_Test{
    
    @testSetup static void testData(){ 
         UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
            insert r;
          User u = new User(
                         ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS_LeadPilot'].Id,
                         LastName = 'Mackie',
                         Email = 'kara.mackie@lpl.com',
                         Username = 'kara.mackie@lpl.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'Internal Regional Director',
                         Alias = 'kmack',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         UserRoleId = r.Id
                    );
        insert u;
    
    }
    static testMethod void BatchEmail_Tasks() {
       
       
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
       test.startTest();
       
       
        Contact_Merge_User_Assignment__c mergeCon =new Contact_Merge_User_Assignment__c();
        mergeCon.Name='Kara Mackie';
        mergeCon.User_ID__c='005U0000004h0p7';
        insert mergeCon;
           
       String userAssign=Contact_Merge_User_Assignment__c.getInstance('Kara Mackie').User_ID__c;
        
       
       Account oAcct  = new Account ();
       oAcct.Name ='Account Test Record';
       insert oAcct;
       
       Contact c = new Contact();
       c.AccountId = oAcct.Id;
       c.lastname = 'acctest';
       c.master_rep_id__c='LMNO';
       c.Internal_Recruiter_IRD__c=userAssign;
       insert c;
       
        
        
        Task t = new Task();
        //t.name = 'test';
        
        t.whoId= c.id;
        t.subject='Email';
        t.type='Email';
        t.master_rep_id__c='';
        insert t;
       
           
        Schedulable_Email_Task_weekly  clsBatchItUpSon = new Schedulable_Email_Task_weekly ();
     
     
         
     String Jobid1=System.schedule('Schedulable_Email_Task_weekly','0 0 1 * * ?',new Schedulable_Email_Task_weekly ());

       
       test.stopTest();
       }
       
   
   
       }