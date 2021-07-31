/******** Test class for baqViewController class**********/
//created By:Sujith komuravelly
//Date:01/15/2019

@isTest(seeAllData = false)
public class testbaqViewController{
    
    private static Account acc;
    private static Opportunity opp;
    private static BAQ__c baq;
    private static Contact con;
    
    
    static testMethod void testBaqController(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        acc = new Account(Name = 'Test Account');
        insert acc;
        
        con= new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',AccountId = acc.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
        insert con;
        
        opp = new Opportunity(AccountId = acc.id, name = 'Test opportunity', CloseDate =  system.today(), StageName = '1 - Unscreened Contact');
        insert opp;
        
        baq = new baq__c(Contact__c = con.id, Opportunity__c = opp.id, Current_Custodian__c = 'Test Custodian', Joining_RIA_or_Corporate__c ='RIA', Number_of_Advisors__c = 4);
        insert baq;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(baq);
        baqViewController controller = new baqViewController(sc ); 
        
        PageReference pageRef = Page.baqViewPage; //replace with your VF page name
        
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL 
        ApexPages.currentPage().getParameters().put('Id', 'baq.id');
        controller.baq = baq;
        System.assertNotEquals(null, baq );
        System.assertNotEquals(controller.baq , baq );
    }
    
    static testMethod void testBaqController2(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        acc = new Account(Name = 'Test Account');
        insert acc;
        
        con= new Contact(Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',AccountId = acc.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
        insert con;
        
        opp = new Opportunity(AccountId = acc.id, name = 'Test opportunity', CloseDate =  system.today(), StageName = '1 - Unscreened Contact');
        insert opp;
        
        baq = new baq__c(Contact__c = con.id, Opportunity__c = opp.id, Current_Custodian__c = 'Test Custodian', Joining_RIA_or_Corporate__c ='RIA', Number_of_Advisors__c = 4);
        insert baq;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(baq);
        baqViewController controller = new baqViewController(sc ); 
        
        PageReference pageRef = Page.baqViewPage; //replace with your VF page name
        
        Test.setCurrentPage(pageRef);
        
        controller.baq = baq;
        // Add parameters to page URL 
        ApexPages.currentPage().getParameters().put('Id', 'baq.id');
        
    }
    
    static testMethod void testBaqController3(){
        
        List<baq__c> baqList = new List<baq__c>();
        baq__c baqRecord = new baq__c();
        baqRecord.Current_Custodian__c = 'Test Custodian';
        baqRecord.Joining_RIA_or_Corporate__c ='RIA';
        baqRecord.Number_of_Advisors__c = 4;
        baqList.add(baqRecord);
        
        test.startTest();
        insert baqList;
        baqViewController.getDetails(baqRecord.Id);
        baqViewController.deleteBaq(baqRecord.Id);
        test.stopTest();
    } 
}