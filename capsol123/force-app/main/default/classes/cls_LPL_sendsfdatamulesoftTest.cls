@istest
global class cls_LPL_sendsfdatamulesoftTest {
  /*  
    @isTest static void testCallout() {
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
insert u;
        
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        Contact ct1= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',CLO_Customer_ID__c=null);
        insert ct1;
        Contact ct2= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,email='test@test.com',
                                 Insurance_Territory__c = 'Test Territory', Current_Firm_Name__c = 'test',
                                 Current_Firm_Type__c='test'  ,RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',CLO_Customer_ID__c=null);
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
            insert lstBro2;
        System.debug('loanApp>>>'+loanApp1);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  
        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        cls_LPL_SendSFDatatoMulesoft sends=new cls_LPL_SendSFDatatoMulesoft();
        
        Id LoanId;
        List<Id> PropIds;
        test.startTest();
        cls_LPL_SendUpdatedCustomerDatatoMule.makePostCallout(ct1.id);
        cls_LPL_SendLoan_ProposalUpdatestoMule.callWebservice(propLst);        
        cls_LPL_SendLoan_ProposalUpdatestoMule.makePostCallout(loanApp1.Id,propLst);
        cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanApp.Id,propLst);
        cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanApp1.Id,propLst);
       // cls_LPL_SubmitLoanApplication  SubmitLoanApplication=new cls_LPL_SubmitLoanApplication(loanApp.id);
        LoanSubmitApplication SubmitLoanApplication=new LoanSubmitApplication();
        
       // SubmitLoanApplication.createProposalfromLoanAppl();
       // SubmitLoanApplication.getLoanApplicationRecord();
        
        LoanSubmitApplication.createProposalFromAura(string.valueof(loanApp.id));
        LoanSubmitApplication.createProposalfromLoanApplication(loanApp);
        LoanSubmitApplication.deleteRelatedProposalOffer(string.valueof(loanApp.id));
        LoanSubmitApplication.createProposalOffers(lstPro,loanApp);
        LoanSubmitApplication.createRepayableProposalOffer(loanApp);
        LoanSubmitApplication.createRepayableProposalOfferAura(string.valueof(loanApp.id));
        LoanSubmitApplication.createRepayableProposalOfferClassic(string.valueof(loanApp.id));
        
        cls_LPL_SubmitLoanApplication.createProposalfromScenarioAura(loanApp.id);
        
        cls_LPL_SubmitLoanApplication.createProposalfromScenarioAura(loanApp1.id);
        cls_LPL_SubmitLoanApplication.createProposalfromScenarioAuraRepayables(loanApp1.id);
       
        //SubmitLoanApplication.createProposalfromLoanApp2(loanApp1.id);
        cls_LPL_SubmitLoanApplication.createProposalfromScenarioforProposal(loanApp1.id);
    }
    */
    
    testMethod static  void testData1(){
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Id TAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
        Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();    
        Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
        Id  ProposalTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByName().get('General Proposal').getRecordTypeId();
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', FirstName = 'Final',LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='tstandarduser@testorg.com');
        insert u;
        Account Acc=wcLoanApplicationControllerTest.createAccount('AccName');
        Contact con=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con1=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con2=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        Contact ct1= new Contact(AccountId = Acc.id, firstname = '', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',
                                 CLO_Customer_ID__c=null,Advisor_Total_Advisory_AUM__c=5,Advisor_Total_AUM__c=1,
                                 Advisor_Total_Brokerage_AUM__c=3,Prior_Yr_GDC__c=4,YTD_GDC__c=3,GP_ROA__c=1,
                                 OSJ_ID__c='ss',OSJ_MGR_Name__c='sss',OSJ_MGR_ID__c='ssd',
                                 LPLCRM__Social_Security_Tax_ID__c='ss',Birthdate=System.today(),
                                 AUM_Attributable__c=3,Split_of_Total_AUM__c=9,Net_Promoter_Score__c=6,
                                 Hire_Date__c=System.today(),Master_Rep_ID__c='s');
        insert ct1;
        Loan_Application__c loanApp1 = new Loan_Application__c();
        loanApp1.Legal_Entity__c = 'Individual';
        loanApp1.Advisor__c = con1.id;
        loanApp1.Primary_Contact__c = true;
        loanApp1.Status__c = '';
        loanApp1.Loan_Purpose__c='';
        loanApp1.Loan_Category__c = '';
        loanApp1.Primary_Contact_Name__c = con1.id;
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
        //loanApp1.Business_Consultant_RM_Email__c = 'test@test.com';
        insert loanApp1;
        test.startTest();
        List<Proposal_Offer__c> pList=createProposals(loanApp1.Id); 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  
         Borrowers__c lstBro2 = new Borrowers__c();
        lstBro2.Name ='test1';
        lstBro2.Contact__c =con1.id;
        lstBro2.Loan_Application__c =loanApp1.id;
        lstBro2.primary_Contact__C =true;
        insert lstBro2;
        Proposal_Offer_Placeholder__c Prol1= new Proposal_Offer_Placeholder__c();
        Prol1.Campaign_Name__c='test';
        Prol1.Loan_Application__c=loanApp1.id;
        insert Prol1;
        cls_LPL_SendLoan_ProposalUpdatestoMule.makePostCallout(loanApp1.Id,new List<id>{pList[0].Id,pList[1].Id});
        cls_LPL_SendUpdatedCustomerDatatoMule.makePostCallout(con1.id);
        cls_LPL_SendUpdatedCustomerDatatoMule.makePostCallout(ct1.id);
        cls_LPL_SendLoan_ProposalUpdatestoMule.callWebservice(new List<Id>{loanApp1.Id});  
        
        cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanApp1.Id,new List<id>{pList[0].Id,pList[1].Id});
        
        LoanSubmitApplication.createProposalFromAura(string.valueof(loanApp1.id));
        LoanSubmitApplication.createProposalfromLoanApplication(loanApp1);
        LoanSubmitApplication.deleteRelatedProposalOffer(string.valueof(loanApp1.id));
        LoanSubmitApplication.createProposalOffers(new List<Proposal_Offer_Placeholder__c>{Prol1},loanApp1);
        LoanSubmitApplication.checkLoanApplication(loanApp1.Id);
        LoanSubmitApplication.createRepayableProposalOffer(loanApp1);
        LoanSubmitApplication.createRepayableProposalOfferAura(string.valueof(loanApp1.id));
        LoanSubmitApplication.createRepayableProposalOfferClassic(string.valueof(loanApp1.id));
       // cls_LPL_SubmitLoanApplication.createProposalfromScenarioAura(loanApp1.id); - commented by amol
        
       // cls_LPL_SubmitLoanApplication.createProposalfromScenarioAura(loanApp1.id); - commented by amol
        //cls_LPL_SubmitLoanApplication.createProposalfromScenarioAuraRepayables(loanApp1.id); - commented by amol
       
        //LoanSubmitApplication.createProposalfromLoanApp2(loanApp1.id);
        //cls_LPL_SubmitLoanApplication.createProposalfromScenarioforProposal(loanApp1.id); - commented by amol
      
        //Bhanu Test class coverage start
        Proposal_Offer__c pro11 = new Proposal_Offer__c();
        pro11.Proposal_Name__c = 'General Proposal1';
        pro11.LoanApp_MD__c = loanApp1.Id;
        pro11.RecordTypeId =  GeneralProposalRecordTypeId ;
        insert pro11;
        pro11.Proposal_Status__c='Accepted';
        pro11.TA_Amount__c =100;
         Update pro11;
        //end
        test.stoptest();
    }
    testMethod static void testData(){
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Id TAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
        Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();    
        Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
        Id  ProposalTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByName().get('General Proposal').getRecordTypeId();
        
        Account Acc=wcLoanApplicationControllerTest.createAccount('AccName');
        Contact con=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con1=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con2=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
       
        Opportunity opp=wcLoanApplicationControllerTest.CreateOpportunity('TEST',Acc.Id);
        String data='{"OpportunityId":"'+Opp.Id+'","AdditionalComments":"dddddd","BorrowerInfo":[{"ContactId":"'+con.Id+'","pAUM":2,"primary":false,"Uname":"aEp2100000000T5CAI"},{"ContactId":"'+con1.Id+'","pAUM":4,"primary":false,"Uname":"aEp2100000000WJCAY"},{"ContactId":"'+con2.Id+'","pAUM":6,"primary":true,"Uname":"aEp2100000000WOCAY"}],"BusinessInfo":{"AdvisorNo":"1","BussinessName":"test business","Custodian":"standard","Entity":"Sole Proprietorship","ParentId":"","Registration":"Broker dealer"},"FinancialInfo":{"advRev":6,"aiuitCash":6,"broRev":6,"eq":6,"fa":6,"fi":6,"mfc":6,"mfdh":6666,"totAdvAum":6,"va":6},"ProposalInfo":{"RequestedLoanAmount":11,"RequestedTermLength":"2"}}';
       // wcLoanApplicationController.WorkingCapital LO=wcLoanApplicationController.collectData(wcLoanApplicationController.saveWCRecord(data));
        wcLoanApplicationController.WorkingCapital LO=new wcLoanApplicationController.WorkingCapital();
       
        
        LO =  wcLoanApplicationController.collectData(wcLoanApplicationController.saveWCRecord(data));
        
        //Added below code to cover Exception log method
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
        //LPL_CreateExceptionLog.createErrorRecordForSFMuleAPIFailure('className','methodName',1,'test','test','test','test',400,LO.RecordId,con2.Id);
        // test.stoptest();
        
       // test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  
        List<Proposal_Offer__c> pList=createProposals(Lo.RecordId); 
    
    
        
        cls_LPL_SendLoan_ProposalUpdatestoMule.makePostCallout(Lo.RecordId,new List<id>{pList[0].Id,pList[1].Id});
        cls_LPL_SendSFDatatoMulesoft.makePostCallout(Lo.RecordId,new List<id>{pList[0].Id,pList[1].Id});

        
        
        
        test.stoptest();

    }
    public static List<Proposal_Offer__c> createProposals(Id RecordId){
        Id  ProposalTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByName().get('General Proposal').getRecordTypeId();
        List<Proposal_Offer__c> pList=new List<Proposal_Offer__c>();
        Proposal_Offer__c pro2 = new Proposal_Offer__c();
        pro2.LoanApp_MD__c = RecordId;
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
        pro2.Date__c = System.today();
        pro2.Expiration__c = System.today();
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
        pList.add(pro2);
        
        
        Proposal_Offer__c pro1 = new Proposal_Offer__c();
        pro1.Proposal_Name__c = 'General Proposal';
        pro1.LoanApp_MD__c = RecordId;
        pro1.RecordTypeId =  ProposalTypeId;
        plist.add(pro1);
        insert plist;
        return plist;
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
    testMethod static void CreateBackendTAProposalOfferClassic(){
        list<Proposal_Offer__c>plist= new list<Proposal_Offer__c>();
        Id BackendTAProposalRecordTypeId1 = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('Backend_Proposal').getRecordTypeId();
        Id BackendTAProposalRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Backend_TA').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        Account a1 = new Account(Name = 'Test Account');
        insert a1;        
        Contact ct1= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',CLO_Customer_ID__c=null);
        insert ct1;
        Loan_Application__c loanApp3 = new Loan_Application__c();        
        loanApp3.Primary_Contact_Name__c = ct1.id;
        loanApp3.Status__c = 'Initiated';
        loanApp3.SUM_NNA__c=456;
        loanApp3.Backend_Hurdle__c=234;
        loanApp3.Backend_Bps__c=2;
        loanApp3.Requested_Loan_Amount__c=444;
        loanApp3.RecordTypeId=BackendTAProposalRecordTypeId;
        insert loanApp3;
        
        Proposal_Offer__c prolist = new Proposal_Offer__c();
        prolist.LoanApp_MD__c = loanApp3.Id;
        prolist.RecordTypeId =  BackendTAProposalRecordTypeId1;
        prolist.TA_Amount__c = loanApp3.Requested_Loan_Amount__c;
        prolist.Max_TA_Amount__c = loanApp3.Requested_Loan_Amount__c;
        prolist.SUM_NNA__c = loanApp3.SUM_NNA__c;
        prolist.Backend_Hurdle__c = loanApp3.Backend_Hurdle__c;
        prolist.Backend_Bps__c = loanApp3.Backend_Bps__c;
        prolist.Proposal_Status__c = 'Accepted';
        prolist.Offer_Name__c = 'Backend TA Offer';
        prolist.Proposal_Name__c='Backend TA Offer';
        prolist.DBA_Business_Name__c ='TESTDBA';
        prolist.Loan_Type__c = 'TEST';
        //plist.add(prolist);
        insert prolist;
        LoanSubmitApplication.CreateBackendTAProposalOfferClassic(loanApp3.id);
        LoanSubmitApplication.checkWithdrawApplication(loanApp3.id); // madhukar is added on 12/03/2020
        LoanSubmitApplication.withdrawApplicationClassic(loanApp3.id); // madhukar is added on 12/03/2020
        LoanSubmitApplication.withdrawApplicationGeneral(loanApp3.id); // madhukar is added on 12/03/2020
        LoanSubmitApplication.collectRecordName(loanApp3.id); // madhukar is added on 12/03/2020
    }
    
}