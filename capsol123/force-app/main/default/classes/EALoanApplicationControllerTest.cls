@isTest
public class EALoanApplicationControllerTest {
    testmethod static void scenario1(){
        Account Acc=wcLoanApplicationControllerTest.createAccount('AccName');
        Contact con=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con1=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con2=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Opportunity opp=wcLoanApplicationControllerTest.CreateOpportunity('TEST',Acc.Id);
        String data='{"AdditionalComments":"dfgdfg","BorrowerInfo":[{"ContactId":"'+con.Id+'","GPROA":"","MasterRepId":"","MasterRType":"","primary":false,"PYGDC":"","recId":null,"Uname":"aEv3I0000008OiRSAU","YTDGDC":"","avail":false}],"BusinessInfo":{"Advisor":5,"BussinessName":"test","Entity":"Sole Proprietorship","Purpose":"Retention"},"ContactId":"'+con.Id+'","FinancialData":{"FundingDate":"2020-05-19","IntrestRate":55,"LoanAmount":55,"LoanTerm":"2 Years"},"RecordId":null}';
      	EALoanApplicationController.collectData(EALoanApplicationController.saveRecord(data));
        EALoanApplicationController.populateDefaultinformation();
        EALoanApplicationController.collectWCDetails(EALoanApplicationController.saveRecord(data));
        EALoanApplicationController.deleteBorrowersRecord(EALoanApplicationController.saveRecord(data));
    }
}