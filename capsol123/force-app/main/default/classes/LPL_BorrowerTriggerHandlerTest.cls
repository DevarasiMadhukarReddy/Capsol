/*
Trigger Name            :LPL_BorrowerTrigger
Description             :Test Class for New_BorrowerTriggerHandler
Developer Name          : Ishan Nigam
Created Date            :10/26/2020

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-0          Created test class                                Ishan Nigam      10/26/2020
CH-01         CS-2610 Sprint 22                                 Saritha          02/17/2021

*/
@isTest(seeAllData = false)
public class LPL_BorrowerTriggerHandlerTest {
    
        public static ID aquisitionLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Acquisition Loan').getRecordTypeId();
        public Static ID growthLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Growth Loan').getRecordTypeId();
        public static ID locRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Line of Credit').getRecordTypeId();
        public static ID refinanceLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Refinance Loan').getRecordTypeId();
        public static ID backendTaRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Backend TA').getRecordTypeId();
        
        public static Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        static testmethod void test1(){
        
        Account a1 = new Account(Name = 'LPL Test Account');
        insert a1;
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname' ,RecordTypeId = conRecordTypeId);
        insert ct1;
        
        Contact ct2= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname1' ,RecordTypeId = conRecordTypeId);
        insert ct2;
        
        Contact ct3= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname2' ,RecordTypeId = conRecordTypeId);
        insert ct3;
        
        Loan_Application__c loanApp = new Loan_Application__c();
        loanApp.RecordTypeId = growthLoanRecTypeId;  // CH-01 aquisitionLoanRecTypeId changed to growthLoanRecTypeId
        loanApp.Advisor__c = ct1.id;
        loanApp.Status__c = 'Initiated';
        
        insert loanApp;
        
        Borrowers__c borr = new Borrowers__c();
        borr.Loan_Application__c = loanApp.id;
        borr.Contact__c = ct1.id;
        borr.name = 'Test Borr';
        borr.Primary_Contact__c = true;
        
        insert borr;
        
        Borrowers__c borr1 = new Borrowers__c();
        borr1.Loan_Application__c = loanApp.id;
        borr1.Contact__c = ct2.id;
        borr1.name = 'Test Borr1';
        
        insert borr1;
        
        Borrowers__c borr2 = new Borrowers__c();
        borr2.Loan_Application__c = loanApp.id;
        borr2.Contact__c = ct3.id;
        borr2.name = 'Test Borr2';
        
        insert borr2;
            
           test.starttest();
            Borrowers__c borrlist=[select id,primary_contact__c from borrowers__c where id = :borr1.id Limit 1];
            borrlist.Primary_Contact__c = true;
            update borrlist;
            Loan_Application__c appUp = [select primary_Contact_name__c from Loan_Application__c where id = :loanApp.id];
            List<Borrowers__c> upBor = new List<Borrowers__c>();
            upBor = [select name from Borrowers__c where Loan_Application__c = :loanApp.id and primary_contact__c = true and name = 'Test Borr1'];        
           test.stoptest();
            System.AssertEquals(upBor.size(),1,true);
            System.AssertEquals(appUp.primary_contact_name__c,ct2.id,true);
           
        
    }
    static testmethod void test2(){
        
        Account a1 = new Account(Name = 'LPL Test Account');
        insert a1;
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname' ,RecordTypeId = conRecordTypeId);
        insert ct1;
        
        Contact ct2= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname1' ,RecordTypeId = conRecordTypeId);
        insert ct2;
        
        Contact ct3= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname2' ,RecordTypeId = conRecordTypeId);
        insert ct3;
        
        Loan_Application__c loanApp = new Loan_Application__c();
        loanApp.RecordTypeId = growthLoanRecTypeId;  //CH-01 aquisitionLoanRecTypeId changed to growthLoanRecTypeId
        loanApp.Advisor__c = ct1.id;
        loanApp.Status__c = 'Initiated';
        
        insert loanApp;
        
        Borrowers__c borr = new Borrowers__c();
        borr.Loan_Application__c = loanApp.id;
        borr.Contact__c = ct1.id;
        borr.name = 'Test Borr';
        borr.Primary_Contact__c = true;
        
        insert borr;
        
        Loan_Application__c lp = [select id,status__c from Loan_Application__c where id = :loanApp.id];
        lp.status__c = 'Funded';
        update lp;
        
        Loan_Application__c loanApp1 = new Loan_Application__c();
        loanApp1.RecordTypeId = growthLoanRecTypeId;  //CH-01 aquisitionLoanRecTypeId changed to growthLoanRecTypeId
        loanApp1.Advisor__c = ct2.id;
        loanApp1.Status__c = 'Initiated';
        insert loanApp1;
        
        Borrowers__c borr4 = new Borrowers__c();
        borr4.Loan_Application__c = loanApp1.id;
        borr4.Contact__c = ct1.id;
        borr4.name = 'Test Borr';
        borr4.Primary_Contact__c = true;
        
              
        try
        {
            test.starttest();
            insert borr4;
            test.stoptest();
        }
        catch(Exception error)
        {           
         System.assert(error.getMessage().contains('This Customer already'+'Loan Application or this Contact is Terminated.'));
        }
        
    }
    
}