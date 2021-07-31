/*
Class Name              :LPL_Onetime_Region_Contact_Batch_Test
Description             :Test Class for LPL_Onetime_Region_Contact_Batch

Developer Name          : Vaibhav Jain
Created Date            :29/9/2018
*/
@isTest(SeeAllData=false)
public class LPL_Onetime_Region_Contact_Batch_Test {
    
    @testSetup
    public static void testDataSetup() {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = true;
        insert tbp;
        Id conRecordTypeId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Id conRecordTypeId2 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        Account acc = new Account(Name='Test Account');
        insert acc;
        for(Integer i=1;i<=5;i++){
            conList.add(new Contact(LastName='Test'+i,Discovery_Home_Zip__c='100'+i,MailingPostalCode='200'+i,recordTypeId=conRecordTypeId1));
        }
        conList.add(new Contact(LastName='Test6',MailingPostalCode='1002',recordTypeId=conRecordTypeId2,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' ));
        insert conList;
        for(Integer i=1;i<=5;i++){
            for(Integer j=1;j<=2;j++){
                oppList.add(new Opportunity(Name='TestOpp'+j,Account=acc,StageName='1 - Unscreened Contact',recordTypeId=oppRecordTypeId,Probability=10,CloseDate=System.today(),Contact__c=conList[i-1].Id));
            }
            oppList.add(new Opportunity(Name='TestOpp',Account=acc,StageName='1 - Unscreened Contact',recordTypeId=oppRecordTypeId,Probability=10,CloseDate=System.today(),Contact__c=conList[5].Id));
            
        }
    //    insert oppList;
        List<IAS_Recruiter_Assignment__c> iasList = new List<IAS_Recruiter_Assignment__c>();
        for(Integer i=1;i<=3;i++){
            iasList.add(new IAS_Recruiter_Assignment__c(Name='100'+i,Region__c='Central'));
        }
        insert iasList;
    }
    
    public static testmethod void getResult(){
        Test.startTest();
        LPL_Onetime_Region_Contact_Batch bc = new LPL_Onetime_Region_Contact_Batch();
        Database.executeBatch(bc,200);
        Test.stopTest();
    }
}