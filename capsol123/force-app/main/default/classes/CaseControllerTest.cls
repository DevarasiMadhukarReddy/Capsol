@isTest(seeAllData=false)
private  class CaseControllerTest {
    testMethod static void testData(){
        Case cs=new Case();
        cs.status='initiated';
        insert cs;
        caseController.loadLoanApplication(cs.Id);
        cs.status='Completed';
        update cs;
        caseController.loadLoanApplication(cs.Id);
    }
}