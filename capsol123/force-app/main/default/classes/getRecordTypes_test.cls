@istest
public class getRecordTypes_test {
static testMethod void SelectedValuesMethod1() {
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ManagerId = userInfo.getUserId(),  
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgEHHealth.com');
        
       System.runAs(u){
      
      Test.startTest();
   getRecordTypes  Lrt = new getRecordTypes ();
           lrt.selectedname='Growth loan';
           Lrt.getselectedaccnamefields();
           Lrt.redir();
           getRecordTypes  Lrt1 = new getRecordTypes ();
           lrt1.selectedname='Acquisition loan';
           Lrt1.getselectedaccnamefields();
           Lrt1.redir();
           getRecordTypes  Lrt2 = new getRecordTypes ();
           lrt2.selectedname='Line of Credit';
           Lrt2.getselectedaccnamefields();
           Lrt2.redir();
           getRecordTypes  Lrt3 = new getRecordTypes ();
           lrt3.selectedname='Refinance Loan';
           Lrt3.getselectedaccnamefields();
           Lrt3.redir();
           
      Test.stopTest();
               
}

}
}