@isTest
public class MarketingCatrgoryContactUpdateNewTest {
    public static Id strRecordTypeC;
    public static Id strRecordTypeL;
    
    static testmethod void  method1(){
        
Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        strRecordTypeC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();
        
        //condition for not having tasks
        /*contact ct1=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC);
        insert ct1;                
        Lead led1 = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST',
                                 RecordTypeId=strRecordTypeL);
        insert led1;
                
        ELOQUA__Marketing_Activity__c  em1=new ELOQUA__Marketing_Activity__c();
        em1.name='Marketing Campaign Response';
        em1.ELOQUA__Contact__c=ct1.id;
        insert em1;
        
        ELOQUA__Marketing_Activity__c  em11=new ELOQUA__Marketing_Activity__c();
        em11.name='Marketing Campaign Response';
        em11.ELOQUA__Lead__c=led1.id;
        insert em11;
        Contact con1=[select id,Marketing_Category__c from contact where id=:ct1.Id];
        con1.Marketing_Category__c='New';        
        update con1;
        lead ld1=[select id,Marketing_Category__c from lead where id=:led1.id];
        ld1.Marketing_Category__c='New';
        update led1;
        */
        //condition for having task in contact
        contact ct2=new contact(lastname = 'lastname2 ',RecordTypeId=strRecordTypeC);
        insert ct2;
        
        List<task> taskList=new List<task>();
        task t1=new task();
        t1.Subject='test subject';
        t1.Status='Not Started';
        t1.Priority='Normal';
        t1.ActivityDate=Date.newInstance(2017,06, 11);
        t1.WhoId=ct2.Id;
        t1.Department__c='Business Development';
        t1.Activity_Type__c='IRD Touch';
        t1.Category__c='Call-Internal';
        taskList.add(t1);
        task t1a=new task();
        t1a.Subject='test subject';
        t1a.Status='Not Started';
        t1a.Priority='Normal';
        t1a.ActivityDate=Date.newInstance(2016,04, 04);
        t1a.WhoId=ct2.Id;
        t1a.Department__c='Business Development';
        t1a.Activity_Type__c='IRD Touch';
        t1a.Category__c='Call-Internal';
        taskList.add(t1a);
        task t1b=new task();
        t1b.Subject='test subject';
        t1b.Status='Not Started';
        t1b.Priority='Normal';
        t1b.ActivityDate=Date.newInstance(2017,03,03);
        t1b.WhoId=ct2.Id;
        t1b.Department__c='Business Development';
        t1b.Activity_Type__c='IRD Touch';
        t1b.Category__c='Call-Internal';
        taskList.add(t1b);
        insert taskList;
        
        ELOQUA__Marketing_Activity__c  em12=new ELOQUA__Marketing_Activity__c();
        em12.name='Marketing Campaign Response';
        em12.ELOQUA__Contact__c=ct2.id;
        insert em12;
        
        ELOQUA__Marketing_Activity__c emUp=[select id,ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c where id=:em12.id];
        emUp.ELOQUA__Contact__c=ct2.id;
        update emUp;
       
        Contact con11=[select id,Marketing_Category__c from contact where id=:ct2.Id];
        con11.Marketing_Category__c='Active';        
        update con11;
        
        //data for having task in lead
        Lead led2 = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST3',
                                 RecordTypeId=strRecordTypeL);
        insert led2;
        List<task> tasklistlead=new List<task>();
        task t2=new task();
        t2.Subject='test subject';
        t2.Status='Not Started';
        t2.Priority='Normal';
        t2.ActivityDate=Date.newInstance(2017,06, 11);
        t2.WhoId=led2.Id;
        t2.Department__c='Business Development';
        t2.Activity_Type__c='IRD Touch';
        t2.Category__c='Call-Internal';
        tasklistlead.add(t2);
          task t2a=new task();
        t2a.Subject='test subject';
        t2a.Status='Not Started';
        t2a.Priority='Normal';
        t2a.ActivityDate=Date.newInstance(2016,05, 05);
        t2a.WhoId=led2.Id;
        t2a.Department__c='Business Development';
        t2a.Activity_Type__c='IRD Touch';
        t2a.Category__c='Call-Internal';
        tasklistlead.add(t2a);
          task t2b=new task();
        t2b.Subject='test subject';
        t2b.Status='Not Started';
        t2b.Priority='Normal';
        t2b.ActivityDate=Date.newInstance(2017,03,03);
        t2b.WhoId=led2.Id;
        t2b.Department__c='Business Development';
        t2b.Activity_Type__c='IRD Touch';
        t2b.Category__c='Call-Internal';
        tasklistlead.add(t2b);
        insert tasklistlead;
        
        ELOQUA__Marketing_Activity__c  em13=new ELOQUA__Marketing_Activity__c();
        em13.name='Marketing Campaign Response';
        em13.ELOQUA__Lead__c=led2.id;
        insert em13;
        
        ELOQUA__Marketing_Activity__c emUp1=[select id,ELOQUA__Lead__c from ELOQUA__Marketing_Activity__c where id=:em13.id];
        emUp1.ELOQUA__Lead__c=led2.id;
        update emUp1;
        
        lead lead11=[select id,Marketing_Category__c from lead where id=:led2.Id];
        lead11.Marketing_Category__c='Active';        
        update lead11;
    }
    
    static testmethod void method2(){
        
Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        //data for contact
        strRecordTypeC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();
        contact ct2=new contact(lastname = 'lastname3 ',RecordTypeId=strRecordTypeC);
        insert ct2;                
        task t1=new task();
        t1.Subject='test subject';
        t1.Status='Not Started';
        t1.Priority='Normal';
        t1.ActivityDate=Date.newInstance(2017,06, 11);
        t1.WhoId=ct2.Id;
        t1.Department__c='Business Development';
        t1.Activity_Type__c='IRD Touch';
        t1.Category__c='Call-Internal';
        insert t1;
        
        ELOQUA__Marketing_Activity__c  em12=new ELOQUA__Marketing_Activity__c();
        em12.name='Marketing Campaign Response';
        em12.ELOQUA__Contact__c=ct2.id;
        insert em12;
        
        ELOQUA__Marketing_Activity__c emUp=[select id,ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c where id=:em12.id];
        emUp.ELOQUA__Contact__c=ct2.id;
        update emUp;
       
        Contact con11=[select id,Marketing_Category__c from contact where id=:ct2.Id];
        con11.Marketing_Category__c='Active';        
        update con11;
        
        // data for lead
        Lead led2 = new Lead(Company='Test Lead123', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST3333',
                                 RecordTypeId=strRecordTypeL);
        insert led2;
        task t2=new task();
        t2.Subject='test subject';
        t2.Status='Not Started';
        t2.Priority='Normal';
        t2.ActivityDate=Date.newInstance(2017,06, 11);
        t2.WhoId=led2.Id;
        t2.Department__c='Business Development';
        t2.Activity_Type__c='IRD Touch';
        t2.Category__c='Call-Internal';
        insert t2;
        
        ELOQUA__Marketing_Activity__c  em13=new ELOQUA__Marketing_Activity__c();
        em13.name='Marketing Campaign Response';
        em13.ELOQUA__Lead__c=led2.id;
        insert em13;
        
         ELOQUA__Marketing_Activity__c emUp1=[select id,ELOQUA__Lead__c from ELOQUA__Marketing_Activity__c where id=:em13.id];
        emUp1.ELOQUA__Lead__c=led2.id;
        update emUp1;
        
        lead lead11=[select id,Marketing_Category__c from lead where id=:led2.Id];
        lead11.Marketing_Category__c='Active';        
        update lead11;
    }
    static testMethod void method3(){
        
       /* strRecordTypeC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();
        contact ct3=new contact(lastname = 'lastname31 ',RecordTypeId=strRecordTypeC);
        insert ct3;
        
        task t3=new task();
        t3.Subject='test subject';
        t3.Status='Not Started';
        t3.Priority='Normal';
        t3.ActivityDate=Date.newInstance(2018,06, 11);
        t3.WhoId=ct3.Id;
        t3.Department__c='Business Consultancy';
        t3.Activity_Type__c='IRD Touch';
        t3.Category__c='Call-Internal';
        insert t3;
        
        ELOQUA__Marketing_Activity__c  em13=new ELOQUA__Marketing_Activity__c();
        em13.name='Marketing Campaign Response';
        em13.ELOQUA__Contact__c=ct3.id;
        insert em13;
        
        ELOQUA__Marketing_Activity__c emUp3=[select id,ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c where id=:em13.id];
        emUp3.ELOQUA__Contact__c=ct3.id;
        update emUp3;
       
        Contact con13=[select id,Marketing_Category__c from contact where id=:ct3.Id];
        con13.Marketing_Category__c='Active';        
        update con13;
        
        contact ct4=new contact(lastname = 'lastname314 ',RecordTypeId=strRecordTypeC);
        insert ct4;
        
        task t4=new task();
        t4.Subject='test subject';
        t4.Status='Not Started';
        t4.Priority='Normal';
        t4.ActivityDate=Date.newInstance(2018,06, 11);
        t4.WhoId=ct3.Id;
        t4.Department__c='Business Development';
        t4.Activity_Type__c='BDA';
        t4.Category__c='Call-Internal';
        insert t4;
        
        ELOQUA__Marketing_Activity__c  em131=new ELOQUA__Marketing_Activity__c();
        em131.name='Marketing Campaign Response';
        em131.ELOQUA__Contact__c=ct4.id;
        insert em131;
        
        ELOQUA__Marketing_Activity__c emUp31=[select id,ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c where id=:em131.id];
        emUp31.ELOQUA__Contact__c=ct4.id;
        update emUp31;
       
        Contact con131=[select id,Marketing_Category__c from contact where id=:ct4.Id];
        con131.Marketing_Category__c='Active';        
        update con131;
        
        
        contact ct5=new contact(lastname = 'lastname315 ',RecordTypeId=strRecordTypeC);
        insert ct5;
        
        task t5=new task();
        t5.Subject='test subject';
        t5.Status='Not Started';
        t5.Priority='Normal';
        t5.ActivityDate=Date.newInstance(2018,06, 11);
        t5.WhoId=ct3.Id;
        t5.Department__c='Business Development';
        t5.Activity_Type__c='BDA';
        t5.Category__c='Social Media Outreach';
        insert t5;
        
        ELOQUA__Marketing_Activity__c  em1315=new ELOQUA__Marketing_Activity__c();
        em1315.name='Marketing Campaign Response';
        em1315.ELOQUA__Contact__c=ct5.id;
        insert em1315;
        
        ELOQUA__Marketing_Activity__c emUp315=[select id,ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c where id=:em1315.id];
        emUp315.ELOQUA__Contact__c=ct4.id;
        update emUp315;
       
        Contact con1315=[select id,Marketing_Category__c from contact where id=:ct5.Id];
        con1315.Marketing_Category__c='Active';        
        update con1315;
*/
    }
    static testmethod void method4(){
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        strRecordTypeC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();
        
        Lead led24 = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST34',
                                 RecordTypeId=strRecordTypeL);
        insert led24;
        task t24=new task();
        t24.Subject='test subject';
        t24.Status='Not Started';
        t24.Priority='Normal';
        t24.ActivityDate=Date.newInstance(2017,06, 11);
        t24.WhoId=led24.Id;
        t24.Department__c='Business Consultancy';
        t24.Activity_Type__c='IRD Touch';
        t24.Category__c='Call-Internal';
        insert t24;
        
        ELOQUA__Marketing_Activity__c  em134=new ELOQUA__Marketing_Activity__c();
        em134.name='Marketing Campaign Response';
        em134.ELOQUA__Lead__c=led24.id;
        insert em134;
        
        lead lead114=[select id,Marketing_Category__c from lead where id=:led24.Id];
        lead114.Marketing_Category__c='Active';        
        update lead114;
    }
    static testmethod void method5(){
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        strRecordTypeC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();
        contact ct3=new contact(lastname = 'lastname315 ',RecordTypeId=strRecordTypeC);
        insert ct3;
        
        task t3=new task();
        t3.Subject='test subject';
        t3.Status='Not Started';
        t3.Priority='Normal';
        t3.ActivityDate=Date.newInstance(2017,05, 11);
        t3.WhoId=ct3.Id;
        t3.Department__c='Business Development';
        t3.Activity_Type__c='IRD Touch';
        t3.Category__c='Call-Internal';
        insert t3;
        
        ELOQUA__Marketing_Activity__c  em13=new ELOQUA__Marketing_Activity__c();
        em13.name='Marketing Campaign Response';
        em13.ELOQUA__Contact__c=ct3.id;
        insert em13;
        
        ELOQUA__Marketing_Activity__c emUp3=[select id,ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c where id=:em13.id];
        emUp3.ELOQUA__Contact__c=ct3.id;
        update emUp3;
       
        Contact con13=[select id,Marketing_Category__c from contact where id=:ct3.Id];
        con13.Marketing_Category__c='Active';        
        update con13;
    }
    static testmethod void bulkification(){
        
Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        strRecordTypeC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();
        contact ctb=new contact(lastname = 'lastname315 ',RecordTypeId=strRecordTypeC);
        insert ctb;
        
        List<ELOQUA__Marketing_Activity__c> MarketingActivitylist=new list<ELOQUA__Marketing_Activity__c>();
        List<ELOQUA__Marketing_Activity__c> MarketingActivitylistUpdate=new list<ELOQUA__Marketing_Activity__c>();
        Set<id> idsets=new set<id>();
        for(integer i=0;i<50;i++){
           ELOQUA__Marketing_Activity__c  em13=new ELOQUA__Marketing_Activity__c();
            em13.name='Marketing Campaign Response';
            em13.ELOQUA__Contact__c=ctb.id;
            MarketingActivitylist.add(em13);
        }
        insert MarketingActivitylist;
        system.assert(MarketingActivitylist.size()>0,'sucesss'+MarketingActivitylist.size());
        system.assert(MarketingActivitylist.size()==50);
        
        for(integer i=0;i<MarketingActivitylist.size();i++){
            idsets.add(MarketingActivitylist[i].id);
        }
        for(ELOQUA__Marketing_Activity__c emUp3:[select id,ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c where id in : idsets])
        {
            emUp3.ELOQUA__Contact__c=ctb.id;
            MarketingActivitylistUpdate.add(emUp3);
        }
        update MarketingActivitylistUpdate;
        system.assert(MarketingActivitylistUpdate.size()==50);
    }
}