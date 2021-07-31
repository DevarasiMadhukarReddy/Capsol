@isTest
private class testSalesforceAEMService {    
        
    static Contact salesforcecontact;
    
    static User salesforceuser;

    static String repId;
    
    static String email;   

    static testMethod void testContactService() {
       Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
      salesforcecontact = testDataSetUpUtility.getNewContactCreated(); 

      insert  salesforcecontact;     
       
          String cont=SalesforceAEMService.checkSalesforceContactValidity('testAem@lpltest.com');     
          System.assertEquals(cont,'True'); 
         // String cont2=SalesforceAEMService.checkSalesforceContactValidity('','testAem@lpltest.com');   
         // System.assertEquals(cont2,'True');    
          String cont1=SalesforceAEMService.checkSalesforceContactValidity('');  
          System.assertEquals(cont1,'False');   
       }
       
       
     /**   static testMethod void testUserService() {
        
          String cont=SalesforceAEMService.checkSalesforceUserValidity('subhashchandran.ghorpade@lpl.com');     
          System.assertEquals(cont,'false'); 
     
       }
       */
}