/*
#############################Change History####################
CH#              Description                                                      Developer Name             Date
----------------------------------------------------------------------------------------------------------------------
Ch-1    Batch created to update task on opportunity -SD901712 - Create Task      Manila Agnihotri           17th May 2018
*/

global class LPL_Opportunity_task_batch implements Database.Batchable<sObject>, Database.Stateful
{   
    Integer numberofdays;
    Integer days;
    Date duedate;
    Date todaydate =system.today();
    Set<ID> OppId = new Set<ID>();
    Set<ID> Conid = new Set<ID>();
    global list<Opportunity> Opplist = new list<Opportunity>();
    global set<Opportunity> OppSet ;
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select id,StageName,Lost_Outcome__c,Expected_AUM__c,Assigned_Recruiter__c,Stage_Change_Date__c,Internal_Recruiter_IRD__c,Contact__c from opportunity where RecordType.Name=\'IAS Business Development\' AND Records_processed__c=false';
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Opportunity> OppUpdateList) 
    {
        
        Map<Id, Date> contaskmap = new Map<Id, Date>();
        Opplist = new list<Opportunity>();
        OppSet = new set<Opportunity>();
        Conid = new Set<ID>();
        List<Task> newTaskList=new List<Task>();
        List<Task> newTaskList2=new List<Task>();
        List<Opportunity> Opplist = new List<Opportunity>();
            for(Opportunity opp: OppUpdateList){
                OppId.add(opp.id);
                Conid.add(opp.Contact__c);
            }
           // List<Contact> Conlist = ;
            for(Contact con : [Select id, (Select id,CreatedDate,ActivityDate,WhoId from Tasks ORDER BY CreatedDate DESC limit 1) from Contact where id in:Conid]) {
                if(con.Tasks.size()>0 || con.Tasks !=null){
                    for(task tsk : con.Tasks){
                     contaskmap.put(tsk.WhoId, tsk.ActivityDate);
                    }
                }
            }
            
            for(Opportunity opp: OppUpdateList)
            {
                Date stagechng = opp.Stage_Change_Date__c;
                days= stagechng.daysBetween(todaydate);
                
                if(contaskmap.containsKey(opp.Contact__c)){ 
                    if(contaskmap.get(opp.Contact__c)!=null){
                         duedate = contaskmap.get(opp.Contact__c);
                         numberofdays = duedate.daysBetween(todaydate);
                    }}
                
                if(opp.Internal_Recruiter_IRD__c!=null){
                    if((opp.StageName =='Closed-Lost') && (opp.Lost_Outcome__c =='Joined Another Firm' || opp.Lost_Outcome__c =='Stayed With Current Firm') && (opp.Expected_AUM__c >1) && (numberofdays>120)){
                        Task taskIRDuser=new Task();
                        taskIRDuser.OwnerId=opp.Internal_Recruiter_IRD__c;
                        taskIRDuser.Subject='Closed-Lost Follow Up';
                        taskIRDuser.ActivityDate=System.today();
                        taskIRDuser.Status='Not Started';
                        taskIRDuser.Priority='Normal';
                        taskIRDuser.WhatId=opp.Id;
                        taskIRDuser.WhoId=opp.Contact__c;
                        taskIRDuser.ActivityDate =system.now().date();
                        taskIRDuser.Department__c='Business Development';
                        newTaskList.add(taskIRDuser);
                        opp.Records_processed__c =true;
                        OppSet.add(opp);
                    } 
                    if((opp.StageName =='2 - Hot List') && (days > 90)){ 
                        if(opp.Assigned_Recruiter__c!=null){
                        Task taskassignuser=new Task();
                        taskassignuser.OwnerId=opp.Assigned_Recruiter__c;
                        taskassignuser.Subject='Stagnant Hot List Call';
                        taskassignuser.ActivityDate=System.today();
                        taskassignuser.Status='Not Started';
                        taskassignuser.Priority='Normal';
                        taskassignuser.WhatId=opp.Id;
                        taskassignuser.WhoId = opp.Contact__c;  
                        taskassignuser.ActivityDate =system.now().date();
                        taskassignuser.Department__c='Business Development';
                        newTaskList2.add(taskassignuser);
                        opp.Records_processed__c =true;
                        OppSet.add(opp);
                    }
                  }
                }
               
            }
            
       if(newTaskList.size()!=null && newTaskList.size()>0) {
                insert newTaskList;
            }
         if(newTaskList2.size()!=null && newTaskList2.size()>0) {
                insert newTaskList2;
            } 
         if(OppSet.size() > 0){
           Opplist.addAll(OppSet);
           database.update(Opplist, false);
        }
    }
    global void finish(Database.BatchableContext BC){
        system.debug('Inside finish'); 
      
    }
}