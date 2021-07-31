@isTest
private class ChangeEloquaContactEmailAddressTgr_test
{

 @testSetup static void testData(){ 
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        User u = new User(
                         ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS_LeadPilot'].Id,
                         LastName = 'Mackie',
                         Email = 'kara.mackie@lpl.com',
                         Username = 'kara.mackie@lpl.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'Internal Regional Director',
                         Alias = 'kmack',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         UserRoleId = r.Id
                    );
        insert u;
        }
        static testMethod void validateHelloWorld() 
        {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
         
        Contact_Merge_User_Assignment__c mergeCon =new Contact_Merge_User_Assignment__c();
        mergeCon.Name='Kara Mackie';
        mergeCon.User_ID__c='005U0000004h0p7';
        insert mergeCon;
           
        String userAssign=Contact_Merge_User_Assignment__c.getInstance('Kara Mackie').User_ID__c;
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        insert oAcct;
        
        contact c=new contact(lastname='testing',firstname='apex',email='test676@gmail.com',AccountId = oAcct.Id,Internal_Recruiter_IRD__c=userAssign);
        Insert c;
        
        c.firstname='test1';
        c.email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com';
        update c;
        }
    }