@IsTest
public class LPL_Zip3AssignmentContact_BatchTest {

    public static testmethod void zip3Test(){
        ID lplAdvisorRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        
         Zip3_Assignment__c zip = new Zip3_Assignment__c(
             												Regional_Business_Solutions_Consultant__c = UserInfo.getUserID(),
             												State__c = 'CA',
             												WMO_Division__c = 'West',
                                                            Insurance_Consultant__c = UserInfo.getUserID(),
                                            		      	Annuity_Consultant__c = UserInfo.getUserID(),
                                                            Financial_Planning_Consultant__c = UserInfo.getUserID(),
                                                            HNW_PTC_Consultant__c = UserInfo.getUserID(),
                                                            Business_Solutions_Consultant__c = UserInfo.getUserID()
                                                           );
        insert zip;
        
        Contact con = new Contact(
            FirstName = 'TestZip',
            Lastname = 'Batch Job',
            MailingState = 'CA',
            RecordTypeID = lplAdvisorRecTypeId
        );
        insert con;
        
        test.startTest();
         LPL_Zip3AssignmentContact_Scheduler batchjob =new LPL_Zip3AssignmentContact_Scheduler();
         String cron = '0 0 23 * * ?';  
         String jobid = System.schedule('LPL_Zip3AssignmentContact_Batch',cron,batchjob);
        test.stopTest();
    }
}