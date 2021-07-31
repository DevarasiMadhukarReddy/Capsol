/*
Batch class Name              :CA_BatchHireAndTermDateUpdateFromAccount
Developer Name                :Ashish Gupta
Created Date                  :17 August 2017
Versio No                     :1.0 

Note:Test class-
*/

global class CA_BatchHireAndTermDateUpdateFromAccount implements Database.Batchable<sObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String Query = 'Select Id, Name,Inst_Term_Date__c,Branch_Open_Date__c,Recent_Updated_Hire_and_Term_Date__c from Account where Recent_Updated_Hire_and_Term_Date__c=true';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        Map<ID,Account> accountMap=new Map<ID,Account>();
        Set<Account> accSet=new Set<Account>();
        
        for(Account acc : Scope){
            
            accountMap.put(acc.Id,acc);   
        }
        
        List<Contract_Accommodation__c> NewContractAccommodationList= new List<Contract_Accommodation__c>(); 
        // Getting data from Contract Accommodation for specific account 
        List<Contract_Accommodation__c> ContractAccommodationList  =[Select Id,Account__c, Name,Term_Date__c ,Hire_Date__c from Contract_Accommodation__c where Account__c in: accountMap.keyset()];
        
        for(Contract_Accommodation__c CAObj : ContractAccommodationList){
            
            // update Hire and term date field from Account.
            if(CAObj.Account__c==accountMap.get(CAObj.Account__c).id) {
                
                CAObj.Hire_Date__c=accountMap.get(CAObj.Account__c).Branch_Open_Date__c;
                CAObj.Term_Date__c=accountMap.get(CAObj.Account__c).Inst_Term_Date__c;
                
                // Unchecked  Recent_Updated_Hire_and_Term_Date field
                accountMap.get(CAObj.Account__c).Recent_Updated_Hire_and_Term_Date__c=false;
                accSet.add(accountMap.get(CAObj.Account__c));
                
                NewContractAccommodationList.add(CAObj);
            }
        }
        if(NewContractAccommodationList.size()>0 && NewContractAccommodationList!=null ){
            
            update NewContractAccommodationList;
            
        } 
        if(accSet.size()>0 && accSet!=null ){
            List<Account> accList=new  List<Account>();
            accList.addAll(accSet);
            
            update accList;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}