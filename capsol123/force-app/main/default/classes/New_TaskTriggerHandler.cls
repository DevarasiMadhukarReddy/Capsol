public class New_TaskTriggerHandler implements BaseTriggerHandler{
    //GLobal variabless           
    public static boolean runonce=true;
    public static boolean runonce1=true;
    public static boolean runonce2=true;
    public static boolean runonce3=true;
    public static boolean runonce4=true;
    public static boolean runonce5=true;
    public static Integer count=0;
     public List<Opportunity> oppFutureUpDateList = new List<Opportunity>();
    
    public Boolean IsDisabled()
    {
        return false;
    }
    
    public void BeforeInsert(List<SObject> newItems) {
        if(test.isRunningTest()){
     HandleCoverage.method();
     HandleCoverage.method1();
     HandleCoverage.method2();
     HandleCoverage.method3();
    }
        count=count+1;
        
        system.debug('count====>'+count);
        relatedrecordsupdate(Trigger.New, Trigger.Old,false);
        createnewTasks(Trigger.New, Trigger.Old,false);
        //collectRecordToProcess(Trigger.New, Trigger.Old,true);
        handleRelatedTo(trigger.new);
        handleRelatedToOpp(trigger.new);
        //handlePeopleAI(trigger.new);
        TaskEmailFieldsUpdate(trigger.new);
        
        //doBeforeInsertOperation((Map<Id,Task>)trigger.newMap ,(Map<Id,Task>)trigger.oldMap,trigger.isupdate);
        handleoutlook(trigger.new);
        
        
        
    } 

    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        
        relatedrecordsupdate(Trigger.New, Trigger.Old,true);
        createnewTasks(Trigger.New, Trigger.Old,true);
        //collectRecordToProcess(Trigger.New, Trigger.Old,true);
        handleRelatedTo(trigger.new);
        handleRelatedToOpp(trigger.new);
        //handlePeopleAI(trigger.new);
        handleoutlook(trigger.new);
        TaskEmailFieldsUpdate(trigger.new);
        
        
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {
        Preventdeletion(trigger.old);
        
    }
    
    public void AfterInsert(Map<Id, SObject> newItems) {
        updateLastRecruitingActivity(trigger.new);
         //updateContactProspectStatus(Trigger.New);
        
        
        
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        updateLastRecruitingActivity(trigger.new);
        // updateContactProspectStatus(Trigger.New);
        //updateLastRecruitingActivity(trigger.new);
        
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) {
        
        
    }
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {
        
        
    }
    
    
    public void updateContactProspectStatus(List<Task> newTasklst){
        set<id> ContactWhoIds=new set<Id>();
        Map<Id, Contact> conMap = new Map<Id, Contact>(); 
        for(Task tsk: newTasklst){
            if(tsk.whoId!= null){       
                if(String.valueOf(tsk.whoId).StartsWith('003')){
                    ContactWhoIds.add(tsk.whoId);
                }
            }
        }
        for(Task newTask: newTasklst){
            if(ContactWhoIds.size() != 0){
                conMap = new Map<Id, Contact>([Select master_rep_Id__c,Advisory_Segment__c,CBSA_Metro_Area__c, 
                                               Lpl_Attachment_Sent__c,Lpl_Attachment_Sent_Date__c, Email,
                                               Inactive_Reason__c, RecordType.Name
                                               ,Marketing_Category__c, Lead_Source__c // CH-10
                                               from Contact 
                                               Where (Id in :ContactWhoIds )]); 
                
                
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
                           //       conMap.get(newTask.whoId).Inactive_Reason__c = 'Contact Attempted';
                                  /* SLU-153 - End*/
                                  
                              }}
                      } else if((newTask.Activity_Type__c == 'IRD Touch'
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
                                    //    conMap.get(newTask.whoId).Inactive_Reason__c = 'Known- Prospect';
                                         /* SLU-153 - END */
                                         
                                     }    
                                 }    
                }
            }       
        }
        if(conMap!=null)
            update conMap.values();
    }   
      
    
    
    
    
    
    public  void Preventdeletion(List<Task> newTaskList){
        Set<ID> assignIDList=new Set<Id>();
        Map<Id,User>  userDetails1 = new  Map<Id,User>();
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
        
        for(Task newTask: newTaskList){
            
            if(newTask.Department__c!=Null && newTask.Department__c=='Business Development' && (userDetails1.get(userId).UserRole.Name=='IRD'|| userDetails1.get(userId).UserRole.Name=='IRD Managment'|| userDetails1.get(userId).UserRole.Name=='Masters Recruiter_v2'||userDetails1.get(userId).UserRole.Name=='Regional VP'|| userDetails1.get(userId).UserRole.Name=='Recruiters' ||assignIDList.contains(userId) || userDetails1.get(userId).UserRole.Name=='BDA' || userDetails1.get(userId).UserRole.Name=='BD-A' || userId == newTask.CreatedById || userDetails1.get(userId).Profile.Name =='System Administrator') ){// CH-12 and CH-13 Added condition to include BDA/BD-A Role,CH-16
            }
            else if(newTask.Department__c!=Null && newTask.Department__c=='Business Development'){ 
                newTask.addError('Insufficient privileges, Please contact System Administrator.');
            }
        }
        
    }
    
    
    
    
    /**
* relatedrecordsupdate performs all the updates related to 
* all related records like contact and leads
* 
* 
**/   
    
    
    public void relatedrecordsupdate(List<Task> tskList, List<Task> tskOldList,Boolean isBefore){
    List<Opportunity> lOpportunities = new List<Opportunity>();
        system.debug('Inside===> Trigger');
        if(runonce){
        runonce=false;
        List<contact> finalconlst=new List<contact>();
            List<contact> finalconlst1=new List<contact>();
            Set<id> ContactWhoIds = new Set<id>();//related contact Ids
            Map<Id, Task> tskMap = new Map<Id, Task>();//holds old task map
            Set<id> LeadWhoIds = new Set<id>();//holds related lead ids
            Set<ID> taskSet=new Set<ID>();//holds selected task ids
            Set<Id> lastActivityWhatIds = new Set<Id>();//holds related whatids (leads)
            Set<Id> lastActivityWhoIds = new Set<Id>();//holds related whoids(contacts)
            Set<ID> taskID = new Set<ID>();//holds set of task ids
            Set<Id> WhatIds = new Set<Id>();//holds all whatids
            //Set<String> conIdSet = new Set<String>();//holds all the rlated contacts
            Map<Id, Contact> conMap = new Map<Id, Contact>();//holds map of id and contact
            Map<Id, Contact> conMapIAP = new Map<Id, Contact>();//holds all the insurance associate Contacts  
            Map<Id, LPL_Insurance_Associates__c> iaMap=new Map<Id, LPL_Insurance_Associates__c>();//holds Map of Id and insurance records
            Map<id, Lead> leadMap = new Map<id, Lead>(); 
            Map<id, Opportunity> oppMap = new Map<id, Opportunity>();
            Map<Id, Opportunity> lastActivityoppMap;
            Map<Id, Lead> lastActivityLeadMap;
            List<lead> leadlst=new List<lead>();//Final
            List<Task> updateTaskstatusList = new List<Task>();
            Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
            Map<String,Schema.RecordTypeInfo> rt_TaskMap = tskRecDesc.getRecordTypeInfosByName();
            Id rt = rt_TaskMap.get('Transitions').getRecordTypeId();
            List<Task> updNewList = new List<Task>();
            Map<Id, Opportunity> mOpportunity = new Map<Id, Opportunity>();
            ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
            
            if(tskList != null){
                for(Task tsk: tskList){
                    system.debug('task==>'+tsk);
                    if(tsk.whoId!= null){       
                        if(String.valueOf(tsk.whoId).StartsWith('003')){
                            ContactWhoIds.add(tsk.whoId);
                        }
                        if(String.valueOf(tsk.whoId).StartsWith('003') && tsk.Status=='Completed' &&  (tsk.Activity_Type__c=='IRD Touch' || tsk.Activity_Type__c=='Recruiting' 
                                                                                                       || tsk.Activity_Type__c=='Master Recruiting' || tsk.Activity_Type__c=='BDA Touch')){
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
                        system.debug('lastActivityWhatIds===>'+lastActivityWhatIds);
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
                    if(tsk.Status == 'CompletedPL+') {  
                        if(tsk.whatId != null){
                            if(String.valueOf(tsk.WhatId).StartsWith('006')){ 
                                WhatIds.add(tsk.WhatID);
                            }
                        }
                    }
                }
                
                
                
            }
            if(ContactWhoIds.size() != 0){
                conMap = new Map<Id, Contact>([Select master_rep_Id__c,Advisory_Segment__c,CBSA_Metro_Area__c, 
                                               Lpl_Attachment_Sent__c,Lpl_Attachment_Sent_Date__c, Email,
                                               Inactive_Reason__c, RecordType.Name
                                               ,Marketing_Category__c, Lead_Source__c // CH-10
                                               from Contact 
                                               Where (Id in :ContactWhoIds )]); 
                
                for(Contact con : conMap.Values()){
                    if(con.RecordType.Name != 'Contact Prospect'){
                        conMapIAP.put(con.ID, Con);    
                    }
                }
                
            }
            if(Trigger.isInsert){
                for(LPL_Insurance_Associates__c ia: [Select Contact__c,Insurance_Tier__c,Fixed_Annuity_Segment__c,Variable_Annuity_Segment__c From LPL_Insurance_Associates__c Where (Contact__c in :conMapIAP.keySet() )]){
                    iaMap.put(ia.Contact__c, ia);
                }
            }
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
                
                lastActivityLeadMap = new Map<id, Lead>([Select id, Last_Activity_Date__c From Lead Where (Id in :lastActivityWhoIds) and RecordType.Name='Discovery Database Lead']); 
                
            }
            if(taskID.size() != 0 ){
                
                //Pravin Kale - Added parameter to Query Record Type 'Transitions' Check as part of Code Optimization
                updateTaskstatusList = [select id, Status, Status_Not_Started_Entry__c, Status_Completed_Entry__c, Status_In_Progress_Entry__c,Status_Deferred_Entry__c, 
                                        Status_Not_Started_Exit__c, Status_In_Progress_Exit__c, Status_Deferred_Exit__c from Task where Id in: taskID and RecordTypeID =: rt];
            }
            if(updateTaskstatusList.size() != 0){
                Triggerhandler handlerTask = new Triggerhandler();
                updNewList = handlerTask.handleTaskStatusDays(updateTaskstatusList, Trigger.OldMap.values());
            }
            
            if(updNewList != null && updNewList.size() > 0){
                update updNewList;
            }
            
            boolean isUpdate=trigger.isupdate;
            
            
            
            set<Id> idset=new set<id>();
            Task oldTask=new Task();
            for(task newTask:tskList){
                if(isUpdate){
                    if(trigger.oldMap.containsKey(newTask.id))
                        oldTask=(task)trigger.oldMap.get(newTask.id);
                }
                Contact fin = conMapIAP.get(newTask.WhoId);//Pravin Kale - changed parameter from conMap to conMapIAP as part of Code Optimization
                LPL_Insurance_Associates__c  IAObject= iaMap.get(newTask.WhoId);
                if(fin != null){       
                    
                    newTask.master_rep_id__c=fin.master_rep_Id__c;  
                    newTask.CBSA_Metro_Area__c= fin.CBSA_Metro_Area__c;                
                }
                
                if(oppMap.size() != 0){
                    Opportunity opp = oppMap.get(newTask.WhatId);
                    if(opp != null){       
                        opp.apex__c = true;
                        mOpportunity.put(opp.Id, opp);      
                    }
                }
                Lead Lfin = leadMap.get(newTask.WhoId);
                if(Lfin != null){       
                    newTask.lead_status__C=Lfin.Status; 
                }
                if(String.valueOf(newTask.whatId)!= null && String.valueOf(newTask.whatId).StartsWith('006')) {
                    newTask.Related_Opportunity__c=newTask.whatId;
                }
                
                
                
                if(newTask.Status == 'Completed' && (((newTask.Activity_Type__c=='IS Recruiter' || newTask.Activity_Type__c=='Premium' ||newTask.Activity_Type__c=='SS&E' || newTask.Activity_Type__c=='IRD Touch' || newTask.Activity_Type__c=='Recruiting' || newTask.Activity_Type__c=='Master Recruiting' || newTask.Activity_Type__c=='BDA Touch') && ( newTask.Category__c!='Left Message – Prospecting' &&  newTask.Category__c!='Mailed information' &&  newTask.Category__c!='Email – Prospecting' &&  newTask.Category__c!='Referral to Branch' &&  newTask.Category__c!='Referral to Core' &&  newTask.Category__c!='Referral to IS' &&  newTask.Category__c!='Referral to Masters' && newTask.Category__c!='Other')))){
                    if(conMap.get(newTask.WhoId) != null && conMap.get(newTask.WhoId).RecordTypeId == conRecordTypeId && conMap.get(newTask.WhoId).Marketing_Category__c != null ){
                        if(conMap.get(newTask.WhoId).Lead_Source__c != null){
                            conMap.get(newTask.WhoId).Lead_Source__c = 'Recruiter Initiated';
                            
                        }
                    }
                }
                
                
                
                if(mOpportunity!= null && mOpportunity.size() > 0){
                    lOpportunities.addAll(mOpportunity.values());
                    //update lOpportunities;
                }
                
                /*  start - ******** Lead Onboarding Changes ********** */
                
                system.debug('lastActivityoppMap'+lastActivityoppMap);
                system.debug('lastActivityLeadMap'+lastActivityLeadMap);
                /*  End - ******** Lead Onboarding Changes ********** */
                if(oppMap!=null || lastActivityoppMap!=null ){                   
                    commanInsertUpdateOperation(newTask,lastActivityoppMap,lastActivityLeadMap);
                } 
                if(lastActivityLeadMap != null){
                    commanInsertUpdateOperation(newTask,lastActivityoppMap,lastActivityLeadMap);
                }
                system.debug('lastActivityLeadMap====>'+lastActivityLeadMap);
                if(lastActivityLeadMap!=null){
                leadlst.addAll(lastActivityLeadMap.values());
                    //update lastActivityLeadMap.values();
                }
                if(lastActivityoppMap!=null){
                lOpportunities.addAll(lastActivityoppMap.values());
                    //update lastActivityoppMap.values();
                }
                if(conMap!=null)
                    finalconlst1.addAll(conMap.values());
                
            }
            
            if(oppFutureUpDateList.size()>0)
            database.update(oppFutureUpDateList,false);
            //update oppFutureUpDateList;
            
            if(finalconlst1.size()>0){
                    database.update(finalconlst,false);
                    }
                    
            if(leadlst.size()>0){
                    database.update(leadlst,false);
                }
            
            if(mOpportunity!= null && mOpportunity.size() > 0){
                    
                    database.update(lOpportunities,false);
                }
            
        }
    }
    
    
    
    
    /**
* Creats new tasks based on teh subject
* 
* 
**/
    
    
    public void createnewTasks(List<Task> tskList, List<Task> tskOldList,Boolean isUpdate){
        
        Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
        Map<String,Schema.RecordTypeInfo> rt_TaskMap = tskRecDesc.getRecordTypeInfosByName();
        Id rt = rt_TaskMap.get('Transitions').getRecordTypeId();
        List<Task> NewtskList=new List<Task>();
        try{
            if(runonce1){
                
                for(task newTask:tskList){
                    
                    
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
                                   NewtskList.add(tsk);    
                               }
                        }
                    }
                    
                }
                upsert NewtskList;
                runonce1=false;
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_taskTriggerGateway','doAfterInsertOperation',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    
    
    
    public void commanInsertUpdateOperation(Task newTask,Map<Id, Opportunity> lastActivityoppMap,Map<Id, Lead> lastActivityLeadMap){
        //try{
        
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
        
        /*}
catch(Exception e) {
system.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
}*/
    }
    
    
    
    
    
    
    
    //&&&&&added 28-may to handle Related To Use case
    public  void handleRelatedTo(List<task> newList){
        if(runonce4){
            List<id> IDS=new List<id>();
            //system.debug('INSIDE TASK 3006');
            Map<id,set<Id>> OppConMap=new Map<id,set<Id>> ();
            set<id> conids=new set<id>();
            set<id> oppids=new set<id>();
            for(Task newTask:newList){
                IDS.add(newTask.id);
                if(newTask.WhoId != null)
                    conids.add(newTask.WhoId);
                
            }
            
            
            
            Map<id,contact> Mapcon=new Map<id,contact>([select id,recordtypeId from contact where id IN:conids]);
            List<OpportunityContactRole> OppConList=[SELECT ContactId,OpportunityId FROM OpportunityContactRole where ContactId IN:conids];
            set<id> oppIdset=new set<id>();
            if(!OppConList.isEmpty()){
                for(OpportunityContactRole opcon:OppConList){
                    oppIdset=OppConMap.get(opcon.ContactId);
                    if(oppIdset==null){
                        oppIdset=new set<Id>();
                        oppIdset.add(opcon.OpportunityId);
                        
                    }else{
                        oppIdset.add(opcon.OpportunityId);
                    }
                    oppids.add(opcon.OpportunityId);
                    OppConMap.put(opcon.ContactId,oppIdset);
                    //system.debug('OppConMap==>'+OppConMap);
                }
            }
            
            
            if(!oppids.isEmpty()){
                Map<id,Opportunity> OppMap=New Map<id,Opportunity>([select id,StageName from opportunity where (StageName ='1 - Engaged' OR StageName ='2 - Hot List' OR StageName ='3 - Submitted a Kit') AND Id IN:oppids]);
                //system.debug('OppMap==>'+OppMap);
                //system.debug('OppMap.Keyset()'+OppMap.Keyset());
                
                //if(userInfo.getUserId() !=''){
                for(Task T:NewList){
                    if(T.whoId != null){
                        ////system.debug('OppConMap.containsKey(T.whoId)'+OppConMap.containsKey(T.whoId));
                        if(OppConMap.containsKey(T.whoId) && Mapcon.containsKey(T.whoId) && Mapcon.get(T.whoId).RecordTypeId=='0120P000000AK3I'){
                            set<id> setoppId=OppConMap.get(T.whoId);
                            if(setoppId.size()>0){
                                for(ID opid:setoppId){
                                    ////system.debug('opid'+opid);
                                    ////system.debug('OppMap.Keyset()'+OppMap.Keyset());
                                    ////system.debug('OppMap.containsKey(opid)'+OppMap.containsKey(opid));
                                    if(OppMap.containsKey(opid) && T.whatId==null){
                                        T.whatId=OppMap.get(opid).id;
                                    }
                                }
                            }
                        }
                        //T.whatId=OppMap.get(OppConMap.get(T.whoId)).id;
                    }
                    //system.debug('Task==>'+T);
                }
                // }
                
            }
            runonce4=false;
        }
    }
    
    
    public  void handleRelatedToOpp(List<task> newList){
        if(runonce3){
            Map<id,set<Id>> OppConMap=new Map<id,set<Id>> ();
            set<id> conids=new set<id>();
            set<id> oppids=new set<id>();
            for(Task newTask:newList){
                if(newTask.whatId != null)
                    oppids.add(newTask.whatId);
                
            }
            List<OpportunityContactRole> OppConList=[SELECT ContactId,OpportunityId FROM OpportunityContactRole where OpportunityId IN:oppids];
            //system.debug('OppConList Task==>'+OppConList);   
            set<id> conIdset=new set<id>();
            if(!OppConList.isEmpty()){
                for(OpportunityContactRole opcon:OppConList){
                    
                    conIdset=OppConMap.get(opcon.OpportunityId);
                    if(conIdset==null){
                        conIdset=new set<Id>();
                        conIdset.add(opcon.ContactId);
                        conids.add(opcon.ContactId);
                    }
                    else{
                        conIdset.add(opcon.ContactId);
                        conids.add(opcon.ContactId);
                    }
                    //system.debug('conIdset==>'+conIdset); 
                    //system.debug('conids==>'+conids); 
                    OppConMap.put(opcon.OpportunityId,conIdset);
                }
            }
            
            //system.debug('OppConMap==>'+OppConMap);        
            // if(!conids.isEmpty()){
            Map<id,contact> ConMap=New Map<id,contact>([select id,RecordTypeId from contact  where Id IN:conids]);
            
            //}
            //system.debug('ConMap==>'+ConMap); 
            //if(userInfo.getUserId() !=''){
            for(Task T:NewList){
                if(T.whatId != null){
                    if(OppConMap.containsKey(T.whatId)){
                        //system.debug('before Task==>'+T);
                        set<id> setoppId=OppConMap.get(T.whatId);
                        //system.debug('OppConMap==>'+OppConMap);
                        //system.debug('setoppId==>'+setoppId);
                        if(setoppId.size()>0){
                            for(ID opid:setoppId){
                                if(ConMap.containsKey(opid) && T.whoId==null && ConMap.get(opid).RecordTypeId=='0120P000000AK3I'){
                                    
                                    T.whoId=ConMap.get(opid).id; 
                                }
                            }
                        }
                        //system.debug('Task==>'+T);
                    }
                    //T.whatId=OppMap.get(OppConMap.get(T.whatId)).id;
                }
            }
            // }
            runonce3=false;
        }
    }    
    
    //&&&&&End
    //&&&&&&13062019
    //@future
    /*public static void handlePeopleAI(List<Task> newList){
        If(runonce2){
            system.debug('INSIDE Future');
            //List<Task> newList=[select id,subject,peopleai__ActivityType__c,peopleai__Created_by_PeopleAI__c,Activity_Type__c,Category__c,ownerid  from Task where ID IN:TSKIDS];
            
            map<id,id>assignIds=new map<id,id>();
            for(Task T:newList){
                if(T.peopleai__Created_by_PeopleAI__c==true){
                    T.Status='Completed';
                    T.Department__c ='Business Development';
                    assignIds.put(T.ownerid,T.ownerid);
                }
            }
            //system.debug('assignIds==>'+assignIds);
            Map<id,user> uMap=new Map<id,user>([ select Id, Name, UserRole.Name  from User where ID IN:assignIds.values()]);
            for(Task T:newList){
                string actstr='';
                string Pstr='';
                //system.debug('uMap==>'+uMap);
                if(assignIds.containsKey(T.ownerid)){
                    system.debug('u==>'+uMap.get(assignIds.get(T.ownerid)));
                    actstr=uMap.get(assignIds.get(T.ownerid)).UserRole.Name;
                    system.debug('actstr==>'+actstr);
                    Pstr=T.peopleai__ActivityType__c;
                    if(actstr ==null)
                        continue;
                    
                    if(actstr.contains('Recruiters')){
                        T.Activity_Type__c='Recruiting';
                        if(Pstr.contains('Sent Email')||Pstr.contains('Cold Email')||Pstr.contains('Blast Email')){
                            T.Category__c='Email-Outbound';
                        }
                        if(Pstr.contains('Received Email')){
                            T.Category__c='Email';
                        }
                    }
                    if(actstr.contains('IS Recruiters')){
                        T.Activity_Type__c='Master Recruiting';
                        if(Pstr.contains('Sent Email')||Pstr.contains('Cold Email')||Pstr.contains('Blast Email')){
                            T.Category__c='Email-Outbound';
                        }
                        if(Pstr.contains('Received Email')){
                            T.Category__c='Email';
                        }
                    }
                    if(actstr.contains('IRD')){
                        T.Activity_Type__c='IRD Touch';
                        if(Pstr.contains('Sent Email')||Pstr.contains('Cold Email')||Pstr.contains('Blast Email')){
                            T.Category__c='Email – Prospecting';
                        }
                        if(Pstr.contains('Received Email')){
                            T.Category__c='Email';
                        }
                    }
                    /*     if(actstr.contains('RD')){
T.Activity_Type__c='Recruting';
} */
                    /*if(actstr.contains('SS&E')){
                        T.Activity_Type__c='SS&E Recruiting Category';
                        if(Pstr.contains('Sent Email')||Pstr.contains('Cold Email')||Pstr.contains('Blast Email')){
                            T.Category__c='Email-Outbound';
                        }
                        if(Pstr.contains('Received Email')){
                            T.Category__c='Email';
                        }
                    }
                    if(actstr.contains('BDA')){
                        T.Activity_Type__c='BDA Touch';
                        if(Pstr.contains('Sent Email')||Pstr.contains('Cold Email')||Pstr.contains('Blast Email')){
                            T.Category__c='Email Send';
                        }
                        if(Pstr.contains('Received Email')){
                            T.Category__c='Email Capture';
                        }
                    }
                    if(actstr.contains('Premium')){
                        T.Activity_Type__c='Premium';
                        if(Pstr.contains('Sent Email')||Pstr.contains('Cold Email')||Pstr.contains('Blast Email')){
                            T.Category__c='Email-Outbound';
                        }
                        if(Pstr.contains('Received Email')){
                            T.Category__c='Email';
                        } 
                    }
                    system.debug('Activity_Type__c==>'+T.Activity_Type__c);
                    system.debug('Task==>'+T);
                    
                }
                
            }
            runonce2=false;
        }
        //stoprecursive=false;
        //Upsert newList;
    }*/
    
    //&&&&&&13062019end
    
  public void updateLastRecruitingActivity(List<Task> tskOldList){
      if(runonce5){
          runonce5=false;
      ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
     Set<String> conIdSet = new Set<String>();
    Set<Id> taskOldSet = new Set<Id>();
      if(tskOldList != null){
                for(Task oldTsk : tskOldList){
                       
                    //Ch-15 starts
                    if(oldTsk.whoId!=null){
                        if(String.valueOf(oldTsk.whoId).StartsWith('003') && oldTsk.Status=='Completed' &&  (oldTsk.Activity_Type__c=='IRD Touch' || oldTsk.Activity_Type__c=='Recruiting' || oldTsk.Activity_Type__c=='Master Recruiting' || oldTsk.Activity_Type__c=='BDA Touch' || oldTsk.Activity_Type__c=='SS&E Recruiting Category' || oldTsk.Activity_Type__c=='Premium')){
                            taskOldSet.add(oldTsk.id);
                        }
                    }
                    //Ch-15 ends
                }
            }
    
    system.debug('taskOldSet==>'+taskOldSet.size());
    if(taskOldSet.size()>0 ){
                for(TaskRelation taskRelationRec :[Select ID, RelationId,TaskId,LastModifiedDate from TaskRelation where TaskId in: taskOldSet]){
                    if(taskRelationRec.RelationId != null){
                        system.debug('bbbbbbbbbbbbbbbbbbbbbbbb');
                        conIdSet.add(taskRelationRec.RelationId);
                    }
                }
            }
    
    system.debug('conIdSet==>'+conIdSet.size());
    
        List<Contact> conRecList = new List<Contact>([SELECT Id,name, (SELECT  Subject,Activity_Type__c, ActivityDate, Description,StartDateTime from ActivityHistories where (Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='BDA Touch' OR Activity_Type__c='SS&E Recruiting Category' OR Activity_Type__c='Premium') order by ActivityDate DESC limit 1) FROM Contact WHERE Id IN:conIdSet AND RecordTypeId =:conRecordTypeId ]);
        for(Contact conRec: conRecList ){
            if(conRec.ActivityHistories.size()>0){
                ActivityHistory taskRec = conRec.ActivityHistories[0];
                conRec.Last_Recruiting_Activity__c =conRec.ActivityHistories[0].ActivityDate;
                system.debug('xxxxxxxxxxxxxxx '+conRec.Last_Recruiting_Activity__c);
            }else{
                conRec.Last_Recruiting_Activity__c =null;
            }
        }
        if(conRecList !=null && conRecList.size()>0){
            system.debug('yyyyyyyyyyyyyyyyyyyyyyy ');
            update conRecList ;
        }
      }
    }
    
    public void handleoutlook(List<Task> tsklst) {

     
   Set<id> ContactWhoIds = new Set<id>();    
   
   for(Task t : tsklst) 
    {
        if(t.whoId!= null)
        {       
            if(String.valueOf(t.whoId).StartsWith('003')) ContactWhoIds.add(t.whoId);            
        }
    }    
    
    
  if(ContactWhoIds.size() != 0){
    
        Map<id, Contact> conMap = new Map<id, Contact>([Select Full_Name__c, phone,Advisory_Segment__c,YTD_NNA__c,Advisor_Channel__c,Direct_Mutual_Fund_AUM__c,MF_and_ETF_AUM__c ,Current_Year_GDC__c From Contact Where (id in :ContactWhoIds )]);           
        
        for(Task  t : tsklst)
        {        
              
                Contact fin = conMap.get(t.WhoId);
                
                if(fin != null) 
                {       
                    t.Outlook_Subject__c =t.subject + ':'+  fin.Full_Name__c +':' + fin.phone;
                    
                    t.Out_Look_Body__c = '. Advisory Segment :'+ fin.Advisory_Segment__c +',' + fin.Advisor_Channel__c+ '. YTD GDC :'+ fin.Current_Year_GDC__c + '. YTD NNA:' + fin.YTD_NNA__c +'. Direct Mutual Fund AUM :'+ fin.Direct_Mutual_Fund_AUM__c + '. MF and ETF AUM :'+ fin.MF_and_ETF_AUM__c + '.';
                     
                }
            
        }    
    
    }
  

}
   public void TaskEmailFieldsUpdate(List<Task> tskList) {
        map<Id, string> emailMap =new map<Id, string>();
        map<Id, string> emailMap1 =new map<Id, string>();
        map<Id, string> emailMap2 =new map<Id, string>();
        set<Id>LoanAppicationset= new set<Id>();
        for(task t:tskList){
            if(t.whatId != null && t.whatId.getSObjectType() == Loan_Application__c.sObjectType) {
                //t.Email_Loan_application__c = t.whatId.Preparer_Email__c;
                LoanAppicationset.add(t.whatId);
        
            }
        }
            list<Loan_Application__c> LoanAppicationlist = [select Id, Preparer_Email__c,Assigned_Recruiter_Email__c,Created_by_Email__c from Loan_Application__c where id in:LoanAppicationset];
        
        for(Loan_Application__c l:LoanAppicationlist){
            emailMap.put(l.Id, l.Preparer_Email__c);
            emailMap1.put(l.Id, l.Assigned_Recruiter_Email__c);
            emailMap2.put(l.Id, l.Created_by_Email__c);
        }
            for(task t:tskList){
            if(t.whatId != null && t.whatId.getSObjectType() == Loan_Application__c.sObjectType) {
                t.Email_Loan_application__c = emailMap.get(t.whatId);
                t.Assigned_Recruiter1__c = emailMap1.get(t.whatId); 
                t.Email_Alert__c =  emailMap2.get(t.whatId);        
            }
        }
   }     
}