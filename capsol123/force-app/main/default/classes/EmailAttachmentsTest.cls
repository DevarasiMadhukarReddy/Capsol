@isTest(seeAlldata=false)
public class EmailAttachmentsTest {
    static testMethod void insertLoanApplicationTest2(){
    User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'madhukar.reddy@lpl.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u1;
        system.debug('***u1'+u1);
        //system.runAs(u1){
        list<Loan_Application__c> lstlaon=new list<Loan_Application__c>();
        Loan_Application__c loanApp = new Loan_Application__c();
        loanApp.Legal_Entity__c = 'Corporation';
        loanApp.Status__c='Document Requested';
        loanApp.Assigned_Recruiter__c = u1.id;
        loanApp.Preparer_Email__c='abc@test.com';
        
        system.debug('***loanApp'+loanApp);
        lstlaon.add(loanApp);
        insert lstlaon;
        system.debug('***lstlaon'+lstlaon);
     
        //List<Task> ts= new list<task>();
        //Task tsk1 = new Task( Subject = 'Agile Email Follow Up',Category__c = 'Left Message – Prospecting',peopleai__Created_by_PeopleAI__c=true, ActivityDate = System.Today(), Status = 'Completed',Department__c = 'Business Development',Activity_Type__c = 'IRD Touch',Email_Loan_application__c=lstlaon[0].Preparer_Email__c,Assigned_Recruiter1__c='madhukar.reddy@lpl.com');
        //ts.add(tsk1);
        //insert ts;
         //system.debug('***ts'+ts);
        Note testNote = new Note();
        testNote.Title = 'Test Account Note';
        testNote.Body = 'Test Account Note Body.';
        testNote.ParentId = loanApp.Id;           
        test.startTest();
        insert testNote;
        EmailAttachments ematt= new EmailAttachments();
        ematt.getLoanApplication();
        test.stopTest();
    }
    
  //  }
}