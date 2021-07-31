/***
* CS-1124 Sprint 15 Release(Auto Create Proposal record - Backend TA Loan Application)  Updated by Madhukar Reddy on 8/04/2020
* CS-1346 & CS-1649 - Error Handling - Modified by Amol - 08/15/2020 - CH02
* CS- 1122 Sprint 15 - Submit Application Mule Data Integration - Backend TA - Modified BY Amol - 08/25/2020 - CH01
* CS-1813 Sprint 16 - Withdraw Application - Amol - 09/22/2020 - CH03
* CS-2308 Sprint 17 - Modified TA Application repayable proposal "loan category" to autofill as "Repayable"
* ##############Change History#############
* CH.No       Description                                                           Developer           Date
---------------------------------------------------------------------------------------------------------------
* CH-04       CS-2756 Sprint 21- Remove hardcoded loan application status values     Bhanu              01/21/2021
* CH06        CS-2736 - Opportunity Governance Issue Sprint 21                       Amol               01/13/2021
*/


global class LoanSubmitApplication {
    global static String snowError = '';
    public static Id RetensionLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Retention_Loan').getRecordTypeId();
    public static Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();//Bhanu CS-2308 
    public static Id BackendTARecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Backend_TA').getRecordTypeId();
    public static Id TAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
    public static Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();
    public static Id BackendTAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('Backend_Proposal').getRecordTypeId();
    public static Id RepayableProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('Repayable').getRecordTypeId(); //Bhanu CS-2308 
    public static String OfferNameForgivable = 'Forgivable Offer';
    public static String OfferNameRepayable = 'Repayable Offer';
    public static Map<String,Integer> TermLengthMap=new  Map<String,Integer>{
        '7 Years'=>7, '5 Years'=>5, '4 Years'=>4, '3 Years'=>3, '2 Years'=>2, '1 Year'=>1, '6 Years'=>6, '8 Years'=>8, '9 Years'=>9, '10 Years'=>10 
            };
                @AuraEnabled
                public static String createProposalFromAura(String loanAppId){
                    try{
                        if(loanAppId!=null){
                            
                              //Start  CH-04
                        String LoanAppstatus='';
                        LoanAppstatus=LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_1');
                        //End
                            
                            Loan_Application__c LA=wcLoanApplicationController.collectRecordDetails(loanAppId);
                            Loan_Application__c laUpdate = new Loan_Application__c();
                            laUpdate.Id=loanAppId;
                            laUpdate.Status__c = LoanAppstatus;//CH-04
                            update laUpdate;
                            return createProposalfromLoanApplication(LA);
                        }
                    }catch(Exception ex){
                        System.debug(ex);
                        System.debug(ex.getMessage());
                        System.debug(ex.getLineNumber());
                    }
                    return 'false';
                }
    
    public static String createProposalfromLoanApplication(Loan_Application__c LA){
        try{
            
            
            
            
            
            Set<Id> ProposalIdset=new Set<Id>();
            if(LA.Proposals_Offers__r.size()>0){
                deleteRelatedProposalOffer(LA.Id);
            }
            if(LA.Proposals_Offers_Placeholders__r.size()>0){
                ProposalIdset.addAll(createProposalOffers(LA.Proposals_Offers_Placeholders__r,LA));
            }
            ProposalIdset.add(createRepayableProposalOffer(LA));
            
            if(ProposalIdset.size()>0){
                List<Id> tempList=new List<Id>();
                tempList.addAll(ProposalIdset);
                cls_LPL_SendSFDatatoMulesoft.makePostCallout(LA.Id,tempList);
            }
            
            //system.debug('snowError'+snowError);
            //system.debug('snowErrorMule'+snowErrorMule);
            /*if(snowError){
snowErrorDP = snowError;
return snowErrorDP;
}else if(snowErrorMule){
snowErrorMuleSoft = snowErrorMule;
return snowErrorMuleSoft;
} else{*/
            return snowError;
            // }
            
            
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return 'false';
    }
    public static void deleteRelatedProposalOffer(String recId){
        delete [select Id from Proposal_Offer__c where LoanApp_MD__c=:recId];
    }
    public static Set<Id> createProposalOffers(List<Proposal_Offer_Placeholder__c> POPList,Loan_Application__c LA){
        Integer Count=1;
        List<Proposal_Offer__c> POList=new List<Proposal_Offer__c>();
        for(Proposal_Offer_Placeholder__c p:POPList){
            Proposal_Offer__c temp=new Proposal_Offer__c();
            temp.LoanApp_MD__c=LA.Id;
            temp.Branch__c = p.Branch__c;
            temp.Campaign__c = p.Campaign_Name__c;
            temp.Platform__c = p.Platform__c;
            temp.OSJ__c = p.OSJ_LE_Name__c;
            temp.U_W_Type__c = p.U_W_Type__c;
            temp.Name = 'Forgivable Offer '+(Count++);
            temp.Offer_Name__c = temp.Name;
            temp.Proposal_Name__c = temp.name;
            temp.RecordTypeId = TAProposalRecordTypeId;
            temp.DBA_Business_Name__c = LA.Business_Name_DBA__c;
            temp.Loan_Type__c = LA.Loan_Purpose__c;
            temp.Loan_Term__c=TermLengthMap.containsKey(p.Term_Length__c)?''+TermLengthMap.get(p.Term_Length__c):null;
            POList.add(temp);
        }
        insert POList;
        Set<Id> tempIdSet=new Set<Id>();
        for(Proposal_Offer__c p:POList){
            tempIdSet.add(p.Id);
        }
        
        //Start  CH-04
        String LoanAppstatus='';
        LoanAppstatus=LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_1');
        //End
        
        
        Loan_Application__c laUpdate = new Loan_Application__c();
        laUpdate = [Select id,status__c from Loan_Application__c where id=:LA.Id];
        if(laUpdate.Id != null){
            laUpdate.Status__c = LoanAppstatus;//CH-04
            update laUpdate;
        }
        
        
        return tempIdSet;
    }
    public static Id createRepayableProposalOffer(Loan_Application__c LA){
        Proposal_Offer__c temp=new Proposal_Offer__c();
        //Set Proposal Name dynamically based on Loan Category - Amol 10/23/2020- Start
        String offerName = LA.Loan_Category__c;
        offerName = offerName.replace('Loan','Offer');
        temp.LoanApp_MD__c=LA.Id;
        //Bhanu CS-2308 Start
        
        if(LA.RecordTypeId == ForgivableLoadRecordTypeId  )
        {
            temp.RecordTypeId = RepayableProposalRecordTypeId; 
            temp.Name = 'Repayable Offer'; 
            temp.Offer_Name__c = 'Repayable Offer'; 
            temp.Proposal_Name__c='Repayable Offer'; 
            
        }
        else
        {
            temp.RecordTypeId = GeneralProposalRecordTypeId;  
            temp.Name = offerName;
            temp.Offer_Name__c = offerName;
            temp.Proposal_Name__c = offerName;
            // Amol changes end
        }   
        //Bhanu CS-2308 ends
        temp.DBA_Business_Name__c = LA.Business_Name_DBA__c;
        temp.Loan_Type__c = LA.Loan_Purpose__c;
        insert temp;
        return temp.Id;
    }
    @AuraEnabled 
    public static List<String> checkLoanApplication(String loanAppId){
        return wcLoanApplicationController.checkLoanappliction(loanAppId);
    }
    
    @AuraEnabled
    public static string createRepayableProposalOfferAura(String loanAppId){
        deleteRelatedProposalOffer(loanAppId);
        Loan_Application__c loanAppRec = new Loan_Application__c();
        loanAppRec =  [SELECT id,Business_Name_DBA__c,Loan_Purpose__c,Application_Type__c,Loan_Category__c,RecordTypeId,SUM_NNA__c,Backend_Hurdle__c,Backend_Bps__c FROM Loan_Application__c WHERE Id = :loanAppId];
        Proposal_Offer__c temp=new Proposal_Offer__c();
        // CS-1124 Sprint 15 Release(Auto Create Proposal record - Backend TA Loan Application)  Updated by Madhukar Reddy on 8/04/2020
        if(loanAppRec.RecordTypeId == BackendTARecordTypeId){
            LoanSubmitApplication.CreateBackendTAProposalOfferClassic(loanAppId);
        }// ended CS-1124
        else {
            temp.LoanApp_MD__c=loanAppId;
            temp.Name = 'Repayable Offer';
            temp.Offer_Name__c = 'Repayable Offer';
            temp.Proposal_Name__c='Repayable Offer';
            //Bhanu CS-2308 Start
            if(loanAppRec.RecordTypeId == ForgivableLoadRecordTypeId  )
            {
                temp.RecordTypeId = RepayableProposalRecordTypeId; 
            }
            else
            {
                temp.RecordTypeId = GeneralProposalRecordTypeId;  
            } 
            //Bhanu CS-2308 ends
            temp.DBA_Business_Name__c = loanAppRec.Business_Name_DBA__c;
            temp.Loan_Type__c = loanAppRec.Loan_Purpose__c;
            insert temp;
        }
        List<Id> propIds = new List<Id>();
        List<Proposal_Offer__c> props = [select id from Proposal_Offer__c where LoanApp_MD__c =: loanAppId];
        for(Proposal_Offer__c prop:props){
            propIds.add(prop.id);
        }
        system.debug('propIds'+propIds);
        
        Loan_Application__c laUpdate = new Loan_Application__c();
        
        //Start CH-04
         String LoanAppstatus='';               
        LoanAppstatus=LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_1');
        //End
        
        
        
        laUpdate = [Select id,status__c from Loan_Application__c where id=:loanAppId];
        if(laUpdate.Id != null){
            laUpdate.Status__c = LoanAppstatus;//CH-04
            update laUpdate;
        }
        
        
        cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanAppId,propIds);
        
        return 'Congratulations! Your loan application has been successfully submitted.';
    }
    
    webService static string createRepayableProposalOfferClassic(String loanAppId){
        deleteRelatedProposalOffer(loanAppId);
        Loan_Application__c loanAppRec = new Loan_Application__c();
        loanAppRec =  [SELECT id,Business_Name_DBA__c,Loan_Purpose__c,Application_Type__c,Loan_Category__c,RecordTypeId,SUM_NNA__c,Backend_Hurdle__c,Backend_Bps__c FROM Loan_Application__c WHERE Id = :loanAppId];
        Proposal_Offer__c temp=new Proposal_Offer__c();
        // CS-1124 Sprint 15 Release(Auto Create Proposal record - Backend TA Loan Application)  Updated by Madhukar Reddy on 8/04/2020
        if(loanAppRec.RecordTypeId == BackendTARecordTypeId){
            LoanSubmitApplication.CreateBackendTAProposalOfferClassic(loanAppId);
        } //end CS-1124
        else {
            temp.LoanApp_MD__c=loanAppId;
            temp.Name = 'Repayable Offer';
            temp.Offer_Name__c = 'Repayable Offer';
            temp.Proposal_Name__c='Repayable Offer';
            //Bhanu CS-2308 Start
            if(loanAppRec.RecordTypeId == ForgivableLoadRecordTypeId  )
            {
                temp.RecordTypeId = RepayableProposalRecordTypeId; 
            }
            else
            {
                temp.RecordTypeId = GeneralProposalRecordTypeId;  
            }   
            //Bhanu CS-2308 ends
            temp.RecordTypeId = GeneralProposalRecordTypeId;
            temp.DBA_Business_Name__c = loanAppRec.Business_Name_DBA__c;
            temp.Loan_Type__c = loanAppRec.Loan_Purpose__c;
            insert temp;
        }
        
        
        List<Id> propIds = new List<Id>();
        List<Proposal_Offer__c> props = [select id from Proposal_Offer__c where LoanApp_MD__c =: loanAppId];
        for(Proposal_Offer__c prop:props){
            propIds.add(prop.id);
        }
        system.debug('propIds'+propIds);
          //Start CH-04
         String LoanAppstatus='';
        LoanAppstatus=LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_1');
        //End
        
        Loan_Application__c laUpdate = new Loan_Application__c();
        laUpdate = [Select id,status__c from Loan_Application__c where id=:loanAppId];
        if(laUpdate.Id != null){
            laUpdate.Status__c = LoanAppstatus;//CH-04
            update laUpdate;
        }
        cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanAppId,propIds);
        
        //return 'Congratulations! Your loan application has been successfully submitted.';
        return 'Success';
        
    } 
    // CS-1124 Sprint 15 Release(Auto Create Proposal record - Backend TA Loan Application)  Updated by Madhukar Reddy on 8/04/2020
    public static void CreateBackendTAProposalOfferClassic(String loanAppId){
        Loan_Application__c loanAppRec = new Loan_Application__c();
        loanAppRec =  [SELECT id,RecordTypeId,RecordType.DeveloperName,Business_Name_DBA__c,Loan_Purpose__c,Requested_Loan_Amount__c,SUM_NNA__c,Backend_Hurdle__c,Backend_Bps__c FROM Loan_Application__c WHERE Id = :loanAppId];
        
        List<Borrowers__c> borrowList=new List<Borrowers__c>();
        List<Borrowers__c> updateBorrList = new List<Borrowers__c>();
        borrowList = [Select Id,Split_of_Total_AUM__c,Backend_Split__c,AUM_Attributable__c,Contact__c,CLO_Customer_Group__c,CLO_Customer_ID__c,
                      Current_Firm_Name__c,Hire_Date__c,Master_Rep_ID__c,Repayable_Split__c,Sub_Loan_Amount__c,Sub_Loan_Split__c,VAUM__c,
                      Current_Firm_Type__c,Enterprise_Name__c,Full_Name__c,Loan_Application__c,Primary_Contact__c,Total_AUM__c,
                      Contact__r.CLO_Customer_ID__c,Contact__r.Name from Borrowers__c 
                      where Loan_Application__c =:loanAppId];
        
        //Start CH-04
        
        
                   //Start CH-04
         String ProposalStatus='';
        ProposalStatus=LoanSubmitApplication.getApplicationStatus('Proposal_Offer__c','Status_1');
        //End
        
        
        
        Proposal_Offer__c temp=new Proposal_Offer__c();
        temp.LoanApp_MD__c=id.valueof(loanAppId);
        temp.Name='Backend TA Offer';
        temp.RecordTypeId = BackendTAProposalRecordTypeId;
        temp.TA_Amount__c = loanAppRec.Requested_Loan_Amount__c;
        temp.Max_TA_Amount__c = loanAppRec.Requested_Loan_Amount__c;
        temp.SUM_NNA__c = loanAppRec.SUM_NNA__c;
        temp.Backend_Hurdle__c = loanAppRec.Backend_Hurdle__c;
        temp.Backend_Bps__c = loanAppRec.Backend_Bps__c;
        temp.Proposal_Status__c = ProposalStatus;//CH-04
        temp.Offer_Name__c = 'Backend TA Offer';
        temp.Proposal_Name__c='Backend TA Offer';
        temp.DBA_Business_Name__c = loanAppRec.Business_Name_DBA__c;
        temp.Loan_Type__c = loanAppRec.Loan_Purpose__c;
        insert temp;
        
        system.debug('temp@@@'+temp);
        system.debug('temp@@@'+temp.RecordType.DeveloperName);
        //Start CH01
        if(loanAppRec.RecordType.DeveloperName == 'Backend_TA' && temp.RecordTypeId == BackendTAProposalRecordTypeId){
            system.debug('inside if1'+borrowList);
            if(borrowList != null){
                for(Borrowers__c brow : borrowList){
                    system.debug('inside if2'+brow);
                    system.debug('inside if3'+temp.TA_Amount__c);
                    system.debug('inside if4'+brow.Backend_Split__c);
                    if(temp.TA_Amount__c !=null && brow.Backend_Split__c != null){
                        brow.Sub_Loan_Amount__c = (temp.TA_Amount__c * brow.Backend_Split__c)/100;
                        system.debug('inside if5'+brow.Sub_Loan_Amount__c);
                        updateBorrList.add(brow);
                    }                
                }
            }
        }
        system.debug('@@@@@updateBorrList'+updateBorrList);
        if(updateBorrList.size()>0){
         // CH06 Start
       // New_Opportunity_TriggerHandler.capsolexecution = true;
         // CH06 End
            update updateBorrList;
        }
        //End CH01
        
    }
    
    //Start CH02
    
    @AuraEnabled
    public static String checkExceptionLog(String loanAppId){
        return checkExceptionLogGeneral(loanAppId);
    }
    
    webService static string checkExceptionLogClassic(String loanAppId){
        return checkExceptionLogGeneral(loanAppId);
    }
    public static String checkExceptionLogGeneral(String loanAppId){
        Exception_Log__c newExceptionRecord = new Exception_Log__c();
        String uniqueId = '';
        String errorSource = '';
        Exception_Log__c newExceptionRec = new Exception_Log__c();
        try {
            
            
            newExceptionRec = [select id,Name,CreatedDate,Exception_Log_ID_Loan_App_ID__c,Loan_Application_Number__c,Error_Source__c from Exception_Log__c 
                               where Loan_Application_Number__c = :loanAppId Order By Name DESC LIMIT 1];
            
            system.debug('newExceptionRec!!!!!!'+newExceptionRec);
            
            if(newExceptionRec != null){
                //uniqueId = String.ValueOf(newExceptionRec.CreatedDate)+loanAppId;
                uniqueId = newExceptionRec.Exception_Log_ID_Loan_App_ID__c;
                system.debug('uniqueId!!!!!!'+uniqueId);
                newExceptionRecord = [select id,Name,Exception_Log_ID_Loan_App_ID__c,Loan_Application_Number__c,Error_Source__c from Exception_Log__c 
                                      where Loan_Application_Number__c = :loanAppId AND 
                                      Exception_Log_ID_Loan_App_ID__c =:uniqueId];
                
                system.debug('newExceptionRecord!!!!!!'+newExceptionRecord);
                
                if(newExceptionRecord != null){
                    if(newExceptionRecord.Error_Source__c == 'Mule Soft'){
                        system.debug('Mule');
                        errorSource =  'Mule Soft';
                        newExceptionRecord.Exception_Log_ID_Loan_App_ID__c = '';
                        update newExceptionRecord;
                        return errorSource;
                    }else if(newExceptionRecord.Error_Source__c == 'Data Power'){
                        system.debug('DP');
                        errorSource = 'Data Power';
                        newExceptionRecord.Exception_Log_ID_Loan_App_ID__c = '';
                        update newExceptionRecord;
                        return errorSource;
                    }
                }else{
                    system.debug('in else');
                    newExceptionRecord.Exception_Log_ID_Loan_App_ID__c = '';
                    update newExceptionRecord;
                    return errorSource;
                }
            }
            
            return errorSource;
        }  catch (Exception Ex) {
            return errorSource;
        }
    }
    //End CH02
    
    
    //Start CH03
    
    @AuraEnabled
    public static boolean withdrawApplication(String loanAppId){
        return withdrawApplicationGeneral(loanAppId);
    }
    
    @AuraEnabled
    public static String checkWithdrawApplication(String loanAppId){
        Loan_Application__c loanAppRec = new Loan_Application__c();
        if(loanAppId != ''){
            loanAppRec=[SELECT id,Status__c from Loan_Application__c where Id =:loanAppId];
        }
        return loanAppRec.Status__c;
    }
    
    webService static boolean withdrawApplicationClassic(String loanAppId){
        return withdrawApplicationGeneral(loanAppId);
    }
    public static boolean withdrawApplicationGeneral(String loanAppId){
        Loan_Application__c loanAppRec = new Loan_Application__c();
        List<Proposal_Offer__c> pOff = new List<Proposal_Offer__c>();
        Boolean flag = false;
        if(loanAppId != ''){
            pOff = [SELECT id,LoanApp_MD__c from Proposal_Offer__c where LoanApp_MD__c =:loanAppId];
            if(pOff.size() == 0){
                flag = false;
            }else{
                
                     
        //Start CH-04
         String LoanAppstatus='';
         LoanAppstatus=LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_2');
        //End
                
                loanAppRec =  [SELECT id,Status__c FROM Loan_Application__c WHERE Id = :loanAppId];
                loanAppRec.Status__c = LoanAppstatus;//CH-04
                update loanAppRec;
                flag = true;
            }
        }
        return flag;
    }
    
    //End CH03
    @AuraEnabled(cacheable=false)
    public static String  collectRecordName(String recId){
        Loan_Application__c loan = [select Id,Status__c,CLO_Application_ID__c from Loan_Application__c where  Id=:recId Limit 1];
        return loan.CLO_Application_ID__c;
    }
     //Start CH-04
    public static String getApplicationStatus(String objectName,String status)
    {
     String LoanAppstatus='';
        List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
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
}