@isTest(seeAllData = false)
public class LPL_LoanApplicationReport_Test{

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
            loanApp4.Status__c = 'Submitted';
            loanApp4.SUM_NNA__c=456;
            loanApp4.Backend_Hurdle__c=234;
            loanApp4.Backend_Bps__c=2;
            loanApp4.Loan_SF_CLO_Status__c=false;
            loanApp4.Requested_Loan_Amount__c=444;
            loanApp4.CLO_Application_ID__c='sdf';
            loanApp4.CLO_Customer_Group_ID__c='877fdf';
            listloan.add(loanApp4) ;
             insert listloan;
             
             Loan_Application__c loanApp5 = new Loan_Application__c();
            loanApp5.Status__c = 'Submitted';
            loanApp5.SUM_NNA__c=4562;
            loanApp5.Backend_Hurdle__c=2347;
            loanApp5.Backend_Bps__c=25;
            loanApp5.Loan_SF_CLO_Status__c=false;
            loanApp5.Requested_Loan_Amount__c=4445;
            loanApp5.CLO_Application_ID__c='sdf1';
            loanApp5.CLO_Customer_Group_ID__c='877fdf';
            listloan1.add(loanApp5) ;
             insert listloan1;
            List<Proposal_Offer__c> lstpro= new List<Proposal_Offer__c >();
            Proposal_Offer__c proTA = new Proposal_Offer__c();            
            proTA.LoanApp_MD__c = listloan1[0].id;
            proTA.Name= 'Offer1';
            proTA.Offer_Accepted__c = true;
            
            lstpro.add(proTA);
            insert lstpro;
          
            
       LPL_LoanApplicationReport Report= new LPL_LoanApplicationReport();
                   //   report.LoanReport(listloan);                      
       report.getEmailAttachmentForDailyJobReport(listloan);  
       report.execute(listloan,True,System.today());
        test.startTest();
           
            LPL_Job_ReportGenerator batchObj=new LPL_Job_ReportGenerator();
            batchObj.execute(null,listloan);
            Database.executeBatch(batchObj);
            String CRON_EXP = '0 0 0 15 3 ? *';
           String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new LPL_JobReportScheduler ());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
       test.stopTest();
}
}