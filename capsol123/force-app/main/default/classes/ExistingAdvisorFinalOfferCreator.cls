public class ExistingAdvisorFinalOfferCreator {
    
    public static cls_gl_string__c settings = cls_gl_string__c.getInstance();
    public ExistingAdvisorFinalOfferCreator() {
        if(settings == null) {
            throw new ints.IntegrationException('GL String has not been set.'); 
        }
        
    }
    
     
    
    @InvocableMethod
    public static void finalOfferCreation(List<Id> caseIDs) {
        if(caseIDs != null && caseIDs.size() > 0) {
            loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
            Date currentSystemDate = loanFacade.getCurrentSystemDate();
            
            List<Case> caseList = [SELECT Id,
                                  Interest_Rate__c, Loan_Amount__c,
                                  Term__c, Case_Reason_Detail__c, Application__c, Final_Offer_Initiated_By__c, Final_Offer__c
                                  FROM Case WHERE Id IN :caseIDs];
            
            if(caseList != null && caseList.size() > 0) {
                Set<String> applicationIDs = new Set<String>();
                Set<String> clProductNames = new Set<String>();
                Map<String, Id> clProductMapping = new Map<String, Id>();
                List<genesis__applications__c> appsToUpdate = new List<genesis__applications__c>();
                List<Case> caseToUpdate = new List<Case>();
                for(Case c : caseList) {
                    applicationIDs.add(c.Application__c);
                    clProductNames.add(c.Case_Reason_Detail__c);
                }
                
                List<clcommon__CL_Product__c> clProductList = [SELECT Id, Name, clcommon__Product_Name__c
                                       FROM clcommon__CL_Product__c
                                       WHERE clcommon__Product_Name__c IN :clProductNames];
                
                if(clProductList != null && clProductList.size() > 0) {
                    for(clcommon__CL_Product__c cl : clProductList) {
                        clProductMapping.put(cl.clcommon__Product_Name__c, cl.Id);
                    }
                }
                
                Map<Id, genesis__applications__c> appsMap = new Map<Id, genesis__applications__c>([SELECT Id, Name, 
                                                     Final_Offer_Submitted__c,
                                                     Final_Offer_Submitted_Date__c,
                                                     genesis__Status__c,
                                                     genesis__Loan_Amount__c,
                                                     genesis__Term__c,
                                                     genesis__Interest_Rate__c,
                                                     genesis__cl_product__c,
                                                     GL_Code__c,
                                                     Application_Type__c
                                                     FROM genesis__applications__c
                                                     WHERE Id IN :applicationIDs]);
            
            
                for(Case c : caseList) {
                    if(appsMap.containsKey(c.Application__c)) {
                        genesis__applications__c app = appsMap.get(c.Application__c);
                        app.genesis__Loan_Amount__c = c.Loan_Amount__c;
                        app.genesis__Interest_Rate__c = c.Interest_Rate__c;
                        app.genesis__Term__c = c.Term__c * 12;
                        system.debug('application loan is'+ app.genesis__Loan_Amount__c );
                        if((String.valueOf(c.Case_Reason_Detail__c)).equals(ConstantsCl.GROWTH_LOAN)) {
                            app.GL_Code__c = settings.Growth_Loan__c;
                            app.Application_Type__c = ConstantsCl.GROWTH_LOAN;
                        } else if((String.valueOf(c.Case_Reason_Detail__c)).equals(ConstantsCl.ACQUISITION_LOAN)) {
                            app.GL_Code__c = settings.Acquisition_Loan__c;
                            app.Application_Type__c = ConstantsCl.ACQUISITION_LOAN;
                        } else if((String.valueOf(c.Case_Reason_Detail__c)).equals(ConstantsCl.BACKEND_TA)) {
                            app.GL_Code__c = settings.Backend_TA__c;
                            app.Application_Type__c = ConstantsCl.BACKEND_TA;
                        } else if((String.valueOf(c.Case_Reason_Detail__c)).equals(ConstantsCl.RETENTION_LOAN)) {
                            app.GL_Code__c = settings.Retention_Loan__c;
                            app.Application_Type__c = ConstantsCl.RETENTION_LOAN;
                        } else if((String.valueOf(c.Case_Reason_Detail__c)).equals(ConstantsCl.OTHER_LOAN)) {
                            system.debug('hello'+settings.Other_Loans__c);
                            app.GL_Code__c = settings.Other_Loans__c;
                            app.Application_Type__c = ConstantsCl.OTHER_LOAN;
                        } else if((String.valueOf(c.Case_Reason_Detail__c)).equals(ConstantsCl.REFINANCE_LOAN)) {
                            system.debug('hello'+settings.Refinance_Loan__c);
                            app.GL_Code__c = settings.Refinance_Loan__c;
                            app.Application_Type__c = ConstantsCl.REFINANCE_LOAN;
                        } else if((String.valueOf(c.Case_Reason_Detail__c)).equals(ConstantsCl.LINE_OF_CREDIT)) {
                            system.debug('hello'+settings.Line_of_Credit__c);
                            app.GL_Code__c = settings.Line_of_Credit__c;
                            app.Application_Type__c = ConstantsCl.LINE_OF_CREDIT;
                        }else if((String.valueOf(c.Case_Reason_Detail__c)).equals(ConstantsCl.NNA_Loan)) {
                            system.debug('hello'+settings.NNA_Loan__c);
                            app.GL_Code__c = settings.NNA_Loan__c;
                            app.Application_Type__c = ConstantsCl.NNA_Loan;
                        }
                        
                        if(clProductMapping.containsKey(c.Case_Reason_Detail__c)) {
                            app.genesis__cl_product__c = clProductMapping.get(c.Case_Reason_Detail__c);
                        }
                        app.Final_Offer_Submitted__c = true;
                        app.Final_Offer_Submitted_Date__c = currentSystemDate;
                        app.genesis__Status__c = 'Final Offer Submitted';
                        appsToUpdate.add(app);
                        
                        c.Final_Offer_Initiated_By__c = UserInfo.getUserId();
                        c.Final_Offer__c = true;
                        caseToUpdate.add(c);
                    }
                }
                
                if(appsToUpdate.size() > 0) {
                    system.debug('application loan is updated' );
                    UPDATE appsToUpdate;
                    UPDATE caseToUpdate;
                }
            }
            
        }
        
    }
}