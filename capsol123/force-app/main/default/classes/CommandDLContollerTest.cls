@isTest(SeeAllData=false) 
private class CommandDLContollerTest{
    
    static testmethod void testcase1_InvokeServiceRequest() {
            
           Automated_Data_Processes__c adp1 = new Automated_Data_Processes__c();
           
           adp1.Process_Name__c = 'Activity_Insert_Non_Recurring';
           adp1.Target_Object__c ='Activity';
           
           insert adp1;
           
           Automated_Data_Processes__c adp2 = [Select id, Process_Name__c from Automated_Data_Processes__c where Process_Name__c = 'Activity_Insert_Non_Recurring' limit 1];
           
           ApexPages.StandardController sc = new ApexPages.standardController(adp2);
           
           String adpID = String.valueof(adp2.Id);   
           
           ApexPages.currentPage().getParameters().put('id', adpID );
           
           CommandDLContoller controller = new CommandDLContoller();  
               
           Test.startTest();
           Test.setMock(WebServiceMock.class, new commandDLMocklpl());
           
           controller.getFileCopyConfirmation();   
           controller.cancel();  
           Test.stopTest();  
           
           Automated_Data_Processes__c adp3 = [Select id, Process_Name__c, Moved_to_Production_Successful__c from Automated_Data_Processes__c where Process_Name__c = 'Activity_Insert_Non_Recurring' limit 1];
           
           system.assertEquals(adp3.Moved_to_Production_Successful__c, true);
           
    }
    
        static testmethod void testcase2_InvokeServiceRequest() {
            
           Automated_Data_Processes__c adp1 = new Automated_Data_Processes__c();
           
           adp1.Process_Name__c = 'Activity_Insert_Non_Recurring';
           adp1.Target_Object__c ='Activity';
           
           insert adp1;
           
           Automated_Data_Processes__c adp2 = [Select id, Process_Name__c, Moved_to_Production_Successful__c from Automated_Data_Processes__c where Process_Name__c = 'Activity_Insert_Non_Recurring' limit 1];
           
           ApexPages.StandardController sc = new ApexPages.standardController(adp2);
           
           String adpID = String.valueof(adp2.Id);   
           
           ApexPages.currentPage().getParameters().put('id', '');
           
           CommandDLContoller controller = new CommandDLContoller();  
               
           Test.startTest();
           Test.setMock(WebServiceMock.class, new commandDLMocklpl());
           
           controller.getFileCopyConfirmation();   
           controller.cancel();  
           Test.stopTest();  
           
           Automated_Data_Processes__c adp3 = [Select id, Process_Name__c, Moved_to_Production_Successful__c from Automated_Data_Processes__c where Process_Name__c = 'Activity_Insert_Non_Recurring' limit 1];
           
           system.assertEquals(adp3.Moved_to_Production_Successful__c, false);
           
    }
}