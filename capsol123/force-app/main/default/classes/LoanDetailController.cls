public with sharing class LoanDetailController {
    @AuraEnabled(cacheable=true)
    public static Object recordInfo(Id recordId){
        return [select Id,name from Loan_Application__c where  Id=:recordId];
    }
}