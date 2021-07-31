/*Batch class Name               : LPL_No_Of_Advisor_On_Account_Batch 
Description                      : This batch class updates # of Advisor on Account. 
Created By                       : Garvita
Created Date                     : 13- Feb-2019
*/


global class LPL_No_Of_Advisor_On_Account_Batch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String Query ='Select ID,Number_of_Contacts__c from Account'; 
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        List<Account> accList = new List<Account>();
        try {  
            Integer count =0;
            Account acc = new Account(id=scope[0].id);
            List<AccountContactRelation> accrRelList = new List<AccountContactRelation>([SELECT id,ContactId from AccountContactRelation where Skip_From_Trigger__c = False AND AccountId=: acc.id]);
            for(AccountContactRelation acrRel : accrRelList){
                count++;
            }
            acc.Number_of_Contacts__c=count;
            accList.add(acc);
            if(accList.size()>0){
                update accList;
            }
        }catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_No_Of_Advisor_On_Account_Batch ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
        
    }
    
    global void finish(Database.BatchableContext BC){}
}