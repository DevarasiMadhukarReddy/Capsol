@isTest(seeAllData = false)
private class LPL_LoanApplicationHandlerTest {
    static testmethod void test1(){
        Test.setMock(HttpCalloutMock.class, new cls_LPL_sendsfdatamulesoftTest.MockHttpResponseGenerator());
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Id TAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
        
        Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();    
        Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
        
        Id  ProposalTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByName().get('General Proposal').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', FirstName = 'Final',LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact ct3= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',CLO_Customer_ID__c='d');
        Ct3.Advisor_Total_AUM__c=4;
        Ct3.Advisor_Total_Brokerage_AUM__c=4;
        Ct3.Advisor_Total_Advisory_AUM__c=4;
        Ct3.Prior_Yr_GDC__c=4;
        Ct3.YTD_GDC__c=4;
        Ct3.OSJ_ID__c=NULL;
        Ct3.OSJ_MGR_Name__c='NULL';
        insert ct3;
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',CLO_Customer_ID__c='d');
        insert ct1;
        Contact ct2= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,email='test@test.com',
                                 Insurance_Territory__c = 'Test Territory', Current_Firm_Name__c = 'test',CLO_Customer_ID__c='s',
                                 Current_Firm_Type__c='test'  ,RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert ct2;
        
        Loan_Application__c loanApp = new Loan_Application__c();
        loanApp.Legal_Entity__c = 'Individual';
        loanApp.Advisor__c = ct1.id;
        loanApp.Primary_Contact__c = true;
        loanApp.Status__c = 'Initiated';
        
        insert loanApp; 
               
        List<Id> propLst=new  List<Id>();      
        
        list<Proposal_Offer_Placeholder__c> lstPro=new list<Proposal_Offer_Placeholder__c>();
        Proposal_Offer_Placeholder__c Prol= new Proposal_Offer_Placeholder__c();
        Prol.Campaign_Name__c='test';
        Prol.Loan_Application__c=loanApp.id;
        
        lstPro.add(Prol);
        
        
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        
        Loan_Application__c loanApp1 = new Loan_Application__c();
        loanApp1.Legal_Entity__c = 'Individual';
        loanApp1.Advisor__c = ct1.id;
        loanApp1.Primary_Contact__c = true;
        loanApp1.Status__c = '';
        loanApp1.Loan_Purpose__c='';
        loanApp1.Loan_Category__c = '';
        loanApp1.Primary_Contact_Name__c = ct2.id;
        loanApp1.Asset_Status__c = 'Verfied';
        loanApp1.Current_Registration__c = 'RIA';
        loanApp1.Current_Custodian__c =  u.Id;
        loanApp1.Assigned_Recruiter__c = u.Id;
        loanApp1.Internal_Recruiter__c = u.Id;
        loanApp1.Business_Developer__c = u.Id;
        loanApp1.Requested_Funding_Date__c = myDate;
        loanApp1.Number_of_LPL_Loans_Outstanding__c = 5;
        loanApp1.Number_of_Advisors__c = 2;
        loanApp1.Additional_Comments__c = 'test';
        loanApp1.Application_Type__c = '';
        loanApp1.CLO_Customer_Group_Name__c = 'test';
        loanApp1.Requested_Loan_Amount__c = 533599;
        loanApp1.Requested_Loan_Term__c = 5;
        loanApp1.Mutual_Funds_Custodied__c = 8533;
        loanApp1.Direct_Mutual_Funds__c = 56562;
        loanApp1.AUM_Variable_Annuities__c = 214646;
        loanApp1.AUM_Fixed_Annuities__c = 45451;
        loanApp1.AUM_Equity__c = 2654564;
        loanApp1.AUM_Fixed_Income__c = 45454;
        loanApp1.AUM_AI_UIT_Cash__c = 154151;
        loanApp1.Total_Advisory_AUM__c = 1545564;
        loanApp1.Advisory_Revenue_c__c = 154545;
        loanApp1.Brokerage_Revenue__c = 154454;
        loanApp1.Total_Gross_Revenue__c = 2646456;
        loanApp1.Total_Annual_Business_Expenditures__c = 165465;
        loanApp1.Estimated_Officers_Compensation__c = 15164653;
        loanApp1.Ownership_of_Business__c = 0.2;
        loanApp1.Total_Annual_Personal_Expenditures__c = 16465565;
        loanApp1.Business_Consultant_RM__c = u.Id;
        loanApp1.OSJ_LE_Branch__c = 'test';
        loanApp1.RecordTypeId = ForgivableLoadRecordTypeId;
        //loanApp1.CLO_Customer_ID__c = 'testclocustomerid';
        //loanApp1.Business_Consultant_RM_Email__c = 'test@test.com';
        
        insert loanApp1;
        
        Loan_Application__c loanApp2 = new Loan_Application__c();
        loanApp2.Legal_Entity__c = 'Individual';
        loanApp2.Advisor__c = ct1.id;
        loanApp2.Primary_Contact__c = true;
        loanApp2.Status__c = 'Initiated';
        //        loanApp2.Scenario__c='Corp - In Branch;Corp - HOS';
        insert loanApp2;
        
        Proposal_Offer__c pro = new Proposal_Offer__c();
        
        pro.LoanApp_MD__c = loanApp.id;
        //madhu 
        pro.U_W_Type__c = 'Standard';
        pro.Offer_Accepted__c = true;
        //  pro.RecordTypeId = ForgivableLoadRecordTypeId;
        insert pro;
        propLst.add(pro.Id);
        Proposal_Offer__c pro2 = new Proposal_Offer__c();
        
        pro2.LoanApp_MD__c = loanApp1.id;
        //madhu 
        pro2.U_W_Type__c = 'Standard';
        pro2.Offer_Accepted__c = false;
        //  pro2.RecordTypeId = ForgivableLoadRecordTypeId;    
        pro2.CLO_Proposal_ID__c = 'test';
        //madhu 
        pro2.Platform__c = 'Corp';
        pro2.OSJ__c = 'test';
        pro2.TA_Program__c = 'test';
       // pro2.TA_of_EAUM__c = 0.2;
        pro2.TA_of_VAUM__c = 0.2;
        pro2.Expected_EAUM__c = 5456465;
        pro2.Backend_Bps__c = 4564654;
        pro2.Backend_Hurdle__c = 1564165;
        pro2.Note_Length__c = 1545;
        pro2.DBA_Business_Name__c = 'test';
        pro2.Date__c = myDate;
        pro2.Expiration__c = myDate;
        pro2.Level_Payout__c = 354354;
        pro2.Fee_Waivers__c = 6549.26;
        pro2.Admin_fee__c = 798456.23;
        pro2.Verified_AUM__c = 46546;
        pro2.Approved_T12__c = 64646.23;
        pro2.Max_TA_Amount__c = 156456.25;
        pro2.TA_Amount__c = 121469;
        pro2.Loan_Clause__c = 'test12345';
        pro2.Notes__c = 'test12345';
        //madhu 
        pro2.Branch__c = 'In-branch / LE';
        pro2.Proposal_Status__c = 'Accepted';
        pro2.Loan_Amount__c = 1564651;
        pro2.Interest_Rate__c = 25.25;
        pro2.Firm_AUM__c = 1564654.23;
        pro2.Breakage_Discount_Percent__c = 25.25;
        pro2.Breakage_Discount__c = 12319798.25;
        pro2.Expected_AUM__c = 2458984.25;
        pro2.Total_Production__c = 256365.50;
        pro2.TA_of_Verified_AUM_Percent__c = 258989.50;
        pro2.TA_of_Expected_AUM__c = 258963.50;
        pro2.TA_of_GDC__c = 258963.50;
        pro2.ROIC__c = 258963.50;
        pro2.Payback__c = 258963.50;
        pro2.Gross_profit__c = 258741.50;
        pro2.GP_ROA__c = 12.94;
        
        insert pro2;
        
        Proposal_Offer__c pro1 = new Proposal_Offer__c();
        pro1.Proposal_Name__c = 'General Proposal';
        pro1.LoanApp_MD__c = loanApp1.id;
        pro1.RecordTypeId =  ProposalTypeId;
        
        insert pro1;
        Proposal_Offer_Placeholder__c Prol1= new Proposal_Offer_Placeholder__c();
        Prol1.Campaign_Name__c='test';
        Prol1.Loan_Application__c=loanApp1.id;
        
        lstPro.add(Prol1);
        insert lstPro;
        List<Borrowers__c> lstBro = new List<Borrowers__c>();
        Borrowers__c lstBro1 = new Borrowers__c();
        lstBro1.Name ='test';
        lstBro1.Contact__c =ct1.id;
        lstBro1.Loan_Application__c =loanApp.id;
        insert lstBro1;
        
        Borrowers__c lstBro2 = new Borrowers__c();
        lstBro2.Name ='test1';
        lstBro2.Contact__c =ct2.id;
        lstBro2.Loan_Application__c =loanApp1.id;
        lstBro2.Primary_Contact__c=true;
        insert lstBro2;
        loanApp1.CLO_Customer_Group_ID__c='s1';
        loanApp1.CLO_Application_ID__c='sdf';
        // loanApp1.Status__c='Offer Accepted';
        update loanApp1;
      
    }
    static testmethod void testScenario1(){
        Test.setMock(HttpCalloutMock.class, new cls_LPL_sendsfdatamulesoftTest.MockHttpResponseGenerator());
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',Contact_Terminated__c=false,CLO_Customer_ID__c='d');
        insert ct1;
        Opportunity opp = new Opportunity();
        opp.Assigned_Recruiter__c = UserInfo.getUserID();
        opp.Internal_Recruiter_IRD__c =UserInfo.getUserID();
        opp.Regional_VP__c = UserInfo.getUserID();
        opp.Name ='test';
        opp.Forgivable_Loan__c=1.0;
        opp.OSJ_Rep_ID__c='test';
        opp.Hire_Date__c=system.today();
        opp.Credit_to_OSJ__c=7.0;
        opp.StageName ='test1';
        opp.CloseDate = system.today();
        insert opp;
        Id TransitionAssistanceRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
        Loan_Application__c loanApp = new Loan_Application__c();
        loanApp.Legal_Entity__c = 'Individual';
        loanApp.Advisor__c = ct1.id;
        loanApp.Opportunity__c=opp.Id;
        loanApp.Primary_Contact__c = true;
        loanApp.Status__c='Initiated';
         loanApp.CLO_Application_ID__c='sdf11';

        loanApp.CLO_Customer_Group_ID__c='sa';
        // loanApp.Status__c='Declined';
        loanApp.Assigned_Recruiter__c = opp.Assigned_Recruiter__c;
        loanApp.Internal_Recruiter__c = opp.Internal_Recruiter_IRD__c;
        loanApp.Business_Developer__c = opp.Regional_VP__c;
        loanApp.RecordTypeId = TransitionAssistanceRecordTypeId;
        insert loanApp;
        
          List<Borrowers__c> lstBro = new List<Borrowers__c>();
        Borrowers__c lstBro1 = new Borrowers__c();
        lstBro1.Name ='test';
        lstBro1.Contact__c =ct1.id;
        lstBro1.Loan_Application__c =loanApp.id;
        insert lstBro1;
        
        loanApp.CLO_Customer_Group_ID__c='s1';
        loanApp.CLO_Application_ID__c='sdf';
        // loanApp.Status__c='Offer Accepted';
        update loanApp;
        system.debug('loanApp>>>>>'+loanApp);
        Loan_Application__c loanApp1 = new Loan_Application__c();
        loanApp1.Legal_Entity__c = 'Individual';
        loanApp1.Advisor__c = ct1.id;
        loanApp1.Opportunity__c=opp.Id;
        loanApp1.Primary_Contact__c = true;
      //  loanApp1.Status__c='Offer Accepted';
        // loanApp.Status__c='Declined';
        loanApp1.Assigned_Recruiter__c = opp.Assigned_Recruiter__c;
        loanApp1.Internal_Recruiter__c = opp.Internal_Recruiter_IRD__c;
        loanApp1.Business_Developer__c = opp.Regional_VP__c;
        loanApp1.RecordTypeId = TransitionAssistanceRecordTypeId;
        insert loanApp1;
      //  loanApp1.Status__c='Offer Accepted';
        update loanApp1;
        system.debug('loanApp2>>>>>'+loanApp1);
        LPL_LoanApplicationHandler.beforeInsert(new List<Loan_Application__c>{loanApp1});
        LPL_LoanApplicationHandler.afterInsertContactAccomodicationcreation(new List<Loan_Application__c>{loanApp1});
        loanApp.Status__c='Declined';
        update loanApp;
        LPL_LoanApplicationHandler.LoanstatusUpdate(new List<Loan_Application__c>{loanApp});
    }
    
    static testMethod void insertLoanApplicationTest2(){
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
            
            Contact ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,
                                     Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                     HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                     ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                     Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                     Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                     Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
            insert ct1;
            
            List<Loan_Application__c> loanApplicationList = new List<Loan_Application__c>();
            List<Loan_Application__c> loanApplicationList1 = new List<Loan_Application__c>();
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
            opp.StageName ='test1';
            opp.CloseDate = system.today();
            insert opp;
            
            oppList.add(opp);
            system.debug('opp Opp'+opp);
            
            List<Financials__c> financecontactList = new List<Financials__c>();
            Financials__c finObj = new Financials__c();
            finObj.YTD_GDC_All__c= 1;
            finObj.Prior_full_year_GDC_All__c= 1;
            finObj.AUM_Custodied_Brokerage__c=1;
            finObj.AUM_Total_Current_Year__c=1;
            finObj.Advisor__c = ct1.Id;
            
            insert finObj;
            
            financecontactList.add(finObj);
            system.debug('financecontactList'+financecontactList);
            
            List<Advisor_Profitability__c> advisorcontactList = new List<Advisor_Profitability__c>();
            Advisor_Profitability__c objAdv = new Advisor_Profitability__c();
            objAdv.Gross_Profit_ROA__c = 1;
            objAdv.Contact__c = ct1.Id;
            insert objAdv;
            
            advisorcontactList.add(objAdv);
            system.debug('advisorcontactList'+advisorcontactList);
            Id TransitionAssistanceRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
            Loan_Application__c loanApp = new Loan_Application__c();
            loanApp.Legal_Entity__c = 'Individual';
            loanApp.Advisor__c = ct1.id;
            loanApp.Opportunity__c=opp.Id;
            loanApp.Primary_Contact__c = true;
           loanApp.Status__c='Initiated';
            // loanApp.Status__c='Declined';
            loanApp.Assigned_Recruiter__c = opp.Assigned_Recruiter__c;
            loanApp.Internal_Recruiter__c = opp.Internal_Recruiter_IRD__c;
            loanApp.Business_Developer__c = opp.Regional_VP__c;            
            loanApp.RecordTypeId = TransitionAssistanceRecordTypeId;
            //  insert loanApp;
            loanApplicationList.add(loanApp);
            Loan_Application__c loanApp3 = new Loan_Application__c();
            Id BackendTAProposalRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Backend_TA').getRecordTypeId();
        loanApp3.Primary_Contact_Name__c = ct1.id;
        loanApp3.Status__c = 'Initiated';
        loanApp3.SUM_NNA__c=456;
        loanApp3.Backend_Hurdle__c=234;
        loanApp3.Backend_Bps__c=2;
        loanApp3.Requested_Loan_Amount__c=444;
        loanApp3.RecordTypeId=BackendTAProposalRecordTypeId;
         Id GrowthRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Growth_Loan').getRecordTypeId();
        list<Loan_Application__c> loanApplicationList2 =new list<Loan_Application__c>();
            Loan_Application__c loanApp4=new Loan_Application__c();
        loanApp4.Primary_Contact_Name__c = ct1.id;
        loanApp4.Status__c = 'Documentation';
        loanApp4.Repayable_Loan_Offer_Selected_Flag__c=true;  
        loanApp4.RecordTypeId= GrowthRecordTypeId;
         loanApplicationList2.add(loanApp4);
        // insert loanApp3;
            loanApplicationList1.add(loanApp3);
            test.startTest();
            insert loanApplicationList;
            insert loanApplicationList1;
            Borrowers__c BW=new Borrowers__c();
        BW.Contact__c=ct1.Id;
        BW.Loan_Application__c=loanApplicationList[0].Id;
        BW.Primary_Contact__c=false;
        BW.AUM_Attributable__c=55;
        insert BW;
           // loanApp.Status__c='Declined';
           // update loanApplicationList;
            LPL_LoanApplicationHandler.loanapplicationafterInsert(loanApplicationList);
             LPL_LoanApplicationHandler.LoanstatusUpdate(loanApplicationList);
             LPL_LoanApplicationHandler.BackendCalculation(loanApplicationList1);
             LPL_LoanApplicationHandler.allowAddtionalFieldUpdate(loanApplicationList,loanApplicationList2);
             
             loanApplicationList[0].Status__c='Declined';
             update loanApplicationList;
            Test.stopTest();
        } 
    }
}