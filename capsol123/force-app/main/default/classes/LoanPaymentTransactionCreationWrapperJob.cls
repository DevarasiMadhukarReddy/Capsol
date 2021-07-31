global class LoanPaymentTransactionCreationWrapperJob implements Database.Batchable<sObject>, Schedulable, Database.Stateful {
    global String query;
    global Set<String> paymentModes;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'SELECT Id, Name FROM loan__Payment_Mode__c';
        System.debug('<< Initiation Query >>' +query);
        return Database.getQueryLocator(query);
    }
    
    global LoanPaymentTransactionCreationWrapperJob() {
        paymentModes = new Set<String>();
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        if(scope != null){
            List<loan__Payment_Mode__c> pmList = (List<loan__Payment_Mode__c>) scope;
            for(loan__Payment_Mode__c pm : pmList) {
                paymentModes.add(pm.Name);   
            }
        }
    }
    
    global void execute(SchedulableContext ctx) {
        Id batchJobId = Database.executeBatch(new LoanPaymentTransactionCreationWrapperJob(), 200);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('<< IN FINISH >> Invoking products LoanPaymentTransactionCreationJob' + paymentModes);
        if(paymentModes.size() > 0) {
            loan.LoanPaymentTransactionCreationJob job = new loan.LoanPaymentTransactionCreationJob(true, paymentModes);
            Database.executeBatch(job);
        } else {
            /* No payment modes found! */
            loan__Batch_Process_Log__c batchLog = new loan__Batch_Process_Log__c();
            batchLog.loan__Message__c = 'No payment modes found!.';
            batchLog.loan__Origin__c = 'LoanPaymentTransactionCreationWrapperJob';
            INSERT batchLog;
        }
    }
}