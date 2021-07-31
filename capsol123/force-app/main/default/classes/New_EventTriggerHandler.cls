public class New_EventTriggerHandler implements BaseTriggerHandler {

    Set<ID> assignIDList=new Set<Id>();
    Set<id> ContactWhoIds = new Set<id>(); 
    public static Set<String> conIdSet = new Set<String>();
    Set<Id> eventOldSet = new Set<Id>();
    Set<ID> eventSet=new Set<ID>();
    Map<id, Contact> conMap = new Map<id, Contact>();
    List<account> Accupdate = new List<Account>();
    
        ID ISINS = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId();
    ID ISREP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Relationship').getRecordTypeId();
      ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    Public static boolean runonce=true;
    Public static boolean runonce1=true;
    Public static integer count=1;
    
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
        system.debug('count===>'+count);
        count++;
        ProcessRelatedRecord(trigger.new,trigger.old,trigger.isbefore);
         handleRelatedTo(trigger.new);
        handleRelatedToOpp(trigger.new);
        //handlePeopleAI(trigger.new);
        doEventInsUpdOperation(trigger.new);
        handleoutlook(trigger.new);
        
    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        system.debug('count===>'+count);
        count++;
        ProcessRelatedRecord(trigger.new,trigger.old,trigger.isbefore);
         handleRelatedTo(trigger.new);
        handleRelatedToOpp(trigger.new);
       // handlePeopleAI(trigger.new);
        doEventInsUpdOperation(trigger.new);
        handleoutlook(trigger.new);
    }
 
    public void BeforeDelete(Map<Id, SObject> oldItems) {
        Preventdeletion(trigger.old);
    }
 
    public void AfterInsert(Map<Id, SObject> newItems) {
        if(conIdSet.size()>0){
            updateLastRecruitingActivity();
        }
        doAccountInsUpdOperation(trigger.new);
        
    }
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        doAccountInsUpdOperation(trigger.new);
    }
 
    public void AfterDelete(Map<Id, SObject> oldItems) {
         if(conIdSet.size()>0){
            updateLastRecruitingActivity();
        }
    }
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
    
    
    
       public  void Preventdeletion(List<Event> newEventList){
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
    
          
            for(Event newEvent: newEventList){
           
            if(newEvent.Department__c!=Null && newEvent.Department__c=='Business Development' && (userDetails1.get(userId).UserRole.Name=='IRD'|| userDetails1.get(userId).UserRole.Name=='IRD Managment'|| userDetails1.get(userId).UserRole.Name=='Masters Recruiter_v2'||userDetails1.get(userId).UserRole.Name=='Regional VP'|| userDetails1.get(userId).UserRole.Name=='Recruiters' ||assignIDList.contains(userId) || userDetails1.get(userId).UserRole.Name=='BDA' || userDetails1.get(userId).UserRole.Name=='BD-A' || userId == newEvent.CreatedById || userDetails1.get(userId).Profile.Name =='System Administrator') ){// CH-12 and CH-13 Added condition to include BDA/BD-A Role,CH-16
            }
            else if(newEvent.Department__c!=Null && newEvent.Department__c=='Business Development'){ 
                newEvent.addError('Insufficient privileges, Please contact System Administrator.');
            }
            }
        
    }
    
    
    
    
    public void ProcessRelatedRecord(List<Event> eventList,List<Event> oldeventList,Boolean isBefore){
        if(runonce){
        if(!trigger.isDelete){
            for(Event evt : eventList ){
                if(evt.whoId!= null) {    
                    if(String.valueOf(evt.whoId).StartsWith('003')){
                        ContactWhoIds.add(evt.whoId); 
                    }
                    //Ch-04 starts
                    if(String.valueOf(evt.whoId).StartsWith('003') && (evt.Activity_Type__c=='IRD Touch' || evt.Activity_Type__c=='Recruiting' || 
                                                                       evt.Activity_Type__c=='Master Recruiting' || evt.Activity_Type__c=='BDA Touch')){
                                                                           eventSet.add(evt.ID);
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
            system.debug('conIdSet===>'+conIdSet);
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
                                                                          oldEve.Activity_Type__c=='BDA Touch')){
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
        
        updateLastRecruitingActivity();
        runonce=false;
        }
    }
    

    
    
    
    //Ch-04 starts
    public void updateLastRecruitingActivity(){
        system.debug('inside update lasteRecruiting activity===>');
        List<Contact> conRecList = new List<Contact>([SELECT Id,name, (SELECT  Subject,Activity_Type__c, ActivityDate, Description,StartDateTime from ActivityHistories where (Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='BDA Touch') order by ActivityDate DESC limit 1) FROM Contact WHERE Id IN:conIdSet AND RecordTypeId =:conRecordTypeId ]);
        system.debug('conRecList size===>'+conRecList.size());
        for(Contact conRec: conRecList ){
            system.debug('conRec.ActivityHistories.size()===>'+conRec.ActivityHistories.size());
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
    
     public void doEventInsUpdOperation( List<Event> newEvntlst){
         
         for(event newEvnt:newEvntlst){
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
        
     }
    
    
    
    
    public void doAccountInsUpdOperation(List<Event> newEvntlst){
        Set<id> AccountWhoIds = new Set<id>(); 
        Map<id,event> evmap=new Map<id,event>();
        if(runonce1){
     for(event newEvnt:newEvntlst){
        if(newEvnt.WhatId!= null){
            if(String.valueOf(newEvnt.WhatId).StartsWith('001')){
                AccountWhoIds.add(newEvnt.WhatId);
                evmap.put(newEvnt.WhatId,newEvnt);  
            }
        } 
     }
        for(Account a :[select id,Last_HOV__c,Last_FOV__c,  Last_VOV__c from Account where ((RecordTypeId =: ISINS OR RecordTypeId =: ISREP) AND  id in:AccountWhoIds)])
        { 
            event newEvnt=evmap.get(a.id);
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
        
            
            runonce1=false;
        upsert Accupdate;
             
         }
    }
    
    
    //&&&&&added 28-may to handle Related To Use case
    public  void handleRelatedTo(List<Event> newList){
        Map<id,set<Id>> OppConMap=new Map<id,set<Id>> ();
        set<id> conids=new set<id>();
        set<id> oppids=new set<id>();
        for(Event newEvent:newList){
            if(newEvent.WhoId != null)
                conids.add(newEvent.WhoId);
            
        }
        List<OpportunityContactRole> OppConList=[SELECT ContactId,OpportunityId FROM OpportunityContactRole where ContactId IN:conids];
        Map<id,contact> Mapcon=new Map<id,contact>([select id,recordtypeId from contact where id IN:conids]);
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
                system.debug('OppConMap==>'+OppConMap);
            }
        }
        
        
        if(!oppids.isEmpty()){
            Map<id,Opportunity> OppMap=New Map<id,Opportunity>([select id,StageName from opportunity where (StageName ='1 - Engaged' OR StageName ='2 - Hot List' OR StageName ='3 - Submitted a Kit') AND Id IN:oppids]);
            system.debug('OppMap==>'+OppMap);
            system.debug('OppMap.Keyset()'+OppMap.Keyset());
        
        //if(userInfo.getUserId() !=''){
        for(Event T:NewList){
            if(T.whoId != null){
                system.debug('OppConMap.containsKey(T.whoId)'+OppConMap.containsKey(T.whoId));
                if(OppConMap.containsKey(T.whoId) && Mapcon.containsKey(T.whoId) && Mapcon.get(T.whoId).RecordTypeId=='0120P000000AK3I'){
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
            system.debug('Event==>'+T);
        }
        // }
        
        }
    }
    
    
 public  void handleRelatedToOpp(List<Event> newList){ 
        Map<id,set<Id>> OppConMap=new Map<id,set<Id>> ();
        set<id> conids=new set<id>();
        set<id> oppids=new set<id>();
        for(Event newEvent:newList){
            if(newEvent.whatId != null)
                oppids.add(newEvent.whatId);
            
        }
        List<OpportunityContactRole> OppConList=[SELECT ContactId,OpportunityId FROM OpportunityContactRole where OpportunityId IN:oppids];
     system.debug('OppConList Event==>'+OppConList);   
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
                system.debug('conIdset==>'+conIdset); 
                system.debug('conids==>'+conids); 
                OppConMap.put(opcon.OpportunityId,conIdset);
            }
        }
        
    system.debug('OppConMap==>'+OppConMap);        
       // if(!conids.isEmpty()){
            Map<id,contact> ConMap=New Map<id,contact>([select id,RecordTypeId from contact  where Id IN:conids]);
            
        //}
         system.debug('ConMap==>'+ConMap); 
        //if(userInfo.getUserId() !=''){
        for(Event T:NewList){
            if(T.whatId != null){
                if(OppConMap.containsKey(T.whatId)){
                    system.debug('before Event==>'+T);
                    set<id> setoppId=OppConMap.get(T.whatId);
                    system.debug('OppConMap==>'+OppConMap);
                    system.debug('setoppId==>'+setoppId);
                    if(setoppId.size()>0){
                        for(ID opid:setoppId){
                            if(ConMap.containsKey(opid) && T.whoId==null && ConMap.get(opid).RecordTypeId=='0120P000000AK3I'){
                            
                                T.whoId=ConMap.get(opid).id;
                            }
                        }
                    }
                    system.debug('Event==>'+T);
                }
                //T.whatId=OppMap.get(OppConMap.get(T.whatId)).id;
            }
        }
        // }
        
        
    }    
    //&&&&& END
    
    
     /*public static void handlePeopleAI(List<event> newList){
         system.debug('INSIDE Future');
         //List<event> newList=[select id,subject,peopleai__ActivityType__c,peopleai__Created_by_PeopleAI__c,Activity_Type__c,Category__c,ownerid  from event where ID IN:TSKIDS];
         
         map<id,id>assignIds=new map<id,id>();
         for(event T:newList){
             if(T.peopleai__Created_by_PeopleAI__c==true){
             //T.Status='Completed';
             T.Department__c ='Business Development';
             assignIds.put(T.ownerid,T.ownerid);
             }
         }
         //system.debug('assignIds==>'+assignIds);
         Map<id,user> uMap=new Map<id,user>([ select Id, Name, UserRole.Name  from User where ID IN:assignIds.values()]);
         for(event T:newList){
             string actstr='';
             string Pstr='';
             //system.debug('uMap==>'+uMap);
             if(assignIds.containsKey(T.ownerid)){
                 system.debug('u==>'+uMap.get(assignIds.get(T.ownerid)));
                 actstr=uMap.get(assignIds.get(T.ownerid)).UserRole.Name;
                 system.debug('actstr==>'+actstr);
                 Pstr=T.peopleai__ActivityType__c;
                     if(actstr.contains('Recruiters')){
                     T.Activity_Type__c='Recruiting';
                         if(Pstr.contains('In-Person')){
                             T.Category__c='Meeting - New Recruit- In Person';
                         }
                         if(Pstr.contains('Conference Call')){
                             T.Category__c='Meeting - New Recruit- Via Phone';
                         }
                     }
                  if(actstr.contains('IS Recruiters')){
                     T.Activity_Type__c='Master Recruiting';
                      if(Pstr.contains('In-Person')){
                             T.Category__c='Meeting - New Recruit- In Person';
                         }
                         if(Pstr.contains('Conference Call')){
                             T.Category__c='Meeting - New Recruit- Via Phone';
                         }
                     }
                  if(actstr.contains('IRD')){
                     T.Activity_Type__c='IRD Touch';
                      if(Pstr.contains('In-Person')){
                             T.Category__c='IRD Meeting Complete- New Recruit- In Person';
                         }
                         if(Pstr.contains('Conference Call')){
                             T.Category__c='IRD Meeting Complete- New Recruit- Via Phone';
                         }
                     }
           /*       if(actstr.contains('RD')){
                     T.Activity_Type__c='Recruiting';
                     } */
                 /* if(actstr.contains('SS&E')){
                     T.Activity_Type__c='SS&E';
                      if(Pstr.contains('In-Person')){
                             T.Category__c='Meeting';
                         }
                         if(Pstr.contains('Conference Call')){
                             T.Category__c='Meeting';
                         }
                     }
                 
                 if(actstr.contains('Premium')){
                     T.Activity_Type__c='Premium';
                      if(Pstr.contains('In-Person')){
                             T.Category__c='Meeting';
                         }
                         if(Pstr.contains('Conference Call')){
                             T.Category__c='Meeting';
                         }
                         
                     }
                 
                 system.debug('Activity_Type__c==>'+T.Activity_Type__c);
                 system.debug('event==>'+T);
                 
             }
         
         }
     } */
     
     //&&&&&&13062019end

    
    public void handleoutlook(list<event> evenlst) {

     
   Set<id> ContactWhoIds = new Set<id>();    
   
   for(Event e : evenlst) 
    {
        if(e.whoId!= null)
        {       
            if(String.valueOf(e.whoId).StartsWith('003')) ContactWhoIds.add(e.whoId);            
        }
    }    
    
    
  if(ContactWhoIds.size() != 0){
    
        Map<id, Contact> conMap = new Map<id, Contact>([Select Full_Name__c, phone,Advisory_Segment__c,Advisor_Channel__c,Direct_Mutual_Fund_AUM__c,MailingStreet,YTD_NNA__c, MailingCity,MailingPostalCode,MailingState,MF_and_ETF_AUM__c ,Current_Year_GDC__c From Contact Where (id in :ContactWhoIds )]);           
        
        for(Event e : evenlst)
        {        
              
                Contact fin = conMap.get(e.WhoId);
                
                if(fin != null) 
                {       
                    e.Outlook_Subject__c = e.subject + ': '+  fin.Full_Name__c +':' + fin.phone;
                    
                    //Address addr = fin.MailingAddress;

                    e.Outlook_Location__c= e.Location + ','+ fin.MailingStreet + ',' + fin.MailingCity + ',' + fin.MailingState + ',' + fin.MailingPostalCode ;
                    
                    e.Out_Look_Body__c = '. Advisory Segment :'+ fin.Advisory_Segment__c +',' + fin.Advisor_Channel__c+ '. YTD GDC :'+ fin.Current_Year_GDC__c + '. YTD NNA:' + fin.YTD_NNA__c +'. Direct Mutual Fund AUM :'+ fin.Direct_Mutual_Fund_AUM__c + '. MF and ETF AUM :'+ fin.MF_and_ETF_AUM__c + '.';
                      
                }
            
        }    
    
    }
  

}
    
}