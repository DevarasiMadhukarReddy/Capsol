/*
     * @author        : Rinku Yadav
     * @date          : 17 May, 2019
     * @description   : This batch class deletes the records of ELOQUA__Marketing_Activity__c which are created before 31st December, 2018
                        and having Activity_Type__c value as either of Email Sent, Email Subscribe or Email Unsubscribe.
*/
global class LPL_MarketingActivityDelete_Batch implements Database.Batchable<SObject> {
    
    /*
         * @Method Name    : start
         * @date           : 17 May, 2019
         * @param          : Database.BatchableContext BC
         * @return         : Database.QueryLocator
    */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'Select Id,ELOQUA__Activity_Type__c,createddate from ELOQUA__Marketing_Activity__c where createddate <= 2018-12-31T00:00:00Z AND ELOQUA__Activity_Type__c IN (\'Email Sent\', \'Email Subscribe\', \'Email Unsubscribe\')';
        return Database.getQueryLocator(query);
    }
    
    /*
         * @Method Name    : execute
         * @date           : 17 May, 2019
         * @param          : Database.BatchableContext BC, List<ELOQUA__Marketing_Activity__c> marketingActList
         * @return         : void
    */ 
    global void execute(Database.BatchableContext BC, List<SObject> marketingActList) {
        
        if(marketingActList != null && !marketingActList.isEmpty()){
            try{
                delete marketingActList;
            } catch (Exception ex){
                system.debug('Exception Occured::: '+ex.getMessage());
            }
        }
    }   
     
     /*
         * @Method Name    : finish
         * @date           : 17 May, 2019
         * @param          : Database.BatchableContext BC
         * @return         : void
    */
    global void finish(Database.BatchableContext BC) {
    
    }
}