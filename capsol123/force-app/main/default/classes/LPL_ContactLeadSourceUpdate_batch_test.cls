/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
CH-01           Test Class for LPL_contactLeadSourceUpdate_batch                    Manila Agnihotri                    05 March 2018               
*/

@isTest
public class LPL_ContactLeadSourceUpdate_batch_test {
    
    public static Id strRecordTypeC=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    public static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    
    static testmethod void method1() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        List<ELOQUA__Marketing_Activity__c> marketingactivityList=new List<ELOQUA__Marketing_Activity__c>();
        List<task> taskList=new List<task>();
        
        Account Acct  = new Account ();
        Acct.Name ='Account Test';
        insert Acct;
        contact ct1=new contact(AccountId = Acct.id,Dynamic_Channel__c='BN',lastname = 'lastname3',RecordTypeId=strRecordTypeC, Marketing_Category__c=null,Lead_source__c=null);
        insert ct1;
        // Marketing Activity insert
        ELOQUA__Marketing_Activity__c  em2=new ELOQUA__Marketing_Activity__c();
        em2.name='BD_DisruptionEM';
        em2.ELOQUA__Contact__c=ct1.id;
        em2.createddate=system.now();
        em2.Activity_Status__c='Responded';
        em2.ELOQUA__Activity_Type__c='Campaign';
        marketingactivityList.add(em2);
        insert marketingactivityList;
        
        //Task insert
        task t1=new task();
        t1.Subject='test subject';
        t1.Status='Inprogress';
        t1.Priority='Normal';
        t1.ActivityDate=Date.newInstance(2017,06, 11);
        t1.createddate=Date.newInstance(2017,03,05);
        t1.WhoId=ct1.Id;
        t1.Department__c='Business Development';
        t1.Activity_Type__c='Recruiting';
        t1.Category__c='Call-Outbound';
        taskList.add(t1);
        insert taskList;
        
        test.startTest();
        
        LPL_ContactLeadSourceUpdate_batch batchObj = new LPL_ContactLeadSourceUpdate_batch();            
        Database.executeBatch(batchObj);
        test.stopTest();
    }
    
    static testmethod void method2() {  
        List<ELOQUA__Marketing_Activity__c> marketingactivityList1=new List<ELOQUA__Marketing_Activity__c>();
        List<task> taskList1=new List<task>();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account Acct  = new Account ();
        Acct.Name ='Account Test Record 1';
        insert Acct;
        
        contact ct2=new contact(AccountId = Acct.id,lastname = 'lastname2 ',Referring_Advisor_Rep_ID__c='abcdfr',Referral_Override__c=true,IsReferral__c='Recruit',RecordTypeId=strRecordTypeC, Marketing_Category__c='Dormant',Lead_source__c=null);
        insert ct2;
        
        ELOQUA__Marketing_Activity__c  em2=new ELOQUA__Marketing_Activity__c();
        em2.name='BD_DisruptionEM';
        em2.ELOQUA__Contact__c=ct2.id;
        em2.createddate=system.now()-2;
        em2.Activity_Status__c='Responded';
        em2.ELOQUA__Activity_Type__c='Campaign';
        marketingactivityList1.add(em2);
        insert marketingactivityList1;
        
        task t1a=new task();
        t1a.Subject='test subject';
        t1a.Status='Responded';
        t1a.Priority='Normal';
        t1a.ActivityDate=Date.newInstance(2016,04, 04);
        t1a.WhoId=ct2.Id;
        t1a.Department__c='Business Development';
        t1a.Activity_Type__c='Recruiting';
        t1a.Category__c='Call-Outbound';
        t1a.createddate=system.now();
        taskList1.add(t1a);
        insert taskList1;
        
        test.startTest();
        LPL_ContactLeadSourceUpdate_batch batchObj = new LPL_ContactLeadSourceUpdate_batch();            
        Database.executeBatch(batchObj);
        test.stopTest();
    }
    
    static testmethod void method3(){
        List<task> taskList2=new List<task>();
        List<ELOQUA__Marketing_Activity__c> marketingactivityList2 = new List<ELOQUA__Marketing_Activity__c>();
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        contact ct3=new contact(lastname = 'lastname3',Referral_Override__c=true,IsReferral__c='Wholesaler',Referring_Advisor_Rep_ID__c='Testing',RecordTypeId=strRecordTypeC, Marketing_Category__c=null,Lead_source__c=null);
        insert ct3;
        
        ELOQUA__Marketing_Activity__c  em2=new ELOQUA__Marketing_Activity__c();
        em2.name='BD_DisruptionEM';
        em2.ELOQUA__Contact__c=ct3.Id;
        em2.Activity_Status__c='Responded';
        em2.ELOQUA__Activity_Type__c='Campaign';
        em2.createddate =system.now();
        marketingactivityList2.add(em2);
        insert marketingactivityList2;
        
        task t1a=new task();
        t1a.Subject='test subject';
        t1a.Status='Completed';
        t1a.Priority='Normal';
        t1a.createddate=system.now();
        t1a.ActivityDate=Date.newInstance(2016,04, 04);
        t1a.WhoId=ct3.Id;
        t1a.Department__c='Business Development';
        t1a.Activity_Type__c='Recruiting';
        t1a.Category__c='Call-Inbound';
        taskList2.add(t1a);
        insert taskList2;
        
        test.startTest();
        LPL_ContactLeadSourceUpdate_batch batchObj = new LPL_ContactLeadSourceUpdate_batch();            
        Database.executeBatch(batchObj);
        test.stopTest();     
    }
    
    static testmethod void method4(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        insert oAcct;
        contact ct3=new contact(AccountId = oAcct.id,Dynamic_Channel__c='BN',lastname = 'lastname3',RecordTypeId=strRecordTypeC, Marketing_Category__c=null,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' );
        insert ct3;
        
        Opportunity op1 = new Opportunity(AccountId = oAcct.id, name = 'Test opportunity'
                                          , CloseDate =  system.today() , StageName = '1 - Engaged'
                                          , Zip_Code__c = '84081', GDC_Prior_12_mo__c = 200
                                          , Contact__c = ct3.Id, RecordTypeId = oppRecordTypeId);
        insert op1;
        
        test.startTest();
        LPL_ContactLeadSourceUpdate_batch batchObj = new LPL_ContactLeadSourceUpdate_batch();            
        Database.executeBatch(batchObj);
        test.stopTest(); 
    }
    
    static testmethod void method5(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        contact ct3=new contact(lastname = 'lastname3',Referring_Advisor_Rep_ID__c='abcdfr',Referral_Override__c=true,IsReferral__c='Outside Recruiting Firm',RecordTypeId=strRecordTypeC, Marketing_Category__c=null);
        insert ct3;
        
        List<task> taskListonly=new List<task>();
        task t1a=new task();
        t1a.Subject='test subject';
        t1a.Status='Completed';
        t1a.Priority='Normal';
        t1a.ActivityDate=Date.newInstance(2016,04, 04);
        t1a.WhoId=ct3.Id;
        t1a.Department__c='Business Development';
        t1a.Activity_Type__c='Recruiting';
        t1a.Category__c='Call-Outbound';
        t1a.createddate=system.now();
        taskListonly.add(t1a);
        insert taskListonly;
        
        test.startTest();
        LPL_ContactLeadSourceUpdate_batch batchObj = new LPL_ContactLeadSourceUpdate_batch();            
        Database.executeBatch(batchObj);
        test.stopTest(); 
    }
    
    static testmethod void method6(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        contact ct6=new contact(lastname = 'lastname3',Referring_Advisor_Rep_ID__c='abcdfr',Referral_Override__c=true,IsReferral__c='Recruit',RecordTypeId=strRecordTypeC, Marketing_Category__c=null,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert ct6;
        List<ELOQUA__Marketing_Activity__c> marketingactivityList6 = new List<ELOQUA__Marketing_Activity__c>();
        ELOQUA__Marketing_Activity__c  em6=new ELOQUA__Marketing_Activity__c();
        em6.name='BD_DisruptionEM';
        em6.ELOQUA__Contact__c=ct6.id;
        em6.createddate=system.now();
        em6.Activity_Status__c='Responded';
        em6.ELOQUA__Activity_Type__c='Campaign';
        em6.Placement_ID__c='BN';
        marketingactivityList6.add(em6);
        insert marketingactivityList6;
        
        test.startTest();
        LPL_ContactLeadsourceUpdate_Scheduler batchjob =new LPL_ContactLeadsourceUpdate_Scheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('TestCheck',sch,batchjob);
        test.stopTest();
    }
}