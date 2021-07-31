/*
#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
CH-01            To update Enterprise Last FOV, Last VOV,Last HOV from   Manila Agnihotri                    4/17/20178
latest event date depending on event or activity type

Ch-02            If Department is Business Developement then restrict 
delete and Edit permission on task and Event for other Role      Ashish Gupta                  7-May-2018
Ch-03    REQ0038890 - RITM0043840 - TASK0066033 - 
Last Recruiting Activity Field :                                                Ashish Gupta                  05-March-2019
This #WO is populating recent date of Activity on Contact   
*/

public without sharing class LPL_EventTriggerHandler implements iTrigger{
    
    Schema.DescribeSObjectResult eventRecDesc = Schema.SObjectType.Event;
    LPL_EventTriggerGateway eventGateWay = new LPL_EventTriggerGateway();
    List<Account> Acclist = new  List<Account>();
    List<Event> newevent1 = new List<Event>();
    Map<ID, Event> oldMap = new Map<ID, Event>();
    Map<String,Schema.RecordTypeInfo> rtMapByName = eventRecDesc.getRecordTypeInfosByName();
    
    public void bulkBefore(){
        if(!Trigger.isDelete){
            eventGateWay.collectRecordToProcess(Trigger.New,null,true);       
        }
        else{
            eventGateWay.collectRecordToProcess(null,Trigger.old,true); 
        }
    }
    
    public void beforeInsert(SObject so){
        Event newEvnt = (Event)so;
        eventGateWay.doEventInsUpdOperation(newEvnt);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Event newEvnt = (Event)so;
        eventGateWay.doEventInsUpdOperation(newEvnt);  
    }
    
    public void beforeDelete(SObject so){}
    
    public void bulkAfter(){
        eventGateWay.collectRecordToProcess(Trigger.New,Trigger.old,false);       
    }
    
    public void afterInsert(SObject so){
        Event newEvnt = (Event)so;
        Acclist =  eventGateWay.doAccountInsUpdOperation(newEvnt);//CH-01
        //Ch-03 starts
        if(LPL_EventTriggerGateway.conIdSet.size()>0){
            eventGateWay.updateLastRecruitingActivity();
        }
        //Ch-03 ends
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        Event newEvnt = (Event)so;
        Acclist =  eventGateWay.doAccountInsUpdOperation(newEvnt);//CH-01
        // ** ch-02 start  **If Department is Business Developement then restrict Edit
        eventGateWay.deleteAndEditRecordByRole(newEvnt);
        // Ch-02 End
        //Ch-03 starts
        if(LPL_EventTriggerGateway.conIdSet.size()>0){
            eventGateWay.updateLastRecruitingActivity();
        }
        //Ch-03 ends
    }
    
    public void afterDelete(SObject so){
        // ** ch-02 start ** If Department is Business Developement then restrict delete
        Event newEvent = (Event)so;
        eventGateWay.deleteAndEditRecordByRole(newEvent);
        // Ch-02 End
        //Ch-03 starts
        if(LPL_EventTriggerGateway.conIdSet.size()>0){
            eventGateWay.updateLastRecruitingActivity();
        }
        //Ch-03 ends
    }
    public void andFinally(){
        //CH-01 - start
        if(Acclist .size()>0){
            Update Acclist ;
        }
        //CH-01 - end
    }
}