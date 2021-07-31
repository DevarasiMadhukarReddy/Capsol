/*
Batch class Name              :CA_BatchHireAndTermDateUpdateFromContact
Developer Name                :Ashish Gupta
Created Date                  :17 August 2017
Versio No                     :1.0 

Note:Test class-
*/

global class CA_BatchHireAndTermDateUpdateFromContact implements Database.Batchable<sObject> {

      
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String Query = 'Select Id, Name,Hire_Date__c,Term_Date__c,Recent_Updated_Hire_and_Term_Date__c from Contact where Recent_Updated_Hire_and_Term_Date__c=true';
        
        return Database.getQueryLocator(query);
    }
    
      global void execute(Database.BatchableContext BC, List<Contact> scope){
           Map<ID,Contact> contactMap=new Map<ID,Contact>();
            Set<Contact> conSet=new Set<Contact>();
           for(Contact contact : Scope){
               
            contactMap.put(contact.Id,contact);   
        }
        
           List<Contract_Accommodation__c> NewContractAccommodationList= new List<Contract_Accommodation__c>(); 
              // Getting data from Contract Accommodation for specific Contact
              List<Contract_Accommodation__c> ContractAccommodationList  =[Select Id,Contact_Name__c, Name,Term_Date__c ,Hire_Date__c from Contract_Accommodation__c where Contact_Name__c in:contactMap.keyset()];
          
            for(Contract_Accommodation__c CAObj : ContractAccommodationList){
                System.debug('CAObj object>>'+CAObj);
                  // update Hire and term date field from Contact.
                if(CAObj.Contact_Name__c==contactMap.get(CAObj.Contact_Name__c).id) {
                System.debug('Inside if clause hire date >>'+contactMap.get(CAObj.Contact_Name__c).Hire_Date__c);
                System.debug('Inside if clause Term date>>'+contactMap.get(CAObj.Contact_Name__c).Term_Date__c);
                    
                    CAObj.Hire_Date__c=contactMap.get(CAObj.Contact_Name__c).Hire_Date__c;
                    CAObj.Term_Date__c=contactMap.get(CAObj.Contact_Name__c).Term_Date__c;
                    
                    // Unchecked  Recent_Updated_Hire_and_Term_Date field
                    contactMap.get(CAObj.Contact_Name__c).Recent_Updated_Hire_and_Term_Date__c=false;
                   
                      System.debug('checkbox status value >>'+contactMap.get(CAObj.Contact_Name__c).Recent_Updated_Hire_and_Term_Date__c);
                      System.debug('contact data >>'+contactMap.get(CAObj.Contact_Name__c));
                     conSet.add(contactMap.get(CAObj.Contact_Name__c));   
                    NewContractAccommodationList.add(CAObj);
                }
        }
      
           if(NewContractAccommodationList.size()>0 && NewContractAccommodationList!=null ){
            System.debug('NewContractAccommodationList >>'+NewContractAccommodationList);
            update NewContractAccommodationList;
            
        } 
          if(conSet.size()>0 && conSet!=null ){
            List<Contact> conList=new  List<Contact>();
            conList.addAll(conSet);
             System.debug('Contact list >>'+conList);
            update conList;
        }
  
      }

     global void finish(Database.BatchableContext BC){
         
        Id batchJobId = Database.executeBatch(new CA_BatchHireAndTermDateUpdateFromAccount(),100);
         
    }
    
}