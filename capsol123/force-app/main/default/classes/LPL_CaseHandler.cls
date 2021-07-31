/*
Trigger Name            : LPL_CaseTrigger 
Trigger Description     :*. Update Transition Assist Dollars Offered field from Case to Opportunity.when Case record is inserted or updated. 

Developer Name          : Ashish Gupta - CTS
Created Date            : 7-Sep- 2017

#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
Ch-1  Update Transition Assist Dollars Offered from Case to Opportunity.          Ashish Gupta              7-Sep- 2017

Ch-2 Calling 'processFinallyOperations' method in LPL_CaseGateway class          Vaibhav Wadhai             11-Sept-2017
     from 'andFinally' method.
     

*/

public class LPL_CaseHandler implements ITrigger {

    LPL_CaseGateway caseGateway=new LPL_CaseGateway();
    
     public LPL_CaseHandler()
    {
    }
   
    public void bulkBefore()
    { 
          if(Trigger.isInsert){
            caseGateway.collectRecordToProcess(Trigger.new,null);    
        }
        if(Trigger.isUpdate){
            caseGateway.collectRecordToProcess(Trigger.new,Trigger.old);    
        }
        
    }
    
    public void bulkAfter()
    {
        if(Trigger.isInsert){
            caseGateway.collectRecordToProcess(Trigger.new,null);    
        }
        if(Trigger.isUpdate){
            caseGateway.collectRecordToProcess(Trigger.new,Trigger.old);    
        }
        
    }
    
    public void beforeInsert(SObject so)
    {
        
         Case obj=(Case)so;
         caseGateway.doBeforeInsertUpdateCase(obj);
       
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
         Case obj=(Case)so;
         Case oldoobj=(Case)oldSo;
         caseGateway.doBeforeInsertUpdateCase(obj);

    }
    
    public void beforeDelete(SObject so)
    {   
        
    }
    
    public void afterInsert(SObject so)
    {  Case obj=(Case)so;
      //** Ch-1 Start  Update Transition Assist Dollars Offered from Case to Opportunity on insert operation.
           caseGateway.updateTADOFromCaseToOpp(obj);
     //** Ch-1 End  Update Transition Assist Dollars Offered from Case to Opportunity on insert operation.
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    { 
         Case obj=(Case)so;
         Case oldoobj=(Case)oldSo;
        //** Ch-1 Start  Update Transition Assist Dollars Offered from Case to Opportunity on update operation.
        caseGateway.updateTADOFromCaseToOpp(obj);
       
         //** Ch-1 End  Update Transition Assist Dollars Offered from Case to Opportunity on update operation.
        
    }
    
    public void afterDelete(SObject so)
    {
    
    
    }
    
    
    public void andFinally()
    {
        // CH-02 START
        
        caseGateway.processFinallyOperations();
        
        // CH-02 END
    }
 

}