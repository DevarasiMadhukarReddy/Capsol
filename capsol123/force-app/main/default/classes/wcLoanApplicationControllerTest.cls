//@isTest(seeAlldata=false)
@isTest
public class wcLoanApplicationControllerTest {
    public Static Opportunity CreateOpportunity(String Name,String AccountId){
        opportunity opp=new Opportunity();
        opp.Assigned_Recruiter__c=userinfo.getuserid();
        opp.Internal_Recruiter_IRD__c=userinfo.getuserid();
        opp.AccountId=AccountId;
        opp.StageName='Prospecting';
        opp.Name=Name;
        opp.CloseDate=SYstem.today()+5;
        insert opp;
        return opp;
    }
    public static Contact CreateContact(String FName,String LName,String AccountId){
        Contact con=new Contact();
        con.FirstName=FName;
        con.LastName=LName;
        con.AccountId=AccountId;
        con.CLO_Customer_ID__c='test';
        insert con;
        return con;
    }
    public static Account createAccount(String AccName){
        Account Acc=new Account();
        Acc.Name=AccName;
        insert Acc;
        return Acc;
    }
    public Static Borrowers__c CreateBorrowers(String LoanId,String ContactId,Decimal AUMAt,Decimal SplitPercent,Boolean Primary ){
        Borrowers__c BW=new Borrowers__c();
        BW.Contact__c=ContactId;
        BW.Loan_Application__c=LoanId;
        BW.Primary_Contact__c=Primary;
        BW.AUM_Attributable__c=AUMAt;
        insert BW;
        return BW;
    }
    @isTest
    static void Test_wcLoanApplication1(){
        Account Acc=createAccount('AccName');
        Contact con=CreateContact('FName', 'LName', Acc.Id);
        Contact con1=CreateContact('FName', 'LName', Acc.Id);
        Contact con2=CreateContact('FName', 'LName', Acc.Id);
        Opportunity opp=CreateOpportunity('TEST',Acc.Id);
        String data='{"OpportunityId":"'+Opp.Id+'","AdditionalComments":"dddddd","BorrowerInfo":[{"ContactId":"'+con.Id+'","pAUM":2,"loanSplit":12,"backendSplit":12,"repayableSplit":40,"primary":false,"Uname":"aEp2100000000T5CAI"},{"ContactId":"'+con1.Id+'","pAUM":4,"primary":false,"Uname":"aEp2100000000WJCAY"},{"ContactId":"'+con2.Id+'","pAUM":6,"primary":false,"Uname":"aEp2100000000WOCAY"}],"BusinessInfo":{"AdvisorNo":"1","BussinessName":"test business","Custodian":"standard","Entity":"Sole Proprietorship","ParentId":"","Registration":"Broker dealer"},"FinancialInfo":{"advRev":6,"aiuitCash":6,"broRev":6,"eq":6,"fa":6,"fi":6,"mfc":6,"mfdh":6666,"totAdvAum":6,"va":6},"ProposalInfo":{"RequestedLoanAmount":11,"RequestedTermLength":"2"}}';
       // wcLoanApplicationController.WorkingCapital LO=wcLoanApplicationController.collectData(wcLoanApplicationController.saveWCRecord(data));
         wcLoanApplicationController.WorkingCapital LO=new wcLoanApplicationController.WorkingCapital();
          LO =  wcLoanApplicationController.collectData(wcLoanApplicationController.saveWCRecord(data));
        
        System.debug('The LO Record Value is======>'+LO.RecordId); 
        wcLoanApplicationController.collectData(LO.RecordId);        
        System.debug('##############'+ wcLoanApplicationController.collectData(LO.RecordId));
        wcLoanApplicationController.NAFunction(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.NA_TCFunction(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.NA_WCFunction(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.EA_AcquisitionFunction(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.EA_GrowthFunction(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.EAFunction(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.validateTransitionAssistance(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.validateRetentionLoan(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.validateWorkingCapital(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        //start Added By Bhanu
        wcLoanApplicationController.validateBackendTA(wcLoanApplicationController.collectWCDetails(LO.RecordId));
         //end
         
       // wcLoanApplicationController.validateRefinanceLoan(wcLoanApplicationController.collectWCDetails(LO.RecordId));
      //  wcLoanApplicationController.validateLineofCredit(wcLoanApplicationController.collectWCDetails(LO.RecordId));
      //  wcLoanApplicationController.validateRetentionLoan(wcLoanApplicationController.collectWCDetails(LO.RecordId));
        wcLoanApplicationController.checkLoanappliction(LO.RecordId);
        wcLoanApplicationController.checkContactStatus(con.Id,'Working Capital',LO.RecordId);
        /*data='{"OpportunityId":"'+Opp.Id+'","RecordId":"'+LO.RecordId+'","AdditionalComments":"dddddd","BorrowerInfo":[],"BusinessInfo":{"AdvisorNo":"1","BussinessName":"test business","Custodian":"standard","Entity":"Sole Proprietorship","ParentId":"","Registration":"Broker dealer"},"FinancialInfo":{"advRev":6,"aiuitCash":6,"broRev":6,"eq":6,"fa":6,"fi":6,"mfc":6,"mfdh":6666,"totAdvAum":6,"va":6},"ProposalInfo":{"RequestedLoanAmount":11,"RequestedTermLength":"2"}}';
        LO=wcLoanApplicationController.collectData(wcLoanApplicationController.saveWCRecord(data));*/
    }
    @isTest
    static void Test_wcLoanApplication2(){
        String data='{"AdditionalComments":"dddddd","BorrowerInfo":[],"BusinessInfo":{"AdvisorNo":"1","BussinessName":"test business","Custodian":"standard","Entity":"Sole Proprietorship","ParentId":"","Registration":"Broker dealer"},"FinancialInfo":{"advRev":6,"aiuitCash":6,"broRev":6,"eq":6,"fa":6,"fi":6,"mfc":6,"mfdh":6666,"totAdvAum":6,"va":6},"ProposalInfo":{"RequestedLoanAmount":11,"RequestedTermLength":"2"}}';
        wcLoanApplicationController.collectData(wcLoanApplicationController.saveWCRecord(data));
        wcLoanApplicationController.deleteallBorrowers(wcLoanApplicationController.saveWCRecord(data));
        try{
        wcLoanApplicationController.saveWCRecord('data' );
        }catch(Exception ex){
            
        }
        wcLoanApplicationController.validateRefinanceLoan(null);
        wcLoanApplicationController.validateLineofCredit(null);
        wcLoanApplicationController.validateRetentionLoan(null);
        wcLoanApplicationController.validateGrowthLoan(null);
        wcLoanApplicationController.validateAcquisitionLoan(null);
        wcLoanApplicationController.checkLoanappliction(null);
    }
    @isTest
    static void Test_wcLoanApplication3(){
        Account Acc=createAccount('AccName');
        Contact con=CreateContact('FName', 'LName', Acc.Id);
        Contact con1=CreateContact('FName', 'LName', Acc.Id);
        Contact con2=CreateContact('FName', 'LName', Acc.Id);
        Opportunity opp=CreateOpportunity('TEST',Acc.Id);
        Loan_Application__c Growth_LA=new Loan_Application__c();
        Growth_LA.RecordTypeId=Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Growth Loan').getRecordTypeId();
        Growth_LA.Primary_Contact_Name__c=con.id;
        insert Growth_LA;
        Borrowers__c bwg=new Borrowers__c();
        bwg.Loan_Application__c=Growth_LA.Id;
        bwg.Contact__c=Con.Id;
        insert bwg;
        Proposal_Offer__c pg=new Proposal_Offer__c();
        pg.LoanApp_MD__c=Growth_LA.Id;
        insert pg;
        Proposal_Offer_Placeholder__c ppg=new Proposal_Offer_Placeholder__c();
        ppg.Loan_Application__c=Growth_LA.Id;
        insert ppg;
        
        
        
        
        
        
        
        
        
        
        Loan_Application__c Acquistion_LA=new Loan_Application__c();
        Acquistion_LA.RecordTypeId=Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Acquisition Loan').getRecordTypeId();
        Acquistion_LA.Primary_Contact_Name__c=con.id;
        insert Acquistion_LA;
        Borrowers__c bw=new Borrowers__c();
        bw.Loan_Application__c=Acquistion_LA.Id;
        bw.Contact__c=Con.Id;
        insert bw;
        Proposal_Offer__c p=new Proposal_Offer__c();
        p.LoanApp_MD__c=Acquistion_LA.Id;
        insert p;
        Proposal_Offer_Placeholder__c pp=new Proposal_Offer_Placeholder__c();
        pp.Loan_Application__c=Acquistion_LA.Id;
        insert pp;
        wcLoanApplicationController.checkLoanappliction(Growth_LA.Id);
        wcLoanApplicationController.checkLoanappliction(Acquistion_LA.Id);
    }
    
    /*@isTest
    static void  test1(){
        Account acc=new Account(name='re');insert acc;
        contact con=new Contact();
        con.FirstName='Test';
        con.LastName='TEST';
        insert con;
        opportunity opp=new Opportunity();
        opp.Assigned_Recruiter__c=userinfo.getuserid();
        opp.Internal_Recruiter_IRD__c=userinfo.getuserid();
        opp.AccountId=acc.Id;
        opp.StageName='Prospecting';
        opp.Name='Test';
        opp.CloseDate=SYstem.today()+5;
        insert opp;
        Loan_Application__c Growth_LA=new Loan_Application__c();
        Growth_LA.RecordTypeId=Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Growth Loan').getRecordTypeId();
        insert Growth_LA;
        
        Loan_Application__c Acquistion_LA=new Loan_Application__c();
        Acquistion_LA.RecordTypeId=Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Acquisition Loan').getRecordTypeId();
        insert Acquistion_LA;
        Borrowers__c bw=new Borrowers__c();
        bw.Loan_Application__c=Acquistion_LA.Id;
        bw.Contact__c=Con.Id;
        insert bw;
        Proposal_Offer__c p=new Proposal_Offer__c();
        p.LoanApp_MD__c=Acquistion_LA.Id;
        insert p;
        Proposal_Offer_Placeholder__c pp=new Proposal_Offer_Placeholder__c();
        pp.Loan_Application__c=Acquistion_LA.Id;
        insert pp;
        wcLoanApplicationController.validateTransitionAssistance(Acquistion_LA);
         wcLoanApplicationController.validateWorkingCapital(Acquistion_LA);
          //Start Added by Bhanu
          wcLoanApplicationController.validateBackendTA(Acquistion_LA);
       //End
       
       wcLoanApplicationController.validateRefinanceLoan(Acquistion_LA);
         wcLoanApplicationController.validateLineofCredit(Acquistion_LA);
         wcLoanApplicationController.validateRetentionLoan(Acquistion_LA);
        wcLoanApplicationController.checkLoanappliction(Growth_LA.Id);
        wcLoanApplicationController.checkLoanappliction(Acquistion_LA.Id);
         wcLoanApplicationController.validateRefinanceLoan(null);
         wcLoanApplicationController.validateLineofCredit(null);
         wcLoanApplicationController.validateRetentionLoan(null);
        wcLoanApplicationController.validateGrowthLoan(null);
        wcLoanApplicationController.validateAcquisitionLoan(null);
        wcLoanApplicationController.checkLoanappliction(null);
        String data='{"OpportunityId":"'+Opp.Id+'","AdditionalComments":"dddddd","BorrowerInfo":[{"ContactId":"'+con.Id+'","pAUM":2,"primary":false,"Uname":"aEp2100000000T5CAI"},{"ContactId":"'+con.Id+'","pAUM":4,"primary":false,"Uname":"aEp2100000000WJCAY"},{"ContactId":"'+con.Id+'","pAUM":6,"primary":false,"Uname":"aEp2100000000WOCAY"}],"BusinessInfo":{"AdvisorNo":"1","BussinessName":"test business","Custodian":"standard","Entity":"Sole Proprietorship","ParentId":"","Registration":"Broker dealer"},"FinancialInfo":{"advRev":6,"aiuitCash":6,"broRev":6,"eq":6,"fa":6,"fi":6,"mfc":6,"mfdh":6666,"totAdvAum":6,"va":6},"ProposalInfo":{"RequestedLoanAmount":11,"RequestedTermLength":"2"}}';
        wcLoanApplicationController.collectData(wcLoanApplicationController.saveWCRecord(data));
        wcLoanApplicationController.collectWCDetails(wcLoanApplicationController.saveWCRecord(data));
        wcLoanApplicationController.NAFunction(wcLoanApplicationController.collectWCDetails(wcLoanApplicationController.saveWCRecord(data)));
        wcLoanApplicationController.EAFunction(wcLoanApplicationController.collectWCDetails(wcLoanApplicationController.saveWCRecord(data)));
        wcLoanApplicationController.checkLoanappliction(wcLoanApplicationController.saveWCRecord(data));
        wcLoanApplicationController.deleteBorrowersRecord(Acquistion_LA.Id);
       
    }*/
}