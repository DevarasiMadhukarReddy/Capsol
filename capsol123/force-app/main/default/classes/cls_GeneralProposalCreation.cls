public class cls_GeneralProposalCreation {
    String loanAppId;
  public static void createProposalfromLoanAppl(String loanAppId) {
           Loan_Application__c loanApp;
         if(loanAppId != null){
        	loanApp= [SELECT id,Scenario__c,Business_Name_DBA__c,Loan_Purpose__c,Application_Type__c,Loan_Category__c,RecordTypeId FROM Loan_Application__c WHERE Id = :loanAppId];
        }
       
            Id WorkingCapitalRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Working_Capital').getRecordTypeId();
            Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();
			

            list<string> scenarioLst = new list<string>();
            list<Proposal_Offer__c> propLst = new list<Proposal_Offer__c>();
                   
             if(loanAppId != null && loanApp.Scenario__c != '' && loanApp.Scenario__c !=null && loanApp.RecordTypeId == WorkingCapitalRecordTypeId){
            	scenarioLst = loanApp.Scenario__c.split(';');
                    if(scenarioLst.size() > 0){
                            for(Integer i=0; i<scenarioLst.size(); i++){
                                Proposal_Offer__c prop = new Proposal_Offer__c();
                                prop.Proposal_Name__c = scenarioLst[i];
                                prop.LoanApp_MD__c = loanAppId;
                                prop.RecordTypeId = GeneralProposalRecordTypeId;
                                propLst.add(prop);
                            }
                               
                        }
             }
            system.debug('propLst'+propLst);
          
           insert propLst;            
       }

      
    
   
}