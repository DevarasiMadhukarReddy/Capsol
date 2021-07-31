/*
Trigger Name            : LPL_ContractAccomodationTrigger 
Trigger Description     :*. Update Business Consultant RM of Contract Accommodation from related Contact. 
*. Update PayeeID of Contract Accommodation from Contact's Master ID.
*. Added logic to calculate Annual GP Impact with custom Setting on changing field of Accommodation details. 
*. Added logic to calculate "GL Account debited" and "GL Department # debited" with custom Setting on changing field of Requesting Dept and Accommodation Category.

Developer Name          : Ashish Gupta - CTS
Created Date            : 12 july 2017

#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
Ch-1  Update Business Consultant RM of Contract Accommodation           Ashish Gupta                        12 july 2017
from related Contact.
Ch-2  Update PayeeID of Contract Accommodation from Contact's Master ID. Ashish Gupta                       18 july 2017
Ch-3  Added logic to calculate Annual GP Impact with custom Setting      Ashish Gupta                       28 july 2017
Ch-4  Added logic to calculate GL acccount and GL Department             Ashish Gupta                       7 August 2017
with custom Setting 

Ch-05 In the 'processRecord' method, we are checking values for Accommodation status     vaibhav Wadhai     5 Sept 2017
,Approval title and Approved/declined By of Contarct Acommodation Record.
If Accommodation status=Apporved and any one of the fields i.e. Approval title or 
Approved/declined By is null then we are creating custom validation Error.

CH-06 Changes for the new record type "Non-CA One-Time Credit" WO No. SD974439:           Utkarsh Topre     19 March 2018
This includes the GL field update logic as per the Requesting Department field 
and the validation for the Approval Process based on the Credit Status field same
as CH-05.


CH-07 US-1340 - Proposal Status Flag - Pending OSJ Credit Approval. As part of this user  Amol Deshpande    22 July 2020
story, Selected proposal status to be updated based on the approval for the OSJ
credit application related to that Loan Application
Note : Test Coverage for This trigger is covered in Test classes  :LPL_ContractAccommodationTrigger_Test

* CH.No       Description                                                           Developer           Date
-----------------------------------------------------------------------------------------------------------------------
* CH-08       CS-2756 Sprint 21- Remove hardcoded loan application status values     Bhanu              01/25/2021
*/



public without sharing class LPL_ContractAccommodation_TriggerGateway {
    
    
    Set<ID> contactIDset=new Set<ID>();
    public List<contact> contactlist=new  List<contact>();
    List<Contract_Accommodation__c> accommodationList=new List<Contract_Accommodation__c>();
    
    ID nonCARecordTypeId = Schema.SObjectType.Contract_Accommodation__c.getRecordTypeInfosByName().get('Non-CA One-Time Credit').getRecordTypeId();
    
    public void collectRecordToProcess(List<Contract_Accommodation__c> newCAList, List<Contract_Accommodation__c> oldCAList){
        try{
            
            for(Contract_Accommodation__c contractObj:newCAList) {
                
                contactIDset.add(contractObj.Contact_Name__c);
                
            }
            
            contactlist=[select Id,Business_Consultant_RM__c,Master_Rep_ID__c from contact where ID In:contactIDset];
        }  
        
        catch(exception e){
            
            System.debug('LPL_ContractAccommodation_TriggerGateway:' + e.getTypeName() + 'collectRecordToProcess:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());
        }
    }
    
    
    public List<Contract_Accommodation__c> updateRMContactToAccommodation(Contract_Accommodation__c ca) {
        // Start Ch -1 Update Business Consultant RM of Contract Accommodation 
        try{
            for(Contact contactobj:contactlist) {
                
                
                ca.Business_Consultant_RM__c=contactobj.Business_Consultant_RM__c ;
                
                // End Ch -1
                
                /******** Code commented as mentioned in the WO- SD992723 by Utkarsh Topre
// Start Ch -2 Update PayeeID of Contract Accommodation from Contact's Master ID
if(ca.Payee_ID__c == Null || ca.Payee_ID__c == '' ){

ca.Payee_ID__c=contactobj.Master_Rep_ID__c;
// End Ch -2
accommodationList.add(ca);
}

*/
            }
        } 
        catch(exception e){
            
            System.debug('LPL_ContractAccommodation_TriggerGateway:' + e.getTypeName() + 'collectRecordToProcess:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());
        }
        return accommodationList;
        
    }
    
    
    /* ******ch-03 Start - Added logic to calculate Annual GP Impact with custom Setting  */
    public void calculateAnnualGpImpact(Contract_Accommodation__c oldObject,Contract_Accommodation__c newObject) {
        
        Decimal value;
        String GlAcccount;
        String GlDepartment;
        try{
            
            
            
            
            if(newObject.Accommodation_Detail__c=='Tech, Resource, HOS (3 years from hire)')
            {
                if(Contract_Accommodations__c.getInstance('Tech,Resource,HOS')!=null){
                    value=Contract_Accommodations__c.getInstance('Tech,Resource,HOS').Gross_Profit__c;
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Tech, Resource, HOS, E&O (3 years from hire)'){
                if(Contract_Accommodations__c.getInstance('Tech, Resource,HOS,E&O')!=null){
                    value=Contract_Accommodations__c.getInstance('Tech, Resource,HOS,E&O').Gross_Profit__c;
                    
                }
            }
            //------
            
            if(newObject.Accommodation_Detail__c=='Albridge'){
                
                if(Contract_Accommodations__c.getInstance('Albridge')!=null){
                    
                    value=Contract_Accommodations__c.getInstance('Albridge').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Branchnet (Core)'){
                
                if(Contract_Accommodations__c.getInstance('Branchnet (Core)')!=null){
                    value=Contract_Accommodations__c.getInstance('Branchnet (Core)').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='E&O'){
                if(Contract_Accommodations__c.getInstance('E&O')!=null){
                    value=Contract_Accommodations__c.getInstance('E&O').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Enhanced Trading - Reballancer Add-on'){
                if(Contract_Accommodations__c.getInstance('Enhanced Trading - Reballancer Add-on')!=null){
                    value=Contract_Accommodations__c.getInstance('Enhanced Trading - Reballancer Add-on').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='HOS'){
                System.debug('value of Hos'+Contract_Accommodations__c.getInstance('HOS'));
                if(Contract_Accommodations__c.getInstance('HOS')!=null){
                    value=Contract_Accommodations__c.getInstance('HOS').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='HOS (through 2018)'){
                if(Contract_Accommodations__c.getInstance('HOS (through 2018)')!=null){
                    value=Contract_Accommodations__c.getInstance('HOS (through 2018)').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Orion'){
                if(Contract_Accommodations__c.getInstance('Orion')!=null){
                    value=Contract_Accommodations__c.getInstance('Orion').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Portfolio Manager'){
                if(Contract_Accommodations__c.getInstance('Portfolio Manager')!=null){
                    value=Contract_Accommodations__c.getInstance('Portfolio Manager').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Resource'){
                if(Contract_Accommodations__c.getInstance('Resource')!=null){
                    value=Contract_Accommodations__c.getInstance('Resource').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Retirement Partners Tool'){
                if(Contract_Accommodations__c.getInstance('Retirement Partners Tool')!=null){
                    value=Contract_Accommodations__c.getInstance('Retirement Partners Tool').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Reuters'){
                if(Contract_Accommodations__c.getInstance('Reuters')!=null){
                    value=Contract_Accommodations__c.getInstance('Reuters').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Split Rep-ID'){
                if(Contract_Accommodations__c.getInstance('Split Rep-ID')!=null){
                    value=Contract_Accommodations__c.getInstance('Split Rep-ID').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Wealthvision'){
                if(Contract_Accommodations__c.getInstance('Wealthvision')!=null){
                    value=Contract_Accommodations__c.getInstance('Wealthvision').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Salesforce'){
                if(Contract_Accommodations__c.getInstance('Salesforce')!=null){
                    value=Contract_Accommodations__c.getInstance('Salesforce').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Morningstar'){
                if(Contract_Accommodations__c.getInstance('Morningstar')!=null){
                    value=Contract_Accommodations__c.getInstance('Morningstar').Gross_Profit__c;
                    
                }
            }
            
            if(newObject.Accommodation_Detail__c=='Portfolio Review Tool'){
                if(Contract_Accommodations__c.getInstance('Portfolio Review Tool')!=null){
                    value=Contract_Accommodations__c.getInstance('Portfolio Review Tool').Gross_Profit__c;
                }  
            }          
            
            
            
            if(newObject.Accommodation_Detail__c=='Portfolio Review Tool'){
                if(Contract_Accommodations__c.getInstance('Portfolio Review Tool')!=null){
                    value=Contract_Accommodations__c.getInstance('Portfolio Review Tool').Gross_Profit__c;
                }  
            } // **Ch-3 End **
            
            /*******CH-06 START - Changes for the new record type "Non-CA One-Time Credit"*********************************/
            
            if(newObject.RecordTypeId == nonCARecordTypeId){
                
                
                if(newObject.Requesting_Dept__c=='Core Business Development')
                { 
                    
                    GlAcccount= GL_Account_and_GL_Department_Debited__c.getInstance('Core Business Development').GL_Account__c;
                    GlDepartment=GL_Account_and_GL_Department_Debited__c.getInstance('Core Business Development').GL_Department__c;
                    
                    
                }
                
                
                else if(newObject.Requesting_Dept__c=='Inst. Business Development')
                { 
                    
                    GlAcccount= GL_Account_and_GL_Department_Debited__c.getInstance('Inst. Business Development').GL_Account__c;
                    GlDepartment=GL_Account_and_GL_Department_Debited__c.getInstance('Inst. Business Development').GL_Department__c;
                    
                    
                }
                
                else if(newObject.Requesting_Dept__c=='IAS Business Consulting')
                { 
                    
                    GlAcccount= GL_Account_and_GL_Department_Debited__c.getInstance('IAS Business Consulting').GL_Account__c;
                    GlDepartment=GL_Account_and_GL_Department_Debited__c.getInstance('IAS Business Consulting').GL_Department__c;
                    
                    
                }
                
                else if(newObject.Requesting_Dept__c=='IS Business Consulting')
                { 
                    
                    GlAcccount= GL_Account_and_GL_Department_Debited__c.getInstance('IS Business Consulting').GL_Account__c;
                    GlDepartment=GL_Account_and_GL_Department_Debited__c.getInstance('IS Business Consulting').GL_Department__c;
                    
                    
                }
                
            }
            
            /*******CH-06 END - Changes for the new record type "Non-CA One-Time Credit"*********************************/
            
            //** ch -4 start **
            
            if(newObject.Requesting_Dept__c=='Core Business Development' && (newObject.Accommodation_Type_Term__c!=null ||newObject.Accommodation_Type_Term__c!=''))
            { 
                if(newObject.Accommodation_Type_Term__c=='Recruiting Initiatives'||newObject.Accommodation_Type_Term__c=='Fee Waivers'||newObject.Accommodation_Type_Term__c=='Technology'||newObject.Accommodation_Type_Term__c=='Other')
                {
                    
                    
                    GlAcccount= GL_Account_and_GL_Department_Debited__c.getInstance('Core Business Development').GL_Account__c;
                    GlDepartment=GL_Account_and_GL_Department_Debited__c.getInstance('Core Business Development').GL_Department__c;
                    
                    
                } 
                
            }
            
            else if(newObject.Requesting_Dept__c=='Inst. Business Development' && (newObject.Accommodation_Type_Term__c!=null ||newObject.Accommodation_Type_Term__c!=''))
            { System.debug('inside ch 2'+newObject.Accommodation_Type_Term__c);
             if(newObject.Accommodation_Type_Term__c=='Recruiting Initiatives'||newObject.Accommodation_Type_Term__c=='Fee Waivers'||newObject.Accommodation_Type_Term__c=='Technology'||newObject.Accommodation_Type_Term__c=='Other')
             {
                 System.debug('inside ch 2 1'+newObject.Accommodation_Type_Term__c);
                 
                 GlAcccount= GL_Account_and_GL_Department_Debited__c.getInstance('Inst. Business Development').GL_Account__c;
                 GlDepartment=GL_Account_and_GL_Department_Debited__c.getInstance('Inst. Business Development').GL_Department__c;
                 System.debug('GlAcccount'+GlAcccount);
                 System.debug('GlDepartment'+GlDepartment);
                 
             } 
             
            }
            else 
                if(newObject.Requesting_Dept__c=='IAS Business Consulting' && (newObject.Accommodation_Type_Term__c!=null ||newObject.Accommodation_Type_Term__c!=''))
            { 
                if(newObject.Accommodation_Type_Term__c=='Fee Waivers'||newObject.Accommodation_Type_Term__c=='Technology'||newObject.Accommodation_Type_Term__c=='Other')
                {
                    
                    
                    GlAcccount= GL_Account_and_GL_Department_Debited__c.getInstance('IAS Business Consulting').GL_Account__c;
                    GlDepartment=GL_Account_and_GL_Department_Debited__c.getInstance('IAS Business Consulting').GL_Department__c;
                    
                    
                } 
                
            }
            
            else 
                if(newObject.Requesting_Dept__c=='IS Business Consulting' && (newObject.Accommodation_Type_Term__c!=null ||newObject.Accommodation_Type_Term__c!=''))
            { 
                if(newObject.Accommodation_Type_Term__c=='Fee Waivers'||newObject.Accommodation_Type_Term__c=='Technology'||newObject.Accommodation_Type_Term__c=='Other')
                {
                    
                    
                    GlAcccount= GL_Account_and_GL_Department_Debited__c.getInstance('IS Business Consulting').GL_Account__c;
                    GlDepartment=GL_Account_and_GL_Department_Debited__c.getInstance('IS Business Consulting').GL_Department__c;
                    
                    
                } 
                
            }
            
            
            if(Trigger.IsUpdate){       
                if(oldObject.Accommodation_Detail__c!=newObject.Accommodation_Detail__c)
                { 
                    
                    System.debug('value??'+value);
                    newObject.Annual_GDP_Impact__c=value; 
                    
                }
                //** ch -3 end   
                
                //** ch -4  start -Added logic to calculate GL acccount and GL Department 
                if((oldObject.Requesting_Dept__c!=newObject.Requesting_Dept__c)||(oldObject.Accommodation_Type_Term__c!=newObject.Accommodation_Type_Term__c) ){
                    System.debug('Inside Update Operation GlAcccount'+GlAcccount+'>> GlDepartment>>'+GlDepartment);
                    newObject.GL_Account__c = String.Valueof(GlAcccount);
                    newObject.GL_Department__c =String.Valueof(GlDepartment);
                }
                
                //** ch -4 end 
            }        
            
            if(Trigger.IsInsert){    
                
                System.debug('value??'+value);
                newObject.Annual_GDP_Impact__c=value; //** ch -3 
                
                newObject.GL_Account__c = String.Valueof(GlAcccount); //** ch -4 
                newObject.GL_Department__c = String.Valueof(GlDepartment);  //** ch -4 
                
                
            } 
            
            
        }
        catch(exception e) {
            
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_ContractAccommodation_TriggerGateway','calculateAnnualGpImpact',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
        
    }
    /* ******ch-01 End  */ 
    
    // CH-05 Start
    
    public void processRecord(Contract_Accommodation__c cc) {
        
        Id testid = cc.Id;
        string Url ='<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid+' >Click here</a>';
        
        if (cc!=null) {
            
            //System.debug('Successfully unlocked Contract_Accommodation__c with ID: ' + unlockedRersult.getId());
            //Start CH-08
            if(cc.Accommodation_Status__c == LoanSubmitApplication.getApplicationStatus('Contract_Accommodation__c','Status_1')  && (cc.Approved_Declined_By__c==NULL || cc.Approver_Title__c==NULL)) {
                //end CH-08
                if(cc.Approver_Title__c==NULL) {
                    
                    //String testid= ApexPages.currentPage().getParameters().get('Id');                
                    //string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid;
                    //string Url ='<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid+' >Click here</a>';
                    
                    cc.Approver_Title__c.addError('Please add Approver Title AND Approved/Declined By before approve. Please '+ Url +' to retun in the detail page of the CA record',false );
                    
                }
                if(cc.Approved_Declined_By__c==NULL) {
                    
                    //string Urll ='<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid+' >Click here</a>';
                    
                    cc.Approved_Declined_By__c.addError('Please add Approver Title AND Approved/Declined By before approve. Please '+ Url +' to retun in the detail page of the CA record',false );
                    
                    //cc.Approved_Declined_By__c.addError('please add Approver Title AND Approved/Declined By before approve');
                }
                
            }
        }
    }
    
    // CH-05 End
    
    /*******CH-06 START - Changes for the new record type "Non-CA One-Time Credit"*********************************/
    
    public void processNonCARTRecord(Contract_Accommodation__c cc) {
        
        try{  
            
            Id testid = cc.Id;
            string Url ='<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid+' >Click here</a>';
            
            if (cc!=null) {
                
                if(cc.RecordTypeId == nonCARecordTypeId){
                    //Start CH-08
                    if(cc.Credit_Status__c== LoanSubmitApplication.getApplicationStatus('Contract_Accommodation__c','Status_2') && (cc.Approved_Declined_By__c==NULL || cc.Approver_Title__c==NULL)) {
                        //End CH-08
                        if(cc.Approver_Title__c==NULL) {
                            
                            //String testid= ApexPages.currentPage().getParameters().get('Id');                
                            //string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid;
                            //string Url ='<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid+' >Click here</a>';
                            
                            cc.Approver_Title__c.addError('Please add Approver Title AND Approved/Declined By before approve. Please '+ Url +' to retun in the detail page of the CA record',false );
                            
                        }
                        if(cc.Approved_Declined_By__c==NULL) {
                            
                            //string Urll ='<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+testid+' >Click here</a>';
                            
                            cc.Approved_Declined_By__c.addError('Please add Approver Title AND Approved/Declined By before approve. Please '+ Url +' to retun in the detail page of the CA record',false );
                            
                            //cc.Approved_Declined_By__c.addError('please add Approver Title AND Approved/Declined By before approve');
                        }
                        
                    }
                }
            }
            
        }
        
        catch(exception e) {
            
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_ContractAccommodation_TriggerGateway','calculateAnnualGpImpact',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    
    
    /*******CH-06 START - Changes for the new record type "Non-CA One-Time Credit"*********************************/
    
    
    /*******CH-07 START "*********************************/
    public void updateSelectedProposalStatus(Contract_Accommodation__c newCA) {
        
        try{  
            
            Id CAId = newCA.Id;
            List<Proposal_Offer__c> lstProp = new List<Proposal_Offer__c>();
            List<Proposal_Offer__c> finallstProp = new List<Proposal_Offer__c>();
            List<Id> propIds = new List<Id>();
            
            system.debug('newCA@@@@@@@@@@@@@'+newCA);
            system.debug('newCA.RecordTypeID@@@@@@@@@@@@@'+newCA.RecordTypeId);
            system.debug('newCA.Loan_Application__c@@@@@@@@@@@@@'+newCA.Loan_Application__c);
            
            Id TA_OSJ_RecordTypeId =  Schema.getGlobalDescribe().get('Contract_Accommodation__c').getDescribe().getRecordTypeInfosByName().get('TA OSJ Credit').getRecordTypeId();
            system.debug('TA_OSJ_RecordTypeId@@@@@@@@@@@@@'+TA_OSJ_RecordTypeId);
            
            if (newCA!=null && newCA.RecordTypeId == TA_OSJ_RecordTypeId && newCA.Loan_Application__c != null) {
                Proposal_Offer__c selProp = new Proposal_Offer__c();
                Loan_Application__c loanlst= new Loan_Application__c();
                selProp = [select id,name,Proposal_Status__c,Status__c,LoanApp_MD__c from Proposal_Offer__c where LoanApp_MD__c = :newCA.Loan_Application__c 
                           AND Status__c = true];
                loanlst.id=selProp.LoanApp_MD__c;
                if(selProp != null){
                    //Start CH-08
                    List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
                    String   ContractStatusRequestInitiated=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Contract_Accommodation__c','Status_3');
                    String   ContractStatusSbmtApproval=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Contract_Accommodation__c','Status_4');
                    String   ProposalStatusAcceptedCP=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Proposal_Offer__c','Status_3');
                    String   ContractStatusMgrApproved=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Contract_Accommodation__c','Status_2');
                    String   ContractStatusDeclined=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Contract_Accommodation__c','Status_5');
                    String   ProposalStatusAccepted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Proposal_Offer__c','Status_1');
                    String   ProposalStatusAcceptedCNA=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Proposal_Offer__c','Status_4');                  
                    
                    String LoanStatusOfferAccepted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_4');      
                    String LoanStatusSubmitForAppoval=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_12');  
                    String LoanStatusDeclined=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_2');  
                    String LoanStatusFunded=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_7');  
                    String LoanStatusDocumentation=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_13'); 
                    String LoanStatusBoarding=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_14'); 
                    
                    if(newCA.Credit_Status__c == ContractStatusRequestInitiated || newCA.Credit_Status__c == ContractStatusSbmtApproval){
                        selProp.Proposal_Status__c = ProposalStatusAcceptedCP;
                        loanlst.Status__c = selProp.Proposal_Status__c;
                    }else if(newCA.Credit_Status__c == ContractStatusMgrApproved){
                        selProp.Proposal_Status__c = ProposalStatusAccepted;
                        if(loanlst.Status__c != LoanStatusDeclined || loanlst.Status__c != LoanStatusFunded || loanlst.Status__c != LoanStatusDocumentation
                           || loanlst.Status__c != LoanStatusBoarding || loanlst.Status__c != LoanStatusSubmitForAppoval)
                            loanlst.Status__c = LoanStatusOfferAccepted;
                    }else if(newCA.Credit_Status__c == ContractStatusDeclined){
                        selProp.Proposal_Status__c = ProposalStatusAcceptedCNA;
                        loanlst.Status__c = selProp.Proposal_Status__c;
                    }
                    
                }
                
                update selProp;
                update loanlst;
                system.debug('loanlst1**'+loanlst);
                system.debug('selProp**'+selProp);
                finallstProp.add(selProp);
                
                lstProp = [select id,name,Proposal_Status__c,Status__c from Proposal_Offer__c where LoanApp_MD__c = :newCA.Loan_Application__c 
                           AND Status__c = false];
                
                if(lstProp != null){
                    finallstProp.addAll(lstProp);  
                }
                
                system.debug('finallstProp'+finallstProp);
                for(Proposal_Offer__c prop:finallstProp){
                    propIds.add(prop.id);
                }
                
                Loan_Application__c loanApp = new Loan_Application__c();
                loanApp = [Select id,Status__c,CLO_Application_ID__c from Loan_Application__c where ID = :newCA.Loan_Application__c];
                if(loanApp != null && loanApp.CLO_Application_ID__c != null && selProp.Proposal_Status__c == 'Accepted'){
                    //Commnted below code by Amol to limit duplicate callouts.
                    //cls_LPL_SendLoan_ProposalUpdatestoMule.makePostCallout(loanApp.Id,propIds);
                }
                
            }
        }
        
        catch(exception e) {
            
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_ContractAccommodation_TriggerGateway','updateSelectedProposalStatus',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    
    /*******CH-07 END "*********************************/
}