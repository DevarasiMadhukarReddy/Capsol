@isTest
public class SFA_MarketingCategoryUpdate_batch_Test {
    
    public static Id strRecordTypeC=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    public static Id strRecordTypeL=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();
    
    static testmethod void method1() {
        
Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        List<ELOQUA__Marketing_Activity__c> marketingactivityList=new List<ELOQUA__Marketing_Activity__c>();
        List<ELOQUA__Marketing_Activity__c> marketingactivityListtask=new List<ELOQUA__Marketing_Activity__c>();
        
        contact ct1=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC);
        
        insert ct1;
        
        Lead led1 = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST',RecordTypeId=strRecordTypeL);
        
        insert led1;
        
        ELOQUA__Marketing_Activity__c  em1=new ELOQUA__Marketing_Activity__c();
        em1.name='Marketing Campaign Response';
        em1.ELOQUA__Contact__c=ct1.id;
        marketingactivityList.add(em1);
        
        ELOQUA__Marketing_Activity__c  em11=new ELOQUA__Marketing_Activity__c();
        em11.name='Marketing Campaign Response';
        em11.ELOQUA__Lead__c=led1.id;
        marketingactivityList.add(em11);
                
        //condition for having task in contact and lead
        contact ct2=new contact(lastname = 'lastname2 ',RecordTypeId=strRecordTypeC);
        insert ct2;
        
        Lead led2 = new Lead(Company='Test Lead123', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST3333',RecordTypeId=strRecordTypeL);
        insert led2;
        
        List<task> taskList=new List<task>();
        List<task> taskListlead=new List<task>();
        
        task t1=new task();
        t1.Subject='test subject';
        t1.Status='Completed';
        t1.Priority='Normal';
        t1.ActivityDate=Date.newInstance(2017,06, 11);
        t1.WhoId=ct2.Id;
        t1.Department__c='Business Development';
        t1.Activity_Type__c='IRD Touch';
        t1.Category__c='Call-Internal';
        taskList.add(t1);
        
        task t1a=new task();
        t1a.Subject='test subject';
        t1a.Status='Completed';
        t1a.Priority='Normal';
        t1a.ActivityDate=Date.newInstance(2016,04, 04);
        t1a.WhoId=ct2.Id;
        t1a.Department__c='Business Development';
        t1a.Activity_Type__c='IRD Touch';
        t1a.Category__c='Call-Internal';
        taskList.add(t1a);
        
        task t1b=new task();
        t1b.Subject='test subject';
        t1b.Status='Completed';
        t1b.Priority='Normal';
        t1b.ActivityDate=Date.newInstance(2017,03,03);
        t1b.WhoId=ct2.Id;
        t1b.Department__c='Business Development';
        t1b.Activity_Type__c='IRD Touch';
        t1b.Category__c='Call-Internal';
        taskList.add(t1b);
                
        task t2=new task();
        t2.Subject='test subject';
        t2.Status='Completed';
        t2.Priority='Normal';
        t2.ActivityDate=Date.newInstance(2017,06, 11);
        t2.WhoId=led2.Id;
        t2.Department__c='Business Development';
        t2.Activity_Type__c='IRD Touch';
        t2.Category__c='Call-Internal';
        taskListlead.add(t2);
        
        task t2a=new task();
        t2a.Subject='test subject';
        t2a.Status='Completed';
        t2a.Priority='Normal';
        t2a.ActivityDate=Date.newInstance(2016,05, 05);
        t2a.WhoId=led2.Id;
        t2a.Department__c='Business Development';
        t2a.Activity_Type__c='IRD Touch';
        t2a.Category__c='Call-Internal';
        taskListlead.add(t2a);
        
        task t2b=new task();
        t2b.Subject='test subject';
        t2b.Status='Completed';
        t2b.Priority='Normal';
        t2b.ActivityDate=Date.newInstance(2017,03,03);
        t2b.WhoId=led2.Id;
        t2b.Department__c='Business Development';
        t2b.Activity_Type__c='IRD Touch';
        t2b.Category__c='Call-Internal';
        taskListlead.add(t2b);
        
    //    insert taskListlead;
        insert taskList;
        
        ELOQUA__Marketing_Activity__c  em12=new ELOQUA__Marketing_Activity__c();
        em12.name='Marketing Campaign Response';
        em12.ELOQUA__Contact__c=ct2.id;
        marketingactivityList.add(em12);
        
        ELOQUA__Marketing_Activity__c  em13=new ELOQUA__Marketing_Activity__c();
        em13.name='Marketing Campaign Response';
        em13.ELOQUA__Lead__c=led2.id;
        marketingactivityList.add(em13);
        
        insert marketingactivityList;
        
        test.startTest();
            
            SFA_MarketingCategoryUpdate_batch batchObj=new SFA_MarketingCategoryUpdate_batch();
            Database.executeBatch(batchObj);
        
        test.stopTest();
    }
}