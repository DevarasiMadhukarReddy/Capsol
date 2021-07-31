/*
Batch class Name              :CA_BatchHireAndTermDateUpdateFromAccount
Developer Name                :Ashish Gupta
Created Date                  :22 August 2017
Versio No                     :1.0 

*/
@isTest(seeAllData=false)
public class CA_BatchHireAndTermDateAccount_Test {
    
    
    
    static testMethod void validateMethod() {
    
    
         List<User> u = [select Id from User where CA_Created_By_Manager__c = true Limit 1];
        
        list<Account>accList=new list<Account>();
        
        for(Integer i=0; i<10; i++){
            
            Account accObj=new Account();
            accObj.Name ='Name'+i;
            accObj.Branch_Open_Date__c=date.ValueOf('2017-09-21');
            accObj.Inst_Term_Date__c=date.ValueOf('2017-09-22');
            accObj.Recent_Updated_Hire_and_Term_Date__c=true;
            accList.add(accObj);
            
        }
        insert accList;
        
        
        
        list<Contract_Accommodation__c>caList=new list<Contract_Accommodation__c>();
        list<Contract_Accommodation__c>caList2=new list<Contract_Accommodation__c>();
        for(integer index=0; index<accList.size(); index++){
          
         
            
            Contract_Accommodation__c caObj=new Contract_Accommodation__c();
            //caObj.name='test Contact'+index;
            
            caObj.Account__c= accList[index].ID;  
            caObj.Hire_Date__c=date.ValueOf('2017-09-21');
            caObj.Term_Date__c=date.ValueOf('2017-09-22');
            caObj.Start_Date__c=System.today();
            caObj.End_Date__c=System.today();
            caObj.Approver_Title__c='VP';
            caObj.Payment_method__c='Check';
            caObj.Accommodation_Frequency__c='Monthly';
            caObj.Does_credit_stay_with_individual_or_flow__c='Individual';  
            
            caObj.Annual_GDP_Impact__c=120;
            
            caObj.Accommodation_Requested__c = 'No';
            caObj.Created_By_Manager__c = u[0].Id;
            
            caList.add(caObj);
            
        }
        insert caList;   
        
        test.startTest();
        
        CA_BatchHireAndTermDateUpdateFromAccount batchObj=new CA_BatchHireAndTermDateUpdateFromAccount();
        Database.executeBatch(batchObj);
        
        Test.stopTest();
        
    } 
    
}