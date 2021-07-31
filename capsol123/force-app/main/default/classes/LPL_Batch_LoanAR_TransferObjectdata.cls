/*
##############Change History#############
CH.No       Description                                                        Developer           Date
------------------------------------------------------------------------------------------------------------
Description:  Loading of data of Managed Package Object 'Contract'            Utkarsh Topre     27/09/2017
into custom Object 'Account Receivable'. Here we have mapped 
some fields from Contract object to Account Receivable Object.

CH-02 collect__External_ID__c split and assign to As of date field           ashish Gupta       2/11/2017
*/

global class LPL_Batch_LoanAR_TransferObjectdata implements Database.batchable<sobject> {
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String Query;
        
        Query = 'Select Id, Name, collect__External_ID__c, Master_Rep_Id__c, collect__Contact__r.Id, collect__Contact__r.Name, Rep_Status_Code__c, Less_Than_120_Days__c, Greater_Than_120_Days__c, Total_AR_Balance__c, Rep_Name__c, Forgivable_Loan__c, Repayable_Loan__c, Non_Loan__c, Rep_ID__c from collect__Loan_Account__c ORDER BY CreatedDate ASC NULLS FIRST';                                
        
        return Database.getQueryLocator(Query);        
        
    }
    
    global void execute(Database.BatchableContext info, List<collect__Loan_Account__c> scope) {
        
        try {
            
            List<Account_Receivable__c> arList=new List<Account_Receivable__c>();            
            List<Account_Receivable__c> accountReceivableList=new List<Account_Receivable__c>();
            List<Account_Receivable__c> FinalarList=new List<Account_Receivable__c>(); 
            Map<String,Account_Receivable__c> loanARMap=new Map<String,Account_Receivable__c>();
            Set<String> ids=new Set<String>();
            map<String, Account_Receivable__c> ar_Map = new map<String, Account_Receivable__c>(); 
            
            
            for(Integer i=0;i<scope.size();i++) {
                
                ids.add(scope[i].Master_Rep_Id__c);
            }
            
            accountReceivableList=[select id, Master_Rep_ID__c,Original_Rep_ID_c__c from Account_Receivable__c where Original_Rep_ID_c__c in : ids];   // Getting Account Receivable records
            
            if(accountReceivableList.size()>0) {
                
                for(Integer i=0;i<accountReceivableList.size();i++) {
                    
                    if(accountReceivableList[i].Original_Rep_ID_c__c!=null) {
                        
                        loanARMap.put(accountReceivableList[i].Original_Rep_ID_c__c,accountReceivableList[i]);
                        
                    }
                    
                }
                
            }
            System.debug('loanARMap'+loanARMap.size());
            System.debug('accountReceivableList'+accountReceivableList.size());
            
            if(scope.size()>=1) {
                
                System.debug('scope'+scope.size());
                
                for(collect__Loan_Account__c clContract:scope) {
                    
                    if(accountReceivableList.size()==0 ){ //Checking AR Object having any data or not
                        
                        Account_Receivable__c ar=new Account_Receivable__c();                    
                        ar.Name= clContract.Name;
                        ar.Balances_Less_than_120_Days__c = clContract.Less_Than_120_Days__c;
                        ar.Balances_Greater_than_120_days__c = clContract.Greater_Than_120_Days__c;
                        ar.Total_Account_Receivables__c = clContract.Total_AR_Balance__c;
                        ar.Advisor__c = clContract.collect__Contact__r.Id; // UT - Need to check regarding this field as per the file
                        ar.Forgivable_Loan__c = clContract.Forgivable_Loan__c;
                        ar.Repayable_Loan__c = clContract.Repayable_Loan__c;
                        ar.Non_Loan__c = clContract.Non_Loan__c;
                        ar.Master_Rep_ID__c =clContract.collect__External_ID__c;
                        ar.Original_Rep_ID_c__c=clContract.Master_Rep_Id__c;
                      // CH-02 start 
                        if(clContract.collect__External_ID__c!=null){
                            String datevalue=clContract.collect__External_ID__c;
                            List<String> splitdatevalue=datevalue.split('#');
                            
                            datevalue =splitdatevalue[splitdatevalue.size()-1];
                            System.debug('Final datevalue >>'+datevalue);
                            ar.As_of_Date__c=datevalue;
                        }
                         // CH-02 End 
                         // 
                        
                        ar_Map.put(ar.Original_Rep_ID_c__c,ar);
                        arList.add(ar);
                        System.debug('arList1  >>'+arList.size());
                        
                    }
                    
                    else {                    
                        
                        if(loanARMap.size()>0) {                                        
                            
                            if(!loanARMap.containsKey(clContract.Master_Rep_Id__c)) { // If loanARMap does not contain clContract.Name then insert record into Account Receivableobject.
                                
                                System.debug('Inside if statement');
                                
                                Account_Receivable__c ar=new Account_Receivable__c();                    
                                ar.Name= clContract.Name;
                                ar.Balances_Less_than_120_Days__c = clContract.Less_Than_120_Days__c;
                                ar.Balances_Greater_than_120_days__c = clContract.Greater_Than_120_Days__c;
                                ar.Total_Account_Receivables__c = clContract.Total_AR_Balance__c;
                                ar.Advisor__c = clContract.collect__Contact__r.Id; // UT - Need to check regarding this field as per the file
                                ar.Forgivable_Loan__c = clContract.Forgivable_Loan__c;
                                ar.Repayable_Loan__c = clContract.Repayable_Loan__c;
                                ar.Non_Loan__c = clContract.Non_Loan__c;   
                                ar.Master_Rep_ID__c =clContract.collect__External_ID__c;
                          ar.Original_Rep_ID_c__c=clContract.Master_Rep_Id__c;
                                
                                  // CH-02 start 
                                if(clContract.collect__External_ID__c!=null){
                                    String datevalue=clContract.collect__External_ID__c;
                                    List<String> splitdatevalue=datevalue.split('#');
                                    
                                    datevalue =splitdatevalue[splitdatevalue.size()-1];
                                    System.debug('Final datevalue >>'+datevalue);
                                    ar.As_of_Date__c=datevalue;
                                }
                                // CH-02 End 
                                ar_Map.put(ar.Original_Rep_ID_c__c,ar);
                                arList.add(ar);
                                
                                
                                
                            }
                            else {
                                
                                if(clContract.Master_Rep_Id__c==loanARMap.get(clContract.Master_Rep_Id__c).Original_Rep_ID_c__c) { //here we are checking for existing Account Receivable records and then updating it.  
                                    
                                    Account_Receivable__c ar=new Account_Receivable__c();                    
                                    ar.Name= clContract.Name;
                                    ar.Balances_Less_than_120_Days__c = clContract.Less_Than_120_Days__c;
                                    ar.Balances_Greater_than_120_days__c = clContract.Greater_Than_120_Days__c;
                                    ar.Total_Account_Receivables__c = clContract.Total_AR_Balance__c;
                                    ar.Advisor__c = clContract.collect__Contact__r.Id; // UT - Need to check regarding this field as per the file
                                    ar.Forgivable_Loan__c = clContract.Forgivable_Loan__c;
                                    ar.Repayable_Loan__c = clContract.Repayable_Loan__c;
                                    ar.Non_Loan__c = clContract.Non_Loan__c;
                                    ar.Master_Rep_ID__c =clContract.collect__External_ID__c;
                                   ar.Original_Rep_ID_c__c=clContract.Master_Rep_Id__c;
                                    ar.Id=loanARMap.get(clContract.Master_Rep_Id__c).Id; //adding salesforce ids of Account Receivable records                    
                                    
                                    System.debug('In else arList'+arList.size()+arList);
                                      // CH-02 start 
                                    if(clContract.collect__External_ID__c!=null){
                                        String datevalue=clContract.collect__External_ID__c;
                                        List<String> splitdatevalue=datevalue.split('#');
                                        datevalue =splitdatevalue[splitdatevalue.size()-1];
                                        System.debug('Final datevalue >>'+datevalue);
                                        ar.As_of_Date__c=datevalue;
                                    }
                                    // CH-02 End 
                                    ar_Map.put(ar.Original_Rep_ID_c__c,ar);
                                    arList.add(ar);
                                    
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                if(ar_Map.size()>0) {
                    
                    System.debug('arListdata'+arList);
                    FinalarList = ar_Map.values();
                    Database.upsert(FinalarList);//modified to upsert to insert or update data.
                    
                }
            }     
            
        }
        catch(Exception e) {
            
            //LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_LoanAR_TransferObjectdata','execute',e.getMessage(),''+e.getLineNumber(),e.getTypeName());
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_LoanAR_TransferObjectdata','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());//modified by vaibhav
        }
        
    }   
    
    
    global void finish(Database.BatchableContext BC) {
        
        try {
            
            System.debug('in finsish method');
            AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors,  JobItemsProcessed,
                              TotalJobItems, CreatedBy.Email
                              from AsyncApexJob where Id =:BC.getJobId()];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
            mail.setSubject('LPL_Batch_LoanAR_TransferObjectdata Batch class status ' + a.Status);
            mail.setPlainTextBody('LPL_Batch_LoanAR_TransferObjectdata Batch class records processed ' + a.TotalJobItems +
                                  ' with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
        }
        catch(Exception e) {
            
            //LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_LoanAR_TransferObjectdata','finish',e.getMessage(),''+e.getLineNumber(),e.getTypeName());
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_LoanAR_TransferObjectdata','finish',e.getMessage(),e.getLineNumber(),e.getTypeName());//modified by vaibhav
        }
        
        
    }
    
    
    
}