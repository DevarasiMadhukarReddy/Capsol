@isTest
public class CLSresendWelcomeEmail_TEST {
    
    
    public static testMethod void testCLSresendWelcomeEmail(){
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
          
        );
        insert u;
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Completed';
        t.Priority='Normal';
		t.Activity_Type__c='Initial Call Out';
        t.OpportunityEmail__c='test@test.com';
        t.Fire_Email__c=true;
        insert t; 
       t.Priority='High';
	   update t;	   
	   CLSresendWelcomeEmail.resendWelcomeEmail(t.id);
     
        
       
    }
    public static testMethod void testCLSresendWelcomeEmail1(){
       Task t2 = new Task();
        t2.OwnerId = UserInfo.getUserId();
        t2.Subject='Donni1';
        t2.Status='In Progress';
        t2.Priority='Normal';
		t2.Activity_Type__c='Advisor Recruitingt1';
        t2.OpportunityEmail__c='';
        t2.Fire_Email__c=false;
        insert t2; 
       t2.Priority='High';
	   update t2;	   
	   CLSresendWelcomeEmail.resendWelcomeEmail(t2.id); 
       
       
        
    }
   
}