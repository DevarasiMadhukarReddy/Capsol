/*Batch class Name               : LPL_Last_BC_Contact_Date_Batch 
Description                      : This batch class updates Contact based on task's Activity Type. 
Created By                       : Gravita
Created Date                     : 1- oct-2018
CH-02:  06/16/2020; Added condition for Defect #REQ0155181
CH-3: Naga;06/26/2020; - Removed the condition t.Activity_Type__c != LPL_StaticDataUtility.ACTIVITY_EMAIL for RITM0174750
*/


global class LPL_Last_BC_Contact_Date_Batch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String Query ='Select ID,Recordtype.name,Name from Contact where (Recordtype.Name=\'LPL Advisor\' OR Recordtype.Name=\'LPL Assistant\' )'; 
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        Set<Id> conIdSet = new Set<Id>();
        Set<Id> tskOwnerId = new Set<Id>();
        Set<ID> UserID =new Set<ID>();
        List<TaskRelation> allTasksOfContacts = new List<TaskRelation>();
        Map<Id,Contact> conMap=new Map<Id,Contact>();
        List<Task> taskList = new List<Task>();
        Map<id,String> taskContactMap = new Map<Id,String>();
        
        try {  
            for(Contact conRec:scope){ 
                conIdSet.add(conRec.Id);
            }
            
            if(conIdSet.size()>0){
                allTasksOfContacts = [Select ID, RelationId,TaskId,Task.Status,Task.Department__c,Task.OwnerId from TaskRelation where RelationId in: conIdSet and Task.Department__c ='Business Consulting'and Task.Status='Completed'];//Naga added CH-02
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
            }
            if(taskContactMap.KeySet().size()>0){
                taskList =([SELECT Id,ActivityDate, Status,WhoId,Department__c, Activity_Type__c, OwnerId from Task where 
                            id in :taskContactMap.KeySet() AND Status='Completed' And Recordtype.name = 'Master' AND Department__c='Business Consulting' ALL ROWS]);
            }
            
            if(taskList.size()>0){
                for(Task tsk:taskList){
                    if(tsk.OwnerId != Null){
                        tskOwnerId.add(tsk.OwnerId);
                    }
                }
            }
            
            MAP<String, Last_Office_BC__c> LastOfficeMap = Last_Office_BC__c.getall();
            List<String>UserRoleList=new List<String>();
            for(Last_Office_BC__c Roles : LastOfficeMap.values()) {
                If(Roles.Role_name__c!=null ){
                    UserRoleList.add(Roles.Role_name__c);
                }
            }
            List<User> ownerDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id IN:tskOwnerId AND UserRole.Name In :UserRoleList];
            for(User u:ownerDetails){
                UserID.add(u.Id);
            }
            
            if(taskList.size()>0){
                if(!UserID.IsEmpty() && UserID.size()>0){
                    for(Task t:taskList){
                        if(UserID.contains(t.OwnerId)){
                            if(taskContactMap.get(t.Id) != null && taskContactMap.get(t.Id) !=''){
                                String [] conIds = taskContactMap.get(t.Id).split(';');
                                for(Integer i=0;i<conIds.size();i++){
                                    Contact conObj = new Contact(id=conIds[i]);
                                    if(t.Activity_Type__c==LPL_StaticDataUtility.ACTIVITY_REGIONAL_MEETING){
                                        if(conMap.containsKey(conObj.Id)){
                                            if((conMap.get(conObj.Id).Last_Regional_Meeting__c==null && t.ActivityDate!=null) ||(conMap.get(conObj.Id).Last_Regional_Meeting__c!= null && t.ActivityDate>conMap.get(conObj.Id).Last_Regional_Meeting__c)){
                                                   conMap.get(conObj.Id).Last_Regional_Meeting__c= t.ActivityDate;
                                               }
                                        }else if(conObj.Last_Regional_Meeting__c ==null  ||(conObj.Last_Regional_Meeting__c !=null && t.ActivityDate>conObj.Last_Regional_Meeting__c)){
                                            conObj.Last_Regional_Meeting__c= t.ActivityDate;
                                        }
                                    }
                                    /***Last Study Group ***/
                                    if(t.Activity_Type__c==LPL_StaticDataUtility.ACTIVITY_STUDY_GROUP || 
                                    t.Activity_Type__c==LPL_StaticDataUtility.ACTIVITY_VIRTUAL_STUDY_GROUP){
                                        if(conMap.containsKey(conObj.Id)){
                                            if((conMap.get(conObj.Id).Last_Study_Group__c == null && t.ActivityDate != null) ||(conMap.get(conObj.Id).Last_Study_Group__c!= null && t.ActivityDate>conMap.get(conObj.Id).Last_Study_Group__c)){
                                                   conMap.get(conObj.Id).Last_Study_Group__c= t.ActivityDate;
                                               }
                                        }else if(conObj.Last_Study_Group__c == null  ||(conObj.Last_Study_Group__c != null && t.ActivityDate > conObj.Last_Study_Group__c)){
                                            conObj.Last_Study_Group__c= t.ActivityDate;
                                        }
                                    }
                                    
                                    /***Last EOV ***/
                                    if(t.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_EOV){
                                        if(conMap.containsKey(conObj.Id)){
                                            if((conMap.get(conObj.Id).Last_HOV__c==null && t.ActivityDate!=null) ||(conMap.get(conObj.Id).Last_HOV__c!= null && t.ActivityDate>conMap.get(conObj.Id).Last_HOV__c) ){
                                                   conMap.get(conObj.Id).Last_HOV__c= t.ActivityDate;
                                               }
                                        }else if(conObj.Last_HOV__c ==null  ||(conObj.Last_HOV__c !=null && t.ActivityDate>conObj.Last_HOV__c)){
                                            conObj.Last_HOV__c= t.ActivityDate;
                                        }
                                    }
                                    
                                    /***Last VOV ***/
                                    if(t.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_VIRTUAL_OFFICE_VISIT){
                                        if(conMap.containsKey(conObj.Id)){
                                            if((conMap.get(conObj.Id).Last_VOV__c==null && t.ActivityDate!=null) ||(conMap.get(conObj.Id).Last_VOV__c!= null && t.ActivityDate>conMap.get(conObj.Id).Last_VOV__c)){
                                                   conMap.get(conObj.Id).Last_VOV__c= t.ActivityDate;
                                               }
                                        }else if(conObj.Last_VOV__c ==null  ||(conObj.Last_VOV__c !=null && t.ActivityDate>conObj.Last_VOV__c)){
                                            conObj.Last_VOV__c= t.ActivityDate;
                                        }
                                    }
                                    
                                    /***Last FOV ***/
                                    if(t.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_FIELD_OFFICE_VISIT){
                                        if(conMap.containsKey(conObj.Id)){
                                            if((conMap.get(conObj.Id).Last_FOV__c==null && t.ActivityDate!=null) ||(conMap.get(conObj.Id).Last_FOV__c!= null && t.ActivityDate>conMap.get(conObj.Id).Last_FOV__c) ){
                                                   conMap.get(conObj.Id).Last_FOV__c= t.ActivityDate;
                                               }
                                        }else if(conObj.Last_FOV__c ==null  ||(conObj.Last_FOV__c !=null && t.ActivityDate>conObj.Last_FOV__c)){
                                            conObj.Last_FOV__c= t.ActivityDate;
                                        }
                                    }
                                    //CH-03 -06/26/2020 - RITM0174750 Naga removed the condition Email 
                                    if(t.Activity_Type__c != LPL_StaticDataUtility.ACTIVITY_MAIL && 
                                       //t.Activity_Type__c != LPL_StaticDataUtility.ACTIVITY_EMAIL && //CH-03 End
                                       t.Activity_Type__c != LPL_StaticDataUtility.ACTIVITY_OTHER){ 
                                        if(conMap.containsKey(conObj.Id)){
                                            if(conMap.containsKey(conObj.Id) && (conMap.get(conObj.Id).Last_BC_contact_date__c==null && t.ActivityDate!=null) ||
                                               (conMap.get(conObj.Id).Last_BC_contact_date__c!= null && t.ActivityDate>conMap.get(conObj.Id).Last_BC_contact_date__c)){
                                                   conMap.get(conObj.Id).Last_BC_contact_date__c= t.ActivityDate;
                                               }
                                        }
                                        else if(conObj.Last_BC_contact_date__c ==null  ||(conObj.Last_BC_contact_date__c !=null && t.ActivityDate>conObj.Last_BC_contact_date__c)){
                                            conObj.Last_BC_contact_date__c= t.ActivityDate;
                                        }
                                    }
                                    if(!conMap.containsKey(conObj.Id)){
                                        conMap.put(conObj.Id,conObj);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(conMap.values().size()>0){
                update conMap.values();
            }
        }catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Last_BC_Contact_Date_Batch ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
        
    }
    
    global void finish(Database.BatchableContext BC){}
}