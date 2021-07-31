/** 
  Modified By Bhanu 8/17/2020 CS-1811 - Custom UI enhancement - Loan Split %
  CH-05  CS-1983 - Defect Primary Contact Bug - Sprint 16   Amol Deshpande    09/08/2020
  CH06 CS-2736 - Opportunity Governance Issue Sprint 21 - Amol 01/13/2021

* CH.No       Description                                                           Developer           Date
---------------------------------------------------------------------------------------------------------------
 CH07		  CS-2755 TA Application Performance Improvement                        Amol Deshpande      02/22/2021
                   
**/

public class clsCustomUIController {
    public static boolean capsolexecutionConTriggerOnSave = false ;//CH07
    
    public clsCustomUIController() {
        
    }
    
    @AuraEnabled
    // public static loanAppWrapperObj saveLoanAppObj(string businessDetailsDataKey, String financialDetailsDataKey, String borrowerDataKey, String proposalsDataKey){
    public static Id  saveLoanAppObj(String loanobj,String opportunity){
        
        /* System.debug(businessDetailsDataKey);
System.debug(financialDetailsDataKey);
System.debug(borrowerDataKey);
System.debug(proposalsDataKey);*/
        list<loanAppWrapperObj> loanAppObj = new list<loanAppWrapperObj>();
        Loan_Application__c loanApp = new Loan_Application__c();
        Contact con = new Contact();
        List<Proposal_Offer_Placeholder__c> popList = new List<Proposal_Offer_Placeholder__c>();
        Proposal_Offer_Placeholder__c pop = new Proposal_Offer_Placeholder__c();
        System.debug(opportunity);
       // Map<String, String> obj = (Map<String,String>)JSON.deserialize(loanobj, Map<String, String>.class);
       //Map<String, String> obj = (Map<String,String>)JSON.deserialize(loanobj, Map<String, String>.class);

       loanAppWrapperObj obj=(loanAppWrapperObj)JSON.deserialize(loanobj, loanAppWrapperObj.class);

       // Map<String, String> borrowerObj = (Map<String,String>)JSON.deserialize(borrowerData, Map<String, String>.class);
        System.debug('@@@@@@@'+obj);
       // System.debug('@@@@@@@'+borrowerObj);

        Integer proposalRows = 0;

        proposalRows = Integer.valueOf(obj.rowProRow);
       loanApp.RecordTypeId=Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Transition Assistance').getRecordTypeId();
        
            if(obj.businessLegalNameDBA != null || obj.businessLegalNameDBA != ''){
                loanApp.Business_Name_DBA__c = obj.businessLegalNameDBA;
            }
            if(obj.noOfAdvisors !=null && obj.noOfAdvisors !=''){
                loanApp.Number_of_Advisors__c = decimal.valueOf(obj.noOfAdvisors);
            }
            if(obj.advisorTotalAUM != null && obj.advisorTotalAUM != ''){
                loanApp.Advisor_Total_AUM__c = decimal.valueOf(obj.advisorTotalAUM);
            }
            if(obj.legalEntity != null && obj.legalEntity != ''){
                loanApp.Legal_Entity__c = obj.legalEntity;
            }
            if(obj.currentRegistration != null && obj.currentRegistration != ''){
                loanApp.Current_Registration__c = obj.currentRegistration;
            }
            if(obj.currentCustodian != null && obj.currentCustodian != ''){
                loanApp.CurrentCustodian__c = obj.currentCustodian;
            }
            if(obj.mutualFundsDirectlyHeld != null && obj.mutualFundsDirectlyHeld != ''){
                loanApp.Direct_Mutual_Funds__c = decimal.valueOf(obj.mutualFundsDirectlyHeld);
            }
            if(obj.mutualFundsCustodied != null && obj.mutualFundsCustodied != ''){
                loanApp.Mutual_Funds_Custodied__c = decimal.valueOf(obj.mutualFundsCustodied);
            }
            if(obj.variableAnnuties != null && obj.variableAnnuties != ''){
                loanApp.AUM_Variable_Annuities__c = decimal.valueOf(obj.variableAnnuties);
            }
            if(obj.fixedAnnuties != null && obj.fixedAnnuties != ''){
                loanApp.AUM_Fixed_Annuities__c = decimal.valueOf(obj.fixedAnnuties);
            }
            if(obj.fixedIncome != null && obj.fixedIncome != ''){
                loanApp.AUM_Fixed_Income__c = decimal.valueOf(obj.fixedIncome);
            }
            if(obj.equity != null && obj.equity != ''){
                loanApp.AUM_Equity__c = decimal.valueOf(obj.equity);
            }
            if(obj.aiUITCash != null && obj.aiUITCash != ''){
                loanApp.AUM_AI_UIT_Cash__c = decimal.valueOf(obj.aiUITCash);
            }
            if(obj.totalAdvisoryAUM != null && obj.totalAdvisoryAUM != ''){
                loanApp.Total_Advisory_AUM__c = decimal.valueOf(obj.totalAdvisoryAUM);
            }
            if(obj.advisoryRevenue != null && obj.advisoryRevenue != ''){
                loanApp.Advisory_Revenue_c__c = decimal.valueOf(obj.advisoryRevenue);
            }
            if(obj.brokerageRevenue != null && obj.brokerageRevenue != ''){
                loanApp.Brokerage_Revenue__c = decimal.valueOf(obj.brokerageRevenue);
            }
        
            
        
            //loanApp.Advisor__c = obj.get('borrowerId;
        
        
           // system.debug(obj.containsKey('primaryContact'));
            //loanApp.Primary_Contact__c = Boolean.ValueOf(obj.get('primaryContact'));
        
        
            //loanApp.Percentage_Split_of_Total_AUM__c =  decimal.valueOf(obj.get('splitOfSumAUM'));
        
            if(obj.AdditionalComment != null && obj.AdditionalComment != ''){ // CS - 2714 - Additional Comments not saving  - 12/24/2020
                loanApp.Additional_Comments__c=String.valueOf(obj.AdditionalComment);
            }
        
        /*if(obj.containsKey('aumAttributable')){
            loanApp.Percentage_Split_of_Total_AUM__c =  decimal.valueOf(obj.get('aumAttributable'));
        }*/
        
        if(opportunity!=null){ 
            loanApp.Opportunity__c=opportunity;
            Opportunity oppor=[select Id,Internal_Recruiter_IRD__c,Assigned_Recruiter__c from Opportunity  where Id=:opportunity];
            if(oppor!=null){
                loanApp.Assigned_Recruiter__c=oppor.Assigned_Recruiter__c==null?null:oppor.Assigned_Recruiter__c;
                loanApp.Internal_Recruiter__c=oppor.Internal_Recruiter_IRD__c==null?null:oppor.Internal_Recruiter_IRD__c;
            }
        }
        try {
            insert loanApp;
            createBorrowerRecords(obj.borrowers,loanApp.Id,loanApp.Business_Name_DBA__c==null?null:loanApp.Business_Name_DBA__c,loanApp.Legal_Entity__c==null?null:loanApp.Legal_Entity__c);
                if(loanApp.Id != null){
                    //Start CH-05
                    if(loanApp.Primary_Contact_Name__c != null){
                        con = [select id,Legal_Entity__c,LPLCRM__U_S_Citizenship__c,Citizenship_Status__c from Contact where id =:loanApp.Primary_Contact_Name__c];
                        if(loanApp.Legal_Entity__c != null){
                            con.Legal_Entity__c = loanApp.Legal_Entity__c;
                        }
                        if(con.LPLCRM__U_S_Citizenship__c == true){
                            con.Citizenship_Status__c = 'US Citizen';
                        }else{
                            con.Citizenship_Status__c = 'Resident alien';
                        }
                        update con;
                    }
                    //End CH-05
            }
        } catch(Exception e) {
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('>>>>CAMPA'+obj.campaignPicklist1);
        
            if(obj.campaignPicklist1 != null || obj.campaignPicklist1 != ''){
                pop.Campaign_Name__c = obj.campaignPicklist1;
            }
            if(obj.uWTypePicklist1 != null || obj.uWTypePicklist1 != ''){
                pop.U_W_Type__c = obj.uWTypePicklist1;
            }
            if(obj.termLength1 != null || obj.termLength1 != ''){
                pop.Term_Length__c = obj.termLength1;
            }
            if(obj.osjLEName1 != null || obj.osjLEName1 != ''){
                pop.OSJ_LE_Name__c = obj.osjLEName1;
            }
            if(obj.branchPicklist1 != null || obj.branchPicklist1 != ''){
                pop.Branch__c = obj.branchPicklist1;
            }
            if(obj.platformPicklist1 != null || obj.platformPicklist1 != ''){
                pop.Platform__c = obj.platformPicklist1;
            }
        
        pop.Loan_Application__c = loanApp.id;
        pop.Offer_Name__c = 'Forgivable Offer 1';
        popList.add(pop);
        if(proposalRows >= 2) {
            System.debug('@@@@'+proposalRows);
            pop = new Proposal_Offer_Placeholder__c();
            
                if(obj.campaignPicklist2 != null || obj.campaignPicklist2 != ''){
                    pop.Campaign_Name__c = obj.campaignPicklist2;
                }
                if(obj.uWTypePicklist2 != null || obj.uWTypePicklist2 != ''){
                    pop.U_W_Type__c = obj.uWTypePicklist2;
                }
                if(obj.termLength2 != null || obj.termLength2 != ''){
                    pop.Term_Length__c = obj.termLength2;
                }
                if(obj.osjLEName2 != null || obj.osjLEName2 != ''){
                    pop.OSJ_LE_Name__c = obj.osjLEName2;
                }
                if(obj.branchPicklist2 != null || obj.branchPicklist2 != ''){
                    pop.Branch__c = obj.branchPicklist2;
                }
                if(obj.platformPicklist2 != null || obj.platformPicklist2 != ''){
                    pop.Platform__c = obj.platformPicklist2;
                }
            
            pop.Offer_Name__c = 'Forgivable Offer 2';
            pop.Loan_Application__c = loanApp.id;
            popList.add(pop);
            
            if(proposalRows >= 3) {
                System.debug('!!!!'+proposalRows);
                pop = new Proposal_Offer_Placeholder__c();
                
                if(obj.campaignPicklist3 != null || obj.campaignPicklist3 != ''){
                    pop.Campaign_Name__c = obj.campaignPicklist3;
                }
                if(obj.uWTypePicklist3 != null || obj.uWTypePicklist3 != ''){
                    pop.U_W_Type__c = obj.uWTypePicklist3;
                }
                if(obj.termLength3 != null || obj.termLength3 != ''){
                    pop.Term_Length__c = obj.termLength3;
                }
                if(obj.osjLEName3 != null || obj.osjLEName3 != ''){
                    pop.OSJ_LE_Name__c = obj.osjLEName3;
                }
                if(obj.branchPicklist3 != null || obj.branchPicklist3 != ''){
                    pop.Branch__c = obj.branchPicklist3;
                }
                if(obj.platformPicklist3 != null || obj.platformPicklist3 != ''){
                    pop.Platform__c = obj.platformPicklist3;
                }
                
                pop.Loan_Application__c = loanApp.id;
                pop.Offer_Name__c = 'Forgivable Offer 3';
                popList.add(pop);
                if(proposalRows >= 4) {
                    System.debug('$$$$$'+proposalRows);
                    pop = new Proposal_Offer_Placeholder__c();
                    
                    if(obj.campaignPicklist4 != null || obj.campaignPicklist4 != ''){
                        pop.Campaign_Name__c = obj.campaignPicklist4;
                    }
                    if(obj.uWTypePicklist4 != null || obj.uWTypePicklist4 != ''){
                        pop.U_W_Type__c = obj.uWTypePicklist4;
                    }
                    if(obj.termLength4 != null || obj.termLength4 != ''){
                        pop.Term_Length__c = obj.termLength4;
                    }
                    if(obj.osjLEName4 != null || obj.osjLEName4 != ''){
                        pop.OSJ_LE_Name__c = obj.osjLEName4;
                    }
                    if(obj.branchPicklist4 != null || obj.branchPicklist4 != ''){
                        pop.Branch__c = obj.branchPicklist4;
                    }
                    if(obj.platformPicklist4 != null || obj.platformPicklist4 != ''){
                        pop.Platform__c = obj.platformPicklist4;
                    }
                    pop.Loan_Application__c = loanApp.id;
                    pop.Offer_Name__c = 'Forgivable Offer 4';
                    popList.add(pop);
                    
                    if(proposalRows >= 5) {
                        System.debug('&&&&&'+proposalRows);
                        pop = new Proposal_Offer_Placeholder__c();
                        
                        if(obj.campaignPicklist5 != null || obj.campaignPicklist5 != ''){
                            pop.Campaign_Name__c = obj.campaignPicklist5;
                        }
                        if(obj.uWTypePicklist5 != null || obj.uWTypePicklist5 != ''){
                            pop.U_W_Type__c = obj.uWTypePicklist5;
                        }
                        if(obj.termLength5 != null || obj.termLength5 != ''){
                            pop.Term_Length__c = obj.termLength5;
                        }
                        if(obj.osjLEName5 != null || obj.osjLEName5 != ''){
                            pop.OSJ_LE_Name__c = obj.osjLEName5;
                        }
                        if(obj.branchPicklist5 != null || obj.branchPicklist5 != ''){
                            pop.Branch__c = obj.branchPicklist5;
                        }
                        if(obj.platformPicklist5 != null || obj.platformPicklist5 != ''){
                            pop.Platform__c = obj.platformPicklist5;
                        }
                        
                        pop.Loan_Application__c = loanApp.id;
                        pop.Offer_Name__c = 'Forgivable Offer 5';
                        popList.add(pop);
                    }
                }
            }
        }

        System.debug('popList'+popList);
        insert popList;


        return loanApp.Id;
       
        
        
    }

    private static void createBorrowerRecords(List<borrowers> Bdata,Id LoanId,String BusinessDBAName,String LegalEntity){
        System.debug('HELLO');
        
        capsolexecutionConTriggerOnSave = true; //CH07
        New_Opportunity_TriggerHandler.capsolexecution = true;//CH06
       
        List<Borrowers__c> BList=new List<Borrowers__c>();
        
        if(Bdata != null){
            for(borrowers b:Bdata){
                if(b.ContactId!=null){
                    Borrowers__c temp=new Borrowers__c();
                    temp.name=b.BName;
                    temp.Contact__c=b.ContactId;
                    temp.Primary_Contact__c=b.primary;
                    temp.Split_of_Total_AUM__c=b.pAUM;
                    temp.Loan_Application__c=LoanId;
                    temp.AUM_Attributable__c = Decimal.valueOf(b.AUMATT);
                    temp.CLO_Customer_Group_Name__c =BusinessDBAName;
                    /*if(b.recId!=null){
                        temp.Id=b.recId;
                    }*/
                      //CS-1811-Bhanu Start
                 temp.Backend_Split__c=b.backendSplit;
                 temp.Sub_Loan_Split__c=b.loanSplit;
                 temp.Repayable_Split__c=b.repayableSplit;
                
                //End
                    BList.add(temp);
                    
                }
            }
        }
        if(BList.size()>0){
            upsert BList;
            Set<Id> BSet=new Set<Id>();
            Set<Id> BSetCon=new Set<Id>();
            for(Borrowers__c t:BList){
                BSet.add(t.Id);
                BSetCon.add(t.Contact__c);
            }
            List<Contact> conUpdate = new List<Contact>();
           // con = [select id,Legal_Entity__c,LPLCRM__U_S_Citizenship__c,Citizenship_Status__c,Split_of_Total_AUM__c from Contact where id =:loanApp.Advisor__c];
                /*        if(loanApp.Legal_Entity__c != null){
                            con.Legal_Entity__c = loanApp.Legal_Entity__c;
                        }
                        if(con.LPLCRM__U_S_Citizenship__c == true){
                            con.Citizenship_Status__c = 'US Citizen';
                        }else{
                            con.Citizenship_Status__c = 'Resident alien';
                        }
                        update con;
            conUpdate = [select id,Legal_Entity__c,LPLCRM__U_S_Citizenship__c,Citizenship_Status__c,Split_of_Total_AUM__c,
                        Primary_Contact__c,AUM_Attributable__c from Contact where id IN :BSetCon];*/
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
                //LA.Advisor__c=null;  -CH-05
                LA.Primary_Contact_Name__c=null;
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
                LA=wcloanapplicationcontroller.collectRecordDetails(LoanId);
                if(PrimaryContactId!=null){
                    //Start CH-05
                    //LA.Primary_Contact__c=true;
                    //LA.Advisor__c=PrimaryContactId;
                    //End CH-05
                    LA.Primary_Contact_Name__c=PrimaryContactId;
                    update LA;
                }else{
                    //Start CH-05
                    //LA.Primary_Contact__c=false;
                    //LA.Advisor__c=null;
                    //End CH-05
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
    
    public class loanAppWrapperObj{
        @auraEnabled public string businessLegalNameDBA {get;set;}
        @auraEnabled public string noOfAdvisors {get;set;}
        @auraEnabled public string legalEntity {get;set;}
        @auraEnabled public Boolean primaryContact {get;set;}
        @auraEnabled public string currentRegistration {get;set;}
        @auraEnabled public string currentCustodian {get;set;}
        @auraEnabled public string aumAttributable {get; set;}
        @auraEnabled public string mutualFundsDirectlyHeld {get;set;}
        @auraEnabled public string mutualFundsCustodied {get;set;}
        @auraEnabled public string variableAnnuties {get;set;}
        @auraEnabled public string fixedAnnuties {get;set;}
        @auraEnabled public string equity {get;set;}
        @auraEnabled public string fixedIncome {get;set;}
        @auraEnabled public string aiUITCash {get;set;}
        @auraEnabled public string totalAdvisoryAUM {get;set;}
        @auraEnabled public string advisoryRevenue {get;set;}
        @auraEnabled public string brokerageRevenue {get;set;}
        @auraEnabled public string advisorTotalAUM {get;set;}
        @auraEnabled public string advisorTotalProduction {get;set;}
        @auraEnabled public string platformPicklist1 {get;set;}
        @auraEnabled public string platformPicklist2 {get;set;}
        @auraEnabled public string platformPicklist3 {get;set;}
        @auraEnabled public string platformPicklist4 {get;set;}
        @auraEnabled public string platformPicklist5 {get;set;}
        @auraEnabled public string branchPicklist1 {get;set;}
        @auraEnabled public string branchPicklist2 {get;set;}
        @auraEnabled public string branchPicklist3 {get;set;}
        @auraEnabled public string branchPicklist4 {get;set;}
        @auraEnabled public string branchPicklist5 {get;set;}
        @auraEnabled public string osjLEName1 {get;set;}
        @auraEnabled public string osjLEName2 {get;set;}
        @auraEnabled public string osjLEName3 {get;set;}
        @auraEnabled public string osjLEName4 {get;set;}
        @auraEnabled public string osjLEName5 {get;set;}
        @auraEnabled public string termLength1 {get;set;}
        @auraEnabled public string termLength2 {get;set;}
        @auraEnabled public string termLength3 {get;set;}
        @auraEnabled public string termLength4 {get;set;}
        @auraEnabled public string termLength5 {get;set;}
        @auraEnabled public string uWTypePicklist1 {get;set;}
        @auraEnabled public string uWTypePicklist2 {get;set;}
        @auraEnabled public string uWTypePicklist3 {get;set;}
        @auraEnabled public string uWTypePicklist4 {get;set;}
        @auraEnabled public string uWTypePicklist5 {get;set;}
        @auraEnabled public string campaignPicklist1 {get;set;}
        @auraEnabled public string campaignPicklist2 {get;set;}
        @auraEnabled public string campaignPicklist3 {get;set;}
        @auraEnabled public string campaignPicklist4 {get;set;}
        @auraEnabled public string campaignPicklist5 {get;set;}
        @auraEnabled public Integer rowProRow {get; set;}
        @auraEnabled public String AdditionalComment {get; set;}

        @auraEnabled public List<borrowers> borrowers {get;set;}
        
        @auraEnabled public list<string> proposals {get;set;}
        
        @auraEnabled public String platform{get;set;}
        @auraEnabled public String OSJLEName{get;set;}
        @auraEnabled public String TermLength{get;set;}
        @auraEnabled public String UWType{get;set;}
        @auraEnabled public String CampaignName{get;set;}
        
        public loanAppWrapperObj(){
            this.businessLegalNameDBA = businessLegalNameDBA;
            this.noOfAdvisors = noOfAdvisors;
            this.legalEntity = legalEntity;
            this.currentRegistration = currentRegistration;
            this.currentCustodian = currentCustodian;
            this.mutualFundsDirectlyHeld = mutualFundsDirectlyHeld;
            this.mutualFundsCustodied = mutualFundsCustodied;
            this.variableAnnuties = variableAnnuties;
            this.fixedAnnuties = fixedAnnuties;
            this.equity = equity;
            this.fixedIncome = fixedIncome;
            this.aiUITCash = aiUITCash;
            this.totalAdvisoryAUM = totalAdvisoryAUM;
            this.advisoryRevenue = advisoryRevenue;
            this.brokerageRevenue = brokerageRevenue;
            this.advisorTotalAUM = advisorTotalAUM;
            this.advisorTotalProduction = advisorTotalProduction;
            this.proposals = proposals;
            this.platform = platform;
            this.OSJLEName = OSJLEName;
            this.TermLength = TermLength;
            this.UWType = UWType;
            this.CampaignName = CampaignName;
            borrowers = null;
            
        }
    
    }

        public class borrowers {
        @AuraEnabled public String ContactId;
        @AuraEnabled public Integer pAUM;
        @AuraEnabled public String AUMATT;
        @AuraEnabled public Boolean primary;
        @AuraEnabled public String Uname;
        @AuraEnabled public String BName;
       //CS-1811-Bhanu Start
         @AuraEnabled public Decimal repayableSplit;
         @AuraEnabled public Decimal loanSplit;
         @AuraEnabled public Decimal backendSplit;
        //End
       public borrowers(){
        BName=null;
        ContactId='';
        pAUM = 0;
        AUMATT='';
        primary=false;
        Uname = '';
       //CS-1811-Bhanu Start
            repayableSplit=0;
            loanSplit=0;
            backendSplit=0;
             //End
       }

    }
}