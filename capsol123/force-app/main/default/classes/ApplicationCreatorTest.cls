@isTest(seeAllData = false)
private class ApplicationCreatorTest 
{
  
    @testSetup static void testData()
    {
        
          User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
          
        );
        insert u;
       
                        BAQ__C b= new BAQ__c(Name='newbaq',
                        Affiliation_1__c='Corp', Branch_1__c='HOS', OSJ_LE_1__c='111',
                        Affiliation_2__c='Hybrid', Branch_2__c='LE', OSJ_LE_2__c='222',
                        Affiliation_3__c='Corp', Branch_3__c='HOS', OSJ_LE_3__c='333',
                        Affiliation_4__c='Corp', Branch_4__c='HOS', OSJ_LE_4__c='111',
                        Affiliation_5__c='Hybrid', Branch_5__c='LE', OSJ_LE_5__c='222',
                        Affiliation_6__c='Corp', Branch_6__c='HOS', OSJ_LE_6__c='333',
                        AUM_RP_Assets_BOR_Brokerage__c=200,
                        AUM_RP_Assets_RPCP_Corporate_RIA__c=100,
                        AUM_RP_Assets_Hybrid_RIA__c=200,
                        AUM_ROC_k_S__c=100,
                            Current_Custodian__c='1', Joining_RIA_or_Corporate__c='RIA', Number_of_Advisors__c=1);
			insert b;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
             contact c1 = new contact(LastName='test');
                 insert c1;
        
        opportunity op = new opportunity(
                                 Name='nameop',
                                BAQ__c =b.Id,
                                AccountId=a1.Id,
                                Contact__c=c1.Id,
                                //Application__c='a6e0P00000094qcQAA',
                                //loan__CurrentGenerators__c='App-1223300',
            
                                //Current_Firm2__c='',
                                TAT_GDC__c=500,
        StageName='completed', CloseDate=system.today());
        Insert op;
               
    }
    
    @isTest
    public static void createApplictionFromOpportunitytest() {
        BAQ__c baq1 =  [select id,name from BAQ__c where name ='newbaq' limit 1];
        
        Account acc1 = [select id from Account where name='Test Account' limit 1];
        Opportunity opp1 = [select id,name,AccountId,Contact__c,TAT_GDC__c from opportunity where name='nameop' limit 1];
        system.debug('@@@@@@@'+opp1.id);
        
       genesis__Applications__c app = new genesis__Applications__c(
                                                                  isParentApplication__c=true,
                                                                  BAQ__c= baq1.id,
                                                                  genesis__Account__c =opp1.Accountid,
                                                                  genesis__Contact__c =opp1.Contact__c,
                                                                  Advisor_Type__c='New',
                                                                  TAT_GDC__c=opp1.TAT_GDC__c,
                                                                  genesis__Product_Type__c = 'Loan',
                                                                  genesis__Status__c = ConstantsCl.APPLICATION_STATUS_BAQ_SUBMITTED
           
           
       );
        
        app.Opportunity__c=opp1.id;
        insert app;
        
     
        ApplicationCreator appcreator1 = new ApplicationCreator(opp1.id);
        ApplicationCreator.createApplicationLtng(opp1.id);
        
    }
    
    
}