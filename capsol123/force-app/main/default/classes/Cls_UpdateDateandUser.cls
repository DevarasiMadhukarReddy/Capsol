public class Cls_UpdateDateandUser {
    @InvocableMethod  
    public static void updateDateandUser(List<Id> ids){
        loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
        date todaysDate = System.today();
        System.debug('hello');
        list<genesis__applications__c> apps = [select id,name,
                                               Approved__c,Approved_Date__c,Approved_Name__c,
                                               Guidance__c,Guidance_Date__c,Guidance_Name__c,
                                               Deffered_Repayable_Approval_Date__c,Deffered_Repayable_Approved__c,
                                               Deffered_Repayable_Approved_name__c, genesis__Status__c, BAQ__c
                                               from genesis__applications__c where id IN :ids];
        
        Set<ID> baqIds = new Set<ID>();
        Map<Id, BAQ__c> baqMap = null;
        if(apps != null && apps.size() > 0) {
            for(genesis__applications__c app : apps) {
                baqIds.add(app.BAQ__c);
            }
            
            if(baqIds.size() > 0) {
                baqMap = new Map<Id, BAQ__c>([SELECT Id, Name, Status__c FROM BAQ__c WHERE Id IN :baqIds]);
            }
        }
        
        List<Group> underWriterQ = [SELECT Id, Name FROM Group WHERE Name = 'Underwriter Q' AND Type = 'Queue'];
        User users = [select Id, name,username from User where Id = :UserInfo.getUserId()];
        list<genesis__applications__c> updatedApp = new list<genesis__applications__c>();
        List<BAQ__c> baqToUpdate = new List<BAQ__c>();
        for(genesis__applications__c app:apps) {
            if(app.Approved_Date__c==null && app.approved__c==true && app.Approved_Name__c==null) {
                app.Approved_Date__c = todaysDate;
                app.Approved_Name__c = users.name;
                app.approved_user__c = users.id;
                app.OwnerId = underWriterQ[0].Id;
                app.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_APPROVED;
                updatedApp.add(app);
                if(baqMap.containsKey(app.BAQ__c)) {
                    BAQ__c baq = baqMap.get(app.BAQ__c);
                    baq.Status__c = ConstantsCl.BAQ_STATUS_APPROVED;
                    baqToUpdate.add(baq);
                }
            }
            if(app.Guidance_Date__c==null && app.Guidance__c==true && app.Guidance_Name__c==null) {
                app.Guidance_Date__c = todaysDate;
                app.Guidance_Name__c = users.name;
                app.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_GUIDANCE;
                updatedApp.add(app);
                if(baqMap.containsKey(app.BAQ__c)) {
                    BAQ__c baq = baqMap.get(app.BAQ__c);
                    baq.Status__c = ConstantsCl.BAQ_STATUS_GUIDANCE;
                    baqToUpdate.add(baq);
                }
            }
            if(app.Deffered_Repayable_Approval_Date__c==null && app.Deffered_Repayable_Approved__c==true && app.Deffered_Repayable_Approved_name__c==null) {
                app.Deffered_Repayable_Approval_Date__c = todaysDate;
                app.Deffered_Repayable_Approved_name__c = users.name;
                app.OwnerId = underWriterQ[0].Id;
                app.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_APPROVED;
                updatedApp.add(app);
                if(baqMap.containsKey(app.BAQ__c)) {
                    BAQ__c baq = baqMap.get(app.BAQ__c);
                    baq.Status__c = ConstantsCl.BAQ_STATUS_APPROVED;
                    baqToUpdate.add(baq);
                }
            }
        }
        try {
            if(updatedApp.size()>0)
                update updatedApp;
            if(baqToUpdate.size() > 0) {
                UPDATE baqToUpdate;
            }
        } catch(Exception e) {
            System.debug(e.getMessage()+''+e.getLineNumber());
        }
    }
}