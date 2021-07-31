@isTest(SeeAllData=false)
//created By:Hiral patel
//Date:01/14/2019
public class UpdateCampaignList_Test {
    @isTest
    public static void runTest(){
        Test.startTest();
        
        Account testAcc = new Account (Name = 'Test Account');
        insert testAcc;
        
        Trigger_Bypass__c t = new Trigger_Bypass__c();
        t.Name = 'Contact';
        t.isOff__c = true;
        Insert t;
        
        Opportunity testOpp = new Opportunity (Name = 'Test Name',AccountId = testAcc.Id,
                                               Type = 'New Customer',StageName = '1 - Engaged',
                                               Amount = 50000.00,CloseDate = System.today(),
                                               LeadSource = 'Banner');
        insert testOpp;
        
        //Creates Contact to be linked to Campaign Member
        Contact testContact = new Contact(FirstName = 'TestContactF', LastName = 'TestContactL', 
                                          Email = 'none@navinet.net',accountid=testAcc.Id,Source_Type_Prospect__c ='Transitions',LeadSource = 'Banner',Lead_Source__c='Transitions'  );
        insert testContact;
        testOpp.Contact__c = testContact.id;
        Campaign cp = new Campaign(Name='Test');
        insert cp;
        update testOpp;
        
        CampaignMember newMember = new CampaignMember(ContactId = testContact.id, status='Sent', campaignid = cp.id);
        insert newMember;
        Test.stopTest();
    }
}