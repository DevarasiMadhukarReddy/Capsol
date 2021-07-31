/*
#############################Change History####################
CH#              Description                                                      Developer Name             Date
----------------------------------------------------------------------------------------------------------------------
Ch-1        Batch test class created to update task on opportunity                Manila Agnihotri           17th May 2018
                 -SD901712 - Create Task      
*/



@isTest
public class LPL_Opportunity_task_batch_test {

    public static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
   
    static testmethod void method1() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        contact ct2=new contact(AccountId=a1.id,lastname = 'lastname2 ',Referring_Advisor_Rep_ID__c='abcdfr',Referral_Override__c=true,IsReferral__c='Recruit',Internal_Recruiter_IRD__c =UserInfo.getUserID(), Marketing_Category__c='Dormant',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert ct2;
        
        Task tsk1 = new Task(whoId = ct2.ID, Subject = 'Disruption Email Click Through Follow Up', ActivityDate = date.newInstance(2018, 01, 12), Status = 'Not Started', OwnerId = ct2.Internal_Recruiter_IRD__c);
        insert tsk1;
         List<Opportunity> oppInsert = new List<Opportunity>();
        Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                        , CloseDate =  system.today(), StageName = 'Closed-Lost'
                                        , Zip_Code__c = '80538', Contact__c= ct2.id
                                        , Internal_Recruiter_IRD__c = ct2.Internal_Recruiter_IRD__c
                                        , Lost_Outcome__c= 'Joined Another Firm'
                                        , GDC_Prior_12_mo__c = 200);
        oppInsert.add(op1);
        insert oppInsert;
       
        test.startTest();
        LPL_Opportunity_task_batch batchObj = new LPL_Opportunity_task_batch();       
        Database.executeBatch(batchObj);
        test.stopTest();
   }
    
     static testmethod void method2() {
       Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        List<Opportunity> oppInsert1 = new List<Opportunity>();
        Opportunity op2 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                        , CloseDate =  system.today()+1, StageName = '2 - Hot List'
                                        , Assigned_Recruiter__c = UserInfo.getUserID()
                                        , Stage_Change_Date__c = date.newInstance(2018, 1, 31));
        oppInsert1.add(op2);
        insert oppInsert1;
         test.startTest();
         LPL_Opportunity_task_Sch batchjob =new LPL_Opportunity_task_Sch();
         String sch = '0 0 23 * * ?'; 
         system.schedule('TestCheck',sch,batchjob);
         test.stopTest();
     }

}