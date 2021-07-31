@isTest
public class LoanApplicationExtensionTest {
    testmethod static void testScenario1(){
        contact con=new Contact();
        con.FirstName='Test';
        con.LastName='TEST';
        insert con;
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
          Current_Registration__c = 'RIA',             // Current Registration- restricted Picklist value
         // Current_Custodian__c = 'undefined',          // Current Custodian
          Additional_Comments__c = 'testfdsfdsfdsf',   // Additional Comments
         // Assigned_Recruiter__c = '0050e0000073UJH',   // Assigned Recruiter
          Preparer_Name__c = 'tttss',                  // Preparer Name
         // Internal_Recruiter__c = '0050e0000074tXV',   // Internal Recruiter
          Servicer_Name__c = 'tttss'//,                  // Servicer Name
          //Business_Developer__c = '0050R000003bIWa'   // Business Developer
        );
        insert sobj;
        ApexPages.StandardController sc = new ApexPages.StandardController(sobj);
        LoanApplicationExtension testAccPlan = new LoanApplicationExtension(sc);
        
        PageReference pageRef = Page.LoanApplicationClassic;
        pageRef.getParameters().put('id', String.valueOf(sobj.Id));
        Test.setCurrentPage(pageRef);
    }
}