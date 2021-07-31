@isTest
private class TATRevenueUpdate_Test {
    
    static testMethod void TATRevenueUpdate_Test () {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Contact C1= new Contact(lastname=testDataSetUpUtility.getRandomUsername(7),email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com',master_rep_id__c='ABCD',AccountId = testAccount.Id,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        
        insert C1;
        String strRecordTypeO = [Select Name, Id From RecordType
                                 where sObjectType='Opportunity' and Name='IAS Business Development'].Id;
        
        String strOwner = UserInfo.getUserId();
        
        Opportunity testOpportunity = new Opportunity(Name=testDataSetUpUtility.getRandomUsername(7), AccountId=testAccount.Id,
                                                      StageName='3 - Discussion', Contact__c=C1.id, LeadSource='Email',
                                                      CloseDate=system.today(), GDC_Prior_12_mo__c=1300000,
                                                      Assigned_Recruiter__c=strOwner,  RecordTypeId=strRecordTypeO);
        insert testOpportunity;
        
        
        Test.startTest();
        Financials__c f1 = new Financials__c (name= testDataSetUpUtility.getRandomUsername(7) ,Advisor__c=C1.id,TAT_GDC__c = 100,external_id__c='ABCD');
        insert F1; 
        Test.stopTest();
    }
}