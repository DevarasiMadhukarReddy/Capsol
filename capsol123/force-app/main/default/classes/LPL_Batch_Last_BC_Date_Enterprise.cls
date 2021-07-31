/*Batch class Name               : LPL_Batch_Last_BC_Date_Enterprise 
Description                      : This batch class is Updating Last_BC_Client_Contact__c field of Account based on task and Event,
those event assigned to User of the LPL IS User Profile 
Created By                       : Ajay Koppineedi 
Created Date                     :   5/5/2018
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
CH-01  Added filter of User of the LPL IS User Profile                Ashish Gupta                       21 june 2018  
*/

global class LPL_Batch_Last_BC_Date_Enterprise implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Id accRT1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Relationship').getRecordTypeId();
        Id accRT2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId();
        
        //Getting qualified contacts if they is available
        
        String query='Select ID, Name, RecordTypeId, Last_BC_Client_Contact__c from Account where (RecordTypeId =: accRT1  OR RecordTypeId =: accRT2)' ;
        
        return database.getQueryLocator(query);  
        
        
    }
    global void execute(Database.BatchableContext BC,List<Account> accUpdateList) {
        try{
            
            Set<Id> accIds = new Set<Id>();
            List<Account> allActivities = new List<Account>();
            Map<Id, DateTime> taskAcc = new Map<Id, DateTime>();
            Map<Id, DateTime> eventAcc = new Map<Id, DateTime>();
            List<Account> accList = new List<Account>();
            List<Contact> allActivitiesOfContacts = new List<Contact>();
            Map<Id, DateTime> taskCon = new Map<Id, DateTime>();
            Map<Id, DateTime> eventCon = new Map<Id, DateTime>();
            Map<Id, List<contact>> ConMap= new  Map<Id, List<contact>>();
            Map<Id,List<Event>> EveMap= new  Map<Id,List<Event>>();
            Map<Id,List<Task>> taskMap= new  Map<Id,List<Task>>();
            Map<ID,datetime> startDateTime = new  Map<ID,datetime>();
            Map<ID,datetime> createdDateTime = new  Map<ID,datetime>();
        
            Id evntRT = Schema.SObjectType.Event.getRecordTypeInfosByName().get('IS Profile').getRecordTypeId();
            
            for(Account acc: accUpdateList){
                
                accIds.add(acc.Id);
            }
            
            Set<ID> setUserID=new Set<ID>();
           List<User> listuserID = [SELECT id, Profile.Name FROM User where Profile.Name='LPL IS User'];
            if(listuserID.size()>0){
            for(User u:listuserID){
               setUserID.add(u.id);
                
                
            }}
        // CH-01 Start    
            //Fetching related Contact, Task and Event records of the Accounts
            allActivities = [Select ID, Last_BC_Client_Contact__c, (Select Id, AccountId from Contacts), (Select Id, WhoId, CreatedDate,OwnerID from Tasks where OwnerID IN : SetuserID ORDER BY CreatedDate DESC limit 1), (Select Id, WhoId, StartDateTime from Events where OwnerID IN : SetuserID And RecordTypeId =: evntRT ORDER BY StartDateTime DESC limit 1) from Account where Id in: accIds ];
            
            //Fetching related Task and Event records of the Contacts related to the Accounts
            allActivitiesOfContacts = [Select ID, AccountId, (Select Id, CreatedDate, WhoId,OwnerID from Tasks where OwnerID IN : SetuserID  ORDER BY CreatedDate DESC limit 1), (Select Id, WhoId, StartDateTime from Events where OwnerID IN : SetuserID AND RecordTypeId =: evntRT ORDER BY StartDateTime DESC limit 1) from Contact where AccountId in: accIds ];
       //CH-01 END    
            //Taking the most recent Start Date of the Event of Accounts
                for(Account searchEvent: allActivities){
                
                if(searchEvent.Events.size()>0){
                    
                    eventAcc.put(searchEvent.Id, searchEvent.Events[0].StartDateTime);
                }
            }
            
            //Taking the most recent Created Date of the Task of Accounts
            
            for(Account searchTask: allActivities){
                
                if(searchTask.Tasks.size() > 0){
                    
                    taskAcc.put(searchTask.Id, searchTask.Tasks[0].CreatedDate); 
                }
            }
            
            //Taking the most recent Start Date of the Event of Contacts
        if(allActivitiesOfContacts.size()>0)  {
            system.debug('allActivitiesOfContacts.size()>>'+allActivitiesOfContacts.size());
            for(Contact con1 : allActivitiesOfContacts){
                if(con1.Events.size()>0){
                    
                    system.debug('con1.Events.size()>>'+con1.Events.size());
                for(Event Eve : con1.Events)
                {
                    if(EveMap.containskey(eve.WhoId))
                    {
                        EveMap.get(eve.Whoid).add(eve);
                    }
                    else
                        EveMap.put(eve.Whoid,new List<Event>{Eve}); // contact id and events map
                    
                    system.debug('EveMap>>'+EveMap);
                }
            }
            }
        }
        if(allActivities.size()>0){  
            for(Account acc1 : allActivities ){
                if(acc1.Contacts.size()>0){
                for(Contact C: acc1.Contacts)
                {
                    if(ConMap.containskey(c.accountid))
                    {
                        ConMap.get(c.accountid).add(C);
                    }
                    else
                        ConMap.put(c.accountid,new List<Contact>{C});
                    
                    system.debug('ConMap>>'+ConMap);
                    
                }
            }
            }
        }

        
            for(Account a: accUpdateList)
            {
                
                Contact Latestcon = new Contact();
                Datetime e;
                if(ConMap.get(a.id)!=null){
                 for(Contact con : ConMap.get(a.id))
                 {
                     system.debug('con>>'+con);
                     system.debug('EveMap>> '+EveMap);
                     
                     if(EveMap.get(con.id)!=null){
                         
                     for(Event Eve1 : EveMap.get(con.id))
                     {
                        
                         
                         if(e == null)
                        {
                            e =Eve1.StartDateTime;
                        }
                        else if(eve1.startDateTime > e)
                        {
                            system.debug('>>>> '+ e);
                            e=eve1.startDateTime;
                            
                        }
                    }
                 }
                 }
                }
                system.debug('Latestevent.startDateTime>>'+e);
                startDateTime.put(a.id,e) ;
                system.debug('startDateTime'+startDateTime);
            }
        
            //Taking the most recent Created Date of the Task of Contacts
          if(allActivitiesOfContacts.size()>0)  {  
            for(Contact con2 : allActivitiesOfContacts){
                if(con2.Tasks.size()>0){
                    system.debug('con2.Tasks.size()>>'+con2.Tasks.size());
                for(Task tsk : con2.Tasks)
                {
                    if(taskMap.containskey(tsk.WhoId))
                    {
                        taskMap.get(tsk.Whoid).add(tsk);
                    }
                    else
                        taskMap.put(tsk.Whoid,new List<Task>{tsk}); // contact id and tasks map
                }
            }
            }
          }
        
          
            for(Account a: accUpdateList)
            {
                Task Latesttask = new Task();
                Contact Latestcon = new Contact();
                Datetime t;
                
                if(ConMap.get(a.id)!=null){
                 for(Contact con : ConMap.get(a.id))
                 {
                     if(taskMap.get(con.id)!=null){
                     for(Task tsk1 : taskMap.get(con.id))
                     {
                         
                         if(t == null)
                        {
                            t =tsk1.CreatedDate;
                        }
                        else if(tsk1.CreatedDate > t)
                        {
                            system.debug('>>>> '+ t);
                            t=tsk1.CreatedDate;
                            
                        }
                      
                     }}
                 }
                }
                createdDateTime.put(a.id,t) ;
            }
            
            for(Account a: accUpdateList)
            {
                
                datetime Acclatetsdate;
                datetime Contactlatestdate;
                
                //Comparing and adding the most recent Start Date of Event and Created Date of Task from Account
                if(eventAcc.get(a.Id)!=null && taskAcc.get(a.Id)!=null)
                {
                if(eventAcc.get(a.Id) > taskAcc.get(a.Id))
                   {
                   Acclatetsdate = eventAcc.get(a.Id);
                    }
                else if (eventAcc.get(a.Id) < taskAcc.get(a.Id)){
                 Acclatetsdate = taskAcc.get(a.Id);
                }
                }
                else if(eventAcc.get(a.Id)!=null && taskAcc.get(a.Id)==null)
                {
                     Acclatetsdate=eventAcc.get(a.Id);
                }
                 else if(eventAcc.get(a.Id)==null && taskAcc.get(a.Id)!=null)
                {
                     Acclatetsdate = taskAcc.get(a.Id);
                }
                else
                {
                  Acclatetsdate = null;  
                }
                
            //Comparing and adding the most recent Start Date of Event and Created Date of Task from Contact
                
            if(startdatetime.get(a.Id)!=null && createdDateTime.get(a.Id)!=null){  
                if(startdatetime.get(a.Id) > createdDateTime.get(a.Id))
                {
                Contactlatestdate = startdatetime.get(a.Id);
                }
                else if(startdatetime.get(a.Id) < createdDateTime.get(a.Id)){
                Contactlatestdate = createdDateTime.get(a.Id);
                }
                    }
                    else if(startdatetime.get(a.Id)!=null && createdDateTime.get(a.Id)==null)
                {
                   Contactlatestdate = startdatetime.get(a.Id); 
                }
                   else if(startdatetime.get(a.Id)==null && createdDateTime.get(a.Id)!=null)
                {
                  Contactlatestdate = createdDateTime.get(a.Id);
                }
                else
                {
                     Contactlatestdate=null;
                }
                
                system.debug('eventStartDate>>'+Contactlatestdate);
                system.debug('taskCreateDate>>'+Acclatetsdate);
                
                //Comparing and adding the most recent Start Date of Event and Created Date of Task from both Account and Contact
                If(Acclatetsdate!=null && Contactlatestdate!=null)
                {
                    if(Acclatetsdate > Contactlatestdate)
                    {
                        a.Last_BC_Client_Contact__c = Date.valueOf(Acclatetsdate);
                    }
                    else if(Acclatetsdate < Contactlatestdate){
                        a.Last_BC_Client_Contact__c = Date.valueOf(Contactlatestdate);
                    }
                    else if(Acclatetsdate == Contactlatestdate){
                        a.Last_BC_Client_Contact__c = Date.valueOf(Contactlatestdate);
                    }
                }
                else if(Acclatetsdate == null && Contactlatestdate!= null){
                    a.Last_BC_Client_Contact__c = Date.valueOf(Contactlatestdate);
                }
                else if (Acclatetsdate != null && Contactlatestdate== null){
                    a.Last_BC_Client_Contact__c = Date.valueOf(Acclatetsdate);
                }
                else if(Acclatetsdate == null && Contactlatestdate== null){
                    a.Last_BC_Client_Contact__c = null;
                } 
                accList.add(a);
            }
            update accList; 
            
        }
        
        
        catch(exception e) {
            
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_Last_BC_Date_Enterprise ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        } 
        
    }
    global void finish(Database.BatchableContext BC){
    }
}