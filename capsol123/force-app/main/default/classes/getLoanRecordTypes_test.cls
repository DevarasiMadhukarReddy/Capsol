@isTest 
public class getLoanRecordTypes_test {
  
   static testMethod void SelectedValuesMethod() {
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ManagerId = userInfo.getUserId(),  
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgEHHealth.com');
        
       System.runAs(u){
      
      Test.startTest();
   getLoanRecordTypes  Lrt = new getLoanRecordTypes ();
           lrt.selectedname='Transition Assistance';
            Lrt.getselectedaccnamefields();
           Lrt.redir();
      Test.stopTest();
            getLoanRecordTypes  Lrt1 = new getLoanRecordTypes ();
           lrt1.selectedname='Working Capital';
           Lrt1.redir();
    
}

}

}