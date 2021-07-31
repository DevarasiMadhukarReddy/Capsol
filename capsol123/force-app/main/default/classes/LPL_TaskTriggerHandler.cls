/*
#############################Change History####################
Requirement                                                     Developer Name                   Date

Ch-01 If Department is Business Developement then restrict delete and 
Edit  permission on task and Event for other Role             Ashish Gupta                  7-May-2018
Ch-02    REQ0038890 - RITM0043840 - TASK0066033 - 
Last Recruiting Activity Field :                                                Ashish Gupta                  05-March-2019
This #WO is populating recent date of Activity on Contact   
*/

public without sharing class LPL_TaskTriggerHandler implements ITrigger{
    
    LPL_TaskTriggerGateway tskGateWay = new LPL_TaskTriggerGateway();
    Public static boolean byPassTasktrigger = false;
    
    public LPL_TaskTriggerHandler(){}
    public void bulkBefore(){
        tskGateWay.collectRecordToProcess(Trigger.New, Trigger.Old,true);    
    }
    
    public void beforeInsert(SObject so){
        Task newTask = (Task)so;
        Task oldTask = new Task();
        tskGateWay.doBeforeInsertOperation(newTask,oldTask ,false); 
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Task newTask = (Task)so;
        Task oldTask = (Task)oldSo;
        tskGateWay.doBeforeInsertOperation(newTask,oldTask ,true);
    }
    
    public void beforeDelete(SObject so){
    }
    public void bulkAfter(){
        tskGateWay.collectRecordToProcess(Trigger.New, Trigger.old,false);
    }
    
    public void afterInsert(SObject so){
        Task newTask = (Task)so;
        tskGateWay.doAfterInsertOperation(newTask, false);
        //Ch-02 starts
        if(LPL_TaskTriggerGateway.conIdSet.size()>0){
            tskGateWay.updateLastRecruitingActivity();
        }
        //Ch-02 ends
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        Task newTask = (Task)so;
        tskGateWay.doAfterInsertOperation(newTask, Trigger.isUpdate);
        Task oldTask  = (Task)oldSo;
        if((oldTask.Status != 'Completed' &&  newTask.Status == 'Completed') && newTask.Activity_Type__c != null && newTask.Activity_Type__c != '' && newTask.Activity_Type__c == 'Initial Call Out'){
        }
        // ** ch-01  start If Department is Business Developement then restrict Edit
        tskGateWay.deleteAndEditRecordByRole(newTask);
        // ** ch-01  End
        //Ch-02 starts
        if(LPL_TaskTriggerGateway.conIdSet.size()>0){
            tskGateWay.updateLastRecruitingActivity();
        }
        //Ch-02 ends
    }
    
    public void afterDelete(SObject so){
        Task newTask = (Task)so;
        // ** ch-01  start If Department is Business Developement then restrict delete
        tskGateWay.deleteAndEditRecordByRole(newTask);
        // ** ch-01  End
        // Ch-02 starts
        if(LPL_TaskTriggerGateway.conIdSet.size()>0){
            tskGateWay.updateLastRecruitingActivity();
        }
        //Ch-02 ends
    }
    
    public void andFinally(){
        // adding bypass logic in finally
        if(!byPassTasktrigger)
            tskGateWay.proceedAddFinally();
    }
}