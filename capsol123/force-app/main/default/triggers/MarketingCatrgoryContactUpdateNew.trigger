/*Created By:Vaibhav Wadhai
Created Date:5/04/2017
Description: 

Trigger event: A certain Marketing Activity is written to Salesforce. Object names in parenthesis(), Operators in brackets{}:
1.  (Marketing Activity) Marketing Activity Name = Marketing Campaign Response
2.  (Marketing Activity) Marketing Activity Name {Contains} “BD_DisruptionEM” or “BD_DripEM”
                                        AND (Marketing Activity) Activity Type {Not Equal} “Email Sent”
What happens: Code looks for certain qualifying sales activity in order to populate the value of Marketing Categorization.
Qualifying Sales Activity
    Department = Business Development
    Activity Type = IRD Touch, Recruiting, Master Recruiting
    Category {Does Not Contain} “Social Media”, “left message”, “mailed”, “email”, “referral”, “other”

    All others considered “Qualifying”

Assign Marketing Category
If qualifying activity exists:

•   If activity date (due date) is in previous six months (before marketing activity create date) then assign “Active”
•   If activity date (due date) is not in previous six months, then assign “Inactive”
If no qualifying activity exists:
Assign “New”

*/
trigger MarketingCatrgoryContactUpdateNew on ELOQUA__Marketing_Activity__c (after insert,after update)  {
    Set<Id> conIds = new Set<Id>();
    Set<Id> ledIds = new Set<Id>();
    Map<Id, Contact> conMap = new Map<Id, Contact>();
    Map<Id, Lead> leadMap = new Map<Id, Lead>();
    List<contact> contactList=new List<contact>();
    Set<contact> contactsSet=new Set<contact>();
    Map<Id,contact> contactsMap =new Map<Id,contact>();//for contact map
    List<lead> leadList=new List<lead>();
    Map<Id,lead>  leadMapnew=new Map<id,lead>();//for lead map
    Set<Id> task_ids=new Set<Id>();
    List<task> taskListnew=new List<task>();
    List<task> taskListnew1=new List<task>();
    List<task> tasklistforlead=new List<task>();
    List<task> tasklistforlead1=new List<task>();
    set<id> task_ids_active=new set<id>();
    Set<id> task_ids_nonActive=new set<id>();
    set<id> task_ids_activeforlead=new set<id>();
    Set<id> task_ids_nonActiveforlead=new set<id>();
    
    set<id> setFutureAcvts =new set<id>();
    set<id> setFutureAcvtsforlead=new set<id>();
    
    Map<Id,datetime> MarkActivityCon=new Map<Id,datetime>();
    Map<Id,datetime> MarkActivitylead=new Map<Id,datetime>();
    
    
    
    List<ELOQUA__Marketing_Activity__c> marketingactivityList=new List<ELOQUA__Marketing_Activity__c>();
    
    if(Trigger.isAfter){
        if(trigger.isInsert){
                    
            for(ELOQUA__Marketing_Activity__c em1:trigger.new){
                if(em1.Name.contains('Marketing Campaign Response')||((em1.Name.contains('BD_DisruptionEM')||em1.Name.contains('BD_DripEM'))&& em1.ELOQUA__Activity_Type__c!='Email Sent')){
                    if(em1.ELOQUA__Contact__c != null)
                        conIds.add(em1.ELOQUA__Contact__c);                  
                    
                    if(em1.ELOQUA__Lead__c != null)
                        ledIds.add(em1.ELOQUA__Lead__c );
                        marketingactivityList.add(em1);
                }
            }
            //for contact
            if(!conIds.isEmpty()){
                for(Contact con:[Select Id,(Select id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE Status = 'Completed' order by ActivityDate ASC) from contact where Id in:conIds]){
                    //datetime ddddd=MarkActivityCon.get(con.id);//for after update
                    if(con.tasks.isEmpty()){             
                        con.Marketing_Category__c='new';
                        contactsMap.put(con.Id,con);
                        System.debug('a'+con.id);
                    }
                    else{
                        for(Task tsk: con.tasks){
                            if(tsk.Department__c=='Business Development'){
                                if(tsk.Activity_Type__c=='IRD Touch'||tsk.Activity_Type__c=='Recruiting'||tsk.Activity_Type__c=='Master Recruiting'){
                                    if(tsk.Category__c!='Social Media Outreach'&& tsk.Category__c!='Left Message – Prospecting'&& tsk.Category__c!='Mailed information'&& tsk.Category__c!='Email – Prospecting'&& tsk.Category__c!='Referral to Branch'&& tsk.Category__c!='Referral to Core'&& tsk.Category__c!='Referral to IS'&& tsk.Category__c!='Referral to Masters' && tsk.Category__c!='Other'){
                                        task_ids.add(tsk.id);
                                        taskListnew.add(tsk);//qualifying task
                                    }else{
                                        taskListnew1.add(tsk);
                                    }
                                }else{
                                    taskListnew1.add(tsk);
                                }
                            }else{
                                taskListnew1.add(tsk);
                            }
                        }
                        
                    }
                    if(!taskListnew1.isEmpty()&&taskListnew.isEmpty()){
                        con.Marketing_Category__c='new';
                        contactsMap.put(con.Id,con);
                        System.debug('b'+con.id);
                    }
                    if(!taskListnew.isEmpty()){
                        Integer temp=Null;
                        date d1;
                        date d2=null;
                        date d3=null;
                        date v=System.today();
                        date dt;
                        date vv;
                        Integer monthforCreatedDate;
                        Integer noOfDays;
                        date varActivityDate;
                        v=System.today();
                        
                        for(task tsk:taskListnew){
                            //date actDueDate =  tsk.ActivityDate;
                            dt=tsk.ActivityDate;
                            if( dt > v){
                                setFutureAcvts.add(tsk.WhoId);
                            }else{
                                if(dt.daysBetween(v)<=180 || dt == v){
                                    task_ids_active.add(tsk.WhoId);
                                    System.debug('dt.daysBetween(v) for insert'+dt.daysBetween(v));
                                    
                                }else{
                                    task_ids_nonActive.add(tsk.WhoId);
                                    System.debug('dt.daysBetween(v) for insert'+dt.daysBetween(v));
                                }
                            }
                            
                        }
                        //
                        if(!task_ids_active.isEmpty() && setFutureAcvts.isEmpty()){
                            con.Marketing_Category__c='Active';
                            contactsMap.put(con.Id,con);
                            System.debug('c'+con.id);
                        }
                        
                        if(!task_ids_nonActive.isEmpty() && setFutureAcvts.isEmpty() && task_ids_active.isEmpty()){
                            con.Marketing_Category__c='Inactive';
                            contactsMap.put(con.Id,con);
                            System.debug('d'+con.id);
                        }
                        
                        if(!setFutureAcvts.isEmpty()){
                            con.Marketing_Category__c='Inactive';
                            contactsMap.put(con.Id,con);
                            System.debug('e'+con.id);
                        }
                        
                    }
                }
                contactList = new List<Contact>();
                contactList.addAll(contactsMap.values()); 
                update contactList;
            }
            //for lead
            if(!ledIds.isEmpty()){
                for(lead led:[Select Id,(Select id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE Status = 'Completed' order by ActivityDate ASC) from lead where Id in:ledIds]){
                    if(led.tasks.isEmpty()){
                        led.Marketing_Category__c='New';
                        //leadList.add(led);
                        leadMapnew.put(led.id,led);
                    }else{
                        for(Task tsk: led.tasks){
                            if(tsk.Department__c=='Business Development'){
                                if(tsk.Activity_Type__c=='IRD Touch'||tsk.Activity_Type__c=='Recruiting'||tsk.Activity_Type__c=='Master Recruiting'){
                                    if(tsk.Category__c!='Social Media Outreach'&& tsk.Category__c!='Left Message – Prospecting'&& tsk.Category__c!='Mailed information'&& tsk.Category__c!='Email – Prospecting'&& tsk.Category__c!='Referral to Branch'&& tsk.Category__c!='Referral to Core'&& tsk.Category__c!='Referral to IS'&& tsk.Category__c!='Referral to Masters' && tsk.Category__c!='Other'){
                                        //taskListnew.add(tsk);//qualifying task
                                        tasklistforlead.add(tsk);
                                    }else{
                                        //taskListnew1.add(tsk);
                                        tasklistforlead1.add(tsk);
                                    }
                                }else{
                                    //taskListnew1.add(tsk);
                                    tasklistforlead1.add(tsk);
                                }
                            }else{
                                //taskListnew1.add(tsk);
                                tasklistforlead1.add(tsk);
                            }
                        }
                        
                    }
                    if(tasklistforlead.isEmpty()&&!tasklistforlead1.isEmpty()){
                        led.Marketing_Category__c='New';
                        //leadList.add(led);
                        leadMapnew.put(led.id,led);
                    }
                    if(!tasklistforlead.isEmpty()){
                        System.debug('abc');
                        Integer temp=Null;
                        date d1;
                        date d2;
                        date v=System.today();
                        datetime varCreatedDate;
                        date vv;
                        Integer monthforCreatedDate;
                        Integer noOfDays;
                        date varActivityDate;
                        v=System.today();
                        for(task tsk:tasklistforlead){
                            date dt =  tsk.ActivityDate;
                            if( dt > V){
                                setFutureAcvtsforlead.add(tsk.WhoId);
                                System.debug('a1');
                            }else{
                                if(dt.daysBetween(V)<=180 || dt == v){
                                    task_ids_activeforlead.add(tsk.WhoId);
                                    System.debug('a2');
                                    System.debug('a2 tsk.WhoId'+tsk.WhoId);
                                }else{
                                    task_ids_nonActiveforlead.add(tsk.WhoId);
                                    System.debug('a3');
                                }
                            }
                            
                        }
                        if(!task_ids_activeforlead.isEmpty()&& setFutureAcvtsforlead.isEmpty()){
                            led.Marketing_Category__c='Active';
                            //leadlist.add(led);
                            leadMapnew.put(led.id,led);
                            System.debug('b1');
                            System.debug('leadlist b1'+leadlist);
                        }if(!task_ids_nonActiveforlead.isEmpty() && setFutureAcvtsforlead.isEmpty() && task_ids_activeforlead.isEmpty()){
                            led.Marketing_Category__c='Inactive';
                            //leadlist.add(led);
                            leadMapnew.put(led.id,led);
                            System.debug('b2');
                            System.debug('leadlist b2'+leadlist);
                        }if(!setFutureAcvtsforlead.isEmpty()){
                            led.Marketing_Category__c='Inactive';
                            //leadlist.add(led);
                            leadMapnew.put(led.id,led);
                            System.debug('b3');
                            System.debug('leadlist b3'+leadlist);
                        }
                    }
                }
                leadList=new list<lead>();
                leadList.addAll(leadMapnew.values());
                update leadlist;
            }
            
        }       
    }
    if(trigger.isAfter){
        if(trigger.isUpdate){
        System.debug('Inside After Update');
            contactsSet=new Set<contact>();
            for(ELOQUA__Marketing_Activity__c em1:trigger.new){
                if(em1.Name.contains('Marketing Campaign Response')||((em1.Name.contains('BD_DisruptionEM')||em1.Name.contains('BD_DripEM'))&& em1.ELOQUA__Activity_Type__c!='Email Sent')){
                    if(em1.ELOQUA__Contact__c != null)
                        conIds.add(em1.ELOQUA__Contact__c);
                    MarkActivityCon.put(em1.ELOQUA__Contact__c,em1.createdDate); 
                    
                    if(em1.ELOQUA__Lead__c != null)
                        ledIds.add(em1.ELOQUA__Lead__c );
                    MarkActivitylead.put(em1.ELOQUA__Lead__c,em1.createdDate);
                    
                    marketingactivityList.add(em1);
                }
            }
            //for contact
            if(!conIds.isEmpty()){
                for(Contact con:[Select Id,(Select id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE Status = 'Completed' order by ActivityDate ASC) from contact where Id in:conIds]){
                    datetime activitycreatedDate=MarkActivityCon.get(con.id);//for after update
                    if(con.tasks.isEmpty()){             
                        con.Marketing_Category__c='new';
                        //contactList.add(con);
                        contactsMap.put(con.Id,con);
                    }else{
                        for(Task tsk: con.tasks){
                            if(tsk.Department__c=='Business Development'){
                                if(tsk.Activity_Type__c=='IRD Touch'||tsk.Activity_Type__c=='Recruiting'||tsk.Activity_Type__c=='Master Recruiting'){
                                    if(tsk.Category__c!='Social Media Outreach'&& tsk.Category__c!='Left Message – Prospecting'&& tsk.Category__c!='Mailed information'&& tsk.Category__c!='Email – Prospecting'&& tsk.Category__c!='Referral to Branch'&& tsk.Category__c!='Referral to Core'&& tsk.Category__c!='Referral to IS'&& tsk.Category__c!='Referral to Masters' && tsk.Category__c!='Other'){
                                        task_ids.add(tsk.id);
                                        taskListnew.add(tsk);//qualifying task
                                        System.debug('abc'+tsk.CreatedDate+tsk.ActivityDate);
                                    }else{
                                        taskListnew1.add(tsk);
                                        
                                    }
                                }else{
                                    taskListnew1.add(tsk);
                                }
                            }else{
                                taskListnew1.add(tsk);
                            }
                        }
                        
                    }
                    if(!taskListnew1.isEmpty()&&taskListnew.isEmpty()){
                        con.Marketing_Category__c='new';
                        //contactList.add(con);
                        contactsMap.put(con.Id,con);
                        
                    }
                    if(!taskListnew.isEmpty()){
                        Integer temp=Null;
                        date d1;
                        date d2=null;
                        date d3=null;
                        date v=System.today();
                        datetime varCreatedDate;
                        date vv;
                        Integer monthforCreatedDate;
                        Integer noOfDays;
                        date varActivityDate;
                        v=System.today();
                        date bb=activitycreatedDate.date();//for after update
                        for(task tsk:taskListnew){
                            date dt =  tsk.ActivityDate;
                            noOfDays=bb.daysBetween(dt);
                            if( dt > bb){            //comparing activity date and marketing creation  date
                                setFutureAcvts.add(tsk.WhoId);
                                System.debug('a12');
                                System.debug('bb  dt daysBetween'+bb+' '+dt+' '+dt.daysBetween(bb)+noOfDays);
                                    //con.Marketing_Category__c='Inactive';
                                    //contactList.add(con);
                                    //contactsMap.put(con.Id,con);

                            }else{
                                if( dt.daysBetween(bb)<=180 || dt == bb){   //(marketing created date and task activity date) or activate date and marketing creation date
                                    task_ids_active.add(tsk.WhoId);
                                     System.debug('b12');
                                     System.debug('bb  dt daysBetween'+bb+' '+dt+' '+dt.daysBetween(bb)+noOfDays);
                                    //con.Marketing_Category__c='Active';
                                    //contactList.add(con);
                                   // contactsMap.put(con.Id,con);
                                }else{
                                    task_ids_nonActive.add(tsk.WhoId);
                                     System.debug('c12');
                                    System.debug('bb  dt daysBetween'+bb+' '+dt+' '+dt.daysBetween(bb)+noOfDays);
                                    //con.Marketing_Category__c='Inactive';
                                    //contactList.add(con);
                                    //contactsMap.put(con.Id,con);
                                }
                            }
                            
                        }
                        
                        if(!task_ids_active.isEmpty() && setFutureAcvts.isEmpty()){
                            con.Marketing_Category__c='Active';
                            //contactList.add(con);
                            contactsMap.put(con.Id,con);
                        }if(!task_ids_nonActive.isEmpty() && setFutureAcvts.isEmpty() && task_ids_active.isEmpty()){
                            con.Marketing_Category__c='Inactive';
                            //contactList.add(con);
                            contactsMap.put(con.Id,con);
                        }if(!setFutureAcvts.isEmpty()){
                            con.Marketing_Category__c='Inactive';
                            //contactList.add(con);
                            contactsMap.put(con.Id,con);
                        }
                        
                    }
                }
                contactList = new List<Contact>();
                contactList.addAll(contactsMap.values()); 
                update contactList;
            }
            //for lead
            if(!ledIds.isEmpty()){
                System.debug('Inside Lead Update');
                for(lead led:[Select Id,(Select id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE Status = 'Completed' order by ActivityDate ASC) from lead where Id in:ledIds]){
                    datetime activitycreatedforlead=MarkActivitylead.get(led.id);
                    System.debug('*****led.tasks'+led.tasks);
                    if(led.tasks.isEmpty()){
                        led.Marketing_Category__c='New';
                        //leadList.add(led);
                         leadMapnew.put(led.id,led);
                    }else{
                        for(Task tsk: led.tasks){
                            if(tsk.Department__c=='Business Development'){
                                if(tsk.Activity_Type__c=='IRD Touch'||tsk.Activity_Type__c=='Recruiting'||tsk.Activity_Type__c=='Master Recruiting'){
                                    if(tsk.Category__c!='Social Media Outreach'&& tsk.Category__c!='Left Message – Prospecting'&& tsk.Category__c!='Mailed information'&& tsk.Category__c!='Email – Prospecting'&& tsk.Category__c!='Referral to Branch'&& tsk.Category__c!='Referral to Core'&& tsk.Category__c!='Referral to IS'&& tsk.Category__c!='Referral to Masters' && tsk.Category__c!='Other'){
                                        //taskListnew.add(tsk);//qualifying task
                                        tasklistforlead.add(tsk);
                                    }else{
                                        //taskListnew1.add(tsk);
                                        tasklistforlead1.add(tsk);
                                    }
                                }else{
                                    //taskListnew1.add(tsk);
                                    tasklistforlead1.add(tsk);
                                }
                            }else{
                                //taskListnew1.add(tsk);
                                tasklistforlead1.add(tsk);
                            }
                        }
                        
                    }
                    System.debug('*****tasklistforlead'+tasklistforlead);
                    System.debug('*****tasklistforlead1'+tasklistforlead1);
                    if(tasklistforlead.isEmpty()&&!tasklistforlead1.isEmpty()){
                        led.Marketing_Category__c='New';
                        //leadList.add(led);
                         leadMapnew.put(led.id,led);
                    }
                    if(!tasklistforlead.isEmpty()){
                        Integer temp=Null;
                        date d1;
                        date d2;
                        date v=System.today();
                        datetime varCreatedDate;
                        date vv;
                        Integer monthforCreatedDate;
                        Integer noOfDays;
                        date varActivityDate;
                        v=System.today();
                        date gg=activitycreatedforlead.date();
                        for(task tsk:tasklistforlead){
                            date dt =  tsk.ActivityDate;
                            if( dt > gg){                        //comparing activity date and marketing activity date
                                setFutureAcvtsforlead.add(tsk.WhoId);
                                //led.Marketing_Category__c='Inactive';
                                //leadlist.add(led);
                                //leadMapnew.put(led.id,led);
                                System.debug('l1');

                            }else{
                                if(dt.daysBetween(gg)<=180 || dt == gg){    //marketing created date and task activity date or activate date and marketing activity date
                                    //led.Marketing_Category__c='Active';
                                    //leadlist.add(led);
                                    //leadMapnew.put(led.id,led);
                                    task_ids_activeforlead.add(tsk.WhoId);
                                    System.debug('l2');
                                     System.debug('gg  dt daysBetween'+gg+' '+dt+' '+dt.daysBetween(gg));
                                }else{
                                    //led.Marketing_Category__c='Inactive';
                                    //leadlist.add(led);
                                    //leadMapnew.put(led.id,led);
                                    task_ids_nonActiveforlead.add(tsk.WhoId);
                                    System.debug('l3');
                                    System.debug('gg  dt daysBetween'+gg+' '+dt+' '+dt.daysBetween(gg));
                                }
                            }
                            
                        }
                        
                        if(!task_ids_activeforlead.isEmpty()&& setFutureAcvtsforlead.isEmpty()){
                            led.Marketing_Category__c='Active';
                            //leadlist.add(led);
                             leadMapnew.put(led.id,led);
                        }if(!task_ids_nonActiveforlead.isEmpty() && setFutureAcvtsforlead.isEmpty() && task_ids_activeforlead.isEmpty()){
                            led.Marketing_Category__c='Inactive';
                            //leadlist.add(led);
                             leadMapnew.put(led.id,led);
                        }if(!setFutureAcvtsforlead.isEmpty()){
                            led.Marketing_Category__c='Inactive';
                            //leadlist.add(led);
                             leadMapnew.put(led.id,led);
                        }
                    }
                }
                leadList=new list<lead>();
                leadList.addAll(leadMapnew.values());
                update leadlist;
            }
        }
    }
}