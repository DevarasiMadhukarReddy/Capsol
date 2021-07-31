global class GenerateAMZ_BatchJob implements Database.Batchable<SObject>, Database.AllowsCallouts {



    // "Start" runs when the class in instanciated
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
    
        return Database.getQueryLocator([select Id,Name,is_migrated__c,Rss_Count__c,loan__Frequency_of_Loan_Payment__c from loan__loan_account__c where is_migrated__c = True and Rss_Count__c = 0]);
    
    
    }
    
    global void execute(Database.BatchableContext bcMain, List<SObject> scope) 
    {
       List<loan__loan_account__c> listLoanAccount = [Select id,name,
                                                           loan__Last_Accrual_Date__c,
                                                           loan__Frequency_of_Loan_Payment__c,
                                                           loan__Payment_Mode__c,
                                                           loan__Next_Installment_Date__c
                                                       from loan__loan_account__c 
                                                       where id in : scope];
       List<loan__Automated_Payment_Setup__c> listAPSToBeInserted = new List<loan__Automated_Payment_Setup__c>();
       for(loan__loan_account__c la : listLoanAccount){
         
            GenerateRepaymentSchedule grs = new GenerateRepaymentSchedule ();
            grs.generateEMI ( la.id,la.loan__Last_Accrual_Date__c);
            
            loan__Automated_Payment_Setup__c aps = new loan__Automated_Payment_Setup__c();
            aps.loan__CL_Contract__c = la.Id;
            aps.loan__Amount_Type__c = 'LAST BILLED AMOUNT';
            aps.loan__Frequency__c = la.loan__Frequency_of_Loan_Payment__c;
            aps.loan__Payment_Mode__c = la.loan__Payment_Mode__c;
            aps.loan__Type__c = ConstantsCl.APS_RECURRING_TYPE;
            aps.loan__Debit_Date__c = la.loan__Next_Installment_Date__c;
            aps.loan__Recurring_ACH_Start_Date__c = la.loan__Next_Installment_Date__c;
            aps.loan__Active__c = true;
            listAPSToBeInserted.add(aps);
       }
       if(listAPSToBeInserted != null && listAPSToBeInserted.size() > 0){
           insert listAPSToBeInserted;
       }
       system.debug('+++++++++++++++++++++++++++++++ execute: ' + scope);     
    }


    // Finish the Batch Job
    global void finish(Database.BatchableContext BC) {
    
  
    }
}