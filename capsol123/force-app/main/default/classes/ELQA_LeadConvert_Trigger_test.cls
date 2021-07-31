@isTest(seealldata=true)
private class ELQA_LeadConvert_Trigger_test
{
   static testMethod void validateHelloWorld() 
    {
        ID LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Create New Manual Lead').getRecordTypeId();
        Lead testLead1=new Lead(lastname = 'Test Lead',
                                EMAIL = 'TESTR123@ABC.COM',
                                RecordTypeId = LeadRecordTypeId,
                                IsConverted = false);
        insert testlead1;
        Lead testLead=new Lead();
        testLead=[SELECT Id FROM lead 
                  WHERE email = 'TESTR123@ABC.COM' 
                  AND RecordTypeId =: LeadRecordTypeId 
                  AND IsConverted = false LIMIT 1];
        test.Starttest();
        //testLead.ownerid='005U0000000qxO5';
        testLead.email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com';
        update testLead;
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(testLead.id);
        ELOQUA__Marketing_Activity__c a = new ELOQUA__Marketing_Activity__c();
        a.ELOQUA__Lead__c=testLead.id;
        insert a;
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        test.Stoptest();


    }
}