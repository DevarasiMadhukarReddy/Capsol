@isTest
public class sendEmailTaskHandler_Test {
    static testmethod void test_TaskControllerExtension() {
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert ct1;
        
        List<Opportunity> oppList = new List<Opportunity>(); 
        Opportunity opp = new Opportunity();
        opp.Assigned_Recruiter__c = UserInfo.getUserID();
        opp.Internal_Recruiter_IRD__c =UserInfo.getUserID();
        opp.Regional_VP__c = UserInfo.getUserID();
        opp.Name ='test';
        opp.Forgivable_Loan__c=1.0;
        opp.OSJ_Rep_ID__c='test';
        opp.Hire_Date__c=system.today();
        opp.Credit_to_OSJ__c=7.0;
        opp.StageName ='test1';
        opp.CloseDate = system.today();
        // insert opp;
        
        oppList.add(opp);
        List<Loan_Application__c> loanApplicationList = new List<Loan_Application__c>();
        Id TransitionAssistanceRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
        Loan_Application__c loanApp = new Loan_Application__c();
        loanApp.Legal_Entity__c = 'Individual';
        loanApp.Advisor__c = ct1.id;
        loanApp.Opportunity__c=opp.Id;
        loanApp.Primary_Contact__c = true;
        loanApp.Status__c='Funded';
        loanApp.Assigned_Recruiter__c = opp.Assigned_Recruiter__c;
        // loanApp.Assigned_Recruiter_Email__c='test@test.com';
        loanApp.Internal_Recruiter__c = opp.Internal_Recruiter_IRD__c;
        loanApp.Business_Developer__c = opp.Regional_VP__c;
        loanApp.RecordTypeId = TransitionAssistanceRecordTypeId;
        insert loanApp;
        
        Loan_Application__c loanApp1 = new Loan_Application__c();
        loanApp1.Legal_Entity__c = 'Individual';
        loanApp1.Advisor__c = ct1.id;
        loanApp1.Opportunity__c=opp.Id;
        loanApp1.Primary_Contact__c = true;
        loanApp1.Status__c='Funded';
        loanApp1.Assigned_Recruiter__c = opp.Assigned_Recruiter__c;
        // loanApp.Assigned_Recruiter_Email__c='test@test.com';
        loanApp1.Internal_Recruiter__c = opp.Internal_Recruiter_IRD__c;
        loanApp1.Business_Developer__c = opp.Regional_VP__c;
        loanApp1.RecordTypeId = TransitionAssistanceRecordTypeId;
        insert loanApp1;
        
        loanApplicationList.add(loanApp);
        loanApplicationList.add(loanApp1);
        list<Task> lsttsk=new list<Task> ();
        list<Task> lsttsk1=new list<Task> ();
        Task tsk= new Task(whatid =loanApplicationList[0].id , OwnerId = Userinfo.getUserId() ,Status='Completed',Subject='apex'); 
        Task tsk1= new Task(whatid =loanApplicationList[1].id , OwnerId = Userinfo.getUserId() ,Status='Completed',Subject='apex'); 
        // insert tsk;
        lsttsk.add(tsk);
        lsttsk1.add(tsk1);
        insert lsttsk;
        insert lsttsk1;
        Test.startTest(); 
        
        sendEmailTaskHandler controller = new sendEmailTaskHandler(); 
        
        sendEmailTaskHandler.taskBeforeInsert(lsttsk);
        sendEmailTaskHandler.taskAfterInsertandUpdate(lsttsk1);
        Test.stopTest(); 
        
    }
    
}