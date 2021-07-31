@isTest
private class testContTriggerHandler
{ 
   
   Public static testMethod void  updateAccountGDCPrior()
   {
       Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
         test.startTest();
         Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
       
         Account oAcct  = new Account ();
                 oAcct.Name ='Account Test Record';
                 insert oAcct;

        Contact oCont = new Contact();
                oCont.AccountId = oAcct.Id;
                oCont.FirstName = 'Contact Test Record';
                oCont.LastName='Test';
                oCont.GDC_Prior_12_mo__c = 2000;
                oCont.RecordtypeId = conRecTypeId;
                insert oCont;
                
              //  GDC_Prior_12_Months__c

                test.stoptest();

}

}