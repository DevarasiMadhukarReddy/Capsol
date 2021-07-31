global class Batch_Email_Tasks implements Database.Batchable<SObject>, Database.AllowsCallouts {

global List<SObject> gllstScopeRecords;

    // "Start" runs when the class in instanciated
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
    
        return Database.getQueryLocator([select Id,Master_Rep_Id__c,WhoId from Task where (Master_Rep_Id__c=''  OR  Master_Rep_Id__c= NULL)and Type ='Email']);
    
    
    }
    


    public static void Task(list<Task> Lstsch) {
    
    List<Task> Lsbi = new List<Task>();
    
    map<id,Task> taskMap = new Map <id,task>();
    
    Map<ID, Contact> ContactMap = new Map<ID, Contact>();

    
    if(!Lstsch.IsEmpty()){
    set<Id> contactSet = new set<Id>();
    
    for(Task b:Lstsch){
    
    if(b.WhoId != null)
        {  
            if(String.valueOf(b.WhoId).StartsWith('003')) {
            
            contactSet.add(b.WhoId);
            taskMap.put(b.id,b);
            
            }
        }
    }
    
    if(!contactSet.IsEmpty()){  
    
        system.debug('+++++++++++++++++++++++++++++++ In:contactSet: ' + contactSet);
    
        ContactMap = new Map<ID, Contact>([select id,master_rep_id__c from Contact where id In:contactSet ]);
        
        system.debug('+++++++++++++++++++++++++++++++ ContactMap: ' + ContactMap);
        
        }    
    }
    
    for(task t:taskMap.values())
    {
       if(ContactMap.get(t.whoId)!= null){       
       
        t.master_rep_id__c=ContactMap.get(t.whoId).master_rep_id__c;
        
        system.debug('+++++++++++++++++++++++++++++++ t.master_rep_id__c: ' + t.master_rep_id__c);
        
        
        }
    }
    
    if(!taskMap.values().IsEmpty()){
    
    system.debug('+++++++++++++++++++++++++++++++ update Lsbi: ' + Lsbi);
    update taskMap.values();
    }
    
 }
      
global void execute(Database.BatchableContext bcMain, List<SObject> lstBatchRecords) 
{
   Task(lstBatchRecords);
   
   system.debug('+++++++++++++++++++++++++++++++ execute: ' + lstBatchRecords);     
}


// Finish the Batch Job
    global void finish(Database.BatchableContext BC) {
    
  
    }
}