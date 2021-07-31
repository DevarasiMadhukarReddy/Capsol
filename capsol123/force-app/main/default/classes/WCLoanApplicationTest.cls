@isTest(seeAlldata=false)
public class WCLoanApplicationTest {
	@isTest
    static void  test1(){
        contact con=new Contact();
        con.FirstName='Test';
        con.LastName='TEST';
        insert con;
        String data='{"AdditionalComments":"dddddd","BorrowerInfo":[{"ContactId":"'+con.Id+'","pAUM":2,"primary":false,"Uname":"aEp2100000000T5CAI"},{"ContactId":"'+con.Id+'","pAUM":4,"primary":false,"Uname":"aEp2100000000WJCAY"},{"ContactId":null,"pAUM":6,"primary":false,"Uname":"aEp2100000000WOCAY"}],"BusinessInfo":{"AdvisorNo":"1","BussinessName":"test business","Custodian":"standard","Entity":"Sole Proprietorship","ParentId":"","Registration":"RIA"},"FinancialInfo":{"advRev":6,"aiuitCash":6,"broRev":6,"eq":6,"fa":6,"fi":6,"mfc":6,"mfdh":6666,"totAdvAum":6,"va":6},"ProposalInfo":{"RequestedLoanAmount":11,"RequestedTermLength":"2"}}';
        WCLoanApplication.checkLoanappliction(wcLoanApplicationController.saveWCRecord(data));
    }
}