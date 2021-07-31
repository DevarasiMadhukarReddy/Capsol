/*
Apex Class Name         :LeadController
Description             :Test Class for LeadController
Developer Name          : Rajnarayanan R
Created Date            : 05/03/2021
*/
@isTest(seeAllData = false)
public class LeadController_Test 
{
    public static ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
    
    @isTest static void TestList()
    {
        List<Contact> advContactList = new List<Contact>();        
        Contact contact = new Contact(LastName='LBS Jackson Contact',FirstName='A',RecordTypeId=conRecordTypeId,MailingState='CT',LBS_Admin__c = false);              
        advContactList.add(contact);
        Contact contact1 = new Contact(LastName='Paul LBS Contact1',FirstName='B',RecordTypeId=conRecordTypeId,MailingState='WA',LBS_Client_Engage__c = false);              
        advContactList.add(contact1);
        Contact contact2 = new Contact(LastName='LBS Raul Martin Contact',FirstName='C',RecordTypeId=conRecordTypeId,MailingState='ME',LBS_Assurance__c = false);      
        advContactList.add(contact2);        
        Test.startTest();
        insert advContactList; 
        System.enqueueJob(new LeadController(advContactList));
        Test.stopTest();
    }
}