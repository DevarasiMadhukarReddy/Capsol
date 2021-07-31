/*
        * This Class is used for Capsol
        * 
        * CS-2309 - Accept Repayble Proposal of a Repyable Loan in Salesforce and sent to CLO - Amol - 10/20/2020 -CH01
        * CS-42 , CS-2119 - Send email when offer extended and proposal status set to approved from CLO. - Amol - 10/30/2020 - CH02
        * CS-2548 - Update Proposal to read only when offer is accepted for repayable applications ONLY - Amol -12/21/2020 - CH03
        * - Author - Amol Deshpande
        * CH.No       Description                                                           Developer           Date
        ----------------------------------------------------------------------------------------------------------------------------
        * CH-04       CS-2756 Sprint 21- Remove hardcoded loan application status values     Bhanu              01/25/2021
        * CH-05       CS-3349 TA Rate(% of VAUM), TA Rate(% of EAUM) field modification      Amol               04/23/2021
        * CH-06       CS-3343 Update Opportunity record when TA Offer extended               Madhukar Reddy     5/11/2021
        * CH-07       CS-3344 Update Opportunity record when TA Offer accepted               Madhukar Reddy     5/21/2021
        * CH-08       CS-4425 Integrate Campaign Offer Accepted field on                     Amol               7/24/2021
                      Opportunity and Proposal Offer              
        */
        public class New_ProposalTriggerHandler implements BaseTriggerHandler{
            
            public Boolean IsDisabled()
            { 
                return false;
            }
            
            public void AfterInsert(Map<Id, SObject> newItems){}
            
            public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
                SendAcceptedRepayableProposal(trigger.new); //  CH01
                SendEmailwhenOfferExtended(trigger.new,(Map<Id,Proposal_Offer__c>)trigger.oldMap); //  CH02
                UpdateOpportunityFields(trigger.new,(Map<Id,Proposal_Offer__c>)trigger.oldMap);// CS-3343 & CS-3344
                
                
            }
            public void BeforeInsert(List<SObject> newItems) {}
            public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
            public void BeforeDelete(Map<Id, SObject> oldItems) {}
            public void AfterDelete(Map<Id, SObject> oldItems) {}
            public void AfterUndelete(Map<Id, SObject> oldItems) {}
            
            //CH01 chnages start
            public void SendAcceptedRepayableProposal(list<Proposal_Offer__c> proList){
                
                ID aquisitionLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Acquisition Loan').getRecordTypeId();
                ID growthLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Growth Loan').getRecordTypeId();
                ID locRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Line of Credit').getRecordTypeId();
                ID refinanceLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Refinance Loan').getRecordTypeId();
                Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();
                
                //CH03 changes Start
                /* Id BorrowerReadOnlyRecordTypeId = Schema.SObjectType.Borrowers__c.getRecordTypeInfosByDeveloperName().get('Borrower_Read_Only').getRecordTypeId();
        Id GeneralProposalReadOnlyRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal_Read_Only').getRecordTypeId();
        
        Id aquisitionLoanReadOnlyRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Acquisition_Loan_Read_Only').getRecordTypeId();
        Id growthLoanReadOnlyRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Growth_Loan_Read_Only').getRecordTypeId();
        Id locReadOnlyRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Line_of_Credit_Read_Only').getRecordTypeId();
        Id refinanceLoanReadOnlyRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Refinance_Loan_Read_Only').getRecordTypeId();
        */
                
                List<Proposal_Offer__c> pOffLst = new List<Proposal_Offer__c>();
                List<Borrowers__c> bList = new List<Borrowers__c>();
                List<Borrowers__c> updateBorrList = new List<Borrowers__c>();
                Loan_Application__c loanAppRec = new Loan_Application__c();
                Decimal TAAmount;
                Id appId;
                Set<Id> propIds = new Set<Id>();
                
                
                for(Proposal_Offer__c pOff : (List<Proposal_Offer__c>)trigger.new){
                    system.debug('pOff.RecordTypeId'+pOff.RecordTypeId);
                    system.debug('pOff.LoanApp_MD__c'+pOff.LoanApp_MD__r);
                    system.debug('pOff.Proposal_Status__c'+pOff.Proposal_Status__c);
                    if(pOff.RecordTypeId == GeneralProposalRecordTypeId && pOff.Proposal_Status__c == 'Accepted'){
                        appId = pOff.LoanApp_MD__c;
                        propIds.add(pOff.Id);
                        if(pOff.TA_Amount__c !=null){
                            TAAmount =  pOff.TA_Amount__c;
                        }
                    }
                }
                
                system.debug('appIds'+appId);
                // select id,TA_Amount__c,Proposal_Status__c,OSJ_Amount__c,RecordType.DeveloperName from Proposal_Offer__c where id = :recId
                if(appId != null && userInfo.getUserId() != System.Label.AEM_Integration_User_ID){
                    loanAppRec= [Select id,Status__c,Repayable_Loan_Offer_Selected_Flag__c,RecordTypeId,CLO_Application_ID__c from Loan_Application__c where id = :appId];
                    
                    bList = [Select Id,Split_of_Total_AUM__c,Backend_Split__c,AUM_Attributable__c,Contact__c,CLO_Customer_Group__c,CLO_Customer_ID__c,
                             Current_Firm_Name__c,Hire_Date__c,Master_Rep_ID__c,Repayable_Split__c,Repayable_Loan_Amount__c,Sub_Loan_Amount__c,Sub_Loan_Split__c,VAUM__c,
                             Current_Firm_Type__c,Enterprise_Name__c,Full_Name__c,Loan_Application__c,Primary_Contact__c,Total_AUM__c,
                             Contact__r.CLO_Customer_ID__c,Contact__r.Name from Borrowers__c 
                             where Loan_Application__c = :appId];
                    
                    if((loanAppRec.RecordTypeId == aquisitionLoanRecTypeId ||  loanAppRec.RecordTypeId == growthLoanRecTypeId ||
                        loanAppRec.RecordTypeId == locRecTypeId  ||  loanAppRec.RecordTypeId == refinanceLoanRecTypeId)
                      ){
                          if(bList != null){
                              for(Borrowers__c brow : bList){
                                  if(TAAmount !=null && brow.Sub_Loan_Split__c != null){
                                      brow.Sub_Loan_Amount__c = (TAAmount * brow.Sub_Loan_Split__c)/100;
                                      brow.Borrower_Check_Flag__c =true;
                                      // brow.RecordTypeId = BorrowerReadOnlyRecordTypeId;
                                      updateBorrList.add(brow);
                                  }
                                  
                              }
                          }
                          
                      }
                    
                    //Start  CH-04
                    List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
                    String   loanStatusOfferAccepted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_4');
                    
                    if(loanAppRec.Status__c != loanStatusOfferAccepted){
                        loanAppRec.Status__c =loanStatusOfferAccepted;
                        //End  CH-04
                        loanAppRec.Repayable_Loan_Offer_Selected_Flag__c = true;
                        /*if(loanAppRec.RecordTypeId == aquisitionLoanRecTypeId){
        loanAppRec.RecordTypeId = aquisitionLoanReadOnlyRecordTypeId;
        }else if(loanAppRec.RecordTypeId == growthLoanRecTypeId){
        loanAppRec.RecordTypeId = growthLoanReadOnlyRecordTypeId;
        }else if(loanAppRec.RecordTypeId == locRecTypeId){
        loanAppRec.RecordTypeId = locReadOnlyRecordTypeId;
        }else if(loanAppRec.RecordTypeId == refinanceLoanRecTypeId){
        loanAppRec.RecordTypeId = refinanceLoanReadOnlyRecordTypeId;
        }*/
                        if(System.IsBatch() == false){
                            update loanAppRec;
                        }
                    } 
                    
                    // Moved borrowers updates after Loan App updates - Amol - 11/17/2020
                    if(updateBorrList.size()>0){
                        update updateBorrList;
                    }
                }
                
            }
            //CH01 chnages end
            
            //CH02 chnages start
            public void SendEmailwhenOfferExtended(list<Proposal_Offer__c> proList, map<id,Proposal_Offer__c> oldProMap){
                Id RetensionLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Retention_Loan').getRecordTypeId();
                Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
                Id MonetizationRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Monetization').getRecordTypeId();
                Id WorkingCapitalLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Working_Capital').getRecordTypeId();
                Id TAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
                Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();
                Id RepayableProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('Repayable').getRecordTypeId();
                List<Proposal_Offer__c> pOffLst = new List<Proposal_Offer__c>();
                Loan_Application__c loanAppRec = new  Loan_Application__c();
                integer i = 0;
                Id appId;
                Id propId;
                
                for(Proposal_Offer__c pOff : (List<Proposal_Offer__c>)trigger.new){
                    appId = pOff.LoanApp_MD__c;
                    propId = pOff.Id;
                }
                if(appId != null){
                    loanAppRec =[select id,status__c,RecordTypeId,Assigned_Recruiter_Email__c,Business_Consultant_RM_Email__c,
                                 Business_Developer_Email__c,Internal_Recruiter_Email__c from Loan_Application__c where id =:appId];
                    pOffLst = [select id,proposal_status__c from Proposal_Offer__c where LoanApp_MD__c =:appId];
                }
                
                //Start  CH-04
                List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
                String   loanStatusOfferExtended=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_11');
                String   loanStatusApproved=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Proposal_Offer__c','Status_5');
                
                
                if(pOffLst != null){
                Proposal_Offer__c oldProp = new Proposal_Offer__c();
                oldProp = oldProMap.get(propId);
                    for(Proposal_Offer__c pOff : pOffLst){
                        
                        if(pOff.Proposal_Status__c == loanStatusApproved && oldProp.Proposal_Status__c != loanStatusApproved 
                        && oldProp.LoanApp_MD__r.Status__c != loanStatusOfferExtended && loanAppRec.Status__c == loanStatusOfferExtended 
                        && Userinfo.getUserId() == System.Label.AEM_Integration_User_ID &&
                           (loanAppRec.RecordTypeId == ForgivableLoadRecordTypeId || loanAppRec.RecordTypeId == RetensionLoadRecordTypeId || 
                            loanAppRec.RecordTypeId == MonetizationRecordTypeId || loanAppRec.RecordTypeId == WorkingCapitalLoadRecordTypeId)){
                                //End CH-04
                                i++;
                            }
                    }
                    if(i == pOffLst.size()){
                        TriggerEmailwhenOfferExtended.sendTemplatedEmail(loanAppRec);
                    }
                }
                
            }
            //CH02 chnages end
            // CH-06 Start the changes
            // CH-07 Star the Changes
            public void UpdateOpportunityFields(list<Proposal_Offer__c> proList,map<id,Proposal_Offer__c> oldProMap){        
                system.debug('UpdateOpportunityFields');
                
                Set<Id> loanId = new Set<Id>();
                //Map<Id,Loan_Application__c> loanMap = new Map<Id,Loan_Application__c>();
                //List<opportunity> listOpp = new List<opportunity>();
                List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
                String   loanStatusOfferExtended=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_11');
                String   proposalStatusApproved=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Proposal_Offer__c','Status_5');
                String   loanStatusOfferAccepted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_4');
                String   PropsalStatusAccept=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Proposal_Offer__c','Status_1');
                Id       ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
                Id       ForgivableProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
                Id       RepayableProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('Repayable').getRecordTypeId();
                integer i=0;
                id propId ;
                New_Opportunity_TriggerHandler.capsolexecution = true; 
                for( Proposal_Offer__c proposalOffer : (List<Proposal_Offer__c>)trigger.new ) {
                    loanId.add(proposalOffer.LoanApp_MD__c);
                   // propId.add(proposalOffer.id);
                   propid=proposalOffer.id;
                    system.debug('LoanId'+LoanId);
                }
                List<Proposal_Offer__c> proOfferList=[select id,Approved_T12__c,Verified_AUM__c,Expected_AUM__c,Date__c,Expiration__c,
                                                      LoanApp_MD__r.Expected_AUM__c,LoanApp_MD__r.Opportunity__r.id,Proposal_Status__c,LoanApp_MD__r.status__c,LoanApp_MD__r.recordtypeid,Max_TA_Amount__c,
                                                      OSJ_Amount__c,OSJ_NON_OSJ_Rep_Id__c,TA_Amount__c,Loan_Term__c,Backend_Bps__c,Backend_Hurdle__c,Backend_Date_1__c,Backend_Date_2__c,RecordTypeId  from Proposal_Offer__c where LoanApp_MD__c =:LoanId AND RecordTypeId =:ForgivableProposalRecordTypeId];
                List<Proposal_Offer__c> ProOfferAccepLList = new List<Proposal_Offer__c>(); 
                
                ProOfferAccepLList = [select id,Campaign_Offer_Selected__c,Approved_T12__c,Verified_AUM__c,Expected_AUM__c,Date__c,Expiration__c,
                            LoanApp_MD__r.Expected_AUM__c,LoanApp_MD__r.Opportunity__r.id,Proposal_Status__c,LoanApp_MD__r.status__c,LoanApp_MD__r.recordtypeid,Max_TA_Amount__c,
                            OSJ_Amount__c,OSJ_NON_OSJ_Rep_Id__c,TA_Amount__c,Loan_Term__c,Backend_Bps__c,Backend_Hurdle__c,Backend_Date_1__c,Backend_Date_2__c,RecordTypeId  from Proposal_Offer__c where LoanApp_MD__c =:loanId AND Proposal_Status__c =:PropsalStatusAccept ];
                                              //system.debug('ProOffer'+ProOffer);
               opportunity opp= new opportunity();
               Proposal_Offer__c oldProp = new Proposal_Offer__c();
               oldProp = oldProMap.get(propId);
                try{
                if(proOfferList!=null){
                 for( Proposal_Offer__c proposal : proOfferList ) {
                        
                        system.debug('proposal'+proposal); 
                        // Below If Statement only for Forgivable Record type
                        if( proposal.Proposal_Status__c == proposalStatusApproved && oldProp.Proposal_Status__c != proposalStatusApproved &&  proposal.LoanApp_MD__r.status__c == loanStatusOfferExtended && oldProp.LoanApp_MD__r.status__c != loanStatusOfferExtended &&  proposal.LoanApp_MD__r.recordtypeid == ForgivableLoadRecordTypeId) {
                            opp.id = proposal.LoanApp_MD__r.Opportunity__r.id;
                            opp.Expected_AUM__c =proposal.LoanApp_MD__r.Expected_AUM__c;   // This field from Loan Application 
                            opp.TAT_GDC__c = proposal.Approved_T12__c;
                            opp.Verified_AUM__c = proposal.Verified_AUM__c;
                            opp.Firm_Standard_AUM__c  = proposal.Verified_AUM__c;
                            opp.Revenue_Received__c = proposal.Date__c;
                            opp.Revenue_Approved__c = proposal.Date__c;
                            opp.Revenue_Expiration_Date__c= proposal.Expiration__c;
                            opp.Revenue_Verification_Status__c ='Revenue Approved';
                            opp.Gross_Profit_ROA__c  = 'Low';
                            i++;
                          } 
                    }
            }
            for (Proposal_Offer__c ProOffer: ProOfferAccepLList){
            if( ProOffer.Proposal_Status__c == PropsalStatusAccept && 
            //oldProp.Proposal_Status__c != PropsalStatusAccept &&  
            ProOffer.LoanApp_MD__r.status__c == loanStatusOfferAccepted && 
            //oldProp.LoanApp_MD__r.status__c != loanStatusOfferAccepted && 
            ProOffer.LoanApp_MD__r.recordtypeid == ForgivableLoadRecordTypeId 
           // && ProOffer.recordtypeid == ForgivableProposalRecordTypeId 
             )
             {
                 system.debug('In Oppty@@');  
                      // Below If Statement only for Forgivable Record type
                        if(ProOffer.recordtypeid == ForgivableProposalRecordTypeId ){
                            opp.id = ProOffer.LoanApp_MD__r.Opportunity__r.id;
                            opp.Max_TA_Dollars_Allowed__c =ProOffer.Max_TA_Amount__c;
                            opp.Credit_to_OSJ__c = ProOffer.OSJ_Amount__c;
                            opp.Credit_to_Non_OSJ_Rep_ID__c = ProOffer.OSJ_NON_OSJ_Rep_Id__c;
                            opp.Forgivable_Loan__c = ProOffer.TA_Amount__c;
                            if(ProOffer.Loan_Term__c != null){
                                Integer loanterm = Integer.valueOf(ProOffer.Loan_Term__c);
                                opp.Forgivable_Loan_Term_to_Rep__c = loanterm ;
                                
                            }
                            
                            opp.Back_end_TA_Calculation_Date__c = ProOffer.Backend_Date_1__c;
                            opp.Back_end_TA_Calculation_Date_2__c = ProOffer.Backend_Date_2__c;
                            opp.Back_end_TA_bps__c = ProOffer.Backend_Bps__c;
                            opp.Back_End_Hurdle__c = ProOffer.Backend_Hurdle__c;
                            opp.Back_End_Hurdle_Pick__c = ProOffer.Campaign_Offer_Selected__c; //CH-08
                        } 
                        // Below If Statement only for Repayable Record type
                        if(ProOffer.recordtypeid == RepayableProposalRecordTypeId ){
                            opp.id = ProOffer.LoanApp_MD__r.Opportunity__r.id;
                            if(ProOffer.Loan_Term__c != null){
                                    Integer loanterm = Integer.valueOf(ProOffer.Loan_Term__c);
                                    opp.Standard_Repayable_Loan_Term_to_Rep__c = loanterm ;
                                    
                            }
                             opp.Standard_Repayable_Loan_Amount_to_Rep__c = ProOffer.TA_Amount__c;
                        }
                                             
                    }
                 }
                        system.debug('OpptyId***'+opp);
                         system.debug('proofferlist***'+ i);
                         system.debug('proofferlistsize'+ proofferlist.size());
                         system.debug('ProOffer***'+ ProOfferAccepLList);
                         if( ((i == proofferlist.size()) || (ProOfferAccepLList.size() > 0)) && opp!=null ){
                            update opp;
                        }
                    }
            catch(exception e){
                system.debug('exception'+ e);
            }  
            // CH-06 ended the changes
            // CH-07 Ended the changes
          }
        }