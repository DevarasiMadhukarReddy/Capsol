public class Cls_TaCreditApproval {
@InvocableMethod  
    public static void updateDateandUserOnCreditApproval(List<Id> ids){
        List<genesis__applications__c> apps = [SELECT Id, Name,
                                               TA_Credit_Approved_By__c, TA_Credit_Approval_Date__c,
                                               TA_Credit_Approved__c
                                               FROM genesis__applications__c WHERE Id IN :ids];
        if(apps != null && apps.size() > 0) {
            User usr = [SELECT Id, Name, Username from User where Id = :UserInfo.getUserId()];
            loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
            Date currentSystemDate = loanFacade.getCurrentSystemDate();
            
            List<genesis__applications__c> appsToUpdate = new List<genesis__applications__c>();
            for(genesis__applications__c app : apps) {
                if(app.TA_Credit_Approved__c) {
                    app.TA_Credit_Approved_By__c = usr.Name;
                    app.TA_Credit_Approval_Date__c = currentSystemDate;
                    appsToUpdate.add(app);
                }
            }
            if(appsToUpdate.size() > 0) {
                UPDATE appsToUpdate;
            }
        }
    }
}