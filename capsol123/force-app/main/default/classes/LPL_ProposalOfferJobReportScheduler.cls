/**
* This Class used to Schedule a report when Clo Applicaiton id is null, Clo customer group id is null and status is submitted the generate Dynamic Report
* Created By Madhukar Reddy 1/20/2021 CS-2759 Scheduled report for defect Loan Application
**/
global class LPL_ProposalOfferJobReportScheduler implements Schedulable 
{
     global void execute(SchedulableContext sc) {     
        LPL_ProposalOffer_ReportGenerator JobReport = new LPL_ProposalOffer_ReportGenerator();
        Database.executeBatch(JobReport);        
   }
}