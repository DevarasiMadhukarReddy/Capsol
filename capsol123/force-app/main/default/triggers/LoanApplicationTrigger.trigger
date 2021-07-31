/***
     * US 60 - Send Loan Application Updates to CLO as part of Update Loan Application Details Service
     * for Loan Application which are already submitted to CLO
     * ----------------------Updated by Amol Sprint 12 CapSol - 05/18/2020 - CH01
     * 
     *  CS-1123 Backend TA Accepted Loan Amount Auto Calculation,Updated by Madhukar Reddy for BackendCalculation
     * CS-1335     Enhancement - Update Application and related records to read-only      Madhukar Reddy 3/4/2021
                   when offer accepted CH02
     */
    
    
    trigger LoanApplicationTrigger on Loan_Application__c (after delete, after insert, after update, before delete, before insert, before update) {
    if(trigger.isBefore){
        if(LPL_TriggerCall.isBeforeLoanFirstTime) {
            LPL_TriggerCall.isBeforeLoanFirstTime = false;
            if(trigger.isInsert){
                LPL_LoanApplicationHandler.beforeInsert(Trigger.new);
            }
        }
    } 
    
    if(trigger.isAfter){
        if(LPL_TriggerCall.isAfterLoanFirstTime) {
            LPL_TriggerCall.isAfterLoanFirstTime = false;
            if(trigger.isInsert){
                LPL_LoanApplicationHandler.afterInsert(Trigger.new);
                 
            }
        }
        if(trigger.isInsert){
            if(StaticFunction.runOnce()){
                LPL_LoanApplicationHandler.loanapplicationafterInsert(Trigger.new); 
               // LPL_LoanApplicationHandler.afterInsertContactAccomodicationcreation(Trigger.new);
            }
        }
    } 
    if(trigger.isAfter && trigger.isUpdate){
        if(StaticFunction.runOnce()){
            LPL_LoanApplicationHandler.loanapplicationafterInsert(Trigger.new); 
       
        }
        //CH01 Start
        LPL_LoanApplicationHandler.sendLoanAppUpdatesToCLO(Trigger.new,Trigger.old);
        //CH01 End
        LPL_LoanApplicationHandler.updateCLODetailsonContact(Trigger.newMap,Trigger.oldMap);
        
     }
     if(trigger.isAfter && trigger.isUpdate){
        if(StaticFunction.runOnce()){
            LPL_LoanApplicationHandler.LoanstatusUpdate(Trigger.new);   
        }
     }
     if(trigger.isBefore && trigger.isUpdate){
        if(StaticFunction.runOnce()){
            LPL_LoanApplicationHandler.LoanstatusUpdate(Trigger.new);
            // CH02 START
            LPL_LoanApplicationHandler.allowAddtionalFieldUpdate(Trigger.old, trigger.new);
            // CH02 END
        }
     }
     // CS-1123 Backend TA Accepted Loan Amount Auto Calculation,Updated by Madhukar Reddy for BackendCalculation
    if(Trigger.isBefore && trigger.isinsert){
      LPL_LoanApplicationHandler.BackendCalculation((List<Loan_Application__c>)trigger.new);
    }
    // CS-1123 Backend TA Accepted Loan Amount Auto Calculation,Updated by Madhukar Reddy for BackendCalculation
    if(Trigger.isBefore && trigger.isUpdate){
    LPL_LoanApplicationHandler.BackendCalculation((List<Loan_Application__c>)trigger.new);
    } 
     
    }