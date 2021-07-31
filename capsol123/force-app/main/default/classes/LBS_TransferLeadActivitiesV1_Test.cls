/*--------------------------------------------------------------------------------
Test class execution for LBS_TransferLeadActivitiesV1
History
<Date>           		<Authors Name>        <Brief Description of Change>
MAY-17-2021		 		KArthick			   LBSFNS-58 - Lead to Opportunity Conversion.

Change Details:

------------------------------------------------------------------------------------*/
@isTest
public class LBS_TransferLeadActivitiesV1_Test {

    @testSetup
    public static void testDate(){
        Contact createContact = new Contact(lastname='Test', recordTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId());
        insert createContact;
        Lead createLead = new Lead(lastname='TestName', Status='Open', Contact__c=createContact.Id, recordTypeId= Schema.SObjectType.Lead.getRecordTypeInfosByName().get('LBS Pre-Opportunity').getRecordTypeId());
        insert createLead;
        Task task = new Task(WhoId = createLead.Id, WhatId=null, Subject='Call', ActivityDate=Date.today(), Status='Completed', Priority='Normal');
        insert task;
        Event event = new Event(WhoId = createLead.Id, Subject='Call', ActivityDate=Date.today(), StartDateTime=Date.today(), EndDateTime=Date.today(), Description='');
        insert event;
     	Opportunity createOppo = new Opportunity(Name='Oppo1', Stagename='Qualification', Leadsource='Other', Probability=100.00, Amount=10.00, Contract_Coverage_Model__c=0.00, Type='Admin Solution', 
                                                 LBS_Territory__c='East', Closedate=system.today(),Contact__c=createContact.Id);
        insert createOppo;  
    }
    
    @isTest
    public static void executeTestMethods(){
        Opportunity getOpportunity = [Select Id from Opportunity Limit 1];
        Lead getLead = [Select Id from Lead Limit 1];
        
        List<LBS_TransferLeadActivitiesV1.OppInfoFromFlow> wrapperList = new List<LBS_TransferLeadActivitiesV1.OppInfoFromFlow>();
        LBS_TransferLeadActivitiesV1.OppInfoFromFlow o = new LBS_TransferLeadActivitiesV1.OppInfoFromFlow();
        o.adminOppId= getOpportunity.Id;
        o.assPlanOppId= getOpportunity.Id;
        o.digOffOppId= getOpportunity.Id;
        o.cfoSolOppId= getOpportunity.Id;
        o.clientEngOppId= getOpportunity.Id;
        o.mktSolOppId= getOpportunity.Id;
        o.bookkeeping= getOpportunity.Id;
        o.dealSupport= getOpportunity.Id;
        o.premiumSupport= getOpportunity.Id;
        o.resilience= getOpportunity.Id;
        o.sellerSupport= getOpportunity.Id;
        o.technology= getOpportunity.Id;
        o.leadId= getLead.Id;
        wrapperList.add(o);
        
        Test.startTest();
        LBS_TransferLeadActivitiesV1.processLBSActivities(wrapperList);
        Test.stopTest();
        
    }
        
}