@isTest
public class LPL_MedalliaDataConnectorSchedulerTest {
    @isTest 
    static void testBatchOnly () {
        List<Contact> contactsList = new List<Contact>();
        for(Integer i = 0; i < 10; i++) {
            contactsList.add(New Contact(
                LastName = 'Test Contact' + i,
                Master_Rep_ID__c = '7W'+i+'B',
                Net_Promoter_Score__c = i,
                NPS_Survey_Period__c = 'Q1 2019',
                NPS_Feedback_Details__c = 'https://lplfinancial.medallia.com/sso/lplfinancial/respInvForm.do?surveyid=69208'+i
            ));
        }
        
        insert contactsList;
        
        Test.setMock(HttpCalloutMock.class, new LPL_MedalliaMockResponseGenerator());
        // call the batch
        Test.startTest();
        ID BatchProcessdId = Database.executeBatch(new LPL_MedalliaDataConnectorBatch());    
        Test.stopTest();
    }
    
    @isTest static void testScheduler () {
        String cronExpr = '0 0 0 15 3 ? 2022';
        String jobRunningTime = '2022-03-15 00:00:00';
        Test.startTest();
        LPL_MedalliaDataConnectorScheduler schedulerObj= new LPL_MedalliaDataConnectorScheduler();
        String jobId = System.schedule('myJobTestJobName', cronExpr, schedulerObj);
        schedulerObj.execute(null);
        Test.stopTest();
    }
}