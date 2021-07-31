@isTest(SeeAllData=true)
private class CT_TestTaskTriggers{
    private static Account a1;
    private static Opportunity op1;
    private static User u;
    private static Contact ct1;
    private static Lead le1;
    
    static {   
        u = [SELECT Country FROM User WHERE (Id = :UserInfo.getUserId()) LIMIT 1];
        
        a1 = new Account(Name = 'Test Account');
        insert a1;
        
        op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity', CloseDate =  system.today(), StageName = '1 - Unscreened Contact');
        insert op1;
        
        ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
        insert ct1;
        
        le1= new Lead(LastName ='tetCogni', Company='Cogni', LeadSource='Banner', Status='Contact Attempted', Discovery_Last_Name__c='tetCogni');
        insert le1;
        
    }
    
    static testMethod void testTrigger(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        //insert tbp;
        
        Test.startTest(); 
        List<Task> tskList = new List<Task>();
        
        Task t1 = new Task(whatid = op1.id, Status = 'Completed', Department__c = 'Business Development', Subject='Email: Can Your Firm Support Your Advisory Transition?', Activity_Type__c = 'BDA', Category__c = 'Left Message', ownerid=u.id);
        tskList.add(t1);
        Task t2 = new Task(whatid = op1.id, Status = 'Completed', Department__c = 'Business Development', Subject='test event', 
                           Activity_Type__c = 'BDA', Category__c = 'Call-Inbound', ownerid=u.id);
        tskList.add(t2);
        op1.StageName = '2 - Contact Initiated';
        Task t3 = new Task(whatid = op1.id, Status = 'Completed', Department__c = 'Business Development',Subject='test event', 
                           Activity_Type__c = 'IRD Touch', Category__c = 'Call-Outbound', ownerid=u.id);
        tskList.add(t3);
        op1.StageName = '2 - Contact Initiated';
        Task t4 = new Task(whatid = op1.id, Status = 'Completed', Department__c = 'Business Development',Subject='test event', 
                           Activity_Type__c = 'Master Recruiting', Category__c = 'Call-Outbound', ownerid=u.id);
        tskList.add(t4);
        op1.StageName = '2 - Contact Initiated';
        
        Task t5 = new Task(whatid = op1.id, Status = 'Completed', Department__c = 'Business Development',Subject='test event', 
                           Activity_Type__c = 'Recruiting', Category__c = 'Call-Outbound', ownerid=u.id);
        tskList.add(t5);     
        op1.StageName = '2 - Contact Initiated';
        
        Task t6 = new Task(whatid = op1.id, whoId=ct1.id, Status = 'Completed', Department__c = 'Business Development',Subject='apex', Activity_Type__c = 'Recruiting', Category__c = 'Call-Outbound', ownerid=u.id);
        tskList.add(t6);   
        insert tskList;
        Test.stopTest();               
    }
    
    static testmethod void test_TaskControllerExtension() {
        
        Test.startTest(); 
        Task tsk= new Task(whatid =op1.id , OwnerId = Userinfo.getUserId() ,Status='Support Requested',Subject='apex'); 
        insert tsk;       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(tsk);
        TaskControllerExtension controller = new TaskControllerExtension(sc); 
        
        controller.uploadFile();
        Test.stopTest(); 
    }
    
    static testmethod void test_TaskEmailAlertFunctionality() {
        Test.startTest(); 
        Task tsk= new Task(whoid =ct1.id , OwnerId = Userinfo.getUserId() ,Subject='test 123'); 
        insert tsk;       
        
        Contact con = [select id, Lpl_Attachment_Sent__c, Lpl_Attachment_Sent_Date__c from Contact where Id =:ct1.Id];
        Test.stopTest(); 
    }
    
    static testmethod void test_TaskLeadTaskFunctionality() {
        Test.startTest(); 
        Task t3 = new Task(whoid = le1.id, Status = 'Completed', Department__c = 'Business Development',Subject='test event', Activity_Type__c = 'IRD Touch', Category__c = 'Call-Outbound', ownerid=u.id);
        insert t3;
        t3.Status ='TEst Department';
        Test.stopTest();
    }
    
    /*  ******** Lead Onboarding Changes test Method ********** */
    static testmethod void test_TaskTriggerHandler() {
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
        Task tsk4= new Task(whatid =op1.id , OwnerId = Userinfo.getUserId() ,Status='Deferred',Subject='apex'); 
        insert tsk4;       
        
        tsk4.Status ='Completed';
        Test.startTest(); 
        update tsk4;
        
        Task tsk5= [select id, Status_Deferred_Exit__c ,Status_Completed_Entry__c , Status  from Task where id =: tsk4.id limit 1];
        system.assert(tsk5.Status == 'Completed');
        Test.stopTest();   
    }
    static testmethod void test_TaskTriggerHandler2() {
        
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
            contactObj.Lead_Source__c = 'Transitions';
            contactObj.Source_Type_Prospect__c ='Transitions';
            contactList.add(contactObj);
        }
        insert contactList;
        for(Integer i=0 ;i <11;i++){
            Opportunity opp = new Opportunity();
            opp.AccountId=accountList[i].Id;
            opp.Contact__c=contactList[i].Id;
            opp.Name='test'+i;
            opp.Request_Type__c='Direct';
            opp.CloseDate=Date.today();
            opp.StageName='Closed-lost'; 
            opp.lost_outcome__c='Unknown';
            opp.Probability=50;
            opportunityList.add(opp);
        }
        insert opportunityList;
        Opportunity Op11 = [select id from Opportunity where id= : opportunityList limit 1];
        Op11.StageName='Closed-lost';
        op11.lost_outcome__c='Unknown';
        update Op11;
    }
}