/**
* LPL_UserDetailService_Test.cls
* Description  : This is test class for LPL_UserDetailService.cls 
* 
* @Author      : Garvita Rai(Cognizant)
* @version     : 1.0
* @CreatedDate : Oct 29 ,2018

*/

@isTest
public class LPL_UserDetailService_Test{
    
    public static testMethod void testMyWebService1() {
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
        
        List<Opportunity> opList = new List<Opportunity>();
        Opportunity op1 = new Opportunity(AccountId = a1.id, Name = 'Test opportunity', CloseDate =  system.today(),
                                          StageName = '1 - Unscreened Contact',email__c='abc@gmail.com',
                                          Integration_Manager__c=u.id,Regional_Transition_Partner__c=u.Id,
                                          Transition_Support_Partner_Secondary__c=u.id,Transition_Support_Partners__c=u.id,
                                          Investment_Transition_Consultant__c=u.id,Project_Manager__c=u.id);
        Opportunity op2 = new Opportunity(AccountId = a1.id,Name = 'Test opportunity 2', CloseDate =  system.today(),
                                          StageName = '2 - Unscreened Contact',email__c='abc2@gmail.com');
		Opportunity op3 = new Opportunity(AccountId = a1.id, Name = 'Test opportunity', CloseDate =  system.today(),
                                          StageName = '1 - Unscreened Contact',email__c='abc@gmail.com',
                                          Project_Manager__c=u.id);
		Opportunity op4 = new Opportunity(AccountId = a1.id, Name = 'Test opportunity', CloseDate =  system.today(),
                                          StageName = '1 - Unscreened Contact',email__c='abc@gmail.com',
                                          Regional_Transition_Partner__c=u.Id);
		Opportunity op5 = new Opportunity(AccountId = a1.id, Name = 'Test opportunity', CloseDate =  system.today(),
                                          StageName = '1 - Unscreened Contact',email__c='abc@gmail.com',
                                          Investment_Transition_Consultant__c=u.Id);
		Opportunity op6 = new Opportunity(AccountId = a1.id, Name = 'Test opportunity', CloseDate =  system.today(),
                                          StageName = '1 - Unscreened Contact',email__c='abc@gmail.com',
                                          Transition_Support_Partner_Secondary__c=u.Id);
										  
        opList.add(op1);
        opList.add(op2);
		opList.add(op3);
		opList.add(op4);
		opList.add(op5);
		opList.add(op6);
        insert opList;
        
        Test.startTest();
        LPL_UserDetailService.getResponse(op1.id);
        LPL_UserDetailService.getResponse(op2.id);
		LPL_UserDetailService.getResponse(op3.id);
		LPL_UserDetailService.getResponse(op4.id);
		LPL_UserDetailService.getResponse(op5.id);
		LPL_UserDetailService.getResponse(op6.id);
        LPL_UserDetailService.getResponse(a1.id);
        LPL_UserDetailService.getResponse('');
        test.stopTest();
    }
}