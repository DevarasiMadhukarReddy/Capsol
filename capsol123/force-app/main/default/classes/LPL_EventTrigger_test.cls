/*
#############################Change History####################
Requirement                                                     Developer Name                   Date

Ch-01 If Department is Business Developement then restrict delete and 
Edit  permission on task and Event for other Role             Ashish Gupta                  7-May-2018

Ch-02  Create a Event with "IRD Touch" Activity Type 
and meet the custom logic                                      Ashish Gupta                  12-March-2019
*/
@isTest(seeAllData = false)
public class LPL_EventTrigger_test {
    public static Contact ct1;
    @testSetup static void UserData(){
        
        List<User> userList = new List<User>();
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
        userList.add(u);
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole1', Name = 'IRD');
        insert r1;
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS User'].Id,
            
            LastName = 'gupta',
            Email = 'ashish.gupta@lpl.com',
            Username = 'ashish.gupta@lpl.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'Internal Regional Director',
            Alias = 'agupt',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r1.Id
        );
        userList.add(u1);
        insert userList;
    }
    
    public static void testData(){ 
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact_Merge_User_Assignment__c mergeCon =new Contact_Merge_User_Assignment__c();
        mergeCon.Name='Kara Mackie';
        mergeCon.User_ID__c='005U0000004h0p7';
        insert mergeCon;
        String userAssign=Contact_Merge_User_Assignment__c.getInstance('Kara Mackie').User_ID__c;
        
        ID ISINS = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId();
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        oAcct.RecordTypeId= ISINS;
        insert oAcct;
        
        
        ct1= new Contact(AccountId = oAcct.id, firstname = 'Fisrname', lastname = 'lastname',phone='12345667899',MailingStreet ='ABC street',MailingCity ='Pune',MailingState='Maharashtra',MailingPostalCode ='411057',
                         Advisory_Segment__c='XYZ',Advisor_Channel__c='Chanel V',Internal_Recruiter_IRD__c=userAssign);
        insert ct1;
    }
    static testMethod void Eventtestinsert (){
        testData();
        Contact c =[Select id,Full_Name__c,phone from contact where lastname = 'lastname'];
        Event e1 = new Event(whoid = c.id,Location ='Pune', Department__c = 'Business Development', Subject='test event', Activity_Type__c = 'BDA', 
                             Category__c = 'Left Message',DurationInMinutes=10,ActivityDateTime=System.today());
        insert e1;
        
        test.startTest();
        //LPL_EventTriggerGateway eventGateWay = new LPL_EventTriggerGateway();
        // eventGateWay.doEventInsUpdOperation(e1);
        test.stopTest();
        
    }
    static testMethod void EventAccountupdate() 
    {
        testData();
        Account A1= [Select id from Account where Name='Account Test Record'];
        Event e1 = new Event(whatid = A1.id, Department__c = 'Business Development', Subject='test event', Activity_Type__c = 'BDA', 
                             Category__c = 'Left Message', DurationInMinutes=10,ActivityDateTime=System.today(), Event_Type__c='Field Office Visit',StartDateTime=System.today());
        insert e1;
        
        A1.Last_FOV__c = e1.StartDateTime.date();
        update A1;
        test.startTest();
        test.stopTest();
    }
    static testMethod void EventAccountupdate2()  {
        testData();
        Account A1= [Select id from Account where Name='Account Test Record'];
        Event e1 = new Event(whatid = A1.id, Department__c = 'Business Development', Subject='test event', Activity_Type__c = 'BDA', 
                             Category__c = 'Left Message', DurationInMinutes=10,ActivityDateTime=System.today(), Event_Type__c='Home Office Visit',StartDateTime=System.today());
        insert e1;
        
        A1.Last_HOV__c = e1.StartDateTime.date();
        update A1;
        test.startTest();
        test.stopTest();
    }
    static testMethod void EventAccountupdate3() 
    {
        testData();
        Account A1= [Select id from Account where Name='Account Test Record'];
        Event e1 = new Event(whatid = A1.id, Department__c = 'Business Development', Subject='test event', Activity_Type__c = 'BDA', 
                             Category__c = 'Left Message', DurationInMinutes=10,ActivityDateTime=System.today(), Event_Type__c='Virtual Office Visit',StartDateTime=System.today());
        insert e1;
        
        A1.Last_VOV__c  = e1.StartDateTime.date();
        update A1;
        test.startTest();
        test.stopTest();
    }
    
    //   Ch-01 Start ** This test method design If Department is Business Developement then restrict delete and     Edit  permission on task and Event for other Role
    static testMethod void deleteAndEditRecord() {
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        insert oAcct;
        
        testData();
        Contact c =[Select id,Full_Name__c,phone from contact where lastname = 'lastname'];
        test.startTest();
        
        Account A1= [Select id from Account where Name='Account Test Record' limit 1];
        Event e1 = new Event(whoid = c.id,whatid = A1.id, Department__c = 'Business Development', Subject='test event', Activity_Type__c = 'BDA', 
                             Category__c = 'Left Message', Event_Type__c='Virtual Office Visit',DurationInMinutes=10,ActivityDateTime=System.today(),StartDateTime=System.today());
        insert e1;
        
        Event e2 =[Select id,whoid,Event_Type__c,Department__c from Event where Department__c = 'Business Development' and id=:e1.id];
        e2.Event_Type__c='Home Office Visit';
        
        System.assertEquals( e2.Department__c, 'Business Development'); 
        e2.Department__c='Fortigent Reporting';
       update e2;
        System.assertEquals( e2.Event_Type__c, 'Home Office Visit'); 
        System.assertEquals( e2.Department__c, 'Fortigent Reporting'); 
        delete e2;
        test.stopTest();
    }
    // Ch-01 End
     // Ch-02 Start
    static testMethod void activityHistoryRecords() {
        testData();
        test.startTest();
        
        Contact c =[Select id,Full_Name__c,phone from contact where lastname = 'lastname'];
        Event e1 = new Event(whoid = c.id,Location ='Pune', Department__c = 'Business Development', Subject='test event', Activity_Type__c = 'IRD Touch', 
                             Category__c = 'Left Message',DurationInMinutes=10,ActivityDateTime=System.today());
        insert e1;
         System.assertEquals( e1.Activity_Type__c, 'IRD Touch');
         test.stopTest();
    }    
     // Ch-02 End
}