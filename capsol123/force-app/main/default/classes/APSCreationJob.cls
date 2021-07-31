global class APSCreationJob implements Database.Batchable<sObject>, Schedulable {
    global String query;
    global Date queryDate;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> disbursalDate = (String.valueOf(queryDate)).split(' ');
        query = 'SELECT Id, Name, loan__Last_Disbursal_Date__c, loan__Contact__r.loan__Payment_Mode__c, loan__Frequency_of_Loan_Payment__c, loan__First_Installment_Date__c, (SELECT Id, Name, loan__Active__c,loan__Type__c FROM loan__Automated_Payment_Setup__r WHERE loan__Type__c = \'RECURRING\') FROM loan__Loan_Account__c WHERE loan__Last_Disbursal_Date__c = ' + disbursalDate[0];
        System.debug('<< Initiation Query >>' +query);
        return Database.getQueryLocator(query);
    }
    
    public APSCreationJob() {
        loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
        this.queryDate = loanFacade.getCurrentSystemDate();
    }
    
    public APSCreationJob(Date queryDate) {
        if(queryDate != null){
            this.queryDate = queryDate;
        } else {
            loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
            this.queryDate = loanFacade.getCurrentSystemDate();
        }
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        if(scope != null){
            
            Map<String, Id> paymentModeMapping = new Map<String, Id>();
            List<loan__Payment_Mode__c> paymentModeList = [SELECT Id, Name FROM loan__Payment_Mode__c];
            if(paymentModeList != null && paymentModeList.size() > 0) {
                for(loan__Payment_Mode__c pm : paymentModeList) {
                    paymentModeMapping.put(pm.Name, pm.Id);
                }
            }
            
            List<loan__Loan_Account__c> loanList = (List<loan__Loan_Account__c>) scope;
            List<loan__Batch_Process_Log__c> logsToUpdate = new List<loan__Batch_Process_Log__c>();
            List<loan__Automated_Payment_Setup__c> apsToInsert = new List<loan__Automated_Payment_Setup__c>();
            for(loan__Loan_Account__c loan : loanList) {
                /* Safe check */
                if(loan.loan__Automated_Payment_Setup__r.size() == 0) {
                    /* Create APS */
                    
                    if(paymentModeMapping.containsKey((String.valueof(loan.loan__Contact__r.loan__Payment_Mode__c)))) {
                        loan__Automated_Payment_Setup__c aps = new loan__Automated_Payment_Setup__c();
                        aps.loan__CL_Contract__c = loan.Id;
                        aps.loan__Amount_Type__c = 'LAST BILLED AMOUNT';
                        aps.loan__Frequency__c = loan.loan__Frequency_of_Loan_Payment__c;
                        aps.loan__Payment_Mode__c = paymentModeMapping.get((String.valueof(loan.loan__Contact__r.loan__Payment_Mode__c)));
                        aps.loan__Type__c = ConstantsCl.APS_RECURRING_TYPE;
                        aps.loan__Debit_Date__c = loan.loan__First_Installment_Date__c;
                        aps.loan__Recurring_ACH_Start_Date__c = loan.loan__First_Installment_Date__c;
                        aps.loan__Active__c = true;
                        apsToInsert.add(aps);
                    } else {
                        loan__Batch_Process_Log__c batchLog = new loan__Batch_Process_Log__c();
                        batchLog.loan__Message__c = 'Skipping APS for loan ' + loan.Name + '. Payment Mode not found!';
                        batchLog.loan__Origin__c = 'APSCreationJob';
                        logsToUpdate.add(batchLog);
                    }
                } else {
                    loan__Batch_Process_Log__c batchLog = new loan__Batch_Process_Log__c();
                    batchLog.loan__Message__c = 'Skipping APS for loan ' + loan.Name + '. APS already exists!';
                    batchLog.loan__Origin__c = 'APSCreationJob';
                    logsToUpdate.add(batchLog);
                }
            }
            
            if(apsToInsert.size() > 0) {
                INSERT apsToInsert;
            } 
            
            try{
                if(logsToUpdate.size() > 0) {
                    INSERT logsToUpdate;
                }
            } catch(Exception e) {
                System.debug('Something went wrong while inserting batch log records' + e.getMessage());
            }
        }
    }
    
    global void execute(SchedulableContext ctx) {
        Id batchJobId = Database.executeBatch(new APSCreationJob(), 200);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('<< IN FINISH >>');
    }
}