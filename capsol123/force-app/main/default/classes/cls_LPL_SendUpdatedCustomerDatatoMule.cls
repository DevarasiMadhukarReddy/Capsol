/***
     * This class is used to send Customer updates to CLO which are already present in CLO.
     * 
     * US 765 - Send Contact Updates to CLO as part of Update Customer Details Service
     * for Loan Application which are already submitted to CLO
     * ----------------------Updated by Amol Sprint 12 CapSol - 05/18/2020 - CH01 
     * 
     * Error Handling-Create Integration Error records in SF when SF invokes Data Power or Mule Soft API.
     *                                              ---Updated by Amol Sprint 13 CapSol - 06/19/2020 - CH02
     * Author - Amol Deshpande
     * CS-1532--Data Model Enhancement: Modified R Type(Modified R Type Description) Updated by Madhukar Reddy Sprin14 Capsol-07/15/2020
     * Modified By Bhanu 11/30/2020 CS-2518 - Enhance Application Submit Validation
     */
     
public class cls_LPL_SendUpdatedCustomerDatatoMule {
    @future(callout = true)
    public static void makePostCallout(Id ConId) {//CH01
        
        DatePowerEndpoint__mdt dpEndpoint = new DatePowerEndpoint__mdt();
        dpEndpoint = [Select DataPowerDEVEndpoint__c,DataPowerPRODEndpoint__c,DataPowerQAEndpoint__c,DataPowerAccessTokenAPIBody__c,
                        DataPowerAccessTokenAPI__c,DataPowerAccessTokenAuthHeader__c,DataPowerSendSFDataToCLOSubmitAPI__c,
                        DataPowerSFDataToCLOUpdateApplicationAPI__c,DataPowerSFDataToCLOUpdateCustomerAPI__c,
                        DPAccessTokenUpdateCustomerAPIBody__c,DataPowerAccessTokenUpdateLoanAPIBody__c,DataPowerSNOWEndpoint__c,
                        DataPowerSNOWAccessTokenAPIBody__c,DataPowerDEVINTEndpoint__c from DatePowerEndpoint__mdt];
        
        List<Borrowers__c> lstBro = new List<Borrowers__c>();
       /* lstBro = [Select Id,Split_of_Total_AUM__c,AUM_Attributable__c,Contact__c,CLO_Customer_Group__c,CLO_Customer_ID__c,Current_Firm_Name__c,
                 Current_Firm_Type__c,Enterprise_Name__c,Full_Name__c,Loan_Application__c,Primary_Contact__c,Total_AUM__c from Borrowers__c 
                 where Loan_Application__c =:LoanId];
        List<Id> broIds = new List<Id>();       
                 for (Borrowers__c lstBroId : lstBro) {
                     broIds.add(lstBroId.Contact__c);
                 }*/
                     
        
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
        }else{
            endpoint = dpEndpoint.DataPowerPRODEndpoint__c;
        }
        
       HttpRequest req = new HttpRequest();
       req.setEndpoint(endpoint+dpEndpoint.DataPowerAccessTokenAPI__c);
       req.setMethod('POST');
       req.setHeader('Authorization', dpEndpoint.DataPowerAccessTokenAuthHeader__c);
       //req.setBody(dpEndpoint.DataPowerAccessTokenAPIBody__c);
      req.setBody(dpEndpoint.DPAccessTokenUpdateCustomerAPIBody__c);
       
       Http http = new Http();
       HTTPResponse res = http.send(req);

       // Start CH02
        if(res.getStatusCode() != 200){
            LPL_CreateExceptionLog.createErrorRecordForSFMuleAPIFailure('cls_LPL_SendUpdatedCustomerDatatoMule','makePostCallout',58,dpEndpoint.DPAccessTokenUpdateCustomerAPIBody__c,
            res.getBody(),'Data Power',res.getStatus(),res.getStatusCode(),null,ConId);
        }else{ // End CH02

       System.debug(JSON.deserializeUntyped(res.getBody()));
       Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
       string accessToken = (string)metadata_Map.get('access_token');
       system.debug('token-----------'+accesstoken);
       HttpRequest req1 = new HttpRequest();
             req1.setEndpoint(endpoint+dpEndpoint.DataPowerSFDataToCLOUpdateCustomerAPI__c);
             req1.setMethod('POST');
             req1.setTimeout(60000); 
             req1.setHeader('Content-Type', 'application/json');
             req1.setHeader('Authorization', 'Bearer ' +accessToken);
        
        Contact con = new Contact();
        //Loan_Application__c loanApp = [select CLO_Application_ID__c,Application_Type__c,Business_Name_DBA__c,Requested_Funding_Date__c,Id,Preparer_Name__c,Preparer_Email__c,Servicer_Name__c,Servicer_Email__c,Assigned_Recruiter__c,Assigned_Recruiter_Email__c,Internal_Recruiter__c,Internal_Recruiter_Email__c,Business_Developer__c,Business_Developer_Email__c,Business_Consultant_RM__c,Business_Consultant_RM_Email__c,Status__c,CreatedDate,CreatedByID,Created_By_Email__c,Primary_Contact__c,Number_of_LPL_Loans_Outstanding__c,Loan_Purpose__c,Loan_Category__c,Requested_Loan_Amount__c,Requested_Loan_Term__c,Current_Custodian__c,Number_of_Advisors__c,Mutual_Funds_Custodied__c,Direct_Mutual_Funds__c,AUM_Total_Mutual_Funds__c,AUM_Variable_Annuities__c,AUM_Fixed_Annuities__c,AUM_Equity__c,AUM_Fixed_Income__c,AUM_AI_UIT_Cash__c,Total_Advisory_AUM__c,Total_Brokerage_AUM__c,Total_AUM__c,Percentage_of_Mutual_Funds_Held_Direct__c,Percentage_of_Mutual_Funds_Held_Custodie__c,Percentage_of_Total_Mutual_Funds__c,Percentage_of_Variable_Annuities__c,Percentage_of_Fixed_Annuities__c,Percentage_of_Equity__c,Percentage_of_Fixed_Income__c,Percentage_of_Total_Brokerage_AUM__c,Percentage_of_Total_Advisory_AUM__c,Percentage_of_Total_AUM__c,Advisory_Revenue_c__c,Brokerage_Revenue__c,Total_Production__c,Percentage_GDC_ROA__c,Percentage_Split_of_Total_AUM__c,AUM_Attributable__c,Additional_Comments__c,Current_Firm_Name__c,Current_Firm_Type__c,Current_Registration__c,Asset_Status__c,U_W_Type__c,Campaign_Name__c,Modified_R_Type__c,GP_ROA__c,YTD_GDC__c,Prior_Yr_GDC__c,Interest_Rate__c,Advisor_Total_Advisory_AUM__c,Advisor_Total_Brokerage_AUM__c,Advisor_Total_AUM__c,Estimated_Credit_Score__c,Succession_Plan__c from Loan_Application__c where id = 'a000R000002mbgXQAQ'];
       // Loan_Application__c loanApp = [select RecordType.developername,Name,CurrentCustodian__c,Advisor_TotalAnnual_Income__c,Advisor_DebtService_Coverage__c,Seller_Note_Remaining_Term_Monthly__c,Seller_s_Name__c,Seller_Note_Payment_months__c,Seller_Debt_Amount__c,Is_Seller_Staying_on_receiving_salary__c,Seller_Note_Rate__c,Seller_Note_Amount__c,LPL_loan_or_an_external_loan__c,Will_You_Assume_Seller_Debt__c,Anticipated_Change_in_Annual_Operating__c,Annual_Acquisition_Operating_Expense__c,Annual_Acquisition_Revenue__c,Estimated_Down_Payment__c,Total_Purchase_Price__c,Total_Annual_Personal_Expenditures__c,Ownership_of_Business__c,Estimated_Officers_Compensation__c,Total_Annual_Business_Expenditures__c,Total_Gross_Revenue__c,Percentage_of_AI_UIT_Cash__c,CLO_Customer_Group_Name__c,Advisor__c,CLO_Application_ID__c,Application_Type__c,Business_Name_DBA__c,Requested_Funding_Date__c,Id,Preparer_Name__c,Preparer_Email__c,Servicer_Name__c,Servicer_Email__c,Assigned_Recruiter__c,Assigned_Recruiter_Email__c,Internal_Recruiter__c,Internal_Recruiter_Email__c,Business_Developer__c,Business_Developer_Email__c,Business_Consultant_RM__c,Business_Consultant_RM_Email__c,Status__c,CreatedDate,CreatedByID,Created_By_Email__c,Primary_Contact__c,Number_of_LPL_Loans_Outstanding__c,Loan_Purpose__c,Loan_Category__c,Requested_Loan_Amount__c,Requested_Loan_Term__c,Current_Custodian__c,Number_of_Advisors__c,Mutual_Funds_Custodied__c,Direct_Mutual_Funds__c,AUM_Total_Mutual_Funds__c,AUM_Variable_Annuities__c,AUM_Fixed_Annuities__c,AUM_Equity__c,AUM_Fixed_Income__c,AUM_AI_UIT_Cash__c,Total_Advisory_AUM__c,Total_Brokerage_AUM__c,Total_AUM__c,Percentage_of_Mutual_Funds_Held_Direct__c,Percentage_of_Mutual_Funds_Held_Custodie__c,Percentage_of_Total_Mutual_Funds__c,Percentage_of_Variable_Annuities__c,Percentage_of_Fixed_Annuities__c,Percentage_of_Equity__c,Percentage_of_Fixed_Income__c,Percentage_of_Total_Brokerage_AUM__c,Percentage_of_Total_Advisory_AUM__c,Percentage_of_Total_AUM__c,Advisory_Revenue_c__c,Brokerage_Revenue__c,Total_Production__c,Percentage_GDC_ROA__c,Percentage_Split_of_Total_AUM__c,AUM_Attributable__c,Additional_Comments__c,Current_Firm_Name__c,Current_Firm_Type__c,Current_Registration__c,Asset_Status__c,U_W_Type__c,Campaign_Name__c,Modified_R_Type__c,GP_ROA__c,YTD_GDC__c,Prior_Yr_GDC__c,Interest_Rate__c,Advisor_Total_Advisory_AUM__c,Advisor_Total_Brokerage_AUM__c,Advisor_Total_AUM__c,Estimated_Credit_Score__c,Succession_Plan__c,CreatedBy.Name,Primary_Contact_Name__c,Primary_Contact_Name__r.Email,Primary_Contact_Name__r.Name,CLO_Customer_Group_ID__c,RecordType.Name,Record_Type__c,Assigned_Recruiter__r.Name,Assigned_Recruiter__r.Email,Internal_Recruiter__r.Name,Internal_Recruiter__r.Email,Business_Developer__r.Name,Business_Developer__r.Email,Business_Consultant_RM__r.Name,Business_Consultant_RM__r.Email,Current_Custodian__r.Name,Current_Custodian__r.Email from Loan_Application__c where id =:LoanId];
        //Proposal_Offer__c poOff = [Select Loan_Category__c,TA_Amount__c,Proposal_Status__c,Platform__c,Branch__c,OSJ__c,TA_Program__c,Loan_Term__c,Interest_Rate__c,TA_of_VAUM__c,Expected_EAUM__c,Verified_AUM__c,Level_Payout__c,Backend_Bps__c,Backend_Hurdle__c,Note_Length__c,Proposal_Name__c,Loan_Amount__c,Id,CLO_Proposal_ID__c from Proposal_Offer__c where id = 'a010R000007Lsg4QAC'];
       // list<Proposal_Offer__c> poOff = [Select U_W_Type__c,Loan_Category__c,TA_Amount__c,Proposal_Status__c,Platform__c,Branch__c,OSJ__c,TA_Program__c,Loan_Term__c,Interest_Rate__c,TA_of_VAUM__c,Expected_EAUM__c,Verified_AUM__c,Level_Payout__c,Backend_Bps__c,Backend_Hurdle__c,Note_Length__c,Proposal_Name__c,Loan_Amount__c,Id,Admin_Fees__c,Admin_fee__c,Application_Type__c,Approved_T12__c,Campaign__c,Date__c,DBA_Business_Name__c,Expiration__c,Fee_Waivers__c,LoanApp_MD__c,Loan_Clause__c,Loan_Purpose__c,Loan_Type__c,Notes__c,Offer_Accepted__c,TA_of_EAUM__c,Record_type__c, CLO_Proposal_ID__c,Status__c,Offer_Name__c,OSJ_Manager_Name__c,OSJ_LE_Branch__c,Max_TA_Amount__c,Firm_AUM__c,Breakage_Discount_Percent__c,Breakage_Discount__c,Expected_AUM__c,Total_Production__c,TA_of_Verified_AUM_Percent__c,TA_of_Expected_AUM__c,TA_of_GDC__c,ROIC__c,Payback__c,Gross_profit__c,GP_ROA__c from Proposal_Offer__c where id IN :PropIds];
        //Contact con = [Select ID,Master_Rep_ID__c ,clcommon__Legal_Entity_Type__c,RecordTypeId,Hire_Date__c,FirstName,Middle_Name__c,LastName,Name,CRD_Number__c,Branch_ID__c,OSJ_MGR_ID__c,OSJ_MGR_Name__c,OSJ_ID__c,Engagement_Index_Score__c,Net_Promoter_Score__c,of_Advisors__c,LPLCRM__U_S_Citizenship__c,Birthdate,LPLCRM__Social_Security_Tax_ID__c,MailingAddress,MailingCity,MailingState,MailingPostalCode,MobilePhone,Enterprise_Name__c from Contact where Id = '0030R00000zSINoQAO'];
       // if(loanApp.RecordType.developername == 'Forgivable_loan' || loanApp.RecordType.developername == 'Working_Capital'){
             con = [Select ID,Master_Rep_ID__c,clcommon__Legal_Entity_Type__c,Estimated_Credit_Score__c,Rep_Type__c,Current_Firm_Type__c,Current_Firm_Name__c,AUM_Attributable__c,Split_of_Total_AUM__c,RecordType.Name,CLO_Customer_ID__c,CLO_Customer_Group_Name__c,Legal_Entity__c,RecordTypeId,Hire_Date__c,FirstName,Middle_Name__c,LastName,Name,CRD_Number__c,Branch_ID__c,OSJ_MGR_ID__c,OSJ_MGR_Name__c,OSJ_ID__c,Engagement_Index_Score__c,Net_Promoter_Score__c,of_Advisors__c,LPLCRM__U_S_Citizenship__c,Birthdate,LPLCRM__Social_Security_Tax_ID__c,MailingAddress,MailingCity,MailingState,MailingPostalCode,MailingCountry,MailingStreet,MobilePhone,Enterprise_Name__c,Email,Fax,Citizenship_Status__c,CLO_Customer_group_ID__c,GP_ROA__c,YTD_GDC__c,Prior_Yr_GDC__c,Advisor_Total_Advisory_AUM__c,Advisor_Total_Brokerage_AUM__c,Advisor_Total_AUM__c from Contact where Id = :ConId];
       // }else{
         //  con = [Select ID,Master_Rep_ID__c,clcommon__Legal_Entity_Type__c,Estimated_Credit_Score__c,Rep_Type__c,Current_Firm_Type__c,Current_Firm_Name__c,AUM_Attributable__c,Split_of_Total_AUM__c,RecordType.Name,CLO_Customer_ID__c,CLO_Customer_Group_Name__c,Legal_Entity__c,RecordTypeId,Hire_Date__c,FirstName,Middle_Name__c,LastName,Name,CRD_Number__c,Branch_ID__c,OSJ_MGR_ID__c,OSJ_MGR_Name__c,OSJ_ID__c,Engagement_Index_Score__c,Net_Promoter_Score__c,of_Advisors__c,LPLCRM__U_S_Citizenship__c,Birthdate,LPLCRM__Social_Security_Tax_ID__c,MailingAddress,MailingCity,MailingState,MailingPostalCode,MailingCountry,MailingStreet,MobilePhone,Enterprise_Name__c,Email,Fax,Citizenship_Status__c,CLO_Customer_group_ID__c,GP_ROA__c,YTD_GDC__c,Prior_Yr_GDC__c,Advisor_Total_Advisory_AUM__c,Advisor_Total_Brokerage_AUM__c,Advisor_Total_AUM__c from Contact where Id = :loanApp.Advisor__c];
       // }    
       // list<Contact> lstCon = new List<Contact>();
        //DateTime myDateTime = DateTime.newInstance(1993, 6, 6, 3, 3, 3);
        //String formatted = myDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        //gen.writeStringField('Authorization', 'Bearer ' +accessToken);
       // gen.writeStringField('applicationid', loanApp.ID);
        gen.writeFieldName('loanapplication');
        gen.writeStartObject(); 
       // gen.writeFieldName('applicationdetails');
        //gen.writeObject(loanApp);
       // gen.writeStartObject(); 
       //  gen.writeStringField('Id', loanApp.Id);
        // gen.writeStringField('Name', loanApp.Name);
        // gen.writeStringField('CreatedDate',loanApp.CreatedDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'));
       /* gen.writeDateTimeField('CreatedDate',loanApp.CreatedDate);
        gen.writeStringField('CreatedBy',loanApp.CreatedBy.Name);
         gen.writeStringField('Created_By_Email__c',loanApp.Created_By_Email__c);
         gen.writeStringField('RecordType',loanApp.RecordType.Name);
         gen.writeBooleanField('Succession_Plan__c',loanApp.Succession_Plan__c);
         gen.writeStringField('AdvisorJoiningRIAorCorp','NA');
         gen.writeStringField('AdvisorPriorFirmType','NA');
         
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
               // Bhanu CS-2518 changes Start
            if(loanApp.Primary_Contact_Name__r.Email == null || loanApp.Primary_Contact_Name__r.Email == ''){
                gen.writeStringField('Primary_Contact_Email__c', '');
            }else{
               gen.writeStringField('Primary_Contact_Email__c', loanApp.Primary_Contact_Name__r.Email); 
            }
            // Bhanu CS-2518 changes Ends
            if(loanApp.Asset_Status__c == null || loanApp.Asset_Status__c == ''){
                gen.writeStringField('Asset_Status__c', '');
            }else{
                gen.writeStringField('Asset_Status__c', loanApp.Asset_Status__c);
            }
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
           /* if(loanApp.Current_Registration__c == null || loanApp.Current_Registration__c == ''){
                gen.writeStringField('Current_Registration__c', '');
            }else{
                gen.writeStringField('Current_Registration__c', loanApp.Current_Registration__c);
            }
            /*if(loanApp.Current_Firm_Type__c == null || loanApp.Current_Firm_Type__c == ''){
                gen.writeStringField('Current_Firm_Type__c', '');
            }else{
                gen.writeStringField('Current_Firm_Type__c', loanApp.Current_Firm_Type__c);
            }*/
           /* if(loanApp.Loan_Category__c == null || loanApp.Loan_Category__c == ''){
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
            
            // Bhanu CS-2518 changes Start
            if(loanApp.Assigned_Recruiter_Email__c == null){
                gen.writeStringField('Assigned_Recruiter_Email__c', '');
            }else{
                gen.writeStringField('Assigned_Recruiter_Email__c', loanApp.Assigned_Recruiter_Email__c);
            }
            //Bhanu CS-2518 changes ends
            if(loanApp.Internal_Recruiter__c == null ){
                gen.writeStringField('Internal_Recruiter__c', '');
            }else{
                gen.writeStringField('Internal_Recruiter__c', loanApp.Internal_Recruiter__r.Name);
            }
             // Bhanu CS-2518 changes Start
            if(loanApp.Internal_Recruiter_Email__c == null || loanApp.Internal_Recruiter_Email__c == ''){
                gen.writeStringField('Internal_Recruiter_Email__c', '');
            }else{
                gen.writeStringField('Internal_Recruiter_Email__c', loanApp.Internal_Recruiter_Email__c);
            }
             // Bhanu CS-2518 changes ends
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
            // Bhanu CS-2518 changes ends
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
            }
            if(loanApp.Preparer_Name__c == null || loanApp.Preparer_Name__c == ''){
                gen.writeStringField('Preparer_Name__c', '');
            }
            if(loanApp.Preparer_Email__c == null || loanApp.Preparer_Email__c == ''){
                gen.writeStringField('Preparer_Email__c', '');
            }
            if(loanApp.Servicer_Name__c == null || loanApp.Servicer_Name__c == ''){
                gen.writeStringField('Servicer_Name__c', '');
            }
            if(loanApp.Servicer_Email__c == null || loanApp.Servicer_Email__c == ''){
                gen.writeStringField('Servicer_Email__c', '');
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
           /* if(loanApp.Interest_Rate__c == null ){
                gen.writeNumberField('Interest_Rate__c', 0);
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
           /* if(loanApp.Total_Gross_Revenue__c == null ){
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
            }
            if(loanApp.Total_Purchase_Price__c == null ){
                gen.writeNumberField('Total_Purchase_Price__c', 0);
            }
            if(loanApp.Estimated_Down_Payment__c == null ){
                gen.writeNumberField('Estimated_Down_Payment__c', 0);
            }
            if(loanApp.Advisor_DebtService_Coverage__c == null ){
                gen.writeNumberField('Advisor_DebtService_Coverage__c', 0);
            }
            if(loanApp.Annual_Acquisition_Revenue__c == null ){
                gen.writeNumberField('Annual_Acquisition_Revenue__c', 0);
            }
            if(loanApp.Annual_Acquisition_Operating_Expense__c == null ){
                gen.writeNumberField('Annual_Acquisition_Operating_Expense__c', 0);
            }
            if(loanApp.Anticipated_Change_in_Annual_Operating__c == null ){
                gen.writeNumberField('Anticipated_Change_in_Annual_Operating__c', 0);
            }
            if(loanApp.Seller_Note_Amount__c == null ){
                gen.writeNumberField('Seller_Note_Amount__c', 0);
            }
            if(loanApp.Seller_Note_Rate__c == null ){
                gen.writeNumberField('Seller_Note_Rate__c', 0);
            }
            if(loanApp.Seller_Debt_Amount__c == null ){
                gen.writeNumberField('Seller_Debt_Amount__c', 0);
            }
            if(loanApp.Seller_Note_Payment_months__c == null ){
                gen.writeNumberField('Seller_Note_Payment_months__c', 0);
            }
            if(loanApp.Seller_Note_Remaining_Term_Monthly__c == null ){
                gen.writeNumberField('Seller_Note_Remaining_Term_Monthly__c', 0);
            }
            if(loanApp.LPL_loan_or_an_external_loan__c == null || loanApp.LPL_loan_or_an_external_loan__c == ''){
                gen.writeStringField('LPL_loan_or_an_external_loan__c', '');
            }
            if(loanApp.Seller_s_Name__c == null || loanApp.Seller_s_Name__c == ''){
                gen.writeStringField('Seller_s_Name__c', '');
            }
         
       /* if(loanApp.Business_Consultant_RM__c == null || loanApp.Business_Consultant_RM__c == ''){
                gen.writeStringField('Business_Consultant_RM__c', '');
            }else{
                gen.writeStringField('Business_Consultant_RM__c', loanApp.Business_Consultant_RM__r.Name);
            } */
        
        /* Added by Anil ***/
        
        /*--New updated code by anil*/
       /* if(loanApp.Business_Consultant_RM__c != null){
            gen.writeStringField('Business_Consultant_RM__c', loanApp.Business_Consultant_RM__r.Name);
        } else {
            gen.writeStringField('Business_Consultant_RM__c', '');   
        }/** End of Anil Code ***/
        
       /* if(loanApp.Business_Consultant_RM_Email__c == null || loanApp.Business_Consultant_RM_Email__c == ''){
            gen.writeStringField('Business_Consultant_RM_Email__c', '');
        }else{
            gen.writeStringField('Business_Consultant_RM_Email__c', loanApp.Business_Consultant_RM_Email__c);
        }
        gen.writeEndObject(); */
       // gen.writeFieldName('proposals');
       // gen.writeStartObject();
        //gen.writeObject(poOff);
       /* gen.writeFieldName('proposals');
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
            if(pOff.Loan_Purpose__c == null || pOff.Loan_Purpose__c == ''){
                gen.writeStringField('Loan_Purpose__c', '');
            }else{
                //gen.writeStringField('Loan_Purpose__c', pOff.Loan_Purpose__c);
                gen.writeStringField('Loan_Purpose__c', loanApp.Loan_Purpose__c);
            }
            if(pOff.Loan_Type__c == null || pOff.Loan_Type__c == ''){
                gen.writeStringField('Loan_Type__c', '');
            }else{
                //gen.writeStringField('Loan_Type__c', pOff.Loan_Type__c);
                gen.writeStringField('Loan_Type__c', loanApp.RecordType.Name);
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
            if(pOff.Loan_Term__c == null){
                gen.writeNumberField('Loan_Term__c', 0);
            }else{
                gen.writeNumberField('Loan_Term__c', Integer.valueOf(pOff.Loan_Term__c));
            }
            if(pOff.TA_of_EAUM__c == null || pOff.TA_of_EAUM__c == 0){
                gen.writeNumberField('TA_of_EAUM__c', 0);
            }else{
                gen.writeNumberField('TA_of_EAUM__c', pOff.TA_of_EAUM__c);
            }
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
            /*if(pOff.Verified_AUM__c == null){
                gen.writeNumberField('Verified_AUM__c', 0);
            }else{
                gen.writeNumberField('Verified_AUM__c', pOff.Verified_AUM__c);
            }
            if(pOff.Approved_T12__c == null){
                gen.writeNumberField('Approved_T12__c', 0);
            }else{
                gen.writeNumberField('Approved_T12__c', pOff.Approved_T12__c);
            }
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
            gen.writeStringField('Proposal_Status__c', 'Unverified');
            /*if(pOff.Proposal_Status__c == null || pOff.Proposal_Status__c == ''){
                gen.writeStringField('Proposal_Status__c', '');
            }else{
                gen.writeStringField('Proposal_Status__c', pOff.Proposal_Status__c);
            }*/
           /* if(pOff.Loan_Amount__c == null){
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
            gen.writeEndObject();
        }

        /*gen.writeEndArray();*/
       // gen.writeEndObject();
        
        //gen.writeFieldName('advisordetails');
        //gen.writeStartObject();*/
        gen.writeFieldName('advisordetails');
       // gen.writeStartArray(); 
        //for (Contact con : con) {
            gen.writeStartObject();
            //gen.writeFieldName('advisordetails');
            //gen.writeObject(con);
            gen.writeStringField('Id', con.Id);
            if(con.FirstName == null || con.FirstName == ''){
                gen.writeStringField('FirstName', '');
            }else{
                 gen.writeStringField('FirstName', con.FirstName);
            }
            if(con.Current_Firm_Name__c == null || con.Current_Firm_Name__c == ''){
                gen.writeStringField('Current_Firm_Name__c', '');
            }else{
                 gen.writeStringField('Current_Firm_Name__c', con.Current_Firm_Name__c);
            }
            if(con.Current_Firm_Type__c == null || con.Current_Firm_Type__c == ''){
                gen.writeStringField('Current_Firm_Type__c', '');
            }else{
                 gen.writeStringField('Current_Firm_Type__c', con.Current_Firm_Type__c);
            }
            if(con.Rep_Type__c== null || con.Rep_Type__c== ''){
                gen.writeStringField('Modified_R_Type__c', '');
            }else{
                 gen.writeStringField('Modified_R_Type__c', con.Rep_Type__c);
            }
            if(con.CLO_Customer_Group_Name__c == null || con.CLO_Customer_Group_Name__c == ''){
                gen.writeStringField('CLO_Customer_Group_Name__c', '');
            }else{
                 gen.writeStringField('CLO_Customer_Group_Name__c', con.CLO_Customer_Group_Name__c);
            }
            if(con.clcommon__Legal_Entity_Type__c == null || con.clcommon__Legal_Entity_Type__c == ''){
                gen.writeStringField('clcommon__Legal_Entity_Type__c', '');
            }else{
                 gen.writeStringField('clcommon__Legal_Entity_Type__c', con.clcommon__Legal_Entity_Type__c);
            }
            if(con.Legal_Entity__c == null || con.Legal_Entity__c == ''){
                gen.writeStringField('Legal_Entity__c', '');
            }else{
                 gen.writeStringField('Legal_Entity__c', con.Legal_Entity__c);
            }
            if(con.Middle_Name__c == null || con.Middle_Name__c == ''){
                gen.writeStringField('Middle_Name__c', '');
            }else{
                 gen.writeStringField('Middle_Name__c', con.Middle_Name__c);
            }
            if(con.LastName == null || con.LastName == ''){
                gen.writeStringField('LastName', '');
            }else{
                 gen.writeStringField('LastName', con.LastName);
            }
            if(con.Name == null || con.Name == ''){
                gen.writeStringField('Name', '');
            }else{
                 gen.writeStringField('Name', con.Name);
            }
            if(con.Estimated_Credit_Score__c == null || con.Estimated_Credit_Score__c == ''){
                gen.writeStringField('Estimated_Credit_Score__c', '');
            }else{
                 gen.writeStringField('Estimated_Credit_Score__c', con.Estimated_Credit_Score__c);
            }
            if(con.CRD_Number__c == null || con.CRD_Number__c == ''){
                gen.writeStringField('CRD_Number__c', '');
            }else{
                 gen.writeStringField('CRD_Number__c', con.CRD_Number__c);
            }
            
            if(con.CLO_Customer_ID__c == null || con.CLO_Customer_ID__c == ''){
                gen.writeStringField('CLO_Customer_ID__c', '');
            }else{
                 gen.writeStringField('CLO_Customer_ID__c', con.CLO_Customer_ID__c);
            }
           /*  if(con.MailingAddress == null || con.MailingAddress == ''){
                gen.writeStringField('MailingAddress', '');
            }else{
                 gen.writeStringField('MailingAddress', con.MailingAddress);
            }*/
            
             if(con.MailingCity == null || con.MailingCity == ''){
                gen.writeStringField('MailingCity', '');
            }else{
                 gen.writeStringField('MailingCity', con.MailingCity);
            }
             if(con.MailingState == null || con.MailingState == ''){
                gen.writeStringField('MailingState', '');
            }else{
                 gen.writeStringField('MailingState', con.MailingState);
            }
             if(con.MailingPostalCode == null || con.MailingPostalCode == ''){
                gen.writeStringField('MailingPostalCode', '');
            }else{
                 gen.writeStringField('MailingPostalCode', con.MailingPostalCode);
            }
             if(con.MailingCountry == null || con.MailingCountry == ''){
                gen.writeStringField('MailingCountry', '');
            }else{
                 gen.writeStringField('MailingCountry', con.MailingCountry);
            }
             if(con.MailingStreet == null || con.MailingStreet == ''){
                gen.writeStringField('MailingStreet', '');
            }else{
                 gen.writeStringField('MailingStreet', con.MailingStreet);
            }
            if(con.MobilePhone == null || con.MobilePhone == ''){
                gen.writeStringField('MobilePhone', '');
            }else{
                 gen.writeStringField('MobilePhone', con.MobilePhone);
            } 
            if(con.Enterprise_Name__c == null || con.Enterprise_Name__c == ''){
                gen.writeStringField('Enterprise_Name__c', '');
            }else{
                 gen.writeStringField('Enterprise_Name__c', con.Enterprise_Name__c);
            } 
            
            if(con.Email == null || con.Email == ''){
                gen.writeStringField('Email', '');
            }else{
                 gen.writeStringField('Email', con.Email);
            } 
            if(con.Fax == null || con.Fax == ''){
                gen.writeStringField('Fax', '');
            }else{
                 gen.writeStringField('Fax', con.Fax);
            }
            if(con.Master_Rep_ID__c == null || con.Master_Rep_ID__c == ''){
                gen.writeStringField('Master_Rep_ID__c', '');
            }else{
                gen.writeStringField('Master_Rep_ID__c', con.Master_Rep_ID__c);   
            }
            
            if(con.RecordType.Name == 'Contact Prospect'){
                gen.writeStringField('RecordType', 'Prospect');
            }
            if(con.RecordType.Name == 'LPL Advisor'){
                gen.writeStringField('RecordType', 'LPL Advisor');
            }
            if(con.Hire_Date__c == null ){
                gen.writeStringField('Hire_Date__c', '');
            }else{
                gen.writeDateField('Hire_Date__c', con.Hire_Date__c);
            }
            if(con.Net_Promoter_Score__c == null ){
                gen.writeNumberField('Net_Promoter_Score__c', 0);
            }else{
                gen.writeNumberField('Net_Promoter_Score__c', con.Net_Promoter_Score__c);
            }
            if(con.Split_of_Total_AUM__c == null ){
                gen.writeNumberField('Split_of_Total_AUM__c', 0);
            }else{
                gen.writeNumberField('Split_of_Total_AUM__c', con.Split_of_Total_AUM__c);
            }
             if(con.AUM_Attributable__c == null ){
                gen.writeNumberField('AUM_Attributable__c', 0);
            }else{
                gen.writeNumberField('AUM_Attributable__c', con.AUM_Attributable__c);
            }

            gen.writeBooleanField('LPLCRM__U_S_Citizenship__c',con.LPLCRM__U_S_Citizenship__c);

            if(con.LPLCRM__U_S_Citizenship__c == false ){
                gen.writeStringField('Citizenship_Status__c', 'Domestic Alien');
            }
            if(con.LPLCRM__U_S_Citizenship__c == true ){
                gen.writeStringField('Citizenship_Status__c', 'Domestic Customer');
            }
            if(con.Birthdate == null ){
                gen.writeStringField('Birthdate', '');
            }else{
                gen.writeDateField('Birthdate', con.Birthdate);
            }
           
            if(con.LPLCRM__Social_Security_Tax_ID__c == null || con.LPLCRM__Social_Security_Tax_ID__c == ''){
                gen.writeStringField('LPLCRM__Social_Security_Tax_ID__c', '');
            }else{
                gen.writeStringField('LPLCRM__Social_Security_Tax_ID__c', con.LPLCRM__Social_Security_Tax_ID__c);
            }
          
            if(con.CLO_Customer_group_ID__c == null || con.CLO_Customer_group_ID__c == ''){
                gen.writeStringField('CLO_Customer_group_ID__c', '');
            }else{
                gen.writeStringField('CLO_Customer_group_ID__c', con.CLO_Customer_group_ID__c);
            }
            if(con.OSJ_MGR_ID__c == null || con.OSJ_MGR_ID__c == ''){
                gen.writeStringField('OSJ_MGR_ID__c', '');
            }else{
                 gen.writeStringField('OSJ_MGR_ID__c', con.OSJ_MGR_ID__c);
            }
            if(con.Branch_ID__c == null || con.Branch_ID__c == ''){
                gen.writeStringField('Branch_ID__c', '');
            }else{
                gen.writeStringField('Branch_ID__c', con.Branch_ID__c);
            }
            if(con.OSJ_MGR_Name__c == null || con.OSJ_MGR_Name__c == ''){
                gen.writeStringField('OSJ_MGR_Name__c', '');
            }else{
                gen.writeStringField('OSJ_MGR_Name__c', con.OSJ_MGR_Name__c);
            }
            if(con.OSJ_ID__c == null || con.OSJ_ID__c == ''){
                gen.writeStringField('OSJ_ID__c', '');
            }else{
                gen.writeStringField('OSJ_ID__c', con.OSJ_ID__c);
            }
            if(con.Engagement_Index_Score__c == null){
                gen.writeStringField('Engagement_Index_Score__c', '0');
            }else{
                gen.writeStringField('Engagement_Index_Score__c', string.valueOf(con.Engagement_Index_Score__c));
            }
            if(con.of_Advisors__c == null){
                gen.writeStringField('of_Advisors__c', '0');
            }else{
                gen.writeStringField('of_Advisors__c', string.valueOf(con.of_Advisors__c));
            }
            if(con.GP_ROA__c == null){
                gen.writeNumberField('GP_ROA__c', 0);
            }else{
                gen.writeNumberField('GP_ROA__c', con.GP_ROA__c);
            }
            if(con.YTD_GDC__c == null){
                gen.writeNumberField('YTD_GDC__c', 0);
            }else{
                gen.writeNumberField('YTD_GDC__c', con.YTD_GDC__c);
            }
            if(con.Prior_Yr_GDC__c == null){
                gen.writeNumberField('Prior_Yr_GDC__c', 0);
            }else{
                 gen.writeNumberField('Prior_Yr_GDC__c', con.Prior_Yr_GDC__c);
            }
            if(con.Advisor_Total_Advisory_AUM__c == null){
                gen.writeNumberField('Advisor_Total_Advisory_AUM__c', 0);
            }else{
                gen.writeNumberField('Advisor_Total_Advisory_AUM__c', con.Advisor_Total_Advisory_AUM__c);
            }
            if(con.Advisor_Total_Brokerage_AUM__c == null){
                gen.writeNumberField('Advisor_Total_Brokerage_AUM__c', 0);
            }else{
                gen.writeNumberField('Advisor_Total_Brokerage_AUM__c', con.Advisor_Total_Brokerage_AUM__c);
            }
            if(con.Advisor_Total_AUM__c == null){
                gen.writeNumberField('Advisor_Total_AUM__c', 0);
            }else{
                gen.writeNumberField('Advisor_Total_AUM__c', con.Advisor_Total_AUM__c);
            }
            gen.writeEndObject();
        //}
        //gen.writeEndArray();
        //gen.writeEndObject();
       // gen.writeObject(con);
        gen.writeEndObject();
       // gen.writeEndObject();
        
        string jsonstring = gen.getAsString();
        
        req1.setBody(jsonstring);
        
        system.debug('jsonstring--------'+jsonstring);
        
             Http http1 = new Http();
       
             HTTPResponse res1 = http1.send(req1);
             system.debug('res1--------'+res1.getBody());
             //System.debug(JSON.deserializeUntyped(res1.getBody()));
            // Map<String, String> resBody = (Map<String,String>)JSON.deserialize(res1.getBody(), Map<String, String>.class);

            if(res1.getStatusCode() != 200){
                LPL_CreateExceptionLog.createErrorRecordForSFMuleAPIFailure('cls_LPL_SendUpdatedCustomerDatatoMule','makePostCallout',1052,dpEndpoint.DataPowerSFDataToCLOUpdateCustomerAPI__c,
               res1.getBody()+'\n'+'-------Payload-------'+'\n'+jsonstring,'Mule Soft',res1.getStatus(),res1.getStatusCode(),null,ConId);
            }
             /*if(resBody.get('statusCode') == '200'){
                    
                    loanApp.Proposals_Submitted__c = true;
                    update loanApp;
             }else{

                 //loanApp.Proposals_Submitted__c = true;
             }*/
        
        //return res1;
        
    }
}

}