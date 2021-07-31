/**
* This Class used to Schedule a report when Clo Applicaiton id is null, Clo customer group id is null and status is submitted the generate Dynamic Report
* Created By Madhukar Reddy 1/20/2021 CS-2759 Scheduled report for defect Loan Application
**/
global class LPL_ProposalOffer_ReportGenerator implements Database.batchable<sObject>, Database.Stateful{ 
   
    global String loanquerey;
    global List<Proposal_Offer__c> listAllJob = new List<Proposal_Offer__c>();

    /* start */
    global Database.QueryLocator start(Database.BatchableContext obj){
       try{
       String status='Offer Extended';
       String status1='Submit for Approval';
        loanquerey='select id,LoanApp_MD__r.Status__c,LoanApp_MD__r.CLO_Application_ID__c,Max_TA_Amount__c , LoanApp_MD__r.CLO_Customer_Group_ID__c,Name,CreatedDate,LoanApp_MD__r.RecordType.Name,CreatedBy.Name,Verified_AUM__c from Proposal_Offer__c where  ( Max_TA_Amount__c =null OR Max_TA_Amount__c =0.0) AND Verified_AUM__c !=0 AND (LoanApp_MD__r.Status__c =:status OR LoanApp_MD__r.Status__c =:status1) AND CreatedDate =TODAY';
               // System.debug('loanquerey => ' + loanquerey);
        }catch(Exception ex){
            System.debug('Error in  -> Start => '+ ex);
        }
            
        return Database.getQueryLocator(loanquerey);
    }
    
    
     global void execute(Database.BatchableContext obj, List<Proposal_Offer__c> jobList){
        if (jobList!= null && jobList.size() > 0){
          //  System.debug('~~~~~~~~~~~~~~joblist = '+ jobList.size()); 
            
            listAllJob.addAll(jobList);
           
        }
    }    
        global void finish(Database.BatchableContext obj){    
        // Logic to Send one single Consolidated Email irrespective of the number of batches executed
        System.debug('============ Finish Consolidated Case List ' + listAllJob .size());
        LPL_ProposalOfferReport objJobHelper = new LPL_ProposalOfferReport();
        objJobHelper.execute(listAllJob , false, Date.today()); 
    }
    
}