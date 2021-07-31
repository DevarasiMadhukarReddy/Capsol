/*
Batch class Name              :LPL_MarketingCategoryBatch
Developer Name                :Ashish Gupta
Created Date                  :15 FEB 2018
Versio No                     :1.0 

Note:Test class-  LPL_MarkeingCategoryBatch_test 
*/

global class LPL_MarketingCategoryBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
       
      // Date fromDate= Marketing_Category_Date__c.getInstance().fromdate__c;
      // Date toDate= Marketing_Category_Date__c.getInstance().todate__c;
            
       // System.debug('fromDate>>'+fromDate);
       // System.debug('toDate>>'+toDate);
        String query = 'Select Id,Marketing_Category__c,CreatedDate,Processed_MarketingCat__c  from Contact where RecordtypeID =:conRecordTypeId';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        
        Set<Id> conIds = new Set<Id>();
        List<Task> taskList=new List<Task>();
        List<ELOQUA__Marketing_Activity__c> marketingList=new List<ELOQUA__Marketing_Activity__c>();
        List<Contact> fetchSubSetOfContacts = new List<Contact>();  
        List<Task> newTaskList=new List<Task>();
        List<ELOQUA__Marketing_Activity__c> newMarketingList=new List<ELOQUA__Marketing_Activity__c>();
        
        
        try{  
            Map<Id,contact> contactsMap =new Map<Id,contact>();//for contact map
            if(scope.size()>0) {
                for(Contact con : scope){
                    
                    conIds.add(con.Id);
                    
                }
            }
            
             fetchSubSetOfContacts = [Select Id,Marketing_Category__c,CreatedDate,Processed_MarketingCat__c,(Select Id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE (ActivityDate =LAST_N_DAYS:365  and Status != 'Completed' and (Department__c='Business Development' and ((Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='BDA Touch') and ( Category__c!='Left Message – Prospecting' and  Category__c!='Mailed information' and  Category__c!='Email – Prospecting' and  Category__c!='Referral to Branch' and  Category__c!='Referral to Core' and  Category__c!='Referral to IS' and  Category__c!='Referral to Masters' and Category__c!='Other'))))), (Select ID,Name,ELOQUA__Contact__c,ELOQUA__Lead__c,createdDate,ELOQUA__Activity_Type__c,ELOQUA__Activity_Date__c from R00N30000000rPtwEAE__r where ELOQUA__Activity_Date__c=LAST_N_DAYS:365)from Contact where  Id in:conIds ];
           
           
            List<Contact>dormantconList=new List<Contact>();
            List<Contact>recuiterconList=new List<Contact>();
            List<Contact>processedConList=new List<Contact>();
            
            for(Contact contactobj: fetchSubSetOfContacts){
               
                if(contactobj.Tasks.size()==0 && contactobj.ELOQUA__R00N30000000rPtwEAE__r.size()==0){
                    
                    contactobj.Marketing_Category__c='Dormant';
                    contactobj.Processed_MarketingCat__c=True;
                    dormantconList.add(contactobj);
                    
                    System.debug('dormant contactobj '+contactobj);
                    // put dormant
                }  
                else if(contactobj.Tasks.size()>0 && contactobj.ELOQUA__R00N30000000rPtwEAE__r.size()==0)                 
                {
                    //check with dormant / blank
                    if( contactobj.Marketing_Category__c==null ||contactobj.Marketing_Category__c=='' || contactobj.Marketing_Category__c=='Dormant')
                    {
                        contactobj.Marketing_Category__c='Recruiter';
                        contactobj.Processed_MarketingCat__c=True;
                        recuiterconList.add(contactobj);
                        System.debug('Recuiter contactobj if task size not zero'+contactobj);
                        //Recuiter
                    }
                    
                }
                
                else if(contactobj.Tasks.size()==0 && contactobj.ELOQUA__R00N30000000rPtwEAE__r.size()>0)                 
                {   //check with dormant / blank
                    if( contactobj.Marketing_Category__c==null ||contactobj.Marketing_Category__c=='' || contactobj.Marketing_Category__c=='Dormant')
                    {
                        contactobj.Marketing_Category__c='Recruiter';
                        contactobj.Processed_MarketingCat__c=True;
                        recuiterconList.add(contactobj);  
                        
                        System.debug('Recuiter contactobj if task size Zero '+contactobj);
                    }
                   
                }
                
                else if(contactobj.Tasks.size()>0 && contactobj.ELOQUA__R00N30000000rPtwEAE__r.size()>0)                 
                {   
                    //check with dormant / blank
                    if( contactobj.Marketing_Category__c==null ||contactobj.Marketing_Category__c=='' || contactobj.Marketing_Category__c=='Dormant')
                    {
                        contactobj.Marketing_Category__c='Recruiter';
                        contactobj.Processed_MarketingCat__c=True;
                        recuiterconList.add(contactobj);  
                        
                        System.debug('Recuiter contactobj if task size Zero '+contactobj);
                    }
                    
                }
                else{
                       contactobj.Processed_MarketingCat__c=True;
                       processedConList.add(contactobj); 
                }
             
            }
            
            if(recuiterconList.size()>0){
                System.debug('recuiterconList>>'+recuiterconList);
                update recuiterconList; 
                
            }
            
            if(dormantconList.size()>0){
                System.debug('dormantconList>>'+dormantconList);
                update dormantconList; 
                
            }
            
            if(processedConList.size()>0){
                System.debug('processedConList>>'+processedConList);
                update processedConList; 
                
            }
            
        }catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_MarketingCategoryBatch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());//modified by vaibhav
            
        }     
    }
    
    global void finish(Database.BatchableContext BC){
        
        
        
    }
}