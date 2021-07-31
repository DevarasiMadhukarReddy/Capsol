/*Batch class Name               : LPL_MassEmailTaskUpdateBatch 
Description                      : Batch is implmented to update the department and activity type for Mass email Task.
Created By                       : Rinku Yadav
Created Date                     : 30-July-2020
*/
global class LPL_MassEmailTaskUpdateBatch implements Database.Batchable<sObject> {
    List<permissionsetassignment> pslist = new List<permissionsetassignment>();
    static final String PRIVATE_DEPT_ACTIVITY = 'Department_activity_type_update_by_email_from_SFO';
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id tskmaster = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Master').getRecordTypeId();
        
        String query = 'SELECT Id,Department__c, Activity_Type__c, Subject ,createdbyid  FROM Task WHERE whoid != null';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Task> tklist){
        try{
            
            Set<Id> taskID = new Set<Id>(); 
            for(Task tsk : tklist){
                taskID.add(tsk.id);
            }
            List<Task> tsklist = new List<Task>([SELECT Id, Department__c, Activity_Type__c, Subject ,createdbyid 
                                                 FROM Task 
                                                 WHERE type='Email' 
                                                 AND Activity_Type__c != 'Email'
                                                 AND Id =: taskID
                                                ]);
            Set<Id> tskCreatorUserSet = new set<Id>();
            for(Task ts: tsklist){
                tskCreatorUserSet.add(ts.createdbyID);
            }
            
            pslist = [ SELECT Id, PermissionSet.Name, AssigneeId 
                       FROM PermissionSetAssignment 
                       WHERE PermissionSet.Name =: PRIVATE_DEPT_ACTIVITY
                       AND AssigneeId IN : tskCreatorUserSet ];
                       
            Set<Id> permissionSetUserIds = new Set<Id>();
            
            if ( pslist != null && pslist.size() > 0 ) {
                
                for ( PermissionSetAssignment ps : pslist ) {
                    permissionSetUserIds.add( ps.AssigneeId );
                }
                
              List<Task> tskToUpdateList = new List<Task>(
                    [ SELECT Id, Department__c, Activity_Type__c, Subject, CreatedById 
                      FROM Task 
                      WHERE type='Email' 
                      AND ownerID IN: permissionSetUserIds 
                      AND Activity_Type__c != 'Email'
                      AND Id =: taskID]
                );
                
                for ( Task tsk : tskToUpdateList ) {
                    if(tsk.subject.contains('Mass Email:')){
                    tsk.Department__c = 'Business Consulting';
                    tsk.Activity_Type__c = 'Email';
                    }
                }
                system.debug('*****'+tskToUpdateList);
                if(tskToUpdateList != null && tskToUpdateList.size()>0){
                   update tskToUpdateList;
                }
             }
        }
        catch(Exception e) 
        {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_MassEmailTaskUpdateBatch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    global void finish(Database.BatchableContext bc){
    }
    
}