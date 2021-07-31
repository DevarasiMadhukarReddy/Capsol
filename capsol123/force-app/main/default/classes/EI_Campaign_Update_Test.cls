/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EI_Campaign_Update_Test {

    static testMethod void myUnitTest() 
    {
        // TO DO: implement unit test
        //Test Account
        Account a1 = new Account (Name = 'Test Acct');
        insert a1; 
        
         Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        //Test Contacts
        Contact c1 = new Contact (LastName = 'Test 1',AccountId = a1.Id);
        Contact c2 = new Contact (LastName = 'Test 2',AccountId = a1.Id);
        insert c1;
        insert c2;
        
        //Test Enagement Indices
        Engagement_Index__c ei1 = new Engagement_Index__c(Name='test 1',Advisor__c=c1.Id);
        Engagement_Index__c ei2 = new Engagement_Index__c(Name='test 2',Advisor__c=c2.Id);
        insert ei1;
        insert ei2; 
        
         //Getting the year now
         Datetime rightnow = Datetime.now();
         String yearNow = rightnow.format('yyyy');
         
         //Getting prior year
         Datetime lastyear = rightnow.addYears(-1);
         String yearLastYear = lastyear.format('yyyy');         
        
        //This will test a conference last year
        Campaign campaign1 = new Campaign(Name = 'Test C1',Type='Seminar / Conference',conference__c='Top Producers',Year__c=yearLastYear);
        
        //This will test a conference within this year
        Campaign campaign2 = new Campaign(Name = 'Test C2',Type='Seminar / Conference',conference__c='Top Producers',Year__c=yearNow);
        
        //This will test a bad conference type
        Campaign campaignB1 = new Campaign(Name = 'Test B1',Type='Seminar / Conference1',conference__c='Top Producers',Year__c='2011');
        
        //This will test an incorrect conference type
        Campaign campaignB2 = new Campaign(Name = 'Test B2',Type='Seminar / Conference',conference__c='Bad dog no biscuit',Year__c='2011');
        
        //This will test a year out of range
        Campaign campaignB3 = new Campaign(Name = 'Test B3',Type='Seminar / Conference',conference__c='Top Producers',Year__c='2009');
        
        //Inserting test campaigns
        insert campaign1;
        insert campaign2;
        insert campaignB1;
        insert campaignB2;
        insert campaignB3;

        //Testing single good 1
        CampaignMember cm1 = new CampaignMember(CampaignID=Campaign1.Id,ContactID=c1.Id,LeadID=NULL);
        insert cm1;
        delete cm1;

        //Testing single good 2
        CampaignMember cm2 = new CampaignMember(CampaignID=Campaign2.Id,ContactID=c1.Id);
        insert cm2;
        delete cm2;

        //Testing single bad 1
        CampaignMember cmB1 = new CampaignMember(CampaignID=CampaignB1.Id,ContactID=c1.Id);
        insert cmB1;
        delete cmB1;

        //Testing single bad 2        
        CampaignMember cmB2 = new CampaignMember(CampaignID=CampaignB2.Id,ContactID=c1.Id);
        insert cmB2;
        delete cmB2;

        //Testing single bad 3        
        CampaignMember cmB3 = new CampaignMember(CampaignID=CampaignB3.Id,ContactID=c1.Id);
        insert cmB3;
        delete cmB3;
        
        //List to contain the multiples for testing
        list<CampaignMember> multipleTest = new list<CampaignMember>();

        //Testing multiple good 1        
        CampaignMember cmm1 = new CampaignMember(CampaignID=Campaign1.Id,ContactID=c1.Id);
        CampaignMember cmm2 = new CampaignMember(CampaignID=Campaign1.Id,ContactID=c2.Id);
        
        multipleTest.add(cmm1);
        multipleTest.add(cmm2);
        
        insert multipleTest;
        multipleTest.clear();
        delete multipleTest;
       
        //Cleaning up
        delete campaign1;
        delete campaign2;
        delete campaignB1;
        delete campaignB2;
        delete campaignB3;
 
        delete ei1;
        delete ei2;
        delete c1;
        delete c2;
        delete a1;       
                
    }
}