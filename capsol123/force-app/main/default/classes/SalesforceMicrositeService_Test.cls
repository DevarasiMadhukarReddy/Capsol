/**
* SalesforceMicrositeService_Test.cls
* Description  : This is test class for SalesforceMicrositeService.cls 
* 
* @Author      : Vaibhav Wadhai(Cognizant)
* @version     : 1.0
* @CreatedDate : Oct 11 ,2017

*/

@isTest
public class SalesforceMicrositeService_Test {
    
    public static testMethod void testMyWebService1() {
        Test.startTest();
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
        
        //creation of user
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',Title = 'title',Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US'
        );
        insert u;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Id contactLPLAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Contact con = LPL_testDataSetUpUtility.createContact('Test Contact',a1.id,contactLPLAdvisor);
        con.Request_To_Join_As__c = LPL_StaticDataUtility.REQUEST_NLA;
        con.Channel__c ='IAS';
        con.Source_Type_Prospect__c ='Transitions';
        con.Lead_Source__c='Transitions'; 
        insert con;
        
        Opportunity op1 = new Opportunity(Request_To_Join_As__c='Test',AccountId = a1.id, 
                                          name = 'Test opportunity', CloseDate =  system.today(),
                                          StageName = '1 - Unscreened Contact',Zip_Code__c = '80538',
                                          GDC_Prior_12_mo__c = 200,email__c='abc@gmail.com',
                                          GRC_Status__c='Excluded',Assigned_to_GRC_Analyst__c=system.today(),
                                          eKit_Received__c=system.today(),Internal_Target_TAT_Date__c=system.today(),
                                          Rep_ID__c='Z349',Location_Type__c='Test Location',
                                          Expected_AUM__c=222,TAT_GDC__c=5555,Assigned_to_OBA_Analyst__c=system.today(),
                                          Review_Status__c='Completed',Integration_Manager__c=u.id,
                                          Regional_Transition_Partner__c=u.Id,Contact__c=con.id);
        insert op1;
        List<task> taskList=new List<task>();
        Task t1 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t1.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_MARKETING_STATIONARY_ITEMS_APPROVAL;
        taskList.add(t1);
        Task t2 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t2.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_CONFIRM_MANDATORY_TRAININGS_COMPLETE;
        taskList.add(t2);
        Task t3 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t3.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SUBMIT_TAT_REQUEST;
        taskList.add(t3);
        Task t4 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t4.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SUBMIT_TAT_REQUEST;
        t4.Status = 'In Progress';
        taskList.add(t4);
        Task t5 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t5.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS;
        taskList.add(t5);
        Task t6 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t6.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_INSURANCE_AND_ANNUITY_APPOINTMENTS;
        taskList.add(t6);
        Task t7 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t7.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS;
        t7.Status = LPL_StaticDataUtility.STATUS_SENT;
        taskList.add(t7);
        Task t8 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t8.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS;
        t8.Status = LPL_StaticDataUtility.STATUS_SCHEDULED;
        taskList.add(t8);
        Task t9 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t9.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_INSURANCE_AND_ANNUITY_APPOINTMENTS;
        t9.Status = LPL_StaticDataUtility.STATUS_SCHEDULED;
        taskList.add(t9);
        Task t10 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t10.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SUBMIT_TAT_REQUEST;
        t10.Status = LPL_StaticDataUtility.STATUS_SENT;
        Task t11 =LPL_testDataSetUpUtility.createTaskCheck(op1.id,u.id);
        t11.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_CONFIRM_MANDATORY_TRAININGS_COMPLETE;
        t11.Activity_with_a_Status_N_A__c= true;
        taskList.add(t10);
        insert taskList;
        SalesforceMicrositeService.result   optyresult=new SalesforceMicrositeService.result();
        SalesforceMicrositeService.sendActivityDetails(String.valueOf(op1.id));
        test.stopTest();
    }
    
    public static testMethod void testMyWebService2() {
        SalesforceMicrositeService.sendActivityDetails('');
    }
    
    public static testMethod void testMyWebService3() {
        Test.startTest();
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,LastName = 'last',
            Email = 'puser000@amamama.com',Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',Title = 'title',Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US'
        );
        insert u;
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        Id contactLPLAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Contact con = LPL_testDataSetUpUtility.createContact('Test Contact',a1.id,contactLPLAdvisor);
        con.CRD_Number__c='123';
        con.Source_Type_Prospect__c ='Transitions';
        con.Lead_Source__c='Transitions'; 
        insert con;
        Opportunity opp = new Opportunity(AccountId = a1.id, name = 'Test opportunity',
                                          CloseDate =  system.today(),StageName = '1 - Unscreened Contact',
                                          Contact__c=con.Id);
        insert opp;
        List<task> taskList=new List<task>();
        Task t1 =LPL_testDataSetUpUtility.createTaskCheck(opp.id,u.id);
        t1.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS;
        t1.Status=LPL_StaticDataUtility.STATUS_DEFERRED;
        taskList.add(t1);
        Task t2 =LPL_testDataSetUpUtility.createTaskCheck(opp.id,u.id);
        t2.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SUBMIT_TAT_REQUEST;
        t2.Status=LPL_StaticDataUtility.STATUS_NOT_STARTED;
        taskList.add(t2);
        Task t3=LPL_testDataSetUpUtility.createTaskCheck(opp.id,u.id);
        t3.Activity_Type__c = LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS;
        t3.Status='Test';
        taskList.add(t3);
        insert taskList;
        SalesforceMicrositeService.sendActivityDetails(opp.id);
        SalesforceMicrositeService.sendActivityDetails('Test');
        test.stopTest();
    }
}