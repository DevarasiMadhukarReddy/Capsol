@isTest(SeeAllData=false)
//created By:Vaibhav wadhai
//Date:05/04/2017
public class LPL_LeadTrigger_Test {
       public static Id strRecordTypeL;
       public static Id conRecordTypeId;
    static testMethod void collectRecordToProcessTest(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        ID leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId(); 
        
         List<Lead> leadList=new List<Lead>();
     for(Integer i=0; i<=5; i++)
     {
      Lead leadObj=new Lead();
      leadObj.LastName='Test Lastname'+i;
      leadObj.Company='Test company'+i;
      leadObj.Status='Active - Not ready to communicate - drip';
      leadObj.PostalCode='441227';
      leadObj.LeadSource='Banner';
          
      
      leadList.add(leadObj);       
     }
leadList.add(new Lead(LastName='Test',Company='Test Company',Status='Active - Not ready to communicate - drip',PostalCode='441227',RecordTypeId=leadRecordTypeId));
        insert leadList; 
        
       
        strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();  
        String strOwner = UserInfo.getUserId();
                
        Default_Oppty_Owner__c testDOO = new Default_Oppty_Owner__c(OwnerId__c = strOwner, Name__c = 'Tom Test');
        insert testDOO;
        
        List<IAS_Recruiter_Assignment__c>  iasList = new List<IAS_Recruiter_Assignment__c >();
        IAS_Recruiter_Assignment__c ias1 = new IAS_Recruiter_Assignment__c(Name = 'C84081', Lead_Type__c='Masters', State__c ='AP',
                                                           Assigned_Recruiter__c = UserInfo.getUserID(),
                                                           Internal_Recruiter__c = UserInfo.getUserID(),
                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                           GDC_Maximum__c = 100000000.0, GDC_Minimum__c=100.0
                                                           );
         iasList.add(ias1);
        IAS_Recruiter_Assignment__c ias2 = new IAS_Recruiter_Assignment__c(Name = '441227', Lead_Type__c='Core', State__c ='AP',
                                                           Assigned_Recruiter__c = UserInfo.getUserID(),
                                                           Internal_Recruiter__c = UserInfo.getUserID(),
                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                           GDC_Maximum__c = 100000000.0, GDC_Minimum__c=100.0
                                                           );
         iasList.add(ias2);
        IAS_Recruiter_Assignment__c ias3 = new IAS_Recruiter_Assignment__c(Name = '441227', Lead_Type__c='Masters', State__c ='AP',
                                                           Assigned_Recruiter__c = UserInfo.getUserID(),
                                                           Internal_Recruiter__c = UserInfo.getUserID(),
                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                           GDC_Maximum__c = 100000000.0, GDC_Minimum__c=100.0
                                                           );
         iasList.add(ias3);
        
         insert iasList; 
        
        Lead testLead = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST',Channel_owner__c='IS BD',
                                 LeadSource='Email', Status='Convert', OwnerId=UserInfo.getUserId(),PostalCode='441227',Prospect_Type__c='Core',
                                 Allow_Lead_Type_Change__c=true,
                                 RecordTypeId=strRecordTypeL);
        insert testLead;
        Lead testLead2 = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST',
                                 LeadSource='Email', Status='Convert', OwnerId=UserInfo.getUserId(),PostalCode='441227',
                                 RecordTypeId=strRecordTypeL);
        insert testLead2;
        Lead testLead3 = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST',Channel_Owner__c='IS BD',
                                 LeadSource='Email', Status='Convert', OwnerId=UserInfo.getUserId(),PostalCode='441227',
                                 RecordTypeId=strRecordTypeL);
        insert testLead3;
        Lead testLead4 = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST',GDC_Prior_12_mo__c=1000,
                                 LeadSource='Email', Status='Convert', OwnerId=UserInfo.getUserId(),PostalCode='441227',
                                 RecordTypeId=leadRecordTypeId);
        insert testLead4;
        Lead testLead1 = [select id from Lead where LastName='TEST' limit 1];
                Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.Id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        }
        static testmethod void method1(){
             Test.startTest();
            strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId(); 
            Lead testLead = new Lead(Company='Test Lead', LastName='TESTCode', RecordtypeId =strRecordTypeL);
            
            insert testLead;
            
            Lead led = [select id,PostalCode, Channel_Owner__c , Assigned_Recruiter__c from Lead where id =: testLead.Id limit 1];  
            system.assertEquals(led.Assigned_Recruiter__c, null);
            
            led.PostalCode = '84081';
            led.Channel_Owner__c = 'IS BD';
            led.Assigned_Recruiter__c=UserInfo.getUserID();
            update led;
            
            Lead led1 = [select id, PostalCode , Assigned_Recruiter__c from Lead where id =: led.ID];
            system.assertEquals(led1.PostalCode , '84081');
            system.assertEquals(led.Assigned_Recruiter__c , UserInfo.getUserID());
            Test.StopTest();
        }
   
    /*Test MEthod for Trigger "marketingActivities_AfterTrigger"  Developer: Utkarsh Topre  Date: 05/25/2017*/
    
    static testMethod void method2(){
       
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        Lead led = new Lead(LastName = 'Test', Company = 'Test Company', LeadSource = 'Banner');
        insert led;
         conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
         Contact ct1= new Contact(firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1');
       insert ct1;
        
        
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( Name = 'BD_DisruptionEM 1' , ELOQUA__Activity_Type__c = 'Email Click Through'
                                                 ,ELOQUA__Contact__c=ct1.id,ELOQUA__Lead__c = led.ID );
        insert ema;
        
        //Task tsk = [select id, WhoId from task where whoId =: led.ID limit 1];
        //system.assertEquals(tsk.WhoId, led.ID);
        test.stopTest();
        
    }
    
    static testMethod void method3(){
        
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Lead led = new Lead(LastName = 'Test', Company = 'Test Company', LeadSource = 'Banner');
        insert led;
        
        conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
         Contact ct1= new Contact(firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1');
       insert ct1;
       
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( Name = 'BD_DripEM 1' , ELOQUA__Activity_Type__c = 'Email Click Through'
                                                    ,ELOQUA__Contact__c=ct1.id,ELOQUA__Lead__c = led.ID );
        insert ema;
        
        //Task tsk = [select id, WhoId from task where whoId =: led.ID limit 1];
        //system.assertEquals(tsk.WhoId, led.ID);
        test.stopTest();
        
    }
    
    static testMethod void method4(){
        
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Lead led = new Lead(LastName = 'Test', Company = 'Test Company', LeadSource = 'Banner');
        insert led;
        
          conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
         Contact ct1= new Contact(firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1');
       insert ct1;
        
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( ELOQUA__Activity_Type__c = 'Campaign' , Activity_Status__c = 'Responded'
                                                 ,ELOQUA__Contact__c=ct1.id,ELOQUA__Lead__c = led.ID );
        insert ema;
        
        //Task tsk = [select id, WhoId from task where whoId =: led.ID limit 1];
        //system.assertEquals(tsk.WhoId, led.ID);
        test.stopTest();
        
    }
    
    static testMethod void method5(){
        
        Test.StartTest();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Lead led = new Lead(LastName = 'Test', Company = 'Test Company', LeadSource = 'Banner');
        insert led;
        
        
          conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
         Contact ct1= new Contact(firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1');
       insert ct1;
         
        ELOQUA__Marketing_Activity__c ema = new ELOQUA__Marketing_Activity__c( Name = 'BD_Agile 1' , ELOQUA__Activity_Type__c = 'Email Click Through'
                                                    ,ELOQUA__Contact__c=ct1.id,ELOQUA__Lead__c = led.ID );
        insert ema;
        
        //Task tsk = [select id, WhoId from task where whoId =: led.ID limit 1];
        //system.assertEquals(tsk.WhoId, led.ID);
        test.stopTest();
        
    }
}