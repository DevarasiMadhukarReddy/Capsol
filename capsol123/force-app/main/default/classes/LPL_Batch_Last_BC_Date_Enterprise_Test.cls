@isTest(SeeAllData = False)
public class LPL_Batch_Last_BC_Date_Enterprise_Test {

    public static Id accRT1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Relationship').getRecordTypeId();
    public static Id accRT2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId();
    public static Id taskRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Master').getRecordTypeId();
    public static Id eventRT = Schema.SObjectType.Event.getRecordTypeInfosByName().get('IS Profile').getRecordTypeId();
    
    public static testmethod void method1() {
     
        List<Account> accList = new List<Account>();
        List<Task> taskList = new List<Task>();
        List<Event> eventList = new List<Event>();
            test.startTest();
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
        acc1.OwnerId = u.Id;
        acc1.Last_BC_Client_Contact__c = system.today()+1;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name='Account 2';
        acc2.RecordTypeId = accRT2 ;
        insert acc2;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc1.Id;
        con.Internal_Recruiter_IRD__c=userAssign;
        insert con;
       
        Contact con2 = new Contact();
        con2.LastName = 'Test Contact2';
        con2.AccountId = acc2.Id;
        con2.Internal_Recruiter_IRD__c=userAssign;
        insert con2;
        
        
        Task tsk1 = new Task(WhatId = acc1.Id, OwnerId = UserInfo.getUserID(), Subject = 'Task 1', ActivityDate = system.today()+1, Priority='Normal', Status='Completed', CreatedDate=System.now()-1, Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound');
        taskList.add(tsk1);
        Task tsk2 = new Task(WhatId = acc1.Id, WhoId = con.Id, OwnerId = UserInfo.getUserID(), Subject = 'Task 2', ActivityDate = system.today(), Priority='Normal', Status='Completed', CreatedDate=System.now(), Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound');
        taskList.add(tsk2);
        insert taskList;
         
        Event ev1 = new Event(WhatId = acc1.Id,RecordTypeId = eventRT, Subject = 'Event 1', StartDateTime = System.now(), EndDateTime = System.now()+1, Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound', Event_Type__c = 'Contract Delivered');
        eventList.add(ev1);
        Event ev2 = new Event(WhatId = acc2.Id, WhoId = con2.ID, RecordTypeId = eventRT, Subject = 'Event 2', StartDateTime = System.now()+1, EndDateTime = System.now()+2, Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound', Event_Type__c = 'Contract Delivered');
        eventList.add(ev2);
        insert eventList;
        
        
   
         LPL_Batch_Last_BC_Date_Enterprise batchjob =new LPL_Batch_Last_BC_Date_Enterprise();
         Database.executeBatch(batchjob);
         test.stopTest();

     }
    
    public static testmethod void method2() {
     
        List<Account> accList = new List<Account>();
        List<Task> taskList = new List<Task>();
        List<Event> eventList = new List<Event>();
          test.startTest();
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
        acc1.OwnerId = u.Id;
        acc1.Last_BC_Client_Contact__c = system.today()+1;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name='Account 2';
        acc2.RecordTypeId = accRT2 ;
        insert acc2;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc1.Id;
        con.Internal_Recruiter_IRD__c=userAssign;
        insert con;
       
        Contact con2 = new Contact();
        con2.LastName = 'Test Contact2';
        con2.AccountId = acc2.Id;
        con2.Internal_Recruiter_IRD__c=userAssign;
        insert con2;
        
        
        Task tsk1 = new Task(WhatId = acc1.Id, OwnerId = UserInfo.getUserID(), Subject = 'Task 1', ActivityDate = system.today(), Priority='Normal', Status='Completed', CreatedDate=System.now(), Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound');
        taskList.add(tsk1);
        Task tsk2 = new Task(WhoId = con.Id, OwnerId = UserInfo.getUserID(), Subject = 'Task 2', ActivityDate = system.today(), Priority='Normal', Status='Completed', CreatedDate=System.now(), Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound');
        taskList.add(tsk2);
        insert taskList;
        
         
        Event ev1 = new Event(WhatId = acc2.Id,RecordTypeId = eventRT, Subject = 'Event 1', StartDateTime = System.now()-1, EndDateTime = System.now()-1, Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound', Event_Type__c = 'Contract Delivered');
        eventList.add(ev1);
        Event ev2 = new Event(WhoId = con.ID, RecordTypeId = eventRT, Subject = 'Event 2', StartDateTime = System.now()+1, EndDateTime = System.now()+2, Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound', Event_Type__c = 'Contract Delivered');
        eventList.add(ev2);
        insert eventList;
        
        
     
         LPL_Batch_Last_BC_Date_Enterprise batchjob =new LPL_Batch_Last_BC_Date_Enterprise();
         Database.executeBatch(batchjob);
         test.stopTest();

     }
     public static testmethod void method4() {
            test.startTest();
          List<Account> accList = new List<Account>();
        List<Task> taskList = new List<Task>();
        List<Event> eventList = new List<Event>();
          Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
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
         
          User u1 = new User(
                         ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IS User'].Id,
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
        insert u1;
          
  Contact_Merge_User_Assignment__c mergeCon =new Contact_Merge_User_Assignment__c();
        mergeCon.Name='Kara Mackie';
        mergeCon.User_ID__c='005U0000004h0p7';
        insert mergeCon;
            
         String userAssign=Contact_Merge_User_Assignment__c.getInstance('Kara Mackie').User_ID__c;
     Account acc1 = new Account();
        acc1.Name = 'Account 1';
        acc1.RecordTypeId = accRT1;
        acc1.OwnerId = u.Id;
        acc1.Last_BC_Client_Contact__c = system.today()+1;
        insert acc1;
        
         Account acc2 = new Account();
        acc2.name='Account 2';
        acc2.RecordTypeId = accRT2 ;
        insert acc2;
        
      Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc1.Id;
        con.Internal_Recruiter_IRD__c=userAssign;
        insert con;

         Task tsk1 = new Task(WhatId = acc1.Id, OwnerId = u1.id, Subject = 'Task 1', ActivityDate = system.today(), Priority='Normal', Status='Completed', CreatedDate=System.now(), Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound');
        taskList.add(tsk1);
        Task tsk2 = new Task(WhoId = con.Id, OwnerId = u1.id, Subject = 'Task 2', ActivityDate = system.today(), Priority='Normal', Status='Completed', CreatedDate=System.now(), Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound');
        taskList.add(tsk2);
        insert taskList;
        
         
        Event ev1 = new Event(WhatId = acc2.Id,OwnerId = u1.id,RecordTypeId = eventRT, Subject = 'Event 1', StartDateTime = System.now()-1, EndDateTime = System.now()-1, Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound', Event_Type__c = 'Contract Delivered');
        eventList.add(ev1);
        Event ev2 = new Event(WhoId = con.ID,OwnerId = u1.id, RecordTypeId = eventRT, Subject = 'Event 2', StartDateTime = System.now()+1, EndDateTime = System.now()+2, Department__c='Business Development', Activity_Type__c='Recruiting', Category__c='Call-Outbound', Event_Type__c = 'Contract Delivered');
        eventList.add(ev2);
        insert eventList;
         
         LPL_Batch_Last_BC_Date_Enterprise batchjob =new LPL_Batch_Last_BC_Date_Enterprise();
         Database.executeBatch(batchjob);

           test.stopTest();
        
    }
    
    static testmethod void method3() {
        
        Test.StartTest();
        LPL_Batch_Last_BC_Date_Enterprise_Sche sh1 = new LPL_Batch_Last_BC_Date_Enterprise_Sche();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Account Schedule', sch, sh1); 
        Test.stopTest();        
        
    }
   
    
}