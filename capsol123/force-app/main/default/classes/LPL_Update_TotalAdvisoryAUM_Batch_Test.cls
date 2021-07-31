/*
Batch class Name              :LPL_Update_TotalAdvisoryAUM_Batch_Test
Developer Name                :Vaibhav Wadhai
Created Date                  :14 june 2017
Versio No                     :1.0 

*/
@isTest(seeAllData=False)
public class LPL_Update_TotalAdvisoryAUM_Batch_Test {
    
    public static Id conRecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    public static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    
    static testMethod void method1() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Recordss';
        insert oAcct;
        
        Contact ct1= new Contact(AccountId = oAcct.id, firstname = 'Fisrname', lastname = 'lastname22245',RecordTypeId = conRecordTypeId,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert ct1;
        
        Branch_Inst_Financial__c  branchObj=new Branch_Inst_Financial__c (name='1234-OSJ',Account__c=oAcct.id);
        insert branchObj;
        
        Opportunity op1 = new Opportunity(AccountId = oAcct.id, name = 'Test opportunity'
                                          , CloseDate =  system.today(), StageName = '1 - Unscreened Contact'
                                          , Zip_Code__c = '80538', GDC_Prior_12_mo__c = 200
                                          , Contact__c = ct1.Id, RecordTypeId = oppRecordTypeId);
        insert op1;
        
        test.startTest();
        LPL_Update_TotalAdvisoryAUM_Schedulable batchObj=new LPL_Update_TotalAdvisoryAUM_Schedulable();
        String sch = '0 0 23 * * ?'; 
        system.schedule('TestCheck',sch,batchObj); 
        test.stopTest();
    }
}