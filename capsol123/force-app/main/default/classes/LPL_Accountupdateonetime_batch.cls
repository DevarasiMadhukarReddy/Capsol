Global class LPL_Accountupdateonetime_batch implements Database.Batchable<sObject>  
{
    Id ISREP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Relationship').getRecordTypeId();
    Id ISINS  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select ID, Name, Last_HOV__c,Last_FOV__c,  Last_VOV__c from Account where (RecordTypeId =: ISREP  OR RecordTypeId =: ISINS)';
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Account> accUpdateList) {
        Set<Id> accIds = new Set<Id>(); 
        List<Account> allActivities = new List<Account>();
        Map<Id, Event> eventAcc = new Map<Id, Event>();
        List<Account> accList = new List<Account>();
        for(Account acc: accUpdateList){
            accIds.add(acc.Id);
        }
        allActivities = [Select ID, Last_HOV__c,Last_FOV__c,  Last_VOV__c,  (Select Id,Event_Type__c,Activity_Type__c, StartDateTime from Events ORDER BY StartDateTime DESC limit 1) from Account where Id in: accIds ];
        
        for(Account searchEvent: allActivities){
            
            if(searchEvent.Events.size()>0){
                
                eventAcc.put(searchEvent.Id, searchEvent.Events[0]);
                
            }
        }
        system.debug('eventAcc' + eventAcc.size());
        for(Account a: accUpdateList)
        {
            if(eventAcc.get(a.id)!=null){
            if( eventAcc.get(a.id).Event_Type__c== 'Field Office Visit' || (eventAcc.get(a.id).Activity_Type__c!=null && eventAcc.get(a.id).Activity_Type__c =='Field Office Visit') )
            {
                a.Last_FOV__c = eventAcc.get(a.id).StartDateTime.date();
            }
            else if(eventAcc.get(a.id).Event_Type__c== 'Home Office Visit'  || (eventAcc.get(a.id).Activity_Type__c!=null && eventAcc.get(a.id).Activity_Type__c =='Home Office Visit'))
            {
                a.Last_HOV__c = eventAcc.get(a.id).StartDateTime.date();
            }
            else if(eventAcc.get(a.id).Event_Type__c== 'Virtual Office Visit'  || (eventAcc.get(a.id).Activity_Type__c!=null && eventAcc.get(a.id).Activity_Type__c =='Virtual Office Visit'))
            {
                a.Last_VOV__c = eventAcc.get(a.id).StartDateTime.date();
            }
            accList.add(a);
            }
        }
        update accList;
    }
    global void finish(Database.BatchableContext BC){
    }
}