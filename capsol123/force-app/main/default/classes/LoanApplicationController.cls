/***
* US 749 - Send Accepted Proposal Updates to CLO as part of Update Proposal Details Service
* for Loan Application which are already submitted to CLO
* ----------------------Updated by Amol Sprint 12 CapSol - 05/18/2020 - CH01
* 
* CS-1734 - OSJ Amount Field - Updated by Amol Sprint 14 Capsol - 07/22/2020
* CS-1340 - Proposal Status Flag - Pending OSJ Credit Approval - Updated by Amol Sprint 14 Capsol - 07/22/2020 - CH02
* CS-744 - Sub Loan Amount Calculations - Updated by  Amol 08/05/2020 - CH03
* CS-2017 - Repayable Loan Amount - Updated by Amol - 08/28/2020 - CH04
* Author - Anil Gunti
* Modified By Bhanu 8/17/2020 CS-1811 - Custom UI enhancement - Loan Split %
* Added By Bhanu  8/20/20 CS-745 Add the Backend date 1 & 2 fields in forgivable proposal section
* Added By Bhanu 8/28/2020 CS-1999 UI display - Repayable Accepted Loan Amount
* Modified By Bhanu 09/09/2020 CS-1891 Campaign field should ONLY be required when U/W Type is = Campaign
* CH-05  CS-1983 - Defect Primary Contact Bug - Sprint 16   Amol Deshpande    09/08/2020
* CS-2516 Sprint 20- Update TA application Offer Accepted Criteria
    * * CH.No       Description                                                           Developer           Date
------------------------------------------------------------------------------------------------------------------------
    *   CH06        CS-2756 Sprint 21- Remove hardcoded values                              Bhanu              01/21/2021
    *   CH07        CS-2736 - Opportunity Governance Issue Sprint 21                        Amol               01/13/2021
    *   CH08        CS-2847 Commented the TA_of_EAUM__c field which is not required         Madhukar           03/20/2021
    *   CH09        CS-2916 SF Repayable proposal acceptance enhancement                    Bhanu              03/29/2021
    *   CH10        CS-3779 OSJ/NON OSJ REP ID - UI Component                               Bhanu              05/13/2021
    *   CH11        CS-3780 Backend Calculation Dates                                       Amol               05/13/2021
    *   CH12        CS-4402 Add Campaign Offer Accepted field to Proposal Offer view        Madhukar Reddy     07/21/2021

    */



public with sharing class LoanApplicationController {
    public class ApplicationWrapper{
        @AuraEnabled public String ApplicationNumber;
        @AuraEnabled public String Status;
        @AuraEnabled public String LoanPurpose;
        @AuraEnabled public String LoanType;
        @AuraEnabled public String ApplicationType;
        @AuraEnabled public String ApprovedT12;
        @AuraEnabled public String VerifiedAssets;
        @AuraEnabled public String Expiration;
        @AuraEnabled public String Datee;
    }
    public class BusinessWrapper{
        @AuraEnabled public String BusinessLegalNameDBA;
        @AuraEnabled public Decimal Advisor;  
        @AuraEnabled public String LegalEntityType;
        @AuraEnabled public String CurrentRegistration;
        @AuraEnabled public String CurrentCustodian;
        public BusinessWrapper(){
            BusinessLegalNameDBA='';
            Advisor=null;
            LegalEntityType='';
            CurrentRegistration='';
            CurrentCustodian='';
        }
    }
    public class FinancialWrapper{
        @AuraEnabled public Decimal MutualFundsDirectlyHeld;
        @AuraEnabled public Decimal PercentMutualFundsDirectlyHeld;
        @AuraEnabled public Decimal MutualFundsCustodied;
        @AuraEnabled public Decimal PercentMutualFundsCustodied;  
        @AuraEnabled public Decimal TotalMutualFunds;
        @AuraEnabled public Decimal VA;
        @AuraEnabled public Decimal PercentVA;   
        @AuraEnabled public Decimal FA;
        @AuraEnabled public Decimal PercentFA;  
        @AuraEnabled public Decimal EQ;
        @AuraEnabled public Decimal PercentEQ; 
        @AuraEnabled public Decimal FI;
        @AuraEnabled public Decimal PercentFI;
        @AuraEnabled public Decimal AIUITCASH;
        @AuraEnabled public Decimal PercentAIUITCASH;
        @AuraEnabled public Decimal TotalBrokerageFund;
        @AuraEnabled public Decimal TotalAdvisoryAUM;
        @AuraEnabled public Decimal TotalAUM;
        @AuraEnabled public Decimal AdvisoryRevenue;
        @AuraEnabled public Decimal BrokerageRevenue;
        @AuraEnabled public Decimal TotalProduction;
        @AuraEnabled public Decimal GDC;
        public FinancialWrapper(){
            MutualFundsDirectlyHeld=0;
            PercentMutualFundsDirectlyHeld=0;
            MutualFundsCustodied=0;
            PercentMutualFundsCustodied=0;  
            TotalMutualFunds=0;
            VA=0;
            PercentVA=0;   
            FA=0;
            PercentFA=0;  
            EQ=0;
            PercentEQ=0; 
            FI=0;
            PercentFI=0;
            AIUITCASH=0;
            PercentAIUITCASH=0;
            TotalBrokerageFund=0;
            TotalAdvisoryAUM=0;
            TotalAUM=0;
            AdvisoryRevenue=0;
            BrokerageRevenue=0;
            TotalProduction=0;
            GDC=0;
        }
    }
    
    public class BorrowerInfoSaveClass{
        @AuraEnabled public String ContactId;
        @AuraEnabled public Decimal pAUM;
        
        @AuraEnabled public boolean primary ;
        @AuraEnabled public String Uname;
        @AuraEnabled public String recId;
        @AuraEnabled public String AUMATT;
        @AuraEnabled public String BName;
        //CS-1811-Bhanu Start
        @AuraEnabled public Decimal repayableSplit;
        @AuraEnabled public Decimal loanSplit;
        @AuraEnabled public Decimal backendSplit;
        //End
        
        public BorrowerInfoSaveClass(){
            ContactId='';
            pAUM=0;
            primary=false;
            Uname=null;
            recId=null;
            AUMATT='';
            BName=null;
            //CS-1811-Bhanu Start
            repayableSplit=0;
            loanSplit=0;
            backendSplit=0;
            //End
        }
    }
    public class BorrowerInfoClass{
        @AuraEnabled public String ContactId;
        @AuraEnabled public Decimal pAUM;
        @AuraEnabled public boolean primary;
        @AuraEnabled public String Uname;
        @AuraEnabled public Object Contact;
        @AuraEnabled public String recId;
        @AuraEnabled public String AUMATT;
        @AuraEnabled public String BName;
        //CS-1811-Bhanu Start
        @AuraEnabled public Decimal repayableSplit;
        @AuraEnabled public Decimal loanSplit;
        @AuraEnabled public Decimal backendSplit;
        //End
        
        public BorrowerInfoClass(){
            ContactId='';
            pAUM=0;
            primary=false;
            Uname=null;
            Contact=null;
            recId=null;
            AUMATT='';
            BName=null;
            //CS-1811-Bhanu Start
            repayableSplit=0;
            loanSplit=0;
            backendSplit=0;
            //End
        }
        
    }
    public class BorrowerWrapper{
        @AuraEnabled public Id BContactId;
        @AuraEnabled public Decimal PercentSplitSumAUM;
        @AuraEnabled public String BorrowerName;
        @AuraEnabled public Decimal AUMAttributable;
        @AuraEnabled public String  CurrentFirmName;
        @AuraEnabled public String  CurrentFirmType;
        @AuraEnabled public Boolean PrimaryContact;
        @AuraEnabled public String BName;
        //CS-1811-Bhanu Start
        @AuraEnabled public Decimal RepayableSplit;
        @AuraEnabled public Decimal LoanSplit;
        @AuraEnabled public Decimal BackendSplit;
        //End
        
        
        
        public BorrowerWrapper(){
            BContactId=null;
            PercentSplitSumAUM=0;
            BorrowerName='';
            AUMAttributable=0;
            CurrentFirmName='';
            CurrentFirmType='';
            PrimaryContact=false;
            BName=null;
            //CS-1811-Bhanu Start
            RepayableSplit=0;
            LoanSplit=0;
            BackendSplit=0;
            //End
        }
    }
    //Modified By Bhanu 9/9/2020 changes Start  1891
    public class ProposalWrapper{
        @AuraEnabled public Proposal_Offer_Placeholder__c POP;
        @AuraEnabled public String OfferName;
        @AuraEnabled public String Platform;
        @AuraEnabled public String Branch;
        @AuraEnabled public String OSJLEName;
        @AuraEnabled public String TermLength;
        @AuraEnabled public String UWType; 
        @AuraEnabled public boolean DisableCampaignName;        
        @AuraEnabled public String CampaignName;
        @AuraEnabled public String slno;
        ProposalWrapper(){
            POP=null;
            OfferName='';
            Platform='';
            Branch='';
            OSJLEName='';
            TermLength='';
            UWType='';
            CampaignName='';
            slno='';
            DisableCampaignName=true;
        }
    }
    //Changes ends
    public Class SystemDetailWrapper{
        @AuraEnabled public String RecordTypeName;
        @AuraEnabled public String RecordTypeId;
        @AuraEnabled public String CreatedName;
        @AuraEnabled public String CreatedId;
        @AuraEnabled public String LastModifiedName;
        @AuraEnabled public String LastModifiedId;
        @AuraEnabled public Datetime CreatedDate;
        @AuraEnabled public Datetime LastModifiedDate;
        @AuraEnabled public String Created_Link;
        @AuraEnabled public String LastModified_Link;
    }
    
    public Class CLOWrapper{
        @AuraEnabled public String CLO_ApplicationId;
        @AuraEnabled public String CLO_CustomerGroup;
        public CLOWrapper(){
            CLO_ApplicationId='';
            CLO_CustomerGroup='';
        }
    }
    public class AdditoinalContactWrapper{
        @AuraEnabled public String AssignedRecruiterId;
        @AuraEnabled public String AssignedRecruiter_Link;
        @AuraEnabled public String AssignedRecruiterName;
        @AuraEnabled public String InternalRecruiterId;
        @AuraEnabled public String InternalRecruiter_Link;
        @AuraEnabled public String InternalRecruiterName;
        @AuraEnabled public String BusinessConsultantId;
        @AuraEnabled public String BusinessConsultant_Link;
        @AuraEnabled public String BusinessConsultantName;
        @AuraEnabled public String PreparerName;
        @AuraEnabled public String ServicerName;
    }
    
    public class LoanCompWrapper{
        @AuraEnabled public ApplicationWrapper AW;
        @AuraEnabled public BusinessWrapper BSW;
        @AuraEnabled public  FinancialWrapper FW;
        @AuraEnabled public BorrowerWrapper BW;
        @AuraEnabled public List<ProposalWrapper> PW;
        @AuraEnabled public Loan_Application__c loan;
        @AuraEnabled public List<BorrowerInfoClass> BorrowerInfo;
        @AuraEnabled public SystemDetailWrapper SDW;
        @AuraEnabled public CLOWrapper CLO;
        @AuraEnabled public AdditoinalContactWrapper ACW;
        @AuraEnabled public String AdditionalComment;
        @AuraEnabled public Id RecordId;
        
        public LoanCompWrapper(){
            AW=new ApplicationWrapper();
            BSW=new  BusinessWrapper();
            FW=new FinancialWrapper();
            BW=new BorrowerWrapper();
            PW=new List<ProposalWrapper>();
            SDW=new SystemDetailWrapper();
            CLO=new CLOWrapper();
            BorrowerInfo=new List<BorrowerInfoClass>();
            ACW=new AdditoinalContactWrapper();
            AdditionalComment='';
            loan=null;
            RecordId=null;
        }
    }
    @TestVisible private static BusinessWrapper populateBusinessWrapper(Loan_Application__c rec){
        BusinessWrapper temp=new BusinessWrapper();
        temp.Advisor=rec.Number_of_Advisors__c!=null?rec.Number_of_Advisors__c:null;
        temp.BusinessLegalNameDBA=rec.Business_Name_DBA__c!=null?rec.Business_Name_DBA__c:'';
        temp.CurrentCustodian=rec.CurrentCustodian__c!=null?rec.CurrentCustodian__c:'';
        temp.CurrentRegistration=rec.Current_Registration__c!=null?rec.Current_Registration__c:'';
        temp.LegalEntityType=rec.Legal_Entity__c!=null?rec.Legal_Entity__c:'';
        return temp;
    }
    @TestVisible private static FinancialWrapper populateFinancialWrapper(Loan_Application__c rec){
        FinancialWrapper temp=new FinancialWrapper();
        temp.MutualFundsDirectlyHeld=rec.Direct_Mutual_Funds__c!=null?rec.Direct_Mutual_Funds__c:0;
        temp.PercentMutualFundsDirectlyHeld=rec.Percentage_of_Mutual_Funds_Held_Direct__c!=null?rec.Percentage_of_Mutual_Funds_Held_Direct__c:0;
        temp.MutualFundsCustodied=rec.Mutual_Funds_Custodied__c!=null?rec.Mutual_Funds_Custodied__c:0;
        temp.PercentMutualFundsCustodied=rec.Percentage_of_Mutual_Funds_Held_Custodie__c!=null?rec.Percentage_of_Mutual_Funds_Held_Custodie__c:0;  
        temp.TotalMutualFunds=rec.AUM_Total_Mutual_Funds__c!=null?rec.AUM_Total_Mutual_Funds__c:0;
        temp.VA=rec.AUM_Variable_Annuities__c!=null?rec.AUM_Variable_Annuities__c:0;
        temp.PercentVA=rec.Percentage_of_Variable_Annuities__c!=null?rec.Percentage_of_Variable_Annuities__c:0;   
        temp.FA=rec.AUM_Fixed_Annuities__c!=null?rec.AUM_Fixed_Annuities__c:0;
        temp.PercentFA=rec.Percentage_of_Fixed_Annuities__c!=null?rec.Percentage_of_Fixed_Annuities__c:0;  
        temp.EQ=rec.AUM_Equity__c!=null?rec.AUM_Equity__c:0;
        temp.PercentEQ=rec.Percentage_of_Equity__c!=null?rec.Percentage_of_Equity__c:0; 
        temp.FI=rec.AUM_Fixed_Income__c!=null?rec.AUM_Fixed_Income__c:0;
        temp.PercentFI=rec.Percentage_of_Fixed_Income__c!=null?rec.Percentage_of_Fixed_Income__c:0;
        temp.AIUITCASH=rec.AUM_AI_UIT_Cash__c!=null?rec.AUM_AI_UIT_Cash__c:0;
        temp.PercentAIUITCASH=rec.Percentage_of_AI_UIT_Cash__c!=null?rec.Percentage_of_AI_UIT_Cash__c:0;
        temp.TotalBrokerageFund=rec.Total_Brokerage_AUM__c!=null?rec.Total_Brokerage_AUM__c:0;
        temp.TotalAdvisoryAUM=rec.Total_Advisory_AUM__c!=null?rec.Total_Advisory_AUM__c:0;
        temp.TotalAUM=rec.Total_AUM__c!=null?rec.Total_AUM__c:0;
        temp.AdvisoryRevenue=rec.Advisory_Revenue_c__c!=null?rec.Advisory_Revenue_c__c:0;
        temp.BrokerageRevenue=rec.Brokerage_Revenue__c!=null?rec.Brokerage_Revenue__c:0;
        temp.TotalProduction=rec.Total_Production__c!=null?rec.Total_Production__c:0;
        temp.GDC=rec.Percentage_GDC_ROA__c!=null?rec.Percentage_GDC_ROA__c:0;
        return temp;
    }
    @TestVisible private static CLOWrapper populateCLOWrapper(Loan_Application__c rec){
        CLOWrapper temp=new CLOWrapper();
        temp.CLO_ApplicationId=rec.CLO_Application_ID__c!=null?rec.CLO_Application_ID__c:'';
        temp.CLO_CustomerGroup=rec.CLO_Customer_Group_ID__c!=null?rec.CLO_Customer_Group_ID__c:'';
        return temp;
    }
    @TestVisible private static SystemDetailWrapper populateSystemDetailWrapper(Loan_Application__c rec){
        SystemDetailWrapper temp=new SystemDetailWrapper();
        temp.CreatedDate=rec.createdDate;
        temp.CreatedId=rec.createdById;
        temp.Created_Link='/'+rec.createdById;
        temp.CreatedName=rec.CreatedBy.Name;
        temp.LastModifiedDate=rec.LastModifiedDate;
        temp.LastModifiedId=rec.LastModifiedById;
        temp.LastModified_Link='/'+rec.LastModifiedById;
        temp.LastModifiedName=rec.LastModifiedBy.Name;
        temp.RecordTypeId=rec.RecordtypeId;
        temp.RecordTypeName=rec.Recordtype.Name;
        return temp;
        
    }
    @TestVisible private static BorrowerWrapper populateBorrowerWrapper(Loan_Application__c rec){
        BorrowerWrapper temp=new BorrowerWrapper();
        //Start CH-05
        temp.BContactId=rec.Primary_Contact_Name__c!=null?(String)rec.Primary_Contact_Name__c:null;
        temp.BorrowerName=rec.Primary_Contact_Name__c!=null?rec.Primary_Contact_Name__r.Name:'';
        //temp.PrimaryContact=rec.Primary_Contact__c!=null?rec.Primary_Contact__c:false;
        //End CH-05
        temp.CurrentFirmName=rec.Current_Firm_Name__c!=null?rec.Current_Firm_Name__c:'';
        temp.CurrentFirmType=rec.Current_Firm_Type__c!=null?rec.Current_Firm_Type__c:'';
        temp.PercentSplitSumAUM=rec.Percentage_Split_of_Total_AUM__c!=null?rec.Percentage_Split_of_Total_AUM__c:0;
        
        temp.AUMAttributable=rec.AUM_Attributable__c!=null?rec.AUM_Attributable__c:0;
        
        
        return  temp;
        
    }
    @TestVisible private static List<ProposalWrapper> populateProposalWrapper(Loan_Application__c rec){
        List<ProposalWrapper> tempList=new List<ProposalWrapper>();
        if(rec.Proposals_Offers_Placeholders__r.size()>0){
            for(Proposal_Offer_Placeholder__c pp:rec.Proposals_Offers_Placeholders__r){
                ProposalWrapper temp=new ProposalWrapper();
                temp.OSJLEName=pp.OSJ_LE_Name__c!=null?pp.OSJ_LE_Name__c:'';
                temp.Platform=pp.Platform__c!=null?pp.Platform__c:'';
                temp.POP=pp;
                temp.TermLength=pp.Term_Length__c!=null?pp.Term_Length__c:'';
                temp.UWType=pp.U_W_Type__c!=null?pp.U_W_Type__c:'';
                temp.OfferName=pp.Name!=null?pp.Name:'';
                temp.CampaignName=pp.Campaign_Name__c!=null?pp.Campaign_Name__c:'';
                temp.Branch=pp.Branch__c!=null?pp.Branch__c:'';
                //Modified By Bhanu 9/9/2020 changes Start  1891
                temp.DisableCampaignName=temp.UWType =='Campaign'?false:true;
                //Changes ends 
                tempList.add(temp);
            }
        }
        return tempList;
    }
    @TestVisible private static AdditoinalContactWrapper populateAdditoinalContactWrapper(Loan_Application__c rec){
        AdditoinalContactWrapper temp=new AdditoinalContactWrapper();
        temp.AssignedRecruiterId=rec.Assigned_Recruiter__c!=null?(String)rec.Assigned_Recruiter__c:'';
        temp.AssignedRecruiter_Link=temp.AssignedRecruiterId!=''?'/'+temp.AssignedRecruiterId:'';
        temp.AssignedRecruiterName=rec.Assigned_Recruiter__c!=null?(String)rec.Assigned_Recruiter__r.Name:'';
        temp.BusinessConsultantId=rec.Business_Developer__c!=null?(String)rec.Business_Developer__c:'';
        temp.BusinessConsultant_Link=temp.BusinessConsultantId!=''?'/'+temp.BusinessConsultantId:'';
        temp.BusinessConsultantName=rec.Business_Developer__c!=null?rec.Business_Developer__r.Name:'';
        temp.InternalRecruiterId=rec.Internal_Recruiter__c!=null?(String)rec.Internal_Recruiter__c:'';
        temp.InternalRecruiter_Link=temp.InternalRecruiterId!=''?'/'+temp.InternalRecruiterId:'';
        temp.InternalRecruiterName=rec.Internal_Recruiter__c!=null?rec.Internal_Recruiter__r.Name:'';
        temp.PreparerName=rec.Preparer_Name__c!=null?rec.Preparer_Name__c:'';
        temp.ServicerName=rec.Servicer_Name__c!=null?rec.Servicer_Name__c:'';
        return temp;
    }
    @TestVisible private static ApplicationWrapper populateApplicationWrapper(Loan_Application__c rec){
        ApplicationWrapper temp=new ApplicationWrapper();
        temp.ApplicationNumber=rec.Name;
        temp.ApplicationType=rec.Application_Type__c!=null?rec.Application_Type__c:'';
        temp.LoanType=rec.Loan_Category__c!=null?rec.Loan_Category__c:'';
        temp.LoanPurpose=rec.Loan_Purpose__c!=null?rec.Loan_Purpose__c:'';
        temp.Status=rec.Status__c!=null?rec.Status__c:'';
        temp.Datee='';
        temp.VerifiedAssets='';
        temp.Expiration='';
        temp.ApprovedT12='';
        return temp;
    }
    @AuraEnabled
    public static LoanCompWrapper collectRecordDetail1(String recId){
        try{
            Loan_Application__c loan=collectRecordDetails(recId);
            if(loan!=null){
                LoanCompWrapper LCW=new LoanCompWrapper();
                LCW.AW=populateApplicationWrapper(loan);
                LCW.BSW=populateBusinessWrapper(loan);
                LCW.FW=populateFinancialWrapper(loan);
                LCW.CLO=populateCLOWrapper(loan);
                LCW.SDW=populateSystemDetailWrapper(loan);
                //LCW.BW=populateBorrowerWrapper(loan);
                LCW.BorrowerInfo=populateBorrowerInfo(loan);
                LCW.PW=populateProposalWrapper(loan);
                LCW.ACW=populateAdditoinalContactWrapper(loan);
                LCW.AdditionalComment=loan.Additional_Comments__c==null?'':loan.Additional_Comments__c;
                LCW.loan=loan;
                LCW.RecordId=loan.Id;
                return LCW;
            }
        }Catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            
        }
        return new LoanCompWrapper();
    }
    public Class AdditonalContactClass{
        @AuraEnabled public String AssignedId;
        @AuraEnabled public String InternalId;
        @AuraEnabled public String BusinessId;
        @AuraEnabled public String PreparerName;
        @AuraEnabled public String ServicerName;
    }
    
    
    public class LoanSaveResult{
        @AuraEnabled public String BusinessName;
        @AuraEnabled public Decimal Advisor;
        @AuraEnabled public String EntityType;
        @AuraEnabled public String Registration;
        @AuraEnabled public String CurrentCustodian;
        @AuraEnabled public String AdditionalComment;
        @AuraEnabled public List<ProposalWrapper> ProposalDATA;
        @AuraEnabled public List<BorrowerInfoSaveClass> BorrowerInfo;
        @AuraEnabled public String RecordId;
        @AuraEnabled public BWResult BWDATA;
        @AuraEnabled public FDATACLASS FDATA;
        @AuraEnabled public AdditonalContactClass ACWDATA;
    }
    public Class BWResult{
        @AuraEnabled public String BorowwerId;
        @AuraEnabled public  Decimal SplitPercent;
    }
    public Class FDATACLASS{
        @AuraEnabled public Decimal mfdh;
        @AuraEnabled public Decimal mfc;
        @AuraEnabled public Decimal totMFC;
        @AuraEnabled public Decimal va;
        @AuraEnabled public Decimal fa;
        @AuraEnabled public Decimal fi;
        @AuraEnabled public Decimal eq;
        @AuraEnabled public Decimal aiuitCash;
        @AuraEnabled public Decimal broRev;
        @AuraEnabled public Decimal advRev;
        @AuraEnabled public Decimal totAdvAum;
    }
    
    @AuraEnabled 
    public static boolean saveLoanRecord(String lData){
        try{
            LoanSaveResult LPS=(LoanSaveResult)JSON.deserialize(lData, LoanSaveResult.class);
            system.debug('LPS'+LPS);
            Loan_Application__c ll=new Loan_Application__c();
            Contact con = new Contact();
            ll.Id=LPS.RecordId;
            ll.Number_of_Advisors__c=LPS.Advisor;
            ll.Business_Name_DBA__c=LPS.BusinessName ;
            ll.CurrentCustodian__c=LPS.CurrentCustodian;
            ll.Current_Registration__c=LPS.Registration;
            ll.Legal_Entity__c=LPS.EntityType;
            ll.Additional_Comments__c=LPS.AdditionalComment;
            
            /* if(LPS.BWDATA.BorowwerId!=null && LPS.BWDATA.BorowwerId!='' ){
ll.Advisor__c=LPS.BWDATA.BorowwerId;
}*/
            
            //ll.Percentage_Split_of_Total_AUM__c=LPS.BWDATA.SplitPercent;
            SYstem.debug(LPS.FDATA);
            ll.Direct_Mutual_Funds__c=LPS.FDATA.mfdh!=null?LPS.FDATA.mfdh:0;
            ll.Mutual_Funds_Custodied__c=LPS.FDATA.mfc!=null?LPS.FDATA.mfc:0;
            
            ll.AUM_Variable_Annuities__c=LPS.FDATA.va!=null?LPS.FDATA.va:0;
            ll.AUM_Fixed_Annuities__c=LPS.FDATA.fa!=null?LPS.FDATA.fa:0;
            ll.AUM_Equity__c=LPS.FDATA.eq!=null?LPS.FDATA.eq:0;
            ll.AUM_Fixed_Income__c=LPS.FDATA.fi!=null?LPS.FDATA.fi:0;
            ll.AUM_AI_UIT_Cash__c=LPS.FDATA.aiuitCash!=null?LPS.FDATA.aiuitCash:0;
            ll.Brokerage_Revenue__c=LPS.FDATA.broRev!=null?LPS.FDATA.broRev:0;
            ll.Advisory_Revenue_c__c=LPS.FDATA.advRev!=null?LPS.FDATA.advRev:0;
            ll.Total_Advisory_AUM__c=LPS.FDATA.totAdvAum!=null?LPS.FDATA.totAdvAum:0;
            
            /* System.debug(LPS.ACWDATA);
if(LPS.ACWDATA.AssignedId!=null){
ll.Assigned_Recruiter__c=LPS.ACWDATA.AssignedId;
}else{
ll.Assigned_Recruiter__c=null;
}
if(LPS.ACWDATA.BusinessId!=null){
ll.Business_Developer__c=LPS.ACWDATA.BusinessId;    
}else{
ll.Business_Developer__c=null;
}
if(LPS.ACWDATA.InternalId!=null){
ll.Internal_Recruiter__c=LPS.ACWDATA.InternalId;
}else{
ll.Internal_Recruiter__c=null;
}
//ll.Preparer_Name__c=LPS.ACWDATA.PreparerName!=null?LPS.ACWDATA.PreparerName:null;
// ll.Servicer_Name__c=LPS.ACWDATA.ServicerName!=null?LPS.ACWDATA.ServicerName:null;
/*opportunity  oppr;
try{
Loan_Application__c llz=[select ID,Opportunity__c from Loan_Application__c where Id=:LPS.RecordId and Opportunity__c!=null limit 1];
oppr=new Opportunity(Id=llz.Opportunity__c);
}catch(Exception exx){
oppr=null;
}


if(oppr!=null){
Opportunity opp=new Opportunity();
opp.Id=oppr.Id;
if(LPS.ACWDATA.AssignedId!=null){
opp.Assigned_Recruiter__c=LPS.ACWDATA.AssignedId;
}
if(LPS.ACWDATA.BusinessId!=null){
opp.Regional_VP__c=LPS.ACWDATA.BusinessId;    
}
if(LPS.ACWDATA.InternalId!=null){
opp.Internal_Recruiter_IRD__c=LPS.ACWDATA.InternalId;
}

update opp;
} */
            update ll;
            if(ll.Id != null){
                if(LPS.BorrowerInfo.size()>0){
                    createBorrowerRecords(LPS.BorrowerInfo,ll.Id,ll.Business_Name_DBA__c==null?null:ll.Business_Name_DBA__c,ll.Legal_Entity__c==null?null:ll.Legal_Entity__c);
                }
                else{
                    deleteBorrowersRecord(ll.Id);
                    
                }
                //Start CH-05
                if(ll.Primary_Contact_Name__c != null){
                    con = [select id,Legal_Entity__c,LPLCRM__U_S_Citizenship__c,Citizenship_Status__c from Contact where id =:ll.Primary_Contact_Name__c];
                    if(ll.Legal_Entity__c != null){
                        con.Legal_Entity__c = ll.Legal_Entity__c;
                    }
                    if(con.LPLCRM__U_S_Citizenship__c == true){
                       con.Citizenship_Status__c = LoanSubmitApplication.getApplicationStatus('Contact','Status_3');  //Start CH06
                    }else{
                        con.Citizenship_Status__c = LoanSubmitApplication.getApplicationStatus('Contact','Status_4');  //Start CH06
                    }
                    update con;
                }
                //End CH-05
            }
            
            List<Proposal_Offer_Placeholder__c> pOH=new List<Proposal_Offer_Placeholder__c>();
            System.debug(LPS.ProposalDATA);
            for(ProposalWrapper p:LPS.ProposalDATA){
                Proposal_Offer_Placeholder__c temp=new Proposal_Offer_Placeholder__c();
                if(p.POP!=null){
                    temp.Id=p.POP.Id;
                }else{
                    temp.Loan_Application__c =LPS.recordId;
                }
                temp.Platform__c=p.Platform;
                temp.OSJ_LE_Name__c=p.OSJLEName;
                temp.Term_Length__c=p.TermLength;
                temp.U_W_Type__c=p.UWType;
                temp.Campaign_Name__c=p.CampaignName;
                temp.Branch__c=p.Branch;
                System.debug(temp);
                pOH.add(temp);
            }
            if(pOH.size()>0){
                upsert pOH;
                set<Id> aa=new Set<Id>();
                for(Proposal_Offer_Placeholder__c z:pOH){
                    aa.add(z.Id);
                }
                if(aa.size()>0){
                    List<Proposal_Offer_Placeholder__c> aaList=new List<Proposal_Offer_Placeholder__c>();
                    for(Proposal_Offer_Placeholder__c t:[select id from Proposal_Offer_Placeholder__c where Loan_Application__c=:LPS.Recordid AND id not in :aa]){
                        aaList.add(t);
                    }
                    if(aaList.size()>0){
                        delete aaList;
                    }
                }
            }
            if(LPS.ProposalDATA.size()==0){
                List<Proposal_Offer_Placeholder__c> aaList=new List<Proposal_Offer_Placeholder__c>();
                for(Proposal_Offer_Placeholder__c t:[select id from Proposal_Offer_Placeholder__c where Loan_Application__c=:LPS.Recordid ]){
                    aaList.add(t);
                }
                if(aaList.size()>0){
                    delete aaList;
                }
            }
            
        }catch(Exception ex ){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
            //return false;
        }
        return true;
        
        
        
        
        
    }
    
    @TestVisible private static void deleteBorrowersRecord(Id LoanId){
        List<Borrowers__c> DLIst=new  List<Borrowers__c>();
        try{
            DLIst=[select Id from Borrowers__c where Loan_Application__c=:LoanId ];
            delete DLIst;
        }catch(Exception ex1){
            System.debug(ex1);
            System.debug(ex1.getMessage());
            System.debug(ex1.getLineNumber());
            
        }
    }
    @AuraEnabled(cacheable=true)
    public static Loan_Application__c  collectRecordName(String recId){
        return [select Id,Name,Recordtype.Name,Status__c,CLO_Application_ID__c, (select id from Proposals_Offers__r limit 1)  from Loan_Application__c where  Id=:recId Limit 1];
    }
    
    
    
    @AuraEnabled
    public static LoanWrapper collectRecordDetail(String recId){
        try{
            System.debug(recId);
            Loan_Application__c loan=collectRecordDetails(recId);
            
            if(loan!=null){
                LoanWrapper LW=new LoanWrapper();
                LW.zz=collectRecordDetail1(recId);
                return LW;
            }
            return null;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return null;
    }
    public Class LoanWrapper{
        @AuraEnabled public LoanCompWrapper zz;
        public LoanWrapper(){
            zz=new LoanCompWrapper();
        }
        
        
    }
    public static List<BorrowerInfoClass> populateBorrowerInfo(Loan_Application__c rec){
        try{
            List<BorrowerInfoClass> temp=new  List<BorrowerInfoClass>();
            for(Borrowers__c tmp:rec.Borrowers__r){
                BorrowerInfoClass iTemp=new BorrowerInfoClass();
                iTemp.ContactId=tmp.Contact__c!=null?tmp.Contact__c:null;
                iTemp.pAUM=tmp.Split_of_Total_AUM__c!=null?tmp.Split_of_Total_AUM__c:0;
                iTemp.primary=tmp.Primary_Contact__c;
                iTemp.Uname=tmp.Id;
                iTemp.Contact=tmp.Contact__c!=null?tmp.Contact__r:null;
                iTemp.recId=tmp.Id;
                itemp.AUMATT=tmp.AUM_Attributable__c!=null?String.valueof(tmp.AUM_Attributable__c):'0';
                
                //CS-1811-Bhanu Start
                iTemp.repayableSplit=tmp.Repayable_Split__c!=null?tmp.Repayable_Split__c:0;
                iTemp.loanSplit=tmp.Sub_Loan_Split__c!=null?tmp.Sub_Loan_Split__c:0;
                iTemp.backendSplit=tmp.Backend_Split__c!=null?tmp.Backend_Split__c:0;
                //Ends
                
                temp.add(iTemp);
            }
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return  new  List<BorrowerInfoClass>();
    }
    
    @TestVisible private static void createBorrowerRecords(List<BorrowerInfoSaveClass> Bdata,Id LoanId,String BusinessDBAName,String LegalEntity){
        System.debug('HELLO');
        // CH07 Start
        New_Opportunity_TriggerHandler.capsolexecution = true;
        // CH07 End
        List<Borrowers__c> BList=new List<Borrowers__c>();
        for(BorrowerInfoSaveClass b:Bdata){
            if(b.ContactId!=null){
                Borrowers__c temp=new Borrowers__c();
                temp.Contact__c=b.ContactId;
                temp.Name=b.BName;
                temp.Primary_Contact__c=b.primary;
                temp.Split_of_Total_AUM__c=b.pAUM;
                //CS-1811-Bhanu Start
                temp.Backend_Split__c=b.backendSplit;
                temp.Sub_Loan_Split__c=b.loanSplit;
                temp.Repayable_Split__c=b.repayableSplit;
                
                //End
                
                temp.Loan_Application__c=LoanId;
                temp.CLO_Customer_Group_Name__c =BusinessDBAName;
                if(b.AUMATT != null && b.AUMATT != ''){
                    temp.AUM_Attributable__c = Decimal.valueof(b.AUMATT);
                }else{
                    temp.AUM_Attributable__c = 0;
                }
                
                if(b.recId!=null){
                    temp.Id=b.recId;
                }
                BList.add(temp);
                system.debug('---------------111111---'+BList);
            }
        }
        if(BList.size()>0){
            upsert BList;
            Set<Id> BSet=new Set<Id>();
            for(Borrowers__c t:BList){
                BSet.add(t.Id);
            }
            updateCLODetails(BSet);
            List<Borrowers__c> DLIst=new  List<Borrowers__c>();
            try{
                DLIst=[select Id from Borrowers__c where Loan_Application__c=:LoanId and Id not in :BSet ];
            }catch(Exception ex1){
                System.debug(ex1);
                System.debug(ex1.getMessage());
                System.debug(ex1.getLineNumber());
                
            }
            if(DLIst.size()>0)
                delete DLIst;
            System.debug(BList);
        }else{
            deleteallBorrowers(LoanId);
        }
    }
    private static  void deleteallBorrowers(Id LoanId){
        List<Borrowers__c> DLIst=new  List<Borrowers__c>();
        try{
            DLIst=[select Id from Borrowers__c where Loan_Application__c=:LoanId  ];
            if(DLIst.size()>0){
                delete Dlist;
                Loan_Application__c LA = new Loan_Application__c();
                LA.Id=LoanId;
                //LA.Advisor__c=null;
                LA.Primary_Contact_Name__c=null;
                
                //LA.Business_Consultant_RM__c=null;
                //LA.Total_Advisory_AUM__c=0;
                update LA;
            }
        }catch(Exception ex1){
            System.debug(ex1);
            System.debug(ex1.getMessage());
            System.debug(ex1.getLineNumber());
            
            throw new AuraHandledException(ex1.getMessage());
        }
    }
    
    @AuraEnabled
    public static Loan_Application__c  collectRecordDetails(String recId){
        return [SELECT Business_Developer__r.Name,(select Id,Name,Campaign_Name__c,Branch__c,U_W_Type__c,Term_Length__c,Platform__c,OSJ_LE_Name__c from Proposals_Offers_Placeholders__r), 
                (SELECT Id, Name, Offer_Name__c, Platform__c, Branch__c, OSJ__c, Loan_Term__c, Interest_Rate__c, Campaign__c, Verified_AUM__c, Approved_T12__c, Date__c, Expiration__c FROM Proposals_Offers__r) ,Id, OwnerId, Name, RecordTypeId, RecordType.Name, Internal_Recruiter__r.Name,Assigned_Recruiter__r.Name,Business_Consultant_RM__r.Name,
                CreatedDate, CreatedById, CreatedBy.Name, SystemModstamp, LastModifiedById, LastModifiedBy.Name,
                LastModifiedDate, CLO_Application_ID__c, CLO_Customer_Group_ID__c, Status__c, Contact_Recruiter__c, 
                Number_of_Advisors__c, Platform__c, Application_Type__c, Loan_Purpose__c, Requested_Loan_Amount__c, 
                Requested_Loan_Term__c, Direct_Mutual_Funds__c, Mutual_Funds_Custodied__c, AUM_Variable_Annuities__c, 
                AUM_Fixed_Annuities__c, AUM_Equity__c, AUM_Fixed_Income__c, AUM_AI_UIT_Cash__c, AUM_Cash__c, Total_Fee_Based_AUM__c, 
                Additional_Comments__c, Scenario__c, Previous_LPL_Advisor__c, Asset_Status__c, Preparer_Name__c, Preparer_Email__c, 
                Servicer_Name__c, Servicer_Email__c, Underwritting_Type__c, Campaign_Name__c, Primary_Contact__c, Current_Registration__c, 
                Level_Payout_Request__c, Request_for_Fee_Reduction__c, Loan_Category__c, Contact_Master_Rep_Id__c, Branch__c, Total_Gross_Revenue__c, 
                Legal_Entity__c, Total_Annual_Business_Expenditures__c, Estimated_Officers_Compensation__c, Ownership_of_Business__c, 
                Total_Annual_Personal_Expenditures__c, Total_Annual_Net_Income__c, Estimated_Credit_Score__c, Total_Purchase_Price__c, 
                Estimated_Down_Payment__c, Annual_Acquisition_Revenue__c, Annual_Acquisition_Operating_Expense__c, Anticipated_Change_in_Annual_Operating__c, 
                Will_You_Assume_Seller_Debt__c, LPL_loan_or_an_external_loan__c, Seller_Note_Amount__c, Seller_Note_Term__c, Seller_Note_Rate__c, 
                Is_Seller_Staying_on_receiving_salary__c, Succession_plan__c, AUM_Total_Mutual_Funds__c, Opportunity__c, Primary_Contact_Name__c, 
                Prior_Firm_Name__c, Prior_Firm_Type__c, Total_Transactional_Brokerage_AUM__c, Total_Brokerage_AUM__c, Percentage_of_Mutual_Funds_Held_Direct__c, 
                Record_Type__c, Internal_Recruiter__c, CurrentCustodian__c, Internal_Recruiter_Email__c, Business_Developer__c, Business_Consultant_RM__c, 
                Business_Developer_Email__c, Business_Consultant_RM_Email__c, OSJ_Manager_Name__c, OSJ_Manager__c, Business_Name_DBA__c, Debt_Service_Coverage__c, 
                Seller_s_Name__c, Seller_Note_Remaining_Term_Monthly__c, Interest_Rate__c, Created_By_Email__c, Requested_Funding_Date__c, OSJ_LE_Branch__c, contactlookup__c, 
                Modified_R_Type__c, Last_Status_Modified_Date__c, 
                // Start CH-05
                //Advisor__c, 
                //End CH-05
                Offer_Terms__c, Term_Length__c, U_W_Type__c, Number_of_LPL_Loans_Outstanding__c, 
                Total_Advisory_AUM__c, Total_AUM__c, Advisory_Revenue_c__c, Brokerage_Revenue__c, Total_Production__c, Percentage_of_Mutual_Funds_Held_Custodie__c, 
                Percentage_of_Total_Mutual_Funds__c, Percentage_of_Variable_Annuities__c, Percentage_of_Fixed_Annuities__c, Percentage_of_Equity__c, 
                Percentage_of_Fixed_Income__c, Percentage_of_Total_Brokerage_AUM__c, Percentage_of_Total_Advisory_AUM__c, Percentage_of_Total_AUM__c, Percentage_GDC_ROA__c, 
                Percentage_Split_of_Total_AUM__c, AUM_Attributable__c, Percentage_of_AI_UIT_Cash__c, Assigned_Recruiter__c, Assigned_Recruiter_Email__c, Current_Custodian__c, 
                YTD_GDC__c,Advisor__r.Name, GP_ROA__c, Advisor_Total_AUM__c, Advisor_Total_Brokerage_AUM__c, Advisor_Total_Advisory_AUM__c, Prior_Yr_GDC__c, Current_Firm_Type__c,
                Current_Firm_Name__c,(select Sub_Loan_Split__c,  Sub_Loan_Amount__c, Repayable_Split__c, Backend_Split__c,Id,Contact__c,Contact__r.Name,Primary_Contact__c,AUM_Attributable__c,Split_of_Total_AUM__c,Loan_Application__c from Borrowers__r )//End
                FROM Loan_Application__c where Id=:recId];
    }
    
    public class ForgivableClass{
        @AuraEnabled public Decimal LoanAmount;
        @AuraEnabled public Decimal  Term;      
        @AuraEnabled public Decimal  IntrestRate;   
        @AuraEnabled public List<Note> NoteList;
        @AuraEnabled public Boolean OfferSelected;
        @AuraEnabled public String SelectButtonId;
        @AuraEnabled public String NoteButtonId;
        @AuraEnabled public String NoteListId;
        @AuraEnabled public Integer NoteLength;
        @AuraEnabled public String OfferId;
        @AuraEnabled public String OfferLink;
        @AuraEnabled public String Clause;
        //CS-1407 Amol Start
        @AuraEnabled public String ProposalStatus;
        @AuraEnabled public String ApprovedT12;
        @AuraEnabled public String VerifiedAssets;
        @AuraEnabled public String Expiration;
        @AuraEnabled public String Datee;
        //End
        //CS-1999 Bhanu Start
        @AuraEnabled public Decimal AcceptedLoanAmount;
        @AuraEnabled public Decimal AcceptedLoanAmount1;
        //End
        public ForgivableClass(){
            LoanAmount=0;
            Term=0;
            IntrestRate=0;
            NoteList=new  List<Note>();
            OfferSelected=false;
            SelectButtonId='Forgive';
            NoteButtonId='NoteForgive';
            NoteLength=0;
            NoteListId='NoteList';
            OfferId=null;
            ProposalStatus = '';
            OfferLink='/';
            Clause='';
            ApprovedT12='';
            VerifiedAssets='';
            Expiration='';
            Datee='';
            //CS-1999 Bhanu Start
            AcceptedLoanAmount=0;
            AcceptedLoanAmount1=0;
            //End
        }
        
    }
    
    
    @AuraEnabled
    public static List<OfferWrapper> collectRelatedProposal(String ParentId){
        try{
            
            List<OfferWrapper> OWL=new List<OfferWrapper>();
             // CH10 Start 
            for(Proposal_Offer__c p: [SELECT OSJ_NON_OSJ_Rep_Id__c,Fee_Waivers__c,Admin_fee__c,RecordType.Name, Max_TA_Amount__c,Loan_Clause__c,Approved_T12__c,
             Date__c, Expiration__c, Id,Offer_Name__c,Status__c,Campaign__c,(select Id,Body,CreatedDate,CreatedBy.Name from Notes ),OSJ_Amount__c, TA_Amount__c, 
             Backend_Bps__c, Backend_Hurdle__c, Expected_EAUM__c, 
             // CH10 Ends 
            //TA_of_EAUM__c,ch-08 CS-2847
             Verified_AUM__c, Loan_Amount__c, Interest_Rate__c, Proposal_Status__c, Proposal_Name__c, Note_Length__c, Platform__c, Branch__c, OSJ__c, TA_Program__c, 
             CLO_Proposal_ID__c, Level_Payout__c, Loan_Term__c, TA_of_VAUM__c, CaseSafeId__c, LoanApp_MD__c, Application_Type__c, Loan_Purpose__c, Record_type__c, 
             Loan_Category__c,
             //CH11 Start
             Backend_Date_1__c, Backend_Date_2__c,  
             //CH11 End
             // CH12 start
             Campaign_Offer_Selected__c
             // CH12 End
             FROM Proposal_Offer__c where LoanApp_MD__c =:ParentId and 
             (Offer_name__c like  '%Forgivable Offer%' or name like  '%Forgivable Offer%' or Proposal_name__c like  '%Forgivable Offer%' ) Limit 5]){
                if(p.Proposal_Name__c==null || p.Proposal_Name__c!='General Proposal' ){
                    OfferWrapper temp=new OfferWrapper();
                    temp.OfferLink= temp.OfferLink+p.Id;
                    temp.OfferId=p.Id;
                    temp.OfferName=p.Offer_Name__c==null?'':p.Offer_Name__c.replace('Forgivable ','');
                    temp.SelectButtonId='SEL-'+p.Id;
                    temp.NoteButtonId='Note-'+p.Id;
                    temp.NoteListId='NoteList-'+p.Id;
                    //Amol Changes Start - 10/05 - CS-2287 
                    //temp.MAX_TA_Amount=p.Max_TA_Amount__c==null?'':'$'+p.Max_TA_Amount__c;
                    temp.MAX_TA_Amount=p.Max_TA_Amount__c==null?0:p.Max_TA_Amount__c;
                    //Amol Changes End - 10/05 - CS-2287 
                    // Amol Changes Start - 07/22 - US-1734 - OSJ Amount Field
                    temp.OSJ_Amount1=p.OSJ_Amount__c==null?0:p.OSJ_Amount__c;
                    temp.OSJ_Amount=p.OSJ_Amount__c==null?0:p.OSJ_Amount__c;
                    // Amol Changes End - 07/22 - US-1734 - OSJ Amount Field
                    // Start CH02
                    temp.ProposalStatus = p.Proposal_Status__c==null?'':p.Proposal_Status__c;
                    // End CH02
                    temp.TA_Rate=p.TA_of_VAUM__c==null?'':''+p.TA_of_VAUM__c+'%';
                    temp.Backend=p.Backend_Bps__c==null?'':''+p.Backend_Bps__c+'bps';
                    // temp.Backend_Benchmark=p.Backend_Hurdle__c==null?'':'$'+p.Backend_Hurdle__c;
                    //Bhanu CS-2515 Start
                    temp.Backend_Benchmark=p.Backend_Hurdle__c==null?0:p.Backend_Hurdle__c;
                    // Bhanu CS-2515 ends
                    temp.Platform=p.Platform__c==null?'':''+p.Platform__c;
                    temp.Branch=p.Branch__c==null?'':''+p.Branch__c;
                    temp.OSJ=p.OSJ__c==null?'':''+p.OSJ__c;
                     // CH10 Start 
                     temp.OSJ_NON_OSJ_Rep_Id=p.OSJ_NON_OSJ_Rep_Id__c==null?'':''+p.OSJ_NON_OSJ_Rep_Id__c;
                      // CH10 Ends 
                      // CH12 Start
                     temp.Campaign_Offer_Selected=p.Campaign_Offer_Selected__c==null?'':''+p.Campaign_Offer_Selected__c;
                     //Ch12 End
                    temp.Terms=p.Loan_Term__c==null?'':''+p.Loan_Term__c+'Year';
                    temp.Payout=p.Level_Payout__c==null?'':''+p.Level_Payout__c;
                    temp.Campiagn=p.Campaign__c==null?'':''+p.Campaign__c;
                    //CS-1407 Amol Start
                    temp.Waivers=p.Fee_Waivers__c==null?'':''+String.valueof(p.Fee_Waivers__c);
                    temp.Admin_Fee=p.Admin_fee__c==null?'':''+String.valueof(p.Admin_fee__c);
                    //End
                    temp.NoteList=p.Notes.size()>0?p.Notes:temp.NoteList;
                    temp.NoteLength=p.Notes.size()>0?p.Notes.size():0;
                    temp.OfferSelected=p.Status__c;
                    temp.ApprovedT12=p.Approved_T12__c!=null?p.Approved_T12__c:null;
                    temp.Expiration=p.Expiration__c!=null?p.Expiration__c.format():null;
                    temp.Datee=p.Date__c!=null?p.Date__c.format():null;
                    temp.VerifiedAssets=p.Verified_AUM__c!=null?p.Verified_AUM__c:null;
                    temp.Clause=p.Loan_Clause__c==null?'':''+p.Loan_Clause__c;
                    //CS-745 Bhanu Start
                    //CH11 Start
                    string formattedDate1='';
                    string formattedDate2 = '';
                    if(p.Backend_Date_1__c != null){
                    string backendDate1 = String.valueof(p.Backend_Date_1__c);
                     formattedDate1 = backendDate1.Substring(0,backendDate1.length()-9);
                    system.debug(p.Backend_Date_1__c.format());
                    system.debug(formattedDate1);
                    }
                    if(p.Backend_Date_2__c != null){
                        string backendDate2 = String.valueof(p.Backend_Date_2__c);
                         formattedDate2 = backendDate2.Substring(0,backendDate2.length()-9);
                        system.debug(p.Backend_Date_2__c);
                    system.debug(p.Backend_Date_2__c.format());
                    }
                    
                    
                    
                    temp.BackendDate1=p.Backend_Date_1__c==null?null:''+p.Backend_Date_1__c.format();
                    temp.BackendDate10=p.Backend_Date_1__c==null?null: ''+p.Backend_Date_1__c;
                    temp.BackendDate2=p.Backend_Date_2__c==null?null:''+p.Backend_Date_2__c.format();
                    temp.BackendDate20=p.Backend_Date_2__c==null?null:''+p.Backend_Date_2__c;
                    //CH11 End
                     //CH09 Bhanu Start
                   temp.RecordType=String.valueof(p.RecordType.Name);
                   //CH09 Bhanu ends                   
                   if(p.RecordType.Name == 'TA Proposal')
                    {
                        temp.TA_Amount1=p.TA_Amount__c==null?0:p.TA_Amount__c;
                        temp.TA_Amount=p.TA_Amount__c==null?0:p.TA_Amount__c;
                    }
                    
                    //End
                    OWL.add(temp);
                }
            }
            return OWL;
        }catch(Exception ex){
            System.debug(ex);
        }
        return new List<OfferWrapper>();
    }
    
       //CH09 Bhanu Start
     @AuraEnabled
    public static List<OfferWrapper> collectProposalList(String ParentId){
        try{
            
            List<OfferWrapper> OWL=new List<OfferWrapper>();
            for(Proposal_Offer__c p: [SELECT Fee_Waivers__c,Admin_fee__c,RecordType.Name, Max_TA_Amount__c,Loan_Clause__c,Approved_T12__c, Date__c, Expiration__c, 
            Id,Offer_Name__c,Status__c,Campaign__c,(select Id,Body,CreatedDate,CreatedBy.Name from Notes ),OSJ_Amount__c, TA_Amount__c, Backend_Bps__c, 
            Backend_Hurdle__c, Expected_EAUM__c, 
            //CH09
             Verified_AUM__c, Loan_Amount__c, Interest_Rate__c, Proposal_Status__c, Proposal_Name__c, Note_Length__c, Platform__c, Branch__c, OSJ__c, TA_Program__c,
             CLO_Proposal_ID__c, Level_Payout__c, Loan_Term__c, TA_of_VAUM__c, CaseSafeId__c, LoanApp_MD__c, Application_Type__c, Loan_Purpose__c, Record_type__c,
             Loan_Category__c,
             //CH11 Start
             Backend_Date_1__c, Backend_Date_2__c  
             //CH11 End
             FROM Proposal_Offer__c where LoanApp_MD__c =:ParentId and 
             (Offer_name__c like  '%Forgivable Offer%'  or name like  '%Forgivable Offer%' or Proposal_name__c like  '%Forgivable Offer%'  or 
             name like  '%Repayable Offer%' ) Limit 6]){
             if(p.Proposal_Name__c==null || p.Proposal_Name__c!='General Proposal' ){
                    OfferWrapper temp=new OfferWrapper();
                    temp.OfferId=p.Id;
                    temp.OfferSelected=p.Status__c;
                     temp.RecordType=String.valueof(p.RecordType.Name);
                     OWL.add(temp);
                }
            }
            return OWL;
        }catch(Exception ex){
            System.debug(ex);
        }
        return new List<OfferWrapper>();
    }
      //CH09 Bhanu ends                   
                  
    
    @AuraEnabled 
    public static ForgivableClass  collectForgivableProposal(String ParentId){
        try{
            ForgivableClass temp=new ForgivableClass();
            Loan_Application__c loanAppRec = new Loan_Application__c();
            loanAppRec = [select id,RecordType.DeveloperName from Loan_Application__c where id=:ParentId];
            boolean bolz=false;
            // Added below condition by Amol to cover the Repayable Offer Validation and Fogivable Offer page load - 11/06/2020
            if(loanAppRec.RecordType.DeveloperName == 'Forgivable_loan' || loanAppRec.RecordType.DeveloperName == 'Working_Capital'){
                for(Proposal_Offer__c p: [SELECT Date__c,Expiration__c,Approved_T12__c,Max_TA_Amount__c,RecordType.Name,Id,
                                          Loan_Clause__c,Offer_Name__c,Status__c,(select Id,Body,CreatedDate,CreatedBy.Name 
                                                                                  from Notes ),OSJ_Amount__c, TA_Amount__c, Backend_Bps__c, Backend_Hurdle__c, 
                                          Expected_EAUM__c, 
                                          //TA_of_EAUM__c,ch-08 CS-2847
                                           Verified_AUM__c, Loan_Amount__c, Interest_Rate__c, 
                                          Proposal_Status__c, Proposal_Name__c, Note_Length__c, Platform__c, Branch__c, OSJ__c,
                                          TA_Program__c, CLO_Proposal_ID__c, Level_Payout__c, Loan_Term__c, TA_of_VAUM__c, 
                                          CaseSafeId__c, LoanApp_MD__c, Application_Type__c, Loan_Purpose__c, Record_type__c, 
                                          Loan_Category__c  FROM Proposal_Offer__c where LoanApp_MD__c =:ParentId 
                                          and (Offer_name__c like  '%Repayable Offer%' or name like  '%Repayable Offer%' 
                                               or Proposal_name__c like  '%Repayable Offer%' )  Limit 1]){// Modified By Bhanu-11/5/2020 for Offer accepted validation 
                                                   temp.NoteList.addAll(p.Notes);
                                                   temp.OfferLink= temp.OfferLink+p.Id;
                                                   temp.OfferId=p.Id;
                                                   temp.NoteLength=temp.NoteList.size();
                                                   //CS-1407 Amol Start
                                                   temp.LoanAmount=p.Max_TA_Amount__c!=null?p.Max_TA_Amount__c:0;
                                                   temp.ApprovedT12=p.Approved_T12__c!=null?String.valueof(p.Approved_T12__c):null;
                                                   temp.Expiration=p.Expiration__c!=null?p.Expiration__c.format():null;
                                                   temp.Datee=p.Date__c!=null?p.Date__c.format():null;
                                                   temp.VerifiedAssets=p.Verified_AUM__c!=null?String.valueOf(p.Verified_AUM__c):null;
                                                   temp.ProposalStatus = p.Proposal_Status__c==null?'':p.Proposal_Status__c;
                                                   //End
                                                   temp.Term=p.Loan_Term__c!=null?Decimal.valueOf(p.Loan_Term__c):null;
                                                   temp.IntrestRate=p.Interest_Rate__c!=null?p.Interest_Rate__c:null;
                                                   temp.OfferSelected=p.Status__c;
                                                   temp.NoteButtonId=temp.NoteButtonId+'-'+p.Id;
                                                   temp.NoteListId=temp.NoteListId+'-'+p.Id;
                                                   temp.SelectButtonId=temp.SelectButtonId+'-'+p.Id;
                                                   temp.Clause=p.Loan_Clause__c==null?'':''+p.Loan_Clause__c;
                                                   //CS-1999 Bhanu Start
                                                   if(p.RecordType.Name =='General Proposal' || p.RecordType.Name == 'Repayable')
                                                   {
                                                       temp.AcceptedLoanAmount1=p.TA_Amount__c==null?0:p.TA_Amount__c;
                                                       temp.AcceptedLoanAmount=p.TA_Amount__c==null?0:p.TA_Amount__c;
                                                   }
                                                   //End            
                                                   bolz=true;
                                               }
            }else if(loanAppRec.RecordType.DeveloperName == 'Monetization' || loanAppRec.RecordType.DeveloperName == 'Retention_Loan'){
                for(Proposal_Offer__c p: [SELECT Date__c,Expiration__c,Approved_T12__c,Max_TA_Amount__c,RecordType.Name,Id,
                                          Loan_Clause__c,Offer_Name__c,Status__c,(select Id,Body,CreatedDate,CreatedBy.Name 
                                                                                  from Notes ),OSJ_Amount__c, TA_Amount__c, Backend_Bps__c, Backend_Hurdle__c, 
                                          Expected_EAUM__c, 
                                          //TA_of_EAUM__c, ch-08 CS-2847
                                          Verified_AUM__c, Loan_Amount__c, Interest_Rate__c, 
                                          Proposal_Status__c, Proposal_Name__c, Note_Length__c, Platform__c, Branch__c, OSJ__c,
                                          TA_Program__c, CLO_Proposal_ID__c, Level_Payout__c, Loan_Term__c, TA_of_VAUM__c, 
                                          CaseSafeId__c, LoanApp_MD__c, Application_Type__c, Loan_Purpose__c, Record_type__c, 
                                          Loan_Category__c  FROM Proposal_Offer__c where LoanApp_MD__c =:ParentId 
                                          and (Offer_name__c like  '%Forgivable Offer%' or name like  '%Forgivable Offer%' 
                                               or Proposal_name__c like  '%Forgivable Offer%' )  Limit 1]){// Modified By Bhanu-11/5/2020 for Offer accepted validation 
                                                   temp.NoteList.addAll(p.Notes);
                                                   temp.OfferLink= temp.OfferLink+p.Id;
                                                   temp.OfferId=p.Id;
                                                   temp.NoteLength=temp.NoteList.size();
                                                   //CS-1407 Amol Start
                                                   temp.LoanAmount=p.Max_TA_Amount__c!=null?p.Max_TA_Amount__c:0;
                                                   temp.ApprovedT12=p.Approved_T12__c!=null?String.valueof(p.Approved_T12__c):null;
                                                   temp.Expiration=p.Expiration__c!=null?p.Expiration__c.format():null;
                                                   temp.Datee=p.Date__c!=null?p.Date__c.format():null;
                                                   temp.VerifiedAssets=p.Verified_AUM__c!=null?String.valueOf(p.Verified_AUM__c):null;
                                                   temp.ProposalStatus = p.Proposal_Status__c==null?'':p.Proposal_Status__c;
                                                   //End
                                                   temp.Term=p.Loan_Term__c!=null?Decimal.valueOf(p.Loan_Term__c):null;
                                                   temp.IntrestRate=p.Interest_Rate__c!=null?p.Interest_Rate__c:null;
                                                   temp.OfferSelected=p.Status__c;
                                                   temp.NoteButtonId=temp.NoteButtonId+'-'+p.Id;
                                                   temp.NoteListId=temp.NoteListId+'-'+p.Id;
                                                   temp.SelectButtonId=temp.SelectButtonId+'-'+p.Id;
                                                   temp.Clause=p.Loan_Clause__c==null?'':''+p.Loan_Clause__c;
                                                   //CS-1999 Bhanu Start
                                                   if(p.RecordType.Name =='General Proposal' || p.RecordType.Name == 'Repayable')
                                                   {
                                                       temp.AcceptedLoanAmount1=p.TA_Amount__c==null?0:p.TA_Amount__c;
                                                       temp.AcceptedLoanAmount=p.TA_Amount__c==null?0:p.TA_Amount__c;
                                                   }
                                                   //End            
                                                   bolz=true;
                                               }
            }
            if(bolz)
                return temp;
            
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public static  boolean createNote(String Body,String ParentId){
        try{
            Note Nt=new Note();
            Nt.body=Body;
            Nt.ParentId=ParentId;
            Nt.Title='Note'+system.NOw();
            insert Nt;
            return true;
        }catch(Exception ex){
            return false;
        }
        
    }
    @AuraEnabled
    public static Boolean updateProposalData(String PropData){
        try{
            System.debug(PropData);
            //system.debug(JSON.deserialize(PropData));
            List<Proposal_Offer__c> PropList=(List<Proposal_Offer__c>)JSON.deserialize(PropData, List<Proposal_Offer__c>.class);
            System.debug(PropList);
            if(PropList!=null){
                update PropList;
                // Added below logic to call the save offer method for TA - Repyable proposal is accepted - Amol -11/13/2020 - Start
                system.debug('PropList$$$$$'+PropList);
                /* for(Proposal_Offer__c pOff : PropList){
if(pOff.recordtype.Id == '0122g0000001zf8AAA'){
saveOffer(string.valueof(pOff.Id),string.valueof(pOff.LoanApp_MD__c));
}
}*/
                // Amol Chnages Ends.
            }else{
                throw new AuraHandledException('Unable to Save ');
            }
            
            
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        return true;
    }
    
    @AuraEnabled 
    public static Boolean  saveOffer(String recId,String loanId){
        try{
            List<Proposal_Offer__c> PropList=new List<Proposal_Offer__c>();
            //Start CH03
            List<Borrowers__c> borrowList=new List<Borrowers__c>();
            List<Borrowers__c> updateBorrList = new List<Borrowers__c>();
            borrowList = [Select Id,Split_of_Total_AUM__c,Backend_Split__c,AUM_Attributable__c,Contact__c,CLO_Customer_Group__c,CLO_Customer_ID__c,
                          Current_Firm_Name__c,Hire_Date__c,Master_Rep_ID__c,Repayable_Split__c,Repayable_Loan_Amount__c,Sub_Loan_Amount__c,Sub_Loan_Split__c,VAUM__c,
                          Current_Firm_Type__c,Enterprise_Name__c,Full_Name__c,Loan_Application__c,Primary_Contact__c,Total_AUM__c,
                          Contact__r.CLO_Customer_ID__c,Contact__r.Name from Borrowers__c 
                          where Loan_Application__c =:loanId];
            
            Loan_Application__c loanAppRec = new Loan_Application__c();
            loanAppRec = [Select id,Status__c,RecordType.DeveloperName from Loan_Application__c where id =:loanId];
            Id RepayableProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('Repayable').getRecordTypeId();
            List<Id> propIds = new List<Id>();
            Boolean UpdateProposal = false;
            Boolean propoStatus = false;
            
            // Added Record Type Condition to not get the Repyable Proposal of a TA and send the Repayable Proposal Status as Approved - Modified By Amol - 11/24/2020
            for(Proposal_Offer__c p: [SELECT Id,RecordTypeId,Offer_Name__c,Status__c,(select Id,Body,CreatedDate,CreatedBy.Name from Notes ),OSJ_Amount__c, TA_Amount__c, Backend_Bps__c, Backend_Hurdle__c, Expected_EAUM__c,
            // TA_of_EAUM__c, ch-08 CS-2847
            Verified_AUM__c, Loan_Amount__c, Interest_Rate__c, Proposal_Status__c, Proposal_Name__c, Note_Length__c, Platform__c, Branch__c, OSJ__c, TA_Program__c, CLO_Proposal_ID__c, Level_Payout__c, Loan_Term__c, TA_of_VAUM__c, CaseSafeId__c, LoanApp_MD__c, Application_Type__c, Loan_Purpose__c, Record_type__c, Loan_Category__c  FROM Proposal_Offer__c where LoanApp_MD__c =:loanId and Id!=:recId]){ 
                if(p.status__c != true && p.RecordTypeId != RepayableProposalRecordTypeId){
         p.Proposal_Status__c=LoanSubmitApplication.getApplicationStatus('Proposal_Offer__c','Status_2'); //CH06 // CS-2286# Modified By Bhanu
                }
                PropList.add(p);
            }
            
            Proposal_Offer__c prop = new Proposal_Offer__c();
            
            prop = [select id,TA_Amount__c,Proposal_Status__c,OSJ_Amount__c,RecordTypeId, RecordType.DeveloperName from Proposal_Offer__c where id = :recId];
            
            Proposal_Offer__c p1=new Proposal_Offer__c();
            p1.Id=recId;
            p1.Status__c=true;
            p1.Offer_Select__c = true;
            p1.RecordTypeId = prop.RecordTypeId; // Added by Amol 11/05/2020 - To set the record type of the offer which is accepted.
            
            if(loanAppRec != null && prop != null){
                system.debug('@@@@@@@@@@@@@@'+prop.OSJ_Amount__c);
                if(prop.OSJ_Amount__c == null || prop.OSJ_Amount__c <= 10000){ //naga added = for less than <= 11/13/2020
                    //if(p1.Proposal_Status__c != 'Accepted')
                    p1.Proposal_Status__c = LoanSubmitApplication.getApplicationStatus('Proposal_Offer__c','Status_1'); //CH06
                    
                    //if(loanAppRec.Status__c != 'Offer Accepted')
                    loanAppRec.Status__c = LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_4'); //CH06
                    
                    //  if(System.IsBatch() == false){ // Commented the code and will be deployed as part of 12/12 Release.
                    if(System.IsBatch() == false && prop.RecordTypeId != RepayableProposalRecordTypeId){ // Added condition to check for the Proposal Record type of a Repyable Proposal of a TA after the Loan Application Status is "Offer Accepted" - Added by Amol - 12/08/2020
                        update loanAppRec;
                    }
                }
                if(loanAppRec.RecordType.DeveloperName == 'Forgivable_loan' && prop.RecordType.DeveloperName == 'TA_Proposal_Record_Type'){
                    if(borrowList != null){
                        for(Borrowers__c brow : borrowList){
                            if(prop.TA_Amount__c !=null && brow.Sub_Loan_Split__c != null){
                                brow.Sub_Loan_Amount__c = (prop.TA_Amount__c * brow.Sub_Loan_Split__c)/100;
                                updateBorrList.add(brow);
                            }
                            
                        }
                    }
                }
                
                system.debug('@@@@@@@@@@@@@@'+loanAppRec.RecordType.DeveloperName);
                system.debug('@@@@@@@@@@@@@@'+prop.RecordType.DeveloperName);
                system.debug('@@@@@@@@@'+borrowList);
                
                /*---11/13/2020 - logic is moved to webservice callout class - Naga 
if(loanAppRec.RecordType.DeveloperName == 'Forgivable_loan' && prop.RecordType.DeveloperName == 'Repayable'){
if(borrowList != null){
for(Borrowers__c brow : borrowList){
system.debug('@@@@@@@@@'+prop.TA_Amount__c);
system.debug('@@@@@@@@@'+brow.Repayable_Split__c);
if(prop.TA_Amount__c !=null && brow.Repayable_Split__c != null){
//Start CH04
brow.Repayable_Loan_Amount__c = (prop.TA_Amount__c * brow.Repayable_Split__c)/100;
//End CH04
updateBorrList.add(brow);
}

}
}
}*/
                /*if(loanAppRec.RecordType.DeveloperName == 'Backend_TA' && prop.RecordType.DeveloperName == 'Backend_Proposal'){
if(borrowList != null){
for(Borrowers__c brow : borrowList){
if(prop.TA_Amount__c !=null && brow.Backend_Split__c != null){
brow.Sub_Loan_Amount__c = (prop.TA_Amount__c * brow.Backend_Split__c)/100;
updateBorrList.add(brow);
}

}
}
}*/
                //Added By Bhanu -11/13/2020 Borrower Subloan amount update
                /*if((loanAppRec.RecordType.DeveloperName == 'Retention_Loan' || loanAppRec.RecordType.DeveloperName == 'Monetization' || loanAppRec.RecordType.DeveloperName == 'Working_Capital') && prop.RecordType.DeveloperName == 'General_Proposal'){
if(borrowList != null){
for(Borrowers__c brow : borrowList){
if(prop.TA_Amount__c !=null && brow.Sub_Loan_Split__c != null){
brow.Sub_Loan_Amount__c = (prop.TA_Amount__c * brow.Sub_Loan_Split__c)/100;
updateBorrList.add(brow);
}

}
}
}*/ //Ended By Bhanu
            }
            
            
            // Added below condition as Part of CH02
            /* if(p1.RecordType.DeveloperName != 'TA_Proposal_Record_Type'){
p1.Proposal_Status__c='Accepted'; 
}*/
            PropList.add(p1);
            if(PropList.size()>0){
                update PropList;
                system.debug('PropList!!!!'+PropList);
                UpdateProposal = true;
            }
            
            if(updateBorrList.size()>0){
                system.debug('updateBorrList!!!!!'+updateBorrList);
                update updateBorrList;
            }
            
            //End CH03
            //Logic added by Amol - Update Proposal API
            //Start CH01
            /*Proposal_Offer__c prop1 = [select id,proposal_status__c from Proposal_Offer__c where id =:recid];
if(prop1.proposal_status__c != null || prop1.Proposal_Status__c != 'Accepted - Pending Credit Approval' || 
prop1.Proposal_Status__c != 'Accepted - Credit Not Approved'){
propoStatus = true;
}*/
            for(Proposal_Offer__c prop1:PropList){
                propIds.add(prop1.id);
                system.debug('prop1.Status__c!!!!!!!'+prop1.Status__c);
                system.debug('prop1.Proposal_Status__c !!!!!!'+prop1.Proposal_Status__c);
                //start CH06 
                if(prop1.Status__c == true && prop1.Proposal_Status__c != null && prop1.Proposal_Status__c != LoanSubmitApplication.getApplicationStatus('Proposal_Offer__c','Status_3') && 
                   prop1.Proposal_Status__c != LoanSubmitApplication.getApplicationStatus('Proposal_Offer__c','Status_4')){
                       propoStatus = true;
                       //End
                   }
            }
            Loan_Application__c loanApp = new Loan_Application__c();
            loanApp = [Select id,RecordTypeId,Loan_SF_CLO_Status__c,Status__c,CLO_Application_ID__c from Loan_Application__c where ID = :loanId];
            //removed propoStatus condition - Amol
            system.debug('loanApp@@@@'+loanApp );
             //start CH06 
            if(loanApp != null && propoStatus && loanApp.CLO_Application_ID__c != null && 
               loanApp.Status__c != LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_5') && 
               loanApp.Status__c != LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_6')){
                   //Ends
                   //Bhanu CS-2516 starts- Update TA application Offer Accepted Criteria
                   
                   Id recTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Transition Assistance').getRecordTypeId();
                   //start CH06 
                   String loanAppStatus= LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_4');
                   if(loanApp.RecordTypeId ==recTypeId && loanApp.status__c == loanAppStatus) //End
                   {
                       List <Borrowers__c> BorrowersList = new List <Borrowers__c>();
                       
                       BorrowersList= [select Id, Name,Contact__r.RecordType.Name,Contact__r.Hire_Date__c ,Loan_Application__r.Opportunity__r.StageName from Borrowers__c where Loan_Application__c=:loanApp.id];
                       
                       
                       if(BorrowersList.size()>0)
                       {
                           Integer cnt=0;
                           for(Borrowers__c Borrowers: BorrowersList)
                           {
                               if( Borrowers.Contact__r.Hire_Date__c !=null && Borrowers.Loan_Application__r.Opportunity__r.StageName =='Closed-Joined' ) 
                               {
                                   cnt=cnt+1;
                               }
                               
                           }
                           if(cnt== BorrowersList.size() && loanApp.status__c==loanAppStatus) // CH06 
                           {
                               cls_LPL_SendLoan_ProposalUpdatestoMule.makePostCallout(Id.valueOf(loanId),propIds);
                               loanApp.Loan_SF_CLO_Status__c=true;
                               update loanApp;
                           }
                           
                       }
                       
                       
                   }
                   else
                   {
                       cls_LPL_SendLoan_ProposalUpdatestoMule.makePostCallout(Id.valueOf(loanId),propIds);
                        loanApp.Loan_SF_CLO_Status__c=true;
                        update loanApp;
                   }
                   //Bhanu CS-2516 ends
                   
                   
                   
               }
            
            if(System.IsBatch() == false && loanAppRec !=null){
                //update loanAppRec;
            }
            //End CH01
            
            return true;
        }catch(Exception ex){
            
        }
        return false;
    }
    
    // @Future - Commented by Amol - 06/04
    @TestVisible private static void updateCLODetails(Set<Id> BSet){
        try{
            Set<Id> ContactIdSet=new Set<Id>();
            Id LoanId;
            Id PrimaryContactId;
            Loan_Application__c LA; 
            List<Contact> ContactUpdateList=new List<Contact>();
            
            for(Borrowers__c temp:[select id, Loan_Application__c,Estimated_Credit_Score__c,CLO_Customer_Group_Name__c,AUM_Attributable__c,Split_of_Total_AUM__c,Contact__c,Primary_Contact__c from Borrowers__c where id in:BSet and Contact__c!=null AND  Loan_Application__c!=null]){
                LoanId=temp.Loan_Application__c;
                if(temp.Primary_Contact__c){
                    PrimaryContactId=temp.Contact__c;
                }
                ContactIdSet.add(temp.Contact__c);
                
                Contact TB=new Contact();
                TB.Id=temp.Contact__c;
                TB.CLO_Customer_Group_Name__c=temp.CLO_Customer_Group_Name__c;
                TB.AUM_Attributable__c=temp.AUM_Attributable__c;
                TB.Split_of_Total_AUM__c=temp.Split_of_Total_AUM__c;
                //TB.Estimated_Credit_Score__c = temp.Estimated_Credit_Score__c;
                ContactUpdateList.add(TB);
                
            }
            
            if(LoanId!=null){
                LA=wcloanapplicationcontroller.collectRecordDetails(LoanId);
                if(PrimaryContactId!=null){
                    //Start CH-05
                    //LA.Primary_Contact__c=true;
                    //LA.Advisor__c=PrimaryContactId;
                    //End CH-05
                    LA.Primary_Contact_Name__c=PrimaryContactId;
                    update LA;
                }
                
                for(Contact  con:ContactUpdateList){
                    con.Legal_Entity__c=LA.Legal_Entity__c;
                }
                
            }
            if(ContactUpdateList.size()>0){
                update ContactUpdateList;
            }
            //Anil updated to call Queuable batch to send primary Contact payload (06/04/2020)
            /*if(PrimaryContactId!=null && LA.Status__c!='initiated'){
System.enqueueJob(new ContactCLOQueueBatch(PrimaryContactId));
//if multiple   contacts then  need to change logic in queuable batch & cls_LPL_SendUpdatedCustomerDatatoMule   
//List<Contact> conIdList=new   List<Contact> ();   
//System.enqueueJob(new ContactCLOQueueBatch(conIdList));
}*/
            
            
            
        }catch(Exception ex1){
            System.debug(ex1);
            System.debug(ex1.getMessage());
            System.debug(ex1.getLineNumber());
        }
    }
    
    
    public class OfferWrapper{
        @AuraEnabled public String OfferName;
        @AuraEnabled public String OfferId;
        //Amol Changes Start - 10/05 - CS-2287 
        //@AuraEnabled public String MAX_TA_Amount;
        @AuraEnabled public Decimal MAX_TA_Amount;
        //Amol Changes End  - 10/05 - CS-2287 
        @AuraEnabled public Decimal TA_Amount;
        @AuraEnabled public Decimal TA_Amount1;
        // Amol Changes start 07/22 - US-1734 - OSJ Amount field
        @AuraEnabled public Decimal OSJ_Amount;
        @AuraEnabled public Decimal OSJ_Amount1;
        // Amol Changes end 07/22 - US-1734 - OSJ Amount field
        // Start CH02
        @AuraEnabled public String ProposalStatus;
        // End CH02
        @AuraEnabled public String TA_Rate;
        @AuraEnabled public String Backend;
        //Bhanu CS-2515 Start
         // CH10 Start
        @AuraEnabled public String OSJ_NON_OSJ_Rep_Id;
        // CH10 Ends
        // CH12 Start
        @AuraEnabled public string Campaign_Offer_Selected;
        // CH12 End
       @AuraEnabled public Decimal Backend_Benchmark;
        @AuraEnabled public String  Platform;
        @AuraEnabled public String Branch;
        @AuraEnabled public String OSJ;
        @AuraEnabled public String Terms;
        @AuraEnabled public String Payout;
        @AuraEnabled public String Campiagn;
        @AuraEnabled public String Waivers;
        @AuraEnabled public String Admin_Fee;
        @AuraEnabled public List<Note> NoteList;
        @AuraEnabled public Boolean OfferSelected;
        @AuraEnabled public String SelectButtonId;
        @AuraEnabled public String NoteButtonId;
        @AuraEnabled public String NoteListId;
        @AuraEnabled public Integer NoteLength;
        @AuraEnabled public String OfferLink;
        @AuraEnabled public String Clause;
        @AuraEnabled public Decimal ApprovedT12;
        @AuraEnabled public Decimal VerifiedAssets;
        @AuraEnabled public String Expiration;
        @AuraEnabled public String Datee;
        //CS-745 Bhanu Start
        @AuraEnabled public String BackendDate1;
        @AuraEnabled public String BackendDate10;
        @AuraEnabled public String BackendDate2;
        @AuraEnabled public String BackendDate20;
        @AuraEnabled public String RecordType; //CH09 Bhanu
        //End
        
        public OfferWrapper(){
            OfferLink='/';
            OfferSelected=false;
            NoteLength=0;
            NoteList=new List<Note>();
            OfferId='';
            //Amol Changes Start - 10/05 - CS-2287 
            //MAX_TA_Amount='';
            MAX_TA_Amount=0;
            //Amol Changes End - 10/05 - CS-2287 
            TA_Amount=0;
            TA_Amount1=0;
                
           OSJ_NON_OSJ_Rep_Id=''; // CH10
           Campaign_Offer_Selected=''; //CH12
        
            // Amol Changes start 07/22 - US-1734 - OSJ Amount field
            OSJ_Amount=0;
            OSJ_Amount1=0;
            // Amol Changes end 07/22 - US-1734 - OSJ Amount field
            // Start CH02
            ProposalStatus='';
            // End CH02
            TA_Rate='';
            Backend=''; 
            Backend_Benchmark=0; //Bhanu CS-2515 Start
            Platform='';
            Branch='';
            OSJ='';
            Terms='';
            Payout='';
            Campiagn='';
            Waivers='';
            Admin_Fee='';
            ApprovedT12=0;
            VerifiedAssets=0;
            Expiration=null;
            Datee=null;
            Clause='';
            // CS-745 Bhanu Start
            BackendDate1='';
            BackendDate10='';
            BackendDate2='';
            BackendDate20='';
            RecordType='';  // CH09 Bhanu
            //End
            
        }
    }
    
}