/*
#############################Change History####################
Requirement                                                   Developer Name                   Date
---------------------------------------------------------------------------------------------------------------------
CH-01 Exception log Fix Issue:                                Vaibhav Wadhai                17/08/2017
      (Class Name was different in processFinally method)
      chaged to 'LPL_AccountConRelationTriggerGateway'
Ch-02 Fixed an issue where duplicates were present in Account list to be updated.
*/
public with sharing class LPL_AccountConRelationTriggerGateway{
    
    Map<ID, AccountContactRelation> conACMap = new Map<ID, AccountContactRelation>();
    Set<ID> accMapID = new Set<ID>();
    Map<ID, Account> accNameMap = new Map<ID, Account>();
    List<Contact> conList = new List<Contact>();
    Map<ID, Contact> updConMap = new Map<ID, Contact>();
    List<AccountContactRelation> accountContactRelationList = new List<AccountContactRelation>();
    List<Account> accountList; 
    Map<ID, Account> updAccMap = new Map<ID, Account>();
    Map<ID, Account> updAccNewMap = new Map<ID, Account>();
    
    public void collectRecordToProcess(List<AccountContactRelation> acRelList){
        try{
            System.debug('acRelList:'+acRelList);
            for(AccountContactRelation acr : acRelList){
                conACMap.put(acr.ContactID, acr);
                accMapID.add(acr.AccountID);     
            }
            
            for(Account acc: [Select id , Name from Account where Id in: accMapID ]){
                accNameMap.put(acc.Id, acc);
            }
            
            conList = [Select Id, Institutional_Group__c, Is_Institutional_Group_Updated__c from Contact where Id in:  conACMap.keyset()];
            
            // List of Account Contact relationship that have in  Account. 
            
            //accountContactRelationList = [Select id,ContactId from AccountContactRelation where AccountId In : accMapID AND Skip_From_Trigger__c = False];
            
            accountList = [Select id, Number_of_Contacts__c from Account where Id In : accMapID AND Skip_From_Trigger__c = False];
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    public Void handleContactUpdate(){
        
        try{
            if(conList.size() != 0){
                for(Contact con : conList){
                    if(con.Is_Institutional_Group_Updated__c == false && !updConMap.KeySet().Contains(con.ID)){
                        con.Institutional_Group__c = accNameMap.get(conACMap.get(con.ID).AccountID).Name;
                        updConMap.put(con.ID, con);
                    }
                }
            }
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    
    
    
    public void reduceCountAccountContactRelationship(List<AccountContactRelation> acRelList){
        try{
            if(!accountList.isEmpty()){
                for(Account accObj : accountList) {
                    if(accObj.Number_of_Contacts__c != NULL){
                        accObj.Number_of_Contacts__c = accObj.Number_of_Contacts__c-1;
                        updAccMap.put(accObj.id,accObj);
                    }
                }
            }
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    // add code for count
    public void addContactCount() {
        try{
            Integer count=0;
            // count = accountContactRelationList.size();
            for(Account acc: accountList){
                if(acc.Number_of_Contacts__c==null)
                    acc.Number_of_Contacts__c=1;
                else
                    acc.Number_of_Contacts__c += 1;
                updAccNewMap.put(acc.id,acc);
            }
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + ''+e.getLineNumber() +'Cause:' + e.getCause());      
        }   
    }
    
    Public void processFinally(){
        try{
            if(updConMap.size() != 0){
                update updConMap.values();
            }
            
            if(updAccNewMap.size() != 0){
                update updAccNewMap.values();
            }
            if(updAccMap.size() != 0){
                update updAccMap.values();
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_AccountConRelationTriggerGateway','processFinallyOperations',e.getMessage(),e.getLineNumber(),e.getTypeName());  
        }
    }
    
    
    
}