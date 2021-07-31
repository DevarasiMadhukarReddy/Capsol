/**
 * testSalesforceContactService.cls
 * Description  : Provides the unit test cases for the visualforce controller "ExpenseReportEditorController"
 * 
 * @Author      : Subhash Ghorpade (Cognizant)
 * @version     : 1.0
 * @CreatedDate : April 30,2015
 */
@isTest
private class testSalesforceContactService {
    
    static User InternalAdvisoryConsultant;
    static User RegionalAdvisoryConsultant;
    
    static Contact salesforcecontact;

    static Exceptions_History__c  exce;
    
    static Exceptions_History__c  exce1;
    
    static list<Exceptions_History__c>  exceList;

    static testMethod void testContactService() {
        
     Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
      salesforcecontact = testDataSetUpUtility.getNewContactCreated(); 

      insert  salesforcecontact;

      exce = testDataSetUpUtility.getNewExceptionCreated();
      
      exce.Contact__c=salesforcecontact.id;
      
      insert exce;
      
      exce1= testDataSetUpUtility.getNewExceptionCreated();
      
      exce1.Contact__c=salesforcecontact.id;
      
      insert exce1;
       
      SalesforceContactService.ResponseContactsAndExceptionsClass cont=SalesforceContactService.getSalesforceContact('12345');      
       System.debug('SalesforceContactService.SalesforceContactClass=============================='+cont);

       SalesforceContactService.ResponseContactsAndExceptionsClass cont1=SalesforceContactService.getSalesforceContact('');      
       System.debug('SalesforceContactService.SalesforceContactClass blank rep ID=============================='+cont1);

       SalesforceContactService.ResponseContactsAndExceptionsClass cont2=SalesforceContactService.getSalesforceContact('1234589');      
       System.debug('SalesforceContactService.SalesforceContactClass invalid rep ID=============================='+cont2);


       }
}