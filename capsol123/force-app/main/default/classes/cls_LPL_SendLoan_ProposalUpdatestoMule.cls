/***
     * This class is used to send Loan Application and proposal updates to CLO which are already present in CLO.
     * 
     * 
     * Error Handling-Create Integration Error records in SF when SF invokes Data Power or Mule Soft API.
     *                                              ---Updated by Amol Sprint 13 CapSol - 06/19/2020 - CH01
     * 
     * CS-60 - Map Business Name DBS in Loan Application adn Proposal Level - ---Updated by Amol Sprint 13 CapSol - 06/19/2020 - CH02
     * CS- 1734 - OSJ Amount field - Updated by Amol 07/22/2020 Sprint 14 Capsol
     * CS-2017 - Repayable Loan Amount - Updated by Amol - 08/28/2020 - CH04
     * CS-1620--Data Model Enhancement: VAUM & Approved T12  Updated by Madhukar Reddy Sprint14 Capsol-07/15/2020
     * Modified By Bhanu 7/23/2020 CS-1343--Data Model - OSJ Related Fields
     * CS-744 - Sub Loan Amount Calculations - Updated by  Amol 08/05/2020 - CH03
     * EAUM Mapping at Loan Application Level CS- 2507 - Modified by Amol - 11/11/2020 -  CH05
     * Modified By Bhanu 11/30/2020 CS-2518 - Enhance Application Submit Validation
     * Author - Amol Deshpande
     * * CH.No       Description                                                           Developer           Date
    ---------------------------------------------------------------------------------------------------------------
    * CH06       CS-2756 Sprint 21- Remove hardcoded values                                 Bhanu              01/21/2021
    * ch07 CS-2847 Commented the TA_of_EAUM__c field which is not required in the code
    * CH - 08    CS - 2953 Enhancement - Update Forgivable Application and related record 
                 as read - only when offer accepted
                                                                                            Amol      03 / 26 / 2021 
     */
public class cls_LPL_SendLoan_ProposalUpdatestoMule{

@InvocableMethod 
public static void callWebservice(List<Id> loanIds) {

Loan_Application__c LoanApp = new Loan_Application__c();
list<Proposal_Offer__c> propLst = new list<Proposal_Offer__c>();
list<Id> propIds = new list<Id>();

if(loanIds.size()>0 && loanIds != null){
propLst = [select id,LoanApp_MD__c from Proposal_Offer__c where LoanApp_MD__c IN : loanIds];

for(Proposal_Offer__c prop:propLst){
                propIds.add(prop.id);
        }
makePostCallout(loanIds[0],PropIds);
}

}


    @future(callout = true)
    public static void makePostCallout(Id LoanId, List<Id> PropIds) {
        
        DatePowerEndpoint__mdt dpEndpoint = new DatePowerEndpoint__mdt();
        dpEndpoint = [Select DataPowerDEVEndpoint__c,DataPowerPRODEndpoint__c,DataPowerQAEndpoint__c,DataPowerAccessTokenAPIBody__c,
                        DataPowerAccessTokenAPI__c,DataPowerAccessTokenAuthHeader__c,DataPowerSendSFDataToCLOSubmitAPI__c,
                        DataPowerSFDataToCLOUpdateApplicationAPI__c,DataPowerSFDataToCLOUpdateCustomerAPI__c,
                        DPAccessTokenUpdateCustomerAPIBody__c,DataPowerAccessTokenUpdateLoanAPIBody__c,DataPowerSNOWEndpoint__c,
                        DataPowerSNOWAccessTokenAPIBody__c,DataPowerDEVINTEndpoint__c from DatePowerEndpoint__mdt];
        List<Borrowers__c> updateBorrowers = new List<Borrowers__c>();
        List<Borrowers__c> lstBro = new List<Borrowers__c>();
        lstBro = [Select Id,Split_of_Total_AUM__c,AUM_Attributable__c,Contact__c,CLO_Customer_Group__c,CLO_Customer_ID__c,Current_Firm_Name__c,
                 Current_Firm_Type__c,Enterprise_Name__c,Full_Name__c,Loan_Application__c,Primary_Contact__c,Total_AUM__c from Borrowers__c 
                 where Loan_Application__c =:LoanId AND Primary_Contact__c = true];

        List<Borrowers__c> lstBrow = new List<Borrowers__c>();
        lstBrow = [Select Id,Split_of_Total_AUM__c,Backend_Split__c,AUM_Attributable__c,Contact__c,CLO_Customer_Group__c,CLO_Customer_ID__c,
                  Current_Firm_Name__c,Hire_Date__c,Master_Rep_ID__c,Repayable_Split__c,Sub_Loan_Amount__c,Sub_Loan_Split__c,VAUM__c,
                  Current_Firm_Type__c,Enterprise_Name__c,Full_Name__c,Loan_Application__c,Primary_Contact__c,Total_AUM__c,Repayable_Loan_Amount__c,
                  Contact__r.CLO_Customer_ID__c,Contact__r.Name from Borrowers__c 
                  where Loan_Application__c =:LoanId];

        List<Id> broIds = new List<Id>();       
                 for (Borrowers__c lstBroId : lstBro) {
                     broIds.add(lstBroId.Contact__c);
                 }
              
                 system.debug('!!!!!!!!lstBro'+lstBro);
        
        system.debug('dpEndpoint-------'+dpEndpoint);
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('Base URL: ' + sfdcBaseURL );  
        
        String endpoint = ''; 
              
        if(sfdcBaseURL.contains('lplmainorg--qa')){
           endpoint = dpEndpoint.DataPowerQAEndpoint__c;  
        }else if(sfdcBaseURL.contains('lplmainorg--finance')){
            endpoint = dpEndpoint.DataPowerDEVEndpoint__c;
        }else if(sfdcBaseURL.contains('lplmainorg--int1')){
            endpoint = dpEndpoint.DataPowerDEVINTEndpoint__c;
        }else if(sfdcBaseURL.contains('lplmainorg.')){
            endpoint = dpEndpoint.DataPowerPRODEndpoint__c;
        }
       HttpRequest req = new HttpRequest();
       req.setEndpoint(endpoint+dpEndpoint.DataPowerAccessTokenAPI__c);
       req.setMethod('POST');
       req.setHeader('Authorization', dpEndpoint.DataPowerAccessTokenAuthHeader__c);
       req.setBody(dpEndpoint.DataPowerAccessTokenUpdateLoanAPIBody__c);
       
       Http http = new Http();
       HTTPResponse res = http.send(req);
       // Start CH01
        if(res.getStatusCode() != 200){
            LPL_CreateExceptionLog.createErrorRecordForSFMuleAPIFailure('cls_LPL_SendLoan_ProposalUpdatestoMule','makePostCallout',79,dpEndpoint.DataPowerAccessTokenUpdateLoanAPIBody__c,
            res.getBody(),'Data Power',res.getStatus(),res.getStatusCode(),LoanId,null);
        }else{ // End CH01
       System.debug(JSON.deserializeUntyped(res.getBody()));
       Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
       string accessToken = (string)metadata_Map.get('access_token');
       system.debug('token-----------'+accesstoken);
       HttpRequest req1 = new HttpRequest();
             req1.setEndpoint(endpoint+dpEndpoint.DataPowerSFDataToCLOUpdateApplicationAPI__c);
             req1.setMethod('POST');
             req1.setTimeout(60000); 
             req1.setHeader('Content-Type', 'application/json');
             req1.setHeader('Authorization', 'Bearer ' +accessToken);
        
        List<Contact> con = new List<Contact>();
        //Loan_Application__c loanApp = [select CLO_Application_ID__c,Application_Type__c,Business_Name_DBA__c,Requested_Funding_Date__c,Id,Preparer_Name__c,Preparer_Email__c,Servicer_Name__c,Servicer_Email__c,Assigned_Recruiter__c,Assigned_Recruiter_Email__c,Internal_Recruiter__c,Internal_Recruiter_Email__c,Business_Developer__c,Business_Developer_Email__c,Business_Consultant_RM__c,Business_Consultant_RM_Email__c,Status__c,CreatedDate,CreatedByID,Created_By_Email__c,Primary_Contact__c,Number_of_LPL_Loans_Outstanding__c,Loan_Purpose__c,Loan_Category__c,Requested_Loan_Amount__c,Requested_Loan_Term__c,Current_Custodian__c,Number_of_Advisors__c,Mutual_Funds_Custodied__c,Direct_Mutual_Funds__c,AUM_Total_Mutual_Funds__c,AUM_Variable_Annuities__c,AUM_Fixed_Annuities__c,AUM_Equity__c,AUM_Fixed_Income__c,AUM_AI_UIT_Cash__c,Total_Advisory_AUM__c,Total_Brokerage_AUM__c,Total_AUM__c,Percentage_of_Mutual_Funds_Held_Direct__c,Percentage_of_Mutual_Funds_Held_Custodie__c,Percentage_of_Total_Mutual_Funds__c,Percentage_of_Variable_Annuities__c,Percentage_of_Fixed_Annuities__c,Percentage_of_Equity__c,Percentage_of_Fixed_Income__c,Percentage_of_Total_Brokerage_AUM__c,Percentage_of_Total_Advisory_AUM__c,Percentage_of_Total_AUM__c,Advisory_Revenue_c__c,Brokerage_Revenue__c,Total_Production__c,Percentage_GDC_ROA__c,Percentage_Split_of_Total_AUM__c,AUM_Attributable__c,Additional_Comments__c,Current_Firm_Name__c,Current_Firm_Type__c,Current_Registration__c,Asset_Status__c,U_W_Type__c,Campaign_Name__c,Modified_R_Type__c,GP_ROA__c,YTD_GDC__c,Prior_Yr_GDC__c,Interest_Rate__c,Advisor_Total_Advisory_AUM__c,Advisor_Total_Brokerage_AUM__c,Advisor_Total_AUM__c,Estimated_Credit_Score__c,Succession_Plan__c,Approved_T12__c,Verified_AUM__c from Loan_Application__c where id = 'a000R000002mbgXQAQ'];
         //Bhanu Changes start
        Loan_Application__c loanApp = [select Expected_AUM__c,RecordType.developername,OSJ_Manager_ID__c, RIA_Firm_ID__c,RIA_Firm_Name__c,Name,CurrentCustodian__c,Advisor_TotalAnnual_Income__c,Advisor_DebtService_Coverage__c,Seller_Note_Remaining_Term_Monthly__c,Seller_s_Name__c,Seller_Note_Payment_months__c,Seller_Debt_Amount__c,Is_Seller_Staying_on_receiving_salary__c,Seller_Note_Rate__c,Seller_Note_Amount__c,LPL_loan_or_an_external_loan__c,Will_You_Assume_Seller_Debt__c,Anticipated_Change_in_Annual_Operating__c,Annual_Acquisition_Operating_Expense__c,Annual_Acquisition_Revenue__c,Estimated_Down_Payment__c,Total_Purchase_Price__c,Total_Annual_Personal_Expenditures__c,Ownership_of_Business__c,Estimated_Officers_Compensation__c,Total_Annual_Business_Expenditures__c,Total_Gross_Revenue__c,Percentage_of_AI_UIT_Cash__c,CLO_Customer_Group_Name__c,Advisor__c,CLO_Application_ID__c,Application_Type__c,Business_Name_DBA__c,Requested_Funding_Date__c,Id,Preparer_Name__c,Preparer_Email__c,Servicer_Name__c,Servicer_Email__c,Assigned_Recruiter__c,Assigned_Recruiter_Email__c,Internal_Recruiter__c,Internal_Recruiter_Email__c,Business_Developer__c,Business_Developer_Email__c,Business_Consultant_RM__c,Business_Consultant_RM_Email__c,Status__c,CreatedDate,CreatedByID,Created_By_Email__c,Primary_Contact__c,Number_of_LPL_Loans_Outstanding__c,Loan_Purpose__c,Loan_Category__c,Requested_Loan_Amount__c,Requested_Loan_Term__c,Current_Custodian__c,Number_of_Advisors__c,Mutual_Funds_Custodied__c,Direct_Mutual_Funds__c,AUM_Total_Mutual_Funds__c,AUM_Variable_Annuities__c,AUM_Fixed_Annuities__c,AUM_Equity__c,AUM_Fixed_Income__c,AUM_AI_UIT_Cash__c,Total_Advisory_AUM__c,Total_Brokerage_AUM__c,Total_AUM__c,Percentage_of_Mutual_Funds_Held_Direct__c,Percentage_of_Mutual_Funds_Held_Custodie__c,Percentage_of_Total_Mutual_Funds__c,Percentage_of_Variable_Annuities__c,Percentage_of_Fixed_Annuities__c,Percentage_of_Equity__c,Percentage_of_Fixed_Income__c,Percentage_of_Total_Brokerage_AUM__c,Percentage_of_Total_Advisory_AUM__c,Percentage_of_Total_AUM__c,Advisory_Revenue_c__c,Brokerage_Revenue__c,Total_Production__c,Percentage_GDC_ROA__c,Percentage_Split_of_Total_AUM__c,AUM_Attributable__c,Additional_Comments__c,Current_Firm_Name__c,Current_Firm_Type__c,Current_Registration__c,Asset_Status__c,U_W_Type__c,Campaign_Name__c,Modified_R_Type__c,GP_ROA__c,YTD_GDC__c,Prior_Yr_GDC__c,Interest_Rate__c,Advisor_Total_Advisory_AUM__c,Advisor_Total_Brokerage_AUM__c,Advisor_Total_AUM__c,Estimated_Credit_Score__c,Succession_Plan__c,CreatedBy.Name,Primary_Contact_Name__c,Primary_Contact_Name__r.Email,Primary_Contact_Name__r.Name,CLO_Customer_Group_ID__c,RecordType.Name,Record_Type__c,Assigned_Recruiter__r.Name,Assigned_Recruiter__r.Email,Internal_Recruiter__r.Name,Internal_Recruiter__r.Email,Business_Developer__r.Name,Business_Developer__r.Email,Business_Consultant_RM__r.Name,Business_Consultant_RM__r.Email,Current_Custodian__r.Name,Current_Custodian__r.Email,Approved_T12__c,Verified_AUM__c from Loan_Application__c where id =:LoanId];
        //Ends
        //Proposal_Offer__c poOff = [Select Loan_Category__c,TA_Amount__c,Proposal_Status__c,Platform__c,Branch__c,OSJ__c,TA_Program__c,Loan_Term__c,Interest_Rate__c,TA_of_VAUM__c,Expected_EAUM__c,Verified_AUM__c,Level_Payout__c,Backend_Bps__c,Backend_Hurdle__c,Note_Length__c,Proposal_Name__c,Loan_Amount__c,Id,CLO_Proposal_ID__c from Proposal_Offer__c where id = 'a010R000007Lsg4QAC'];
        list<Proposal_Offer__c> poOff = [Select RecordType.developername,U_W_Type__c,Loan_Category__c,OSJ_Amount__c,TA_Amount__c,Proposal_Status__c,Platform__c,Branch__c,OSJ__c,TA_Program__c,Loan_Term__c,Interest_Rate__c,TA_of_VAUM__c,Expected_EAUM__c,Verified_AUM__c,Level_Payout__c,Backend_Bps__c,Backend_Hurdle__c,Note_Length__c,Proposal_Name__c,Loan_Amount__c,Id,Admin_Fees__c,Admin_fee__c,Application_Type__c,Approved_T12__c,Campaign__c,Date__c,DBA_Business_Name__c,Expiration__c,Fee_Waivers__c,LoanApp_MD__c,Loan_Clause__c,Loan_Purpose__c,Loan_Type__c,Notes__c,Offer_Accepted__c,
        // TA_of_EAUM__c, ch07 CS-2847
        Record_type__c, CLO_Proposal_ID__c,Status__c,Offer_Name__c,OSJ_Manager_Name__c,OSJ_LE_Branch__c,Max_TA_Amount__c,Firm_AUM__c,Breakage_Discount_Percent__c,Breakage_Discount__c,Expected_AUM__c,Total_Production__c,TA_of_Verified_AUM_Percent__c,TA_of_Expected_AUM__c,TA_of_GDC__c,ROIC__c,Payback__c,Gross_profit__c,GP_ROA__c from Proposal_Offer__c where id IN :PropIds];
        //Contact con = [Select ID,Master_Rep_ID__c ,clcommon__Legal_Entity_Type__c,RecordTypeId,Hire_Date__c,FirstName,Middle_Name__c,LastName,Name,CRD_Number__c,Branch_ID__c,OSJ_MGR_ID__c,OSJ_MGR_Name__c,OSJ_ID__c,Engagement_Index_Score__c,Net_Promoter_Score__c,of_Advisors__c,LPLCRM__U_S_Citizenship__c,Birthdate,LPLCRM__Social_Security_Tax_ID__c,MailingAddress,MailingCity,MailingState,MailingPostalCode,MobilePhone,Enterprise_Name__c from Contact where Id = '0030R00000zSINoQAO'];
       // if(loanApp.RecordType.developername == 'Forgivable_loan' || loanApp.RecordType.developername == 'Working_Capital'){
            con = [Select ID,Master_Rep_ID__c,clcommon__Legal_Entity_Type__c,Estimated_Credit_Score__c,Modified_R_Type__c,Current_Firm_Type__c,Current_Firm_Name__c,AUM_Attributable__c,Split_of_Total_AUM__c,RecordType.Name,CLO_Customer_ID__c,CLO_Customer_Group_Name__c,Legal_Entity__c,RecordTypeId,Hire_Date__c,FirstName,Middle_Name__c,LastName,Name,CRD_Number__c,Branch_ID__c,OSJ_MGR_ID__c,OSJ_MGR_Name__c,OSJ_ID__c,Engagement_Index_Score__c,Net_Promoter_Score__c,of_Advisors__c,LPLCRM__U_S_Citizenship__c,Birthdate,LPLCRM__Social_Security_Tax_ID__c,MailingAddress,MailingCity,MailingState,MailingPostalCode,MailingCountry,MailingStreet,MobilePhone,Enterprise_Name__c,Email,Fax,Citizenship_Status__c,CLO_Customer_group_ID__c,GP_ROA__c,YTD_GDC__c,Prior_Yr_GDC__c,Advisor_Total_Advisory_AUM__c,Advisor_Total_Brokerage_AUM__c,Advisor_Total_AUM__c from Contact where Id IN :broIds];
       // }else{
           //con = [Select ID,Master_Rep_ID__c,clcommon__Legal_Entity_Type__c,Estimated_Credit_Score__c,Modified_R_Type__c,Current_Firm_Type__c,Current_Firm_Name__c,AUM_Attributable__c,Split_of_Total_AUM__c,RecordType.Name,CLO_Customer_ID__c,CLO_Customer_Group_Name__c,Legal_Entity__c,RecordTypeId,Hire_Date__c,FirstName,Middle_Name__c,LastName,Name,CRD_Number__c,Branch_ID__c,OSJ_MGR_ID__c,OSJ_MGR_Name__c,OSJ_ID__c,Engagement_Index_Score__c,Net_Promoter_Score__c,of_Advisors__c,LPLCRM__U_S_Citizenship__c,Birthdate,LPLCRM__Social_Security_Tax_ID__c,MailingAddress,MailingCity,MailingState,MailingPostalCode,MailingCountry,MailingStreet,MobilePhone,Enterprise_Name__c,Email,Fax,Citizenship_Status__c,CLO_Customer_group_ID__c,GP_ROA__c,YTD_GDC__c,Prior_Yr_GDC__c,Advisor_Total_Advisory_AUM__c,Advisor_Total_Brokerage_AUM__c,Advisor_Total_AUM__c from Contact where Id = :loanApp.Advisor__c];
       // }    
        list<Contact> lstCon = new List<Contact>();
        //DateTime myDateTime = DateTime.newInstance(1993, 6, 6, 3, 3, 3);
        //String formatted = myDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        //gen.writeStringField('Authorization', 'Bearer ' +accessToken);
        gen.writeStringField('applicationid', loanApp.ID);
        gen.writeFieldName('loanapplication');
        gen.writeStartObject(); 
        gen.writeFieldName('applicationdetails');
        //gen.writeObject(loanApp);
        gen.writeStartObject(); 
         gen.writeStringField('Id', loanApp.Id);
         gen.writeStringField('Name', loanApp.Name);
        // gen.writeStringField('CreatedDate',loanApp.CreatedDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'));
        gen.writeDateTimeField('CreatedDate',loanApp.CreatedDate);
        gen.writeStringField('CreatedBy',loanApp.CreatedBy.Name);
         gen.writeStringField('Created_By_Email__c',loanApp.Created_By_Email__c);
         //gen.writeStringField('RecordType',loanApp.RecordType.Name);
         // Send Backend Transition Assistance instead of Backend TA
        if(loanApp.RecordType.Name == 'Backend TA'){
            gen.writeStringField('RecordType','Backend Transition Assistance');
        }else{
            gen.writeStringField('RecordType',loanApp.RecordType.Name);
        }
         gen.writeBooleanField('Succession_Plan__c',loanApp.Succession_Plan__c);
         gen.writeStringField('AdvisorJoiningRIAorCorp','NA');
         gen.writeStringField('AdvisorPriorFirmType','NA');
         
             //Modified By Bhanu 7/23/2020 Changes starts
  if(loanApp.RecordType.developername == 'Forgivable_loan' || loanApp.RecordType.developername == 'Working_Capital')
  {
       if(loanApp.OSJ_Manager_ID__c == null || loanApp.OSJ_Manager_ID__c == '')
     {
            gen.writeStringField('OSJ_Manager_ID__c', '');
        }else{
            gen.writeStringField('OSJ_Manager_ID__c', loanApp.OSJ_Manager_ID__c);
        }
     if(loanApp.RIA_Firm_ID__c == null || loanApp.RIA_Firm_ID__c == ''){
            gen.writeStringField('RIA_Firm_ID__c', '');
        }else{
            gen.writeStringField('RIA_Firm_ID__c', loanApp.RIA_Firm_ID__c);
        }
     if(loanApp.RIA_Firm_Name__c == null || loanApp.RIA_Firm_Name__c == ''){
            gen.writeStringField('RIA_Firm_Name__c', '');
        }else{
            gen.writeStringField('RIA_Firm_Name__c', loanApp.RIA_Firm_Name__c);
        }
  }
  //End
         
            if(loanApp.Status__c == null || loanApp.Status__c == ''){
                gen.writeStringField('Status__c', '');
            }else{
                gen.writeStringField('Status__c', loanApp.Status__c);
            }
            if(loanApp.Primary_Contact_Name__c == null){
                gen.writeStringField('Primary_Contact_Name__c', '');
               // gen.writeStringField('Primary_Contact_Email__c', '');
            }else{
                gen.writeStringField('Primary_Contact_Name__c', loanApp.Primary_Contact_Name__r.Name);
               // gen.writeStringField('Primary_Contact_Email__c', loanApp.Primary_Contact_Name__r.Email);
            }
          if(con != null ){
                if(con[0].CLO_Customer_ID__c != ''){
                    gen.writeStringField('CLO_Customer_ID__c', con[0].CLO_Customer_ID__c);
                }else{
                    gen.writeStringField('CLO_Customer_ID__c', '');
                }
                //gen.writeStringField('CLO_Customer_ID__c', '');
               // gen.writeStringField('Primary_Contact_Email__c', '');
            }
            else{
                    gen.writeStringField('CLO_Customer_ID__c', '');
               // gen.writeStringField('Primary_Contact_Email__c', loanApp.Primary_Contact_Name__r.Email);
            }
                
            if(loanApp.Primary_Contact_Name__r.Email == null || loanApp.Primary_Contact_Name__r.Email == ''){
                gen.writeStringField('Primary_Contact_Email__c', '');
            }else{
               gen.writeStringField('Primary_Contact_Email__c', loanApp.Primary_Contact_Name__r.Email); 
            }
           
            if(loanApp.Asset_Status__c == null || loanApp.Asset_Status__c == ''){
                gen.writeStringField('Asset_Status__c', '');
            }else{
                gen.writeStringField('Asset_Status__c', loanApp.Asset_Status__c);
            }
            //Start CH02 
            if(loanApp.Business_Name_DBA__c == null || loanApp.Business_Name_DBA__c == ''){
                gen.writeStringField('Business_Name_DBA__c', '');
            }else{
                gen.writeStringField('Business_Name_DBA__c', loanApp.Business_Name_DBA__c);
            }
            //End CH02 
            if(loanApp.Loan_Purpose__c == null || loanApp.Loan_Purpose__c == ''){
                gen.writeStringField('Loan_Purpose__c', '');
            }else{
                gen.writeStringField('Loan_Purpose__c', loanApp.Loan_Purpose__c);
            }
            /*if(loanApp.Current_Firm_Name__c == null || loanApp.Current_Firm_Name__c == ''){
                gen.writeStringField('Current_Firm_Name__c', '');
            }else{
                gen.writeStringField('Current_Firm_Name__c', loanApp.Current_Firm_Name__c);
            }*/
            if(loanApp.Current_Registration__c == null || loanApp.Current_Registration__c == ''){
                gen.writeStringField('Current_Registration__c', '');
            }else{
                gen.writeStringField('Current_Registration__c', loanApp.Current_Registration__c);
            }
            /*if(loanApp.Current_Firm_Type__c == null || loanApp.Current_Firm_Type__c == ''){
                gen.writeStringField('Current_Firm_Type__c', '');
            }else{
                gen.writeStringField('Current_Firm_Type__c', loanApp.Current_Firm_Type__c);
            }*/
            if(loanApp.Loan_Category__c == null || loanApp.Loan_Category__c == ''){
                gen.writeStringField('Loan_Category__c', '');
            }else{
                

                if(loanApp.Loan_Category__c=='Forgivable Loan'){
                    gen.writeStringField('Loan_Category__c','Forgivable' );
                }
                else{
                    gen.writeStringField('Loan_Category__c', 'Repayable');
                }                
                
            }
            if(loanApp.CurrentCustodian__c == null || loanApp.CurrentCustodian__c == ''){
                gen.writeStringField('Current_Custodian__c', '');
            }else{
                gen.writeStringField('Current_Custodian__c', loanApp.CurrentCustodian__c);
            }
            if(loanApp.Assigned_Recruiter__c == null){
                gen.writeStringField('Assigned_Recruiter__c', '');
            }else{
                gen.writeStringField('Assigned_Recruiter__c', loanApp.Assigned_Recruiter__r.Name);
            }
             
            if(loanApp.Assigned_Recruiter_Email__c == null){
                gen.writeStringField('Assigned_Recruiter_Email__c', '');
            }else{
                gen.writeStringField('Assigned_Recruiter_Email__c', loanApp.Assigned_Recruiter_Email__c);
            }
            
            if(loanApp.Internal_Recruiter__c == null ){
                gen.writeStringField('Internal_Recruiter__c', '');
            }else{
                gen.writeStringField('Internal_Recruiter__c', loanApp.Internal_Recruiter__r.Name);
            }
             
            if(loanApp.Internal_Recruiter_Email__c == null || loanApp.Internal_Recruiter_Email__c == ''){
                gen.writeStringField('Internal_Recruiter_Email__c', '');
            }else{
                gen.writeStringField('Internal_Recruiter_Email__c', loanApp.Internal_Recruiter_Email__c);
            }
              
            if(loanApp.Business_Developer__c == null){
                gen.writeStringField('Business_Developer__c', '');
            }else{
                gen.writeStringField('Business_Developer__c', loanApp.Business_Developer__r.Name);
            }
            
            if(loanApp.Business_Developer_Email__c == null || loanApp.Business_Developer_Email__c == ''){
                gen.writeStringField('Business_Developer_Email__c', '');
            }else{
                gen.writeStringField('Business_Developer_Email__c', loanApp.Business_Developer_Email__c);
            }
             

            if(loanApp.Requested_Funding_Date__c == null){
                gen.writeStringField('Requested_Funding_Date__c', '');
            }else{
                gen.writeDateField('Requested_Funding_Date__c', loanApp.Requested_Funding_Date__c);
            }
            if(loanApp.Number_of_LPL_Loans_Outstanding__c == null){
                gen.writeNumberField('Number_of_LPL_Loans_Outstanding__c', 0);
            }else{
                gen.writeNumberField('Number_of_LPL_Loans_Outstanding__c', loanApp.Number_of_LPL_Loans_Outstanding__c);
            }
            //CH05 Start
            if(loanApp.Expected_AUM__c == null){
                gen.writeNumberField('Expected_AUM__c', 0);
            }else{
                gen.writeNumberField('Expected_AUM__c', loanApp.Expected_AUM__c);
            }
            //CH05 End
            if(loanApp.Number_of_Advisors__c == null){
                gen.writeNumberField('Number_of_Advisors__c', 0);
            }else{
                gen.writeNumberField('Number_of_Advisors__c', loanApp.Number_of_Advisors__c);
            }
            if(loanApp.Additional_Comments__c == null || loanApp.Additional_Comments__c == ''){
                gen.writeStringField('Additional_Comments__c', '');
            }else{
                gen.writeStringField('Additional_Comments__c', loanApp.Additional_Comments__c);
            }
            if(loanApp.CLO_Application_ID__c == null || loanApp.CLO_Application_ID__c == ''){
                gen.writeStringField('CLO_Application_ID__c', '');
            }else{
                gen.writeStringField('CLO_Application_ID__c', loanApp.CLO_Application_ID__c);
            }
            if(loanApp.Application_Type__c == null || loanApp.Application_Type__c == ''){
                gen.writeStringField('Application_Type__c', '');
            }else{
                gen.writeStringField('Application_Type__c', loanApp.Application_Type__c);
            }
            if(loanApp.CLO_Customer_Group_Name__c == null || loanApp.CLO_Customer_Group_Name__c == ''){
                gen.writeStringField('CLO_Customer_Group_Name__c', '');
            }else{
                gen.writeStringField('CLO_Customer_Group_Name__c', loanApp.CLO_Customer_Group_Name__c);
            }
            if(loanApp.CLO_Customer_Group_ID__c == null || loanApp.CLO_Customer_Group_ID__c == ''){
                gen.writeStringField('CLO_Customer_Group_ID__c', '');
            }else{
                gen.writeStringField('CLO_Customer_Group_ID__c', loanApp.CLO_Customer_Group_ID__c);
            }
            if(loanApp.Preparer_Name__c == null || loanApp.Preparer_Name__c == ''){
                gen.writeStringField('Preparer_Name__c', '');
            }else{
                gen.writeStringField('Preparer_Name__c', loanApp.Preparer_Name__c);
            }
            if(loanApp.Preparer_Email__c == null || loanApp.Preparer_Email__c == ''){
                gen.writeStringField('Preparer_Email__c', '');
            }else{
                gen.writeStringField('Preparer_Email__c', loanApp.Preparer_Email__c);
            }
            if(loanApp.Servicer_Name__c == null || loanApp.Servicer_Name__c == ''){
                gen.writeStringField('Servicer_Name__c', '');
            }else{
                gen.writeStringField('Servicer_Name__c', loanApp.Servicer_Name__c);
            }
            if(loanApp.Servicer_Email__c == null || loanApp.Servicer_Email__c == ''){
                gen.writeStringField('Servicer_Email__c', '');
            }else{
                gen.writeStringField('Servicer_Email__c', loanApp.Servicer_Email__c);
            }
            if(loanApp.Requested_Loan_Amount__c == null){
                gen.writeNumberField('Requested_Loan_Amount__c', 0);
            }else{
                gen.writeNumberField('Requested_Loan_Amount__c', loanApp.Requested_Loan_Amount__c);
            }
            if(loanApp.Requested_Loan_Term__c == null){
                gen.writeNumberField('Requested_Loan_Term__c', 0);
            }else{
                gen.writeNumberField('Requested_Loan_Term__c', loanApp.Requested_Loan_Term__c);
            }
            if(loanApp.Mutual_Funds_Custodied__c == null){
                gen.writeNumberField('Mutual_Funds_Custodied__c', 0);
            }else{
                gen.writeNumberField('Mutual_Funds_Custodied__c', loanApp.Mutual_Funds_Custodied__c);
            }
            if(loanApp.Direct_Mutual_Funds__c == null){
                gen.writeNumberField('Direct_Mutual_Funds__c', 0);
            }else{
                gen.writeNumberField('Direct_Mutual_Funds__c', loanApp.Direct_Mutual_Funds__c);
            }
            if(loanApp.AUM_Total_Mutual_Funds__c == null ){
                gen.writeNumberField('AUM_Total_Mutual_Funds__c', 0);
            }else{
                gen.writeNumberField('AUM_Total_Mutual_Funds__c', loanApp.AUM_Total_Mutual_Funds__c);
            }
            if(loanApp.AUM_Variable_Annuities__c == null ){
                gen.writeNumberField('AUM_Variable_Annuities__c', 0);
            }else{
                gen.writeNumberField('AUM_Variable_Annuities__c', loanApp.AUM_Variable_Annuities__c);
            }
            if(loanApp.AUM_Fixed_Annuities__c == null ){
                gen.writeNumberField('AUM_Fixed_Annuities__c', 0);
            }else{
                gen.writeNumberField('AUM_Fixed_Annuities__c', loanApp.AUM_Fixed_Annuities__c);
            }
            if(loanApp.AUM_Equity__c == null ){
                gen.writeNumberField('AUM_Equity__c', 0);
            }else{
                gen.writeNumberField('AUM_Equity__c', loanApp.AUM_Equity__c);
            }
            if(loanApp.AUM_Fixed_Income__c == null ){
                gen.writeNumberField('AUM_Fixed_Income__c', 0);
            }else{
                gen.writeNumberField('AUM_Fixed_Income__c', loanApp.AUM_Fixed_Income__c);
            }
            if(loanApp.AUM_AI_UIT_Cash__c == null ){
                gen.writeNumberField('AUM_AI_UIT_Cash__c', 0);
            }else{
                gen.writeNumberField('AUM_AI_UIT_Cash__c', loanApp.AUM_AI_UIT_Cash__c);
            }
            if(loanApp.Total_Advisory_AUM__c == null ){
                gen.writeNumberField('Total_Advisory_AUM__c', 0);
            }else{
                gen.writeNumberField('Total_Advisory_AUM__c', loanApp.Total_Advisory_AUM__c);
            }
            if(loanApp.Total_Brokerage_AUM__c == null ){
                gen.writeNumberField('Total_Brokerage_AUM__c', 0);
            }else{
                gen.writeNumberField('Total_Brokerage_AUM__c', loanApp.Total_Brokerage_AUM__c);
            }
            if(loanApp.Total_AUM__c == null ){
                gen.writeNumberField('Total_AUM__c', 0);
            }else{
                gen.writeNumberField('Total_AUM__c', loanApp.Total_AUM__c);
            }
            if(loanApp.Percentage_of_Mutual_Funds_Held_Direct__c == null ){
                gen.writeNumberField('Percentage_of_Mutual_Funds_Held_Direct__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Mutual_Funds_Held_Direct__c', loanApp.Percentage_of_Mutual_Funds_Held_Direct__c);
            }
            if(loanApp.Percentage_of_Mutual_Funds_Held_Custodie__c == null ){
                gen.writeNumberField('Percentage_of_Mutual_Funds_Held_Custodie__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Mutual_Funds_Held_Custodie__c', loanApp.Percentage_of_Mutual_Funds_Held_Custodie__c);
            }
            if(loanApp.Percentage_of_Total_Mutual_Funds__c == null ){
                gen.writeNumberField('Percentage_of_Total_Mutual_Funds__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Total_Mutual_Funds__c', loanApp.Percentage_of_Total_Mutual_Funds__c);
            }
            if(loanApp.Percentage_of_Variable_Annuities__c == null ){
                gen.writeNumberField('Percentage_of_Variable_Annuities__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Variable_Annuities__c', loanApp.Percentage_of_Variable_Annuities__c);
            }
            if(loanApp.Percentage_of_Fixed_Annuities__c == null ){
                gen.writeNumberField('Percentage_of_Fixed_Annuities__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Fixed_Annuities__c', loanApp.Percentage_of_Fixed_Annuities__c);
            }
            if(loanApp.Percentage_of_Equity__c == null ){
                gen.writeNumberField('Percentage_of_Equity__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Equity__c', loanApp.Percentage_of_Equity__c);
            }
            if(loanApp.Percentage_of_Fixed_Income__c == null ){
                gen.writeNumberField('Percentage_of_Fixed_Income__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Fixed_Income__c', loanApp.Percentage_of_Fixed_Income__c);
            }
            if(loanApp.Percentage_of_AI_UIT_Cash__c == null ){
                gen.writeNumberField('Percentage_of_AI_UIT_Cash__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_AI_UIT_Cash__c', loanApp.Percentage_of_AI_UIT_Cash__c);
            }
            if(loanApp.Percentage_of_Total_Brokerage_AUM__c == null ){
                gen.writeNumberField('Percentage_of_Total_Brokerage_AUM__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Total_Brokerage_AUM__c', loanApp.Percentage_of_Total_Brokerage_AUM__c);
            }
            if(loanApp.Percentage_of_Total_Advisory_AUM__c == null ){
                gen.writeNumberField('Percentage_of_Total_Advisory_AUM__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Total_Advisory_AUM__c', loanApp.Percentage_of_Total_Advisory_AUM__c);
            }
            if(loanApp.Percentage_of_Total_AUM__c == null ){
                gen.writeNumberField('Percentage_of_Total_AUM__c', 0);
            }else{
                gen.writeNumberField('Percentage_of_Total_AUM__c', loanApp.Percentage_of_Total_AUM__c);
            }
            if(loanApp.Advisory_Revenue_c__c == null ){
                gen.writeNumberField('Advisory_Revenue_c__c', 0);
            }else{
                gen.writeNumberField('Advisory_Revenue_c__c', loanApp.Advisory_Revenue_c__c);
            }
            if(loanApp.Brokerage_Revenue__c == null ){
                gen.writeNumberField('Brokerage_Revenue__c', 0);
            }else{
                gen.writeNumberField('Brokerage_Revenue__c', loanApp.Brokerage_Revenue__c);
            }

            if(loanApp.Total_Production__c == null ){
                gen.writeNumberField('Total_Production__c', 0);
            }else{
                gen.writeNumberField('Total_Production__c', loanApp.Total_Production__c);
            }
            if(loanApp.Percentage_GDC_ROA__c == null ){
                gen.writeNumberField('Percentage_GDC_ROA__c', 0);
            }else{
                gen.writeNumberField('Percentage_GDC_ROA__c', loanApp.Percentage_GDC_ROA__c);
            }
           /* if(loanApp.Percentage_Split_of_Total_AUM__c == null ){
                gen.writeNumberField('Percentage_Split_of_Total_AUM__c', 0);
            }else{
                gen.writeNumberField('Percentage_Split_of_Total_AUM__c', loanApp.Percentage_Split_of_Total_AUM__c);
            }
            if(loanApp.AUM_Attributable__c == null ){
                gen.writeNumberField('AUM_Attributable__c', 0);
            }else{
                gen.writeNumberField('AUM_Attributable__c', loanApp.AUM_Attributable__c);
            }*/
            if(loanApp.Interest_Rate__c == null ){
                gen.writeNumberField('Interest_Rate__c', 0);
            }else{
                gen.writeNumberField('Interest_Rate__c', loanApp.Interest_Rate__c);
            }
          /*  if(loanApp.Advisor_Total_Advisory_AUM__c == null ){
                gen.writeNumberField('Advisor_Total_Advisory_AUM__c', 0);
            }*/
           /* if(loanApp.Advisor_Total_Brokerage_AUM__c == null ){
                gen.writeNumberField('Advisor_Total_Brokerage_AUM__c', 0);
            }*/
           /* if(loanApp.Advisor_Total_AUM__c == null ){
                gen.writeNumberField('Advisor_Total_AUM__c', 0);
            }*/
            if(loanApp.Total_Gross_Revenue__c == null ){
                gen.writeNumberField('Total_Gross_Revenue__c', 0);
            }else{
                gen.writeNumberField('Total_Gross_Revenue__c', loanApp.Total_Gross_Revenue__c);
            }
            if(loanApp.Total_Annual_Business_Expenditures__c == null ){
                gen.writeNumberField('Total_Annual_Business_Expenditures__c', 0);
            }else{
                gen.writeNumberField('Total_Annual_Business_Expenditures__c', loanApp.Total_Annual_Business_Expenditures__c);
            }
            if(loanApp.Estimated_Officers_Compensation__c == null ){
                gen.writeNumberField('Estimated_Officers_Compensation__c', 0);
            }else{
                gen.writeNumberField('Estimated_Officers_Compensation__c', loanApp.Estimated_Officers_Compensation__c);
            }
            if(loanApp.Ownership_of_Business__c == null ){
                gen.writeNumberField('Ownership_of_Business__c', 0);
            }else{
                gen.writeNumberField('Ownership_of_Business__c', loanApp.Ownership_of_Business__c);
            }
            if(loanApp.Total_Annual_Personal_Expenditures__c == null ){
                gen.writeNumberField('Total_Annual_Personal_Expenditures__c', 0);
            }else{
                gen.writeNumberField('Total_Annual_Personal_Expenditures__c', loanApp.Total_Annual_Personal_Expenditures__c);
            }
            if(loanApp.Advisor_TotalAnnual_Income__c == null ){
            gen.writeNumberField('Advisor_TotalAnnual_Income__c', 0);
        }else{
            gen.writeNumberField('Advisor_TotalAnnual_Income__c', loanApp.Advisor_TotalAnnual_Income__c);
        }
        if(loanApp.Total_Purchase_Price__c == null ){
            gen.writeNumberField('Total_Purchase_Price__c', 0);
        }else{
            gen.writeNumberField('Total_Purchase_Price__c', loanApp.Total_Purchase_Price__c);
        }
        if(loanApp.Estimated_Down_Payment__c == null ){
            gen.writeNumberField('Estimated_Down_Payment__c', 0);
        }else{
            gen.writeNumberField('Estimated_Down_Payment__c', loanApp.Estimated_Down_Payment__c);
        }
        if(loanApp.Advisor_DebtService_Coverage__c == null ){
            gen.writeNumberField('Advisor_DebtService_Coverage__c', 0);
        }else{
            gen.writeNumberField('Advisor_DebtService_Coverage__c', loanApp.Advisor_DebtService_Coverage__c);   
        }
        if(loanApp.Annual_Acquisition_Revenue__c == null ){
            gen.writeNumberField('Annual_Acquisition_Revenue__c', 0);
        }else{
            gen.writeNumberField('Annual_Acquisition_Revenue__c', loanApp.Annual_Acquisition_Revenue__c);
        }
        if(loanApp.Annual_Acquisition_Operating_Expense__c == null ){
            gen.writeNumberField('Annual_Acquisition_Operating_Expense__c', 0);
        }else{
            gen.writeNumberField('Annual_Acquisition_Operating_Expense__c', loanApp.Annual_Acquisition_Operating_Expense__c);
        }
        if(loanApp.Anticipated_Change_in_Annual_Operating__c == null ){
            gen.writeNumberField('Anticipated_Change_in_Annual_Operating__c', 0);
        }else{
            gen.writeNumberField('Anticipated_Change_in_Annual_Operating__c', loanApp.Anticipated_Change_in_Annual_Operating__c);
        }
        if(loanApp.Seller_Note_Amount__c == null ){
            gen.writeNumberField('Seller_Note_Amount__c', 0);
        }else{
            gen.writeNumberField('Seller_Note_Amount__c', loanApp.Seller_Note_Amount__c);
        }
        if(loanApp.Seller_Note_Rate__c == null ){
            gen.writeNumberField('Seller_Note_Rate__c', 0);
        }else{
            gen.writeNumberField('Seller_Note_Rate__c', loanApp.Seller_Note_Rate__c);
        }
        if(loanApp.Seller_Debt_Amount__c == null ){
            gen.writeNumberField('Seller_Debt_Amount__c', 0);
        }else{
            gen.writeNumberField('Seller_Debt_Amount__c', loanApp.Seller_Debt_Amount__c);
        }
        if(loanApp.Seller_Note_Payment_months__c == null ){
            gen.writeNumberField('Seller_Note_Payment_months__c', 0);
        }else{
            gen.writeNumberField('Seller_Note_Payment_months__c', loanApp.Seller_Note_Payment_months__c);
        }
        if(loanApp.Seller_Note_Remaining_Term_Monthly__c == null ){
            gen.writeNumberField('Seller_Note_Remaining_Term_Monthly__c', 0);
        }else{
            gen.writeNumberField('Seller_Note_Remaining_Term_Monthly__c', loanApp.Seller_Note_Remaining_Term_Monthly__c);
        }
        if(loanApp.LPL_loan_or_an_external_loan__c == null || loanApp.LPL_loan_or_an_external_loan__c == ''){
            gen.writeStringField('LPL_loan_or_an_external_loan__c', '');
        }else{
            gen.writeStringField('LPL_loan_or_an_external_loan__c', loanApp.LPL_loan_or_an_external_loan__c);
        }
        if(loanApp.Seller_s_Name__c == null || loanApp.Seller_s_Name__c == ''){
            gen.writeStringField('Seller_s_Name__c', '');
        }else{
            gen.writeStringField('Seller_s_Name__c', loanApp.Seller_s_Name__c);
        }
         
       /* if(loanApp.Business_Consultant_RM__c == null || loanApp.Business_Consultant_RM__c == ''){
                gen.writeStringField('Business_Consultant_RM__c', '');
            }else{
                gen.writeStringField('Business_Consultant_RM__c', loanApp.Business_Consultant_RM__r.Name);
            } 
        */
        /* Added by Anil ***/
        
        /*--New updated code by anil*/
        if(loanApp.Business_Consultant_RM__c != null){
            gen.writeStringField('Business_Consultant_RM__c', loanApp.Business_Consultant_RM__r.Name);
        } else {
            gen.writeStringField('Business_Consultant_RM__c', '');   
        }
        /** End of Anil Code ***/
        
        if(loanApp.Business_Consultant_RM_Email__c == null || loanApp.Business_Consultant_RM_Email__c == ''){
            gen.writeStringField('Business_Consultant_RM_Email__c', '');
        }else{
            gen.writeStringField('Business_Consultant_RM_Email__c', loanApp.Business_Consultant_RM_Email__c);
        }
        /* CS-1620 Added by Madhukar Reddy on 07/15/2020 Started loop */
        if(loanApp.Verified_AUM__c == null){
            gen.writeNumberField('Verified_AUM__c', 0);
        }else{
            gen.writeNumberField('Verified_AUM__c', loanApp.Verified_AUM__c);
        }
        if(loanApp.Approved_T12__c== null){
            gen.writeNumberField('Approved_T12__c', 0);
        }else{
            gen.writeNumberField('Approved_T12__c', loanApp.Approved_T12__c);
        }
        /* CS-1620 Ended by Madhukar Reddy on 07/15/2020  */
        gen.writeEndObject(); 
       // gen.writeFieldName('proposals');
       // gen.writeStartObject();
        //gen.writeObject(poOff);
        gen.writeFieldName('proposals');
        gen.writeStartArray(); 
        for (Proposal_Offer__c pOff : poOff) {
            gen.writeStartObject();
            //gen.writeFieldName('proposals');
           // gen.writeObject(poff);
            gen.writeStringField('Id', pOff.Id);
            gen.writeStringField('LoanApp_MD__c', pOff.LoanApp_MD__c);
            if(loanApp.Primary_Contact_Name__c == null){
                gen.writeStringField('Primary_Contact_Name__c', '');
            }else{
                gen.writeStringField('Primary_Contact_Name__c', loanApp.Primary_Contact_Name__r.Name);
            }

            if(pOff.Offer_Accepted__c == true){
                gen.writeBooleanField('Offer_Accepted__c', true);
            }else{
                gen.writeBooleanField('Offer_Accepted__c', false);
            }
            if(pOff.U_W_Type__c == null || pOff.U_W_Type__c == ''){
                gen.writeStringField('U_W_Type__c', '');
            }else{
                gen.writeStringField('U_W_Type__c', pOff.U_W_Type__c);
            }
           if(pOff.Loan_Category__c == null || pOff.Loan_Category__c == ''){
                gen.writeStringField('Loan_Category__c', '');
            }else{
                if(pOff.Loan_Category__c=='Forgivable Loan'){
                    gen.writeStringField('Loan_Category__c','Forgivable' );
                }
                else{
                    gen.writeStringField('Loan_Category__c', 'Repayable');
                }
                
            }
            if(pOff.Proposal_Status__c == null || pOff.Proposal_Status__c == ''){
                gen.writeStringField('Proposal_Status__c', '');
            }else{
                gen.writeStringField('Proposal_Status__c', pOff.Proposal_Status__c);
            }
            
            if(pOff.OSJ_Manager_Name__c == null || pOff.OSJ_Manager_Name__c == ''){
                gen.writeStringField('OSJ_Manager_Name__c', '');
            }else{
                gen.writeStringField('OSJ_Manager_Name__c', pOff.OSJ_Manager_Name__c);
            }
            if(pOff.CLO_Proposal_ID__c == null || pOff.CLO_Proposal_ID__c == ''){
                gen.writeStringField('CLO_Proposal_ID__c', '');
            }else{
                gen.writeStringField('CLO_Proposal_ID__c', pOff.CLO_Proposal_ID__c);
            }
            //Start CH02 
            if(loanApp.Business_Name_DBA__c == null || loanApp.Business_Name_DBA__c == ''){
                gen.writeStringField('Business_Name_DBA__c', '');
            }else{
                gen.writeStringField('Business_Name_DBA__c', loanApp.Business_Name_DBA__c);
            }
            //End CH02 
            if(pOff.Record_type__c == null || pOff.Record_type__c == ''){
                gen.writeStringField('Record_type__c', '');
            }else{
                gen.writeStringField('Record_type__c', pOff.Record_type__c);
            }
            if(pOff.Platform__c == null || pOff.Platform__c == ''){
                gen.writeStringField('Platform__c', '');
            }else{
                gen.writeStringField('Platform__c', pOff.Platform__c);
            }
            if(loanApp.Loan_Purpose__c == null || loanApp.Loan_Purpose__c == ''){
                gen.writeStringField('Loan_Purpose__c', '');
            }else{
                //gen.writeStringField('Loan_Purpose__c', pOff.Loan_Purpose__c);
                gen.writeStringField('Loan_Purpose__c', loanApp.Loan_Purpose__c);
            }
            if(pOff.Loan_Type__c == null || pOff.Loan_Type__c == ''){
                gen.writeStringField('Loan_Type__c', '');
            }else{
                //gen.writeStringField('Loan_Type__c', pOff.Loan_Type__c);
                //gen.writeStringField('Loan_Type__c', loanApp.RecordType.Name);
                // Send Backend Transition Assistance instead of Backend TA
                if(loanApp.RecordType.Name == 'Backend TA'){
                    gen.writeStringField('Loan_Type__c','Backend Transition Assistance');
                }else{
                    gen.writeStringField('Loan_Type__c',loanApp.RecordType.Name);
                }
            }
            if(pOff.OSJ__c == null || pOff.OSJ__c == ''){
                gen.writeStringField('OSJ__c', '');
            }else{
                gen.writeStringField('OSJ__c', pOff.OSJ__c);
            }
            if(pOff.TA_Program__c == null || pOff.TA_Program__c == ''){
                gen.writeStringField('TA_Program__c', '');
            }else{
                gen.writeStringField('TA_Program__c', pOff.TA_Program__c);
            }
           /* Commented by Amol 09/29 - CS 2175 
           if(pOff.Loan_Term__c == null){
                gen.writeNumberField('Loan_Term__c', 0);
            }else{
                gen.writeNumberField('Loan_Term__c', Integer.valueOf(pOff.Loan_Term__c));
            }*/
            //CS 2175 Added By Amol 09/29/2020 Start
             if(pOff.RecordType.developername == 'TA_Proposal_Record_Type'){
                  if(pOff.Loan_Term__c == null){
                    gen.writeStringField('Loan_Term__c', '');
                  }else{
                    gen.writeStringField('Loan_Term__c', pOff.Loan_Term__c); 
                  }
             }else{
                 if(loanApp.Requested_Loan_Term__c == null){
                    gen.writeStringField('Loan_Term__c', '');
                 }else{
                    gen.writeStringField('Loan_Term__c', string.valueOf(loanApp.Requested_Loan_Term__c));
                }
             }

             //CS 2175 END
           /* ch07 CS-2847 Commmented By Madhukar Reddy TA_of_EAUM__c 2/12/2021 this field is not used in payload
           if(pOff.TA_of_EAUM__c == null || pOff.TA_of_EAUM__c == 0){
                gen.writeNumberField('TA_of_EAUM__c', 0);
            }else{
                gen.writeNumberField('TA_of_EAUM__c', pOff.TA_of_EAUM__c);
            }
            */
            if(pOff.TA_of_VAUM__c == null || pOff.TA_of_VAUM__c == 0){
                gen.writeNumberField('TA_of_VAUM__c', 0);
            }else{
                gen.writeNumberField('TA_of_VAUM__c', pOff.TA_of_VAUM__c);
            }
            if(pOff.Expected_EAUM__c == null || pOff.Expected_EAUM__c == 0){
                gen.writeNumberField('Expected_EAUM__c', 0);
            }else{
                gen.writeNumberField('Expected_EAUM__c', pOff.Expected_EAUM__c);
            }
            if(pOff.Backend_Bps__c == null || pOff.Backend_Bps__c == 0){
                gen.writeNumberField('Backend_Bps__c', 0);
            }else{
                gen.writeNumberField('Backend_Bps__c', pOff.Backend_Bps__c);
            }
            if(pOff.Backend_Hurdle__c == null || pOff.Backend_Hurdle__c == 0){
                gen.writeNumberField('Backend_Hurdle__c', 0);
            }else{
                gen.writeNumberField('Backend_Hurdle__c', pOff.Backend_Hurdle__c);
            }
            if(pOff.Note_Length__c == null || pOff.Note_Length__c == 0){
                gen.writeNumberField('Note_Length__c', 0);
            }else{
                gen.writeNumberField('Note_Length__c', pOff.Note_Length__c);
            }
            if(pOff.Proposal_Name__c == null || pOff.Proposal_Name__c == ''){
                gen.writeStringField('Proposal_Name__c', '');
            }else{
                gen.writeStringField('Proposal_Name__c', pOff.Proposal_Name__c);
            }
            if(pOff.Application_Type__c == null || pOff.Application_Type__c == ''){
                gen.writeStringField('Application_Type__c', '');
            }else{
                gen.writeStringField('Application_Type__c', pOff.Application_Type__c);
            }
            if(pOff.DBA_Business_Name__c == null || pOff.DBA_Business_Name__c == ''){
                gen.writeStringField('DBA_Business_Name__c', '');
            }else{
                gen.writeStringField('DBA_Business_Name__c', pOff.DBA_Business_Name__c);
            }
            if(pOff.Offer_Name__c == null || pOff.Offer_Name__c == ''){
                gen.writeStringField('Offer_Name__c', '');
            }else{
                gen.writeStringField('Offer_Name__c', pOff.Offer_Name__c);
            }
            if(pOff.Date__c == null){
                gen.writeStringField('Date__c', '');
            }else{
                 gen.writeDateField('Date__c', pOff.Date__c);
            }
            if(pOff.Expiration__c == null){
                gen.writeStringField('Expiration__c', '');
            }else{
                gen.writeDateField('Expiration__c', pOff.Expiration__c);
            }
            if(pOff.Level_Payout__c == null || pOff.Level_Payout__c == null){
                gen.writeNumberField('Level_Payout__c', 0);
            }else{
                gen.writeNumberField('Level_Payout__c', pOff.Level_Payout__c);
            }
            if(pOff.Campaign__c == null || pOff.Campaign__c == ''){
                gen.writeStringField('Campaign__c', '');
            }else{
                gen.writeStringField('Campaign__c', pOff.Campaign__c);
            }
            if(pOff.Fee_Waivers__c == null){
                gen.writeNumberField('Fee_Waivers__c', 0);
            }else{
                gen.writeNumberField('Fee_Waivers__c', pOff.Fee_Waivers__c);   
            }
            if(pOff.Admin_fee__c == null){
                gen.writeNumberField('Admin_fee__c', 0);
            }else{
                gen.writeNumberField('Admin_fee__c', pOff.Admin_fee__c);
            }
           /* if(pOff.Admin_Fees__c == null){
                gen.writeNumberField('Admin_Fees__c', 0);
            }else{
                gen.writeNumberField('Admin_Fees__c', pOff.Admin_Fees__c);
            }*/
            //  Commented by Madhukar Reddy  Not used 2 fields
            //  Uncommmenting since FIS is sending VAUM and Approved T12 at proposal level instead of Application level
            if(pOff.Verified_AUM__c == null){
                gen.writeNumberField('Verified_AUM__c', 0);
            }else{
                gen.writeNumberField('Verified_AUM__c', pOff.Verified_AUM__c);
            }
            if(pOff.Approved_T12__c == null){
                gen.writeNumberField('Approved_T12__c', 0);
            }else{
                gen.writeNumberField('Approved_T12__c', pOff.Approved_T12__c);
            }
            

            //Amol Changes Start - US 1734 - OSJ Amount Field
            if(pOff.RecordType.developername == 'TA_Proposal_Record_Type'){
                if(pOff.OSJ_Amount__c == null){
                    gen.writeNumberField('OSJ_Amount__c', 0);
                }else{
                    gen.writeNumberField('OSJ_Amount__c', pOff.OSJ_Amount__c);
                }
            }
            //Amol Changes End - US 1734 - OSJ Amount Field

            if(pOff.Max_TA_Amount__c == null){
                gen.writeNumberField('Max_TA_Amount__c', 0);
            }else{
                gen.writeNumberField('Max_TA_Amount__c', pOff.Max_TA_Amount__c);
            }
            if(pOff.TA_Amount__c == null){
                gen.writeNumberField('TA_Amount__c', 0);
            }else{
                gen.writeNumberField('TA_Amount__c', pOff.TA_Amount__c);
            }
            if(pOff.Loan_Clause__c == null || pOff.Loan_Clause__c == ''){
                gen.writeStringField('Loan_Clause__c', '');
            }else{
                gen.writeStringField('Loan_Clause__c', pOff.Loan_Clause__c);
            }
            if(pOff.Notes__c == null || pOff.Notes__c == ''){
                gen.writeStringField('Notes__c', '');
            }else{
                gen.writeStringField('Notes__c', pOff.Notes__c);
            }
            if(pOff.OSJ_LE_Branch__c == null || pOff.OSJ_LE_Branch__c == ''){
                gen.writeStringField('OSJ_LE_Branch__c', '');
            }else{
                gen.writeStringField('OSJ_LE_Branch__c', pOff.OSJ_LE_Branch__c);
            }
            if(pOff.Branch__c == null || pOff.Branch__c == ''){
                gen.writeStringField('Branch__c', '');
            }else{
                gen.writeStringField('Branch__c', pOff.Branch__c);
            }
            //gen.writeStringField('Proposal_Status__c', 'Unverified');
            /*if(pOff.Proposal_Status__c == null || pOff.Proposal_Status__c == ''){
                gen.writeStringField('Proposal_Status__c', '');
            }else{
                gen.writeStringField('Proposal_Status__c', pOff.Proposal_Status__c);
            }*/
            if(pOff.Loan_Amount__c == null){
                gen.writeNumberField('Loan_Amount__c', 0);
            }else{
                gen.writeNumberField('Loan_Amount__c', pOff.Loan_Amount__c);
            }
            if(pOff.Interest_Rate__c == null){
                gen.writeNumberField('Interest_Rate__c', 0);
            }else{
                gen.writeNumberField('Interest_Rate__c', pOff.Interest_Rate__c);
            }
            if(pOff.Firm_AUM__c == null){
                gen.writeNumberField('Firm_AUM__c', 0);
            }else{
                gen.writeNumberField('Firm_AUM__c', pOff.Firm_AUM__c);
            }
            if(pOff.Breakage_Discount_Percent__c == null){
                gen.writeNumberField('Breakage_Discount_Percent__c', 0);
            }else{
                gen.writeNumberField('Breakage_Discount_Percent__c', pOff.Breakage_Discount_Percent__c);
            }
            if(pOff.Breakage_Discount__c == null){
                gen.writeNumberField('Breakage_Discount__c', 0);
            }else{
                gen.writeNumberField('Breakage_Discount__c', pOff.Breakage_Discount__c);
            }
            if(pOff.Expected_AUM__c == null){
                gen.writeNumberField('Expected_AUM__c', 0);
            }else{
                gen.writeNumberField('Expected_AUM__c', pOff.Expected_AUM__c);
            }
            if(pOff.Total_Production__c == null){
                gen.writeNumberField('Total_Production__c', 0);
            }else{
                gen.writeNumberField('Total_Production__c', pOff.Total_Production__c);
            }
            if(pOff.TA_of_Verified_AUM_Percent__c == null){
                gen.writeNumberField('TA_of_Verified_AUM_Percent__c', 0);
            }else{
                gen.writeNumberField('TA_of_Verified_AUM_Percent__c', pOff.TA_of_Verified_AUM_Percent__c);
            }
            if(pOff.TA_of_Expected_AUM__c == null){
                gen.writeNumberField('TA_of_Expected_AUM__c', 0);
            }else{
                gen.writeNumberField('TA_of_Expected_AUM__c', pOff.TA_of_Expected_AUM__c); 
            }
            if(pOff.TA_of_GDC__c == null){
                gen.writeNumberField('TA_of_GDC__c', 0);
            }else{
                gen.writeNumberField('TA_of_GDC__c', pOff.TA_of_GDC__c);
            }
            if(pOff.ROIC__c == null){
                gen.writeNumberField('ROIC__c', 0);
            }else{
                gen.writeNumberField('ROIC__c', pOff.ROIC__c);   
            }
            if(pOff.Payback__c == null){
                gen.writeNumberField('Payback__c', 0);
            }else{
                gen.writeNumberField('Payback__c', pOff.Payback__c);
            }
            if(pOff.Gross_profit__c == null){
                gen.writeNumberField('Gross_profit__c', 0);
            }else{
                gen.writeNumberField('Gross_profit__c', pOff.Gross_profit__c);   
            }
            if(pOff.GP_ROA__c == null){
                gen.writeNumberField('GP_ROA__c', 0);
            }else{
                gen.writeNumberField('GP_ROA__c', pOff.GP_ROA__c);   
            }

            // Start CH03
                gen.writeFieldName('subLoans');
                gen.writeStartArray();
             //Start CH06
             String ProposalStatus='';
            ProposalStatus=LoanSubmitApplication.getApplicationStatus('Proposal_Offer__c','Status_1');
            //End
                
                if(pOff.Proposal_Status__c == ProposalStatus){
                    for(Borrowers__c brow : lstBrow){
                        gen.writeStartObject();
                        if(brow.Contact__r.Name == null || brow.Contact__r.Name == ''){
                            gen.writeStringField('CLOCustomerFullName', '');
                        }else{
                            gen.writeStringField('CLOCustomerFullName', brow.Contact__r.Name);   
                        }
                        if(brow.Contact__r.CLO_Customer_ID__c == null || brow.Contact__r.CLO_Customer_ID__c == ''){
                            gen.writeStringField('CLO_Customer_ID__c', '');
                        }else{
                            gen.writeStringField('CLO_Customer_ID__c', brow.Contact__r.CLO_Customer_ID__c);   
                        }
                        //Start CH04
                        if(loanApp.RecordType.developername == 'Forgivable_loan' && pOff.RecordType.developername == 'Repayable'){
                            /*if(brow.Repayable_Loan_Amount__c == null){
                                gen.writeNumberField('Sub_Loan_Amount__c', 0);
                            }else{
                                gen.writeNumberField('Sub_Loan_Amount__c', (pOff.TA_Amount__c * brow.Repayable_Split__c)/100); 
                                brow.Repayable_Loan_Amount__c = (pOff.TA_Amount__c * brow.Repayable_Split__c)/100;
                                updateBorrowers.add(brow);  
                            }*/
                             if(pOff.TA_Amount__c !=null && brow.Repayable_Split__c != null){
                                gen.writeNumberField('Sub_Loan_Amount__c', (pOff.TA_Amount__c * brow.Repayable_Split__c)/100); 
                                brow.Repayable_Loan_Amount__c = (pOff.TA_Amount__c * brow.Repayable_Split__c)/100;
                                updateBorrowers.add(brow); 
                            }else{
                                 gen.writeNumberField('Sub_Loan_Amount__c', 0);
                            }
                        }
                        //Added By Bhanu -11/13/2020 Borrower Subloan amount update
                         else if((loanApp.RecordType.DeveloperName == 'Retention_Loan' || loanApp.RecordType.DeveloperName == 'Monetization' || loanApp.RecordType.DeveloperName == 'Working_Capital') && pOff.RecordType.DeveloperName == 'General_Proposal'){
                         if(pOff.TA_Amount__c !=null && brow.Sub_Loan_Split__c != null){
                         gen.writeNumberField('Sub_Loan_Amount__c', (pOff.TA_Amount__c * brow.Sub_Loan_Split__c)/100); 
                                brow.Sub_Loan_Amount__c = (pOff.TA_Amount__c * brow.Sub_Loan_Split__c)/100;
                                updateBorrowers.add(brow);
                         }else{
                                 gen.writeNumberField('Sub_Loan_Amount__c', 0);
                            }
                         } //Ended By Bhanu
                 
                        else{
                            if(brow.Sub_Loan_Amount__c == null){
                                gen.writeNumberField('Sub_Loan_Amount__c', 0);
                            }else{
                                gen.writeNumberField('Sub_Loan_Amount__c', brow.Sub_Loan_Amount__c);   
                            }
                        }
                        //End CH04
                        gen.writeEndObject();
                    }
                }
                gen.writeEndArray();
            
            //End CH03
            gen.writeEndObject();
        }

        gen.writeEndArray();
       // gen.writeEndObject();
        
        //gen.writeFieldName('advisordetails');
        //gen.writeStartObject();
     /*  gen.writeFieldName('advisordetails');
        gen.writeStartArray(); 
        for (Contact cnt : con) {
            gen.writeStartObject();
            //gen.writeFieldName('advisordetails');
            //gen.writeObject(cnt);
            gen.writeStringField('Id', cnt.Id);
            if(cnt.FirstName == null || cnt.FirstName == ''){
                gen.writeStringField('FirstName', '');
            }else{
                 gen.writeStringField('FirstName', cnt.FirstName);
            }
            if(cnt.Current_Firm_Name__c == null || cnt.Current_Firm_Name__c == ''){
                gen.writeStringField('Current_Firm_Name__c', '');
            }else{
                 gen.writeStringField('Current_Firm_Name__c', cnt.Current_Firm_Name__c);
            }
            if(cnt.Current_Firm_Type__c == null || cnt.Current_Firm_Type__c == ''){
                gen.writeStringField('Current_Firm_Type__c', '');
            }else{
                 gen.writeStringField('Current_Firm_Type__c', cnt.Current_Firm_Type__c);
            }
            if(cnt.Modified_R_Type__c == null || cnt.Modified_R_Type__c == ''){
                gen.writeStringField('Modified_R_Type__c', '');
            }else{
                 gen.writeStringField('Modified_R_Type__c', cnt.Modified_R_Type__c);
            }
            if(cnt.CLO_Customer_Group_Name__c == null || cnt.CLO_Customer_Group_Name__c == ''){
                gen.writeStringField('CLO_Customer_Group_Name__c', '');
            }else{
                 gen.writeStringField('CLO_Customer_Group_Name__c', cnt.CLO_Customer_Group_Name__c);
            }
            if(cnt.clcommon__Legal_Entity_Type__c == null || cnt.clcommon__Legal_Entity_Type__c == ''){
                gen.writeStringField('clcommon__Legal_Entity_Type__c', '');
            }else{
                 gen.writeStringField('clcommon__Legal_Entity_Type__c', cnt.clcommon__Legal_Entity_Type__c);
            }
            if(cnt.Legal_Entity__c == null || cnt.Legal_Entity__c == ''){
                gen.writeStringField('Legal_Entity__c', '');
            }else{
                 gen.writeStringField('Legal_Entity__c', cnt.Legal_Entity__c);
            }
            if(cnt.Middle_Name__c == null || cnt.Middle_Name__c == ''){
                gen.writeStringField('Middle_Name__c', '');
            }else{
                 gen.writeStringField('Middle_Name__c', cnt.Middle_Name__c);
            }
            if(cnt.LastName == null || cnt.LastName == ''){
                gen.writeStringField('LastName', '');
            }else{
                 gen.writeStringField('LastName', cnt.LastName);
            }
            if(cnt.Name == null || cnt.Name == ''){
                gen.writeStringField('Name', '');
            }else{
                 gen.writeStringField('Name', cnt.Name);
            }
            if(cnt.Estimated_Credit_Score__c == null || cnt.Estimated_Credit_Score__c == ''){
                gen.writeStringField('Estimated_Credit_Score__c', '');
            }else{
                 gen.writeStringField('Estimated_Credit_Score__c', cnt.Estimated_Credit_Score__c);
            }
            if(cnt.CRD_Number__c == null || cnt.CRD_Number__c == ''){
                gen.writeStringField('CRD_Number__c', '');
            }else{
                 gen.writeStringField('CRD_Number__c', cnt.CRD_Number__c);
            }
            
            if(cnt.CLO_Customer_ID__c == null || cnt.CLO_Customer_ID__c == ''){
                gen.writeStringField('CLO_Customer_ID__c', '');
            }else{
                 gen.writeStringField('CLO_Customer_ID__c', cnt.CLO_Customer_ID__c);
            }
           /*  
          
           if(cnt.MailingAddress == null || cnt.MailingAddress == ''){
                gen.writeStringField('MailingAddress', '');
            }else{
                 gen.writeStringField('MailingAddress', cnt.MailingAddress);
            }
             if(cnt.MailingCity == null || cnt.MailingCity == ''){
                gen.writeStringField('MailingCity', '');
            }else{
                 gen.writeStringField('MailingCity', cnt.MailingCity);
            }
             if(cnt.MailingState == null || cnt.MailingState == ''){
                gen.writeStringField('MailingState', '');
            }else{
                 gen.writeStringField('MailingState', cnt.MailingState);
            }
             if(cnt.MailingPostalCode == null || cnt.MailingPostalCode == ''){
                gen.writeStringField('MailingPostalCode', '');
            }else{
                 gen.writeStringField('MailingPostalCode', cnt.MailingPostalCode);
            }
             if(cnt.MailingCountry == null || cnt.MailingCountry == ''){
                gen.writeStringField('MailingCountry', '');
            }else{
                 gen.writeStringField('MailingCountry', cnt.MailingCountry);
            }
             if(cnt.MailingStreet == null || cnt.MailingStreet == ''){
                gen.writeStringField('MailingStreet', '');
            }else{
                 gen.writeStringField('MailingStreet', cnt.MailingStreet);
            }
            if(cnt.MobilePhone == null || cnt.MobilePhone == ''){
                gen.writeStringField('MobilePhone', '');
            }else{
                 gen.writeStringField('MobilePhone', cnt.MobilePhone);
            } 
           
            if(cnt.Enterprise_Name__c == null || cnt.Enterprise_Name__c == ''){
                gen.writeStringField('Enterprise_Name__c', '');
            }else{
                 gen.writeStringField('Enterprise_Name__c', cnt.Enterprise_Name__c);
            }
            
            if(cnt.Email == null || cnt.Email == ''){
                gen.writeStringField('Email', '');
            }else{
                 gen.writeStringField('Email', cnt.Email);
            }
            
            if(cnt.Fax == null || cnt.Fax == ''){
                gen.writeStringField('Fax', '');
            }else{
                 gen.writeStringField('Fax', cnt.Fax);
            }
            if(cnt.Master_Rep_ID__c == null || cnt.Master_Rep_ID__c == ''){
                gen.writeStringField('Master_Rep_ID__c', '');
            }else{
                gen.writeStringField('Master_Rep_ID__c', cnt.Master_Rep_ID__c);   
            }
            
            if(cnt.RecordType.Name == 'Contact Prospect'){
                gen.writeStringField('RecordType', 'Prospect');
            }
            if(cnt.RecordType.Name == 'LPL Advisor'){
                gen.writeStringField('RecordType', 'LPL Advisor');
            }
            if(cnt.Hire_Date__c == null ){
                gen.writeStringField('Hire_Date__c', '');
            }else{
                gen.writeDateField('Hire_Date__c', cnt.Hire_Date__c);
            }
            if(cnt.Net_Promoter_Score__c == null ){
                gen.writeNumberField('Net_Promoter_Score__c', 0);
            }else{
                gen.writeNumberField('Net_Promoter_Score__c', cnt.Net_Promoter_Score__c);
            }
            if(cnt.Split_of_Total_AUM__c == null ){
                gen.writeNumberField('Split_of_Total_AUM__c', 0);
            }else{
                gen.writeNumberField('Split_of_Total_AUM__c', cnt.Split_of_Total_AUM__c);
            }
             if(cnt.AUM_Attributable__c == null ){
                gen.writeNumberField('AUM_Attributable__c', 0);
            }else{
                gen.writeNumberField('AUM_Attributable__c', cnt.AUM_Attributable__c);
            }

            gen.writeBooleanField('LPLCRM__U_S_Citizenship__c',cnt.LPLCRM__U_S_Citizenship__c);

            if(cnt.LPLCRM__U_S_Citizenship__c == false ){
               //Start CH06
             String ContactCustomerStatus='';
            ContactCustomerStatus=LoanSubmitApplication.getApplicationStatus('Contact','Status_1');
            
                gen.writeStringField('Citizenship_Status__c', ContactCustomerStatus);//End
            }
            if(cnt.LPLCRM__U_S_Citizenship__c == true ){
              //Start CH06
             String ContactCustomerStatus='';
            ContactCustomerStatus=LoanSubmitApplication.getApplicationStatus('Contact','Status_2');
           
                gen.writeStringField('Citizenship_Status__c', ContactCustomerStatus);  //End
            }
            if(cnt.Birthdate == null ){
                gen.writeStringField('Birthdate', '');
            }else{
                gen.writeDateField('Birthdate', cnt.Birthdate);
            }
                 
            if(cnt.LPLCRM__Social_Security_Tax_ID__c == null || cnt.LPLCRM__Social_Security_Tax_ID__c == ''){
                gen.writeStringField('LPLCRM__Social_Security_Tax_ID__c', '');
            }else{
                gen.writeStringField('LPLCRM__Social_Security_Tax_ID__c', cnt.LPLCRM__Social_Security_Tax_ID__c);
            }
                
            if(cnt.CLO_Customer_group_ID__c == null || cnt.CLO_Customer_group_ID__c == ''){
                gen.writeStringField('CLO_Customer_group_ID__c', '');
            }else{
                gen.writeStringField('CLO_Customer_group_ID__c', cnt.CLO_Customer_group_ID__c);
            }
            if(cnt.OSJ_MGR_ID__c == null || cnt.OSJ_MGR_ID__c == ''){
                gen.writeStringField('OSJ_MGR_ID__c', '');
            }else{
                 gen.writeStringField('OSJ_MGR_ID__c', cnt.OSJ_MGR_ID__c);
            }
            if(cnt.Branch_ID__c == null || cnt.Branch_ID__c == ''){
                gen.writeStringField('Branch_ID__c', '');
            }else{
                gen.writeStringField('Branch_ID__c', cnt.Branch_ID__c);
            }
            if(cnt.OSJ_MGR_Name__c == null || cnt.OSJ_MGR_Name__c == ''){
                gen.writeStringField('OSJ_MGR_Name__c', '');
            }else{
                gen.writeStringField('OSJ_MGR_Name__c', cnt.OSJ_MGR_Name__c);
            }
            if(cnt.OSJ_ID__c == null || cnt.OSJ_ID__c == ''){
                gen.writeStringField('OSJ_ID__c', '');
            }else{
                gen.writeStringField('OSJ_ID__c', cnt.OSJ_ID__c);
            }
            if(cnt.Engagement_Index_Score__c == null){
                gen.writeStringField('Engagement_Index_Score__c', '0');
            }else{
                gen.writeStringField('Engagement_Index_Score__c', string.valueOf(cnt.Engagement_Index_Score__c));
            }
            if(cnt.of_Advisors__c == null){
                gen.writeStringField('of_Advisors__c', '0');
            }else{
                gen.writeStringField('of_Advisors__c', string.valueOf(cnt.of_Advisors__c));
            }
            if(cnt.GP_ROA__c == null){
                gen.writeNumberField('GP_ROA__c', 0);
            }else{
                gen.writeNumberField('GP_ROA__c', cnt.GP_ROA__c);
            }
            if(cnt.YTD_GDC__c == null){
                gen.writeNumberField('YTD_GDC__c', 0);
            }else{
                gen.writeNumberField('YTD_GDC__c', cnt.YTD_GDC__c);
            }
            if(cnt.Prior_Yr_GDC__c == null){
                gen.writeNumberField('Prior_Yr_GDC__c', 0);
            }else{
                 gen.writeNumberField('Prior_Yr_GDC__c', cnt.Prior_Yr_GDC__c);
            }
            if(cnt.Advisor_Total_Advisory_AUM__c == null){
                gen.writeNumberField('Advisor_Total_Advisory_AUM__c', 0);
            }else{
                gen.writeNumberField('Advisor_Total_Advisory_AUM__c', cnt.Advisor_Total_Advisory_AUM__c);
            }
            if(cnt.Advisor_Total_Brokerage_AUM__c == null){
                gen.writeNumberField('Advisor_Total_Brokerage_AUM__c', 0);
            }else{
                gen.writeNumberField('Advisor_Total_Brokerage_AUM__c', cnt.Advisor_Total_Brokerage_AUM__c);
            }
            if(cnt.Advisor_Total_AUM__c == null){
                gen.writeNumberField('Advisor_Total_AUM__c', 0);
            }else{
                gen.writeNumberField('Advisor_Total_AUM__c', cnt.Advisor_Total_AUM__c);
            }
            gen.writeEndObject();
        }
        gen.writeEndArray();*/
        //gen.writeEndObject();
       // gen.writeObject(con);
        gen.writeEndObject();
        gen.writeEndObject();
        
        string jsonstring = gen.getAsString();
        
        req1.setBody(jsonstring);
        
        system.debug('jsonstring--------'+jsonstring);
        
             Http http1 = new Http();
       
             HTTPResponse res1 = http1.send(req1);
             system.debug('res1--------'+res1.getBody());
            // System.debug(JSON.deserializeUntyped(res1.getBody()));
             //Map<String, String> resBody = (Map<String,String>)JSON.deserialize(res1.getBody(), Map<String, String>.class);
             //CH - 08 Start
            List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
            String   loanStatusDocumentation=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_13');
            String   loanStatusBoardingFunding=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_14');
            String   loanStatusNigo=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_15');
            String   loanStatuInformationRequested=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_16');
            String   loanStatusInformationSubmitted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_17');
            String   loanStatusFunded=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_7');
        // Added below code by Amol - To update borrowers who have seledcted Rpayable proposal of a TA - 11/13/2020 - Start
        if(res1.getStatusCode() == 200){
             if(loanApp.Status__c != loanStatusDocumentation && loanApp.Status__c != loanStatusBoardingFunding &&
            loanApp.Status__c != loanStatusNigo && loanApp.Status__c != loanStatuInformationRequested &&
            loanApp.Status__c != loanStatusInformationSubmitted && loanApp.Status__c != loanStatusFunded) {
                if(updateBorrowers.size()>0 && updateBorrowers != null){
                    update updateBorrowers;
                }
            }
        }
        //CH - 08 End
        //Amol Chnages End

             // Start CH01
        if(res1.getStatusCode() != 200){
            LPL_CreateExceptionLog.createErrorRecordForSFMuleAPIFailure('cls_LPL_SendLoan_ProposalUpdatestoMule','makePostCallout',1291,dpEndpoint.DataPowerSFDataToCLOUpdateApplicationAPI__c,
            res1.getBody()+'\n'+'-------Payload-------'+'\n'+jsonstring,'Mule Soft',res1.getStatus(),res1.getStatusCode(),LoanId,null);
        }
        // End CH01
        
        //return res1;
        
    }
}

    
    //CH01 END

}