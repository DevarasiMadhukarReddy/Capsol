/**
Batch Class where external sales teams RACs and RICs could close out the earliest dated open activity 
with "Advisory Segmentation" subject by merely adding campaign members to a SGW (Small Group Workshop) campaign. 
Activity will relate to the campaign and activity will be closed out. Trigger can execute on the addition of the campaign member or can be run offline on a weekly basis.
Will require a special naming convention to the campaign to know to execute the logic / trigger.
*/



global class Batch_SGWA_AdvisorySegTask_Update implements Database.Batchable<SObject>, Database.AllowsCallouts {

global List<SObject> gllstScopeRecords;

    // "Start" runs when the class in instanciated
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
    
        return Database.getQueryLocator([select Id,ContactId,CampaignId,LeadId,SGWA_member__c,Campaign_Owner__c,Campaign_Start_Date__c,Campaign_Name__c  from Campaignmember where (Campaign_Name__c like'%SGWA%') and status = 'Attended' and SGWA_member__c = false]);   
    
    }
    
    public static void Campaignmember (list<Campaignmember> Lstsch) {
    
    List<Campaignmember > Lsbi = new List<Campaignmember>();
    
    map<id,Campaignmember > memberMap = new Map <id,Campaignmember >();
    
     map<id,Task> taskMap1 = new Map <id,TAsk>();
    
    Map<ID, Contact> ContactMap = new Map<ID, Contact>();
    
    Set<Id> ContactIds = new Set<Id>();
    
    Map<ID, Lead> LeadMap = new Map<ID, Lead>();
    
    Set<Id> LeadIds = new Set<Id>();


    
    if(!Lstsch.IsEmpty()){
    set<Id> contactSet = new set<Id>();
    
    for(Campaignmember b:Lstsch){
    
    if(b.ContactId != null)
        {  
            
            
            contactSet.add(b.ContactId );
            memberMap.put(b.ContactId,b);
   
        }
      if(b.LeadId != null)
        {  
            
            
            contactSet.add(b.LeadId );
            memberMap.put(b.LeadId,b);
   
        }  
        
        b.SGWA_member__c =true;
    }
    
    if(!contactSet.IsEmpty()){  
    
        system.debug('+++++++++++++++++++++++++++++++ In:contactSet: ' + contactSet);
    
        taskMap1 = new Map<ID, task>([select Id,whoid,status from task where whoid In:contactSet and subject = 'Advisory Segmentation' and status != 'Completed'  and ISRECURRENCE = false order by ActivityDate]);
        
        system.debug('+++++++++++++++++++++++++++++++ ContactMap: ' + ContactMap);
        
        }    
    }
    
    for(Task t:taskMap1.values())
    {
       if(memberMap.get(t.whoId)!= null){       
       
           if(ContactIds.contains(t.whoId)== false)
           {       
                t.status = 'Completed';

                
                if(String.valueOf(t.whoId).StartsWith('003')) 
                {   
                    t.whatId= memberMap.get(t.whoId).CampaignId;
                    t.Description='Attended'+':'+ memberMap.get(t.whoId).Campaign_Name__c ;
                    t.OwnerId=memberMap.get(t.whoId).Campaign_Owner__c;
                    t.ActivityDate=memberMap.get(t.whoId).Campaign_Start_Date__c;
                    t.Activity_Type__c='External Advisory';
                }
                ContactIds.add(t.whoId);
            } 
        
        
        }
    }
    
    if(!taskMap1.values().IsEmpty()){
    
    system.debug('+++++++++++++++++++++++++++++++ update Lsbi: ' + Lsbi);
    update taskMap1.values();
    update Lstsch;
    }
    
 }
      
global void execute(Database.BatchableContext bcMain, List<SObject> lstBatchRecords) 
{
   Campaignmember(lstBatchRecords);
   
   system.debug('+++++++++++++++++++++++++++++++ execute: ' + lstBatchRecords);     
}


// Finish the Batch Job
    global void finish(Database.BatchableContext BC) {
    
  
    }
}