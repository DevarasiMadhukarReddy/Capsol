// This class is no longer used for any functionality hence commneting the entire class - Amol 11/04/2020

global class cls_LPL_SubmitLoanApplication {
   /*  String loanAppId;
    Loan_Application__c loanApp;
    
    public cls_LPL_SubmitLoanApplication (String loanAppId) { 
        this.loanAppId= loanAppId;
    }
    
    @AuraEnabled 
    public static List<String> checkLoanApplication(String loanAppId){
        return wcLoanApplicationController.checkLoanappliction(loanAppId);
    }
    @AuraEnabled
    public static void createProposalfromScenarioAura(String loanAppId) {
        if(String.isNotBlank(String.valueOf(loanAppId))) {
            
            cls_LPL_SubmitLoanApplication  ac = new cls_LPL_SubmitLoanApplication (loanAppId);
            ac.getLoanApplicationRecord();
             ac.createProposalfromLoanAppl();
            
        } else {
            System.debug('Error in submitting Application');
        }
        
    }
    
    @AuraEnabled
    public static String createProposalfromScenarioAuraRepayables(String loanAppId) {
        if(String.isNotBlank(String.valueOf(loanAppId))) {
            
            cls_LPL_SubmitLoanApplication  ac = new cls_LPL_SubmitLoanApplication (loanAppId);
            ac.getLoanApplicationRecord();
            return ac.createProposalfromLoanApplRepayables();
            
        } else {
            return 'Unable to create an application! Application details are missing';
        }
        
    }
    
    @testvisible
    private  String createProposalfromLoanApplRepayables() {
        system.debug('loanAppId'+loanAppId);
        try {
            if(loanAppId != null){
                loanApp= [SELECT id,Business_Name_DBA__c,Loan_Purpose__c,Application_Type__c,Loan_Category__c,RecordTypeId FROM Loan_Application__c WHERE Id = :loanAppId];
                system.debug('loanApp'+loanApp);
            }
         Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();
         list<Proposal_Offer__c> propLst = new list<Proposal_Offer__c>();
               if(loanAppId != null){
                Proposal_Offer__c prop = new Proposal_Offer__c();
                prop.Name = 'Repayable Offer';
                prop.Offer_Name__c = 'Repayable Offer';
                prop.Proposal_Name__c = 'Repayable Offer';
               // prop.Loan_Type__c= 'Repayable';
                prop.LoanApp_MD__c = loanAppId;
                prop.RecordTypeId = GeneralProposalRecordTypeId;
                prop.DBA_Business_Name__c = loanApp.Business_Name_DBA__c;
                prop.Loan_Type__c = loanApp.Loan_Purpose__c;
                
                propLst.add(prop);
                
                insert propLst; 
            }
            system.debug('propLst1111'+propLst);
            List<Id> propIds = new List<Id>();
            List<Proposal_Offer__c> props = [select id from Proposal_Offer__c where LoanApp_MD__c =: loanAppId];
            for(Proposal_Offer__c prop:props){
                propIds.add(prop.id);
            }
            system.debug('propIds'+propIds);
            
            cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanAppId,propIds);
            
            return 'SUCCESS! General Proposals has been created.';
        }
        catch(Exception e) {
            
            System.debug('##### Error in creating Proposals ##### ' + e.getStackTraceString());
            if(e.getLineNumber()==31)
                return 'Error in creating an Proposals. ' ;
            else 
                return 'Error in creating an Proposals.'+ e.getMessage();
        } 
    }
    */
    
  /* webService static String createProposalfromScenario(String loanAppId) {
        if(String.isNotBlank(String.valueOf(loanAppId))) {
            
            cls_LPL_SubmitLoanApplication  ac = new cls_LPL_SubmitLoanApplication (loanAppId);
            ac.getLoanApplicationRecord();
            return ac.createProposalfromLoanAppl();
            
        } else {
            return 'Unable to create an application! Case details are missing';
        }
        
    }*/
  /* @testvisible
    private void getLoanApplicationRecord() {
        
        if(loanAppId != null){
            loanApp= [SELECT Id,Scenario__c,Business_Name_DBA__c,Loan_Purpose__c,Application_Type__c,Loan_Category__c,RecordTypeId FROM Loan_Application__c WHERE Id = :loanAppId];
        }
        
        
    }
    @testvisible
    private void createProposalfromLoanAppl() {
        
        try {
            Id RetensionLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Retention_Loan').getRecordTypeId();
            Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
            
            Id TAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
            Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();
            
            
            /*list<string> scenarioLst = new list<string>();*/
           /* if(loanAppId != null){
                List<Proposal_Offer__c> propLst = new List<Proposal_Offer__c>();
                List<Proposal_Offer_Placeholder__c> POPList = [Select Campaign_Name__c, Loan_Application__c, OSJ_LE_Name__c, Platform__c,
                                                          Term_Length__c, U_W_Type__c, Branch__c from Proposal_Offer_Placeholder__c where 
                                                          Loan_Application__c =: loanAppId];

                System.debug('POPList'+POPList);
                Integer i = 1;
                if(POPList.size() > 0){
                    Proposal_Offer__c pro;
                    for(Proposal_Offer_Placeholder__c pop : POPList){
                        pro = new Proposal_Offer__c();
                       //madhu 
                       pro.Branch__c = pop.Branch__c;
                      //madhu 
                      pro.Campaign__c = pop.Campaign_Name__c;
                      // madhu 
                      pro.Platform__c = pop.Platform__c;
                        pro.OSJ__c = pop.OSJ_LE_Name__c;
                        pro.LoanApp_MD__c = pop.Loan_Application__c;
                      //madhu 
                      pro.U_W_Type__c = pop.U_W_Type__c;
                        pro.Name = 'Forgivable Offer '+i++;
                        pro.Proposal_Name__c= pro.Name;
                        pro.Offer_Name__c = pro.Name;
                        pro.RecordTypeId = TAProposalRecordTypeId;
                        pro.DBA_Business_Name__c = loanApp.Business_Name_DBA__c;
                        pro.Loan_Type__c = loanApp.Loan_Purpose__c;
                        //pro.Loan_Type__c= 'Forgivable';
                        if(pop.Term_Length__c == '3 Years') {
                       //madhu 
                       pro.Loan_Term__c = '3';
                        } 
                        if(pop.Term_Length__c == '5 Years') {
                        //madhu 
                        pro.Loan_Term__c = '5';
                         } 
                         if(pop.Term_Length__c == '7 Years') {
                         //madhu 
                         pro.Loan_Term__c = '7';
                         } 
                         if(pop.Term_Length__c == '10 Years') {
                        //madhu  
                        pro.Loan_Term__c = '10';
                         } 
                        propLst.add(pro);
                    }
                  
                }

                Proposal_Offer__c prop = new Proposal_Offer__c();
                    prop.Name = 'Repayable Offer';
                    prop.Offer_Name__c = 'Repayable Offer';
                    prop.Proposal_Name__c='Repayable Offer';
                    //prop.Loan_Type__c= 'Repayable';
                    prop.LoanApp_MD__c = loanAppId;
                    prop.RecordTypeId = GeneralProposalRecordTypeId;
                    prop.DBA_Business_Name__c = loanApp.Business_Name_DBA__c;
                    prop.Loan_Type__c = loanApp.Loan_Purpose__c;
                    propLst.add(prop);
                    System.debug('propLst'+propLst);
                    insert propLst;
            }
            
            List<Id> propIds = new List<Id>();
            List<Proposal_Offer__c> props = [select id from Proposal_Offer__c where LoanApp_MD__c =: loanAppId];
            for(Proposal_Offer__c prop:props){
                propIds.add(prop.id);
            }
            system.debug('propIds'+propIds);
            // if(propIds != null){
            //cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanAppId,propIds);
            cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanAppId,propIds);
            
            // }
            //return 'SUCCESS! Proposals has been created.';
        } catch(Exception e) {
            
            System.debug('##### Error in creating Prposals ##### ' + e.getStackTraceString());
            if(e.getLineNumber()==31)
                System.debug( 'Error in creating an Proposals. ' );
            else 
                System.debug( 'Error in creating an Proposals.'+ e.getMessage());
        }     
    }
    @testvisible
    private  String createProposalfromLoanApp2(String loanAppId) {
        system.debug('loanAppId'+loanAppId);
        try {
            if(loanAppId != null){
                loanApp= [SELECT id,Business_Name_DBA__c,Loan_Purpose__c,Application_Type__c,Loan_Category__c,RecordTypeId FROM Loan_Application__c WHERE Id = :loanAppId];
                system.debug('loanApp'+loanApp);
            }
         Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();
         list<Proposal_Offer__c> propLst = new list<Proposal_Offer__c>();
               if(loanAppId != null){
                Proposal_Offer__c prop = new Proposal_Offer__c();
                prop.Name = 'Repayable Offer';
                prop.Offer_Name__c = 'Repayable Offer';
                prop.Proposal_Name__c='Repayable Offer';
               // prop.Loan_Type__c= 'Repayable';
                prop.LoanApp_MD__c = loanAppId;
                prop.RecordTypeId = GeneralProposalRecordTypeId;
                prop.DBA_Business_Name__c = loanApp.Business_Name_DBA__c;
                prop.Loan_Type__c = loanApp.Loan_Purpose__c;
                
                propLst.add(prop);
                
                insert propLst; 
            }
            system.debug('propLst1111'+propLst);
            List<Id> propIds = new List<Id>();
            List<Proposal_Offer__c> props = [select id from Proposal_Offer__c where LoanApp_MD__c =: loanAppId];
            for(Proposal_Offer__c prop:props){
                propIds.add(prop.id);
            }
            system.debug('propIds'+propIds);
            
            cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanAppId,propIds);
            
            return 'SUCCESS! General Proposals has been created.';
        }
        catch(Exception e) {
            
            System.debug('##### Error in creating Prposals ##### ' + e.getStackTraceString());
            if(e.getLineNumber()==31)
                return 'Error in creating an Proposals. ' ;
            else 
                return 'Error in creating an Proposals.'+ e.getMessage();
        } 
    }
    
    webService static String createProposalfromScenarioforProposal(String loanAppId) {
        system.debug('first loanAppId'+loanAppId);
        if(String.isNotBlank(String.valueOf(loanAppId))) {
            
            cls_LPL_SubmitLoanApplication  ac = new cls_LPL_SubmitLoanApplication (loanAppId);
            ac.getLoanApplicationRecord();
            return ac.createProposalfromLoanApp2(loanAppId);
            
        } else {
            return 'Unable to create an application! some details are missing';
        }
        
    }   */
    
}