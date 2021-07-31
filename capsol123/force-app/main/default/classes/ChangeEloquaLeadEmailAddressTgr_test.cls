@isTest(seealldata=false)
private class ChangeEloquaLeadEmailAddressTgr_test
{
   static testMethod void validateHelloWorld() 
    {
        /*****Added by Rinku to resolve test class issue******/
        Lead ld = new Lead(lastname = 'TestLead', email = 'abc@email.com');
        insert ld;
     	Lead c=new Lead();
     	c=[select id from lead where email!=NULL limit 1];
     	c.lastname='test1';
     	c.email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com';
     	update c;

    }
}