/*
#############################Change History####################
Requirement                                                     Developer Name                   Date

Ch-01 If Department is Business Developement then restrict delete and 
Edit  permission on task and Event for other Role             Ashish Gupta                  7-May-2018
*/
@isTest(SeeAllData=False)
public class LPL_TaskTrigger_Test{
    public static  User u;
    @testSetup static void UserData(){
        List<User> userList = new List<User>();
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        u = new User(
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
        userList.add(u);
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole1', Name = 'IRD');
        insert r1;
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS_LeadPilot'].Id,
            
            LastName = 'gupta',
            Email = 'ashish.gupta@lpl.com',
            Username = 'ashish.gupta@lpl.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'Internal Regional Director',
            Alias = 'agupt',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r1.Id
        );
        userList.add(u1);
        insert userList;
    }
    
    static testmethod void test_TaskControllerExtension() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        User u= [SELECT Id,Email,Name from User Where Email ='kara.mackie@lpl.com' LIMIT 1];
        //Add the Account and opportunity executing the opportunity trigger that uses the syncWithIASRecruiterAssignment method
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Id conRecordTypeId;
        conRecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();   
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory',Lpl_Attachment_Sent_Date__c=system.today(),Lpl_Attachment_Sent__c=false, recordTypeId=conRecordTypeId);
        
        insert ct1;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200);
        insert op1;
        
        Task tsk= new Task(whatid =op1.id , OwnerId = Userinfo.getUserId() ,Status='Support Requested',Subject='apex'); 
        insert tsk;
        
        Test.startTest(); 
        ApexPages.StandardController sc = new ApexPages.StandardController(tsk);
        TaskControllerExtension controller = new TaskControllerExtension(sc); 
        controller.uploadFile();
        Test.stopTest(); 
        
    }
    
    static testmethod void test_TaskEmailAlertFunctionality() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Test.startTest(); 
        Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
        Map<String,Schema.RecordTypeInfo> rt_TaskMap = tskRecDesc.getRecordTypeInfosByName();
        Account a1 = new Account(Name = 'Test Account');        
        insert a1;         
        
        Id conRecordTypeId;
        conRecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();   
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory',Lpl_Attachment_Sent_Date__c=system.today(),Lpl_Attachment_Sent__c=false, recordTypeId=conRecordTypeId);
        insert ct1;
        
        Id rt = rt_TaskMap.get('Transitions').getRecordTypeId();
        Task tsk= new Task(whoid =ct1.id , OwnerId = Userinfo.getUserId() ,Subject='test 123',recordTypeId=rt); 
        insert tsk;       
        
        Contact con = [select id, Lpl_Attachment_Sent__c, Lpl_Attachment_Sent_Date__c from Contact where Id =:ct1.Id];
        
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        
        GroupMember m =new GroupMember(UserOrGroupId=Userinfo.getUserId());
        Set<Id> result=new Set<Id>();
        if (((String)m.UserOrGroupId).startsWith(userType)){
            result.add(m.UserOrGroupId);
        }
        ID userID = UserInfo.getUserId();
        System.assertEquals(con.Lpl_Attachment_Sent__c , false);
        System.assertEquals(result.contains(userID) , true);          
        Test.stopTest(); 
        
    }
    
    static testmethod void test_TaskLeadTaskFunctionality() {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Test.startTest(); 
        User u1= [SELECT Id,Email,Name from User Where Email ='ashish.gupta@lpl.com' limit 1];
        Lead le1= new Lead(LastName ='tetCogni', Company='Cogni', LeadSource='Banner', Status='Contact Attempted', 
                           
                           Discovery_Last_Name__c='tetCogni');
        insert le1;
        Task t3 = new Task(whoid = le1.id, Status = 'Completed', Department__c = 'Business Development',Subject='test event', Activity_Type__c = 'IRD Touch', Category__c = 'Call-Outbound', ownerid=u1.id);
        insert t3;
        t3.Department__c='Fortigent Reporting';
        t3.Status='In Progress';
        update t3;
        Test.stopTest();
    }
    
    /*  ******** Lead Onboarding Changes test Method ********** */
    static testmethod void test_TaskTriggerHandler() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        Account a1 = new Account(Name = 'Test Account');        
        insert a1;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200);
        insert op1;
        
        Task tsk= new Task(whatid =op1.id , OwnerId = Userinfo.getUserId() ,Status='Not Started',Subject='apex'); 
        insert tsk;       
        
        tsk.Status ='In Progress';
        Test.startTest(); 
        update tsk;
        
        Task tsk1= [select id, Status_Not_Started_Exit__c ,Status_In_Progress_Entry__c, Status  from Task where id =: tsk.id 
                    
                    limit 1];
        system.assert(tsk1.Status == 'In Progress');
        Test.stopTest(); 
        
    }
    static testmethod void test_TaskTriggerHandler1() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');        
        insert a1;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200);
        insert op1;
        
        Task tsk4= new Task(whatid =op1.id , OwnerId = Userinfo.getUserId() ,Status='Deferred',Subject='apex'); 
        insert tsk4;       
        
        tsk4.Status ='Completed';
        Test.startTest(); 
        update tsk4;
        
        Task tsk5= [select id, Status_Deferred_Exit__c ,Status_Completed_Entry__c , Status  from Task where id =: tsk4.id 
                    
                    limit 1];
        system.assert(tsk5.Status == 'Completed');
        Test.stopTest();   
    }
    
    static testmethod void test_TaskTriggerHandler2() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');        
        insert a1;
        
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200);
        insert op1;
        
        Task tsk2= new Task(whatid =op1.id , OwnerId = Userinfo.getUserId() ,Status='In Progress',Subject='apex'); 
        insert tsk2;       
        
        tsk2.Status ='Deferred';
        Test.startTest();       
        update tsk2;
        
        Task tsk3= [select id, Status_In_Progress_Exit__c ,Status_Deferred_Entry__c , Status  from Task where id =: tsk2.id 
                    
                    limit 1];
        system.assert(tsk3.Status == 'Deferred');
        Test.stopTest(); 
    }
    
    static testmethod void test_Opportunity() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        List<Account> accountList= new List<Account>();
        List<Opportunity> opportunityList= new List<Opportunity>();
        for(Integer i=0 ;i <11;i++){
            Account acc = new Account();
            acc.Name ='Name'+i;
            
            accountList.add(acc);
        }
        
        insert accountList;
        
        List<Contact> contactList= new List<Contact>();
        for(Integer i=0 ;i <11;i++){
            Contact contactObj = new Contact();
            contactObj.LastName ='Name'+i;
            contactList.add(contactObj);
        }
        
        insert contactList;
        
        Id oppRecordTypeId;
        oppRecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RIA Compliance ADVantage').getRecordTypeId();  
        Decimal sumGDC=0.0;
        Decimal unverifiedAUM=0.0;
        for(Integer i=0 ;i <11;i++){
            Opportunity opp = new Opportunity();
            opp.AccountId=accountList[i].Id;
            opp.Contact__c=contactList[i].Id;
            opp.Name='test'+i;
            opp.Request_Type__c='Direct';
            opp.CloseDate=Date.today();
            opp.StageName='Closed-lost'; 
            opp.apex__c=true;
            opp.Probability=50;
            opp.RecordTypeId=oppRecordTypeId;    
            opportunityList.add(opp);
        }
        
        insert opportunityList;
        
        Opportunity Op11 = [select id from Opportunity where id= : opportunityList limit 1];
        
        Op11.StageName='Closed-lost';
        update Op11;
    }
    
    static testMethod void taskCategory(){
        try{
            Trigger_Bypass__c tbp = new Trigger_Bypass__c();
            tbp.name='Contact';
            tbp.IsOff__c = False;
            //insert tbp;
            
            Test.startTest();
            
            Account a1 = new Account(Name = 'Test Account');        
            insert a1;
            
            Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                              , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                              , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200);
            insert op1;
            
            Contact ct1= new Contact(Master_Rep_ID__c='N5KZ',AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
            insert ct1;
            List<Task> tskList = new List<Task>();
            
      /*     Task tsk1 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'BDA Touch', Category__c = 'Left Message', OwnerId = u.id);
           tskList.add(tsk1);
            
            Task tsk2 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'BDA Touch', Category__c = 'Call-Outbound', OwnerId = u.id);
            tskList.add(tsk2);
            
            Task tsk3 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Master Recruiting', Category__c = 'Left Message', OwnerId = u.id);
            tskList.add(tsk3);
            
            Task tsk4 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Master Recruiting', Category__c = 'Home Office Visit', OwnerId = u.id);
            tskList.add(tsk4);
            
            Task tsk5 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', Category__c = 'Left Message', OwnerId = u.id);
            tskList.add(tsk5);
            
            Task tsk6 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', Category__c = 'Call – Outbound Prospecting', OwnerId = u.id);
            tskList.add(tsk6);
            
            Task tsk7 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Recruiting', Category__c = 'Email', OwnerId = u.id);
            tskList.add(tsk7);
            
            Task tsk8 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Recruiting', Category__c = 'IRD Meeting Complete – New Recruit', OwnerId = u.id);
            tskList.add(tsk8);
            
            Task tsk9 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', Category__c = 'IRD Meeting Complete – New Recruit', OwnerId = u.id);
            tskList.add(tsk9);
            
            Task tsk10 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', Category__c = 'IRD Meeting Set – New Recruit', OwnerId = u.id);
            tskList.add(tsk10);
            
            Task tsk11 = new Task(whoId = ct1.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = System.Today() + 5, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', Category__c = 'RD Meeting Set – New Recruit', OwnerId = u.id);
            tskList.add(tsk11);
            
            Task tsk12 = new Task(whoId = ct1.ID, Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 4, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', Category__c = 'RD Meeting Set – New Recruit', OwnerId = u.id);
            tskList.add(tsk12);
            
            LPL_Insurance_Associates__c L1=new LPL_Insurance_Associates__c(Name='N5KZ', External_ID__c='N5KZ',Contact__c=ct1.ID,Insurance_Tier__c='45',Fixed_Annuity_Segment__c='120',Variable_Annuity_Segment__c ='12');
            insert L1;
            Task tsk13 = new Task(whoId = ct1.ID, Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 4, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', Category__c = 'RD Meeting Set – New Recruit', OwnerId = u.id);
            tskList.add(tsk13); */
            Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
            Map<String,Schema.RecordTypeInfo> rt_TaskMap = tskRecDesc.getRecordTypeInfosByName();
            Id rt = rt_TaskMap.get('Transitions').getRecordTypeId();
            
       /*     Task tsk14 = new Task(whoId = ct1.ID, Subject = Label.Disruption_LPL_Scale_Advisor_Value, ActivityDate = System.Today() + 4, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch',  OwnerId = u.id,recordTypeId=rt);
            tskList.add(tsk14); */
            insert  tskList;
            test.stopTest();
            
        } catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        
    }   
    //   Ch-01 Start ** This test method design If Department is Business Developement then restrict delete and     Edit  permission on task and Event for other Role
    static testMethod void deleteAndEditRecord(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        insert oAcct;
        
        User u1= [SELECT Id,Email,Name from User Where Email ='ashish.gupta@lpl.com' limit 1];
        
        test.startTest();
        Account a1= [Select id from Account where Name='Account Test Record'];
        Contact ct1= new Contact(Master_Rep_ID__c='N5KZ',AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
        insert ct1;
        
        Task tsk12 = new Task(whoId = ct1.ID, Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 4, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', Category__c = 'RD Meeting Set – New Recruit', OwnerId = u1.id);
        insert tsk12;
        
        Task tsk13 =[Select id,Subject,Department__c from Task where Department__c = 'Business Development' and id=:tsk12.id limit 1];
        
        system.assertEquals( tsk13.Department__c, 'Business Development'); 
        
        tsk13.Department__c='Fortigent Reporting';
        update tsk13;
        
        system.assertEquals( tsk13.Department__c, 'Fortigent Reporting'); 
        
        delete tsk13;
        
        test.stopTest();
    }
    
    //Ch-01 End
    static testMethod void updateAndInsertTest(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        
        insert oAcct;
        User u1= [SELECT Id,Email,Name from User Where Email ='ashish.gupta@lpl.com' limit 1];
        test.startTest();
        
        Account a1= [Select id from Account where Name='Account Test Record'];
        Contact ct1= new Contact(Master_Rep_ID__c='N5KZ',AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
        insert ct1;
        
        Task tsk12 = new Task(whoId = ct1.ID, Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 3, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', OwnerId = u1.id);
        tsk12.Subject= Label.Disruption_LPL_Scale_Advisor_Value;
        insert tsk12;
        test.stopTest();
    }
    
    static testMethod void updateAndInsertTest2() {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        try{
            Account oAcct  = new Account ();
            oAcct.Name ='Account Test Record';
            
            insert oAcct;
            User u1= [SELECT Id,Email,Name from User Where Email ='ashish.gupta@lpl.com' limit 1];
            
            test.startTest();
            Account a1= [Select id from Account where Name='Account Test Record'];
            Contact ct1= new Contact(Master_Rep_ID__c='N5KZ',AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
            insert ct1;
            
            
            List<Task> tskList = new List<Task>();
            Task tsk12 = new Task(whoId = ct1.ID, Category__c='Email', Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 3, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch', OwnerId = u1.id);
            tsk12.Subject= Label.Disruption_LPL_Scale_Advisor_Value;
            tskList.add(tsk12);
            
            Task tsk13 = new Task(whoId = ct1.ID, Category__c='Email', Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 4, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Recruiting', OwnerId = u1.id);
            tskList.add(tsk13);
            
            Task tsk14 = new Task(whoId = ct1.ID, Category__c='Email Send', Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 4, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'BDA Touch', OwnerId = u1.id);
            tskList.add(tsk14);
            
            Task tsk15 = new Task(whoId = ct1.ID, Category__c='Call-Inbound', Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 3, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Recruiting', OwnerId = u1.id);
            tskList.add(tsk15);
            
            Task tsk16= new Task(whoId = ct1.ID, Category__c='Call-Inbound', Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 3, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'BDA Touch', OwnerId = u1.id);
            tskList.add(tsk16);
            
            Task tsk17= new Task(whoId = ct1.ID, Category__c='Home Office Visit', Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 3, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Recruiting', OwnerId = u1.id);
            tskList.add(tsk17);
            
            Task tsk18= new Task(whoId = ct1.ID, Category__c='Meeting – New Recruit', Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 3, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Recruiting', OwnerId = u1.id);
            tskList.add(tsk18);
            Task tsk19= new Task(whoId = ct1.ID, Category__c='Meeting – Wholesaler', Subject = 'Agile Email Follow Up', ActivityDate = System.Today() + 3, Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'Recruiting', OwnerId = u1.id);
            tskList.add(tsk19);
            insert tskList;
            
            test.stopTest();
        }  catch(Exception e) {
            system.assertEquals(e.getMessage(), e.getMessage()); 
        }
    }
}