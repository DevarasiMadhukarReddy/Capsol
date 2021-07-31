/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class atRiskLastModified_Test {

    static testMethod void myUnitTest() 
    {
        /*
        // TO DO: implement unit test
        Account oAcct  = new Account ();
             oAcct.Name ='Account Test Record';
        insert oAcct;
        
        Contact c1 = new Contact (LastName = 'Test C1', AccountId = oAcct.Id);
        Contact c2 = new Contact (LastName = 'Test C2', AccountId = oAcct.Id);
        
        insert c1;
        insert c2;
        
        c1.At_Risk__c = 'Green';
        c2.At_Risk_Comments__c = 'Blah';
        
        list<Contact> ac = new list<Contact>();
        ac.add(c1);
        ac.add(c2);
        
        update ac;
        
        ac.clear();
        
        c1.At_Risk__c = 'Red';
        c2.At_Risk_Comments__c = 'Blah2';
        
        ac.add(c1);
        ac.add(c2);
        update ac;
        */
        
        
    }
}