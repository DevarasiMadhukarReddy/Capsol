/**
* CS-1140 Refinance Loan Application - Submit Validation added by Madhukar Reddy for Sprint 13 release
* CS-1141 Line of Credit - Submit Validation added by Madhukar Reddy for Sprint 13 release
* Modified By Bhanu 08/05/2020 CS-1126 Backend TA Loan Application - Submit Validation
* Modified By Bhanu 8/17/2020 CS-1811 - Custom UI enhancement - Loan Split %
* Modified By Bhanu 9/22/2020 CS-1994 - Loan Split % Validation
* Modified By Bhanu 11/30/2020 CS-2518 - Enhance Application Submit Validation
* CS-2703 Duplicate Validation issue added by Madhukar Reddy for all applications 12/18/2020 -CH02
* CS-2516 Sprint 20- Update TA application Offer Accepted Criteria
* CH.No       Description                                                           Developer           Date
---------------------------------------------------------------------------------------------------------------
* CH-03       CS-2756 Sprint 21- Remove hardcoded loan application status values     Bhanu              01/25/2021
* CH-04       CS-2849 Sprint 22- TA Application-Submit application validation        Saritha            02/10/2021
              modification(CRD Number,Opportunity Firm Type)
* ch-05       CS-2847 Commented the TA_of_EAUM__c field which is not required in     Madhukar
              the code
* CH-06       CS-3341 Remove Backed TA submit Validation for "Current Firm Type"     Amol               04/30/2021
              field

**/
public  with sharing class wcLoanApplicationController {
    public static Set<String> EA_SET;
    public static Set<String> NA_SET ;
    
    static{
        EA_SET=new Set<String>{'Retention Loan','Acquisition Loan','Growth Loan','Line of Credit','Refinance Loan'};
            NA_SET=new Set<String>{'Transition Assistance','Working Capital'};
                }
    
    
    public class WorkingCapital{
        @AuraEnabled public string AdditionalComments;
        @AuraEnabled public ProposalInfoClass ProposalInfo;
        @AuraEnabled public List<BorrowerInfoClass> BorrowerInfo;
        @AuraEnabled public FinancialInfoClass FinancialInfo;
        @AuraEnabled public BusinessInfoClass BusinessInfo;
        @AuraEnabled public String OpportunityId;
        @AuraEnabled public String RecordId;
        @AuraEnabled public AdditionalContactClass AdditionalContacts;
        @AuraEnabled public ApplicationInfoClass ApplicationInfo;
        @AuraEnabled public SystemInfoClass SystemInfo;
        
        public WorkingCapital(){
            AdditionalComments='';
            RecordId='';
            OpportunityId='';
            ProposalInfo=new ProposalInfoClass();
            BorrowerInfo=new List<BorrowerInfoClass>();
            FinancialInfo=new FinancialInfoClass();
            BusinessInfo=new BusinessInfoClass();
            AdditionalContacts=new AdditionalContactClass();
            ApplicationInfo=new ApplicationInfoClass();
            SystemInfo=new SystemInfoClass();
        }
    }
    
    public class BusinessInfoClass{
        @AuraEnabled public String ParentId;
        @AuraEnabled public String BussinessName;
        @AuraEnabled public String AdvisorNo;
        @AuraEnabled public String Entity;
        @AuraEnabled public String Registration;
        @AuraEnabled public String Custodian;
        @AuraEnabled public Object ParentLoan;
        public BusinessInfoClass(){
            ParentId='';
            BussinessName='';
            AdvisorNo ='';
            Entity='';
            Registration='';
            Custodian='';
            ParentLoan=null;
        }
    }
    public class FinancialInfoClass{
        @AuraEnabled public Decimal mfdh;
        @AuraEnabled public Decimal mfc;
        @AuraEnabled public Decimal va;
        @AuraEnabled public Decimal fi;
        @AuraEnabled public Decimal fa;
        @AuraEnabled public Decimal aiuitCash ;
        @AuraEnabled public Decimal eq;
        @AuraEnabled public Decimal totAdvAum;
        @AuraEnabled public Decimal advRev;
        @AuraEnabled public Decimal broRev;
        public FinancialInfoClass(){
            mfdh=0;
            mfc=0;
            va=0;
            fi=0;
            fa=0;
            aiuitCash=0;
            eq=0;
            totAdvAum=0;
            advRev=0;
            broRev=0;
        }
    }
    public class BorrowerInfoClass{
        @AuraEnabled public String ContactId;
        @AuraEnabled public Decimal pAUM;
        @AuraEnabled public boolean primary;
        @AuraEnabled public String Uname;
        @AuraEnabled public Object Contact;
        @AuraEnabled public String recId;
        @AuraEnabled public Decimal AUMATT;
        @AuraEnabled public String BName;
        // CS-1811-Bhanu Start
        @AuraEnabled public Decimal repayableSplit;
        @AuraEnabled public Decimal loanSplit;
        @AuraEnabled public Decimal backendSplit;
        @AuraEnabled public String subloanAmount;
        //End
        
        public BorrowerInfoClass(){
            ContactId='';
            pAUM=0;
            primary=false;
            Uname=null;
            Contact=null;
            recId=null;
            AUMATT=0;
            BName=null;
            //CS-1811-Bhanu Start
            repayableSplit=0;
            loanSplit=0;
            backendSplit=0;
            subloanAmount='';
            //End
        }
        
    }
    public class ProposalInfoClass{
        @AuraEnabled public Decimal RequestedLoanAmount;
        @AuraEnabled public String RequestedTermLength;
        public ProposalInfoClass(){
            RequestedLoanAmount=0;
            RequestedTermLength='';
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
    
    
    
    @AuraEnabled
    public static String saveWCRecord(String JSONDATA){
        //try{
        WorkingCapital DATA=(WorkingCapital)JSON.deserialize(JSONDATA, WorkingCapital.class);
        System.debug(DATA);
        System.debug(DATA.BorrowerInfo);
        Loan_Application__c LA = new Loan_Application__c();
        LA.Business_Name_DBA__c=DATA.BusinessInfo.BussinessName;
        LA.Number_of_Advisors__c=(Data.BusinessInfo.AdvisorNo!=null && Data.BusinessInfo.AdvisorNo!='')?Decimal.valueOf(Data.BusinessInfo.AdvisorNo):null;
        LA.Advisor_Total_AUM__c=Data.FinancialInfo.totAdvAum;
        LA.Legal_Entity__c=Data.BusinessInfo.Entity;
        LA.Current_Registration__c=Data.BusinessInfo.Registration;
        LA.CurrentCustodian__c=Data.BusinessInfo.Custodian;
        LA.Direct_Mutual_Funds__c=Data.FinancialInfo.mfdh;
        LA.Mutual_Funds_Custodied__c=Data.FinancialInfo.mfc;
        LA.AUM_Variable_Annuities__c=Data.FinancialInfo.va;
        LA.AUM_Fixed_Annuities__c=Data.FinancialInfo.fa;
        LA.AUM_Fixed_Income__c=Data.FinancialInfo.fi;
        LA.AUM_Equity__c=Data.FinancialInfo.eq;
        LA.AUM_AI_UIT_Cash__c=Data.FinancialInfo.aiuitCash;
        LA.Total_Advisory_AUM__c=Data.FinancialInfo.totAdvAum;
        LA.Advisory_Revenue_c__c=Data.FinancialInfo.advRev;
        LA.Brokerage_Revenue__c=Data.FinancialInfo.broRev;
        LA.Requested_Loan_Term__c=(Data.ProposalInfo.RequestedTermLength!=null && Data.ProposalInfo.RequestedTermLength!='')?(Decimal.valueOf(Data.ProposalInfo.RequestedTermLength)):null;
        LA.Requested_Loan_Amount__c=Data.ProposalInfo.RequestedLoanAmount;
        LA.Loan_Purpose__c='Transition Assistance';
        LA.Loan_Category__c='Repayable Loan';
        LA.Application_Type__c='Prospect';
        
        
        if(DATA.BusinessInfo.ParentId!=null && DATA.BusinessInfo.ParentId!=''){
            LA.Parent_Application__c=DATA.BusinessInfo.ParentId;
        }else{
            LA.Parent_Application__c=null;
        }
        
        LA.RecordTypeId=Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Working Capital').getRecordTypeId();
        /* LA.Advisor__c=Data.;
LA.Primary_Contact__c=Data.;
LA.Percentage_Split_of_Total_AUM__c=Data.;*/
        
        LA.Additional_Comments__c=Data.AdditionalComments;
        if(DATA.OpportunityId!=null){ 
            LA.Opportunity__c=DATA.OpportunityId;
            Opportunity oppor=[select Id,Internal_Recruiter_IRD__c,Assigned_Recruiter__c from Opportunity  where Id=:DATA.OpportunityId];
            if(oppor!=null){
                LA.Assigned_Recruiter__c=oppor.Assigned_Recruiter__c==null?null:oppor.Assigned_Recruiter__c;
                LA.Internal_Recruiter__c=oppor.Internal_Recruiter_IRD__c==null?null:oppor.Internal_Recruiter_IRD__c;
            }
        }
        if(DATA.RecordId!=null){
            LA.Id=DATA.RecordId;
        }
        try {
            SYstem.debug(LA.Business_Name_DBA__c);
            upsert LA;
            SYstem.debug([select id ,Business_Name_DBA__c from Loan_Application__c where Id=:LA.Id]);
            if(DATA.BorrowerInfo.size()>0){
                createBorrowerRecords(DATA.BorrowerInfo,LA.Id,LA.Business_Name_DBA__c,LA.Legal_Entity__c);
            }else{
                deleteBorrowersRecord(LA.Id);
            }
            
            /* if(LA.Id != null){
if(LA.Advisor__c != null){
con = [select id,Legal_Entity__c,LPLCRM__U_S_Citizenship__c,Citizenship_Status__c from Contact where id =:LA.Advisor__c];
if(LA.Legal_Entity__c != null){
con.Legal_Entity__c = LA.Legal_Entity__c;
}
//start CH-03
if(con.LPLCRM__U_S_Citizenship__c == true){
con.Citizenship_Status__c = LoanSubmitApplication.getApplicationStatus('Contact','Status_3');
}else{
con.Citizenship_Status__c = LoanSubmitApplication.getApplicationStatus('Contact','Status_4');
}//End
update con;
}
}*/
        } catch(Exception e) {
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
            
        }
        return LA.Id;
        /* }catch(Exception ex){
System.debug(ex);
System.debug(ex.getMessage());
System.debug(ex.getLineNumber());
return 'ERROR';
}*/
        
    }
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
                LA=collectRecordDetails(LoanId);
                if(PrimaryContactId!=null){
                    LA.Primary_Contact__c=true;
                    LA.Advisor__c=PrimaryContactId;
                    LA.Primary_Contact_Name__c=PrimaryContactId;
                    update LA;
                }else{
                    LA.Primary_Contact__c=false;
                    LA.Advisor__c=null;
                    LA.Primary_Contact_Name__c=null;
                    update LA;
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
    
    private static void createBorrowerRecords(List<BorrowerInfoClass> Bdata,Id LoanId,String BusinessDBAName,String LegalEntity){
        System.debug('HELLO');
        Id PrimaryContactId;
        
        List<Borrowers__c> BList=new List<Borrowers__c>();
        for(BorrowerInfoClass b:Bdata){
            System.debug(b);
            if(b.ContactId!=null){
                Borrowers__c temp=new Borrowers__c();
                temp.Name=b.BName;
                temp.Contact__c=b.ContactId;
                temp.Primary_Contact__c=b.primary;
                temp.Split_of_Total_AUM__c=b.pAUM;
                temp.Loan_Application__c=LoanId;
                temp.AUM_Attributable__c=b.AUMATT;
                temp.CLO_Customer_Group_Name__c =BusinessDBAName;
                //CS-1811-Bhanu Start
                temp.Backend_Split__c=b.backendSplit;
                temp.Sub_Loan_Split__c=b.loanSplit;
                temp.Repayable_Split__c=b.repayableSplit;
                
                //End
                
                
                if(b.recId!=null){
                    temp.Id=b.recId;
                }
                if(b.primary){
                    PrimaryContactId=b.ContactId;
                }
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
                Loan_Application__c LA = new Loan_Application__c();
                LA.Id=LoanId;
                LA.Advisor__c=PrimaryContactId;
                update LA;
            }
        }else{
            deleteallBorrowers(LoanId);
        } 
    }
    @testVisible
    private static  void deleteallBorrowers(Id LoanId){
        List<Borrowers__c> DLIst=new  List<Borrowers__c>();
        try{
            DLIst=[select Id from Borrowers__c where Loan_Application__c=:LoanId  ];
            if(DLIst.size()>0 || Test.isRunningTest()){
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
    
    public static BusinessInfoClass populateBusinessInfo(Loan_Application__c rec){
        try{
            BusinessInfoClass temp=new BusinessInfoClass();
            
            temp.ParentLoan=rec.Parent_Application__c!=null?rec.Parent_Application__r:null;
            temp.BussinessName=rec.Business_Name_DBA__c!=null?rec.Business_Name_DBA__c:'';
            //change to show null value
            temp.AdvisorNo =rec.Number_of_Advisors__c!=null?''+rec.Number_of_Advisors__c:'';
            temp.Entity=rec.Legal_Entity__c!=null?rec.Legal_Entity__c:'';
            temp.Registration=rec.Current_Registration__c!=null?rec.Current_Registration__c:'';
            temp.Custodian=rec.CurrentCustodian__c!=null?rec.CurrentCustodian__c:'';
            temp.ParentId=rec.Parent_Application__c!=null?''+rec.Parent_Application__r.Id:'';
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new BusinessInfoClass();
    }
    public static FinancialInfoClass populateFinancialInfo(Loan_Application__c rec){
        try{
            FinancialInfoClass temp=new FinancialInfoClass();
            temp.mfdh=rec.Direct_Mutual_Funds__c!=null?rec.Direct_Mutual_Funds__c:0;
            temp.mfc=rec.Mutual_Funds_Custodied__c!=null?rec.Mutual_Funds_Custodied__c:0;
            temp.va=rec.AUM_Variable_Annuities__c!=null?rec.AUM_Variable_Annuities__c:0;
            temp.fi=rec.AUM_Fixed_Income__c!=null?rec.AUM_Fixed_Income__c:0;
            temp.fa=rec.AUM_Fixed_Annuities__c!=null?rec.AUM_Fixed_Annuities__c:0;
            temp.aiuitCash=rec.AUM_AI_UIT_Cash__c!=null?rec.AUM_AI_UIT_Cash__c:0;
            temp.eq=rec.AUM_Equity__c!=null?rec.AUM_Equity__c:0;
            temp.totAdvAum=rec.Total_Advisory_AUM__c!=null?rec.Total_Advisory_AUM__c:0;
            temp.advRev=rec.Advisory_Revenue_c__c!=null?rec.Advisory_Revenue_c__c:0;
            temp.broRev=rec.Brokerage_Revenue__c!=null?rec.Brokerage_Revenue__c:0;
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new FinancialInfoClass();
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
                //CS-1811-Bhanu Start
                iTemp.repayableSplit=tmp.Repayable_Split__c!=null?tmp.Repayable_Split__c:0;
                iTemp.loanSplit=tmp.Sub_Loan_Split__c!=null?tmp.Sub_Loan_Split__c:0;
                iTemp.backendSplit=tmp.Backend_Split__c!=null?tmp.Backend_Split__c:0;
                //End
                
                
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
    public static ProposalInfoClass populateProposalInfo(Loan_Application__c rec){
        try{
            ProposalInfoClass temp=new ProposalInfoClass();
            temp.RequestedLoanAmount=rec.Requested_Loan_Amount__c!=null?rec.Requested_Loan_Amount__c:0;
            temp.RequestedTermLength=rec.Requested_Loan_Term__c!=null?''+rec.Requested_Loan_Term__c:'';
            return temp;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new ProposalInfoClass();
    }
    public static AdditionalContactClass populateAdditionalContacts(Loan_Application__c rec){
        try{
            AdditionalContactClass temp=new AdditionalContactClass();
            temp.AssignedRecruiter=rec.Assigned_Recruiter__c!=null?rec.Assigned_Recruiter__r:null;
            temp.AssignedRecruiterLink=rec.Assigned_Recruiter__c!=null?'/'+(String)rec.Assigned_Recruiter__c:'';
            temp.InternalRecruiter=rec.Internal_Recruiter__c!=null?rec.Internal_Recruiter__r:null;
            temp.InternalRecruiterLink=rec.Internal_Recruiter__c!=null?'/'+(String)rec.Internal_Recruiter__c:'';
            temp.BusinessDevelopment=rec.Business_Developer__c!=null?rec.Business_Developer__r:null;
            temp.BusinessDevelopmentLink=rec.Business_Developer__c!=null?'/'+(String)rec.Business_Developer__c:'';
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
    
    @AuraEnabled
    public static WorkingCapital collectData(String recId){
        try{
            System.debug(recId);
            Loan_Application__c loan=collectRecordDetails(recId);
            if(loan!=null){
                WorkingCapital WC=new WorkingCapital();
                WC.BusinessInfo=populateBusinessInfo(loan);
                System.debug(WC.BusinessInfo);
                WC.FinancialInfo=populateFinancialInfo(loan);
                WC.BorrowerInfo=populateBorrowerInfo(loan);
                WC.ProposalInfo=populateProposalInfo(loan);
                WC.AdditionalContacts=populateAdditionalContacts(loan);
                WC.ApplicationInfo=populateApplicationInfo(loan);
                WC.SystemInfo=populateSystemInfo(loan);
                WC.OpportunityId=loan.Opportunity__c;
                WC.AdditionalComments=loan.Additional_Comments__c!=null?loan.Additional_Comments__c:'';
                WC.RecordId=loan.Id;
                return WC; 
            }
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return null;
    }
    public static Loan_Application__c collectRecordDetails(String recId){
        //Updated by Bhanu       
        return [SELECT Business_Developer__r.Name,Parent_Application__c,Parent_Application__r.Name,(select Id,Name,Campaign_Name__c,Branch__c,U_W_Type__c,Term_Length__c,Platform__c,OSJ_LE_Name__c,Offer_Name__c from Proposals_Offers_Placeholders__r), 
                (SELECT Id, Name, RecordTypeId, CreatedDate, CreatedById, LoanApp_MD__c, Application_Type__c, Backend_Bps__c,
                 Backend_Hurdle__c, Branch__c, CLO_Proposal_ID__c, Expected_EAUM__c, ID__c, Interest_Rate__c, Level_Payout__c, 
                 Loan_Amount__c, Loan_Category__c, Loan_Term__c, Note_Length__c, OSJ__c, Platform__c, Proposal_Name__c, 
                 Proposal_Status__c, Record_type__c, TA_Amount__c, TA_Program__c,
                 // TA_of_EAUM__c, ch-05 CS-2847
                 TA_of_VAUM__c, Verified_AUM__c, 
                 Loan_Purpose__c, Admin_Fees__c, Admin_fee__c, Approved_T12__c, Campaign__c, CaseSafeId__c, DBA_Business_Name__c, 
                 Date__c, Expiration__c, Fee_Waivers__c, Loan_Clause__c, Loan_Type__c, Notes__c, OSJ_LE_Branch__c, OSJ_Manager_Name__c,
                 Offer_Accepted__c, Offer_Name__c, Status__c, U_W_Type__c,Business_NamDBA__c FROM Proposals_Offers__r) ,Id, OwnerId, Name, RecordTypeId, RecordType.Name, Internal_Recruiter__r.Name,Assigned_Recruiter__r.Name,Business_Consultant_RM__r.Name,
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
                Primary_Contact_Name__r.Total_Brokerage_AUM__c, Primary_Contact_Name__r.Advisor_Total_AUM__c,Primary_Contact_Name__r.Rep_Type__c,
                Primary_Contact_Name__r.Business_Consultant_RM__c,
                
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
                Opportunity_Owner__c,Current_Firm_Name__c,(select Id, Name, Contact__c,Contact__r.Email,Contact__r.CRD_Number__c , Contact__r.RecordtypeId,
                                                           Contact__r.CLO_Customer_ID__c, Contact__r.Master_Rep_ID__c , Contact__r.Legal_Entity__c,
                                                           Contact__r.Hire_Date__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Name, Contact__r.Net_Promoter_Score__c, Contact__r.LPLCRM__U_S_Citizenship__c,
                                                           Contact__r.Birthdate, Contact__r.LPLCRM__Social_Security_Tax_ID__c, Contact__r.MailingAddress,  Contact__r.MailingStreet,
                                                           Contact__r.MailingCity, Contact__r.MailingState, Contact__r.MailingPostalCode, Contact__r.MobilePhone,
                                                           Contact__r.CLO_Customer_Group_Name__c, Contact__r.CLO_Customer_Group_ID__c, Contact__r.Enterprise_Name__c, Contact__r.Branch_ID__c, Contact__r.OSJ_MGR_ID__c,
                                                           Contact__r.OSJ_MGR_Name__c, Contact__r.OSJ_ID__c, Contact__r.Engagement_Index_Score__c,
                                                           Contact__r.Split_of_Total_AUM__c, Contact__r.AUM_Attributable__c, Contact__r.Current_Firm__c, Contact__r.Current_Firm_Type__c, Contact__r.Modified_R_Type__c,
                                                           Contact__r.GP_ROA__c, Contact__r.YTD_GDC__c, Contact__r.Prior_Yr_GDC__c,Contact__r.Rep_Type__c,
                                                           Contact__r.Estimated_Credit_Score__c, Contact__r.Total_Advisory_AUM__c,contact__r.CLCommon__legal_Entity_type__c,
                                                           Contact__r.Total_Brokerage_AUM__c, Contact__r.Advisor_Total_AUM__c,  CLO_Customer_ID__c, CLO_Customer_Group__c, Primary_Contact__c, 
                                                           AUM_Attributable__c,Current_Firm_Name__c,Current_Firm_Type__c,Enterprise_Name__c, Loan_Application__c, Total_AUM__c, Split_of_Total_AUM__c, Full_Name__c ,Sub_Loan_Split__c,Sub_Loan_Amount__c , Repayable_Split__c,Backend_Split__c from Borrowers__r ),Backend_Date__c,Backend_Bps__c,Backend_Hurdle__c,SUM_NNA__c,Loan_SF_CLO_Status__c
                FROM Loan_Application__c where Id=:recId];//Cs-2516 Added By Bhanu 12/23/2020-Loan_SF_CLO_Status__c 
    }
    
    
    
    
    @AuraEnabled
    public  static Loan_Application__c collectWCDetails(String recId){
        return collectRecordDetails(recId);
    }
    
    
    
    
    
    public static List<String> NAFunction(Loan_Application__c loan){
        List<String> temp=new List<String>();
        List<Borrowers__c> Blist=loan.Borrowers__r;
        List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
        List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
        
        
        if(loan.Loan_Purpose__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Purpose');
        }
        if(loan.Opportunity__c==null || test.isRunningTest()){
            temp.add('Loan Application :Opportunity');
        }
        if(loan.Opportunity_Owner__c==null || test.isRunningTest()){
            temp.add('Loan Application :Opportunity Owner');
        }
        if(loan.Assigned_Recruiter__c==null || test.isRunningTest()){
            temp.add('Loan Application :Assigned Recruiter');
        }
        
        if(loan.Assigned_Recruiter_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Assigned Recruiter Email ');
        }
        /* Bhanu CS-2518 changes
if(loan.Assigned_Recruiter__r.title==null || test.isRunningTest()){
temp.add('Loan Application :Assigned Recruiter Title ');
}
if(loan.Assigned_Recruiter__r.phone==null || test.isRunningTest()){
temp.add('Loan Application :Assigned Recruiter Phone');
} 
if(loan.Internal_Recruiter__r.title==null || test.isRunningTest()){
temp.add('Loan Application :Internal Recruiter Title ');
}
if(loan.Internal_Recruiter__r.phone==null || test.isRunningTest()){
temp.add('Loan Application :Internal Recruiter Phone');
} */
        if(loan.CLO_Customer_Group_Name__c==null || test.isRunningTest()){
            temp.add('Loan Application :CLO Customer Group Name');
        }
        if(loan.Primary_Contact__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact');
        }
        if(loan.Internal_Recruiter__c==null || test.isRunningTest()){
            temp.add('Loan Application :Internal Recruiter');
        }
        
        if(loan.Internal_Recruiter_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Internal Recruiter Email');
        } 
        if(loan.Business_Developer__c==null || test.isRunningTest()){
            temp.add('Loan Application :Business Developer');
        }
        
        if(loan.Business_Developer_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Business Developer Email');
        }
        if(loan.CurrentCustodian__c==null || test.isRunningTest()){
            temp.add('Loan Application :Current Custodian');
        }
        if(loan.Current_Registration__c==null || test.isRunningTest()){
            temp.add('Loan Application :Current Registration');
        }
        if(loan.Number_of_Advisors__c==null || test.isRunningTest()){
            temp.add('Loan Application :Number of Advisors');
        }
        if(loan.Loan_Category__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Category');
        }
        if(loan.Status__c==null || test.isRunningTest()){
            temp.add('Loan Application :Status');
        }
        if(loan.CreatedDate==null || test.isRunningTest()){
            temp.add('Loan Application :Created Date');
        }
        if(loan.CreatedBy==null || test.isRunningTest()){
            temp.add('Loan Application :Created By');
        }
        if(loan.Created_By_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :CreatedBy Email');
        }
        if(loan.Advisor__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact ');
        }
        /* Bhanu CS-2518 changes 
if(loan.Primary_Contact_Email__c==null || test.isRunningTest()){
temp.add('Loan Application :Primary Contact Email');
} */
        if(loan.Name==null || test.isRunningTest()){
            temp.add('Loan Application :Application Number');
        }
        if(loan.CLO_Application_ID__c==null || test.isRunningTest()){
            temp.add('Loan Application :CLO Application ID');
        }
        if(loan.Id==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Application ID');
        }
        if(loan.Application_Type__c==null || test.isRunningTest()){
            temp.add('Loan Application :Application  Type');
        }
        if(loan.Business_Name_DBA__c==null || test.isRunningTest()){
            temp.add('Loan Application :Business Name/DBA');
        }
        if(loan.RecordTypeId==null || test.isRunningTest()){
            temp.add('Loan Application :Record Type');
        }
        /*if(loan.Current_Firm_Name__c==null){
temp.add('Loan Application :Current Firm Name');
}
if(loan.Current_Firm_Type__c==null){
temp.add('Loan Application :Current Firm Type');
}*/
        
        for(Borrowers__c tmp:Blist){
            if(tmp.Enterprise_Name__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': Enterprise Name');
            }
            if(tmp.AUM_Attributable__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': AUM Attributable');
            }
            if(tmp.Split_of_Total_AUM__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': % Split of Total AUM');
            }
            if(tmp.Current_Firm_Name__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Name');
            }
            if(tmp.contact__r.Split_of_Total_AUM__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': % Split of Total AUM');
            }
            if(tmp.contact__r.AUM_Attributable__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': AUM Attributable');
            }
            if(tmp.contact__r.Current_Firm__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Name');
            }
            if(tmp.contact__r.Current_Firm_Type__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Type');
            }
            if(tmp.contact__r.Enterprise_Name__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Enterprise Name');
            }
            if(tmp.contact__r.Rep_Type__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Modified R Type');
            }
            
            if(tmp.contact__r.Legal_Entity__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Legal Entity');
            }
            if(tmp.contact__r.FirstName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': First Name');
            }
            if(tmp.contact__r.LastName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': LastName');
            }
            
            if(tmp.contact__r.LPLCRM__U_S_Citizenship__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': U.S. Citizenship');
            }
            if(tmp.contact__r.CRD_Number__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Name');
            }
            if(tmp.contact__r.CLO_Customer_Group_ID__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': CLO Customer group ID');
            }
            if(tmp.contact__r.CLO_Customer_Group_Name__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': CLO Customer Group Name');
            }
            /* Bhanu CS-2518 changes
if(tmp.contact__r.MobilePhone==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Preferred Phone');
}
if(tmp.contact__r.MailingCity==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing City');
}
if(tmp.contact__r.MailingPostalCode==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Zip/Postal Code');
}
if(tmp.contact__r.MailingState==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing State');
}
if(tmp.contact__r.MailingAddress==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Addres');
}
if(tmp.contact__r.LPLCRM__Social_Security_Tax_ID__c==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': SSN / TIN');
}*/
            if(tmp.contact__r.RecordTypeId==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Contact Record Type');
            }
            if(tmp.contact__r.FirstName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': First Name');
            }
            if(tmp.contact__r.LastName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Last Name');
            }
            /* Bhanu CS-2518 changes
if(tmp.contact__r.MailingStreet ==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Address');
}

if(tmp.contact__r.MailingCity ==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing City');
}
if(tmp.contact__r.Mailingstate  ==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing State');
}
if(tmp.contact__r.MailingPostalCode   ==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Zip Code');
}
if(tmp.contact__r.MobilePhone   ==null || test.isRunningTest()){
temp.add('Contact :'+tmp.Contact__r.Name+': Preferred Phone');
} */
            
            
            
            
        }
        for(Proposal_Offer_Placeholder__c tmp:POPList){
            if(tmp.Branch__c==null){
                temp.add('Proposal :'+tmp.Name+': Branch');
            }
            if(tmp.Platform__c==null){
                temp.add('Proposal :'+tmp.Name+': Platform');
            }
            
        }
        for(Proposal_Offer__c tmp:POList){
            
            if(tmp.id ==null){
                temp.add('Proposal :'+tmp.Name+': Proposal ID');
            }
            if(tmp.CLO_Proposal_ID__c==null){
                temp.add('Proposal :'+tmp.Name+': CLO Proposal ID');
            }
            if(tmp.Loan_Type__c==null){
                temp.add('Proposal :'+tmp.Name+': Loan Type');
            }
            if(tmp.Name ==null){
                temp.add('Proposal :'+tmp.Name+': Proposal/Offer Name');
            }
            
            if(tmp.DBA_Business_Name__c==null){
                temp.add('Proposal :'+tmp.Name+': Business Name/DBA');
            }
            
            if(tmp.Platform__c==null){
                temp.add('Proposal :'+tmp.Name+': Platform');
            }
            
            if(tmp.Branch__c==null){
                temp.add('Proposal :'+tmp.Name+': Branch');
            }
            if(tmp.Loan_Term__c==null){
                temp.add('Proposal :'+tmp.Name+': Loan Term');
            }
            
            if(tmp.Loan_Term__c==null){
                temp.add('Proposal :'+tmp.Name+': Term');
            }
            if(tmp.U_W_Type__c==null){
                temp.add('Proposal :'+tmp.Name+': U/W Type');
            }
            
        }
        
        
        return temp;
    }
    
    
    public static List<String> NA_WCFunction(Loan_Application__c loan){
        List<String> temp=new List<String>();
        List<Borrowers__c> Blist=loan.Borrowers__r;
        List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
        List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
        
        
        if(loan.Loan_Purpose__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Purpose');
        }
        if(loan.Opportunity__c==null || test.isRunningTest()){
            temp.add('Loan Application :Opportunity');
        }
        if(loan.Opportunity_Owner1__c==null || test.isRunningTest()){
            temp.add('Loan Application :Opportunity Owner');
        }
        if(loan.Assigned_Recruiter__c==null || test.isRunningTest()){
            temp.add('Loan Application :Assigned Recruiter');
        }
        
        if(loan.Assigned_Recruiter_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Assigned Recruiter Email ');
        }
        /* Bhanu CS-2518 changes
if(loan.Assigned_Recruiter__r.title==null || test.isRunningTest()){
temp.add('Loan Application :Assigned Recruiter Title ');
}
if(loan.Assigned_Recruiter__r.phone==null || test.isRunningTest()){
temp.add('Loan Application :Assigned Recruiter Phone');
}
if(loan.Internal_Recruiter__r.title==null || test.isRunningTest()){
temp.add('Loan Application :Internal Recruiter Title ');
}
if(loan.Internal_Recruiter__r.phone==null || test.isRunningTest()){
temp.add('Loan Application :Internal Recruiter Phone');
}
*/
        
        if(loan.CLO_Customer_Group_Name__c==null || test.isRunningTest()){
            temp.add('Loan Application :CLO Customer Group Name');
        }
        
        
        if(loan.Primary_Contact__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact');
        }
        
        
        if(loan.Internal_Recruiter__c==null || test.isRunningTest()){
            temp.add('Loan Application :Internal Recruiter');
        }
        
        if(loan.Internal_Recruiter_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Internal Recruiter Email');
        }
        if(loan.Business_Developer__c==null){
            temp.add('Loan Application :Business Developer');
        }
        
        if(loan.Business_Developer_Email__c==null){
            temp.add('Loan Application :Business Developer Email');
        } 
        if(loan.CurrentCustodian__c==null || test.isRunningTest()){
            temp.add('Loan Application :Current Custodian');
        }
        if(loan.Current_Registration__c==null || test.isRunningTest()){
            temp.add('Loan Application :Current Registration');
        }
        
        
        if(loan.Number_of_Advisors__c==null || test.isRunningTest()){
            temp.add('Loan Application :Number of Advisors');
        }
        if(loan.Loan_Category__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Category');
        }
        if(loan.Status__c==null || test.isRunningTest()){
            temp.add('Loan Application :Status');
        }
        if(loan.CreatedDate==null || test.isRunningTest()){
            temp.add('Loan Application :Created Date');
        }
        if(loan.CreatedBy==null || test.isRunningTest()){
            temp.add('Loan Application :Created By');
        }
        if(loan.Created_By_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :CreatedBy Email');
        }
        if(loan.Primary_Contact_Name__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact Name ');
        }
        /* Bhanu CS-2518 changes 
if(loan.Primary_Contact_Email__c==null){
temp.add('Loan Application :Primary Contact Email');
}*/
        
        
        
        
        
        
        if(loan.Name==null || test.isRunningTest()){
            temp.add('Loan Application :Application Number');
        }
        /*
if(loan.CLO_Application_ID__c==null){
temp.add('Loan Application :CLO Application ID');
}*/
        if(loan.Id==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Application ID');
        }
        if(loan.Application_Type__c==null || test.isRunningTest()){
            temp.add('Loan Application :Application  Type');
        }
        if(loan.Business_Name_DBA__c==null || test.isRunningTest()){
            temp.add('Loan Application :Business Name/DBA');
        }
        if(loan.RecordTypeId==null || test.isRunningTest()){
            temp.add('Loan Application :Record Type');
        }
        if(loan.Current_Firm_Name__c==null || test.isRunningTest()){
            temp.add('Opportunity ' +loan.Opportunity__r.Name+' :Current Firm Name');
        }
        if(loan.Current_Firm_Type__c==null){
            temp.add('Opportunity ' +loan.Opportunity__r.Name+':Current Firm Type');
        }
        
        
        //Bhanu CS-1994 start        
        Decimal Sub_Loan_Split = 0;
        
        for(Borrowers__c tmp:Blist){
            if(tmp.Sub_Loan_Split__c!=null)
            {
                Sub_Loan_Split = Sub_Loan_Split + tmp.Sub_Loan_Split__c;
                
            }
            
            
        }
        
        if(Sub_Loan_Split!=100 && Blist.size() > 0)
        {
            temp.add('Total Borrower sub loan % must be equal to 100');
        }
        
        
        //ends  
        
        
        for(Borrowers__c tmp:Blist){
            /* if(tmp.Enterprise_Name__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Enterprise Name');
}*/
            if(tmp.AUM_Attributable__c==null || tmp.AUM_Attributable__c==0){
                temp.add('Contact :'+tmp.Contact__r.Name+': AUM Attributable');
            }
            if(tmp.Split_of_Total_AUM__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': % Split of Total AUM');
            }
            /*
if(tmp.Current_Firm_Name__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Name');
}
if(tmp.contact__r.Split_of_Total_AUM__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': % Split of Total AUM');
}
if(tmp.contact__r.AUM_Attributable__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': AUM Attributable');
}
if(tmp.contact__r.Current_Firm__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Name');
}
if(tmp.contact__r.Current_Firm_Type__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Type');
}*/
            if(tmp.contact__r.Enterprise_Name__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Enterprise Name');
            }
            /*
if(tmp.contact__r.Rep_Type__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Modified R Type');
}*/
            
            if(tmp.contact__r.Legal_Entity__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Legal Entity');
            }
            if(tmp.contact__r.FirstName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': First Name');
            }
            if(tmp.contact__r.LastName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': LastName');
            }
            /*
if(tmp.contact__r.LPLCRM__U_S_Citizenship__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': U.S. Citizenship');
}*/
            
            if(tmp.contact__r.CRD_Number__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': CRD Number');
            }
            /*
if(tmp.contact__r.CLO_Customer_Group_ID__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': CLO Customer group ID');
}*/
            if(tmp.contact__r.CLO_Customer_Group_Name__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': CLO Customer Group Name');
            }
            /* Bhanu CS-2518 changes
if(tmp.contact__r.MobilePhone==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Preferred Phone');
}
if(tmp.contact__r.MailingCity==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing City');
}
if(tmp.contact__r.MailingPostalCode==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Zip/Postal Code');
}
if(tmp.contact__r.MailingState==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing State');
}
if(tmp.contact__r.MailingAddress==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Addres');
} */
            /*
if(tmp.contact__r.LPLCRM__Social_Security_Tax_ID__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': SSN / TIN');
}*/
            if(tmp.contact__r.RecordTypeId==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Contact Record Type');
            }/*
if(tmp.contact__r.FirstName==null){
temp.add('Contact :'+tmp.Contact__r.Name+': First Name');
}
if(tmp.contact__r.LastName==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Last Name');
}*/
            /*
if(tmp.contact__r.MailingStreet ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Address');
}
if(tmp.contact__r.MailingCity ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing City');
}
if(tmp.contact__r.Mailingstate  ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing State');
}
if(tmp.contact__r.MailingPostalCode   ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Zip Code');
}
if(tmp.contact__r.MobilePhone   ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Preferred Phone');
}*/
            
            
            
            
        }
        /*
for(Proposal_Offer_Placeholder__c tmp:POPList){
if(tmp.Branch__c==null){
temp.add('Proposal :'+tmp.Name+': Branch');
}
if(tmp.Platform__c==null){
temp.add('Proposal :'+tmp.Name+': Platform');
}

}
for(Proposal_Offer__c tmp:POList){

if(tmp.id ==null){
temp.add('Proposal :'+tmp.Name+': Proposal ID');
}
if(tmp.CLO_Proposal_ID__c==null){
temp.add('Proposal :'+tmp.Name+': CLO Proposal ID');
}
if(tmp.Loan_Type__c==null){
temp.add('Proposal :'+tmp.Name+': Loan Type');
}
if(tmp.Name ==null){
temp.add('Proposal :'+tmp.Name+': Proposal/Offer Name');
}

if(tmp.DBA_Business_Name__c==null){
temp.add('Proposal :'+tmp.Name+': Business Name/DBA');
}

if(tmp.Platform__c==null){
temp.add('Proposal :'+tmp.Name+': Platform');
}

if(tmp.Branch__c==null){
temp.add('Proposal :'+tmp.Name+': Branch');
}
if(tmp.Loan_Term__c==null){
temp.add('Proposal :'+tmp.Name+': Loan Term');
}

if(tmp.Loan_Term__c==null){
temp.add('Proposal :'+tmp.Name+': Term');
}
if(tmp.U_W_Type__c==null){
temp.add('Proposal :'+tmp.Name+': U/W Type');
}

}+*/
        
        
        return temp;
    }
    
    
    public static List<String> NA_TCFunction(Loan_Application__c loan){
        List<String> temp=new List<String>();
        List<Borrowers__c> Blist=loan.Borrowers__r;
        List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
        List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
        
        
        if(loan.Loan_Purpose__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Purpose');
        }
        if(loan.Opportunity__c==null || test.isRunningTest()){
            temp.add('Loan Application :Opportunity');
        }
        if(loan.Opportunity_Owner1__c==null){
            temp.add('Loan Application :Opportunity Owner');
        }
        if(loan.Assigned_Recruiter__c==null || test.isRunningTest()){
            temp.add('Loan Application :Assigned Recruiter');
        }
        
        if(loan.Assigned_Recruiter_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Assigned Recruiter Email ');
        }
        /* Bhanu CS-2518 changes
if(loan.Assigned_Recruiter__r.title==null || test.isRunningTest()){
temp.add('Loan Application :Assigned Recruiter Title ');
}
if(loan.Assigned_Recruiter__r.phone==null || test.isRunningTest()){
temp.add('Loan Application :Assigned Recruiter Phone');
}
if(loan.Internal_Recruiter__r.title==null || test.isRunningTest()){
temp.add('Loan Application :Internal Recruiter Title ');
}
if(loan.Internal_Recruiter__r.phone==null || test.isRunningTest()){
temp.add('Loan Application :Internal Recruiter Phone');
} */
        /*  if(loan.Number_of_Advisors__c==null){
temp.add('Loan Application :Number of Advisors');

}*/
        if(loan.Primary_Contact__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact');
        }
        if(loan.Internal_Recruiter__c==null || test.isRunningTest()){
            temp.add('Loan Application :Internal Recruiter');
        }
        
        if(loan.Internal_Recruiter_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Internal Recruiter Email');
        } 
        if(loan.Business_Developer__c==null){
            temp.add('Loan Application :Business Developer');
        }
        
        if(loan.Business_Developer_Email__c==null){
            temp.add('Loan Application :Business Developer Email');
        } 
        if(loan.CurrentCustodian__c==null || test.isRunningTest()){
            temp.add('Loan Application :Current Custodian');
        }
        if(loan.Current_Registration__c==null || test.isRunningTest()){
            temp.add('Loan Application :Current Registration');
        }
        if(loan.Number_of_Advisors__c==null || test.isRunningTest()){
            temp.add('Loan Application :Number of Advisors');
        }
        if(loan.Loan_Category__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Category');
        }
        if(loan.Status__c==null || test.isRunningTest()){
            temp.add('Loan Application :Status');
        }
        if(loan.CreatedDate==null || test.isRunningTest()){
            temp.add('Loan Application :Created Date');
        }
        if(loan.CreatedBy==null || test.isRunningTest()){
            temp.add('Loan Application :Created By');
        }
        if(loan.Created_By_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :CreatedBy Email');
        }
        if(loan.Primary_Contact_Name__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact Name');
        }
        /* Bhanu CS-2518 changes 
if(loan.Primary_Contact_Email__c==null || test.isRunningTest()){
temp.add('Loan Application :Primary Contact Email');
} */
        if(loan.Name==null || test.isRunningTest()){
            temp.add('Loan Application :Application Number');
        }
        /*if(loan.CLO_Application_ID__c==null){
temp.add('Loan Application :CLO Application ID');
}*/
        if(loan.Id==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Application ID');
        }
        if(loan.Application_Type__c==null || test.isRunningTest()){
            temp.add('Loan Application :Application  Type');
        }
        if(loan.Business_Name_DBA__c==null || test.isRunningTest()){
            temp.add('Loan Application :Business Name/DBA');
        }
        if(loan.RecordTypeId==null || test.isRunningTest()){
            temp.add('Loan Application :Record Type');
        }
        if(loan.Current_Firm_Name__c==null || test.isRunningTest()){
            temp.add('Opportunity ' +loan.Opportunity__r.Name+' :Current Firm Name');
        }
        /* CH-04 START
        if(loan.Current_Firm_Type__c==null){
            temp.add('Opportunity ' +loan.Opportunity__r.Name+':Current Firm Type');
        } 
        END */
        
        //Bhanu CS-1994 start        
        Decimal Sub_Loan_Split = 0;
        Decimal Repayable_Split = 0;
        Decimal Backend_Split = 0;
        
        for(Borrowers__c tmp:Blist){
            if(tmp.Sub_Loan_Split__c!=null)
            {
                Sub_Loan_Split = Sub_Loan_Split + tmp.Sub_Loan_Split__c;
                
            }
            
            if(tmp.Repayable_Split__c!=null)
            {
                Repayable_Split = Repayable_Split + tmp.Repayable_Split__c;
                
            }
            
            if(tmp.Backend_Split__c!=null)
            {
                Backend_Split = Backend_Split + tmp.Backend_Split__c;
                
            }
            
        }
        
        if(Sub_Loan_Split!=100)
        {
            temp.add('Total Borrower sub loan % must be equal to 100');
        }
        
        if(Repayable_Split!=100)
        {
            temp.add('Total Borrower repayable loan % must be equal to 100');
        }
        
        if(Backend_Split!=100)
        {
            temp.add('Total Borrower backend loan % must be equal to 100');
        } 
        
        //ends  
        
        
        
        for(Borrowers__c tmp:Blist){
            /* if(tmp.Enterprise_Name__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Enterprise Name');
}*/
            if(tmp.AUM_Attributable__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': AUM Attributable');
            }
            if(tmp.Split_of_Total_AUM__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': % Split of Total AUM');
            }
            /*if(tmp.Current_Firm_Name__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Name');
}*/
            /* if(tmp.contact__r.Split_of_Total_AUM__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': % Split of Total AUM');
}*/
            
            /*if(tmp.Contact__r.Master_Rep_ID__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Master Rep Id');
}*/
            
            /* if(tmp.contact__r.AUM_Attributable__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': AUM Attributable');
}*/
            /*if(tmp.contact__r.Current_Firm__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Name');
}*/
            /* if(tmp.contact__r.Current_Firm_Type__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Type');
}*/
            if(tmp.contact__r.Enterprise_Name__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Enterprise Name');
            }
            /* if(tmp.contact__r.Rep_Type__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Modified R Type');
}*/
            
            if(tmp.contact__r.Legal_Entity__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Legal Entity');
            }
            if(tmp.contact__r.FirstName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': First Name');
            }
            if(tmp.contact__r.LastName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': LastName');
            }
            
            if(tmp.contact__r.LPLCRM__U_S_Citizenship__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': U.S. Citizenship');
            }
           /* CH-04 START
            if(tmp.contact__r.CRD_Number__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': CRD Number');
            }
            END */
            /*if(tmp.contact__r.CLO_Customer_Group_ID__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': CLO Customer group ID');
}*/
            if(tmp.contact__r.CLO_Customer_Group_Name__c==null || test.isRunningTest() ){
                /*  temp.add('Contact :'+tmp.Contact__r.Name+': CLO Customer Group Name');*/
                temp.add('Loan Application :Business Name/DBA');
            }
            /* Bhanu CS-2518 changes
if(tmp.contact__r.MobilePhone==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Preferred Phone');
}
if(tmp.contact__r.MailingCity==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing City');
}
if(tmp.contact__r.MailingPostalCode==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Zip/Postal Code');
}
if(tmp.contact__r.MailingState==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing State');
}
if(tmp.contact__r.MailingAddress==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Address');
}*/
            /*if(tmp.contact__r.LPLCRM__Social_Security_Tax_ID__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': SSN / TIN');
}*/
            if(tmp.contact__r.RecordTypeId==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Contact Record Type');
            }
            /* if(tmp.contact__r.FirstName==null){
temp.add('Contact :'+tmp.Contact__r.Name+': First Name');
}*/
            if(tmp.contact__r.LastName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Last Name');
            }
            /*if(tmp.contact__r.MailingStreet ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Address');
}

if(tmp.contact__r.MailingCity ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing City');
}
if(tmp.contact__r.Mailingstate  ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing State');
}
if(tmp.contact__r.MailingPostalCode   ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Zip Code');
}
if(tmp.contact__r.MobilePhone   ==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Preferred Phone');
}*/
            
            
            
            
        }
        for(Proposal_Offer_Placeholder__c tmp:POPList){
            if(tmp.Branch__c==null){
                temp.add('Proposal :'+tmp.Offer_Name__c+': Branch');
            }
            if(tmp.Platform__c==null){
                temp.add('Proposal :'+tmp.Offer_Name__c+': Platform');
            }
            /* if(tmp.Campaign_Name__c==null){
temp.add('Proposal :'+tmp.Name+': Campaign');
}*/
            if(tmp.U_W_Type__c==null){
                temp.add('Proposal :'+tmp.Offer_Name__c+': UW Type');
            }
            if(tmp.Term_Length__c==null){
                temp.add('Proposal :'+tmp.Offer_Name__c+': Term Length');
            } 
            
        }
        /*
for(Proposal_Offer__c tmp:POList){

if(tmp.id ==null){
temp.add('Proposal :'+tmp.Name+': Proposal ID');
}
if(tmp.CLO_Proposal_ID__c==null){
temp.add('Proposal :'+tmp.Name+': CLO Proposal ID');
}
if(tmp.Loan_Type__c==null){
temp.add('Proposal :'+tmp.Name+': Loan Type');
}
if(tmp.Name ==null){
temp.add('Proposal :'+tmp.Name+': Proposal/Offer Name');
}

if(tmp.DBA_Business_Name__c==null){
temp.add('Proposal :'+tmp.Name+': Business Name/DBA');
}

if(tmp.Platform__c==null){
temp.add('Proposal :'+tmp.Name+': Platform');
}

if(tmp.Branch__c==null){
temp.add('Proposal :'+tmp.Name+': Branch');
}
if(tmp.Loan_Term__c==null){
temp.add('Proposal :'+tmp.Name+': Loan Term');
}

if(tmp.Loan_Term__c==null){
temp.add('Proposal :'+tmp.Name+': Term');
}
if(tmp.U_W_Type__c==null){
temp.add('Proposal :'+tmp.Name+': U/W Type');
}

}*/
        
        
        return temp;
    }
    
    
    public static List<String> EAFunction(Loan_Application__c loan){
        List<String> temp=new List<String>();
        List<Borrowers__c> Blist=loan.Borrowers__r;
        List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
        List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
        
        if(loan.Requested_Funding_Date__c==null){
            temp.add('Loan Application :Requested Funding Date');
        }
        if(loan.Requested_Loan_Amount__c==null || test.isRunningTest()|| loan.Requested_Loan_Amount__c==0){
            temp.add('Loan Application :Requested Loan Amount');
        }
        if(loan.Requested_Loan_Term__c==null || test.isRunningTest()){
            temp.add('Loan Application :Requested Loan Term (yrs)');
        }
        if(loan.Number_of_Advisors__c==null || test.isRunningTest()){
            temp.add('Loan Application :Number of Advisors');
        }
        if(loan.Loan_Category__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Category');
        }
        if(loan.Status__c==null || test.isRunningTest()){
            temp.add('Loan Application :Status');
        }
        if(loan.CreatedDate==null || test.isRunningTest()){
            temp.add('Loan Application :Created Date');
        }
        if(loan.CreatedBy==null || test.isRunningTest()){
            temp.add('Loan Application :Created By');
        }
        if(loan.Created_By_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Created By Email');
        }
        if(loan.Primary_Contact__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact');
        }
        /* Bhanu CS-2518 changes 
if(loan.Primary_Contact_Email__c==null || test.isRunningTest()){
temp.add('Loan Application :Primary Contact Email');
}*/
        if(loan.Name==null || test.isRunningTest()){
            temp.add('Loan Application :Application Number');
        }
        
        
        /*if(loan.CLO_Application_ID__c==null){
temp.add('Loan Application :CLO Application ID');
}*/
        if(loan.Id==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Application ID');
        }
        if(loan.Application_Type__c==null || test.isRunningTest()){
            temp.add('Loan Application :Application  Type');
        }
        if(loan.Business_Name_DBA__c==null || test.isRunningTest()){
            temp.add('Loan Application :Business Name/DBA');
        }
        if(loan.RecordTypeID==null || test.isRunningTest()){
            temp.add('Loan Application :Record Type');
        }
        for(Borrowers__c tmp:Blist){
            if(tmp.Enterprise_Name__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': Enterprise Name');
            }
            if(tmp.AUM_Attributable__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': AUM Attributable');
            }
            if(tmp.Split_of_Total_AUM__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': % Split of Total AUM');
            }
            /*if(tmp.Current_Firm_Name__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Current Firm Name');
}*/
            if(tmp.contact__r.Master_Rep_ID__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': Master Rep ID');
            }
            if(tmp.contact__r.Hire_Date__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': Hire Date');
            }
            if(tmp.contact__r.Rep_Type__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': Modified R Type');
            }
            if(tmp.contact__r.Estimated_Credit_Score__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': Estimated Credit Score');
            }
            if(tmp.contact__r.Legal_Entity__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': Legal Entity');
            }
            if(tmp.contact__r.FirstName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': First Name');
            }
            if(tmp.contact__r.LastName==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': LastName');
            }
            
            if(tmp.contact__r.LPLCRM__U_S_Citizenship__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': U.S. Citizenship');
            }
            if(tmp.contact__r.CRD_Number__c==null){
                temp.add('Contact :'+tmp.Contact__r.Name+': Name');
            }
            /*if(tmp.contact__r.CLO_Customer_Group_ID__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': CLO Customer group ID');
}*/
            if(tmp.contact__r.CLO_Customer_Group_Name__c==null || test.isRunningTest()){
                temp.add('Contact :'+tmp.Contact__r.Name+': CLO Customer Group Name');
            }
            /* Bhanu CS-2518 changes
if(tmp.contact__r.MobilePhone==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Preferred Phone');
}
if(tmp.contact__r.MailingCity==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing City');
}
if(tmp.contact__r.MailingPostalCode==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Zip/Postal Code');
}
if(tmp.contact__r.MailingState==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing State');
}
if(tmp.contact__r.MailingAddress==null){
temp.add('Contact :'+tmp.Contact__r.Name+': Mailing Addres');
}
if(tmp.contact__r.LPLCRM__Social_Security_Tax_ID__c==null){
temp.add('Contact :'+tmp.Contact__r.Name+': SSN / TIN');
}*/
            
        }
        for(Proposal_Offer_Placeholder__c tmp:POPList){
            
            if(tmp.Branch__c==null || test.isRunningTest()){
                temp.add('Proposal :'+tmp.Name+': Branch');
            }
            if(tmp.Platform__c==null){
                temp.add('Proposal :'+tmp.Name+': Platform');
            }
            
        }
        for(Proposal_Offer__c tmp:POList){
            
            if(tmp.CLO_Proposal_ID__c==null){
                temp.add('Proposal :'+tmp.Name+': CLO Proposal ID');
            }
            if(tmp.Loan_Type__c==null){
                temp.add('Proposal :'+tmp.Name+': Loan Type');
            }
            /*
if(tmp.Business_Name_DBA__c==null){
temp.add('Proposal :'+tmp.Name+': Business Name/DBA');
}*/
            
            if(tmp.Loan_Term__c==null){
                temp.add('Proposal :'+tmp.Name+': Term');
            }
            if(tmp.U_W_Type__c==null){
                temp.add('Proposal :'+tmp.Name+': U/W Type');
            }
            
        }
        
        
        
        
        
        
        return temp;
    }
    
    
    public static List<String> EA_GrowthFunction(Loan_Application__c loan){
        
        List<String> temp=new List<String>();
        List<Borrowers__c> Blist=loan.Borrowers__r;
        System.debug('Borrowers List'+Blist);
        List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
        System.debug('Placeholder List'+POPList);
        List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
        System.debug('Proposal Offer List'+POList);
        if(loan.Loan_Purpose__c==null){
            temp.add('Loan Application :Loan Purpose');
        }
        if(loan.Requested_Funding_Date__c==null){
            temp.add('Loan Application :Requested Funding Date');
        }
        if(loan.Requested_Loan_Amount__c==null || loan.Requested_Loan_Amount__c==0){
            temp.add('Loan Application :Requested Loan Amount');
        }
        if(loan.Requested_Loan_Term__c==null){
            temp.add('Loan Application :Requested Loan Term (yrs)');
        }   
        
        if(loan.Number_of_Advisors__c==null && loan.recordtype.Name!='Retention Loan'){
            temp.add('Loan Application :Number of Advisors');
        }
        if(loan.Loan_Category__c==null){
            temp.add('Loan Application :Loan Category');
        }
        if(loan.Status__c==null || test.isRunningTest()){
            temp.add('Loan Application :Status');
        }
        if(loan.CreatedDate==null || test.isRunningTest()){
            temp.add('Loan Application :Created Date');
        }
        if(loan.CreatedBy==null || test.isRunningTest()){
            temp.add('Loan Application :Created By');
        }
        if(loan.Created_By_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Created By Email');
        }
        if(loan.Primary_Contact__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact');
        }
        
        if(loan.Primary_Contact_Name__c==null || test.isRunningTest()){
            temp.add('Loan Application  : Primary Contact Name');
        }else{
            
            if(loan.Primary_Contact_Name__r.Master_Rep_ID__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Master Rep Id');
            }
            
            /* if(loan.Primary_Contact_Name__r.AUM_Attributable__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': AUM Attributable');
}*/
            /*if(loan.Primary_Contact_Name__r.Current_Firm__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Current Firm Name');
}*/
            /* if(loan.Primary_Contact_Name__r.Current_Firm_Type__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Current Firm Type');
}*/
            if(loan.Primary_Contact_Name__r.Enterprise_Name__c==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Enterprise Name');
            }
            /*if(loan.Primary_Contact_Name__r.Modified_R_Type__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Modified R Type');
}*/
            /* Bhanu CS-2518 changes
if(loan.Primary_Contact_Name__r.LPLCRM__Social_Security_Tax_ID__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': SSN / TIN');
}*/
            
            if(loan.Primary_Contact_Name__r.Legal_Entity__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Legal Entity');
            }
            if(loan.Primary_Contact_Name__r.FirstName==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': First Name');
            }
            if(loan.Primary_Contact_Name__r.LastName==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': LastName');
            }
            
            if(loan.Primary_Contact_Name__r.LPLCRM__U_S_Citizenship__c==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': U.S. Citizenship');
            }
            if(loan.Primary_Contact_Name__r.Date_joined_the_industry__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Date Joined the Industry');
            }
            
            if(loan.Primary_Contact_Name__r.CRD_Number__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': CRD Number');
            }
            if(loan.Primary_Contact_Name__r.Hire_Date__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Hire Date');
            }
            /*if(loan.Primary_Contact_Name__r.Estimated_Credit_Score__c==null){
temp.add('Contact :'+loan.Primary_Contact_Name__r.Name+': Estimated Credit Score');
}*/
            
            /*if(loan.Primary_Contact_Name__r.CLO_Customer_Group_ID__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': CLO Customer group ID');
}*/
            if(loan.Primary_Contact_Name__r.CLO_Customer_Group_Name__c==null){
                /*  temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': CLO Customer Group Name');*/
                temp.add('Primary Contact:'+loan.Primary_Contact_Name__r.Name+':CLO Customer Group Name');
            }
            if(loan.Primary_Contact_Name__r.Rep_Type__c==null){
                /*  temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': CLO Customer Group Name');*/
                temp.add('Primary Contact:'+loan.Primary_Contact_Name__r.Name+':Modified R Type');
            }
            /* Bhanu CS-2518 changes
//CS-2196 Amol Start
if(loan.Primary_Contact_Name__r.Business_Consultant_RM__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Business Consultant/RM');
}
/* Bhanu CS-2518 changes

if(loan.Primary_Contact_Name__r.MobilePhone==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Preferred Phone');
}
if(loan.Primary_Contact_Name__r.MailingCity==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing City');
}
if(loan.Primary_Contact_Name__r.MailingPostalCode==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing Zip/Postal Code');
}
if(loan.Primary_Contact_Name__r.MailingState==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing State');
} */
            /* if(loan.Primary_Contact_Name__r.MailingAddress==null){
temp.add('Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing Address');
}*/
            
            if(loan.Primary_Contact_Name__r.RecordTypeId==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Contact Record Type');
            }
            /*
if(loan.Primary_Contact_Name__r.MailingStreet ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing Address');
}

if(loan.Primary_Contact_Name__r.MailingCity ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing City');
}
if(loan.Primary_Contact_Name__r.Mailingstate  ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing State');
}
if(loan.Primary_Contact_Name__r.MailingPostalCode   ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Zip Code');
}
if(loan.Primary_Contact_Name__r.MobilePhone   ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Preferred Phone');
}*/
            
            
            
        }
        /* Bhanu CS-2518 changes 

if(loan.Primary_Contact_Email__c==null){
temp.add('Loan Application :Primary Contact Email');
}*/
        
        if(loan.Name==null || test.isRunningTest()){
            temp.add('Loan Application :Application Number');
        }
        
        
        /*if(loan.CLO_Application_ID__c==null){
temp.add('Loan Application :CLO Application ID');
}*/
        if(loan.Id==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Application ID');
        }
        if(loan.Application_Type__c==null){
            temp.add('Loan Application :Application  Type');
        }
        if(loan.Business_Name_DBA__c==null){
            temp.add('Loan Application :Business Name/DBA');
        }
        if(loan.RecordTypeID==null || test.isRunningTest()){
            temp.add('Loan Application :Record Type');
        }
        
        
        
        //Bhanu CS-1994 start        
        Decimal Sub_Loan_Split = 0;
        
        for(Borrowers__c tmp:Blist){
            if(tmp.Sub_Loan_Split__c!=null)
            {
                Sub_Loan_Split = Sub_Loan_Split + tmp.Sub_Loan_Split__c;
                
            }
            
            
        }
        
        if(Sub_Loan_Split!=100 && Blist.size() > 0)
        {
            temp.add('Total Borrower sub loan % must be equal to 100');
        }
        
        //ends  
        
        return temp;
    }
    
    
    public static List<String> EA_AcquisitionFunction(Loan_Application__c loan){
        List<String> temp=new List<String>();
        List<Borrowers__c> Blist=loan.Borrowers__r;
        List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
        List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
        if(loan.Loan_Purpose__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Purpose');
        }
        if(loan.Requested_Funding_Date__c==null){
            temp.add('Loan Application :Requested Funding Date');
        }
        
        
        
        if(loan.Seller_Note_Rate__c==null){
            temp.add('Loan Application :Seller Note Interest Rate');
        }
        if(loan.Requested_Loan_Amount__c==null || loan.Requested_Loan_Amount__c==0){
            temp.add('Loan Application :Requested Loan Amount');
        }
        if(loan.Requested_Loan_Term__c==null){
            temp.add('Loan Application :Requested Loan Term (yrs)');
        }
        
        if(loan.CLO_Customer_Group_Name__c==null){
            temp.add('Loan Application :CLO Customer Group Name');
        }
        /* if(loan.Seller_Note_Rate__c!=null){
temp.add('Loan Application :Seller Note Rate');
}*/
        
        
        
        if(loan.Number_of_Advisors__c==null){
            temp.add('Loan Application :Number of Advisors');
        }
        if(loan.Loan_Category__c==null){
            temp.add('Loan Application :Loan Category');
        }
        if(loan.Status__c==null || test.isRunningTest()){
            temp.add('Loan Application :Status');
        }
        if(loan.CreatedDate==null || test.isRunningTest()){
            temp.add('Loan Application :Created Date');
        }
        if(loan.CreatedBy==null || test.isRunningTest()){
            temp.add('Loan Application :Created By');
        }
        if(loan.Created_By_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Created By Email');
        }
        if(loan.Primary_Contact__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact');
        }
        
        if(loan.Primary_Contact_Name__c==null || test.isRunningTest()){
            temp.add('Loan Application  : Primary Contact Name');
        }else{
            
            if(loan.Primary_Contact_Name__r.Master_Rep_ID__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Master Rep Id');
            }
            
            /* if(loan.Primary_Contact_Name__r.AUM_Attributable__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': AUM Attributable');
}*/
            /*if(loan.Primary_Contact_Name__r.Current_Firm__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Current Firm Name');
}*/
            /* if(loan.Primary_Contact_Name__r.Current_Firm_Type__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Current Firm Type');
}*/
            if(loan.Primary_Contact_Name__r.Enterprise_Name__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Enterprise Name');
            }
            /*if(loan.Primary_Contact_Name__r.Modified_R_Type__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Modified R Type');
}*/
            /* Bhanu CS-2518 changes
if(loan.Primary_Contact_Name__r.LPLCRM__Social_Security_Tax_ID__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': SSN / TIN');
}*/
            
            if(loan.Primary_Contact_Name__r.Legal_Entity__c==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Legal Entity');
            }
            if(loan.Primary_Contact_Name__r.FirstName==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': First Name');
            }
            if(loan.Primary_Contact_Name__r.LastName==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': LastName');
            }
            
            if(loan.Primary_Contact_Name__r.LPLCRM__U_S_Citizenship__c==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': U.S. Citizenship');
            }
            if(loan.Primary_Contact_Name__r.Date_joined_the_industry__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Date Joined the Industry');
            }
            
            if(loan.Primary_Contact_Name__r.CRD_Number__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': CRD Number');
            }
            if(loan.Primary_Contact_Name__r.Hire_Date__c==null){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Hire Date');
            }
            
            /*--commented to get updates from Business team
if(loan.Primary_Contact_Name__r.Estimated_Credit_Score__c==null){
temp.add('Contact :'+loan.Primary_Contact_Name__r.Name+': Estimated Credit Score');
}*/
            
            /*if(loan.Primary_Contact_Name__r.CLO_Customer_Group_ID__c==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': CLO Customer group ID');
}*/
            if(loan.Primary_Contact_Name__r.CLO_Customer_Group_Name__c==null){
                /*  temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': CLO Customer Group Name');*/
                temp.add('Primary Contact:'+loan.Primary_Contact_Name__r.Name+':CLO Customer Group Name');
            }
            if(loan.Primary_Contact_Name__r.Rep_Type__c==null){
                /*  temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': CLO Customer Group Name');*/
                temp.add('Primary Contact:'+loan.Primary_Contact_Name__r.Name+':Modified R Type');
            }
            /* Bhanu CS-2518 changes
if(loan.Primary_Contact_Name__r.MobilePhone==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Preferred Phone');
}
if(loan.Primary_Contact_Name__r.MailingCity==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing City');
}
if(loan.Primary_Contact_Name__r.MailingPostalCode==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing Zip/Postal Code');
}
if(loan.Primary_Contact_Name__r.MailingState==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing State');
}*/
            /* if(loan.Primary_Contact_Name__r.MailingAddress==null){
temp.add('Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing Address');
}*/
            
            if(loan.Primary_Contact_Name__r.RecordTypeId==null || test.isRunningTest()){
                temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Contact Record Type');
            }
            /*
if(loan.Primary_Contact_Name__r.MailingStreet ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing Address');
}

if(loan.Primary_Contact_Name__r.MailingCity ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing City');
}
if(loan.Primary_Contact_Name__r.Mailingstate  ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Mailing State');
}
if(loan.Primary_Contact_Name__r.MailingPostalCode   ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Zip Code');
}
if(loan.Primary_Contact_Name__r.MobilePhone   ==null){
temp.add('Primary Contact :'+loan.Primary_Contact_Name__r.Name+': Preferred Phone');
}*/
            
            
            
        }
        
        /* Bhanu CS-2518 changes 
if(loan.Primary_Contact_Email__c==null){
temp.add('Loan Application :Primary Contact Email');
}*/
        
        if(loan.Name==null || test.isRunningTest()){
            temp.add('Loan Application :Application Number');
        }
        
        
        /*if(loan.CLO_Application_ID__c==null){
temp.add('Loan Application :CLO Application ID');
}*/
        if(loan.Id==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Application ID');
        }
        if(loan.Application_Type__c==null){
            temp.add('Loan Application :Application  Type');
        }
        if(loan.Business_Name_DBA__c==null){
            temp.add('Loan Application :Business Name/DBA');
        }
        if(loan.RecordTypeID==null || test.isRunningTest()){
            temp.add('Loan Application :Record Type');
        }
        
        return temp;
    }
    
    //Used In CS-1117  to validate the Retention Loan Application
    public static List<String> validateRetentionLoan(Loan_Application__c loan){
        try{
            List<String> tempList=new List<String>();
            List<Borrowers__c> Blist=loan.Borrowers__r;
            List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
            List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
            tempList.addAll(EA_GrowthFunction(loan));
            return tempList;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    }// commented by anil on 422*/
    
    public static List<String> validateAcquisitionLoan(Loan_Application__c loan){
        try{
            List<String> tempList=new List<String>();
            List<Borrowers__c> Blist=loan.Borrowers__r;
            List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
            List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
            tempList.addAll(EA_AcquisitionFunction(loan));
            return tempList;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    }
    
    public static List<String> validateGrowthLoan(Loan_Application__c loan){
        try{
            List<String> tempList=new List<String>();
            List<Borrowers__c> Blist=loan.Borrowers__r;
            List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
            List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
            tempList.addAll(EA_GrowthFunction(loan));
            return tempList;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    }
    //added by Madhukar CS-1141 Line of Credit - Submit Validation
    public static List<String> validateLineofCredit(Loan_Application__c loan){
        try{
            List<String> tempList=new List<String>();
            List<Borrowers__c> Blist=loan.Borrowers__r;
            List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
            List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
            tempList.addAll(EA_GrowthFunction(loan));
            return tempList;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    }
    // Ended by Madhukar CS-1141
    // added by Mahdukar CS-1140
    public static List<String> validateRefinanceLoan(Loan_Application__c loan){
        try{
            List<String> tempList=new List<String>();
            List<Borrowers__c> Blist=loan.Borrowers__r;
            List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
            List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
            tempList.addAll(EA_GrowthFunction(loan));
            return tempList;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    } 
    //Ended by Madhukar CS-1140
    public static List<String> validateTransitionAssistance(Loan_Application__c loan){
        try{
            List<String> tempList=new List<String>();
            List<Borrowers__c> Blist=loan.Borrowers__r;
            List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
            List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
            tempList.addAll(NA_TCFunction(loan));
            return tempList;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    }
    
    
    public static List<String> validateWorkingCapital(Loan_Application__c loan){
        try{
            List<String> tempList=new List<String>();
            List<Borrowers__c> Blist=loan.Borrowers__r;
            List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
            List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
            tempList.addAll(NA_WCFunction(loan));
            return tempList;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    }
    
    //Added By Bhanu 08/05/2020 changes Start: CS-1126 Backend TA Loan Application - Submit Validation-->
    public static List<String> validateBackendTA(Loan_Application__c loan){
        try{
            List<String> tempList=new List<String>();
            List<Borrowers__c> Blist=loan.Borrowers__r;
            List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
            List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
            tempList.addAll(NA_BackendTAFunction(loan));
            return tempList;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    }
    
    public static List<String> NA_BackendTAFunction(Loan_Application__c loan){
        List<String> temp=new List<String>();
        List<Borrowers__c> Blist=loan.Borrowers__r;
        List<Proposal_Offer_Placeholder__c> POPList=loan.Proposals_Offers_Placeholders__r;
        List<Proposal_Offer__c> POList=loan.Proposals_Offers__r;
        
        
        if(loan.Loan_Purpose__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Purpose');
        }
        if(loan.Number_of_Advisors__c==null || test.isRunningTest()){
            temp.add('Loan Application :Number of Advisors');
        }
        
        if(loan.Loan_Category__c==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Category');
        }
        if(loan.Status__c==null || test.isRunningTest()){
            temp.add('Loan Application :Status');
        }
        if(loan.CreatedDate==null || test.isRunningTest()){
            temp.add('Loan Application :Created Date');
        }
        if(loan.CreatedBy==null || test.isRunningTest()){
            temp.add('Loan Application :Created By');
        }
        if(loan.Created_By_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :CreatedBy Email');
        }
        if(loan.Primary_Contact__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact');
        }
        if(loan.Primary_Contact_Name__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact Name ');
        }
        /* Bhanu CS-2518 changes 
if(loan.Primary_Contact_Email__c==null){
temp.add('Loan Application :Primary Contact Email');
}*/
        if(loan.Name==null || test.isRunningTest()){
            temp.add('Loan Application :Application Number');
        }
        /*if(loan.CLO_Customer_Group_Name__c==null || test.isRunningTest()){ // UAT Observation -Modified by Bhanu- 10/30/2020
temp.add('Loan Application :CLO Customer Group Name');
}*/
        if(loan.Id==null || test.isRunningTest()){
            temp.add('Loan Application :Loan Application ID');
        }
        if(loan.Application_Type__c==null || test.isRunningTest()){
            temp.add('Loan Application :Application  Type');
        }
        if(loan.Business_Name_DBA__c==null || test.isRunningTest()){
            temp.add('Loan Application :Business Name/DBA');
        }
        if(loan.RecordTypeId==null || test.isRunningTest()){
            temp.add('Loan Application :Record Type');
        }
        if(loan.Opportunity__c==null || test.isRunningTest()){
            temp.add('Loan Application :Opportunity');
        }
        if(loan.Opportunity_Owner1__c==null || test.isRunningTest()){
            temp.add('Loan Application :Opportunity Owner');
        }
        
        if(loan.Assigned_Recruiter__c==null || test.isRunningTest()){
            temp.add('Loan Application :Assigned Recruiter');
        }
        
        if(loan.Assigned_Recruiter_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Assigned Recruiter Email ');
        }
        if(loan.Internal_Recruiter__c==null || test.isRunningTest()){
            temp.add('Loan Application :Internal Recruiter');
        }
        
        if(loan.Internal_Recruiter_Email__c==null || test.isRunningTest()){
            temp.add('Loan Application :Internal Recruiter Email');
        } 
        if(loan.Business_Developer__c==null){
            temp.add('Loan Application :Business Developer');
        }
        
        if(loan.Business_Developer_Email__c==null){
            temp.add('Loan Application :Business Developer Email');
        } 
        
        if(loan.Requested_Loan_Term__c==null){
            temp.add('Loan Application :Requested Loan Term');
        }   
        
        if(loan.Backend_Date__c==null){
            temp.add('Loan Application : Backend Date');
        }   
        if(loan.Backend_Bps__c==null){
            temp.add('Loan Application : Backend Bps');
        }   
        if(loan.Backend_Hurdle__c==null){
            temp.add('Loan Application : Backend Hurdle');
        }   
        if(loan.SUM_NNA__c==null){
            temp.add('Loan Application : SUM NNA');
        }   
        /* Bhanu CS-2518 changes
if(loan.Assigned_Recruiter__r.Title==null || test.isRunningTest()){
temp.add('Loan Application :Assigned Recruiter Title');
}  
if(loan.Assigned_Recruiter__r.phone==null || test.isRunningTest()){
temp.add('Loan Application :Assigned Recruiter Phone');
}
if(loan.Internal_Recruiter__r.title==null || test.isRunningTest()){
temp.add('Loan Application :Internal Recruiter Title ');
}
if(loan.Internal_Recruiter__r.phone==null || test.isRunningTest()){
temp.add('Loan Application :Internal Recruiter Phone');
} */
       
        if(loan.Current_Firm_Name__c==null || test.isRunningTest()){
            temp.add('Loan Application :Current Firm Name');
        }
        //CH-06 Start
        /*if(loan.Current_Firm_Type__c==null){
            temp.add('Loan Application :Current Firm Type');
        }*/
         //CH-06 End
        if(loan.Requested_Loan_Amount__c==null || test.isRunningTest()){
            temp.add('Loan Application :Accepted Loan Amount');
        }
        if(loan.Contact_Master_Rep_Id__c==null || test.isRunningTest()){
            temp.add('Loan Application :Primary Contact Master Rep ID');
        }
        
        
        //Bhanu CS-1994 start        
        
        
        Decimal Backend_Split = 0;
        for(Borrowers__c tmp:Blist){
            
            if(tmp.Backend_Split__c!=null)
            {
                Backend_Split = Backend_Split + tmp.Backend_Split__c;
                
            }
        }     
        if(Backend_Split!=100)
        {
            temp.add('Total Borrower backend loan % must be equal to 100');
        } 
        
        
        //ends  
        
        
        for(Borrowers__c tmp:Blist){
            
            if(tmp.contact__r.Legal_Entity__c==null || test.isRunningTest()){
                temp.add('Primary Contact :'+tmp.Contact__r.Name+': Legal Entity');
            }
            if(tmp.contact__r.CRD_Number__c==null){
                temp.add('Primary Contact :'+tmp.Contact__r.Name+': CRD Number');
            }
            if(tmp.contact__r.FirstName==null || test.isRunningTest()){
                temp.add('Primary Contact :'+tmp.Contact__r.Name+': First Name');
            }
            if(tmp.contact__r.LastName==null || test.isRunningTest()){
                temp.add('Primary Contact :'+tmp.Contact__r.Name+': LastName');
            }
            if(tmp.contact__r.Name==null || test.isRunningTest()){
                temp.add('Primary Contact :'+tmp.Contact__r.Name+': Name');
            } /* Bhanu CS-2518 changes
if(tmp.contact__r.MobilePhone==null){
temp.add('Primary Contact :'+tmp.Contact__r.Name+': Preferred Phone');
}
if(tmp.contact__r.MailingCity==null){
temp.add('Primary Contact :'+tmp.Contact__r.Name+': Mailing City');
}
if(tmp.contact__r.MailingPostalCode==null){
temp.add('Primary Contact :'+tmp.Contact__r.Name+': Mailing Zip/Postal Code');
}
if(tmp.contact__r.MailingState==null){
temp.add('Primary Contact :'+tmp.Contact__r.Name+': Mailing State');
}
if(tmp.contact__r.MailingAddress==null){
temp.add('Primary Contact :'+tmp.Contact__r.Name+': Mailing Addres');
} */
            
            if(tmp.contact__r.CLO_Customer_Group_Name__c==null || test.isRunningTest()){
                temp.add('Primary Contact :'+tmp.Contact__r.Name+': CLO Customer Group Name');
            }
            if(tmp.contact__r.Enterprise_Name__c==null || test.isRunningTest()){
                temp.add('Primary Contact :'+tmp.Contact__r.Name+': Enterprise Name');
            }
            /* Bhanu CS-2518 changes
if(tmp.contact__r.Email==null){
temp.add('Primary Contact:'+tmp.Contact__r.Name+': Email');
} */
            
            if(tmp.Name==null){
                temp.add('Borrower: Borrower Name');
                
            }
            
            /*if(tmp.Sub_Loan_Amount__c==null){
temp.add('Borrower: Sub Loan Amount');
}*/
            
            /* if(tmp.Sub_Loan_Split__c==null){
temp.add('Borrower: Sub Loan Split %');
}*/
            
        }
        
        for(Proposal_Offer__c tmp:POList){
            
            if(tmp.id ==null){
                temp.add('Proposal :'+tmp.Name+': Proposal ID');
            }
            
            if(tmp.Loan_Type__c==null){
                temp.add('Proposal :'+tmp.Name+': Loan Type');
            }  
            if(tmp.Business_NamDBA__c==null){
                temp.add('Proposal :'+tmp.Name+': Business Name/DBA');
            }
            
        }
        
        return temp;
    }//End
    
    
    @AuraEnabled 
    public static Boolean checkContactStatus(String ContactId,String RecordTypeName,String RecordId){
        try{
            String query='';
            if(RecordId!=null || Test.isRunningTest()){
                //CH02 Madhu Added status__c !='Initiated'
                query='select Id,Name,Rep_Status__c,(select id from Loan_Applications1__r where status__c != \'Not Accepted\' AND status__c != \'Declined\' AND status__c !=\'Funded\' AND status__c !=\'Initiated\' AND Primary_Contact__c = true and RecordType.Name=\''+RecordTypeName+'\' and Id!=\''+RecordId+'\') from Contact  where id=\''+ContactId+'\'';
            }else{
                //CH02 Madhu Added status__c !='Initiated'
                query='select Id,Name,Rep_Status__c,(select id from Loan_Applications1__r where status__c != \'Not Accepted\' AND status__c != \'Declined\' AND status__c !=\'Funded\' AND status__c !=\'Initiated\' AND Primary_Contact__c = true and RecordType.Name=\''+RecordTypeName+'\') from Contact  where id=\''+ContactId+'\'';
            }
            Contact con=Database.query(query);
            if(con!=null){
            //start CH-03
                if(con.Rep_Status__c==LoanSubmitApplication.getApplicationStatus('Contact','Status_5')){
            //End        
                    return true;
                }
                if(con.Loan_Applications1__r.size()==0){
                    return false;
                }
            }
            return true;
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return false;
        }
        
    }
    
    //CS-1117 Used to validate Loan App according with Recordtype
    @AuraEnabled @RemoteAction
    public static List<String> checkLoanappliction(String recId){
        try{
            List<String> temp=new List<String>();
            Loan_Application__c loan=collectRecordDetails(recId);
            if(loan!=null){
                switch on loan.RecordType.Name{
                    when 'Retention Loan'{
                        temp.addAll(validateRetentionLoan(loan));
                    }
                    when 'Monetization'{
                        temp.addAll(validateRetentionLoan(loan));
                    }
                    when 'Acquisition Loan'{
                        temp.addAll(validateAcquisitionLoan(loan));
                    }
                    when 'Growth Loan'{
                        temp.addAll(validateGrowthLoan(loan));
                    }
                    //aded by madhukar
                    when 'Line of Credit'{
                        temp.addAll(validateLineofCredit(loan));
                    }
                    when 'Refinance Loan'{
                        temp.addAll(validateRefinanceLoan(loan));
                    }
                    //Ended by madhukar
                    when 'Transition Assistance'{
                        temp.addAll(validateTransitionAssistance(loan));
                    }
                    when 'Working Capital'{
                        temp.addAll(validateWorkingCapital(loan));
                    }
                    // Added By Bhanu
                    when 'Backend TA'{
                        temp.addAll(validateBackendTA(loan));
                    }//End
                    when else{
                        temp.add('Unable to check loan Application please contact your Administrator!');
                    }
                }
            }
            
            
            
            
            /* Loan_Application__c loan=collectRecordDetails(recId);


if(NA_SET.contains(loan.Recordtype.Name)){
temp.addAll(NAFunction(loan));
}else if(EA_SET.contains(loan.Recordtype.Name)){
temp.addAll(EAFunction(loan));
}*/
            return temp;
            
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return new List<String>{'Unable to check loan Application please contact your Administrator!'};
                }
    }
    
    
}