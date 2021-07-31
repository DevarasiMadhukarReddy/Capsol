@istest
public class lwcCustomLookupController_Test {
        
    public static testmethod void lwcCustomLookupControlle(){  
        Profile Profile = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        
        User admin = new User(Alias = 'admin', Email='admin@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='admin', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId =Profile.Id,
                              TimeZoneSidKey='America/Los_Angeles',
                              UserName='adnmin@abc.com' );
        
        insert admin;
        User admin1 = new User(Alias = 'admin1', Email='admin@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='admin1', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId =Profile.Id,
                              TimeZoneSidKey='America/Los_Angeles',
                              UserName='adnmin@abc1.com' );
        
        insert admin1;
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'admin1', lastname = 'admin1 ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1',
                                 Master_Rep_ID__c=admin1.id,
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert ct1; 
        
        string ObjectName='User';
          string ObjectName1='contact';
        string fieldName='isActive';
        string value='admin';
         string value1='admin1';
        String fieldvalue=admin1.Name;
        String masterRepId =admin.id;
        lwcCustomLookupController lwcr= new lwcCustomLookupController();
        lwcCustomLookupController.getResults(ObjectName,fieldName,value);
        lwcCustomLookupController.getResults(ObjectName1,fieldName,value1);
        lwcCustomLookupController.getResults('User', 'isActive', 'value');
        // lwcr.getResults(admin);
        lwcCustomLookupController.SObJectResult soo=new  lwcCustomLookupController.SObJectResult('User',admin.id , 'true');
        //soo.SObJectResult('User',admin.id , 'true');
        
    }
    
}