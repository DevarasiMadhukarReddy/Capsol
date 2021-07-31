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
private class TestAcctFA {

    static testMethod void myUnitTest() {
        List<Account> clients = new List<Account>{};
        RecordType bnet = [select Id from RecordType where Name = 'BranchNet'];
        
        for(Integer i = 0; i < 250; i++){           
            Account a = new Account( LastName = 'Test Account ' + i, RecordTypeId = bnet.Id, Type = 'Individual');
            clients.add(a);
        }
        
        Profile p = [select id from profile where name='IS User']; 
        User u = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='hrwf@2dimtech.com');

        System.runAs(u) {       
            Test.startTest();
            try {
                insert clients;
            
                List<LPLCRM__Financial_Account__c> accounts = new List<LPLCRM__Financial_Account__c>{};
                
                for(Integer i = 0; i < 250; i++){
                    LPLCRM__Financial_Account__c a = new LPLCRM__Financial_Account__c(Name = 'Test FA ' + i, LPLCRM__Client__c = clients[i].Id);
                    accounts.add(a);
                }
                
                insert accounts;
                
                clients[0].Description = 'test';
                update clients;
                
                accounts[0].LPLCRM__LPL_Policy_No__c = 'test';
                update accounts;
                
                delete accounts;                
                delete clients;
            }
            catch(DmlException d) {
    
                d.getMessage();
    
            }
        }
        u.IsActive = false;
        update u;
    }
}