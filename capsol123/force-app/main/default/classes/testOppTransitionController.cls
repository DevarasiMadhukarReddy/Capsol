/*  ******** Lead Onboarding Changes VF Controller Test Class ********** */


@isTest(seeAllData = false)
public class testOppTransitionController{
    private static Account a1;
    private static Opportunity op1;
    private static User u;
    private static Contact ct1;
    
    static testMethod void testOppController(){
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact_Merge_User_Assignment__c cmUA = new Contact_Merge_User_Assignment__c();
        cmUA.Name = 'Kara Mackie';
        cmUA.User_ID__c = '005U0000004h0p7';
        insert cmUA;
        
        a1 = new Account(Name = 'Test Account');
        insert a1;
        
        ct1= new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
        insert ct1;
        
        op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity', CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                              , Transition_Support_Partners__c = UserInfo.getUserID(), Investment_Transition_Consultant__c = UserInfo.getUserID(),
                              Regional_Transition_Partner__c = UserInfo.getUserID(),Integration_Manager__c= UserInfo.getUserID());
        insert op1;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(op1);
        OppTransitionActivitiesController controller = new OppTransitionActivitiesController(); 
        
        controller.getgetAdvisorDetails();
        controller.getgetOCTaskDetails();
        controller.getgetRTPTaskDetails();
        controller.getgetITPTaskDetails();
        controller.getgetTSPTaskDetails();
        controller.backToOpportunity();
    }
}