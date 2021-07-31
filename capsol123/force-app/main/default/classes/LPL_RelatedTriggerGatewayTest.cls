@isTest
public class LPL_RelatedTriggerGatewayTest {
    static testmethod void datasetup(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        Id isInstitution = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IS - Institution').getRecordTypeId(); 
        List<Account> accList = new List<Account>();
        Account acc1 = new Account(Name='Program Manager Test', RecordTypeId=isInstitution);
        acclist.add(acc1);
        insert accList;
        
        List<Contact> conList = new List<Contact>();
        Contact con1= new Contact(firstname = 'Fisrtname', lastname = 'lastname');
        conList.add(con1);
        
        Contact con2= new Contact(firstname = 'Fisrt2', lastname = 'lastname', PM_Communication_List__c = true, PM_Contact_Level__c = 'Primary PM Contact', Hire_Date__c = Date.today());
        conList.add(con2);
        Contact con3= new Contact(firstname = 'Fisrt3', lastname = 'lastname',PM_Communication_List__c = true, PM_Contact_Level__c = 'Primary PM Contact', Hire_Date__c = (Date.today()-2));
        conList.add(con3);
        insert conlist;
        
        system.debug('Con1ID'+con1.id);
        system.debug('Con2ID'+con2.id);
        system.debug('Con3ID'+con3.id);
        
        related__c rel = new related__c(Relationship_Type__c = 'Advisor & PM',Enterprises__c = acc1.id, Related_Contacts__c = con1.id  );
        insert rel;
        related__c rel2 =new related__c(Relationship_Type__c = 'PM', Enterprises__c = acc1.id, Related_Contacts__c = con2.id );
        insert rel2;
        related__c rel3 =new related__c(Relationship_Type__c = 'PM & OSJ', Enterprises__c = acc1.id, Related_Contacts__c = con3.id );
        insert rel3;
        
        
        
        List<Account> acclist1=new List<Account>();
        test.starttest();
        acclist1=[SELECT Id,Program_Manager__c,(SELECT Id,Contact_Level__c FROM Contacts WHERE Rep_Status__c = 'Active' AND Role__c = 'Program Manager' ORDER BY Contact_Level__c , CreatedDate, Hire_Date__c LIMIT 1),(SELECT Id, Related_Contacts__c,Related_Contacts__r.Contact_Level__c FROM Related_Enterprises__r WHERE Relationship_Type__c IN ('Advisor & PM', 'PM', 'PM & OSJ') ORDER BY Related_Contacts__r.Contact_Level__c, Related_Contacts__r.Hire_Date__c desc LIMIT 1) FROM Account WHERE RecordType.Name = 'IS - Institution'];
        system.assertEquals(acclist1[0].Program_Manager__c,rel2.Related_Contacts__c);
        delete rel2;
        test.stopTest();
    }
    
}