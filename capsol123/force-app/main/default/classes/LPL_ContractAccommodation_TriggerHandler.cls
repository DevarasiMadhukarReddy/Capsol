/*
Trigger Name            : LPL_ContractAccomodationTrigger 
Trigger Gateway         :LPL_ContractAccommodation_TriggerGateway
Developer Name          : Ashish Gupta - CTS
Created Date            : 12 july 2017

#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
Ch-1  Method that update Business Consultant RM of Contract Accommodation             Ashish Gupta                        12 july 2017
      from related Contact.
Ch-2   method that update PayeeID of Contract Accommodation from Contact's Master ID.     Ashish Gupta                       18 july 2017
Ch-3  Inside this method added logic to calculate Annual GP Impact with custom Setting      Ashish Gupta                       28 july 2017
Ch-4  Inside this method added logic to calculate GL acccount and GL Department             Ashish Gupta                       7 August 2017
            with custom Setting
            
Ch-05 Added method 'processReord' for  handling validation error in approval process        Vaibhav Wadhai                     5 September 2017
 
CH-06 US-1340 Proposal Status Flag - Pending OSJ Credit Approval                            Amol Deshpande                     22 July 2020

Note : Test Coverage for This trigger is covered in Test classes  :LPL_ContractAccommodationTrigger_Test
*/
public class LPL_ContractAccommodation_TriggerHandler  implements ITrigger{
    
    LPL_ContractAccommodation_TriggerGateway triggerGateway  =new LPL_ContractAccommodation_TriggerGateway();
    
    
    
    public LPL_ContractAccommodation_TriggerHandler()
    {
    }
    
    
    
    public void bulkBefore()
    { 
        if(Trigger.isInsert){
            triggerGateway.collectRecordToProcess(Trigger.new,null);    
        }
        if(Trigger.isUpdate){
            triggerGateway.collectRecordToProcess(Trigger.new,Trigger.old);    
        }
        
        
    }
    
    public void bulkAfter()
    {
        if(Trigger.isInsert){
            triggerGateway.collectRecordToProcess(Trigger.new,null);    
        }
        if(Trigger.isUpdate){
            triggerGateway.collectRecordToProcess(Trigger.new,Trigger.old);    
        }
        
    }
    
    public void beforeInsert(SObject so)
    {
        Contract_Accommodation__c obj=(Contract_Accommodation__c)so;
             //** Ch-1 and CH-02 start this method is use to update RM and payID from Contact to CA on before insert.
        triggerGateway.updateRMContactToAccommodation(obj); 
       //** Ch-1 and CH -02 End
       
         //** Ch-3 and ch-04start this method is use to calculate annual GP on before insert.
        triggerGateway.calculateAnnualGpImpact(null,obj);
       
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        Contract_Accommodation__c obj=(Contract_Accommodation__c)so;
         Contract_Accommodation__c oldoobj=(Contract_Accommodation__c)oldSo;
          //** Ch-1 and CH-02 start this method is use to update RM and payID from Contact to CA on before update
        triggerGateway.updateRMContactToAccommodation(obj);
       //** Ch-1 and CH-02 End
       //** Ch-3 and ch-04 start this method is use to calculate annual GP and GL account on before update.
        triggerGateway.calculateAnnualGpImpact(oldoobj,obj);
          //** Ch-3 and ch-04 End
          
          //CH-05 START
                              
          triggerGateway.processRecord(obj);
          triggerGateway.processNonCARTRecord(obj);
          
          //CH-05 END

    }
    
    public void beforeDelete(SObject so)
    {   
        
    }
    
    public void afterInsert(SObject so)
    {
       
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    { 
    // CH-06 Start
    
    Contract_Accommodation__c newCA = (Contract_Accommodation__c)so;
    Contract_Accommodation__c oldCA = (Contract_Accommodation__c)oldSo;
    triggerGateway.updateSelectedProposalStatus(newCA);
    
    // CH-06 End
        
    }
    
    public void afterDelete(SObject so)
    {
    
    
    }
    
    
    public void andFinally()
    {
        
    }
    
    
    
}