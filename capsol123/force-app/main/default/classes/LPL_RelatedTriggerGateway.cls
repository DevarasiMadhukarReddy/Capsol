public class LPL_RelatedTriggerGateway{
    
    public void updateProgramManagerOnAccountRel(List<Related__c> newRelList, List<Related__c> oldRelList, boolean isAfterDelete){
        Set<Id> accountIds = new Set<Id>();
        List<Account> accList = new List<Account>();
        
        if(newRelList != null && !newRelList.isEmpty() && oldRelList == null && !isAfterDelete){
            for(Related__c rel: newRelList){
                accountIds.add(rel.Enterprises__c);
            }
        } 
        else if (newRelList != null && !newRelList.isEmpty() && oldRelList != null && !oldRelList.isEmpty() && !isAfterDelete) {
            for(Related__c rel : oldRelList){
                accountIds.add(rel.Enterprises__c);
            }
        } 
        else if (newRelList == null && oldRelList != null && !oldRelList.isEmpty() && isAfterDelete){
            for(Related__c rel : oldRelList){
                accountIds.add(rel.Enterprises__c);
            }
        }
        
        if(accountIds != null && !accountIds.isEmpty()){
            accList = [SELECT Id, (SELECT Id FROM Contacts WHERE Rep_Status__c = 'Active' AND Role__c = 'Program Manager' ORDER BY Contact_Level__c , CreatedDate, Hire_Date__c LIMIT 1), (SELECT Id, Related_Contacts__c FROM Related_Enterprises__r WHERE Relationship_Type__c IN ('Advisor & PM', 'PM', 'PM & OSJ') ORDER BY Related_Contacts__r.Contact_Level__c, Related_Contacts__r.Hire_Date__c desc LIMIT 1) FROM Account WHERE RecordType.Name = 'IS - Institution' AND Id IN: accountIds];
        }
        
        if(accList != null && !accList.isEmpty()){
            for(Account acc : accList){
                if(acc.Contacts != null && !acc.Contacts.isEmpty()) {
                    acc.Program_Manager__c = acc.Contacts[0].Id;
                } else {
                    if(acc.Related_Enterprises__r != null && !acc.Related_Enterprises__r.isEmpty()){
                        acc.Program_Manager__c = acc.Related_Enterprises__r[0].Related_Contacts__c;
                    }
                }
            }
        }
        
        try{
            update accList;
        } 
        catch (Exception e){
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_ContactTriggerGateway','updateProgramManagerOnAccount',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
}