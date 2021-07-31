/*
Trigger Handler         : LPL_ContractAccommodation_TriggerHandler
Trigger Gateway         :LPL_ContractAccommodation_TriggerGateway
Developer Name          : Ashish Gupta - CTS
Created Date            : 12 july 2017
Description             : This trigger on Contract Accommodation Object.  


Note : Test Coverage for This trigger is covered in Test classes  :LPL_ContractAccommodationTrigger_Test
*/



trigger LPL_ContractAccomodationTrigger on Contract_Accommodation__c (  before insert, before update,before delete,after delete, after insert, after update) {


   
    TriggerFactory.createHandler(Contract_Accommodation__c.sObjectType);
    
    
}