/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Test class for Batch - LPL_Last_BC_Contact_Date_Batch         Ashish Gupta                  7 August 2018


*/

@isTest(SeeAllData=False)
public class LPL_Last_BC_Contact_Date_Batch_Test {
    
    @testSetup static void testData() {
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'IAS RMBC');
        insert r;
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS User'].Id,
            FirstName='ashish',
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
            UserRoleId = r.Id
        );
        insert u1;
    }
    
    public static testmethod void contactDateUpdateBatchTest() {
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
        Last_Office_BC__c lastOffice = LPL_testDataSetUpUtility.createLastOffice('IAS RMBC','Test');
        insert lastOffice;
        
        Id contactLPLAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Id contactLPLAdvisorAssistant= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Assistant').getRecordTypeId();
        Id accRT1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Development Opportunity').getRecordTypeId();
        Id taskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Master').getRecordTypeId();
        
        Account acc1 = new Account();
        acc1.Name = 'Account 1';
        acc1.RecordTypeId = accRT1;
        insert acc1;
        List<String> activityType = new List<String>{LPL_StaticDataUtility.ACTIVITY_REGIONAL_MEETING, 
            LPL_StaticDataUtility.ACTIVITY_VIRTUAL_STUDY_GROUP, LPL_StaticDataUtility.ACTIVITY_EOV,
            LPL_StaticDataUtility.ACTIVITY_VIRTUAL_OFFICE_VISIT,LPL_StaticDataUtility.ACTIVITY_FIELD_OFFICE_VISIT,'Test'};
        List<Contact> conList = new List<Contact>();
        for(Integer i=0; i<=activityType.size()+3;i++){
            Contact con = LPL_testDataSetUpUtility.createContact('Test Contact '+i,acc1.Id,contactLPLAdvisor);
            conList.add(con);
        }
        conList[0].Last_Regional_Meeting__c= date.newInstance(2018, 01, 10);
        conList[0].Last_Study_Group__c= date.newInstance(2018, 01, 10);
        conList[0].Last_HOV__c= date.newInstance(2018, 01, 10);
        conList[0].Last_VOV__c= date.newInstance(2018, 01, 10);
        conList[0].Last_FOV__c= date.newInstance(2018, 01, 10);
        conList[0].Last_BC_contact_date__c= date.newInstance(2018, 01, 10);
        insert conList;
        
        User u1= [SELECT Id,Email,Name from User Where Email ='ashish.gupta@lpl.com' limit 1];
        
        List<Task> taskList = new List<Task>();
        for(Integer i=0; i<3;i++){
            for(String actType : activityType){
                Task tsk = LPL_testDataSetUpUtility.createTask(conList[i].id,u1.id);
                tsk.Activity_Type__c=actType;
                taskList.add(tsk);
            }
        }
        insert taskList;
        
        List<TaskRelation> tskRelList = new List<TaskRelation>();
        for(Integer i=0;i<activityType.size();i++){
            TaskRelation tskRel = new TaskRelation(RelationId=conList[i+3].id,TaskId=taskList[i].id);
            tskRelList.add(tskRel);
        }
        insert tskRelList;
        
        test.startTest();
        LPL_Last_BC_Contact_Date_Batch batchjob =new LPL_Last_BC_Contact_Date_Batch();
        Database.executeBatch(batchjob);
        test.stopTest();
        system.assertNotEquals(conList[0].Last_BC_contact_date__c,null);
        system.assertNotEquals(conList[0].Last_Study_Group__c,null);
        system.assertNotEquals(conList[0].Last_HOV__c,null);
        
    }
}