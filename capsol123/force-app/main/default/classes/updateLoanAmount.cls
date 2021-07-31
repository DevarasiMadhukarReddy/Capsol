public class updateLoanAmount {
    
    @InvocableMethod
    public static void updateLoanAmount(List<Id> caseIDs) {
        if(caseIDs != null && caseIDs.size() > 0) {
            List<Case> caseList = [SELECT Id, Loan_Amount__c , Application__c FROM Case WHERE Id IN :caseIDs];
            System.debug('Value of caseList is'+ caseList);
            if(caseList != null && caseList.size() > 0) {
                Set<String> applicationIDs = new Set<String>();
                List<genesis__applications__c> appsToUpdate = new List<genesis__applications__c>();
                  for(Case c : caseList) {
                       applicationIDs.add(c.Application__c);
                  }
                
                Map<Id, genesis__applications__c> appsMap = new Map<Id, genesis__applications__c>([SELECT Id, Name,                                                     
                                                     genesis__Loan_Amount__c                                                     
                                                     FROM genesis__applications__c
                                                     WHERE Id IN :applicationIDs]);
                System.debug('Value of appsMap is '+ appsMap);
                
                 for(Case c : caseList) {
                    if(appsMap.containsKey(c.Application__c)) {
                        genesis__applications__c app = appsMap.get(c.Application__c);
                        app.genesis__Loan_Amount__c = c.Loan_Amount__c;
                        appsToUpdate.add(app);
                    }
                 }
                
                if(appsToUpdate.size() > 0){
                    System.debug('Inside if of updateLoanAmount');
                    update appsToUpdate;
                }
            }
        }
    }

}