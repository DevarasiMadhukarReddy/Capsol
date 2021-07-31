@isTest(seeAlldata=false)
global class LoanApplicationControllerTest {
 @isTest
    static void  test1(){
        contact con=new Contact();
        con.FirstName='Test';
        con.LastName='TEST';
        con.CLO_Customer_ID__c='123';
        insert con;
        
        Id RecordTypeIdProposal;
        list<Proposal_Offer__c> lstPO = new list<Proposal_Offer__c>();
  List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get('Proposal_Offer__c').getDescribe().getRecordTypeInfos();    

       

        for(RecordTypeInfo rt : recordtypes){

            if(rt.getName() == 'General Proposal' )
            {
            RecordTypeIdProposal=   rt.getRecordTypeId();
            }
          
        }        
        LoanApplicationController LAC=new LoanApplicationController();
        Loan_Application__c sobj = new Loan_Application__c(
         // Opportunity__c = '0060R00000BRAmG',        // Opportunity
          Application_Type__c = 'Prospect',            // Application  Type
          Business_Name_DBA__c = 'tttdbaggggcvbsadf',  // Business Name/DBA
          Status__c = 'Initiated',                     // Status
          Legal_Entity__c = 'Partnership',             // Legal Entity
          Loan_Category__c = 'Forgivable Loan',        // Loan Category
          Number_of_Advisors__c = 67723,            // Number of Advisors
          Direct_Mutual_Funds__c = 343,                // Mutual Funds (Directly Held)
          Mutual_Funds_Custodied__c = 55,              // Mutual Funds (Custodied)
          AUM_Variable_Annuities__c = 23,              // Variable Annuities
          AUM_Fixed_Annuities__c = 435,                // Fixed Annuities
          AUM_Equity__c = 435,                         // Equity
          AUM_Fixed_Income__c = 435,                   // Fixed Income
          AUM_AI_UIT_Cash__c = 234,                    // AI, UIT & Cash
          Advisor_Total_Brokerage_AUM__c = 1960.00,    // Total Brokerage AUM
          Advisor_Total_Advisory_AUM__c = 1000,        // Total Advisory AUM
          Advisor_Total_AUM__c = 2960.00,              // Total AUM
          Advisory_Revenue_c__c = 44,                  // Advisory Revenue
          Brokerage_Revenue__c = 33,                   // Brokerage Revenue
         // Advisor__c = '0030R00000zLHwj',              // Advisor
          Percentage_Split_of_Total_AUM__c = 34,       // % Split of Total AUM
          Primary_Contact__c = false,                  // Primary Contact
          Current_Registration__c = 'RIA',   // Current Registration
         // Current_Custodian__c = 'undefined',          // Current Custodian
          Additional_Comments__c = 'testfdsfdsfdsf',   // Additional Comments
         // Assigned_Recruiter__c = '0050e0000073UJH',   // Assigned Recruiter
          Preparer_Name__c = 'tttss',                  // Preparer Name
         // Internal_Recruiter__c = '0050e0000074tXV',   // Internal Recruiter
          Servicer_Name__c = 'tttss'//,                  // Servicer Name
          //Business_Developer__c = '0050R000003bIWa'   // Business Developer
        );
        insert sobj;
        
        Proposal_Offer__c sobj1 = new Proposal_Offer__c(
       RecordTypeId= RecordTypeIdProposal,
          Name = 'Forgivable Offer',                 // Proposal/Offer Name
         //madhu 
         Branch__c = 'HOS/New Branch',                // Branch
        // madhu 
        Platform__c = 'Hybrid',                      // Platform
          OSJ__c = 'dfdsfdsf',   
          OSJ_NON_OSJ_Rep_Id__c= 'Rep1',                        
          Offer_Name__c = 'Forgivable Offer 1',        // Offer Name
        // madhu 
        Campaign__c = 'EOY',                   // Campaign
          Status__c = false,                           // Status
          Loan_Type__c = 'Transtion Assitance',        // Loan Type
          DBA_Business_Name__c = 'tttdbaggggcvbsadf',  // DBA/Business Name
          Offer_Accepted__c = false,                   // Offer Accepted
         // madhu 
         U_W_Type__c = 'Standard',                    // U/W Type
         // madhu 
         Loan_Term__c ='7',                          // Loan Term
          LoanApp_MD__c = sobj.Id           // Loan Application
        );
        insert sobj1;
        lstPO.add(sobj1);
        
         Proposal_Offer__c sobj4 = new Proposal_Offer__c(
          Name = 'Repayable Offer',                 // Proposal/Offer Name
        //madhu 
        Branch__c = 'New Branch / HOS',                // Branch
       //madhu  
       Platform__c = 'Hybrid',                      // Platform
          OSJ__c = 'dfdsfdsf',                         // OSJ
          Offer_Name__c = 'Repayable Offer 1',        // Offer Name
        //madhu  
        Campaign__c = 'EOY',                   // Campaign
          Status__c = false,                           // Status
          Loan_Type__c = 'Transtion Assitance',        // Loan Type
          DBA_Business_Name__c = 'tttdbaggggcvbsadf',  // DBA/Business Name
          Offer_Accepted__c = false,                   // Offer Accepted
        //madhu 
        U_W_Type__c = 'Standard',                    // U/W Type
        //madhu 
        Loan_Term__c = '7' ,                          // Loan Term
          LoanApp_MD__c = sobj.Id           // Loan Application
        );
        insert sobj4;
        lstPO.add(sobj4);
        
        Proposal_Offer_Placeholder__c sobj2 = new Proposal_Offer_Placeholder__c(
          Platform__c = 'Hybrid',                 // Platform
          Branch__c = 'New Branch / HOS',             // Branch
          OSJ_LE_Name__c = 'dfdsfdsf',              // OSJ/LE Name
          Term_Length__c = '7 Years',               // Term Length
          U_W_Type__c = 'Standard',                 // U/W Type
          Campaign_Name__c = 'EOY',           // Campaign Name
          Loan_Application__c = sobj.Id   // Loan Application
        );
        insert sobj2;
        Borrowers__c sobj3 = new Borrowers__c();
         sobj3.Contact__c = con.id;
         sobj3.Loan_Application__c =sobj.Id;
        insert sobj3;
        LoanApplicationController.collectRecordDetail(sobj.Id);
        LoanApplicationController.collectRecordName(sobj.Id);
        LoanApplicationController.collectRelatedProposal(sobj.Id);
         LoanApplicationController.collectProposalList(sobj.Id); //CS-2916
        LoanApplicationController.collectForgivableProposal(sobj.Id);
        LoanApplicationController.createNote('TEXT',sobj.Id);
        LoanApplicationController.saveOffer(sobj4.Id,sobj.Id);
        String data1='{"RecordId":"'+sobj.Id+'","BusinessName":"TEST","Advisor":"4","EntityType":"Sole Proprietorship","Registration":"RIA","CurrentCustodian":"STandard","AdditionalComment":"test","FDATA":{"mfdh":1,"mfc":1,"totMFC":1,"va":1,"fa":1,"fi":1,"eq":1,"aiuitCash":1,"broRev":1,"advRev":1,"totAdvAum":1},"BorrowerInfo":[{"AUMATT":"0.24","ContactId":"'+con.Id+'","pAUM":3,"primary":true,"recId":"'+sobj3.Id+'","Uname":"'+sobj3.Id+'","avail":false}],"ProposalDATA":[{"Branch":"New Branch / HOS","CampaignName":"EOY","OfferName":"PO-000000357","OSJLEName":"test","Platform":"Hybrid","slno":"it0","TermLength":"7 Years","UWType":"Premium Model","aliasPlatform":"Platform0","aliasBranch":"Branch0","aliasTermLength":"TermLength0","aliasUWType":"UWType0","aliasCampaignName":"CampaignName0","aliasOSJLEName":"OSJLEName0","first":true}]}';
        LoanApplicationController.saveLoanRecord(data1);
        wcLoanApplicationController.checkLoanappliction(sobj.Id);
        LoanApplicationController.populateBorrowerWrapper(sobj);
        String strProposal = JSON.serialize(lstPO);
        LoanApplicationController.updateProposalData(strProposal );
        
          //Bhanu CS-2516 starts- Update TA application Offer Accepted Criteria
           test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  

              Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', FirstName = 'Final',LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='tstandarduser@testorg.com');
        insert u;
            Account Acc=wcLoanApplicationControllerTest.createAccount('AccName');
         Opportunity opp=wcLoanApplicationControllerTest.CreateOpportunity('TEST',Acc.Id);
        opp.StageName ='Closed-Joined';
        update opp;
        
        sobj.RecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Transition Assistance').getRecordTypeId();
        sobj.Status__c  = 'Offer Accepted';
        sobj.Opportunity__c =opp.id;
        sobj.CLO_Application_ID__c='123';
        update sobj; 

        con.Hire_Date__c=System.today();
        update con;
         LoanApplicationController.saveOffer(sobj4.Id,sobj.Id);
            test.stoptest();
        
          //Bhanu CS-2516 ends- Update TA application Offer Accepted Criteria
    } 

 global class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            // res.Endpoint
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"8UT28QKGORMivFqne-6PMRLdTYk3AS0mcxdVwRJEwYsTjwZjqGopk1TRzGX7vHSZpFNFL3HOmX3RKZrQkBap3b16j-XVkwArdDbhusArOBGzYsD1cpA8B87N_RedJrd9btvq2i22cAjPvyJLSVMc297U0V9YZ9rJ3tM429G8mglnsUNUVJJi_nnTJAN6-H038B4Y1aQeRQZVdU72Nr942eYZ3fXv1HXfxwYUZgWyYO5juVaVnoq_ZJHcrFGXfNp5LVrNlnEibHhJ2RGeD-MYKhyVjfkTrATGQhYY--OVCOemUyWKTlwgwBFjgzfpQfOq79raEglOTgEF3Qx78RY2-nBNvgOTRMET4B2fT17Q8EN4UCQLxGZTGq1ACN5j2B3YKT7isjzwAgysloYGJsL4j4D8dCGKgWBO0rTXwx7MfkNsX5TjAYRNCip5vTSRXeSBqhjM_TtwbKCA0HexikSz-XryZT7pKGYhjfRCXtWudd7OUjFYoDRfKTiAhjNk5yJj","token_type":"bearer","expires_in":86400,"userName":"test@gmail.com",".issued":"Thu, 25 Jun 2015 12:56:23 GMT",".expires":"Fri, 26 Jun 2015 12:56:23 GMT"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
}