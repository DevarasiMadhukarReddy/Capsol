trigger DisbursementCustomTrigger on loan__Loan_Disbursal_Transaction__c (before insert) {
    
    if (!loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c){
        
        Set<String> contractIds = new Set<String>();
        for(loan__Loan_Disbursal_Transaction__c ldt : Trigger.new) {
            if(ldt.loan__Loan_Account__c != null) {
                contractIds.add(ldt.loan__Loan_Account__c);
            }
        }
        
        if(contractIds.size() > 0) {
            Map<String, String> paymentModeMapping = new Map<String, String>();
            List<loan__Payment_Mode__c> paymentModeList = [SELECT Id, Name FROM loan__Payment_Mode__c];
            if(paymentModeList != null && paymentModeList.size() > 0) {
                for(loan__Payment_Mode__c pm : paymentModeList) {
                    paymentModeMapping.put(pm.Name, pm.Id);
                }
            }
            
            Map<Id, loan__Loan_Account__c> contracts = new Map<Id, loan__Loan_Account__c>([SELECT Id, Name, loan__Contact__r.loan__Payment_Mode__c FROM loan__Loan_Account__c WHERE Id IN :contractIds]);
            for(loan__Loan_Disbursal_Transaction__c ldt : Trigger.new) {
                loan__Loan_Account__c contract = contracts.get(ldt.loan__Loan_Account__c);
                if(String.isNotBlank(String.valueOf(contract.loan__Contact__r.loan__Payment_Mode__c))) {
                    if(paymentModeMapping.containsKey(String.valueOf(contract.loan__Contact__r.loan__Payment_Mode__c))) {
                        ldt.loan__Mode_of_Payment__c = paymentModeMapping.get(String.valueOf(contract.loan__Contact__r.loan__Payment_Mode__c));
                    } else {
                        ldt.addError(contract.loan__Contact__r.loan__Payment_Mode__c + ' mode of payment is not available in Payment Mode object');
                    } 
                } else {
                    ldt.addError('Payment Mode is not present in associated Contact.');
                }
            }
            
        }
        
    }
    
}