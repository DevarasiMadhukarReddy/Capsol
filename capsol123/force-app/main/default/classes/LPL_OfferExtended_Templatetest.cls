@isTest(SeeAllData=false)
public class LPL_OfferExtended_Templatetest {
    
    static testMethod void Proposaltemplate(){
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u1;
        system.runAs(u1){
            Id TAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
            Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
            Id WorkingCapitalLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Working_Capital').getRecordTypeId();
            Id RetensionLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Retention_Loan').getRecordTypeId();
            
            Loan_Application__c loanAp = new Loan_Application__c();
            loanAp.Legal_Entity__c = 'Corporation';
            loanAp.Status__c='Document Requested';
            loanAp.Assigned_Recruiter__c = u1.id;
            loanAp.Preparer_Email__c='abc@test.com';
            insert loanAp;
            // PageReference pageRef = new PageReference();
            // PageReference pageRef = Page.LoanTemplt;
            //  pageRef.getParameters().put('relatedToType',loanAp.id);
            //    Test.setCurrentPage(pageRef);
            //   ApexPages.currentPage().getParameters().put('relatedToType',loanAp.Id);
            ApexPages.currentPage().getParameters().put('relatedToType', String.valueOf(loanAp.Id));
            LPL_OfferExtended_Template lt1= new LPL_OfferExtended_Template();
            // lt1.set(Loanid);
            // lt1.Loanid(loanAp.ID);
            lt1.Loanid=loanAp.Id;
            lt1.getdta();
            
            
            list<Loan_Application__c> lstlaon=new list<Loan_Application__c>();
            
            Loan_Application__c loanApp = new Loan_Application__c();
            loanApp.Legal_Entity__c = 'Corporation';
            loanApp.Status__c='Document Requested';
            loanApp.Assigned_Recruiter__c = u1.id;
            loanApp.Preparer_Email__c='abc@test.com';
            insert loanApp;
            //  lstlaon.add(loanApp);
            //insert lstlaon;
            Loan_Application__c loanApp1= new Loan_Application__c();
            loanApp1.Legal_Entity__c = 'Corporation';
            loanApp1.Status__c='Document Requested';
            loanApp1.Assigned_Recruiter__c = u1.id;
            loanApp1.Preparer_Email__c='abc1@test1.com';
            loanApp1.RecordTypeId=WorkingCapitalLoadRecordTypeId;
            loanApp1.Expected_AUM__c=90;
            loanapp1.Advisory_Revenue_c__c =10;
            loanapp1.Brokerage_Revenue__c=10;
            loanapp1.Verified_AUM__c =5000;
            insert loanApp1;
           system.debug('***loanApp1'+loanApp1);
            Loan_Application__c loanApp2= new Loan_Application__c();
            loanApp2.Legal_Entity__c = 'Corporation';
            loanApp2.Status__c='Document Requested';
            loanApp2.Assigned_Recruiter__c = u1.id;
            loanApp2.Preparer_Email__c='abc1@test1.com';
            loanApp2.RecordTypeId=RetensionLoadRecordTypeId;
            insert loanApp2;
            id strRecordDevName12 = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
            // id strRecordDevName = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
            list<Proposal_Offer__c> prooffer=new list<Proposal_Offer__c>();
            list<Proposal_Offer__c> prooffer1=new list<Proposal_Offer__c>();
            Proposal_Offer__c pro= new Proposal_Offer__c();
            pro.name='test';
            pro.LoanApp_MD__c=loanApp1.id;
            pro.Max_TA_Amount__c=1000;
            pro.Backend_Hurdle__c=300;
            pro.Backend_Bps__c=5;            
            pro.Fee_Waivers__c=800;
            pro.Admin_Fee__c=300;
            pro.RecordTypeId =strRecordDevName12;
            prooffer.add(pro);
            
            Proposal_Offer__c pr1= new Proposal_Offer__c();
            pr1.name='test1';
            pr1.LoanApp_MD__c=loanApp1.id;
            pr1.RecordTypeId =strRecordDevName12;
            prooffer.add(pr1);
            insert prooffer;
            System.assertEquals(2, prooffer.size());
                system.debug('***prosofftest'+prooffer);
            LPL_OfferExtended_Template lt= new LPL_OfferExtended_Template();
            lt.loanid=loanApp1.id;
            lt.getopptys();
            lt.getopptys1();
            lt.getopptys12();
            lt.getdta();
            Test.startTest();
            //LoanTemplt.PropWrapper laontempwrrraper = new LoanTemplt.PropWrapper('pr1');
            LPL_OfferExtended_Template.PropWrapper laontempwrrraper = new LPL_OfferExtended_Template.PropWrapper('prooffer');
            LPL_OfferExtended_Template.PropWrapper laontempwrrraper1 = new LPL_OfferExtended_Template.PropWrapper('prooffer1');
            TriggerEmailwhenOfferExtended.sendTemplatedEmail(loanApp1);
            TriggerEmailwhenOfferExtended.sendTemplatedEmail(loanApp2);
            Test.stopTest();
        }
    }
}