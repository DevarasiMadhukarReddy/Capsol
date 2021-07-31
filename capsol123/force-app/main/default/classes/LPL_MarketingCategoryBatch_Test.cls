@isTest
public class LPL_MarketingCategoryBatch_Test {
     public static Id strRecordTypeC=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    
    static testmethod void method1() {
         List<ELOQUA__Marketing_Activity__c> marketingactivityList=new List<ELOQUA__Marketing_Activity__c>();
         List<task> taskList=new List<task>();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        contact ct1=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC);
       
        insert ct1;
        
        ELOQUA__Marketing_Activity__c  em1=new ELOQUA__Marketing_Activity__c();
        em1.name='Marketing Campaign Response';
        em1.ELOQUA__Contact__c=ct1.id;
        em1.ELOQUA__Activity_Date__c=system.today()-5;
        marketingactivityList.add(em1);
        
       insert marketingactivityList;
            contact ct2=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC);
       
        insert ct2;
         
        task t1=new task();
        t1.Subject='test subject';
        t1.Status='Not Started';
        t1.Priority='Normal';
        t1.ActivityDate=Date.newInstance(2017,06, 11);
        t1.WhoId=ct2.Id;
        t1.Department__c='Business Development';
        t1.Activity_Type__c='BDA Touch';
        t1.Category__c='Call-Internal';
        taskList.add(t1);
        
        insert taskList;
     
        
          test.startTest();
            
            LPL_MarketingCategoryBatch batchObj=new LPL_MarketingCategoryBatch();
            Database.executeBatch(batchObj);
        
        test.stopTest();
        
    }

    static testmethod void method2() {
        
         Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;

          List<ELOQUA__Marketing_Activity__c> marketingactivityList1=new List<ELOQUA__Marketing_Activity__c>();
         List<task> taskList1=new List<task>();
        contact ct3=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC);
       
        insert ct3;        
        
        contact ct4=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC);
       
        insert ct4;        
   
        task t2=new task();
        t2.Subject='test subject';
        t2.Status='Not Started';
        t2.Priority='Normal';
        t2.ActivityDate=Date.newInstance(2017,06, 11);
        t2.WhoId=ct3.Id;
        t2.Department__c='Business Development';
        t2.Activity_Type__c='BDA Touch';
        t2.Category__c='Call-Internal';
        taskList1.add(t2);
        
        insert taskList1;
        
        
          ELOQUA__Marketing_Activity__c  em2=new ELOQUA__Marketing_Activity__c();
        em2.name='Marketing Campaign Response';
        em2.ELOQUA__Contact__c=ct3.id;
        em2.ELOQUA__Activity_Date__c=system.today()-5;
        marketingactivityList1.add(em2);
        
       insert marketingactivityList1;
         test.startTest();
            
         LPL_MarketingCategory_Scheduler batchObj=new LPL_MarketingCategory_Scheduler();            
            String sch = '0 0 23 * * ?'; 
            system.schedule('TestCheck',sch,batchObj); 
        
            //LPL_MarketingCategoryBatch batchObj=new LPL_MarketingCategoryBatch();
        //  Database.executeBatch(batchObj);
        
        test.stopTest();
        
    }
    
}