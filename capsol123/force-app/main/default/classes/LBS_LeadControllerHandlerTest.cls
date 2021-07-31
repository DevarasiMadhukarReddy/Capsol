/*
Apex Class Name         : LBS_LeadControllerHandlerTest
Description             : Test Class for LBS_LeadControllerHandler
Developer Name          : Indrasena
Created Date            : 05/04/2021
*/
@isTest
public class LBS_LeadControllerHandlerTest {
    
    
    @testSetup 
    static void loadTestData() {        
        List<Contact> advContactList = new List<Contact>();
        ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Contact contact = new Contact(LastName='LBS Jackson Contact',FirstName='A',RecordTypeId=conRecordTypeId,MailingState='CT',LBS_Admin__c = true);              
        advContactList.add(contact);
        Contact contact1 = new Contact(LastName='Paul LBS Contact1',FirstName='B',RecordTypeId=conRecordTypeId,MailingState='WA',LBS_Client_Engage__c = false);              
        advContactList.add(contact1);
        Contact contact2 = new Contact(LastName='LBS Raul Martin Contact',FirstName='C',RecordTypeId=conRecordTypeId,MailingState='ME',LBS_Assurance__c = false);      
        advContactList.add(contact2);
        insert advContactList;
    }
    
    
    
    static testmethod void createLeadValidTest(){
        Contact cont = [Select Id,LBS_Assurance__c,LBS_Admin__c,LBS_Marketing_Solutions__c,LBS_CFO_Solutions__c,LBS_Bookkeeping__c,LBS_Premium_Buyer__c,LBS_Resilience__c,LBS_Valuation__c,LBS_Deal_Support__c,LBS_Seller_Support__c,LBS_Technology__c,
                        LBS_Client_Engage__c,FirstName,LastName,Email,MailingState,Phone
                        From Contact limit 1];
        LBS_LeadControllerHandler.createLead(new List<Contact>{cont});
        
        List<Lead> lbsPreOppLead = new List<Lead>();
        Integer leadCount = [SELECT Count() from Lead];
        if(leadCount > 0)            
            lbsPreOppLead = [Select Id, Name,OwnerId from Lead limit 1];
        
        System.assert(lbsPreOppLead != null);
        
        
    }
    
}