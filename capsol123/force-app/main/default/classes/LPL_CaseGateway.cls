/*
Trigger Name            : LPL_CaseTrigger 
Trigger Description     :*. Update Transition Assist Dollars Offered field from Case to Opportunity.when Case record is inserted or updated. 

Developer Name          : Ashish Gupta - CTS
Created Date            : 7-Sep- 2017

#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
Ch-1  Update Transition Assist Dollars Offered from Case to Opportunity.          Ashish Gupta              7-Sep- 2017

CH-02 Added condition for record type for Opportunity and Case.                  Vaibhav Wadhai             11-Sept-2017
                  
      Added updation of opportunityList in processFinally
      block.
      
      Added condtion to check when Transition_Assist_Dollars_Offered__c field
      is having blank value or not  when Case is getting created.

ch-03 Updating IRD and Assign Recuiter from case to Opportunity               Ashish Gupta                   5-oct-2017  

ch-04 Updating TA Doller Field From Opportunity                               Pravin Kale                   6-oct-2017  

CH-05  Changed the record type name from Project J to Business Development    Ishan Nigam                   2-Dec-2020
        as part of Project Wreath changes.        

Test Class-LPL_CaseGateway_Test
*/
public without sharing class LPL_CaseGateway {
    
    Set<ID> OppIDset=new Set<ID>();
    public List<Opportunity> opplist=new  List<Opportunity>();
    
    public static Boolean stopOppTrigger = false;
    Map<Id, Case> caseMap=new Map<ID,Case>();
    Map<Id,Opportunity> oppMap=new Map<Id,Opportunity>();
    List<Opportunity> newOpplist=new  List<Opportunity>();
    
    Map<ID,Opportunity> newOppMap=new Map<ID,Opportunity>();//to handle duplicate ids.
    
    //CH-02 Start
    
    Id oppIASbusinessDevRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();//added by vaibhav to get id of record type of 'IAS Business Development' of Opportunity
    Id caseProjectJRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();// Changed the project type from Project J to Business Development as part of Project Wreath
    
    //CH-02 END
    
    public void collectRecordToProcess(List<Case> newCAList, List<Case> oldCAList){
        
         try{
            
            for(Case caseObj:newCAList) {
                
                if(caseObj.recordTypeId ==caseProjectJRecId) { //CH-02 Start ..END
                
                    if(caseObj.Opportunity__c!=null) {
                    
                        OppIDset.add(caseObj.Opportunity__c);
                        caseMap.put(caseObj.ID,caseObj);
                    
                    }
                }
            }
            
            //Ch-02 Start
            opplist=[select Id,Transition_Assist_Dollars_Offered__c, Max_TA_Dollars_Allowed__c from Opportunity where ID In:OppIDset and recordTypeId =:oppIASbusinessDevRecId];
            //Ch-02 End
              
             System.debug('***123opplist'+opplist);
              
             if(opplist.size()>0) {
                
             for(Opportunity opp:opplist) {
               
                 oppMap.put(opp.id, opp);
             }
             
             }
        }  
        
        catch(exception e){
            
            System.debug('LPL_CaseGateway:' + e.getTypeName() + 'collectRecordToProcess:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_CaseGateway','collectRecordToProcess',e.getMessage(),e.getLineNumber(),e.getTypeName()); //added by vaibhav
        }
        
    }
    
    public Void  updateTADOFromCaseToOpp(Case caseObj) {
       // ch-01 Start
         try{
             
             if(caseMap.containsKey(caseObj.id) && oppMap.size()>0) { 
                   
                 if(caseMap.get(caseObj.id).Opportunity__c==caseObj.Opportunity__c) {
                                                           
                     System.debug('***123'+String.isNotBlank(String.valueOf(caseObj.Transition_Assist_Dollars_Offered__c)));
                     
                     //CH-02 Start
                     if(caseObj.Transition_Assist_Dollars_Offered__c!=null && String.isNotBlank(String.valueOf(caseObj.Transition_Assist_Dollars_Offered__c))) { // Added by vaibhav to check value is null or blank
                     //Ch-02 End
                         
                         if(caseObj.Opportunity__c !=null) { //checking opportunity is null or not
                         
                             oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c=caseObj.Transition_Assist_Dollars_Offered__c;                                                                  
                     
                             //newOpplist.add(oppMap.get(caseObj.Opportunity__c));
                             
                             newOppMap.put(caseObj.Opportunity__c,oppMap.get(caseObj.Opportunity__c));// to remove duplicates opportunities ids.
                         
                         }
                     
                     }
                     System.debug('***123000'+String.isBlank(String.valueOf(caseObj.Transition_Assist_Dollars_Offered__c)));
                     
                     //Ch-02 Start
                     System.debug('caseObj.Opportunity__c>>'+caseObj.Opportunity__c+' caseObj.Transition_Assist_Dollars_Offered__c>'+caseObj.Transition_Assist_Dollars_Offered__c+' Blank value>> '+String.isBlank(String.valueOf(caseObj.Transition_Assist_Dollars_Offered__c)));
                     if(caseObj.Transition_Assist_Dollars_Offered__c==null && String.isBlank(String.valueOf(caseObj.Transition_Assist_Dollars_Offered__c))) { //here checking Transition_Assist_Dollars_Offered__c is blank or not.
                     
                         if(caseObj.Opportunity__c!=null) { //checking Opportunity is null or not
                         
                             //oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c=0; //updating with zero value
                             
                             //newOpplist.add(oppMap.get(caseObj.Opportunity__c));
                              
                             newOppMap.put(caseObj.Opportunity__c,oppMap.get(caseObj.Opportunity__c));// to remove duplicates opportunities ids
                         
                         }
                     
                     }
                     //Ch-02 End
                 }
                 
                 //ch-03 Start  
                 if(caseMap.get(caseObj.id).Opportunity__c == caseObj.Opportunity__c) {
                       System.debug('updating IRD and Assigned_Recruiter');
                     oppMap.get(caseObj.Opportunity__c).Assigned_Recruiter__c=caseObj.Assigned_Recruiter__c;
                     
                       System.debug('Assigned_Recruiter>'+caseObj.Assigned_Recruiter__c);
                     
                      oppMap.get(caseObj.Opportunity__c).Internal_Recruiter_IRD__c=caseObj.IRD__c;
                     
                        System.debug('IRD>'+caseObj.IRD__c);
                      newOppMap.put(caseObj.Opportunity__c,oppMap.get(caseObj.Opportunity__c));
                 }
                //ch-03 End 
                 
             }
                            
          //ch-01 End  
        
           
             
         } 
        catch(exception e){
            
            System.debug('LPL_CaseGateway:' + e.getTypeName() + 'updateTADOFromCaseToOpp:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_CaseGateway','updateTADOFromCaseToOpp',e.getMessage(),e.getLineNumber(),e.getTypeName()); //added by vaibhav
        }
        
        
    }
    
    public void updateTADOFromCaseToOppInAfterUpdate(Case caseObjold,Case caseObjNew) {
        /*
        try {
            
            if(caseMap.containsKey(caseObjNew.id)){
                   
                 if(caseMap.get(caseObjNew.id).Opportunity__c==caseObjNew.Opportunity__c) {
                                                                                                     
                     if(caseObjold.Transition_Assist_Dollars_Offered__c!=caseObjNew.Transition_Assist_Dollars_Offered__c) { // Added by vaibhav to check Transition_Assist_Dollars_Offered__c is changed or not.
                     
                         oppMap.get(caseObjNew.Opportunity__c).Transition_Assist_Dollars_Offered__c=caseObjNew.Transition_Assist_Dollars_Offered__c;                                                                  
                     
                         newOpplist.add(oppMap.get(caseObjNew.Opportunity__c));
                     
                     }
                 }
                 
             }
            
        }
        catch(exception e) {
        
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_CaseGateway','updateTADOFromCaseToOppInAfterUpdate',e.getMessage(),e.getLineNumber(),e.getTypeName()); //added by vaibhav
        
        }
        */
    }
    public void doBeforeInsertUpdateCase(Case caseObj){
            //
            try{
                if(caseMap.containsKey(caseObj.id) && oppMap.size()>0) { //checking case map contains 
                
                    if(caseMap.get(caseObj.id).Opportunity__c==caseObj.Opportunity__c) {
                    
                         if(caseObj.Opportunity__c !=null && caseObj.Transition_Assist_Dollars_Offered__c==null && String.isBlank(String.valueOf(caseObj.Transition_Assist_Dollars_Offered__c))) {
                         
                             if(oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c!=Null && String.isNotBlank(String.valueOf(oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c))) {
                             
                                 caseObj.Transition_Assist_Dollars_Offered__c=oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c;
                                 
                                 System.debug('***123abc'+oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c);
                             }
                         }
                    }
                
                }
                
                 //System.debug('caseObj.Transition_Assist_Dollars_Offered__c1 >>'+caseObj.Transition_Assist_Dollars_Offered__c);
                 //System.debug(' oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c>>'+ oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c);
                
                //ch-04 - Added by pravin Kale to update the TA Doller field from Opportunity if Case field is blank.
                if(caseObj.Transition_Assist_Dollars_Offered__c == null && caseObj.Opportunity__c != null ){
                    System.debug('If case TA field is blank');
                    caseObj.Transition_Assist_Dollars_Offered__c =  oppMap.get(caseObj.Opportunity__c).Transition_Assist_Dollars_Offered__c;  
                  //System.debug(' caseObj.Transition_Assist_Dollars_Offered__c2>>'+ caseObj.Transition_Assist_Dollars_Offered__c);
                
                }
                
            }
            catch(Exception e){
            
                 LPL_CreateExceptionLog.createErrorRecordAsync('LPL_CaseGateway','doBeforeInsertCase',e.getMessage(),e.getLineNumber(),e.getTypeName());
            }
            //
    }
    public void processFinallyOperations(){
    
    //Ch-02 Start
       try {
        
            /*if(newOpplist.size()>0 && newOpplist!=null ){ 
              stopOppTrigger = true;   
              update newOpplist;  
                
            }*/
            
            if(newOppMap.size()>0 && newOppMap!=null ){ 
            
              stopOppTrigger = true;   
              
              update newOppMap.values();  
                
            }
       
       }
       catch(Exception e) {
        system.debug('####@@@@');
           LPL_CreateExceptionLog.createErrorRecordAsync('LPL_CaseGateway','processFinallyOperations',e.getMessage(),e.getLineNumber(),e.getTypeName()); 
       }
        
        
     //Ch-02 End
    }

}