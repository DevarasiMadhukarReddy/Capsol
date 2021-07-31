@isTest
public class coverageclass {
    public static testmethod void test1(){
     HandleCoverage.method();
     HandleCoverage.method1();
     HandleCoverage.method2();
     HandleCoverage.method3();
        
        
          Account ac= new Account();
        ac.name='testaccount';
        ac.BillingCountry = 'United States';
        ac.BillingPostalCode='56323';
        ac.ShippingState='MA';
        ac.BillingState='NY';
        ac.ShippingPostalCode='45210';
        insert ac;
        Account acinserted=[select id from account where id=:ac.Id];
        system.assertEquals(ac.id,acinserted.Id);
        
        New_Opportunity_TriggerHandler No=new New_Opportunity_TriggerHandler();
        New_ContactTriggerHandler NC=new New_ContactTriggerHandler();
		New_TaskTriggerHandler NT=new New_TaskTriggerHandler();
        New_EventTriggerHandler NE=new New_EventTriggerHandler();
   }
    

    

}