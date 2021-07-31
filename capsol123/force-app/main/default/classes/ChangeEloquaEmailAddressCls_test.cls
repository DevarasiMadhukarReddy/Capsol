@isTest(seealldata=true)
private class ChangeEloquaEmailAddressCls_test
{
   static testMethod void validateHelloWorld() 
    {
map<string,string> emailz = new map<string,string>();
emailz.put('abc@abc.com','abc@abc.com');
     ChangeEloquaEmailAddressCls.ChangeEloquaEmailAddress(emailz);
     // c = new ChangeEloquaEmailAddressCls.ChangeEloquaEmailAddress();
    }
}