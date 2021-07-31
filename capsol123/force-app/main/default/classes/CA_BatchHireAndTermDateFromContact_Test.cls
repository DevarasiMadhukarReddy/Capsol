/*
Batch class Name              :CA_BatchHireAndTermDateUpdateFromContact
Developer Name                :Ashish Gupta
Created Date                  :21 August 2017
Versio No                     :1.0 

*/
@isTest(seeAllData=false)
public class CA_BatchHireAndTermDateFromContact_Test {
    
    static testMethod void validateMethod() {
       
        List<User> u = [select Id from User where CA_Created_By_Manager__c = true Limit 1];
        
        Trigger_Bypass__c Triggerbypass=new Trigger_Bypass__c();
        Triggerbypass.Name='Contact';
        Triggerbypass.isOff__C=false;
        insert Triggerbypass;        
        list<Contact>conList=new list<Contact>();
        
        for(Integer i=0; i<10; i++){
            
            Contact cObj=new Contact();
            cObj.LastName ='Name'+i;
            cObj.Hire_Date__c=date.ValueOf('2017-09-21');
            cObj.Term_Date__c=date.ValueOf('2017-09-22');
            cObj.Recent_Updated_Hire_and_Term_Date__c=true;
            conList.add(cObj);
            
        }
        insert conList;
        
        list<Contract_Accommodation__c>caList=new list<Contract_Accommodation__c>();
        list<Contract_Accommodation__c>caList2=new list<Contract_Accommodation__c>();
        for(integer index=0; index<conList.size(); index++){
            
            Contract_Accommodation__c caObj=new Contract_Accommodation__c();
            //caObj.name='test Contact'+index;
            caObj.Contact_Name__c=conList[index].ID;     
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
            caObj.Created_By_Manager__c = u[0].id;
           
            
            caList.add(caObj);
            
        }
        insert caList;   
        
        
        test.startTest();
        
        CA_BatchHireAndTermDateUpdateFromContact batchObj=new CA_BatchHireAndTermDateUpdateFromContact();
        Database.executeBatch(batchObj);
        
        Test.stopTest();
        
    } 
}