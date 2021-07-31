/* 
* @Author      : Manila Agnihotri(Cognizant)
* @version     : 1.0
* @CreatedDate : Sept 21 ,2018
* Purpose      : To hold test data for test classes
*/
public with sharing class LPL_testDataSetUpUtility {
    
    public static Task createTask(Id conId,Id uId) {
        Task tsk = new Task(whoId = conId, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = date.newInstance(2018, 01, 12), Status = 'Completed', OwnerId = uId,Department__c='Business Consulting');
        return tsk;
    }
    
    public static Task createTaskCheck(Id oppId,Id uId) {
        Task tsk = new Task(whatId = oppId, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = date.newInstance(2018, 01, 12), Status = 'Completed', 
                            OwnerId = uId,Department__c='Business Consulting', Category__c = 'Left Message');
        return tsk;
    }
    
    public static Contact createContact(String name,Id accId,Id contactLPLAdvisor) {
        Contact con = new Contact();
        con.LastName = name;
        con.AccountId = accId;
        con.recordTypeId=contactLPLAdvisor;
        return con;
    }
    
    public static Trigger_Bypass__c createTriggerByPass(String name,Boolean isOFF) {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name = name;
        tbp.IsOff__c = isOFF;
        return tbp;
    }
    
    public static Last_Office_BC__c createLastOffice(String roleName,String name) {
        Last_Office_BC__c lastOffice = new Last_Office_BC__c(Role_name__c=roleName,Name=name);
        return lastOffice;
    }
    
    public static IAS_Recruiter_Assignment__c createIAS(Id uId){
        IAS_Recruiter_Assignment__c iasRec = new IAS_Recruiter_Assignment__c(Name='12345',Assigned_Recruiter__c=uId,Internal_Recruiter__c=uId);
        return iasRec;
    }
    
    public static Lead createLead(String name) {
        Lead led= new Lead(LastName=name);
        return led;
    }
    
}