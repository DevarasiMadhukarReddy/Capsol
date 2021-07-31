@isTest
private class LeadConversionTest {

    static testMethod void myUnitTest() {
    
    Trigger_Bypass__c tbp = new Trigger_Bypass__c();
    tbp.name='Contact';
    tbp.IsOff__c = False;
    insert tbp;

     RecordType strRecordType = [Select ID, Name From RecordType
                  where sObjectType='Lead' and Name='Discovery Database Lead' limit 1];
     ID strOwner = UserInfo.getUserId();
                
       Default_Oppty_Owner__c testDOO = new Default_Oppty_Owner__c(OwnerId__c = strOwner, Name__c = 'Tom Test');
       insert testDOO;

       IAS_Recruiter_Assignment__c iasRA = new IAS_Recruiter_Assignment__c(
                                                 Name='C92612',
                                                 Assigned_Recruiter__c=strOwner,
                                                 Internal_Recruiter__c=strOwner,
                                                 Regional_VP__c=strOwner,
                                                 Lead_Type__c='Core',
                                                 State__c='CA',
                                                 External_Id__c  = 'XXX',
                                                 GDC_Maximum__c=1000,
                                                 GDC_Minimum__c=0); 
        insert iasRA;                                                            
        
        Lead testLead = new Lead(
                                 Company='Test Lead',
                                 Email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com',
                                 LastName='TEST',
                                 PostalCode='92612',
                                 LeadSource='Email',
                                 Status='Test',
                                 OwnerId=UserInfo.getUserId(),
                                 RecordTypeId = strRecordType.ID);
        insert testLead;
       
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.Id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        }
}