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
private class ContactHierarchyTestData {

    static testMethod void myUnitTest() 
    {
          Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        // TO DO: implement unit test
        Account aa = new Account();
        Contact ca = new Contact();
        Contact cb = new Contact();
        Contact cc = new Contact();
        
        aa.Name = 'Test Account';
        insert aa;
        
        ca.AccountId=aa.Id;
        cb.AccountId=aa.Id;
        cc.AccountId=aa.Id;
        
        ca.LastName='Test a';
        cb.LastName='Test b';
        cc.LastName='Test c';
        
        ca.Rep_Status__c = 'Active';
        cb.Rep_Status__c = 'Active';
        cc.Rep_Status__c = 'ACtive';
        
        ca.Role__c = 'OSJ';
        cb.Role__c = 'Non-OSJ';
        cc.Role__c = 'Rep';
        
        insert ca;
        insert cb;
        insert cc;
        
        cb.ReportsToId=ca.Id;
        cc.ReportsToId=cb.Id;
        update cb;
        update cc;
        
        PageReference ContactHierarchyTree = Page.ContactHierarchyTree;
        Test.setCurrentPage( ContactHierarchyTree );
            
        // Instanciate Controller
        ContactStructure controller = new ContactStructure();
        
        // Call Methodes for top contact
        controller.setcurrentId( ca.id );
        ContactStructure.ObjectStructureMap[] smt1 = new ContactStructure.ObjectStructureMap[]{};
        smt1 = controller.getObjectStructure();

        controller.setcurrentId( cb.id );
        ContactStructure.ObjectStructureMap[] smt2 = new ContactStructure.ObjectStructureMap[]{};
        smt2 = controller.getObjectStructure();
        System.Assert( smt2.size() > 0, 'Test failed at Top account, with Id: '+smt2.size() );
        controller.setcurrentId( cc.id );
        ContactStructure.ObjectStructureMap[] smt3 = new ContactStructure.ObjectStructureMap[]{};
        smt3 = controller.getObjectStructure();   
        System.Assert( smt3.size() > 0, 'Test failed at Middle account, with Id: '+smt3.size() );
        
    }
}