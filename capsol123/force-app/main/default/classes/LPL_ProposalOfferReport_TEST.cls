@isTest(seeAllData = false)
public class LPL_ProposalOfferReport_TEST {

static testMethod void validate() {
User u = new User(
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
                         LocaleSidKey = 'en_US',
                         CA_Created_By_Manager__c=true
                         //UserRoleId = r.Id
                    );
        insert u;
        List<Loan_Application__c > listloan=new List<Loan_Application__c >();
        List<Loan_Application__c > listloan1=new List<Loan_Application__c >();
         Loan_Application__c loanApp4 = new Loan_Application__c();
            loanApp4.Status__c = 'Offer Extended';
            loanApp4.SUM_NNA__c=456;
            loanApp4.Backend_Hurdle__c=234;
            loanApp4.Backend_Bps__c=2;
            loanApp4.Loan_SF_CLO_Status__c=false;
            loanApp4.Requested_Loan_Amount__c=444;
            loanApp4.CLO_Application_ID__c='sdf';
            LoanApp4.CLO_Customer_Group_ID__c='sff3';            
            listloan.add(loanApp4) ;
             insert listloan;
             
             Loan_Application__c loanApp5 = new Loan_Application__c();
            loanApp5.Status__c = 'Offer Extended';
            loanApp5.SUM_NNA__c=4562;
            loanApp5.Backend_Hurdle__c=2347;
            loanApp5.Backend_Bps__c=25;
            loanApp5.Loan_SF_CLO_Status__c=false;
            loanApp5.Requested_Loan_Amount__c=4445;
            loanApp5.CLO_Application_ID__c='sdf1';
            LoanApp5.CLO_Customer_Group_ID__c='sff35';     
            listloan1.add(loanApp5) ;
             insert listloan1;
            List<Proposal_Offer__c> lstpro= new List<Proposal_Offer__c >();
            Proposal_Offer__c proTA = new Proposal_Offer__c();            
            proTA.LoanApp_MD__c = listloan1[0].id;
            ProTA.Proposal_Status__c='Unverified';
            ProTA.Max_TA_Amount__c=0.0;
            ProTa.Verified_AUM__c=89;
            ProTa.TA_of_Verified_AUM_Percent__c=858;
            ProTa.Approved_T12__c=678;
            ProTa.Expiration__c=system.today();
            ProTa.Date__c=system.today();
            proTA.Name= 'Offer1';
            proTA.Offer_Accepted__c = true;            
            lstpro.add(proTA);
            insert lstpro;
                 
       LPL_ProposalOfferReport propReport= new LPL_ProposalOfferReport();
       //propReport.LoanReport(lstpro);                      
       propReport.getEmailAttachmentForDailyJobReport(lstpro);  
       propReport.execute(lstpro,True,System.today());
       propReport.getEmailContentsForDailyJobReport(lstpro,System.today());
        test.startTest();
           LPL_ProposalOffer_ReportGenerator batchObj1=new LPL_ProposalOffer_ReportGenerator();
            Database.executeBatch(batchObj1);
            String CRON_EXP1 = '0 0 0 15 3 ? *';
           String jobId1 = System.schedule('ScheduleApexClassTest',  CRON_EXP1, new LPL_ProposalOfferJobReportScheduler ());
            CronTrigger ct1 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId1];
            System.assertEquals(CRON_EXP1, ct1.CronExpression);
            System.assertEquals(0, ct1.TimesTriggered);
            Test.stopTest();
        
}
}