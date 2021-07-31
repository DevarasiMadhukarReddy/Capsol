@isTest
public class LBS_OpportunityProductTriggerhandlerTest {
    @isTest static void testLineItemMethod() 
    {        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ManagerId = userInfo.getUserId(),  
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgEHHealth.com');
        
        System.runAs(u){  
            Test.startTest();
            Id pricebookId = Test.getStandardPricebookId();
            
            //Create your product
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true,
                Product_Term__c = 10
            );
            insert prod;
            
            Product2 prod1 = new Product2(
                Name = 'Product Y',
                ProductCode = 'Pro-Y',
                isActive = true,
                Product_Term__c = 20
            );
            insert prod1;
            
            //Create your pricebook entry
            PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true
            );
            insert pbEntry;
            
            PricebookEntry pbEntry1 = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod1.Id,
                UnitPrice = 200.00,
                IsActive = true
            );
            insert pbEntry1;
            
            Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
            
            
            Opportunity  opty4 = new Opportunity ();
            opty4.name='test';
            opty4.StageName='Engaged opportunity';
            opty4.Type='Technology Solution';
            opty4.CloseDate =  system.today();
            opty4.Close_Won_Reason__c='Cybersecurity gaps';
            opty4.Probability=20;
            opty4.RecordTypeId= OppRecordTypeId;
            
            insert opty4;
            
            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = opty4.Id,
                Quantity = 5,
                PricebookEntryId = pbEntry.Id,
                TotalPrice = 5 * pbEntry.UnitPrice               
            );
            Insert oli;
            
            OpportunityLineItem oli1 = new OpportunityLineItem(
                OpportunityId = opty4.Id,
                Quantity = 4,
                PricebookEntryId = pbEntry1.Id,
                TotalPrice = 4 * pbEntry1.UnitPrice
            );
            Insert oli1;
            Delete oli1;            
            Test.stopTest();
        }
    }
}