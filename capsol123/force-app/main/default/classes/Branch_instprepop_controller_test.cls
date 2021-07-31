@isTest 
private class Branch_instprepop_controller_test{
    static testMethod void BatchHistory() {
       
       
       test.startTest();
       
       
        Account a = new Account();
       a.name = 'acctest';
       insert a;
       
        id aa =Schema.SObjectType.Branch_Inst_Financial__c.getRecordTypeInfosByName().get('Fortigent Financials').getRecordTypeId();
        
       Branch_Inst_Financial__c b = new Branch_Inst_Financial__c();
       b.name = 'test';
       b.RecordtypeId = aa;
       b.Account__c = a.id;
       insert b;
       
       PageReference pageRef = Page.Branchinstprepop;
        pageRef.getParameters().put('id', String.valueOf(b.Id));
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(b);
        Branch_instprepop_controller  bSce = new Branch_instprepop_controller (sc);
        bSce.redirect();
       
       test.stoptest();
       }
       }