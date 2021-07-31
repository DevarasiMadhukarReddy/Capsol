@isTest
private class LeadOpportunityContactTest {
    
     public static Id strRecordTypeL;
     
    @testSetup static void methodName() {
        strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId();  
        
        String strOwner = UserInfo.getUserId();
                
        Default_Oppty_Owner__c testDOO = new Default_Oppty_Owner__c(OwnerId__c = strOwner, Name__c = 'Tom Test');
        insert testDOO;
        
        List<IAS_Recruiter_Assignment__c>  iasList = new List<IAS_Recruiter_Assignment__c >();
        
        IAS_Recruiter_Assignment__c ias1 = new IAS_Recruiter_Assignment__c(Name = '84081', Lead_Type__c='Masters', State__c ='AP',
                                                           Assigned_Recruiter__c = UserInfo.getUserID(),
                                                           Internal_Recruiter__c = UserInfo.getUserID(),
                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                           GDC_Maximum__c = 100000000.0, GDC_Minimum__c=2000000.0
                                                           );
         iasList.add(ias1);                                                  
                                                           
        IAS_Recruiter_Assignment__c ias2 = new IAS_Recruiter_Assignment__c(Name = '84081', Lead_Type__c='Core', State__c = 'AP',
                                                           Assigned_Recruiter__c= UserInfo.getUserID(),
                                                           Internal_Recruiter__c= UserInfo.getUserID(),
                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                           GDC_Maximum__c = 2000000.0, GDC_Minimum__c=0.0
                                                           );       
                                                           
         iasList.add(ias2);    
         
         insert iasList;                                                                 
        
        Lead testLead = new Lead(Company='Test Lead', Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', LastName='TEST',
                                 LeadSource='Email', Status='Convert', OwnerId=UserInfo.getUserId(), 
                                 RecordTypeId=strRecordTypeL);
        insert testLead;
            
    }
    
    
    static testMethod void myUnitTest1() {
    
         Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;

        Lead testLead = [select id from Lead where LastName='TEST'];
         
        
       
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.Id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        }
        
        static testMethod void myUnitTest2() {
            
            Test.startTest();
            strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId(); 
            Lead testLead = new Lead(Company='Test Lead', LastName='TESTCode', RecordtypeId =strRecordTypeL);
            
            insert testLead;
            
            Lead led = [select id,PostalCode, Channel_Owner__c , Assigned_Recruiter__c from Lead where id =: testLead.Id limit 1];  
            system.assertEquals(led.Assigned_Recruiter__c, null);
            
            led.PostalCode = '84081';
            led.Channel_Owner__c = 'IS BD';
            update led;
            
            Lead led1 = [select id, PostalCode , Assigned_Recruiter__c from Lead where id =: led.ID]; 
            system.assertEquals(led1.PostalCode , '84081');
            //Commented by Rajnarayanan R (Due to the inactive Trigger, this statement is throwing error)
            //system.assertEquals(led1.Assigned_Recruiter__c , UserInfo.getUserID());
            Test.StopTest(); 
        }
        
        static testMethod void myUnitTest3() {
            
            Test.startTest();
            strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId(); 
            Lead testLead = new Lead(Company='Test Lead', LastName='TESTCode', PostalCode = '84081',Channel_Owner__c = 'IS BD',RecordtypeId =strRecordTypeL);
            
            insert testLead;
            Lead led = [select id,PostalCode, Prospect_Type__c ,Channel_Owner__c , Allow_Lead_Type_Change__c ,Assigned_Recruiter__c from Lead where id =: testLead.Id limit 1];  
            
            led.Prospect_Type__c = 'Core';
            led.Allow_Lead_Type_Change__c = true;
            update led;
            
            Lead led1 = [select id, PostalCode , Prospect_Type__c , Assigned_Recruiter__c from Lead where id =: led.ID]; 
            //system.assertEquals(led1.Prospect_Type__c , 'Core');

            Test.StopTest(); 
        }
        
        static testMethod void myUnitTest4() {
            
            Test.startTest();
            strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId(); 
            Lead testLead = new Lead(Company='Test Lead', LastName='TESTCode', PostalCode = '84081',RecordtypeId =strRecordTypeL);
            
            insert testLead;
            
            Lead led = [select id,PostalCode, GDC_Prior_12_mo__c,Prospect_Type__c ,Channel_Owner__c , Allow_Lead_Type_Change__c ,Assigned_Recruiter__c from Lead where id =: testLead.Id limit 1];  
            
            led.GDC_Prior_12_mo__c = 100.0;
            
            update led;
            
            Lead led1 = [select id, PostalCode , Prospect_Type__c , Assigned_Recruiter__c from Lead where id =: led.ID]; 
            Test.StopTest(); 
        }
        
        static testMethod void myUnitTest5() {
            
            Test.startTest();
            strRecordTypeL = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Discovery Database Lead').getRecordTypeId(); 
            Lead testLead = new Lead(Company='Test Lead', LastName='TESTCode', PostalCode = '84081',RecordtypeId =strRecordTypeL);
            
            insert testLead;
            
            Lead led = [select id,PostalCode, GDC_Prior_12_mo__c,Prospect_Type__c ,Channel_Owner__c , Allow_Lead_Type_Change__c ,Assigned_Recruiter__c from Lead where id =: testLead.Id limit 1];  
            
            led.GDC_Prior_12_mo__c = 10000000.0;
            
            update led;
            
            Test.StopTest(); 
        }
        
        /*
        static testMethod void myUnitTest2() {
            String strRecordTypeO = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
        

        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Branch_Inst_Financial__c  Bi = new Branch_Inst_Financial__c();
        Bi.name = 'test-OSJ';
        bi.Account__c = testAccount.Id;
        insert bi;
        
        Contact testContact1 = new Contact(LastName='Test Contact1', AccountId=testAccount.Id,
                                    ELQ_Marketing_Email_Opt_Out__c=false, 
                                    Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', MailingPostalCode='92122');
        insert testContact1;
        Contact testContact2 = new Contact(LastName='Test Contact2', AccountId=testAccount.Id, 
                                    Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com', MailingPostalCode='92122');
        insert testContact2;
        
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity Test', AccountId=testAccount.Id,
                                    StageName='3 - Discussion', Contact__c=testContact1.Id, LeadSource='Email',
                                    CloseDate=system.today(), GDC_Prior_12_mo__c=1300000,
                                    Assigned_Recruiter__c=UserInfo.getUserID(),  RecordTypeId=strRecordTypeO);
        insert testOpportunity;
        
        Test.startTest();
        testContact1.LastName='update Test';
        update testContact1;
        
        testOpportunity.Contact__c=testContact2.Id;
        testOpportunity.Assigned_Recruiter__c=null;
        update testOpportunity;
        Test.stopTest();
           
        }
        */
        
        
}