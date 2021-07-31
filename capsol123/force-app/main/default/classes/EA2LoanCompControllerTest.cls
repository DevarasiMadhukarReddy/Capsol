@isTest(seeAllData=false)
private  class EA2LoanCompControllerTest {
    testMethod static void testData(){
        Case cs=new Case();
        cs.status='initiated';
        insert cs;
        EA2LoanCompController.collectCaseStatus(cs.Id);
        cs.status='Completed';
        update cs;
        EA2LoanCompController.collectCaseStatus(cs.Id);
        EA2LoanCompController.collectCaseStatus(null);
        EA2LoanCompController.checkLoggedInUserAccess('Opportunity');
        EA2LoanCompController.checkLoggedInUserAccess('Case');
        EA2LoanCompController.checkLoggedInUserAccess('Contact');
  
    }
}