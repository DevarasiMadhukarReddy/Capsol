@isTest(SeeAllData=true)
private class CT_TestEventTriggers{
    private static Account a1;
    private static Opportunity op1;
    private static User u;
    public static Contact ct1;
    
    static testMethod void testTrigger(){
        Test.startTest(); 
        u = [SELECT Country FROM User WHERE (Id = :UserInfo.getUserId()) LIMIT 1];
        
        a1 = new Account(Name = 'Test Account');
        insert a1;
        
        op1 = new Opportunity(AccountId = a1.id, GDC_Prior_12_mo__c = 200, name = 'Test opportunity', CloseDate =  system.today(), StageName = '1 - Unscreened Contact');
        insert op1;
        
        ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname',Source_Type_Prospect__c  ='Transitions',Lead_Source__c='Transitions' );
        insert ct1;
        
        Event e1 = new Event(whatid = op1.id, Department__c = 'Business Development', Subject='test event', Activity_Type__c = 'BDA', 
                             Category__c = 'Left Message', ownerid=u.id, DurationInMinutes=10,ActivityDateTime=System.today());
        insert e1;
        
        Event e2 = new Event(whoid = ct1.id, Department__c = 'Business Development', Subject='test event', Activity_Type__c = 'BDA', 
                             Category__c = 'Left Message', ownerid=u.id, DurationInMinutes=10,ActivityDateTime=System.today());
        insert e2;
        
        Event e3 = [select id ,Department__c  from Event where id =: e2.Id limit 1];
        e3.Department__c  = 'Testing Update';
        update e3;
        Test.stopTest();               
    }
}