/*Test class for cls_LPL_AutoSubmitTALoanAppToCLO
* Created By Bhanu 12/24/2020 CS-2516- Update TA application Offer Accepted Criteria.
*
*
*************************************************************************************/
@isTest(seeAllData = false)
global class cls_LPL_AutoSubmitTALoanAppToCLOTest {

 static testMethod void insertLoanApplicationTest(){
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        User u1 = new User(
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
            LocaleSidKey = 'en_US');
        insert u1;
        system.runAs(u1){
            Account a1 = new Account(Name = 'Test Account');
            insert a1;
            
           list<contact> listcon= new list<contact>(); 
            Contact ct1= new Contact(AccountId = a1.id, firstname = 'First Name', lastname = 'lastname ' ,Hire_Date__c=system.today(),
                                     Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                     HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                     ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                     Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                     Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                     Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',CLO_Customer_ID__c='3455ffd5');
            listcon.add(ct1);
            
            Contact ct2= new Contact(AccountId = a1.id, firstname = 'First Name', lastname = 'lastname1 ' ,Hire_Date__c=system.today(),
                                     Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                     HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                     ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                     Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                     Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                     Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
           
            listcon.add(ct2);
            insert listcon;
            ct2.CLO_Customer_ID__c='34558ffd5';
            update listcon;
            
             List<Opportunity> oppList = new List<Opportunity>(); 
            Opportunity opp = new Opportunity();
            opp.Assigned_Recruiter__c = UserInfo.getUserID();
            opp.Internal_Recruiter_IRD__c =UserInfo.getUserID();
            opp.Regional_VP__c = UserInfo.getUserID();
            opp.Name ='test';
            opp.Forgivable_Loan__c=1.0;
            opp.OSJ_Rep_ID__c='test';
            opp.Hire_Date__c=system.today();
            opp.Credit_to_OSJ__c=7.0;
            opp.StageName ='Closed-Joined';
            opp.CloseDate = system.today();
            insert opp;
            
            oppList.add(opp);
            system.debug('opp Opp'+opp);
            Loan_Application__c loanApp4 = new Loan_Application__c();
            Id TArecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Transition Assistance').getRecordTypeId();
            loanApp4.Primary_Contact_Name__c = listcon[0].id;
            loanApp4.Status__c = 'Offer Accepted';
            loanApp4.SUM_NNA__c=456;
            loanApp4.Backend_Hurdle__c=234;
            loanApp4.Backend_Bps__c=2;
            loanApp4.Loan_SF_CLO_Status__c=false;
            loanApp4.Requested_Loan_Amount__c=444;
            loanApp4.RecordTypeId=TArecTypeId;
            loanApp4.Opportunity__c=opp.Id;
            //loanApp4.CLO_Application_ID__c='sdf';
            insert loanApp4 ;
             Borrowers__c lstBro1TA = new Borrowers__c();
            lstBro1TA.Name ='test';
            lstBro1TA.Contact__c =listcon[0].id;
            lstBro1TA.Primary_Contact__c = true;
            lstBro1TA.Loan_Application__c =loanApp4.id;
            insert lstBro1TA;
          
            List<Loan_Application__c> loanApplicationList = new List<Loan_Application__c>();
            List<Loan_Application__c> loanApplicationList1 = new List<Loan_Application__c>();
           
            
            List<Financials__c> financecontactList = new List<Financials__c>();
            Financials__c finObj = new Financials__c();
            finObj.YTD_GDC_All__c= 1;
            finObj.Prior_full_year_GDC_All__c= 1;
            finObj.AUM_Custodied_Brokerage__c=1;
            finObj.AUM_Total_Current_Year__c=1;
            finObj.Advisor__c = listcon[0].Id;
            
            insert finObj;
            
            financecontactList.add(finObj);
            system.debug('financecontactList'+financecontactList);
            
            List<Advisor_Profitability__c> advisorcontactList = new List<Advisor_Profitability__c>();
            Advisor_Profitability__c objAdv = new Advisor_Profitability__c();
            objAdv.Gross_Profit_ROA__c = 1;
            objAdv.Contact__c = listcon[0].Id;
            insert objAdv;
            
            advisorcontactList.add(objAdv);
            system.debug('advisorcontactList'+advisorcontactList);
           
          
            Loan_Application__c loanApp3 = new Loan_Application__c();
            Id BackendTAProposalRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Backend_TA').getRecordTypeId();
            loanApp3.Primary_Contact_Name__c = listcon[0].id;
            loanApp3.Status__c = 'Initiated';
            loanApp3.SUM_NNA__c=456;
            loanApp3.Backend_Hurdle__c=234;
            loanApp3.Backend_Bps__c=2;
            loanApp3.Requested_Loan_Amount__c=444;
            loanApp3.RecordTypeId=BackendTAProposalRecordTypeId;
            // insert loanApp3;
            loanApplicationList1.add(loanApp3);
            
            
            Proposal_Offer__c proTA = new Proposal_Offer__c();
            
            proTA.LoanApp_MD__c = loanApp4.id;
            //madhu 
            proTA.U_W_Type__c = 'Standard';
            proTA.Offer_Accepted__c = true;
            insert proTA;
            
           

            test.startTest();
            insert loanApplicationList1;
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  

           
            cls_LPL_AutoSubmitTALoanAppToCLO batchObj=new cls_LPL_AutoSubmitTALoanAppToCLO();
            Database.executeBatch(batchObj);
            LoanApplicationController.saveOffer(string.valueof(proTA.Id),string.valueof(loanApp4.Id));
            Test.stopTest();
        } 
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