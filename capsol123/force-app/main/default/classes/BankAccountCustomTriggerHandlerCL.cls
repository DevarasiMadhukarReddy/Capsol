public class BankAccountCustomTriggerHandlerCL {
    Map<Id, loan__Bank_Account__c> oldMap;
    Map<Id, loan__Bank_Account__c> newMap;
    
    public BankAccountCustomTriggerHandlerCL (Map<Id, loan__Bank_Account__c> oldMap, Map<Id, loan__Bank_Account__c> newMap) {
        this.oldMap = oldMap;
        this.newMap = newMap;
    }
    
    public void afterInsertHandler() {
        Set<Id> contactIds = new Set<Id>();
        if(newMap != null) {
            for(Id bankAccId : newMap.keySet()) {
                if(newMap.get(bankAccId).loan__Contact__c != null) {
                    contactIds.add(newMap.get(bankAccId).loan__Contact__c);
                }
            }
        }
        
        if(contactIds.size() > 0) {
            List<Contact> contacts = [SELECT Id, Name, Bank_Account_Available__c FROM Contact WHERE Id IN :contactIds];
            if(contacts != null && contacts.size() > 0) {
                List<Contact> contactsToUpdate = new List<Contact>();
                for(Contact c : contacts) {
                    c.Bank_Account_Available__c = true;
                    contactsToUpdate.add(c);
                }
                
                if(contactsToUpdate.size() > 0) {
                    UPDATE contactsToUpdate;
                }
            }
        }
    } 
    
}