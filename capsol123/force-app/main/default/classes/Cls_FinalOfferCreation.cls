global class Cls_FinalOfferCreation {
      
    public static cls_gl_string__c settings = cls_gl_string__c.getInstance();
    public Cls_FinalOfferCreation () {
        if(settings == null) {
            throw new ints.IntegrationException('GL String has not been set.'); 
        }
  }
    @InvocableMethod
    public static void finalOfferCreation(List<Id> ids){
        loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
        date todaysDate = loanFacade.getCurrentSystemDate();
        Contact osjContact;
        Opportunity opps;
        RecordType recType = [SELECT Id, Name, SobjectType, DeveloperName
                                                     FROM RecordType 
                                                     WHERE DeveloperName = 'Loan'
                                                     AND SObjectType =: 'genesis__Applications__c' 
                                                     LIMIT 1];     
        list<genesis__applications__c> app = [select id,name,Opportunity__c,
                                                Advisor_Current_Credit__c,
                                                OSJ_Current_Credit__c,
                                                Non_OSJ_Current_Credit__c,
                                                Referral_Credit__c,
                                                Referral_Credit2__c,
                                                Referral_Credit3__c,
                                                Opportunity__r.Credit_To_Rep__c,
                                                Opportunity__r.Credit_to_OSJ__c,
                                                Opportunity__r.Credit_to_Non_OSJ_Advisor__c,
                                                Opportunity__r.Referral_Fee__c,
                                                Opportunity__r.Referral_Credit_2__c,
                                                Opportunity__r.Referral_Credit_3__c,
                                                Approved_Name__c,
                                                genesis__Status__c
                                              from genesis__applications__c
                                              where isParentApplication__c = true AND id IN :ids];
        
        Map<Id, genesis__applications__c> parentAppMapping = new Map<Id, genesis__applications__c>();
        if(app!=null && app.size()>0) {
            
             
            /**** TA Credit Split Logic ****/
            /////////////////Code Refactor/////////////////////////
            Set<Id> oppIds = new Set<Id>();
            Set<String> usersName = new Set<String>();
            List<genesis__applications__c> appsToUpdate = new List<genesis__applications__c>();
            for(genesis__applications__c pApp : app) {
                parentAppMapping.put(pApp.Id, pApp);
                oppIds.add(pApp.Opportunity__c);
                usersName.add(pApp.Approved_Name__c);
                pApp.Final_Offer_Submitted_Date__c = todaysDate;
                pApp.Final_Offer_Submitted__c = true;
                pApp.Application_Type__c = ConstantsCl.REPAYABLE_LOAN;
                pApp.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_FINAL_OFFER_SUBMITTED;
                appsToUpdate.add(pApp);
                
            }
            if(appsToUpdate.size() > 0) {
                UPDATE appsToUpdate;
            }
            //////////////////////Code Refactor//////////////////////////////////////////////
            List<genesis__applications__c> parentAppsToUpdate = new List<genesis__applications__c>();
            for(genesis__applications__c pApp : app) {
               
                if( pApp.Opportunity__r.Credit_To_Rep__c != null || pApp.Opportunity__r.Credit_to_OSJ__c != null || 
                pApp.Opportunity__r.Credit_to_Non_OSJ_Advisor__c != null || pApp.Opportunity__r.Referral_Fee__c != null ) {
                    pApp.Advisor_Current_Credit__c = pApp.Opportunity__r.Credit_To_Rep__c;
                    pApp.OSJ_Current_Credit__c = pApp.Opportunity__r.Credit_to_OSJ__c;
                    if(pApp.Opportunity__r.Credit_to_Non_OSJ_Advisor__c != null) {
                        pApp.Non_OSJ_Current_Credit__c = pApp.Opportunity__r.Credit_to_Non_OSJ_Advisor__c;
                    }
                    pApp.Referral_Credit__c = pApp.Opportunity__r.Referral_Fee__c;
                    pApp.Referral_Credit2__c = pApp.Opportunity__r.Referral_Credit_2__c;
                    pApp.Referral_Credit3__c = pApp.Opportunity__r.Referral_Credit_3__c;
                    parentAppsToUpdate.add(pApp);
                }
            }
            
            if(parentAppsToUpdate.size() > 0) {
                UPDATE parentAppsToUpdate;
            }
            
            /*************************/
            
           ////////////////////////////Code Refactor////////////////////////////////////////////
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select id,name,
                                                                           Forgivable_Loan__c,Forgivable_Loan_Term_to_Rep__c,
                                                                           osj_rep_id__c,
                                                                         Forgivable_Loan_Term_to_OSJ__c,
                                                                           Forgivable_Loan_to_OSJ__c,
                                                                           Forgivable_Loan_to_Non_OSJ_Advisor__c,Forgivable_Loan_Term_to_Non_OSJ_Advisor__c,
                                                                           Standard_Repayable_Loan_Amount_to_Rep__c,Standard_Repayable_Loan_Term_to_Rep__c
                                                                   from Opportunity
                                                                   where id In:oppIds]);
            List<User> userLst = new List<User>([select id,name,
                                                       loan__Current_Branch_s_System_Date__c 
                                                from user where name In:usersName]);
            
            if(userLst==null || userLst.size()==0) {
                throw new CLSException('Application approved users doesnot exist');
            }
             
             
            Map<String,User> userMap = new Map<String,User>();
            for(User s:userLst){
                userMap.put(s.name,s);
            }    
            Map<Id,List<Contact>> osjContacts = new Map<Id,List<Contact>>();
            for(Opportunity oppId: oppMap.values()) {
                if(oppId.osj_rep_id__c!=null) {
                    List<Contact> osjC = [select id,name from contact where Master_Rep_ID__c =: oppId.osj_rep_id__c];
                    if(osjC!=null && osjC.size()>0)
                        osjContacts.put(oppId.Id,osjC);
                    else 
                        throw new CLSException('No such contact exist for OSJ rep Id');
               }
            } 

            list<genesis__applications__c> finalChildApps = [select id,name,platform__c,opportunity__c,genesis__parent_application__c,
                                                                     genesis__contact__c,genesis__parent_application__r.opportunity__c,
                                                                     genesis__parent_application__r.Approved_Name__c,
                                                                     TA_Amount__c,Note_Length__c
                                                             from genesis__applications__c
                                                             where genesis__parent_application__c =:ids and Final_Offer__c=true
                                                                   and application_type__c ='Forgivable'];
            
            list<genesis__applications__c> finalChildRepayableApps = [select id,name,platform__c,opportunity__c,genesis__parent_application__c,
                                                                     genesis__contact__c,genesis__parent_application__r.opportunity__c,genesis__loan_amount__c,
                                                                     genesis__parent_application__r.Approved_Name__c,genesis__term__c,
                                                                     TA_Amount__c,Note_Length__c
                                                             from genesis__applications__c
                                                             where genesis__parent_application__c =:ids
                                                                   and application_type__c ='Repayable'];
            if(finalChildRepayableApps !=null && finalChildRepayableApps.size()>0 && oppMap!=null) {
                clcommon__CL_Product__c clProductId = [select id,name
                                                      from clcommon__CL_Product__c
                                                      where clcommon__Product_Name__c='Repayable'];
                List<genesis__applications__c> finalRepayableAppsToUpdate = new List<genesis__applications__c>();
                for(genesis__applications__c finalApps:finalChildRepayableApps ) {
                    finalApps.genesis__CL_Product__c = clProductId.id;
                    finalApps.approved_user__c = userMap.get(finalApps.genesis__parent_application__r.Approved_Name__c).id;
                    finalApps.GL_Code__c = settings.Repayable__c;
                    finalApps.genesis__Loan_Amount__c = (oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Standard_Repayable_Loan_Amount_to_Rep__c!=null?oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Standard_Repayable_Loan_Amount_to_Rep__c:finalApps.genesis__loan_amount__c);
                    finalApps.genesis__term__c = (oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Standard_Repayable_Loan_Term_to_Rep__c!=null?((oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Standard_Repayable_Loan_Term_to_Rep__c)*12):(finalApps.genesis__term__c));
                    finalRepayableAppsToUpdate.add(finalApps);
                }
                if(finalRepayableAppsToUpdate.size() > 0) {
                    UPDATE finalRepayableAppsToUpdate;
                }
                
            }
            
            
            if(finalChildApps!=null && finalChildApps.size()>0 && oppMap!=null/*&& opps!=null*/) {
                clcommon__CL_Product__c clProductId = [select id,name
                                                      from clcommon__CL_Product__c
                                                      where clcommon__Product_Name__c='Forgivable'];
                ///////////////////////////////Code Refactor/////////////////////////////////////////////////////
                List<genesis__applications__c> finalAppsToUpdate = new List<genesis__applications__c>(); 
                List<genesis__applications__c> osjAppInsert = new List<genesis__applications__c>(); 
                List<genesis__applications__c> nonOsjAppInsert = new List<genesis__applications__c>();                                     
                Map<Id, genesis__applications__c> parentAppTypeMap = new Map<Id, genesis__applications__c>();
                for(genesis__applications__c finalApps:finalChildApps) {
                    if(parentAppMapping.containsKey(finalApps.genesis__Parent_Application__c)) {
                        
                        if(parentAppTypeMap.containsKey(finalApps.genesis__Parent_Application__c)) {
                            genesis__applications__c parentApp = parentAppTypeMap.get(finalApps.genesis__Parent_Application__c);
                            parentApp.Application_Type__c = ConstantsCl.FORGIVABLE_LOAN;
                        } else {
                            genesis__applications__c parentApp = parentAppMapping.get(finalApps.genesis__Parent_Application__c);
                            parentApp.Application_Type__c = ConstantsCl.FORGIVABLE_LOAN;
                            parentAppTypeMap.put(finalApps.genesis__Parent_Application__c, parentApp);
                        }
                        
                    }
                    finalApps.genesis__Loan_Amount__c = (oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan__c!=null?oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan__c:finalApps.TA_Amount__c);
                    finalApps.genesis__term__c = (oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_Term_to_Rep__c!=null?(oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_Term_to_Rep__c*12):(finalApps.note_length__c*12));
                    finalApps.genesis__Payment_Frequency__c = genesis.LendingConstants.PAYMENT_FREQ_MONTHLY;
                    finalApps.genesis__Expected_Start_Date__c = todaysDate ;
                    finalApps.genesis__maturity_date__c = todaysDate.addMonths(Integer.valueOf(finalApps.genesis__term__c));
                    finalApps.opportunity__c = oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).id;
                    finalApps.forgivable_types__c = 'Rep';
                    finalApps.genesis__CL_Product__c = clProductId.id;
                    system.debug(userMap+'Hello'+finalApps.genesis__parent_application__r.Approved_Name__c);
                    finalApps.approved_user__c = userMap.get(finalApps.genesis__parent_application__r.Approved_Name__c).id;
                    finalApps.GL_Code__c = settings.Forgivable__c;
                    /*if(finalApps.platform__c =='Hybrid')
                        finalApps.osj_rep__c = (osjContacts.get(finalApps.genesis__parent_application__r.opportunity__c)!=null?osjContacts.get(finalApps.genesis__parent_application__r.opportunity__c)[0].id:null);*/
                    finalAppsToUpdate.add(finalApps);
                    genesis__Applications__c osjApplication = new genesis__Applications__c(
                                                        genesis__Loan_Amount__c = (oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_to_OSJ__c!=null?oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_to_OSJ__c:0),
                                                        //genesis__Interest_Rate__c = interestRate,
                                                        platform__c = finalApps.platform__c,
                                                        genesis__contact__c = (osjContacts.get(finalApps.genesis__parent_application__r.opportunity__c)!=null?osjContacts.get(finalApps.genesis__parent_application__r.opportunity__c)[0].id:null),
                                                        genesis__Term__c = (oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_Term_to_OSJ__c!=null?(oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_Term_to_OSJ__c*12):(finalApps.note_length__c*12)),
                                                        genesis__Payment_Frequency__c = genesis.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                        genesis__Expected_Start_Date__c = todaysDate ,
                                                        genesis__maturity_date__c = todaysDate.addMonths(Integer.valueOf(finalApps.note_length__c*12)),                              
                                                        opportunity__c = oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).id,
                                                        application_type__c = 'Forgivable',
                                                        RecordTypeId = recType.Id,
                                                        genesis__Product_Type__c = 'Loan',
                                                        genesis__parent_application__c = finalApps.genesis__parent_application__c,
                                                        forgivable_types__c = 'OSJ',
                                                        forgivable_OSJ_MID__c = oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).osj_rep_id__c,
                                                        genesis__CL_Product__c = clProductId.id,
                                                        Final_Offer__c=true,
                                                        advisor_type__c = 'New',
                                                        GL_Code__c = settings.Forgivable__c,
                                                        /*Final_Offer_Submitted_Date__c = todaysDate,
                                                        Final_Offer_Submitted__c = true,
                                                        isParentApplication__c = false,*/
                                                        approved_user__c = userMap.get(finalApps.genesis__parent_application__r.Approved_Name__c).id/*,
                                                        osj_rep__c = (finalApps.platform__c =='Hybrid'?(osjContacts.get(finalApps.genesis__parent_application__r.opportunity__c)!=null?osjContacts.get(finalApps.genesis__parent_application__r.opportunity__c)[0].id:null):null)*/); 
                osjApplication.amount_in_words__c  = (osjApplication.genesis__loan_amount__c!=null?CLS_NumberToWord.amountWords(osjApplication.genesis__Loan_Amount__c):null);
                osjAppInsert.add(osjApplication);
                genesis__Applications__c nonOsjApplication = new genesis__Applications__c(//genesis__Contact__c = finalApps.genesis__contact__c,
                                                        genesis__Loan_Amount__c = (oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_to_Non_OSJ_Advisor__c!=null?oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_to_Non_OSJ_Advisor__c:0),
                                                        //genesis__Interest_Rate__c = interestRate,
                                                        platform__c = finalApps.platform__c,
                                                        genesis__Term__c = (oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_Term_to_Non_OSJ_Advisor__c!=null?(oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_Term_to_Non_OSJ_Advisor__c*12):(finalApps.note_length__c*12)),
                                                        genesis__Payment_Frequency__c = genesis.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                        genesis__Expected_Start_Date__c = todaysDate ,
                                                        genesis__maturity_date__c = todaysDate.addMonths(Integer.valueOf((oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_Term_to_Non_OSJ_Advisor__c!=null?(oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).Forgivable_Loan_Term_to_Non_OSJ_Advisor__c*12):(finalApps.note_length__c*12)))),             
                                                        opportunity__c = oppMap.get(finalApps.genesis__parent_application__r.opportunity__c).id,
                                                        application_type__c = 'Forgivable',
                                                        RecordTypeId = recType.Id,
                                                        genesis__Product_Type__c = 'Loan',
                                                        genesis__parent_application__c = finalApps.genesis__parent_application__c,
                                                        forgivable_types__c = 'NonOSJ',
                                                        GL_Code__c = settings.Forgivable__c,
                                                        Final_Offer__c=true,
                                                        advisor_type__c = 'New',
                                                        genesis__CL_Product__c = clProductId.id,
                                                        approved_user__c = userMap.get(finalApps.genesis__parent_application__r.Approved_Name__c).id/*,
                                                        osj_rep__c = (finalApps.platform__c =='Hybrid'?(osjContacts.get(finalApps.genesis__parent_application__r.opportunity__c)!=null?osjContacts.get(finalApps.genesis__parent_application__r.opportunity__c)[0].id:null):null)*/); 
               nonOsjApplication.amount_in_words__c  = (nonOsjApplication.genesis__loan_amount__c!=null?CLS_NumberToWord.amountWords(nonOsjApplication.genesis__Loan_Amount__c):null); 
               nonOsjAppInsert.add(nonOsjApplication);

                }
                if(finalAppsToUpdate.size() > 0) {
                    UPDATE finalAppsToUpdate;
                }
                if(osjAppInsert.size() > 0) {
                    insert osjAppInsert;
                }
                if(nonOsjAppInsert.size() > 0) {
                    insert nonOsjAppInsert;
                }
                if(parentAppTypeMap.size() > 0) {
                    UPDATE parentAppTypeMap.values();
                }

            }
        
        }        
        
    }
    
    webService static String generateFinalOffer(String applicationID) {
        if(String.isNotBlank(String.valueOf(applicationID))) {
            
            list<genesis__applications__c> finalChildApps = [SELECT Id, Name
                                                             FROM genesis__Applications__c
                                                             WHERE genesis__Parent_Application__c =:applicationID AND Final_Offer__c = true];
            
            if(finalChildApps != null && finalChildApps.size() > 0) {
                if(finalChildApps.size() > 1) {
                    return 'CAUTION: Can not proceed with more than one offer. Please select only one offer from the available Affiliations. You can also consider unchecking Repayable offer even though if it is a part of final offer!';
                }
            } else {
                return 'CAUTION: Atleast one Affilication\'s final offer is required to proceed!';
            }
            
            Savepoint sp = Database.setSavepoint();
            try{
                List<String> appList = new List<String>();
                appList.add(applicationID);
                Cls_FinalOfferCreation.finalOfferCreation(appList);
                return 'SUCCESS: Final offer created!';
            } catch(Exception e) {
                Database.rollback(sp);
                System.debug('Error while generating final offer ' + e.getStackTraceString());
                return 'ERROR: ' + e.getMessage() + ' ## Line No ' + e.getLineNumber() + '.';
            }
            
        } else {
            return 'Application Id cannot be null.';
        }
        
    }

}