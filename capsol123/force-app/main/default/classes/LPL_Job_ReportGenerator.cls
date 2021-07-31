/**
* This Class used to Schedule a report when Clo Applicaiton id is null, Clo customer group id is null and status is submitted the generate Dynamic Report
* Created By Madhukar Reddy 1/20/2021 CS-2759 Scheduled report for defect Loan Application
**/
global class LPL_Job_ReportGenerator implements Database.batchable<sObject>, Database.Stateful{ 
   
    global String loanquerey;
    global List<Loan_Application__c > listAllJob = new List<Loan_Application__c >();

    /* start */
    global Database.QueryLocator start(Database.BatchableContext obj){
       try{
       String status='Submitted';
        loanquerey='select id,Status__c,CLO_Application_ID__c,CLO_Customer_Group_ID__c,Name,CreatedDate,RecordType.Name,CreatedBy.Name from Loan_Application__c where ( CLO_Application_ID__c =null OR CLO_Customer_Group_ID__c =null ) and CreatedDate = TODAY and Status__c=: Status';
                System.debug('loanquerey => ' + loanquerey);
        }catch(Exception ex){
           // System.debug('Error in  -> Start => '+ ex);
        }
            
        return Database.getQueryLocator(loanquerey);
    }
    
    
     global void execute(Database.BatchableContext obj, List<Loan_Application__c > jobList){
        if (jobList!= null && jobList.size() > 0){
           // System.debug('~~~~~~~~~~~~~~joblist = '+ jobList.size());
        
            
            listAllJob .addAll(jobList);
           
        }
    }    
        global void finish(Database.BatchableContext obj){    
        // Logic to Send one single Consolidated Email irrespective of the number of batches executed
        System.debug('============ Finish Consolidated Case List ' + listAllJob .size());
        LPL_LoanApplicationReport objJobHelper = new LPL_LoanApplicationReport();
        objJobHelper.execute(listAllJob , false, Date.today()); 
    }
    
}