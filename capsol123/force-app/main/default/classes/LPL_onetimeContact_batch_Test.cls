/*
Class Name              :LPL_onetimeContact_batch_Test
Description             :Test Class for LPL_onetimeContact_batch

Developer Name          : Vaibhav Jain
Created Date            :29/9/2018
*/
@isTest(SeeAllData=false)
public class LPL_onetimeContact_batch_Test {
    
    @testSetup
    public static void testDataSetup() {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = true;
        insert tbp;
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        List<Contact> conList = new List<Contact>();
        for(Integer i=1;i<=5;i++){
            conList.add(new Contact(LastName='Test'+i,Discovery_Home_Zip__c='100'+i,MailingPostalCode='200'+i,recordTypeId=conRecordTypeId));
        }
        conList.add(new Contact(LastName='Test6',Discovery_Home_Zip__c='1006',MailingPostalCode='2006',recordTypeId=conRecordTypeId,Allow_Lead_Type_Change__c=true));
        conList.add(new Contact(LastName='Test6',recordTypeId=conRecordTypeId));
        conList.add(new Contact(LastName='Test6',MailingPostalCode='1001',recordTypeId=conRecordTypeId));
        insert conList;
        List<IAS_Recruiter_Assignment__c> iasList = new List<IAS_Recruiter_Assignment__c>();
        for(Integer i=1;i<=3;i++){
            iasList.add(new IAS_Recruiter_Assignment__c(Name='100'+i));
        }
        insert iasList;
    }
    
    public static testmethod void getResult(){
        Test.startTest();
        LPL_onetimeContact_batch bc = new LPL_onetimeContact_batch();
        Database.executeBatch(bc,200);
        Test.stopTest();
        /*
         List<IAS_Recruiter_Assignment__c>  iasList = new List<IAS_Recruiter_Assignment__c >();
        
        IAS_Recruiter_Assignment__c ias1 = new IAS_Recruiter_Assignment__c(Name = '84081', Lead_Type__c='Masters', State__c ='AP',
                                                           Assigned_Recruiter__c = UserInfo.getUserID(),
                                                           Internal_Recruiter__c = UserInfo.getUserID(),
                                                           Regional_VP__c = UserInfo.getUserID(), 
                                                           GDC_Maximum__c = 100000000.0, GDC_Minimum__c=2000000.0
                                                           );
         iasList.add(ias1); 
        insert iasList;
        
        Contact c = [Select id,Internal_Recruiter_IRD__c,Discovery_Home_Zip__c,MailingPostalCode from Contact where Discovery_Home_Zip__c=null and MailingPostalCode='84081' limit 1];
        IAS_Recruiter_Assignment__c ias = [Select id,Internal_Recruiter__c,name from IAS_Recruiter_Assignment__c where name=:c.MailingPostalCode limit 1];
        System.assertEquals(c.Internal_Recruiter_IRD__c, ias.Internal_Recruiter__c);
*/
    }
    
}