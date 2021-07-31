@istest
public class RecordTypeSelector_test {

    @isTest static void  Recordtypeselectors(){
        
           
            RecordTypeSelector RTS= new RecordTypeSelector();
           RecordTypeSelector.fetchRecordTypeValues('Loan_Application__c');
Loan_Application__c loan=new Loan_Application__c();
loan.Acquisition_comment__c='test';
INSERT loan;
           RecordTypeSelector.GetLoanObjectInformtion();
              Account a1 = new Account(Name = 'Test Account');
        insert a1;
             Opportunity op1 = new Opportunity(AccountId = a1.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200);
             insert Op1;
                      
   Test.setMock(HttpCalloutMock.class, new cls_LPL_sendsfdatamulesoftTest.MockHttpResponseGenerator());
    test.startTest(); 
           RecordTypeSelector.GetOpportunityDetails(Op1.Id);
         
            test.stopTest();
               
        }      
    
}