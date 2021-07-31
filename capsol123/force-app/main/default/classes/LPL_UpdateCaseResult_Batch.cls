/*
Batch class Name              :LPL_UpdateCaseResult_Batch
Developer Name                :Vaibhav Wadhai
Created Date                  :24 july 2017
Versio No                     :1.0 

Note:Test class-
*/

global class LPL_UpdateCaseResult_Batch implements Database.Batchable<sObject>, Database.Stateful {
    
    
    public static boolean stopCaseTrigger=false;// to disable case Trigger
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Id caseRecordTypeIBDid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();//Ishan Nigam:Modified the name from Project J to Business Development as part of Project Wreath changes
        
        String query;
        String query1='Verbal Yes';
        query='Select Id from Case where RecordTypeId =\'' + caseRecordTypeIBDid + '\'' 
                            + 'and No_Follow_Up_Days__c!=NULL and Result__c =\'' + query1+ '\'';
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Case> caseList) {
                           
        System.debug('caseOppList*****'+caseList); 
        List<Case> caseOppList = new List<Case>();
        System.debug('caseOppList'+caseOppList.size()+caseOppList);
        
        if(caseList.size()>=0) {
                            
        for(Case caseRec:caseList) {
            
            caseOppList.add(caseRec);
        }         
        
        System.debug('caseOppList*****'+caseOppList.size()+caseOppList);
               
        if(!caseOppList.isEmpty()) {
            
            stopCaseTrigger=true; // to disable  Case trigger
            
            update caseOppList;
         }
        }
        
        
       
    }
    global void finish(Database.BatchableContext BC){
                
             
    }
    
}