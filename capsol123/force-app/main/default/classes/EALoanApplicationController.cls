/*
    Author          : 'Anil Kumar Gunti'
    Created Date    :
    Description     : Used in LWC Component(eaRetentionModule/eaRetentionPage)  to create / Update Loan application Record.
    Story           : CS-1107(Sprint12)

    * Modified by Amol - CS - 1812 - Defect: Retention Loan application functions - 8 / 20 / 2020 - Ch01
    * ch02 CS-2847 Commented the TA_of_EAUM__c field which is not required in the code
    
    

    CH.No   Description                                                                 Developer  Date
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
    *
    CH - 03  CS - 2953 Enhancement - Update Forgivable Application and related record 
             as read - only when offer accepted
                                                                                         Amol      03 / 26 / 2021 
    


   
*/
public with sharing class EALoanApplicationController { 
    public static Map<String,Integer> TermLengthMap=new  Map<String,Integer>{
        '7 Years'=>7, '5 Years'=>5, '4 Years'=>4, '3 Years'=>3, '2 Years'=>2, '1 Year'=>1, '6 Years'=>6, '8 Years'=>8, '9 Years'=>9, '10 Years'=>10 
    };
    public static Map<Integer,String> TermLengthMapReverse=new Map<Integer,String>{
       7 =>'7 Years', 5=>'5 Years', 4=>'4 Years',3=>'3 Years', 2=>'2 Years',1=> '1 Year',6=> '6 Years', 8=>'8 Years',9=>'9 Years',10=>'10 Years' 
    };
    public class RetentionPicklistData{
        @AuraEnabled public  List<Object> LoanPurposeList;
        @AuraEnabled public  List<Object> LoanEntityList;
        public RetentionPicklistData(){
            Map<String,Object> DefaultData=new Map<String,Object>{'label'=>'','value'=>''};
            LoanPurposeList=new List<Object>();
            LoanEntityList=new List<Object>();
        }
    }
    //to get Picklist information
    @AuraEnabled(cacheable=true)
    public static RetentionPicklistData populateDefaultinformation(){
        RetentionPicklistData RetentionData=new RetentionPicklistData();
        RetentionData.LoanEntityList.addAll(populateValue(Loan_Application__c.Legal_Entity__c.getDescribe().getPickListValues()));
        RetentionData.LoanPurposeList.addAll(populateValue(Loan_Application__c.Loan_Purpose__c.getDescribe().getPickListValues()));
        return RetentionData;
    }
 
    public static List<Object> populateValue(List<Schema.PicklistEntry> pickListValues){
        List<Object> Temp=new List<Object>();
        for(Schema.PicklistEntry f: pickListValues){
            System.debug(f);
            if(f.isActive()){
                Map < String, String > values = new Map < String, String > {
                    'label' => f.getLabel(),
                    'value' => f.getValue()
                };
                Temp.add((Object)values);
            }
        }
        return Temp;
    }
    public class BusinessInfoWrapper{
        @AuraEnabled public String BussinessName;
        @AuraEnabled public String Entity;
        @AuraEnabled public String Purpose;
        @AuraEnabled public String Advisor;
        //Start Ch01
        @AuraEnabled public String CaseNumber;
        @AuraEnabled public String CaseIdLink;
        //End Ch01
        //change to accept advisor value as null ---06/27   
        public BusinessInfoWrapper(){
            BussinessName='';
            Entity='';
            Purpose='';
            Advisor='';
            //Start Ch01
            CaseIdLink='';
            CaseNumber='';
            //End Ch01
        }
    }
    public class FinancialInfoWrapper{
        @AuraEnabled public Decimal LoanAmount;
        @AuraEnabled public Decimal IntrestRate;
        @AuraEnabled public String LoanTerm;
        @AuraEnabled public Date FundingDate;
        public FinancialInfoWrapper(){
            LoanAmount=0;
            IntrestRate=0;
            LoanTerm=null;
            FundingDate=null;
        }
    }
    public class BorrowerInfoWrapper{
        @AuraEnabled public String ContactId;
        @AuraEnabled public Contact Contact;
        @AuraEnabled public Boolean primary;
        @AuraEnabled public String Uname;
        @AuraEnabled public String recId;
        @AuraEnabled public String MasterRepId;
        @AuraEnabled public String MasterRType;
        @AuraEnabled public String YTDGDC;
        @AuraEnabled public String PYGDC;
        @AuraEnabled public String GPROA;
        @AuraEnabled public String BName;
        //CS-1811-Bhanu Start
        @AuraEnabled public Decimal loanSplit;
        //End
        
        public BorrowerInfoWrapper(){
            primary=false;
            ContactId=null;
            Contact=null;
            Uname=null;
            MasterRepId=null;
            MasterRType=null;
            YTDGDC=null;
            PYGDC=null;
            GPROA=null;
            BName=null;
            //CS-1811-Bhanu Start
            loanSplit=0;
            //End

        }
    }

    public class AdditionalContactClass{
        @AuraEnabled public Object AssignedRecruiter;
        @AuraEnabled public String AssignedRecruiterLink;
        @AuraEnabled public Object InternalRecruiter;
        @AuraEnabled public String InternalRecruiterLink;
        @AuraEnabled public Object BusinessDevelopment;
        @AuraEnabled public String BusinessDevelopmentLink;
        @AuraEnabled public String PreparerName;
        @AuraEnabled public String ServicerName;

        public AdditionalContactClass(){
            AssignedRecruiter=null;
            AssignedRecruiterLink=null;
            InternalRecruiter=null;
            InternalRecruiterLink=null;
            BusinessDevelopment=null;
            BusinessDevelopmentLink=null;
            PreparerName='';
            ServicerName='';
        }
        
    }
    public class ApplicationInfoClass{
        @AuraEnabled public String ApplicationNo;
        @AuraEnabled public String ApplicationLink;
        @AuraEnabled public String Status;
        @AuraEnabled public String LoanPurpose;
        @AuraEnabled public String LoanType;
        @AuraEnabled public String Type;
        @AuraEnabled public Object RecordType;
        @AuraEnabled public String RecordTypeName;
        public ApplicationInfoClass(){
            ApplicationNo='';
            ApplicationLink='';
            Status='';
            LoanPurpose='';
            LoanType='';
            Type='';
            RecordType=null;
            RecordTypeName='';
        }
    }
    public class SystemInfoClass{
        @AuraEnabled public Object CreatedBy;
        @AuraEnabled public String CreatedByLink;
        @AuraEnabled public Datetime CreatedDate;
        @AuraEnabled public Object LastModifiedBy;
        @AuraEnabled public String LastModifiedByLink;
        @AuraEnabled public Datetime LastModifiedDate;
        @AuraEnabled public String CLOApplicationId;
        @AuraEnabled public String CLOCustomerGroup;
        public SystemInfoClass(){
            CreatedBy=null;
            CreatedByLink='';
            CreatedDate=null;
            LastModifiedBy=null;
            LastModifiedByLink='';
            LastModifiedDate=null;
            CLOApplicationId='';
            CLOCustomerGroup='';
        }
    }

    public class RetiontionWrapper{
        @AuraEnabled public BusinessInfoWrapper BusinessInfo;
        @AuraEnabled public FinancialInfoWrapper FinancialData;
        @AuraEnabled public List<BorrowerInfoWrapper> BorrowerInfo;
        @AuraEnabled public String AdditionalComments;
        //@AuraEnabled public String ContactId; - COmmneted as part of Ch01
        //Start Ch01
        @AuraEnabled public String CaseId;
        //End Ch01
        @AuraEnabled public String RecordId;
        @AuraEnabled public AdditionalContactClass AdditionalContacts;
        @AuraEnabled public ApplicationInfoClass ApplicationInfo;
        @AuraEnabled public SystemInfoClass SystemInfo;
        public RetiontionWrapper(){
            RecordId=null;
            BusinessInfo=new BusinessInfoWrapper();
            FinancialData=new FinancialInfoWrapper();
            BorrowerInfo=new List<BorrowerInfoWrapper>();
            AdditionalComments='';
            //ContactId=null; - Commented as part of Ch01
            //Start Ch01
            CaseId=null;
            //End Ch01
            AdditionalContacts=new AdditionalContactClass();
            ApplicationInfo=new ApplicationInfoClass();
            SystemInfo=new SystemInfoClass();
        }
        
    }
    public static BusinessInfoWrapper populateBusinessInfo(Loan_Application__c rec){
        try{
            BusinessInfoWrapper temp=new BusinessInfoWrapper();
            temp.BussinessName=rec.Business_Name_DBA__c!=null?rec.Business_Name_DBA__c:'';
            temp.Entity=rec.Legal_Entity__c!=null?rec.Legal_Entity__c:'';
            temp.Purpose=rec.Loan_Purpose__c!=null?rec.Loan_Purpose__c:'';
            //change to accept advisor value as null ---06/27
            temp.Advisor=rec.Number_of_Advisors__c!=null?''+rec.Number_of_Advisors__c:'';
            //Start Ch01
            temp.CaseNumber=rec.Case_Number__c!=null?rec.Case_Number__r.CaseNumber:'';
            temp.CaseIdLink=rec.Case_Number__c!=null?'/'+rec.Case_Number__c:'';
            //End Ch02
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new BusinessInfoWrapper();
    }
    public static FinancialInfoWrapper populateFinancialInfo(Loan_Application__c rec){
        try{
            FinancialInfoWrapper temp=new FinancialInfoWrapper();
            temp.LoanAmount=rec.Requested_Loan_Amount__c==null?0:rec.Requested_Loan_Amount__c;
            temp.IntrestRate=rec.Interest_Rate__c==null?0:rec.Interest_Rate__c;
            temp.LoanTerm=rec.Requested_Loan_Term__c==null?'':TermLengthMapReverse.containsKey(Integer.valueOf(rec.Requested_Loan_Term__c))?TermLengthMapReverse.get(Integer.valueOf(rec.Requested_Loan_Term__c)):'';
            System.debug('System.debug>>'+rec.Requested_Funding_Date__c);
            temp.FundingDate=rec.Requested_Funding_Date__c==null?null:rec.Requested_Funding_Date__c;
            System.debug('System.debuZZZZg>>'+temp.FundingDate);
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new FinancialInfoWrapper();
    }
    public static Map<Id,Contact> collectContactDetails(Set<Id> ContactIdSet){
        try{

            return new Map<Id,Contact>([select Id,(select Id,Gross_Profit_ROA__c from Advisor_Profitability__r order by LastmodifiedDate Desc limit 1),
            (Select Id,YTD_GDC_All__c,Prior_full_year_GDC_All__c from Financials__r order by LastmodifiedDate Desc limit 1) from Contact  where Id in :ContactIdSet]);

        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new Map<Id,Contact>();
    }
    public static List<BorrowerInfoWrapper> populateBorrowerInfo(Loan_Application__c rec){
        try{
            List<BorrowerInfoWrapper> temp=new  List<BorrowerInfoWrapper>();
           set<Id> conSetId=new Set<Id>();
            for(Borrowers__c tmp:rec.Borrowers__r){
                BorrowerInfoWrapper iTemp=new BorrowerInfoWrapper();
                iTemp.ContactId=tmp.Contact__c!=null?tmp.Contact__c:null;
                iTemp.primary=tmp.Primary_Contact__c;
                iTemp.Uname=tmp.Id;
                iTemp.Contact=tmp.Contact__c!=null?tmp.Contact__r:null;
                if(tmp.Contact__c!=null){
                    iTemp.MasterRepId=tmp.Contact__r.Master_Rep_ID__c!=null?tmp.Contact__r.Master_Rep_ID__c:'';
                    iTemp.MasterRType=tmp.Contact__r.Rep_Type__c!=null?tmp.Contact__r.Rep_Type__c:'';
                    conSetId.add(tmp.Contact__c);
                   /* iTemp.MasterRepId=tmp.Contact__r.Master_Rep_ID__c!=null?tmp.Contact__r.Master_Rep_ID__c:'';
                    iTemp.MasterRType=tmp.Contact__r.Modified_R_Type__c!=null?tmp.Contact__r.Modified_R_Type__c:'';
                    iTemp.YTDGDC=tmp.Contact__r.YTD_GDC__c!=null?''+tmp.Contact__r.YTD_GDC__c:'';
                    iTemp.PYGDC=tmp.Contact__r.Prior_Yr_GDC__c!=null?''+tmp.Contact__r.Prior_Yr_GDC__c:'';
                    iTemp.GPROA=tmp.Contact__r.GP_ROA__c!=null?''+tmp.Contact__r.GP_ROA__c:'';*/
                }else{
                    iTemp.MasterRepId='';
                    iTemp.MasterRType='';
                    iTemp.YTDGDC='';
                    iTemp.PYGDC='';
                    iTemp.GPROA='';
                    
                }
                   //CS-1811-Bhanu Start
                 
                 iTemp.loanSplit=tmp.Sub_Loan_Split__c!=null?tmp.Sub_Loan_Split__c:0;
                
                //Ends
                
                iTemp.recId=tmp.Id;

                temp.add(iTemp);
            }
            if(conSetId.size()>0){
                Map<Id,Contact> ContactMap=collectContactDetails(conSetId);
                for(BorrowerInfoWrapper b:temp){
                    if(b.Contact!=null){

                        
                        if(ContactMap.containsKey(b.Contact.Id) && ContactMap.get(b.Contact.Id).Advisor_Profitability__r!=null && ContactMap.get(b.Contact.Id).Advisor_Profitability__r.size()==1){
                            b.GPROA=ContactMap.get(b.Contact.Id).Advisor_Profitability__r[0].Gross_Profit_ROA__c!=null?''+ContactMap.get(b.Contact.Id).Advisor_Profitability__r[0].Gross_Profit_ROA__c:'';
                        }else{
                            b.GPROA='';
                        }
                        if(ContactMap.containsKey(b.Contact.Id) && ContactMap.get(b.Contact.Id).Financials__r!=null && ContactMap.get(b.Contact.Id).Financials__r.size()==1){
                            b.YTDGDC=ContactMap.get(b.Contact.Id).Financials__r[0].YTD_GDC_All__c!=null?''+ContactMap.get(b.Contact.Id).Financials__r[0].YTD_GDC_All__c:'';
                            b.PYGDC=ContactMap.get(b.Contact.Id).Financials__r[0].Prior_full_year_GDC_All__c!=null?''+ContactMap.get(b.Contact.Id).Financials__r[0].Prior_full_year_GDC_All__c:'';
                        }else{
                            b.YTDGDC='';
                            b.PYGDC='';
                            
                        }
                    }
                }
            }
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return  new  List<BorrowerInfoWrapper>();
    }
    public static SystemInfoClass populateSystemInfo(Loan_Application__c rec){
        try{
            SystemInfoClass temp=new SystemInfoClass();
            temp.CreatedBy=rec.createdBy;
            temp.CreatedByLink='/'+rec.createdById;
            temp.CreatedDate=rec.createdDate;
            temp.LastModifiedBy=rec.LastModifiedBy;
            temp.LastModifiedByLink='/'+rec.LastModifiedById;
            temp.LastModifiedDate=rec.LastModifiedDate;
            temp.CLOApplicationId=rec.CLO_Application_ID__c!=null?rec.CLO_Application_ID__c:'';
            temp.CLOCustomerGroup=rec.CLO_Customer_Group_ID__c!=null?rec.CLO_Customer_Group_ID__c:'';
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new SystemInfoClass();
    }
    public static ApplicationInfoClass populateApplicationInfo(Loan_Application__c rec){
        try{
            ApplicationInfoClass temp=new ApplicationInfoClass();          
            temp.ApplicationNo=rec.Name;
            temp.ApplicationLink='';
            temp.Status=rec.Status__c!=null?rec.Status__c:'';
            temp.LoanPurpose=rec.Loan_Purpose__c!=null?rec.Loan_Purpose__c:'';
            temp.LoanType=rec.Loan_Category__c!=null?rec.Loan_Category__c:'';
            temp.Type=rec.Application_Type__c!=null?rec.Application_Type__c:'';
            temp.RecordType=rec.Recordtype;
            temp.RecordTypeName=rec.Recordtype.Name;
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new ApplicationInfoClass();
    }
    public static AdditionalContactClass populateAdditionalContacts(Loan_Application__c rec){
        try{
            AdditionalContactClass temp=new AdditionalContactClass();
            temp.AssignedRecruiter=rec.Assigned_Recruiter__c!=null?rec.Assigned_Recruiter__r:null;
            temp.AssignedRecruiterLink=rec.Assigned_Recruiter__c!=null?'/'+(String)rec.Assigned_Recruiter__c:'';
            temp.InternalRecruiter=rec.Internal_Recruiter__c!=null?rec.Internal_Recruiter__r:null;
            temp.InternalRecruiterLink=rec.Internal_Recruiter__c!=null?'/'+(String)rec.Internal_Recruiter__c:'';
            System.debug('rec.Recordtype.Name'+rec.Recordtype.Name);
            if(rec.Recordtype.Name=='Retention Loan'){
                temp.BusinessDevelopment=rec.Business_Consultant_RM__c!=null?rec.Business_Consultant_RM__r:null;
                temp.BusinessDevelopmentLink=rec.Business_Consultant_RM__c!=null?'/'+(String)rec.Business_Consultant_RM__c:'';
            }else{
                temp.BusinessDevelopment=rec.Business_Developer__c!=null?rec.Business_Developer__r:null;
                temp.BusinessDevelopmentLink=rec.Business_Developer__c!=null?'/'+(String)rec.Business_Developer__c:'';
            }
            //temp.BusinessDevelopment=rec.Business_Developer__c!=null?rec.Business_Developer__r:null;
            ///temp.BusinessDevelopmentLink=rec.Business_Developer__c!=null?'/'+(String)rec.Business_Developer__c:'';
            temp.PreparerName=rec.Preparer_Name__c!=null?rec.Preparer_Name__c:'';
            temp.ServicerName=rec.Servicer_Name__c!=null?rec.Servicer_Name__c:'';
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new AdditionalContactClass();
    }

    @AuraEnabled
    public static RetiontionWrapper collectData(String recId){
        try{
            System.debug(recId);
            Loan_Application__c loan=collectRecordDetails(recId);
            if(loan!=null){
                RetiontionWrapper RW=new RetiontionWrapper();
                RW.BusinessInfo=populateBusinessInfo(loan);
                RW.FinancialData=populateFinancialInfo(loan);
                RW.BorrowerInfo=populateBorrowerInfo(loan);
                RW.SystemInfo=populateSystemInfo(loan);
                RW.ApplicationInfo=populateApplicationInfo(loan);
                // RW.ContactId=loan.contactlookup__c==null?null:loan.contactlookup__c;  - Commented as part of Ch01
                //Start Ch01
                RW.CaseId=loan.Case_Number__c==null?null:loan.Case_Number__c;
                //End Ch01
                RW.AdditionalContacts=populateAdditionalContacts(loan);
                RW.AdditionalComments=loan.Additional_Comments__c!=null?loan.Additional_Comments__c:'';
                RW.RecordId=loan.Id;
                return RW;
            }
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return null;
    }
 //CS-1811-Bhanu Start
    public static Loan_Application__c collectRecordDetails(String recId){
        return [SELECT Business_Developer__r.Name,Parent_Application__c,Parent_Application__r.Name,(select Id,Name,Campaign_Name__c,Branch__c,U_W_Type__c,Term_Length__c,Platform__c,OSJ_LE_Name__c,Offer_Name__c from Proposals_Offers_Placeholders__r), 
        (SELECT Id, Name, RecordTypeId, CreatedDate, CreatedById, LoanApp_MD__c, Application_Type__c, Backend_Bps__c,
         Backend_Hurdle__c, Branch__c, CLO_Proposal_ID__c, Expected_EAUM__c, ID__c, Interest_Rate__c, Level_Payout__c, 
         Loan_Amount__c, Loan_Category__c, Loan_Term__c, Note_Length__c, OSJ__c, Platform__c, Proposal_Name__c, 
         Proposal_Status__c, Record_type__c, TA_Amount__c, TA_Program__c, 
         //TA_of_EAUM__c, ch02 CS-2847
         TA_of_VAUM__c, Verified_AUM__c, 
         Loan_Purpose__c, Admin_Fees__c, Admin_fee__c, Approved_T12__c, Campaign__c, CaseSafeId__c, DBA_Business_Name__c, 
         Date__c, Expiration__c, Fee_Waivers__c, Loan_Clause__c, Loan_Type__c, Notes__c, OSJ_LE_Branch__c, OSJ_Manager_Name__c,
          Offer_Accepted__c, Offer_Name__c, Status__c, U_W_Type__c FROM Proposals_Offers__r) ,Id, OwnerId, Name, RecordTypeId, RecordType.Name, Internal_Recruiter__r.Name,Assigned_Recruiter__r.Name,Business_Consultant_RM__r.Name,
        CreatedDate, CreatedById, CreatedBy.Name, SystemModstamp, LastModifiedById, LastModifiedBy.Name,CLO_Customer_Group_Name__c,
        LastModifiedDate, CLO_Application_ID__c, CLO_Customer_Group_ID__c, Status__c, Contact_Recruiter__c,
        Primary_Contact_Name__r.CRD_Number__c , Primary_Contact_Name__r.RecordtypeId,
        Primary_Contact_Name__r.CLO_Customer_ID__c, Primary_Contact_Name__r.Master_Rep_ID__c , Primary_Contact_Name__r.Legal_Entity__c,
        Primary_Contact_Name__r.Hire_Date__c, Primary_Contact_Name__r.FirstName, Primary_Contact_Name__r.LastName, Primary_Contact_Name__r.Name, Primary_Contact_Name__r.Net_Promoter_Score__c, Primary_Contact_Name__r.LPLCRM__U_S_Citizenship__c,
        Primary_Contact_Name__r.Birthdate, Primary_Contact_Name__r.LPLCRM__Social_Security_Tax_ID__c, Primary_Contact_Name__r.MailingAddress,  Primary_Contact_Name__r.MailingStreet,
        Primary_Contact_Name__r.MailingCity, Primary_Contact_Name__r.MailingState, Primary_Contact_Name__r.MailingPostalCode, Primary_Contact_Name__r.MobilePhone,
        Primary_Contact_Name__r.CLO_Customer_Group_Name__c, Primary_Contact_Name__r.CLO_Customer_Group_ID__c, Primary_Contact_Name__r.Enterprise_Name__c, Primary_Contact_Name__r.Branch_ID__c, Primary_Contact_Name__r.OSJ_MGR_ID__c,
        Primary_Contact_Name__r.OSJ_MGR_Name__c, Primary_Contact_Name__r.OSJ_ID__c, Primary_Contact_Name__r.Engagement_Index_Score__c,
        Primary_Contact_Name__r.Split_of_Total_AUM__c, Primary_Contact_Name__r.AUM_Attributable__c, Primary_Contact_Name__r.Current_Firm__c, Primary_Contact_Name__r.Current_Firm_Type__c, Primary_Contact_Name__r.Modified_R_Type__c,
        Primary_Contact_Name__r.GP_ROA__c, Primary_Contact_Name__r.Date_joined_the_industry__c,Primary_Contact_Name__r.YTD_GDC__c, Primary_Contact_Name__r.Prior_Yr_GDC__c,
        Primary_Contact_Name__r.Estimated_Credit_Score__c, Primary_Contact_Name__r.Total_Advisory_AUM__c,Primary_Contact_Name__r.CLCommon__legal_Entity_type__c,
        Primary_Contact_Name__r.Total_Brokerage_AUM__c, Primary_Contact_Name__r.Advisor_Total_AUM__c,

        Advisor__r.CRD_Number__c , Advisor__r.RecordtypeId,
        Advisor__r.CLO_Customer_ID__c, Advisor__r.Master_Rep_ID__c , Advisor__r.Legal_Entity__c,
        Advisor__r.Hire_Date__c, Advisor__r.FirstName, Advisor__r.LastName, Advisor__r.Name, Advisor__r.Net_Promoter_Score__c, Advisor__r.LPLCRM__U_S_Citizenship__c,
        Advisor__r.Birthdate, Advisor__r.LPLCRM__Social_Security_Tax_ID__c, Advisor__r.MailingAddress,  Advisor__r.MailingStreet,
        Advisor__r.MailingCity, Advisor__r.MailingState, Advisor__r.MailingPostalCode, Advisor__r.MobilePhone,
        Advisor__r.CLO_Customer_Group_Name__c, Advisor__r.CLO_Customer_Group_ID__c, Advisor__r.Enterprise_Name__c, Advisor__r.Branch_ID__c, Advisor__r.OSJ_MGR_ID__c,
        Advisor__r.OSJ_MGR_Name__c, Advisor__r.OSJ_ID__c, Advisor__r.Engagement_Index_Score__c,
        Advisor__r.Split_of_Total_AUM__c, Advisor__r.AUM_Attributable__c, Advisor__r.Current_Firm__c, Advisor__r.Current_Firm_Type__c, Advisor__r.Modified_R_Type__c,
        Advisor__r.GP_ROA__c, Advisor__r.Date_joined_the_industry__c,Advisor__r.YTD_GDC__c, Advisor__r.Prior_Yr_GDC__c,
        Advisor__r.Estimated_Credit_Score__c, Advisor__r.Total_Advisory_AUM__c,Advisor__r.CLCommon__legal_Entity_type__c,
        Advisor__r.Total_Brokerage_AUM__c, Advisor__r.Advisor_Total_AUM__c,






        Number_of_Advisors__c, Platform__c, Application_Type__c, Loan_Purpose__c, Requested_Loan_Amount__c, 
        Requested_Loan_Term__c, Direct_Mutual_Funds__c, Mutual_Funds_Custodied__c, AUM_Variable_Annuities__c, 
        AUM_Fixed_Annuities__c, AUM_Equity__c, AUM_Fixed_Income__c, AUM_AI_UIT_Cash__c, AUM_Cash__c, Total_Fee_Based_AUM__c, 
        Additional_Comments__c, Scenario__c, Previous_LPL_Advisor__c, Asset_Status__c, Preparer_Name__c, Preparer_Email__c, Opportunity_Owner1__c,
        Servicer_Name__c, Servicer_Email__c, Underwritting_Type__c, Campaign_Name__c, Primary_Contact__c, Current_Registration__c, 
        Level_Payout_Request__c, Request_for_Fee_Reduction__c, Loan_Category__c, Contact_Master_Rep_Id__c, Branch__c, Total_Gross_Revenue__c, 
        Legal_Entity__c, Total_Annual_Business_Expenditures__c, Estimated_Officers_Compensation__c, Ownership_of_Business__c, 
        Total_Annual_Personal_Expenditures__c, Total_Annual_Net_Income__c, Estimated_Credit_Score__c, Total_Purchase_Price__c, 
        Estimated_Down_Payment__c, Annual_Acquisition_Revenue__c, Annual_Acquisition_Operating_Expense__c, Anticipated_Change_in_Annual_Operating__c, 
        Will_You_Assume_Seller_Debt__c, LPL_loan_or_an_external_loan__c, Seller_Note_Amount__c, Seller_Note_Term__c, Seller_Note_Rate__c, 
        Is_Seller_Staying_on_receiving_salary__c, Succession_plan__c, AUM_Total_Mutual_Funds__c, Opportunity__c,Opportunity__r.Name, Primary_Contact_Name__c,Primary_Contact_Email__c, 
        Prior_Firm_Name__c, Prior_Firm_Type__c, Total_Transactional_Brokerage_AUM__c, Total_Brokerage_AUM__c, Percentage_of_Mutual_Funds_Held_Direct__c, 
        Record_Type__c, Internal_Recruiter__c,Internal_Recruiter__r.title,Internal_Recruiter__r.phone, CurrentCustodian__c, Internal_Recruiter_Email__c, Business_Developer__c, Business_Consultant_RM__c, 
        Business_Developer_Email__c, Business_Consultant_RM_Email__c, OSJ_Manager_Name__c, OSJ_Manager__c, Business_Name_DBA__c, Debt_Service_Coverage__c, 
        Seller_s_Name__c, Seller_Note_Remaining_Term_Monthly__c, Interest_Rate__c, Created_By_Email__c, Requested_Funding_Date__c, OSJ_LE_Branch__c, contactlookup__c, 
        Modified_R_Type__c, Last_Status_Modified_Date__c, Advisor__c, Offer_Terms__c, Term_Length__c, U_W_Type__c, Number_of_LPL_Loans_Outstanding__c, 
        Total_Advisory_AUM__c, Total_AUM__c, Advisory_Revenue_c__c, Brokerage_Revenue__c, Total_Production__c, Percentage_of_Mutual_Funds_Held_Custodie__c, 
        Percentage_of_Total_Mutual_Funds__c, Percentage_of_Variable_Annuities__c, Percentage_of_Fixed_Annuities__c, Percentage_of_Equity__c, 
        Percentage_of_Fixed_Income__c, Percentage_of_Total_Brokerage_AUM__c, Percentage_of_Total_Advisory_AUM__c, Percentage_of_Total_AUM__c, Percentage_GDC_ROA__c, 
        Percentage_Split_of_Total_AUM__c, AUM_Attributable__c, Percentage_of_AI_UIT_Cash__c, Assigned_Recruiter__c,Assigned_Recruiter__r.title,Assigned_Recruiter__r.phone, Assigned_Recruiter_Email__c, Current_Custodian__c, 
        YTD_GDC__c, GP_ROA__c, Advisor_Total_AUM__c, Advisor_Total_Brokerage_AUM__c, Advisor_Total_Advisory_AUM__c, Prior_Yr_GDC__c, Current_Firm_Type__c,
        Opportunity_Owner__c,Current_Firm_Name__c,(select Id, Name, Contact__c,Contact__r.CRD_Number__c , Contact__r.RecordtypeId,
        Contact__r.CLO_Customer_ID__c, Contact__r.Master_Rep_ID__c , Contact__r.Legal_Entity__c,
        Contact__r.Hire_Date__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Name, Contact__r.Net_Promoter_Score__c, Contact__r.LPLCRM__U_S_Citizenship__c,
         Contact__r.Birthdate, Contact__r.LPLCRM__Social_Security_Tax_ID__c, Contact__r.MailingAddress,  Contact__r.MailingStreet,
         Contact__r.MailingCity, Contact__r.MailingState, Contact__r.MailingPostalCode, Contact__r.MobilePhone,
          Contact__r.CLO_Customer_Group_Name__c, Contact__r.CLO_Customer_Group_ID__c, Contact__r.Enterprise_Name__c, Contact__r.Branch_ID__c, Contact__r.OSJ_MGR_ID__c,
           Contact__r.OSJ_MGR_Name__c, Contact__r.OSJ_ID__c, Contact__r.Engagement_Index_Score__c,
          Contact__r.Split_of_Total_AUM__c, Contact__r.AUM_Attributable__c, Contact__r.Current_Firm__c, Contact__r.Current_Firm_Type__c, Contact__r.Modified_R_Type__c,Contact__r.Rep_Type__c,
           Contact__r.GP_ROA__c, Contact__r.YTD_GDC__c, Contact__r.Prior_Yr_GDC__c,
           Contact__r.Estimated_Credit_Score__c, Contact__r.Total_Advisory_AUM__c,contact__r.CLCommon__legal_Entity_type__c,
         Contact__r.Total_Brokerage_AUM__c, Contact__r.Advisor_Total_AUM__c,  CLO_Customer_ID__c, CLO_Customer_Group__c, Primary_Contact__c, 
        AUM_Attributable__c,Current_Firm_Name__c,Current_Firm_Type__c,Enterprise_Name__c, Loan_Application__c, Total_AUM__c, Split_of_Total_AUM__c, Full_Name__c,Sub_Loan_Split__c from Borrowers__r ) ,Case_Number__c, Case_Number__r.CaseNumber,Case_Number__r.OwnerId,Case_Number__r.Owner.Name 
        FROM Loan_Application__c where Id=:recId];      //End
    }



    @AuraEnabled
    public  static Loan_Application__c collectWCDetails(String recId){
        return collectRecordDetails(recId);
    }
    @testVisible
    private static void deleteBorrowersRecord(Id LoanId){
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
    private static void createBorrowerRecords(List<BorrowerInfoWrapper> Bdata,Id LoanId,String BusinessDBAName,String LegalEntity){
        System.debug('HELLO');
        Id PrimaryContactId;

        List<Borrowers__c> BList=new List<Borrowers__c>();
        for(BorrowerInfoWrapper b:Bdata){
            System.debug(b);
            if(b.ContactId!=null){
                Borrowers__c temp=new Borrowers__c();
                temp.Name=b.BName;
                temp.Contact__c=b.ContactId;
                temp.Primary_Contact__c=b.primary;
                temp.Loan_Application__c=LoanId;
                temp.CLO_Customer_Group_Name__c =BusinessDBAName;
                if(b.recId!=null){
                    temp.Id=b.recId;
                }
                if(b.primary){
                    PrimaryContactId=b.ContactId;
                }
                   //CS-1811-Bhanu Start
                temp.Sub_Loan_Split__c=b.loanSplit;
                                
                //End
                BList.add(temp);
                
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
            if(PrimaryContactId!=null){
                Contact con=[select Business_Consultant_RM__c,Id from Contact where id=:PrimaryContactId];
                Loan_Application__c LA = new Loan_Application__c();
                LA.Id=LoanId;
                LA.Advisor__c=PrimaryContactId;
                LA.Business_Consultant_RM__c=con.Business_Consultant_RM__c;
                update LA;
            }else{
                Loan_Application__c LA = new Loan_Application__c();
                LA.Id=LoanId;
                LA.Advisor__c=null;
                LA.Business_Consultant_RM__c=null;
                update LA;
            }
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
                LA.Advisor__c=null;
                LA.Primary_Contact_Name__c=null;
                
                LA.Business_Consultant_RM__c=null;
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
    //@Future
    private static void updateCLODetails(Set<Id> BSet){
        try{
            Set<Id> ContactIdSet=new Set<Id>();
            Id LoanId;
            Id PrimaryContactId;
            Loan_Application__c LA; 
            List<Contact> ContactUpdateList=new List<Contact>();
            
            for(Borrowers__c temp:[select id, Loan_Application__c,CLO_Customer_Group_Name__c,AUM_Attributable__c,Split_of_Total_AUM__c,Contact__c,Primary_Contact__c from Borrowers__c where id in:BSet and Contact__c!=null AND  Loan_Application__c!=null]){
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
                ContactUpdateList.add(TB);

            }

            if(LoanId!=null){
                LA=wcLoanApplicationController.collectRecordDetails(LoanId);
                if(PrimaryContactId!=null){
                    LA.Primary_Contact__c=true;
                    LA.Advisor__c=PrimaryContactId;
                    LA.Primary_Contact_Name__c=PrimaryContactId;
                    update LA;
                }else{
                    LA.Primary_Contact__c=false;
                    LA.Advisor__c=null;
                    LA.Primary_Contact_Name__c=null;
                }
                
                for(Contact  con:ContactUpdateList){
                    con.Legal_Entity__c=LA.Legal_Entity__c;
                }

            }
            if(ContactUpdateList.size()>0){
                update ContactUpdateList;
            }

        }catch(Exception ex1){
            System.debug(ex1);
            System.debug(ex1.getMessage());
            System.debug(ex1.getLineNumber());
        }
    }

    @AuraEnabled
    public static String saveRecord(String JSONDATA){
        try{
            System.debug(JSONDATA);
            RetiontionWrapper DATA=(RetiontionWrapper)JSON.deserialize(JSONDATA, RetiontionWrapper.class);
            System.debug(DATA);
            System.debug(DATA.BorrowerInfo);
            Loan_Application__c LA = new Loan_Application__c();
            LA.Business_Name_DBA__c=DATA.BusinessInfo.BussinessName;
            LA.Legal_Entity__c=Data.BusinessInfo.Entity;
            LA.Loan_Purpose__c='Retention';
            LA.Number_of_Advisors__c=DATA.BusinessInfo.Advisor==''?null:Decimal.valueOf(DATA.BusinessInfo.Advisor);
            //LA.contactlookup__c=Data.ContactId!=null?Data.ContactId:null; - Commented as part of Ch01
            //Start Ch01
            LA.Case_Number__c=Data.CaseId!=null?Data.CaseId:null;
            //End Ch01
            LA.RecordTypeId=Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Retention Loan').getRecordTypeId();
            LA.Requested_Loan_Term__c= TermLengthMap.containsKey(DATA.FinancialData.LoanTerm)?TermLengthMap.get(DATA.FinancialData.LoanTerm):null;
            LA.Requested_Loan_Amount__c=DATA.FinancialData.LoanAmount;
            LA.Interest_Rate__c=DATA.FinancialData.IntrestRate;
            System.debug(DATA.FinancialData.FundingDate);
            LA.Requested_Funding_Date__c=DATA.FinancialData.FundingDate;
            LA.Additional_Comments__c=Data.AdditionalComments;
            if(DATA.RecordId!=null){
                LA.Id=DATA.RecordId;
            }
            upsert LA;
            //CH - 03 Start
            Loan_Application__c loanApp = [select id,status__c from Loan_Application__c where id = :LA.id];
            List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
            String   loanStatusDocumentation=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_13');
            String   loanStatusBoardingFunding=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_14');
            String   loanStatusNigo=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_15');
            String   loanStatuInformationRequested=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_16');
            String   loanStatusInformationSubmitted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_17');
            String   loanStatusFunded=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_7');
            
            if(loanApp.Status__c != loanStatusDocumentation && loanApp.Status__c != loanStatusBoardingFunding &&
            loanApp.Status__c != loanStatusNigo && loanApp.Status__c != loanStatuInformationRequested &&
            loanApp.Status__c != loanStatusInformationSubmitted && loanApp.Status__c != loanStatusFunded) {
            system.debug('LA.Status__c'+loanApp.Status__c);
                    if(DATA.BorrowerInfo.size()>0){
                        createBorrowerRecords(DATA.BorrowerInfo,LA.Id,LA.Business_Name_DBA__c,LA.Legal_Entity__c);
                    }else{
                        deleteBorrowersRecord(LA.Id);
                    }
                }
                //CH - 03 End
            return LA.Id;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        //return 'Error';
    }
    
  
}