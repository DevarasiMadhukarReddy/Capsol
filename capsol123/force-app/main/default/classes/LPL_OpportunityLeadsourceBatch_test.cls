@isTest(seeAllData=false)
public class LPL_OpportunityLeadsourceBatch_test {
    public static Id strRecordTypeC=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    static testmethod void method1() {
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        contact ct1=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
        insert ct1;
        List<Opportunity> oppInsert = new List<Opportunity>();
        Opportunity op1 = new Opportunity(name = 'Test opportunity', CloseDate =  system.today()
                                          , StageName = '1 - Unscreened Contact', Zip_Code__c = '80538'
                                          , GDC_Prior_12_mo__c = 200, Contact__c=ct1.id);
        oppInsert.add(op1);
        Set<ID> O =new Set<ID>();
        for(Opportunity opp :oppInsert){
            O.add(opp.Contact__c);
        }
        List<Contact>  Con =[Select id,Lead_source__c from contact where Recordtype.Name='Contact prospect' AND ID in:o];
        test.startTest();
        LPL_OpportunityLeadsourceBatch batchObj = new LPL_OpportunityLeadsourceBatch();            
        Database.executeBatch(batchObj);
        test.stopTest();
    }
}