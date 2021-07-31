@isTest(SeeAllData=false)
//created By:Hiral patel
//Date:01/14/2019
public class CampaignMemberTrigger_Test {
    @isTest
    public static void runTest(){
        Test.startTest();
        Account testAcc = new Account (Name = 'Test Account');
        insert testAcc;
        
        Trigger_Bypass__c t = new Trigger_Bypass__c();
        t.Name = 'Contact';
        t.isOff__c = true;
        Insert t;
        
        //Creates Contact to be linked to Campaign Member
        Contact testContact = new Contact(FirstName = 'TestContactF', LastName = 'TestContactL', 
                                          Email = 'none@navinet.net',accountid=testAcc.Id,LeadSource = 'Banner',Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions' );
        insert testContact;
        Opportunity testOpp = new Opportunity (Name = 'Test Name',AccountId = testAcc.Id,
                                               Type = 'New Customer',StageName = '1 - Engaged',
                                               Amount = 50000.00,CloseDate = System.today(),
                                               LeadSource = 'Banner',Contact__c = testContact.Id);
        insert testOpp;
        
        Campaign cp = new Campaign(Name='Test', Opportunity__c = testOpp.Id);
        insert cp;
        
        CampaignMember newMember = new CampaignMember(ContactId = testContact.id, status='Sent', campaignid = cp.id);
        insert newMember;
        Test.stopTest();
    }
}