@isTest

public class LPL_MarketingActivityDelete_Batch_Test {
    
  public static Id strConRecordType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    
    static testmethod void TestMarketdelete() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c =False;
        insert tbp;
        
        Contact con1= new Contact(Lastname='Marketdelete',RecordTypeId=strConRecordType);
        insert con1;

        ELOQUA__Marketing_Activity__c Marketdata1 = new ELOQUA__Marketing_Activity__c(Name = 'DeleteActive',ELOQUA__Activity_Type__c = 'Email Sent', ELOQUA__Contact__c =con1.id);
        insert Marketdata1;
        
        Test.setCreatedDate(Marketdata1.Id, DateTime.newInstance(2016,12,07));
        
        /*Exceuting the batch Job*/
        try{
            Test.startTest();
            LPL_MarketingActivityDelete_Batch bc = new LPL_MarketingActivityDelete_Batch();
            Database.executeBatch(bc);
            Test.stopTest();   
        }
        Catch(Exception ex){
           system.debug('Exception Occured: '+ex.getMessage()); 
        }
    }
    
    
}