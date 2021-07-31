/*
#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
CH-01            To update Enterprise Last FOV, Last VOV,Last HOV from   Manila Agnihotri                    4/17/20178
latest event date depending on event or activity type
Ch-02            If Department is Business Developement then restrict delete and 
Edit  permission on task and Event for other Role            Ashish Gupta                   4/27/2018
CH-03            Added condition to include BDA/BD-A Role                       Garvita Rai                    25 January 2019
Ch-04    REQ0038890 - RITM0043840 - TASK0066033 - 
Last Recruiting Activity Field :                                                Ashish Gupta                  05-March-2019
This #WO is populating recent date of Activity on Contact  

CH-05         Allowed System Administrator to edit/delete Events                Garvita Rai                    22-March-2019   
CH-06		 Added one more "SS&E Recruiting Category" Activity type value      Ashish Gupta                  04-April-2019
			 filter  condition in Last Recruiting Activity logic
*/

public without sharing class LPL_EventTriggerGateway{
    
    Set<id> ContactWhoIds = new Set<id>();  
    Map<id, Contact> conMap = new Map<id, Contact>(); 
    Set<id> AccountWhoIds = new Set<id>(); 
    List<Account> Acc = new List<Account>();
    List<account> Accupdate = new List<Account>();
    List<Account> accountListToUpdate=new List<Account>();
    List<Event> EveList = new List<Event>();
    ID ISINS = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId();
    ID ISREP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Relationship').getRecordTypeId();
    Set<ID> assignIDList=new Set<Id>();
    
    List<EventRelation> allEventsOfContacts = new List<EventRelation>();
    Map<Id,Contact> contactIDMap=new Map<ID,Contact>();
    Set<ID> eventSet=new Set<ID>();
    Set<Id> eventOldSet = new Set<Id>();
    ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();  //CH-10
    
    public static Set<String> conIdSet = new Set<String>();
    
    public void collectRecordToProcess(List<Event> eventList,List<Event> oldeventList,Boolean isBefore){
        if(!trigger.isDelete){
            for(Event evt : eventList ){
                if(evt.whoId!= null) {    
                    if(String.valueOf(evt.whoId).StartsWith('003')){
                        ContactWhoIds.add(evt.whoId); 
                    }
                    //Ch-04 starts
                    if(String.valueOf(evt.whoId).StartsWith('003') && (evt.Activity_Type__c=='IRD Touch' || evt.Activity_Type__c=='Recruiting' || 				//CH-06  starts
                                                                       evt.Activity_Type__c=='Master Recruiting' || evt.Activity_Type__c=='BDA Touch' || evt.Activity_Type__c=='SS&E Recruiting Category' )){
                                                                           eventSet.add(evt.ID);                                                         //CH-06  End
                                                                       }
                    //Ch-04 ends
                }
            }
            //Ch-04 starts
            if(eventSet.size()>0){
                for(EventRelation eventRelationRec :[Select ID, RelationId,EventId,LastModifiedDate from EventRelation where EventId in: eventSet]){
                    if(eventRelationRec.RelationId != null){
                        conIdSet.add(eventRelationRec.RelationId);
                    }
                }
            }
            //Ch-04 ends
            
            if(ContactWhoIds.size() != 0){
                conMap = new Map<id, Contact>([Select Full_Name__c, phone,Advisory_Segment__c,Advisor_Channel__c,Direct_Mutual_Fund_AUM__c,
                                               MailingStreet,YTD_NNA__c, 
                                               MailingCity,MailingPostalCode,MailingState,MF_and_ETF_AUM__c ,Current_Year_GDC__c 
                                               From Contact Where (id in :ContactWhoIds )]);                   
            }
        }
        //Ch-04 starts 
        if(oldeventList != null){
            for(Event oldEve : oldeventList){
                if(oldEve.whoId!=null){
                    if(String.valueOf(oldEve.whoId).StartsWith('003') && (oldEve.Activity_Type__c=='IRD Touch' ||
                                                                          oldEve.Activity_Type__c=='Recruiting' || 
                                                                          oldEve.Activity_Type__c=='Master Recruiting' ||
                                                                          oldEve.Activity_Type__c=='BDA Touch'  ||
                                                                          oldEve.Activity_Type__c=='SS&E Recruiting Category' //CH-06  
                                                                         )){
                                                                              eventOldSet.add(oldEve.id);
                                                                          }
                }
            }
        }
        
        if(eventOldSet.size()>0 && isBefore){
            for(EventRelation evtRelationRec :[Select ID, RelationId,EventId,LastModifiedDate from EventRelation where EventId in: eventOldSet]){
                if(evtRelationRec.RelationId != null){
                    conIdSet.add(evtRelationRec.RelationId);
                }
            }
        }
        //Ch-04 ends
        List<PermissionSetAssignment> PermissionSetAssignmentList=[SELECT Id, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment where  PermissionSet.Name='Edit_Business_development_Task_Event'];
        
        for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
            assignIDList.add(permissionObj.AssigneeId);
        }
    }
    
    //Ch-04 starts //CH-06 starts
    public void updateLastRecruitingActivity(){
        List<Contact> conRecList = new List<Contact>([SELECT Id,name, (SELECT  Subject,Activity_Type__c, ActivityDate, Description,StartDateTime from ActivityHistories where (Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='BDA Touch' OR Activity_Type__c='SS&E Recruiting Category') order by ActivityDate DESC limit 1) FROM Contact WHERE Id IN:conIdSet AND RecordTypeId =:conRecordTypeId ]);
        //CH-06 End
        for(Contact conRec: conRecList ){
            if(conRec.ActivityHistories.size()>0){
                ActivityHistory taskRec = conRec.ActivityHistories[0];
                conRec.Last_Recruiting_Activity__c =conRec.ActivityHistories[0].ActivityDate;
            }else{
                conRec.Last_Recruiting_Activity__c =null;
            }
        }
        if(conRecList!=null && conRecList.size()>0){
            update conRecList ;
        }
    }
    //Ch-04 ends
    
    public void doEventInsUpdOperation( Event newEvnt){
        if(conMap.size() != 0 && conMap != null){
            Contact fin = conMap.get(newEvnt.WhoId);
            if(fin != null) {       
                newEvnt.Outlook_Subject__c = newEvnt.subject + ': '+  fin.Full_Name__c +':' + fin.phone;
                
                newEvnt.Outlook_Location__c= newEvnt.Location + ','+ fin.MailingStreet + ',' + fin.MailingCity + ',' + fin.MailingState + ',' + fin.MailingPostalCode ;
                
                newEvnt.Out_Look_Body__c = '. Advisory Segment :'+ fin.Advisory_Segment__c +',' + fin.Advisor_Channel__c+ '. YTD GDC :'
                    + fin.Current_Year_GDC__c + '. YTD NNA:' + fin.YTD_NNA__c
                    +'. Direct Mutual Fund AUM :'+ fin.Direct_Mutual_Fund_AUM__c + '. MF and ETF AUM :'
                    + fin.MF_and_ETF_AUM__c + '.';
            }
        }
    }
    /*CH-01  -start*/
    public List<Account> doAccountInsUpdOperation(Event newEvnt){
        if(newEvnt.WhatId!= null){
            if(String.valueOf(newEvnt.WhatId).StartsWith('001')){
                AccountWhoIds.add(newEvnt.WhatId);            
            }
        } 
        for(Account a :[select id,Last_HOV__c,Last_FOV__c,  Last_VOV__c from Account where ((RecordTypeId =: ISINS OR RecordTypeId =: ISREP) AND  id in:AccountWhoIds)])
        {
            if(newEvnt.Event_Type__c=='Field Office Visit' || (newEvnt.Activity_Type__c!=null && newEvnt.Activity_Type__c=='Field Office Visit')){
                a.Last_FOV__c = newEvnt.StartDateTime.date();
            }
            else if(newEvnt.Event_Type__c =='Home Office Visit' || (newEvnt.Activity_Type__c!=null && newEvnt.Activity_Type__c=='Home Office Visit')){
                a.Last_HOV__c= newEvnt.StartDateTime.date();
            }
            else if(newEvnt.Event_Type__c=='Virtual Office Visit' || (newEvnt.Activity_Type__c!=null && newEvnt.Activity_Type__c== 'Virtual Office Visit')){
                a.Last_VOV__c =newEvnt.StartDateTime.date();
            }
            else {
                //do nothing
            }
            if(!Accupdate.contains(a))
                Accupdate.add(a);
        }
        return Accupdate;
    }
    /*CH-01  -end*/
    
    //CH-02 Start
    public  void deleteAndEditRecordByRole( Event newEvent){
        Id userId = userinfo.getUserId();
        try{
            User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
            if(newEvent.Department__c!=null && newEvent.Department__c=='Business Development' &&(userDetails.UserRole.Name=='IRD'|| userDetails.UserRole.Name=='IRD Managment'|| userDetails.UserRole.Name=='Masters Recruiter_v2'||userDetails.UserRole.Name=='Regional VP'|| userDetails.UserRole.Name=='Recruiters'|| assignIDList.contains(userId)  || userDetails.UserRole.Name=='BDA' || userDetails.UserRole.Name=='BD-A' || userDetails.Profile.Name =='System Administrator' || userId == newEvent.CreatedById)){ // CH-03 Added condition to include BDA/BD-A Role, CH-05
            }
            else if(newEvent.Department__c!=null && newEvent.Department__c=='Business Development'){ 
                newEvent.addError('Insufficient privileges, Please contact System Administrator.');
            }
        }
        catch(exception e){
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_EventTriggerGateway','deleteAndEditRecordByRole',e.getMessage(),e.getLineNumber(),e.getTypeName());     
        }
    }
    //CH-02 End
}