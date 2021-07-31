@isTest
private class LPL_ChangeEloquaContactEmailAddressTgr
{
   
   static testMethod void validateHelloWorld() 
    {
       
Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
      Account oAcct  = new Account ();
      oAcct.Name ='Account Test Record';
      insert oAcct;
     
      contact c=new contact(lastname='testing',firstname='apex',email='test676@gmail.com',AccountId = oAcct.Id);
     
      Insert c;
     
      c.firstname='test1';
      c.email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com';
      Test.startTest();
          update c;
      Test.stopTest();
    }
}