/*Batch class Name               : LPL_RecentActivitDateOnContact_batch 
Description                      : This one time batch fetch the Recent activity date (Task/Event) and populate on the Contact.
Created By                       : Vaibhav Jain
Created Date                     : 27-Sep-2018
*/
global class LPL_RecentActivitDateOnContact_batch implements Database.Batchable<sObject> {
    
    List<Contact> activitiesList = new List<Contact>();
    List<Contact> recordsToUpdate = new List<Contact>();
    List<Contact> recordsToProcess = new List<Contact>();
    Set<Id> contactIds = new Set<Id>();
    Map<Id,DateTime> radMap = new Map<Id,DateTime>();
    DateTime recentActivityDate;
    Map<id,String> taskContactMap = new Map<Id,String>();
    Map<id,String> eventContactMap = new Map<Id,String>();
    ID ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select id,FirstName,LastName from Contact where RecordtypeId=:ConRecordTypeId';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> conList){
        List<Task> taskList = new List<Task>();
        List<Event> eventList = new List<Event>();
        Map<Id, Contact> mapConToUpdate = new Map<Id,Contact>();
        try{
            for(Contact c:conList){
                contactIds.add(c.Id);
            }
            if(contactIds.size()>0){
                List<TaskRelation> allTasksOfContacts = new List<TaskRelation>();
                allTasksOfContacts = [Select ID, RelationId,TaskId,LastModifiedDate from TaskRelation where RelationId in: contactIds];
                if(allTasksOfContacts.size()>0){
                    for(TaskRelation taskRelationRec :allTasksOfContacts){
                        if(taskContactMap.containskey(taskRelationRec.TaskId)){
                            String RelationIdVal = taskContactMap.get(taskRelationRec.TaskId)+';'+taskRelationRec.RelationId;
                            taskContactMap.put(taskRelationRec.TaskId,RelationIdVal);
                        }
                        else{
                            taskContactMap.put(taskRelationRec.TaskId,taskRelationRec.RelationId);
                        }
                    }
                }
                
                List<EventRelation> allEventsOfContacts = new List<EventRelation>();
                allEventsOfContacts = [Select ID, RelationId,EventId,LastModifiedDate from EventRelation where RelationId in: contactIds];
                if(allEventsOfContacts.size()>0){
                    for(EventRelation eventRelationRec :allEventsOfContacts){
                        if(eventContactMap.containskey(eventRelationRec.EventId)){
                            String RelationIdVal = eventContactMap.get(eventRelationRec.EventId)+';'+eventRelationRec.RelationId;
                            eventContactMap.put(eventRelationRec.EventId,RelationIdVal);
                        }
                        else{
                            eventContactMap.put(eventRelationRec.EventId,eventRelationRec.RelationId);
                        }
                    }
                }
                
                if(taskContactMap.KeySet().size()>0){
                    taskList =([SELECT Id,ActivityDate, Status,WhatId,LastModifiedDate from Task where 
                                id in :taskContactMap.KeySet() order by lastModifiedDate ALL ROWS ]);
                }
                
                if(eventContactMap.KeySet().size()>0){
                    eventList =([SELECT Id,ActivityDate,WhatId,LastModifiedDate from Event where 
                                 id in :eventContactMap.KeySet() order by lastModifiedDate ALL ROWS]);
                }
                
                if(taskList.size()>0){
                    for(Task t:taskList){
                        if(taskContactMap.get(t.Id) != null && taskContactMap.get(t.Id) !=''){
                            String [] conIds = taskContactMap.get(t.Id).split(';');
                            for(Integer i=0;i<conIds.size();i++){
                                Contact conObj = new Contact(id=conIds[i]);
                                if(!mapConToUpdate.containsKey(conObj.id)){
                                    conObj.Recent_Activity_Date__c = t.LastModifiedDate;
                                    mapConToUpdate.put(conObj.id,conObj);
                                }
                            }
                        }
                    }
                }
                
                if(eventList.size()>0){
                    for(Event evt:eventList){
                        if(eventContactMap.get(evt.Id) != null && eventContactMap.get(evt.Id) !=''){
                            String [] conIds = eventContactMap.get(evt.Id).split(';');
                            for(Integer i=0;i<conIds.size();i++){
                                Contact conObj = new Contact(id=conIds[i]);
                                if(!mapConToUpdate.containsKey(conObj.id)){
                                    conObj.Recent_Activity_Date__c = evt.LastModifiedDate;
                                    mapConToUpdate.put(conObj.id,conObj);
                                }else{
                                    if(mapConToUpdate.get(conObj.id).Recent_Activity_Date__c < evt.LastModifiedDate){
                                        conObj.Recent_Activity_Date__c = evt.LastModifiedDate;
                                        mapConToUpdate.put(conObj.id,conObj);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if(mapConToUpdate.values().size()>0){
                update mapConToUpdate.values();
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_RecentActivitDateOnContact_batch ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    global void finish(Database.BatchableContext bc){
    }
    
}