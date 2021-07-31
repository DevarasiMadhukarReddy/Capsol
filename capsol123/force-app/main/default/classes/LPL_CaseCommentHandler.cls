/*
Trigger Name            :LPL_CaseCommentHandler 
Description             :This Trigger Handler class contains logic realted to Custom object Case Comment.

Developer Name          :Pravin Kale
Created Date            :7/25/2017 

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
*/

public class LPL_CaseCommentHandler implements ITrigger {    
    
    LPL_CaseCommentGateway csjGateway = new LPL_CaseCommentGateway ();
    
    public LPL_CaseCommentHandler(){}
    
    public void bulkBefore(){}
    
    public void beforeInsert(SObject so){}
    public void beforeUpdate(SObject oldSo, SObject so){}
    public void beforeDelete(SObject so){}
    
    public void bulkAfter(){
        csjGateway.collectRecordToProcess(Trigger.new);
    }
    public void afterInsert(SObject so){
        Case_Comments_J__c newCSJ = (Case_Comments_J__c)so;         
        csjGateway.processEmailAlertComments(newCSJ, null);
    }
    public void afterUpdate(SObject oldSo, SObject so){
        Case_Comments_J__c newCSJ = (Case_Comments_J__c)so;
        Case_Comments_J__c oldCSJ = (Case_Comments_J__c)oldSo;
         
        csjGateway.processEmailAlertComments(newCSJ, oldCSJ);
    }
    public void afterDelete(SObject so){}
    
    public void andFinally(){}

}