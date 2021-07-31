/*
Trigger Name            : 
Description             :Test Class for LPL_PotentialDuplicateTrigger
Developer Name          : Garvita Rai
Created Date            : 9/28/2018

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
*/
@isTest(SeeAllData=false)
public class LPL_PotentialDuplicateTrigger_Test{
    @testSetup
    public static void testDataSetup(){
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
    }
    
    public static testmethod void unitTest1(){
        Id contactProspectRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        List<Contact> conList = new List<Contact>();
        Id accRT1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Development Opportunity').getRecordTypeId();
        
        Account acc1 = new Account();
        acc1.Name = 'Account 1';
        acc1.RecordTypeId = accRT1;
        insert acc1;
        CRMfusionDBR101__Scenario__c scenarioRec = new CRMfusionDBR101__Scenario__c(Name='Dupe Email',CRMfusionDBR101__Deployed__c=true,CRMfusionDBR101__Match_on_Insert_Action__c  ='Report Duplicate',CRMfusionDBR101__Match_on_Update_Action__c='Report Duplicate',CRMfusionDBR101__Scenario_Type__c='Contact');
        insert scenarioRec;
        
        // Create 2 contacts with matching UniqueKey
        for(Integer  i= 1 ; i<3;i++){
            Contact con = LPL_testDataSetUpUtility.createContact('Test Contact '+i,acc1.id,contactProspectRecordType);
            con.email='test@test.com';
            conList.add(con);
        }
        insert conList;
        
        List<Contact> contactList = new List<Contact>([SELECT id from Contact]);
        List<CRMfusionDBR101__Scenario__c > scenarioList = new List<CRMfusionDBR101__Scenario__c >([SELECT id from CRMfusionDBR101__Scenario__c]);
        
        CRMfusionDBR101__Potential_Duplicate__c dupe =new CRMfusionDBR101__Potential_Duplicate__c(CRMfusionDBR101__Contact__c=contactList[0].id,CRMfusionDBR101__Scenario__c=scenarioList[0].id,CRMfusionDBR101__Scenario_Type__c='Contact',CRMfusionDBR101__Key__c='676489457845');
        insert dupe;
        
        
        
        //CRMfusionDBR101__Potential_Duplicate__c 
        
    }
}