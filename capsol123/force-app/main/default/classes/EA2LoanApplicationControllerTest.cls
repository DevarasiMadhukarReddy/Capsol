@isTest
public class EA2LoanApplicationControllerTest {
    testmethod static void scenario1(){
        test.startTest();
        Account Acc=wcLoanApplicationControllerTest.createAccount('AccName');
        Contact con=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con1=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con2=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Case cs=new Case();
        cs.status='initiated';
        insert cs;
        Opportunity opp=wcLoanApplicationControllerTest.CreateOpportunity('TEST',Acc.Id);
        String data='{"AdditionalComments":"dfgdfg","BorrowerInfo":[{"ContactId":"'+con.Id+'","GPROA":"","MasterRepId":"","MasterRType":"","primary":true,"PYGDC":"","recId":null,"Uname":"aEv3I0000008OiRSAU","YTDGDC":"","avail":false}],"BusinessInfo":{"Advisor":5,"BussinessName":"test","Entity":"Sole Proprietorship","Purpose":"Retention"},"CaseId":"'+cs.Id+'","FinancialData":{"FundingDate":"2020-05-19","IntrestRate":55,"LoanAmount":55,"LoanTerm":"2 Years"},"RecordId":null}';
        EA2LoanApplicationController.collectData(EA2LoanApplicationController.saveRecord(data));
        //EA2LoanApplicationController.populateDefaultinformation();
        //EA2LoanApplicationController.collectWCDetails(EA2LoanApplicationController.saveRecord(data));
        //EALoanApplicationController.deleteBorrowersRecord(EA2LoanApplicationController.saveRecord(data));

        test.stopTest();
    }
       /* commented by Madhukar reddy on 11/05/2020
    testmethod static void scenario2(){
        test.startTest();
        Account Acc=wcLoanApplicationControllerTest.createAccount('AccName');
        Contact con=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con1=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Contact con2=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        Case cs=new Case();
        cs.status='initiated';
        insert cs;
        Opportunity opp=wcLoanApplicationControllerTest.CreateOpportunity('TEST',Acc.Id);
        String data='{"AdditionalComments":"dfgdfg","BorrowerInfo":[{"ContactId":"'+con.Id+'","GPROA":"","MasterRepId":"","MasterRType":"","primary":false,"PYGDC":"","recId":null,"Uname":"aEv3I0000008OiRSAU","YTDGDC":"","avail":false}],"BusinessInfo":{"Advisor":5,"BussinessName":"test","Entity":"Sole Proprietorship","Purpose":"Retention"},"CaseId":"'+cs.Id+'","FinancialData":{"FundingDate":"2020-05-19","IntrestRate":55,"LoanAmount":55,"LoanTerm":"2 Years"},"RecordId":null}';
        EA2LoanApplicationController.collectData(EA2LoanApplicationController.saveRecord(data));
        EA2LoanApplicationController.populateDefaultinformation();
        EA2LoanApplicationController.collectWCDetails(EA2LoanApplicationController.saveRecord(data));
        EALoanApplicationController.deleteBorrowersRecord(EA2LoanApplicationController.saveRecord(data));

        test.stopTest();
    } */
}