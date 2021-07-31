/*
#############################Change History####################
Requirement                                       Developer Name                   Date

Ch-1   101 SOQL FIx                                       Sai Kethu                    6 June 2017
Ch-2   Process Builder Logic Implementation               Pravin Kale                  7 June 2017  
ch-3   When task record is created or edited Last         Ashish Gupta                  20 june 217
activity date on Lead will be updated
CH-04  Uncommented future method and commented            Vaibhav Wadhai                20 july 2017
'oppFutureUpDateList' in proceedAddFinally block
CH-05  Added code for Updating task in                    Vaibhav Wadhai                20 july 2017
method 'doBeforeInsertOperation'
CH-06  Calling future method from finally block           Vaibhav Wadhai                21 july 2017

CH-07 Added static variable in processfinally block       Vaibhav Wadhai                2 August 2017
So 'oppFutureUpDateList' is updating once

Ch-08 Added Master Recruiting and BDA Touch category code       Ashish Gupta                  20-Nov-2017

Ch-09 If Department is Business Developement then restrict delete and 
Edit  permission on task and Event for other Role            Ashish Gupta                  27-April-2018

CH-10 Update Lead Source to "Recruiter Initiated (RI)" when     Utkarsh Topre               05-June-2018
Marketing Category equals "Dormant" and a qualifying
Task created/updated related to that Contact

SLU-153 Update the prospect status value with Known Prospect for Responsive (Legacy stage 3-5). For Contact 
Attempted (Legacy stage 2) please change to Contact Attempted.      Kishore Ravi            01/23/2019 

CH-12      Added condition to include BDA/BD-A Role                  Garvita Rai            25 January 2019
CH-13      Modified condition to update Department 
            based on Type field                                       Garvita Rai            22 February 2019
CH-14 INC0245454                                                      Garvita Rai             28-Feb-2019
Ch-15 REQ0038890 - RITM0043840 - TASK0066033 - 
Last Recruiting Activity Field :                                      Ashish Gupta             05-March-2019
This #WO is populating recent date of Activity on Contact

CH-16         Allowed System Administrator to edit/delete Events               Garvita Rai      22-March-2019 
CH-17        Added one more "SS&E Recruiting Category" Activity type value     Ashish Gupta     04-April-2019
             filter  condition in Last Recruiting Activity logic
*/
public without sharing class LPL_TaskTriggerGateway{
    
    Set<id> ContactWhoIds = new Set<id>();
    Set<id> LeadWhoIds = new Set<id>(); 
    Set<String> IA_MRID = new set<String>(); 
    Map<Id, LPL_Insurance_Associates__c> iaMap=new Map<Id, LPL_Insurance_Associates__c>(); 
    Map<id, Lead> leadMap = new Map<id, Lead>();
    Map<Id, Contact> conMap = new Map<Id, Contact>(); 
    Map<Id, Contact> conMapIAP = new Map<Id, Contact>(); //Pravin Kale - conMapIAP - Map to exculude LPL Insurance Associates Pouplation for Contact Prospect
    Set<Id> WhatIds = new Set<Id>();
    Map<Id, Group> groupMap = new Map<Id, Group>();
    List<String> emailIds = new List<String>();
    Map<id, Opportunity> oppMap = new Map<id, Opportunity>();    
    Map<Id, Opportunity> mOpportunity = new Map<Id, Opportunity>();
    List<Opportunity> lOpportunities = new List<Opportunity>();
    Group grp1;
    Static ID grpID;
    boolean executeUpdate = false;
    List<task> tskList= new List<task>();
    Map<Id, Task> tskMap = new Map<Id, Task>();
    List<Task> updateTaskstatusList = new List<Task>();
    Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
    Map<String,Schema.RecordTypeInfo> rt_TaskMap = tskRecDesc.getRecordTypeInfosByName();
    Id rt = rt_TaskMap.get('Transitions').getRecordTypeId(); 
    Set<Id> lastActivityWhoIds = new Set<Id>();
    Set<Id> lastActivityWhatIds = new Set<Id>(); 
    Map<Id, Opportunity> lastActivityoppMap;
    Map<Id, Lead> lastActivityLeadMap; 
    boolean isRecursion = false;
    list<Contact> TestCon = new list<Contact>();
    public static List<Opportunity> oppFutureUpDateList = new List<Opportunity>();
    List<Task> updNewList = new List<Task>();
    Set<ID> taskID = new Set<ID>();
    Map<ID, GroupMember> grpMap = new Map<ID, GroupMember>();
    public static boolean value=true;
    public static boolean var1=true;//CH-07
    List<Task>taskRelatedOppList=new List<Task>();// by ashish
    Map<Id,User>  userDetails1 = new  Map<Id,User>();//CH-16
    ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();  //CH-10
    Set<ID> assignIDList=new Set<Id>();
    public static boolean taskcheck = False;
    
    List<TaskRelation> allTasksOfContacts = new List<TaskRelation>();
    Set<ID> taskSet=new Set<ID>();
    Set<Id> taskOldSet = new Set<Id>();
    
    public static Set<String> conIdSet = new Set<String>();
    
    public void collectRecordToProcess(List<Task> tskList, List<Task> tskOldList,Boolean isBefore){
        try {
            if(tskOldList != null){
                for(Task oldTsk : tskOldList){
                    tskMap.put(oldTsk.Id, oldTsk);    
                    //Ch-15 starts
                    if(oldTsk.whoId!=null){
                        if(String.valueOf(oldTsk.whoId).StartsWith('003') && oldTsk.Status=='Completed' &&  (oldTsk.Activity_Type__c=='IRD Touch' || oldTsk.Activity_Type__c=='Recruiting' || oldTsk.Activity_Type__c=='Master Recruiting' || oldTsk.Activity_Type__c=='BDA Touch' || oldTsk.Activity_Type__c=='SS&E Recruiting Category')){ //CH-17
                            taskOldSet.add(oldTsk.id);
                        }
                    }
                    //Ch-15 ends
                }
            }
            //Ch-15 starts
            if(taskOldSet.size()>0 && isBefore){
                for(TaskRelation taskRelationRec :[Select ID, RelationId,TaskId,LastModifiedDate from TaskRelation where TaskId in: taskOldSet]){
                    if(taskRelationRec.RelationId != null){
                        conIdSet.add(taskRelationRec.RelationId);
                    }
                }
            }
            //Ch- 15 ends
            //Condition added by Subhash 5-5 to fix prod error
            if(tskList != null){
                for(Task tsk: tskList){
                    if(tsk.whoId!= null){       
                        if(String.valueOf(tsk.whoId).StartsWith('003')){
                            ContactWhoIds.add(tsk.whoId);
                        }
                        if(String.valueOf(tsk.whoId).StartsWith('003') && tsk.Status=='Completed' &&  (tsk.Activity_Type__c=='IRD Touch' || tsk.Activity_Type__c=='Recruiting' 
                                                                                                       || tsk.Activity_Type__c=='Master Recruiting' || tsk.Activity_Type__c=='BDA Touch' || tsk.Activity_Type__c=='SS&E Recruiting Category')){ //CH-17
                                                                                                           taskSet.add(tsk.Id); 
                                                                                                       }
                        if(String.valueOf(tsk.whoId).StartsWith('00Q')){
                            LeadWhoIds.add(tsk.whoId);  
                        }
                        if(tskMap != null && tskMap.size() != 0){
                            if(tsk.whoId != null && String.valueOf(tsk.WhoId).StartsWith('00Q')){
                                if(tsk.Status != tskMap.get(tsk.Id).Status){
                                    lastActivityWhoIds.add(tsk.WhoID);
                                }
                            }
                        }
                        if (tsk.whoId != null){
                            if(String.valueOf(tsk.WhoId).StartsWith('00Q')) lastActivityWhoIds.add(tsk.WhoID);
                        }
                        if(tskMap != null && tskMap.size() != 0){
                            if(tsk.Status!= tskMap.get(tsk.Id).Status){
                                if(String.valueOf(tsk.WhoId).StartsWith('00Q')){
                                    lastActivityWhoIds.add(tsk.WhoID);
                                }
                            }
                        }
                    }
                    if(tsk.whatId!= null){ 
                        if (tsk.whatId != null){
                            if(String.valueOf(tsk.WhatId).StartsWith('006')) lastActivityWhatIds.add(tsk.WhatID);
                        }
                        if(tskMap != null && tskMap.size() != 0){
                            if(tsk.whatId != null && String.valueOf(tsk.WhatId).StartsWith('006')){
                                if(tsk.Status != tskMap.get(tsk.Id).Status){
                                    lastActivityWhatIds.add(tsk.WhatID);
                                    taskID.add(tsk.ID);
                                }
                            }
                        }
                        if(tsk.Subject == 'Apex'){  
                            if(tsk.whatId != null){
                                if(String.valueOf(tsk.WhatId).StartsWith('006')){
                                    WhatIds.add(tsk.WhatID);
                                }
                            }
                        }    
                    }
                    if(tsk.Status == 'Completed') {  
                        if(tsk.whatId != null){
                            if(String.valueOf(tsk.WhatId).StartsWith('006')){ 
                                WhatIds.add(tsk.WhatID);
                            }
                        }
                    }
                }
                //Ch-15 starts
                if(taskSet.size()>0){
                    for(TaskRelation taskRelationRec :[Select ID, RelationId,TaskId,LastModifiedDate from TaskRelation where TaskId in: taskSet]){
                        if(taskRelationRec.RelationId != null){
                            conIdSet.add(taskRelationRec.RelationId);
                        }
                    }
                }
                //Ch-15 ends
            }
            Id userId = userinfo.getUserId();
            User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId];
            Set<User> u = new Set<User>();
            u.add(userDetails);
            List<User> u1 = new List<User>();
            u1.addall(u);
            
            for(User u3 : u1){
                if(u3.id!=null){
                    userDetails1.put(u3.id,u3);//CH-16
                }else{}//do nothing
            }
            List<PermissionSetAssignment> PermissionSetAssignmentList=[SELECT Id, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment where  PermissionSet.Name='Edit_Business_development_Task_Event'];
            for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                assignIDList.add(permissionObj.AssigneeId);
            }
            //********CH-01 : Start(Added Insert Condition)***************
            //If(Trigger.isInsert){
            if(ContactWhoIds.size() != 0){
                conMap = new Map<Id, Contact>([Select master_rep_Id__c,Advisory_Segment__c,CBSA_Metro_Area__c, 
                                               Lpl_Attachment_Sent__c,Lpl_Attachment_Sent_Date__c, Email,
                                               Inactive_Reason__c, RecordType.Name
                                               ,Marketing_Category__c, Lead_Source__c // CH-10
                                               from Contact 
                                               Where (Id in :ContactWhoIds )]); 
                /* Start : Pravin Kale - loop to exculude LPL Insurance Associates Pouplation for Contact Prospect*/
                for(Contact con : conMap.Values()){
                    if(con.RecordType.Name != 'Contact Prospect'){
                        conMapIAP.put(con.ID, Con);    
                    }
                }
                for(GroupMember grp :  [Select Id, UserOrGroupId From GroupMember Where GroupId =: Label.LPL_Log_a_Call_Advisor_Group]){ //Ch-1: Added custom label
                    grpMap.put(grp.Id, grp);
                }
            }
            
            //Pravin Kale - changed parameter in Query from conMap to conMapIAP as part of Code Optimization
            if(Trigger.isInsert){
                for(LPL_Insurance_Associates__c ia: [Select Contact__c,Insurance_Tier__c,Fixed_Annuity_Segment__c,Variable_Annuity_Segment__c From LPL_Insurance_Associates__c Where (Contact__c in :conMapIAP.keySet() )]){
                    iaMap.put(ia.Contact__c, ia);
                }
            }
            
            //********CH-01 : End**************
            if(LeadWhoIds.size() != 0){
                leadMap = new Map<id, Lead>([Select Status From Lead Where (id in :LeadWhoIds)]);    
            }
            if(WhatIds.size() != 0){
                //Pravin Kale - changed parameter added record Type check as part of Code Optimization
                oppMap = new Map<id, Opportunity>([Select id, apex__c, Name, StageName From Opportunity Where (Id in :WhatIDs) and RecordType.Name =: 'RIA Compliance ADVantage']);
            }
            if(lastActivityWhatIds.size() != 0){ 
                lastActivityoppMap = new Map<id, Opportunity>([Select id, Last_Activity_Date__c,Internal_Recruiter_IRD__c,Key_Recruit_Contact__c From Opportunity Where (Id in :lastActivityWhatIds)]);  //CH-05 added internal Recruiter and key recruit contact
            }
            if(lastActivityWhoIds.size() != 0){
                //********CH-03 : Start***************
                lastActivityLeadMap = new Map<id, Lead>([Select id, Last_Activity_Date__c From Lead Where (Id in :lastActivityWhoIds) and RecordType.Name='Discovery Database Lead']); 
                //********CH-03 : End***************
            }
            if(taskID.size() != 0 ){
                
                //Pravin Kale - Added parameter to Query Record Type 'Transitions' Check as part of Code Optimization
                updateTaskstatusList = [select id, Status, Status_Not_Started_Entry__c, Status_Completed_Entry__c, Status_In_Progress_Entry__c,Status_Deferred_Entry__c, 
                                        Status_Not_Started_Exit__c, Status_In_Progress_Exit__c, Status_Deferred_Exit__c from Task where Id in: taskID and RecordTypeID =: rt];
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_taskTriggerGateway','collectRecordToProcess',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    
     //&&&&&added 28-may to handle Related To Use case
 /*   public  void handleRelatedTo(List<task> newList){
        Map<id,set<Id>> OppConMap=new Map<id,set<Id>> ();
        set<id> conids=new set<id>();
        set<id> oppids=new set<id>();
        for(Task newTask:newList){
            if(newTask.WhoId != null)
                conids.add(newTask.WhoId);
            
        }
        List<OpportunityContactRole> OppConList=[SELECT ContactId,OpportunityId FROM OpportunityContactRole where ContactId IN:conids];
        set<id> oppIdset=new set<id>();
        if(!OppConList.isEmpty()){
            for(OpportunityContactRole opcon:OppConList){
                 oppIdset=OppConMap.get(opcon.ContactId);
                if(oppIdset==null){
                    oppIdset=new set<Id>();
                    
                }else{
                    oppIdset.add(opcon.OpportunityId);
                }
                oppids.add(opcon.OpportunityId);
                OppConMap.put(opcon.ContactId,oppIdset);
                system.debug('OppConMap==>'+OppConMap);
            }
        }
        
        
        if(!oppids.isEmpty()){
            Map<id,Opportunity> OppMap=New Map<id,Opportunity>([select id,StageName from opportunity where (StageName ='1 - Engaged' OR StageName ='2 - Hot List' OR StageName !='3 - Submitted a Kit') AND Id IN:oppids]);
            system.debug('OppMap==>'+OppMap);
            system.debug('OppMap.Keyset()'+OppMap.Keyset());
        
        //if(userInfo.getUserId() !=''){
        for(Task T:NewList){
            if(T.whoId != null){
                system.debug('OppConMap.containsKey(T.whoId)'+OppConMap.containsKey(T.whoId));
                if(OppConMap.containsKey(T.whoId)){
                    set<id> setoppId=OppConMap.get(T.whoId);
                    if(setoppId.size()>0){
                        for(ID opid:setoppId){
                            system.debug('opid'+opid);
                            system.debug('OppMap.Keyset()'+OppMap.Keyset());
                            system.debug('OppMap.containsKey(opid)'+OppMap.containsKey(opid));
                            if(OppMap.containsKey(opid) && T.whatId==null){
                                T.whatId=OppMap.get(opid).id;
                            }
                        }
                    }
                } 
                //T.whatId=OppMap.get(OppConMap.get(T.whoId)).id;
            }
            system.debug('Task==>'+T);
        }
        // }
        
        }
    }
    
    
 public  void handleRelatedToOpp(List<task> newList){ 
        Map<id,set<Id>> OppConMap=new Map<id,set<Id>> ();
        set<id> conids=new set<id>();
        set<id> oppids=new set<id>();
        for(Task newTask:newList){
            if(newTask.whatId != null)
                oppids.add(newTask.whatId);
            
        }
        List<OpportunityContactRole> OppConList=[SELECT ContactId,OpportunityId FROM OpportunityContactRole where OpportunityId IN:oppids];
     system.debug('OppConList Task==>'+OppConList);   
     set<id> conIdset=new set<id>();
        if(!OppConList.isEmpty()){
            for(OpportunityContactRole opcon:OppConList){
                
                if(OppConMap.get(opcon.OpportunityId)!=null){
                    conIdset.add(opcon.ContactId);
                }
                else{
                    conIdset=new set<Id>();
                }
                conids.add(opcon.ContactId);
                OppConMap.put(opcon.OpportunityId,conIdset);
            }
        }
        
  system.debug('OppConMap==>'+OppConMap);        
        if(!conids.isEmpty()){
            Map<id,contact> ConMap=New Map<id,contact>([select id from contact  where Id IN:conids]);
            
        }
        //if(userInfo.getUserId() !=''){
        for(Task T:NewList){
            if(T.whatId != null){
                if(OppConMap.containsKey(T.whatId)){
                    system.debug('before Task==>'+T);
                    set<id> setoppId=OppConMap.get(T.whatId);
                    if(setoppId.size()>0){
                        for(ID opid:setoppId){
                            if(OppConMap.containsKey(opid) && T.whoId==null){
                                T.whoId=ConMap.get(opid).id;
                            }
                        }
                    }
                    system.debug('Task==>'+T);
                }
                //T.whatId=OppMap.get(OppConMap.get(T.whatId)).id;
            }
        }
        // }
        
        
    }  */
    
    
    //Ch-15 Starts
    public void updateLastRecruitingActivity(){
        List<Contact> conRecList = new List<Contact>([SELECT Id,name, (SELECT  Subject,Activity_Type__c, ActivityDate, Description,StartDateTime from ActivityHistories where (Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='BDA Touch' OR Activity_Type__c='SS&E Recruiting Category') order by ActivityDate DESC limit 1) FROM Contact WHERE Id IN:conIdSet AND RecordTypeId =:conRecordTypeId ]);
        for(Contact conRec: conRecList ){
            if(conRec.ActivityHistories.size()>0){
                ActivityHistory taskRec = conRec.ActivityHistories[0];
                conRec.Last_Recruiting_Activity__c =conRec.ActivityHistories[0].ActivityDate;
            }else{
                conRec.Last_Recruiting_Activity__c =null;
            }
        }
        if(conRecList !=null && conRecList.size()>0){
            update conRecList ;
        }
        
    }
    //Ch-15 Ends
    //
    
    
    public Void doBeforeInsertOperation(Task newTask,Task oldTask, Boolean isUpdate){
    
 /* &&&&& Ramola  
   id UserId =userInfo.getUserId();
    User u=[select id,userrole.name from User where id=:UserId];
    if(u.userRole.Name=='IRD'|| u.userRole.Name=='BDA'|| u.userRole.Name=='Business Development MD' || u.userRole.Name=='IS Recruiters' || u.userRole.Name=='Recruiters'){
    newTask.Department__c = 'Business Development'; 
    } */
 /*  newTask.Activity_Type__c=u.userRole.name;  */
   
    
    
    
    
        try{
            Contact fin = conMapIAP.get(newTask.WhoId);//Pravin Kale - changed parameter from conMap to conMapIAP as part of Code Optimization
            LPL_Insurance_Associates__c  IAObject= iaMap.get(newTask.WhoId);
            if(fin != null){       
                // newTask.Advisory_Segment__c=fin.Advisory_Segment__c; 
                newTask.master_rep_id__c=fin.master_rep_Id__c;  
                newTask.CBSA_Metro_Area__c= fin.CBSA_Metro_Area__c;                
            }
            Lead Lfin = leadMap.get(newTask.WhoId);
            if(Lfin != null){       
                newTask.lead_status__C=Lfin.Status; 
            }
            if(String.valueOf(newTask.whatId)!= null && String.valueOf(newTask.whatId).StartsWith('006')) {
                newTask.Related_Opportunity__c=newTask.whatId;
                taskRelatedOppList.add(newTask);
            }
            if(newTask.Type != null && newTask.Type == 'Email' && (!isUpdate ||(isUpdate && oldTask.Department__c == newTask.Department__c))){ //CH-14
                newTask.Department__c = 'Business Development';
            }
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    public void doAfterInsertOperation(Task newTask, Boolean isUpdate){
        try{
            if(WhatIds.size() == 0) {
                if(ContactWhoIds.size() != 0) {
                    updateContactProspectStatus(newTask);
                    emailAlert(newTask);
                }
            }
            if(oppMap.size() != 0){
                Opportunity opp = oppMap.get(newTask.WhatId);
                if(opp != null){       
                    opp.apex__c = true;
                    mOpportunity.put(opp.Id, opp);      
                }
            }
            //Pravin Kale - Added parameter Contact Cehck as a part of Code Optimization in below Condition 
            if(!isUpdate && newTask.whoId != null){
                if(String.valueOf(newTask.whoId).StartsWith('003')){
                    if(newTask.Subject==Label.Disruption_LPL_Scale_Advisor_Value  
                       || newTask.Subject== Label.Disruption_LPL_Scale_Change_Environment 
                       || newTask.Subject== Label.Disruption_LPL_Scale_Current_Firm_Limitations 
                       || newTask.Subject== Label.Disruption_LPL_Stability_Change_Environment
                       || newTask.Subject== Label.Disruption_LPL_Stability_Compensation 
                       || newTask.Subject== Label.Disruption_LPL_Stability_Current_Firm_Instability
                       || newTask.Subject== Label.Disruption_LPL_Value_Advisor_Value
                       || newTask.Subject== label.Disruption_LPL_Value_Control 
                       || newTask.Subject== Label.Disruption_LPL_Value_Current_Firm_Limitations ){
                           Task tsk = new task();
                           tsk.subject = 'Agile Email Follow Up';
                           tsk.Department__c = 'Business Development';
                           tsk.Activity_Type__c ='IRD Touch';
                           tsk.recordtypeId = rt;
                           if(newTask.whoId != null)
                               tsk.whoId = newTask.whoid; 
                           if(newTask.whatId != null)
                               tsk.whatId = newTask.whatid;
                           Datetime dt = DateTime.newInstance(Date.today(),Time.newInstance(0, 0, 0, 0));
                           String dayOfWeek = dt.format('EEEE');
                           if(dayOfWeek == 'Wednesday' || dayOfWeek == 'Thursday'|| dayOfWeek == 'Friday' ){
                               tsk.ActivityDate = system.today()+5;}
                           else If(dayOfWeek =='Saturday'){
                               tsk.ActivityDate = system.today()+4;}
                           else {   
                               tsk.ActivityDate = system.today()+3;}
                           tsk.OwnerId = newTask.OwnerId; 
                           tskList.add(tsk);    
                       }
                }
            }
            /*  Start - ******** Lead Onboarding Changes **********  */
            //Handle status days fields
            if(updateTaskstatusList.size() != 0){
                Triggerhandler handlerTask = new Triggerhandler();
                updNewList = handlerTask.handleTaskStatusDays(updateTaskstatusList, Trigger.OldMap.values());
            }
            /*  End - ******** Lead Onboarding Changes ********** */
            
            if(oppMap!=null || lastActivityLeadMap!=null ){                   
                commanInsertUpdateOperation(newTask);
            } 
            if(lastActivityLeadMap != null){
                commanInsertUpdateOperation(newTask);
            }
            /********************CH-10 Start***************************************/
            if(newTask.Status == 'Completed' && (newTask.Department__c=='Business Development' && ((newTask.Activity_Type__c=='IRD Touch' || newTask.Activity_Type__c=='Recruiting' || newTask.Activity_Type__c=='Master Recruiting' || newTask.Activity_Type__c=='BDA Touch') && ( newTask.Category__c!='Left Message – Prospecting' &&  newTask.Category__c!='Mailed information' &&  newTask.Category__c!='Email – Prospecting' &&  newTask.Category__c!='Referral to Branch' &&  newTask.Category__c!='Referral to Core' &&  newTask.Category__c!='Referral to IS' &&  newTask.Category__c!='Referral to Masters' && newTask.Category__c!='Other')))){
                if(conMap.get(newTask.WhoId) != null && conMap.get(newTask.WhoId).RecordTypeId == conRecordTypeId && conMap.get(newTask.WhoId).Marketing_Category__c != null &&conMap.get(newTask.WhoId).Marketing_Category__c == 'Dormant'){
                    if(conMap.get(newTask.WhoId).Lead_Source__c != null){
                        conMap.get(newTask.WhoId).Lead_Source__c = 'Recruiter Initiated';
                        executeUpdate = true;
                    }
                }
            }
            
            /*********************CH-10 End******************************************/   
        }  
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_taskTriggerGateway','doAfterInsertOperation',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    /* Start - Contact Update Opertion from Task */
    public void updateContactProspectStatus(Task newTask){
        try{
            if(conMap.keyset().Contains(newtask.whoId) && conMap.size() > 0){
                if((newTask.Department__c == 'Business Development' && newTask.Activity_Type__c == 'IRD Touch'
                    && (newTask.Category__c == 'Email' || newTask.Category__c == 'Left Message' || newTask.Category__c == 'Mailed information'
                        || newTask.Category__c == 'Email – Prospecting' || newTask.Category__c == 'Left Message – Prospecting' ||  newTask.Category__c == 'Social Media Outreach') 
                    && newTask.Status == 'Completed') || 
                   (newTask.Department__c == 'Business Development' && (newTask.Activity_Type__c == 'Recruiting' || newTask.Activity_Type__c == 'Master Recruiting')
                    && (newTask.Category__c == 'Email' || newTask.Category__c == 'Left Message' || newTask.Category__c == 'Mailed information'
                        || newTask.Category__c == 'Email-Outbound') 
                    && newTask.Status == 'Completed')
                   || 
                   // Ch-08 start
                   (newTask.Department__c == 'Business Development' && newTask.Activity_Type__c == 'BDA Touch'
                    && (newTask.Category__c == 'Email Send' || newTask.Category__c == 'Left Message' ||newTask.Category__c == 'Social Outreach')
                    
                    && newTask.Status == 'Completed')
                  ){
                      if(conMap.get(newTask.whoId).Inactive_Reason__c != 'Active Opportunity'){  
                          /* SLU-153 - Start */
                          if(conMap.get(newTask.whoId).Inactive_Reason__c != 'Responsive'){
                              conMap.get(newTask.whoId).Inactive_Reason__c = 'Contact Attempted';
                              /* SLU-153 - End*/
                              executeUpdate = true;
                          }}
                  } else if((newTask.Department__c == 'Business Development' && newTask.Activity_Type__c == 'IRD Touch'
                             && (newTask.Category__c == 'IRD Meeting Complete - COI' || newTask.Category__c == 'Call-Inbound' || newTask.Category__c == 'Call-Outbound'
                                 || newTask.Category__c == 'Call – Outbound Prospecting' || newTask.Category__c == 'IRD Meeting Complete – Existing Recruit' 
                                 || newTask.Category__c == 'IRD Meeting Complete – New Recruit' || newTask.Category__c == 'IRD Meeting Set– Existing Recruit' 
                                 || newTask.Category__c == 'IRD Meeting Set – New Recruit' || newTask.Category__c == 'RD Meeting Set – Existing Recruit' 
                                 || newTask.Category__c == 'RD Meeting Set – New Recruit' || newTask.Category__c == 'HOV Host') 
                             && newTask.Status == 'Completed')|| 
                            (newTask.Department__c == 'Business Development' && (newTask.Activity_Type__c == 'Recruiting' || newTask.Activity_Type__c == 'Master Recruiting')
                             && (newTask.Category__c == 'Call-Inbound' || newTask.Category__c == 'Call-Outbound' || newTask.Category__c == 'Conf. Call Webinar'
                                 || newTask.Category__c == 'Home Office Visit' || newTask.Category__c == 'Meeting – Drop-by' || newTask.Category__c == 'Meeting – Existing Recruit'
                                 || newTask.Category__c == 'Meeting – New Recruit' || newTask.Category__c == 'Meeting – Target City'
                                 || newTask.Category__c == 'Meeting – Wholesaler' || newTask.Category__c == 'RVP Assist Meeting') 
                             && newTask.Status == 'Completed')|| 
                            (newTask.Department__c == 'Business Development' && newTask.Activity_Type__c == 'BDA Touch'
                             && (newTask.Category__c == 'Call-Inbound' || newTask.Category__c == 'Call-Outbound' || newTask.Category__c == 'RD Meeting Set' || newTask.Category__c == 'IRD Meeting Set')
                             && newTask.Status == 'Completed')){
                                 if(conMap.get(newTask.whoId).Inactive_Reason__c != 'Active Opportunity'){
                                     /* SLU-153 - Start */
                                     conMap.get(newTask.whoId).Inactive_Reason__c = 'Known Prospect';
                                     /* SLU-153 - END */
                                     executeUpdate = true;
                                 }    
                             }    
            }
        }  catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_taskTriggerGateway','updateContactProspectStatus',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }        
    }    
    /* End - Contact Update Opertion from Task */
    public void commanInsertUpdateOperation(Task newTask){
        try{
            if( lastActivityoppMap!=null && lastActivityoppMap.size() > 0 ){ 
                Opportunity lastActivityopp = lastActivityoppMap.get(newTask.WhatId); 
                if(lastActivityopp != null){
                    lastActivityopp.Last_Activity_Date__c = System.now();           
                    lastActivityoppMap.remove(newTask.WhatId);           
                    lastActivityoppMap.put(lastActivityopp.Id, lastActivityopp);
                }
            } 
            if(lastActivityoppMap != null && lastActivityoppMap.size() != 0){
                oppFutureUpDateList = lastActivityoppMap.values();           
            }     
            if( lastActivityLeadMap!=null && lastActivityLeadMap.size() > 0){ 
                Lead LeadlastActivityLead = lastActivityLeadMap.get(newTask.WhoId); 
                if(LeadlastActivityLead  != null){
                    LeadlastActivityLead.Last_Activity_Date__c = System.now(); 
                    lastActivityLeadMap.remove(newTask.WhatId);
                    lastActivityLeadMap.put(LeadlastActivityLead.Id, LeadlastActivityLead);
                }
            }
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    //Cehck the Email sent to Advisor is sent or Not
    public void emailAlert(task newTaskObj) {
        try{
            Set<Id> userGroupIds = GetUserIdsFromGroup(grpID);
            ID userID = UserInfo.getUserId();
            Integer countDays;
            if(conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent_Date__c != null) {
                countDays = conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent_Date__c.daysBetween(System.Today());
            }
            if(userGroupIds.contains(userID)) {
                if(conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent__c == false ) {
                    conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent__c = true; 
                    conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent_Date__c = System.Today();
                    executeUpdate = true;
                } else if(conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent__c == true && countDays > 90 ) {
                    conMap.get(newTaskObj.whoId).Lpl_Attachment_Sent_Date__c = System.Today();
                    executeUpdate = true;
                }
            }
        }catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    public Set<id> GetUserIdsFromGroup(Id groupId){ 
        Set<Id> result=new Set<Id>();
        try{
            String userType = Schema.SObjectType.User.getKeyPrefix();
            String groupType = Schema.SObjectType.Group.getKeyPrefix();
            if(grpMap.size() != 0){
                for (GroupMember m : grpMap.values()){
                    if (((String)m.UserOrGroupId).startsWith(userType)){
                        result.add(m.UserOrGroupId);
                    }
                    // Note: there may be a problem with governor limits if this is called too many times
                    else if (((String)m.UserOrGroupId).startsWith(groupType)){  
                        // Call this function again but pass in the group found within this group
                        result.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
                    }
                }
            }
        }catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_taskTriggerGateway','GetUserIdsFromGroup',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
        return result;  
    }
    @Future //CH-04
    public static void updateOppFuture(){
        try{
            update oppFutureUpDateList;
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_TasKTriggerGateway','updateOppFuture',e.getMessage(),e.getLineNumber(),e.getTypeName());      
        }
    }
    //CH-09 Start
    public  void deleteAndEditRecordByRole(Task newTask){
        try{  
            Id userId = userinfo.getUserId();
            if(newTask.Department__c!=Null && newTask.Department__c=='Business Development' && (userDetails1.get(userId).UserRole.Name=='IRD'|| userDetails1.get(userId).UserRole.Name=='IRD Managment'|| userDetails1.get(userId).UserRole.Name=='Masters Recruiter_v2'||userDetails1.get(userId).UserRole.Name=='Regional VP'|| userDetails1.get(userId).UserRole.Name=='Recruiters' ||assignIDList.contains(userId) || userDetails1.get(userId).UserRole.Name=='BDA' || userDetails1.get(userId).UserRole.Name=='BD-A' || userId == newTask.CreatedById || userDetails1.get(userId).Profile.Name =='System Administrator') ){// CH-12 and CH-13 Added condition to include BDA/BD-A Role,CH-16
            }
            else if(newTask.Department__c!=Null && newTask.Department__c=='Business Development'){ 
                newTask.addError('Insufficient privileges, Please contact System Administrator.');
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_TasKTriggerGateway','updateOppFuture',e.getMessage(),e.getLineNumber(),e.getTypeName());      
        }
    }
    //CH-09 End
    public void proceedAddFinally(){
        
        try{  
            if(conMap.size() != 0 && executeUpdate == true) { 
                taskcheck =True;
                update conMap.values();
            }
            
            if(!oppFutureUpDateList.isEmpty() && LPL_TaskTriggerGateway.var1==true){  //Ch-07 Start
                update oppFutureUpDateList;   //CH-04
                LPL_TaskTriggerGateway.var1=false;  //Ch-07 End
            }
            if(mOpportunity!= null && mOpportunity.size() > 0){
                lOpportunities = mOpportunity.values();
                update lOpportunities;
            }
            if(lastActivityLeadMap!= null && lastActivityLeadMap.size() > 0){
                update lastActivityLeadMap.values();
            }
            if(updNewList != null && updNewList.size() > 0){
                update updNewList;
            }
            if(tskList.size()>0){    
                insert tskList;
            } 
        } catch(exception e){
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_TasKTriggerGateway','proceedAddFinally',e.getMessage(),e.getLineNumber(),e.getTypeName());     
        }
    }
}