@isTest(SeeAllData=false)
//created By:Hiral patel
//Date:01/14/2019
//BFR005   Contacts qualification process to create opportunity 
public class OpportunityRecordtypeController_Test {
    @isTest
    public static void createRecordstoTest(){
           Account testAcc = new Account (Name = 'Test Account');
        {
            insert testAcc;
        }
        Trigger_Bypass__c t = new Trigger_Bypass__c();
        t.Name = 'Contact';
        t.isOff__c = true;
        Insert t;
        Contact con = new Contact(FirstName = 'TestContactF', LastName = 'TestContactL',accountid=testAcc.Id,
                                 Outside_Recruiting_Firm_Fee__c = 'Expired',Outside_Recruiting_Firm_Name__c= 'Cross Search',
                                  Outside_Recruiting_Firm_Payout__c = 60,   
                                  Lead_Approval_Date__c = Date.newInstance(2019, 02, 4));
      
        insert con;
        Test.startTest();
        OpportunityRecordtypeController.fetchRecordTypeValues();
        OpportunityRecordtypeController.getRecTypeId('IAS Business Development');
        OpportunityRecordtypeController.getContact('conId');
         Test.stopTest();
     
    }

}