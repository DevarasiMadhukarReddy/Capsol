/***
     * US 60 - Send Loan Application Updates to CLO as part of Update Loan Application Details Service
     * for Loan Application which are already submitted to CLO
     * ----------------------Updated by Amol Sprint 12 CapSol - 05/18/2020 - CH01
     * 
     * CS-1123 Backend TA Accepted Loan Amount Auto Calculation,Updated by Madhukar Reddy for BackendCalculation
     * CS-2703 Duplicate Validation issue added by Madhukar Reddy for all applications 12/18/2020 -CH02
     * CH-03 CS-2735 Process Builder Exception Error                    Bhanu               01/06/2021 
     * CH.No       Description                                                           Developer           Date
---------------------------------------------------------------------------------------------------------------
     * CH-04       CS-2756 Sprint 21- Remove hardcoded loan application status values     Bhanu              01/25/2021
     * CH-06        Optimization Fix for 101 SOQL error.Boolean Check to 
                   not call ContactTriggerHandler for CAPSOL                              Amol               01/13/2021
     * CH-07       CS-1335 Enhancement - Update Application and related records to read-only      Madhukar Reddy 3/4/2021
                   when offer accepted 
     */
    
    public class LPL_LoanApplicationHandler {
    public static boolean capsolexecutionConTrigger = false ;//CH-06

    public static void beforeInsert(List<Loan_Application__c> loanApps) {
        Set<Id> contactIds = new Set<Id>();
        Set<Id> primaryContacts = new Set<Id>();
        for(Loan_Application__c loan : loanApps) {
            //loan.status__c = 'Initiated';
            loan.Last_Status_Modified_Date__c = System.today();
            contactIds.add(loan.Advisor__c);
        }
        
         //Start  CH-04
         List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
         String   loanStatusFunded=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_7');
          String   loanStatusInitiated=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_3');
           String   loanStatusDeclined=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_2');
            String   loanStatusNotAccepted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_9');
        

        //CH02 Madhu Added status__c !='Initiated'
        List<Loan_Application__c> loanAppList = [SELECT id, Advisor__c, Primary_Contact__c, status__c, recordtypeId FROM Loan_Application__c 
         WHERE Advisor__c IN: contactIds AND status__c != :loanStatusNotAccepted AND status__c !=:loanStatusDeclined AND status__c !=:loanStatusFunded AND status__c !=:loanStatusInitiated
                                                AND Primary_Contact__c = true];
           System.debug('****loanAppList'+loanAppList);
        // CH-04 End //CH02 end
        list<Id> lststr = new list<Id>();   
        for(Loan_Application__c loan : loanAppList) { 
            primaryContacts.add(loan.Advisor__c);
          lststr.add(loan.recordtypeId);
        }
      
        if(primaryContacts.size() > 0) {
            for(Loan_Application__c loan1 : loanApps) {
               if( loan1.Advisor__c != null && primaryContacts.contains(loan1.Advisor__c) && lststr.contains(loan1.recordtypeId)) {
                    loan1.addError('This Customer already has an Opened Loan Application');
                }
            }
        }
    }
    
    public static void afterInsert(List<Loan_Application__c> loanApps) {
        
    }
     public static void loanapplicationafterInsert(List<Loan_Application__c> loanApps) {
        List<Loan_Application__c> updateLoanApplicationList = new List<Loan_Application__c>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> OppIds = new Set<Id>();
        Loan_Application__c LoanObj = new Loan_Application__c();
        for(Loan_Application__c loan : loanApps) {
            contactIds.add(loan.Advisor__c);
        }
        for(Loan_Application__c loan : loanApps) {
            OppIds.add(loan.Opportunity__c);
        }
        List<Opportunity> oppList = [SELECT id,Assigned_Recruiter__c,Internal_Recruiter_IRD__c,Regional_VP__c FROM Opportunity WHERE ID IN: OppIds];
        system.debug('oppList'+oppList);
        
        List<Financials__c> financecontactList = [SELECT id,YTD_GDC_All__c,Prior_full_year_GDC_All__c,Total_Advisory_AUM__c,AUM_Custodied_Brokerage__c,AUM_Total_Current_Year__c,Advisor__c,CreatedDate FROM Financials__c WHERE Advisor__c IN: contactIds ORDER BY CreatedDate DESC LIMIT 1];
        system.debug('financecontactList'+financecontactList);
        
        List<Advisor_Profitability__c> advisorcontactList = [SELECT id,Gross_Profit_ROA__c,Contact__c,CreatedDate FROM Advisor_Profitability__c WHERE Contact__c IN: contactIds ORDER BY CreatedDate DESC LIMIT 1];
        system.debug('advisorcontactList'+advisorcontactList);
    
        if(oppList.size() >0){
            for(Opportunity opp : oppList) {
                LoanObj.Assigned_Recruiter__c=opp.Assigned_Recruiter__c;
                LoanObj.Internal_Recruiter__c=opp.Internal_Recruiter_IRD__c;
                LoanObj.Business_Developer__c=opp.Regional_VP__c;
                //LoanObj.Current_Firm_Type__c=opp.Firm_Type_Broker_Dealer__c;
                //LoanObj.Current_Firm_Name__c=opp.Account__c;  
                LoanObj.Id=loanApps[0].Id;
                //update LoanObj; //Commmented by Amol-08June2020 - to do DML outside for loop
                system.debug('LoanObj Opp'+LoanObj);
            }
        }
        
        
        
        if(financecontactList.size() >0){
            for(Financials__c fincon : financecontactList) {
                LoanObj.YTD_GDC__c=fincon.YTD_GDC_All__c;
                LoanObj.Prior_Yr_GDC__c=fincon.Prior_full_year_GDC_All__c;
                LoanObj.Advisor_Total_Advisory_AUM__c=fincon.Total_Advisory_AUM__c;
                LoanObj.Advisor_Total_Brokerage_AUM__c=fincon.AUM_Custodied_Brokerage__c;
                LoanObj.Advisor_Total_AUM__c=fincon.AUM_Total_Current_Year__c;
                LoanObj.Id=loanApps[0].Id;
                //update LoanObj; //Commmented by Amol-08June2020 - to do DML outside for loop
                system.debug('LoanObj finance'+LoanObj);
            }
         }
        
         if(advisorcontactList.size() >0){
            for(Advisor_Profitability__c advcon : advisorcontactList) {
                LoanObj.GP_ROA__c=advcon.Gross_Profit_ROA__c;
                LoanObj.Id=loanApps[0].Id;
                
                //update LoanObj;//Commmented by Amol-08June2020 - to do DML outside for loop
                system.debug('LoanObj adv'+LoanObj);
            }
         }
        
        if(LoanObj.id != null){
            updateLoanApplicationList.add(LoanObj); //Added by Amol-08June2020 - to do DML outside for loop
        }
        system.debug('updateLoanApplicationList'+updateLoanApplicationList);  
        if(updateLoanApplicationList.size() > 0)
        {
            system.debug('updateLoanApplicationListAmol'+updateLoanApplicationList);
            update updateLoanApplicationList; //Added by Amol-08June2020
        }    
        
    }
    public static void afterInsertContactAccomodicationcreation(List<Loan_Application__c> loanApps) {   
     /*Set<Id> loanIds = new Set<Id>();
     List<Loan_Application__c> loanApp = new List<Loan_Application__c>();
        for(Loan_Application__c loan : loanApps) {
            loanIds.add(loan.Id);
        }
           loanApp= [SELECT id,Status__c,Primary_Contact_Name__c,Opportunity__c,Opportunity__r.Credit_to_OSJ__c,Opportunity__r.Forgivable_Loan__c,Opportunity__r.OSJ_Rep_ID__c,Opportunity__r.Hire_Date__c,Opportunity__r.Contact__r.Name,Opportunity__r.Regional_VP__c,RecordTypeId,Opportunity__r.Business_Consultant_RM_From_Contact__c,Opportunity__r.Contact__c,Opportunity__r.AccountId FROM Loan_Application__c WHERE Id IN: loanIds];
            system.debug('loanApp'+loanApp);
        
        Id TransitionAssistanceRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
        Id TAOSJCreditRecordTypeId = Schema.SObjectType.Contract_Accommodation__c.getRecordTypeInfosByDeveloperName().get('TA_OSJ_Credit').getRecordTypeId();
        
        list<Contract_Accommodation__c> conAccLst = new list<Contract_Accommodation__c>();
        
        //Start  CH-04
        if(loanApp[0].Id != null && loanApp[0].RecordTypeId == TransitionAssistanceRecordTypeId  && loanApp[0].Status__c == :LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_10')  && loanApp[0].Opportunity__c !=null
           && loanApp[0].Opportunity__r.Credit_to_OSJ__c !=null && loanApp[0].Opportunity__r.Forgivable_Loan__c !=null && loanApp[0].Opportunity__r.OSJ_Rep_ID__c !=null && loanApp[0].Opportunity__r.Hire_Date__c !=null){
         //End
               
               Contract_Accommodation__c conAccObj = new Contract_Accommodation__c();
               conAccObj.Loan_Application__c = loanApp[0].Id;
               conAccObj.Contact_Name__c = loanApp[0].Opportunity__r.Contact__c;
               //conAccObj.Business_Consultant_RM__c = loanApp[0].Opportunity__r.Business_Consultant_RM_From_Contact__c;
               //conAccObj.Business_Consultant_RM__c = loanApp[0].Opportunity__r.Contact__c;
               conAccObj.Payee_ID__c = loanApp[0].Primary_Contact_Name__c;
               conAccObj.Hire_Date__c = loanApp[0].Opportunity__r.Hire_Date__c;
               conAccObj.Enterprise__c = loanApp[0].Opportunity__r.AccountId;
               //conAccObj.Branch_ID__c = loanAppId;
               // conAccObj.OSJ_ID__c = loanAppId;
               conAccObj.Credit_Status__c = 'Submitted for Approval';
               conAccObj.Requesting_Dept__c = 'Core Business Development';
               conAccObj.Created_By_Manager__c = loanApp[0].Opportunity__r.Regional_VP__c;
               conAccObj.Approved_Declined_By__c = loanApp[0].Opportunity__r.Regional_VP__c;
               conAccObj.Approver_Title__c = 'SVP';
               conAccObj.Credit_Category__c = 'TA OSJ Credit';
               conAccObj.Credit_Amount_Requested__c = loanApp[0].Opportunity__r.Credit_to_OSJ__c;
               conAccObj.Does_credit_stay_with_individual_or_flow__c = 'Individual';
               conAccObj.Advisor_Statement_Description__c = 'test ';
               conAccObj.GL_Department__c = ' ';
               conAccObj.GL_Account__c = string.valueof('812150');
               system.debug('con GLAccount'+conAccObj.GL_Account__c);
               conAccObj.Additional_Details__c = ' ';
               conAccObj.RecordTypeId = TAOSJCreditRecordTypeId;
               conAccLst.add(conAccObj);
               
           }
        system.debug('conAccLst1111'+conAccLst);
        
        insert conAccLst; 
    if(conAccLst.size() >0){
     Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
     req.setComments('Submitted for approval. Please approve.');
     req.setObjectId(conAccLst[0].Id);
     Approval.ProcessResult result = Approval.process(req);
     System.debug('Submitted for approval successfully: '+result.isSuccess());
     }*/
    }
    public static void LoanstatusUpdate(list<Loan_Application__c> loanapp1) {
    
    set<id> setid= new set<id>();
    for(Loan_Application__c La:loanapp1)
     {
        setid.add(la.id);
     }
    
      //Start  CH-04
         List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
         String   loanStatusDeclined=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_2');
    
    list<Loan_Application__c> LAlst=[select id,status__c from Loan_Application__c where id in:setid and status__c=:loanStatusDeclined];
    if(LAlst.size()>0)
    {
     for(Loan_Application__c la1:loanapp1)
     {
       if(la1.status__c== loanStatusDeclined ){  //End CH-04
         la1.adderror('You cant edit the loan application because status is Declined');
     }
    }
    
    }
    }
    
    public static void updateCLODetailsonContact(Map<Id, Loan_Application__c> nMap,Map<Id, Loan_Application__c> oMap){
    if(capsolexecutionConTrigger == false){
        capsolexecutionConTrigger = true;
        system.debug('capsolexecutionConTrigger'+capsolexecutionConTrigger);
        Set<Id> LoanIdSet=new Set<Id>();
        Map<Id,Set<Id>> LoanwithContactsMap=new Map<Id,Set<Id>>();
        List<Contact> ContactList=new List<Contact>();
          //Start  CH-04
         List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
         String   loanStatusDeclined=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_2');
        system.debug('nMap@@@@@@@@@@'+nMap);
        for(Id ln:nMap.KeySet()){
           /**CH-03 **/
           
            if(nMap.get(ln).status__C!=null && nMap.get(ln).status__C!=loanStatusDeclined && nMap.get(ln).CLO_Customer_Group_Id__c!=null && nMap.get(ln).CLO_Customer_Group_Id__c!=oMap.get(ln).CLO_Customer_Group_Id__c){ //End CH-04
                LoanIdSet.add(ln);
            }
        }
        system.debug('LoanIdSet!!!!!!!!!'+LoanIdSet);
        for(Borrowers__c br:[select Id,Contact__c,Loan_Application__c from Borrowers__c where Loan_Application__c in:LoanIdSet and Contact__c!=null ]){
        system.debug('LoanwithContactsMap########'+LoanwithContactsMap);
            if(!LoanwithContactsMap.containsKey(br.Loan_Application__c))
                LoanwithContactsMap.put(br.Loan_Application__c,new Set<Id>());
            LoanwithContactsMap.get(br.Loan_Application__c) .add(br.Contact__c); 
        }
        system.debug('LoanwithContactsMap$$$$$$'+LoanwithContactsMap);
        if(LoanwithContactsMap.size()>0){
            for(Id ln:LoanwithContactsMap.keySet()){
                for(Id cn:LoanwithContactsMap.get(ln)){
                    Contact temp=new Contact();
                    temp.Id=cn;
                    temp.CLO_Customer_Group_Id__C=nMap.get(ln).CLO_Customer_Group_Id__c;
                    ContactList.add(temp);
                }
                
            }
        }
        system.debug('ContactList%%%%%%%%'+ContactList);
        if(ContactList.size()>0){
         // CH06 Start
        
        
         // CH06 End
            update ContactList;
            
        }
        }
        
    }
    
    //CH01 Start
    public static void sendLoanAppUpdatesToCLO(list<Loan_Application__c> newLAList,list<Loan_Application__c> oldLAList){
         if(StaticFunction.runOnceApplicationUpdatesToCLO()){
         boolean runonce=true;
         List<Proposal_Offer__c> propList = new List<Proposal_Offer__c>();
            List<Id> propIds = new List<Id>();
         system.debug('userInfo.getUserId();'+userInfo.getUserId());
        system.debug('newLAList@@@@@@@@'+newLAList);
                system.debug('oldLAList@@@@@@@@'+oldLAList);
                Boolean fireUpdateApi = false;
                Boolean propStatus = false;
                Id LAId;
                for(Loan_Application__c newLA : newLAList){
                    if(runonce){
                    if(newLA.CLO_Application_ID__c != null &&  
                    newLA.CLO_Customer_Group_ID__c != null){
                        SObject oldLA = Trigger.oldMap.get(newLA.ID);
                    // if(oldContact.Legal_Entity__c != newCon.Legal_Entity__c )
    
                    for(Schema.FieldSetMember fld :SObjectType.Loan_Application__c.FieldSets.CapsolUpdateLoanAppFieldSet.getFields()) {
                        system.debug('FIELDSET$$$$$$$$$$$$$$$$$$$'+fld.getFieldPath());
                        //string APIname = fld.getFieldPath();
                        if(oldLA.get(fld.getFieldPath()) != newLA.get(fld.getFieldPath())){
                                fireUpdateApi = true;
                                LAId = newLA.Id;
                                
                        }
    
                    }
    
                    }
                    runonce = false;
                }
            }
    
            list<Id> loanAppIds = new list<Id>();
            Loan_Application__c loanAppRec = new Loan_Application__c();
            loanAppIds.add(LAId);
            if(LAId != null){
            loanAppRec = [select id,status__c from Loan_Application__c where id = :LAId];
            propList = [select id,proposal_status__c,recordtype.developername from Proposal_Offer__c where LoanApp_MD__c = :LAId and Status__c = true];
                if(propList != null && propList.size() > 0){
                    for(Proposal_Offer__c prop:propList){
                    propIds.add(prop.id);
                    system.debug('prop.proposal_status__c'+prop.proposal_status__c);
                        if(prop.proposal_status__c !=null && prop.proposal_status__c != 'Accepted - Pending Credit Approval' && 
                        prop.proposal_status__c != 'Accepted - Credit Not Approved'){
                            propStatus = true;
                        }
                    }
               
                } 
    
      //Start  CH-04
         List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
         String   loanStatusPendingCredit=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_5');
          String   loanStatusCreditNotApproved=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_6');
    
    //Start CH-04
                if(fireUpdateApi && propStatus && System.IsBatch() == false && userInfo.getUserId() !=  system.Label.AEM_Integration_User_ID 
                 && loanAppRec.Status__c!= loanStatusPendingCredit && 
                    loanAppRec.Status__c!= loanStatusCreditNotApproved){
                       cls_LPL_SendLoan_ProposalUpdatestoMule.callWebservice(loanAppIds);
                }
            }//Ends
         }
        
    }
    //CH01 End
    // CS-1123 Backend TA Accepted Loan Amount Auto Calculation,Updated by Madhukar Reddy for BackendCalculation
    public static void BackendCalculation(List<Loan_Application__c> loanApplicationNewList){
    Id BackendTAProposalRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Backend_TA').getRecordTypeId();
  
    for(Loan_Application__c loan: loanApplicationNewList){
    
    if(loan.recordTypeId == BackendTAProposalRecordTypeId){
    
    Decimal Sumnna=loan.SUM_NNA__c!=null?loan.SUM_NNA__c:0;
    Decimal Backendhurdle=loan.Backend_Hurdle__c!=null?loan.Backend_Hurdle__c:0;
    Decimal Backendbps=loan.Backend_Bps__c!=null?loan.Backend_Bps__c:0;
    loan.Requested_Loan_Amount__c=(sumnna - Backendhurdle ) * Backendbps;
   
    }
    }
    }
    
    
        //Start CH-04
    public static String getApplicationStatus(List<LPL_Applications_status__mdt> lplStatusLst, String objectName,String status)
    {
     String LoanAppstatus='';
       // List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from //LPL_Applications_status__mdt];
        for(LPL_Applications_status__mdt lplstatus : lplStatusLst)
        {   
             if(lplstatus.Object_Name__c  == objectName && lplstatus.Action__c == status)
           {
                LoanAppstatus= lplstatus.Status__c;
            }
        }
        return LoanAppstatus;
    }
     //End
    // CH-07 START
    public static void allowAddtionalFieldUpdate(List<Loan_Application__c> oldLAList,List<Loan_Application__c> newLAList){
        List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
        String   loanStatusDocumentation=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_13');
       // String   loanStatusOfferAccepted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_4');
        String   loanStatusBoardingFunding=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_14');
        String   loanStatusNigo=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_15');
        String   loanStatuInformationRequested=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_16');
        String   loanStatusInformationSubmitted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_17');
        String   loanStatusFunded=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_7');
        Id AcquisitionRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Acquisition_Loan').getRecordTypeId();
        Id GrowthRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Growth_Loan').getRecordTypeId();
        Id LineofCreditRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Line_of_Credit').getRecordTypeId();
        Id RefinanceRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Refinance_Loan').getRecordTypeId();
        String  System_Administrator1 = system.label.System_Administrator;
        Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
        for(Loan_Application__c oldLA :oldLAList){
            if(oldLA.Repayable_Loan_Offer_Selected_Flag__c == true && (oldLA.Status__c == loanStatusDocumentation || oldLA.Status__c ==loanStatusBoardingFunding || oldLA.Status__c ==loanStatusNigo || oldLA.Status__c ==loanStatuInformationRequested || oldLA.Status__c ==loanStatusInformationSubmitted) && ( oldLA.RecordTypeId ==AcquisitionRecordTypeId || oldLA.recordTypeId == GrowthRecordTypeId || oldLA.recordTypeId ==LineofCreditRecordTypeId || oldLA.recordTypeId == RefinanceRecordTypeId) && ProfileName.Name !=System_Administrator1){
              
                SObject newLA = Trigger.newmap.get(oldLA.ID);
                for(Schema.FieldSetMember fld :SObjectType.Loan_Application__c.FieldSets.ReadOnlyFieldsCapsolUpdateLoanAppFieldSe.getFields()) {
                 if(oldLA.get(fld.getFieldPath()) != newLA.get(fld.getFieldPath())){
                        newLA.addError('Only Additional Comments can be edited once the Offer is Accepted.'); 
                       
                    }
                }
            }
        }
    }
    // CH-07 END
    }