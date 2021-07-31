// LCR020      Opportunity - Cloud Lending create application Button functionality    Lightning Cmp method   Hiral patel  12/21/2018
global without sharing class ApplicationCreator {
    String opportunityId;
    Opportunity opportunity;
    BAQ__c baq; 
    
    public ApplicationCreator(String opportunityId) {
        this.opportunityId = opportunityId;
    }
    
    private void getOpportunityRecord() {
        /* Query the opportunity fields (BAQ if necessary) */
        opportunity = [SELECT Id, Name,
                                BAQ__c,
                                Account.Id,
                                Contact__c,
                                Application__c,
                                loan__CurrentGenerators__c,
                                Firm_Type2__c,
                                Current_Firm2__r.Name,
                                TAT_GDC__c
                        FROM Opportunity WHERE Id = :opportunityId];
        
        baq = [SELECT Id, Name,
                        Status__c,
                        Affiliation_1__c, Branch_1__c, OSJ_LE_1__c,
                        Affiliation_2__c, Branch_2__c, OSJ_LE_2__c,
                        Affiliation_3__c, Branch_3__c, OSJ_LE_3__c,
                        Affiliation_4__c, Branch_4__c, OSJ_LE_4__c,
                        Affiliation_5__c, Branch_5__c, OSJ_LE_5__c,
                        Affiliation_6__c, Branch_6__c, OSJ_LE_6__c,
                        Total_Fee_Based_AUM__c,
                        Total_Transactional_Brokerage_AUM__c,
                        AUM_RP_Assets_BOR_Brokerage__c,
                        AUM_RP_Assets_RPCP_Corporate_RIA__c,
                        AUM_RP_Assets_Hybrid_RIA__c,
                        AUM_ROC_k_S__c,
                        AUM_Small_Market_Solution__c,
                        AUM_TAMPs_or_3rd_Party__c,
                        Ranking_Dependent_Fields_Total__c,
                        Retirement_Plan_Assets_Total__c
                FROM BAQ__c WHERE Id = :opportunity.BAQ__c];
        
    }
    
    private String createApplictionFromOpportunity() {
        Savepoint sp = Database.setSavepoint();
        try {
            List<Discount_Table__c> discountList = null;
            if(String.isNotBlank(opportunity.Current_Firm2__r.Name)) {
                discountList = [SELECT Id, Name, Firm_Name__c, Firm_Type__c, Bucket_Discount__r.Name, Bucket_Discount__r.Discount__c FROM Discount_Table__c WHERE Firm_Name__c = :opportunity.Current_Firm2__r.Name LIMIT 1];
            }
            
            /* Creating parent application */
            List<RecordType> rtypes = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Package' AND isActive=true];
            genesis__Applications__c app = new genesis__Applications__c();
            app.RecordTypeId = rtypes.get(0).Id;
            app.isParentApplication__c = true;
            app.BAQ__c = baq.Id;
            app.genesis__Account__c = opportunity.Account.Id;
            app.genesis__Contact__c = opportunity.Contact__c;
            app.Opportunity__c = opportunity.Id;
            app.Advisor_Type__c = 'New';
            app.TAT_GDC__c = opportunity.TAT_GDC__c;
            app.genesis__Product_Type__c = 'LOAN';
            app.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_BAQ_SUBMITTED;
            
            /* Updating editable formula fields */
            app.Firm_AUM_Editable__c = baq.Total_Fee_Based_AUM__c + baq.Total_Transactional_Brokerage_AUM__c + baq.Retirement_Plan_Assets_Total__c;
            app.Retirement_Plan_Assets_Editable__c = baq.Retirement_Plan_Assets_Total__c;
            app.Ranking_Dependent_BAQ_Fields_Total__c = baq.Ranking_Dependent_Fields_Total__c;
            app.TAMP_Assets_Editable__c = baq.AUM_TAMPs_or_3rd_Party__c;
               
            if(discountList != null && discountList.size() > 0) {
                app.Ramp_Bucket__c = discountList.get(0).Bucket_Discount__r.Name;
                app.discount_per__c= discountList.get(0).Bucket_Discount__r.Discount__c;
                app.Breakage_Discounts__c = discountList.get(0).Bucket_Discount__r.Discount__c;
            }
            
            INSERT app;
            
            /* Creating child applications based on the number of affilications in the BAQ object. */
            List<genesis__Applications__c> childAppsList = createChildApplications(app.Id);
            if(childAppsList != null && childAppsList.size() > 0) {
                INSERT childAppsList;
            }
            
            /* Update the reference of this application in Opportunity object */
            List<genesis__Applications__c> appList = [SELECT Id, Name FROM genesis__Applications__c WHERE Id = :app.Id];
            opportunity.Application__c = app.Id;
            opportunity.loan__CurrentGenerators__c = appList.get(0).Name;
            UPDATE opportunity;
            
            /*
            baq.Status__c = ConstantsCl.BAQ_STATUS_SUBMITTED;
            UPDATE baq;
            */
            
            /////////////////Inserting Approved Offers///////////////////////
            //ApporvedOffersCreation.approvedOffers(app.Id);
            /////////////////End of the call/////////////////////////////////
            
            return ConstantsCl.APPLICATION_CREATION_SUCCESS_MSG;
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug('##### Error in creating application ##### ' + e.getStackTraceString());
            return 'Error in creating an application. ' + e.getMessage();
        } 
    }
    
    private List<genesis__Applications__c> createChildApplications(String masterAppId) {
        List<genesis__Applications__c> childAppsList = new List<genesis__Applications__c>();
        List<RecordType> rtypeLoan = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Loan' AND isActive=true];
        
        if(masterAppId != null && String.isNotBlank(masterAppId)) {
            /* AFFILIATION-1 */
            if(baq.Affiliation_1__c != null && String.isNotBlank(String.valueOf(baq.Affiliation_1__c))) {
                genesis__Applications__c cApp1 = new genesis__Applications__c();
                cApp1.RecordTypeId = rtypeLoan.get(0).Id;
                cApp1.genesis__Account__c = opportunity.Account.Id;
                cApp1.genesis__Contact__c = opportunity.Contact__c;
                cApp1.BAQ__c = baq.Id;
                cApp1.Opportunity__c = opportunity.Id;
                cApp1.Advisor_Type__c = 'New';
                cApp1.genesis__Parent_Application__c = masterAppId;
                cApp1.genesis__Product_Type__c = 'LOAN';
                cApp1.Platform__c = baq.Affiliation_1__c;
                cApp1.Branch__c = baq.Branch_1__c;
                cApp1.OSJ__c = baq.OSJ_LE_1__c;
                cApp1.Affiliation_Number__c = 1;
                cApp1.Retirement_Plan_Assets_Editable__c = baq.Retirement_Plan_Assets_Total__c;
                cApp1.Ranking_Dependent_BAQ_Fields_Total__c = baq.Ranking_Dependent_Fields_Total__c;
                
				cApp1.Application_Type__c = 'Forgivable';
				
                childAppsList.add(cApp1);
            }
            
            /* AFFILIATION-2 */
            if(baq.Affiliation_2__c != null && String.isNotBlank(String.valueOf(baq.Affiliation_2__c))) {
                genesis__Applications__c cApp2 = new genesis__Applications__c();
                cApp2.RecordTypeId = rtypeLoan.get(0).Id;
                cApp2.genesis__Account__c = opportunity.Account.Id;
                cApp2.genesis__Contact__c = opportunity.Contact__c;
                cApp2.BAQ__c = baq.Id;
                cApp2.Opportunity__c = opportunity.Id;
                cApp2.Advisor_Type__c = 'New';
                cApp2.genesis__Product_Type__c = 'LOAN';
                cApp2.genesis__Parent_Application__c = masterAppId;
                cApp2.Platform__c = baq.Affiliation_2__c;
                cApp2.Branch__c = baq.Branch_2__c;
                cApp2.OSJ__c = baq.OSJ_LE_2__c;
                cApp2.Affiliation_Number__c = 2;
                cApp2.Retirement_Plan_Assets_Editable__c = baq.Retirement_Plan_Assets_Total__c;
                cApp2.Ranking_Dependent_BAQ_Fields_Total__c = baq.Ranking_Dependent_Fields_Total__c;
                cApp2.Application_Type__c = 'Forgivable';
                childAppsList.add(cApp2);
            }
            
            /* AFFILIATION-3 */
            if(baq.Affiliation_3__c != null && String.isNotBlank(String.valueOf(baq.Affiliation_3__c))) {
                genesis__Applications__c cApp3 = new genesis__Applications__c();
                cApp3.RecordTypeId = rtypeLoan.get(0).Id;
                cApp3.genesis__Account__c = opportunity.Account.Id;
                cApp3.genesis__Contact__c = opportunity.Contact__c;
                cApp3.BAQ__c = baq.Id;
                cApp3.Opportunity__c = opportunity.Id;
                cApp3.Advisor_Type__c = 'New';
                cApp3.genesis__Product_Type__c = 'LOAN';
                cApp3.genesis__Parent_Application__c = masterAppId;
                cApp3.Platform__c = baq.Affiliation_3__c;
                cApp3.Branch__c = baq.Branch_3__c;
                cApp3.OSJ__c = baq.OSJ_LE_3__c;
                cApp3.Affiliation_Number__c = 3;
                cApp3.Retirement_Plan_Assets_Editable__c = baq.Retirement_Plan_Assets_Total__c;
                cApp3.Ranking_Dependent_BAQ_Fields_Total__c = baq.Ranking_Dependent_Fields_Total__c;
                cApp3.Application_Type__c = 'Forgivable';
                childAppsList.add(cApp3);
            }
            
            /* AFFILIATION-4 */
            if(baq.Affiliation_4__c != null && String.isNotBlank(String.valueOf(baq.Affiliation_4__c))) {
                genesis__Applications__c cApp4 = new genesis__Applications__c();
                cApp4.RecordTypeId = rtypeLoan.get(0).Id;
                cApp4.genesis__Account__c = opportunity.Account.Id;
                cApp4.genesis__Contact__c = opportunity.Contact__c;
                cApp4.BAQ__c = baq.Id;
                cApp4.Opportunity__c = opportunity.Id;
                cApp4.Advisor_Type__c = 'New';
                cApp4.genesis__Product_Type__c = 'LOAN';
                cApp4.genesis__Parent_Application__c = masterAppId;
                cApp4.Platform__c = baq.Affiliation_4__c;
                cApp4.Branch__c = baq.Branch_4__c;
                cApp4.OSJ__c = baq.OSJ_LE_4__c;
                cApp4.Affiliation_Number__c = 4;
                cApp4.Retirement_Plan_Assets_Editable__c = baq.Retirement_Plan_Assets_Total__c;
                cApp4.Ranking_Dependent_BAQ_Fields_Total__c = baq.Ranking_Dependent_Fields_Total__c;
                cApp4.Application_Type__c = 'Forgivable';
                childAppsList.add(cApp4);
            }
            
            /* AFFILIATION-5 */
            if(baq.Affiliation_5__c != null && String.isNotBlank(String.valueOf(baq.Affiliation_5__c))) {
                genesis__Applications__c cApp5 = new genesis__Applications__c();
                cApp5.RecordTypeId = rtypeLoan.get(0).Id;
                cApp5.genesis__Account__c = opportunity.Account.Id;
                cApp5.genesis__Contact__c = opportunity.Contact__c;
                cApp5.BAQ__c = baq.Id;
                cApp5.Opportunity__c = opportunity.Id;
                cApp5.Advisor_Type__c = 'New';
                cApp5.genesis__Product_Type__c = 'LOAN';
                cApp5.genesis__Parent_Application__c = masterAppId;
                cApp5.Platform__c = baq.Affiliation_5__c;
                cApp5.OSJ__c = baq.OSJ_LE_5__c;
                cApp5.Branch__c = baq.Branch_5__c;
                cApp5.Affiliation_Number__c = 5;
                cApp5.Retirement_Plan_Assets_Editable__c = baq.Retirement_Plan_Assets_Total__c;
                cApp5.Ranking_Dependent_BAQ_Fields_Total__c = baq.Ranking_Dependent_Fields_Total__c;
                cApp5.Application_Type__c = 'Forgivable';
                childAppsList.add(cApp5);
            }
            
            /* AFFILIATION-6 */
            if(baq.Affiliation_6__c != null && String.isNotBlank(String.valueOf(baq.Affiliation_6__c))) {
                genesis__Applications__c cApp6 = new genesis__Applications__c();
                cApp6.RecordTypeId = rtypeLoan.get(0).Id;
                cApp6.genesis__Account__c = opportunity.Account.Id;
                cApp6.genesis__Contact__c = opportunity.Contact__c;
                cApp6.BAQ__c = baq.Id;
                cApp6.Opportunity__c = opportunity.Id;
                cApp6.Advisor_Type__c = 'New';
                cApp6.genesis__Product_Type__c = 'LOAN';
                cApp6.genesis__Parent_Application__c = masterAppId;
                cApp6.Platform__c = baq.Affiliation_6__c;
                cApp6.Branch__c = baq.Branch_6__c;
                cApp6.OSJ__c = baq.OSJ_LE_6__c;
                cApp6.Affiliation_Number__c = 6;
                cApp6.Retirement_Plan_Assets_Editable__c = baq.Retirement_Plan_Assets_Total__c;
                cApp6.Ranking_Dependent_BAQ_Fields_Total__c = baq.Ranking_Dependent_Fields_Total__c;
                cApp6.Application_Type__c = 'Forgivable';
                childAppsList.add(cApp6);
            }
            
            /* Additional appliation for Repayable loans */
            genesis__Applications__c cApp7 = new genesis__Applications__c();
            cApp7.RecordTypeId = rtypeLoan.get(0).Id;
            cApp7.genesis__Account__c = opportunity.Account.Id;
            cApp7.genesis__Contact__c = opportunity.Contact__c;
            cApp7.BAQ__c = baq.Id;
            cApp7.genesis__Product_Type__c = 'LOAN';
            cApp7.Opportunity__c = opportunity.Id;
            cApp7.Advisor_Type__c = 'New';
            cApp7.genesis__Parent_Application__c = masterAppId;
            cApp7.Application_Type__c = 'Repayable';
            cApp7.Retirement_Plan_Assets_Editable__c = baq.Retirement_Plan_Assets_Total__c;
            cApp7.Ranking_Dependent_BAQ_Fields_Total__c = baq.Ranking_Dependent_Fields_Total__c;
            cApp7.genesis__Payment_Frequency__c = genesis.LendingConstants.PAYMENT_FREQ_SEMI_MONTHLY;
            childAppsList.add(cApp7);
        }
        
        return childAppsList;
    }
    
    webService static String createApplication(String opportunityID) {
        if(String.isNotBlank(String.valueOf(opportunityID))) {
            
            ApplicationCreator ac = new ApplicationCreator(opportunityID);
            ac.getOpportunityRecord();
            return ac.createApplictionFromOpportunity();
            
        } else {
            return ConstantsCl.APPLICATION_CREATION_MISSING_FIELDS_MSG;
        }
        
    }
    
    //LCR020      Opportunity - Cloud Lending create application Button functionality   Lightning Cmp method   Hiral patel  12/21/2018
    @AuraEnabled
    public static Opportunity getOpportunityForLtng(String oppId){
        List<Opportunity> oppList = [Select Id,Application__c,BAQ__c From Opportunity Where Id =:oppId];
        return oppList.get(0);
    }
    // LCR020      Opportunity - Cloud Lending create application Button functionality  Lightning Cmp method   Hiral patel  12/21/2018
    @AuraEnabled
    public static String createApplicationLtng(String oppId){
        return createApplication(oppId);
    }
}