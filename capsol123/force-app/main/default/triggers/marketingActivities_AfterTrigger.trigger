/*
Trigger Name            : marketingActivities_AfterTrigger 
Trigger Description     :When Activity Type = Campaign, and Activity Status = Responded, create a task 
assigned to the IRD associated to the Contact. 
*Subject = Marketing Form Follow up
*Department = Business Development
*Activity Type = IRD Touch
*Category = Call-Outbound
*Due Date = 2 days after the created date of the Marketing activity task
Developer Name          : Sai Kethu - CTS
Created Date            : 12/12/16

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01       Same functionality as above on Lead as well       Utkarsh Topre      04/20/2017
CH-02       The functionality to create tasks on Lead &       Utkarsh Topre      05/03/2017
Contact based on certain criteria
CH-03       The functionality to create tasks on Lead &       Utkarsh Topre      05/25/2017
Contact when the Marketing Activity Name
contains 'BD_Agile'

CH-04 Update Lead Source to "Marketing Initiated (MI)" when   Manila Agnihotri   05-June-2018
      Marketing Category equals "Dormant" and a qualifying
      activity created/updated related to that Contact

Note : Test Coverage for This trigger is covered in Test classes  : LPL_ContTriggerHandlerTest and LPL_LeadTrigger_Test
*/

trigger marketingActivities_AfterTrigger on ELOQUA__Marketing_Activity__c (after insert,after update) {
    Set<Id> conIds = new Set<Id>();
    Set<Id> ledIds = new Set<Id>();
    Map<Id, Contact> conMap = new Map<Id, Contact>();
    Map<Id, Lead> leadMap = new Map<Id, Lead>();
    List<Task> taskList1 = new List<Task>();

    If(trigger.isInsert)
    {
        
        Trigger_Bypass__c tbp =  Trigger_Bypass__c.getInstance('Contact');
        tbp.IsOff__c = True;
        Update tbp;
        for(ELOQUA__Marketing_Activity__c ema1 : trigger.new)
        {
            if((ema1.ELOQUA__Activity_Type__c == 'Campaign' && ema1.Activity_Status__c == 'Responded') || 
               (ema1.Name.contains('BD_DisruptionEM') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through') || //CH-02 : Added 'BD_DisruptionEM' in Name
               (ema1.Name.contains('BD_DripEM') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through') ||   //CH-02 : Added 'BD_DripEM' in Name
               (ema1.Name.contains('BD_Agile') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through')){    //CH-03 : Added 'BD_Agile' in Name
                   if(ema1.ELOQUA__Contact__c != null) //Add the Contact ID when the ELOQUA__Contact__c is not null
                       conIds.add(ema1.ELOQUA__Contact__c );
                   //CH-01
                   if(ema1.ELOQUA__Lead__c != null) //Add the Lead ID when the ELOQUA__Lead__c is not null
                       ledIds.add(ema1.ELOQUA__Lead__c );
               }
            else{
                if(ema1.ELOQUA__Contact__c != null){
                    conIds.add(ema1.ELOQUA__Contact__c);
                 }
            }
        } 
        
            if(!conIds.isEmpty()){       
                conMap = new Map<id, Contact>([Select id,Internal_Recruiter_IRD__c,Lead_Source__c,Recordtype.Name,Marketing_Category__c From Contact Where (Id in :conIds)]);
            }
            //CH-01 - Start
            if(!ledIds.isEmpty()){
                leadMap = new Map<id, Lead>([Select id,Internal_Recruiter_IRD__c From Lead Where (Id in :ledIds)]);
            }
            //CH-01 - ENd
        
        for(ELOQUA__Marketing_Activity__c ema1 : trigger.new)
        {
        // CH-04 - start
            if((ema1.Name.contains('BD_DisruptionEM') || ema1.Name.contains('BD_Agile') || ema1.Name.contains('Marketing Campaign Response') || ema1.Name.contains('BD_DripEM')) && (ema1.ELOQUA__Activity_Type__c!='Email Sent'))
            {
            if(ema1.ELOQUA__Contact__c!=null)
            {
                if(conMap.get(ema1.ELOQUA__Contact__c).RecordType.Name == 'Contact Prospect'&& conMap.get(ema1.ELOQUA__Contact__c).Lead_Source__c !=null && conMap.get(ema1.ELOQUA__Contact__c).Marketing_Category__c == 'Dormant' && conMap.get(ema1.ELOQUA__Contact__c).Marketing_Category__c!=null){
                    conMap.get(ema1.ELOQUA__Contact__c).Lead_Source__c = 'Marketing Initiated';
                }
            }
            }
      // CH-04 - end      
            if(ema1.ELOQUA__Contact__c != NULL && ema1.ELOQUA__Activity_Type__c == 'Campaign' && ema1.Activity_Status__c == 'Responded' ){            
                Task t1 = new Task();
                t1.Subject = 'Marketing Form Follow up';
                t1.whoId = conMap.get(ema1.ELOQUA__Contact__c).ID;
                t1.Status = 'Not Started';
                t1.Department__c = 'Business Development';
                t1.Activity_Type__c = 'IRD Touch';
                t1.Category__c = 'Call-Outbound';
                t1.ActivityDate = System.Today() + 2;
                t1.recordtypeId = Label.TaskMasterRecordType;
                t1.Type = 'Outbound Call';
                
                If(conMap.get(ema1.ELOQUA__Contact__c).Internal_Recruiter_IRD__c != NULL)
                t1.ownerId =  conMap.get(ema1.ELOQUA__Contact__c).Internal_Recruiter_IRD__c ;  
                taskList1.add(t1);    
            }
            
            //**********CH-01 : START to create a Task under the Lead***************
            if(ema1.ELOQUA__Lead__c!= NULL && ema1.ELOQUA__Activity_Type__c == 'Campaign' && ema1.Activity_Status__c == 'Responded' ){
                Task t2 = new Task();
                t2.Subject = 'Marketing Form Follow up';
                t2.whoId = leadMap.get(ema1.ELOQUA__Lead__c).ID;
                t2.Status = 'Not Started';
                t2.Department__c = 'Business Development';
                t2.Activity_Type__c = 'IRD Touch';
                t2.Category__c = 'Call-Outbound';
                t2.ActivityDate = System.Today() + 2;
                t2.recordtypeId = Label.TaskMasterRecordType;
                t2.Type = 'Outbound Call';
                
                If(leadMap.get(ema1.ELOQUA__Lead__c).Internal_Recruiter_IRD__c != NULL)
                t2.ownerId =  leadMap.get(ema1.ELOQUA__Lead__c).Internal_Recruiter_IRD__c;  
                taskList1.add(t2); 
            }
            //**********CH-01 : END to create a Task under the Lead***************
            //**********CH-02 : START***************
            //********************For Contact: This will create a Task under the Contact when the below criteria is met********************
            if(ema1.ELOQUA__Contact__c != NULL && ema1.Name.contains('BD_DisruptionEM') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through' ){            
                Task t3 = new Task();
                t3.Subject = 'Disruption Email Click Through Follow Up';
                t3.whoId = conMap.get(ema1.ELOQUA__Contact__c).ID;
                t3.Status = 'Not Started';
                t3.Department__c = 'Business Development';
                t3.Activity_Type__c = 'IRD Touch';
                t3.Category__c = 'Call-Outbound';
                t3.ActivityDate = System.Today() + 5;
                t3.recordtypeId = Label.TaskMasterRecordType;
                t3.Type = 'Outbound Call';
                
                If(conMap.get(ema1.ELOQUA__Contact__c).Internal_Recruiter_IRD__c != NULL)
                t3.ownerId =  conMap.get(ema1.ELOQUA__Contact__c).Internal_Recruiter_IRD__c ;  
                taskList1.add(t3);    
            }
            
            if(ema1.ELOQUA__Contact__c != NULL && ema1.Name.contains('BD_DripEM') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through' ){            
                Task t4 = new Task();
                t4.Subject = 'Drip Email Click Through Follow Up ';
                t4.whoId = conMap.get(ema1.ELOQUA__Contact__c).ID;
                t4.Status = 'Not Started';
                t4.Department__c = 'Business Development';
                t4.Activity_Type__c = 'IRD Touch';
                t4.Category__c = 'Call-Outbound';
                t4.ActivityDate = System.Today() + 5;
                t4.recordtypeId = Label.TaskMasterRecordType;
                t4.Type = 'Outbound Call';
                
                If(conMap.get(ema1.ELOQUA__Contact__c).Internal_Recruiter_IRD__c != NULL)
                t4.ownerId =  conMap.get(ema1.ELOQUA__Contact__c).Internal_Recruiter_IRD__c ;  
                taskList1.add(t4);    
            }
            
            //**************************For Lead: This will create a Task under the Lead when the below criteria is met***************************
            if(ema1.ELOQUA__Lead__c != NULL && ema1.Name.contains('BD_DisruptionEM') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through' ){            
                Task t5 = new Task();
                t5.Subject = 'Disruption Email Click Through Follow Up';
                t5.whoId = leadMap.get(ema1.ELOQUA__Lead__c).ID;
                t5.Status = 'Not Started';
                t5.Department__c = 'Business Development';
                t5.Activity_Type__c = 'IRD Touch';
                t5.Category__c = 'Call-Outbound';
                t5.ActivityDate = System.Today() + 5;
                t5.recordtypeId = Label.TaskMasterRecordType;
                t5.Type = 'Outbound Call';
                
                If(leadMap.get(ema1.ELOQUA__Lead__c).Internal_Recruiter_IRD__c != NULL)
                t5.ownerId =  leadMap.get(ema1.ELOQUA__Lead__c).Internal_Recruiter_IRD__c ;  
                taskList1.add(t5);    
            }
            
            if(ema1.ELOQUA__Lead__c != NULL && ema1.Name.contains('BD_DripEM') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through' ){            
                Task t6 = new Task();
                t6.Subject = 'Drip Email Click Through Follow Up ';
                t6.whoId = leadMap.get(ema1.ELOQUA__Lead__c).ID;
                t6.Status = 'Not Started';
                t6.Department__c = 'Business Development';
                t6.Activity_Type__c = 'IRD Touch';
                t6.Category__c = 'Call-Outbound';
                t6.ActivityDate = System.Today() + 5;
                t6.recordtypeId = Label.TaskMasterRecordType;
                t6.Type = 'Outbound Call';
                
                If(leadMap.get(ema1.ELOQUA__Lead__c).Internal_Recruiter_IRD__c != NULL)
                t6.ownerId =  leadMap.get(ema1.ELOQUA__Lead__c).Internal_Recruiter_IRD__c ;  
                taskList1.add(t6);    
            }
            //**********CH-02 : END***************
            //**********CH-03 : START***************
            //********************For Contact: This will create a Task under the Contact when the below criteria is met********************
            if(ema1.ELOQUA__Contact__c != NULL && ema1.Name.contains('BD_Agile') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through' ){            
                Task t7 = new Task();
                t7.Subject = 'Agile Email Click Through Follow Up';
                t7.whoId = conMap.get(ema1.ELOQUA__Contact__c).ID;
                t7.Status = 'Not Started';
                t7.Department__c = 'Business Development';
                t7.Activity_Type__c = 'IRD Touch';
                t7.Category__c = 'Call-Outbound';
                t7.ActivityDate = System.Today() + 5;
                t7.recordtypeId = Label.TaskMasterRecordType;
                
                If(conMap.get(ema1.ELOQUA__Contact__c).Internal_Recruiter_IRD__c != NULL)
                t7.ownerId =  conMap.get(ema1.ELOQUA__Contact__c).Internal_Recruiter_IRD__c ;  
                taskList1.add(t7);    
            }
            
            //**************************For Lead: This will create a Task under the Lead when the below criteria is met***************************
            if(ema1.ELOQUA__Lead__c != NULL && ema1.Name.contains('BD_Agile') && ema1.ELOQUA__Activity_Type__c == 'Email Click Through' ){            
                Task t8 = new Task();
                t8.Subject = 'Agile Email Click Through Follow Up';
                t8.whoId = leadMap.get(ema1.ELOQUA__Lead__c).ID;
                t8.Status = 'Not Started';
                t8.Department__c = 'Business Development';
                t8.Activity_Type__c = 'IRD Touch';
                t8.Category__c = 'Call-Outbound';
                t8.ActivityDate = System.Today() + 5;
                t8.recordtypeId = Label.TaskMasterRecordType;
                
                If(leadMap.get(ema1.ELOQUA__Lead__c).Internal_Recruiter_IRD__c != NULL)
                t8.ownerId =  leadMap.get(ema1.ELOQUA__Lead__c).Internal_Recruiter_IRD__c ;  
                taskList1.add(t8);    
            }
            //**********CH-03 : END***************
        }
       If(!taskList1.isEmpty()){
            database.insert(taskList1,false);
        } 
        if(conMap.size() != 0) {
            database.update(conMap.values(),false);
        }
        tbp.IsOff__c = False;
        Update tbp;
    }
       
        //CH-04 - start
        
     if(trigger.isUpdate)
    {
        Trigger_Bypass__c tbp =  Trigger_Bypass__c.getInstance('Contact');
        tbp.IsOff__c = True;
        Update tbp;
         for(ELOQUA__Marketing_Activity__c ema1 : trigger.new)
        {
          if(ema1.ELOQUA__Contact__c != null){
                    conIds.add(ema1.ELOQUA__Contact__c);
                 }
                 
                    if(!conIds.isEmpty()){       
                conMap = new Map<id, Contact>([Select id,Internal_Recruiter_IRD__c,Lead_Source__c,Recordtype.Name,Marketing_Category__c From Contact Where (Id in :conIds)]);
            }
                 
                 if((ema1.Name.contains('BD_DisruptionEM') || ema1.Name.contains('BD_Agile') || ema1.Name.contains('Marketing Campaign Response') || ema1.Name.contains('BD_DripEM')) && (ema1.ELOQUA__Activity_Type__c!='Email Sent'))
                 {
                 if(ema1.ELOQUA__Contact__c != null){
                if(conMap.get(ema1.ELOQUA__Contact__c).RecordType.Name == 'Contact Prospect' && conMap.get(ema1.ELOQUA__Contact__c).Lead_Source__c !=null && conMap.get(ema1.ELOQUA__Contact__c).Marketing_Category__c == 'Dormant' && conMap.get(ema1.ELOQUA__Contact__c).Marketing_Category__c!=null)
                {
                    conMap.get(ema1.ELOQUA__Contact__c).Lead_Source__c = 'Marketing Initiated';
                }
                }
            }
        }
        if(conMap.size() != 0) {
            database.update(conMap.values(),false);
        }
            tbp.IsOff__c = False;
            Update tbp;
    }
    // CH-04 - end 
}