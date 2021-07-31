public class BaqToAppicationTriggerHandlerCL {
    Map<Id, BAQ__c> oldMap;
    Map<Id, BAQ__c> newMap;
    
    public BaqToAppicationTriggerHandlerCL(Map<Id, BAQ__c> oldMap, Map<Id, BAQ__c> newMap) {
        this.oldMap = oldMap;
        this.newMap = newMap;
    }
    
    public void afterUpdateHandler() {
        Set<Id> baqIDs = newMap.keySet();
        Map<Id, List<genesis__Applications__c>> baqAppMap = new Map<Id, List<genesis__Applications__c>>();
        List<genesis__Applications__c> appList = [SELECT Id, Name, genesis__Account__c, genesis__Contact__c, Opportunity__c, 
                                                  BAQ__c, Retirement_Plan_Assets_Editable__c, Ranking_Dependent_BAQ_Fields_Total__c, genesis__Status__c 
                                                  FROM genesis__Applications__c WHERE isParentApplication__c = true AND genesis__Parent_Application__c = null AND BAQ__c IN : baqIDs];
        
        if(appList != null && appList.size() > 0) {
            for(genesis__Applications__c app : appList) {
                if(baqAppMap.containsKey(app.BAQ__c)) {
                    List<genesis__Applications__c> baqAppList = baqAppMap.get(app.BAQ__c);
                    baqAppList.add(app);
                    baqAppMap.put(app.BAQ__c, baqAppList);
                } else {
                    List<genesis__Applications__c> baqAppList = new List<genesis__Applications__c>();
                    baqAppList.add(app);
                    baqAppMap.put(app.BAQ__c, baqAppList);
                }
            }
            
            List<genesis__Applications__c> appsToBeUpdated = new List<genesis__Applications__c>();
            List<genesis__Applications__c> appsToBeInserted = new List<genesis__Applications__c>();
            for(Id baqId : newMap.keySet()) {
                if(baqAppMap.containsKey(baqId)) {
                    List<genesis__Applications__c> apps = baqAppMap.get(baqId);
                    
                    for(genesis__Applications__c app : apps) {
                        Boolean isToUpdate = false;
                        Boolean isToUpdateChildApps = false;
                        Boolean isToInsertChildApps = false;
                        Boolean changeAppToBaqResubmitted = false;
                        List<genesis__Applications__c> childAppList = [SELECT Id, Name, BAQ__c, Retirement_Plan_Assets_Editable__c, 
                                                                       Platform__c, Branch__c, OSJ__c, Affiliation_Number__c, Ranking_Dependent_BAQ_Fields_Total__c 
                                                                       FROM genesis__Applications__c WHERE genesis__Parent_Application__c = :app.Id AND BAQ__c =:baqId];
                        
                        /* Add Application fields which needs to be updated here! */
                        if(oldMap.get(baqId).Total_Fee_Based_AUM__c != newMap.get(baqId).Total_Fee_Based_AUM__c) {
                            app.Firm_AUM_Editable__c = newMap.get(baqId).Total_Fee_Based_AUM__c + newMap.get(baqId).Total_Transactional_Brokerage_AUM__c + newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                            isToUpdate = true;
                            changeAppToBaqResubmitted = true;
                        }
                        
                        if(oldMap.get(baqId).Total_Transactional_Brokerage_AUM__c != newMap.get(baqId).Total_Transactional_Brokerage_AUM__c) {
                            app.Firm_AUM_Editable__c = newMap.get(baqId).Total_Fee_Based_AUM__c + newMap.get(baqId).Total_Transactional_Brokerage_AUM__c + newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                            isToUpdate = true;
                            changeAppToBaqResubmitted = true;
                        }
                        
                        if(oldMap.get(baqId).Retirement_Plan_Assets_Total__c != newMap.get(baqId).Retirement_Plan_Assets_Total__c) {
                            app.Retirement_Plan_Assets_Editable__c = newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                            app.Firm_AUM_Editable__c = newMap.get(baqId).Total_Fee_Based_AUM__c + newMap.get(baqId).Total_Transactional_Brokerage_AUM__c + newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                            if(childAppList != null && childAppList.size() > 0) {
                                for(genesis__Applications__c capp : childAppList) {
                                    capp.Retirement_Plan_Assets_Editable__c = newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                                }
                            }
                            isToUpdate = true;
                            isToUpdateChildApps = true;
                            changeAppToBaqResubmitted = true;
                        }
                        
                        if(oldMap.get(baqId).AUM_TAMPs_or_3rd_Party__c != newMap.get(baqId).AUM_TAMPs_or_3rd_Party__c) {
                            app.TAMP_Assets_Editable__c = newMap.get(baqId).AUM_TAMPs_or_3rd_Party__c;
                            isToUpdate = true;
                            changeAppToBaqResubmitted = true;
                        }
                        
                        if(oldMap.get(baqId).Ranking_Dependent_Fields_Total__c != newMap.get(baqId).Ranking_Dependent_Fields_Total__c) {
                            app.Ranking_Dependent_BAQ_Fields_Total__c = newMap.get(baqId).Ranking_Dependent_Fields_Total__c;
                            if(childAppList != null && childAppList.size() > 0) {
                                for(genesis__Applications__c capp : childAppList) {
                                    capp.Ranking_Dependent_BAQ_Fields_Total__c = newMap.get(baqId).Ranking_Dependent_Fields_Total__c;
                                }
                            }
                            isToUpdate = true;
                            isToUpdateChildApps = true;
                            changeAppToBaqResubmitted = true;
                        }
                        
                        /* Checking for Affiliation changes */
                        // Affiliation 1
                        if((oldMap.get(baqId).Affiliation_1__c != newMap.get(baqId).Affiliation_1__c) || (oldMap.get(baqId).Branch_1__c != newMap.get(baqId).Branch_1__c) || 
                          (oldMap.get(baqId).OSJ_LE_1__c != newMap.get(baqId).OSJ_LE_1__c)) {
                            if(newMap.get(baqId).Affiliation_1__c != null && String.isNotBlank(String.valueOf(newMap.get(baqId).Affiliation_1__c))) {
                                if(childAppList != null && childAppList.size() > 0) {
                                    Boolean isNewAffiliation = true;
                                    for(genesis__Applications__c capp : childAppList) {
                                        if(capp.Affiliation_Number__c == 1) {
                                            if(oldMap.get(baqId).Affiliation_1__c != newMap.get(baqId).Affiliation_1__c) {
                                                capp.Platform__c = newMap.get(baqId).Affiliation_1__c;
                                            } 
                                            if(oldMap.get(baqId).Branch_1__c != newMap.get(baqId).Branch_1__c) {
                                                capp.Branch__c = newMap.get(baqId).Branch_1__c;
                                            }
                                            if(oldMap.get(baqId).OSJ_LE_1__c != newMap.get(baqId).OSJ_LE_1__c) {
                                                capp.OSJ__c = newMap.get(baqId).OSJ_LE_1__c;
                                            }
                                            
                                            isToUpdateChildApps = true;
                                            isNewAffiliation = false;
                                            changeAppToBaqResubmitted = true;
                                            break;
                                        }
                                    }
                                    
                                    if(isNewAffiliation) {
                                        /* Child app creation logic for new affiliation 1*/
                                        List<RecordType> rtypeLoan = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Loan' AND isActive=true];
                                        genesis__Applications__c cApp1 = new genesis__Applications__c();
                                        cApp1.RecordTypeId = rtypeLoan.get(0).Id;
                                        cApp1.genesis__Account__c = app.genesis__Account__c;
                                        cApp1.genesis__Contact__c = app.genesis__Contact__c;
                                        cApp1.BAQ__c = app.BAQ__c;
                                        cApp1.Opportunity__c = app.Opportunity__c;
                                        cApp1.Advisor_Type__c = 'New';
                                        cApp1.genesis__Parent_Application__c = app.Id;
                                        cApp1.Platform__c = newMap.get(baqId).Affiliation_1__c;
                                        cApp1.Branch__c = newMap.get(baqId).Branch_1__c;
                                        cApp1.OSJ__c = newMap.get(baqId).OSJ_LE_1__c;
                                        cApp1.Affiliation_Number__c = 1;
                                        cApp1.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_NEW_ENTERED;
                                        cApp1.Retirement_Plan_Assets_Editable__c = newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                                        cApp1.Ranking_Dependent_BAQ_Fields_Total__c = newMap.get(baqId).Ranking_Dependent_Fields_Total__c;
                                        appsToBeInserted.add(cApp1);
                                        isToInsertChildApps = true;
                                        changeAppToBaqResubmitted = true;
                                    }
                                }
                            }
                        }
                        
                        // Affiliation 2
                        if((oldMap.get(baqId).Affiliation_2__c != newMap.get(baqId).Affiliation_2__c) || (oldMap.get(baqId).Branch_2__c != newMap.get(baqId).Branch_2__c) || 
                          (oldMap.get(baqId).OSJ_LE_2__c != newMap.get(baqId).OSJ_LE_2__c)) {
                            if(newMap.get(baqId).Affiliation_2__c != null && String.isNotBlank(String.valueOf(newMap.get(baqId).Affiliation_2__c))) {
                                if(childAppList != null && childAppList.size() > 0) {
                                    Boolean isNewAffiliation = true;
                                    for(genesis__Applications__c capp : childAppList) {
                                        if(capp.Affiliation_Number__c == 2) {
                                            if(oldMap.get(baqId).Affiliation_2__c != newMap.get(baqId).Affiliation_2__c) {
                                                capp.Platform__c = newMap.get(baqId).Affiliation_2__c;
                                            } 
                                            if(oldMap.get(baqId).Branch_2__c != newMap.get(baqId).Branch_2__c) {
                                                capp.Branch__c = newMap.get(baqId).Branch_2__c;
                                            }
                                            if(oldMap.get(baqId).OSJ_LE_2__c != newMap.get(baqId).OSJ_LE_2__c) {
                                                capp.OSJ__c = newMap.get(baqId).OSJ_LE_2__c;
                                            }
                                            isToUpdateChildApps = true;
                                            isNewAffiliation = false;
                                            changeAppToBaqResubmitted = true;
                                            break;
                                        }
                                    }
                                    if(isNewAffiliation) {
                                        /* Child app creation logic for new affiliation 2*/
                                        List<RecordType> rtypeLoan = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Loan' AND isActive=true];
                                        genesis__Applications__c cApp2 = new genesis__Applications__c();
                                        cApp2.RecordTypeId = rtypeLoan.get(0).Id;
                                        cApp2.genesis__Account__c = app.genesis__Account__c;
                                        cApp2.genesis__Contact__c = app.genesis__Contact__c;
                                        cApp2.BAQ__c = app.BAQ__c;
                                        cApp2.Opportunity__c = app.Opportunity__c;
                                        cApp2.Advisor_Type__c = 'New';
                                        cApp2.genesis__Parent_Application__c = app.Id;
                                        cApp2.Platform__c = newMap.get(baqId).Affiliation_2__c;
                                        cApp2.Branch__c = newMap.get(baqId).Branch_2__c;
                                        cApp2.OSJ__c = newMap.get(baqId).OSJ_LE_2__c;
                                        cApp2.Affiliation_Number__c = 2;
                                        cApp2.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_NEW_ENTERED;
                                        cApp2.Retirement_Plan_Assets_Editable__c = newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                                        cApp2.Ranking_Dependent_BAQ_Fields_Total__c = newMap.get(baqId).Ranking_Dependent_Fields_Total__c;
                                        appsToBeInserted.add(cApp2);
                                        isToInsertChildApps = true;
                                        changeAppToBaqResubmitted = true;
                                    }
                                }
                            }
                        }
                        
                        // Affiliation 3
                        if((oldMap.get(baqId).Affiliation_3__c != newMap.get(baqId).Affiliation_3__c) || (oldMap.get(baqId).Branch_3__c != newMap.get(baqId).Branch_3__c) || 
                          (oldMap.get(baqId).OSJ_LE_3__c != newMap.get(baqId).OSJ_LE_3__c)) {
                            if(newMap.get(baqId).Affiliation_3__c != null && String.isNotBlank(String.valueOf(newMap.get(baqId).Affiliation_3__c))) {
                                if(childAppList != null && childAppList.size() > 0) {
                                    Boolean isNewAffiliation = true;
                                    for(genesis__Applications__c capp : childAppList) {
                                        if(capp.Affiliation_Number__c == 3) {
                                            if(oldMap.get(baqId).Affiliation_3__c != newMap.get(baqId).Affiliation_3__c) {
                                                capp.Platform__c = newMap.get(baqId).Affiliation_3__c;
                                            } 
                                            if(oldMap.get(baqId).Branch_3__c != newMap.get(baqId).Branch_3__c) {
                                                capp.Branch__c = newMap.get(baqId).Branch_3__c;
                                            }
                                            if(oldMap.get(baqId).OSJ_LE_3__c != newMap.get(baqId).OSJ_LE_3__c) {
                                                capp.OSJ__c = newMap.get(baqId).OSJ_LE_3__c;
                                            }
                                            isToUpdateChildApps = true;
                                            isNewAffiliation = false;
                                            changeAppToBaqResubmitted = true;
                                            break;
                                        }
                                    }
                                    if(isNewAffiliation) {
                                        /* Child app creation logic for new affiliation 3*/
                                        List<RecordType> rtypeLoan = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Loan' AND isActive=true];
                                        genesis__Applications__c cApp3 = new genesis__Applications__c();
                                        cApp3.RecordTypeId = rtypeLoan.get(0).Id;
                                        cApp3.genesis__Account__c = app.genesis__Account__c;
                                        cApp3.genesis__Contact__c = app.genesis__Contact__c;
                                        cApp3.BAQ__c = app.BAQ__c;
                                        cApp3.Opportunity__c = app.Opportunity__c;
                                        cApp3.Advisor_Type__c = 'New';
                                        cApp3.genesis__Parent_Application__c = app.Id;
                                        cApp3.Platform__c = newMap.get(baqId).Affiliation_3__c;
                                        cApp3.Branch__c = newMap.get(baqId).Branch_3__c;
                                        cApp3.OSJ__c = newMap.get(baqId).OSJ_LE_3__c;
                                        cApp3.Affiliation_Number__c = 3;
                                        cApp3.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_NEW_ENTERED;
                                        cApp3.Retirement_Plan_Assets_Editable__c = newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                                        cApp3.Ranking_Dependent_BAQ_Fields_Total__c = newMap.get(baqId).Ranking_Dependent_Fields_Total__c;
                                        appsToBeInserted.add(cApp3);
                                        isToInsertChildApps = true;
                                        changeAppToBaqResubmitted = true;
                                    }
                                }
                            }
                        }
                        
                        // Affiliation 4
                        if((oldMap.get(baqId).Affiliation_4__c != newMap.get(baqId).Affiliation_4__c) || (oldMap.get(baqId).Branch_4__c != newMap.get(baqId).Branch_4__c) || 
                          (oldMap.get(baqId).OSJ_LE_4__c != newMap.get(baqId).OSJ_LE_4__c)) {
                            if(newMap.get(baqId).Affiliation_4__c != null && String.isNotBlank(String.valueOf(newMap.get(baqId).Affiliation_4__c))) {
                                if(childAppList != null && childAppList.size() > 0) {
                                    Boolean isNewAffiliation = true;
                                    for(genesis__Applications__c capp : childAppList) {
                                        if(capp.Affiliation_Number__c == 4) {
                                            if(oldMap.get(baqId).Affiliation_4__c != newMap.get(baqId).Affiliation_4__c) {
                                                capp.Platform__c = newMap.get(baqId).Affiliation_4__c;
                                            } 
                                            if(oldMap.get(baqId).Branch_4__c != newMap.get(baqId).Branch_4__c) {
                                                capp.Branch__c = newMap.get(baqId).Branch_4__c;
                                            }
                                            if(oldMap.get(baqId).OSJ_LE_4__c != newMap.get(baqId).OSJ_LE_4__c) {
                                                capp.OSJ__c = newMap.get(baqId).OSJ_LE_4__c;
                                            }
                                            isToUpdateChildApps = true;
                                            isNewAffiliation = false;
                                            changeAppToBaqResubmitted = true;
                                            break;
                                        }
                                    }
                                    if(isNewAffiliation) {
                                        /* Child app creation logic for new affiliation 4*/
                                        List<RecordType> rtypeLoan = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Loan' AND isActive=true];
                                        genesis__Applications__c cApp4 = new genesis__Applications__c();
                                        cApp4.RecordTypeId = rtypeLoan.get(0).Id;
                                        cApp4.genesis__Account__c = app.genesis__Account__c;
                                        cApp4.genesis__Contact__c = app.genesis__Contact__c;
                                        cApp4.BAQ__c = app.BAQ__c;
                                        cApp4.Opportunity__c = app.Opportunity__c;
                                        cApp4.Advisor_Type__c = 'New';
                                        cApp4.genesis__Parent_Application__c = app.Id;
                                        cApp4.Platform__c = newMap.get(baqId).Affiliation_4__c;
                                        cApp4.Branch__c = newMap.get(baqId).Branch_4__c;
                                        cApp4.OSJ__c = newMap.get(baqId).OSJ_LE_4__c;
                                        cApp4.Affiliation_Number__c = 4;
                                        cApp4.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_NEW_ENTERED;
                                        cApp4.Retirement_Plan_Assets_Editable__c = newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                                        cApp4.Ranking_Dependent_BAQ_Fields_Total__c = newMap.get(baqId).Ranking_Dependent_Fields_Total__c;
                                        appsToBeInserted.add(cApp4);
                                        isToInsertChildApps = true;
                                        changeAppToBaqResubmitted = true;
                                    }
                                }
                            }
                        }
                        
                        // Affiliation 5
                        if((oldMap.get(baqId).Affiliation_5__c != newMap.get(baqId).Affiliation_5__c) || (oldMap.get(baqId).Branch_5__c != newMap.get(baqId).Branch_5__c) || 
                          (oldMap.get(baqId).OSJ_LE_5__c != newMap.get(baqId).OSJ_LE_5__c)) {
                            if(newMap.get(baqId).Affiliation_5__c != null && String.isNotBlank(String.valueOf(newMap.get(baqId).Affiliation_5__c))) {
                                if(childAppList != null && childAppList.size() > 0) {
                                    Boolean isNewAffiliation = true;
                                    for(genesis__Applications__c capp : childAppList) {
                                        if(capp.Affiliation_Number__c == 5) {
                                            if(oldMap.get(baqId).Affiliation_5__c != newMap.get(baqId).Affiliation_5__c) {
                                                capp.Platform__c = newMap.get(baqId).Affiliation_5__c;
                                            } 
                                            if(oldMap.get(baqId).Branch_5__c != newMap.get(baqId).Branch_5__c) {
                                                capp.Branch__c = newMap.get(baqId).Branch_5__c;
                                            }
                                            if(oldMap.get(baqId).OSJ_LE_5__c != newMap.get(baqId).OSJ_LE_5__c) {
                                                capp.OSJ__c = newMap.get(baqId).OSJ_LE_5__c;
                                            }
                                            isToUpdateChildApps = true;
                                            isNewAffiliation = false;
                                            changeAppToBaqResubmitted = true;
                                            break;
                                        }
                                    }
                                    if(isNewAffiliation) {
                                        /* Child app creation logic for new affiliation 5*/
                                        List<RecordType> rtypeLoan = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Loan' AND isActive=true];
                                        genesis__Applications__c cApp5 = new genesis__Applications__c();
                                        cApp5.RecordTypeId = rtypeLoan.get(0).Id;
                                        cApp5.genesis__Account__c = app.genesis__Account__c;
                                        cApp5.genesis__Contact__c = app.genesis__Contact__c;
                                        cApp5.BAQ__c = app.BAQ__c;
                                        cApp5.Opportunity__c = app.Opportunity__c;
                                        cApp5.Advisor_Type__c = 'New';
                                        cApp5.genesis__Parent_Application__c = app.Id;
                                        cApp5.Platform__c = newMap.get(baqId).Affiliation_5__c;
                                        cApp5.Branch__c = newMap.get(baqId).Branch_5__c;
                                        cApp5.OSJ__c = newMap.get(baqId).OSJ_LE_5__c;
                                        cApp5.Affiliation_Number__c = 5;
                                        cApp5.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_NEW_ENTERED;
                                        cApp5.Retirement_Plan_Assets_Editable__c = newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                                        cApp5.Ranking_Dependent_BAQ_Fields_Total__c = newMap.get(baqId).Ranking_Dependent_Fields_Total__c;
                                        appsToBeInserted.add(cApp5);
                                        isToInsertChildApps = true;
                                        changeAppToBaqResubmitted = true;
                                    }
                                }
                            }
                        }
                        
                        // Affiliation 6
                        if((oldMap.get(baqId).Affiliation_6__c != newMap.get(baqId).Affiliation_6__c) || (oldMap.get(baqId).Branch_6__c != newMap.get(baqId).Branch_6__c) || 
                          (oldMap.get(baqId).OSJ_LE_6__c != newMap.get(baqId).OSJ_LE_6__c)) {
                            if(newMap.get(baqId).Affiliation_6__c != null && String.isNotBlank(String.valueOf(newMap.get(baqId).Affiliation_6__c))) {
                                if(childAppList != null && childAppList.size() > 0) {
                                    Boolean isNewAffiliation = true;
                                    for(genesis__Applications__c capp : childAppList) {
                                        if(capp.Affiliation_Number__c == 6) {
                                            if(oldMap.get(baqId).Affiliation_6__c != newMap.get(baqId).Affiliation_6__c) {
                                                capp.Platform__c = newMap.get(baqId).Affiliation_6__c;
                                            } 
                                            if(oldMap.get(baqId).Branch_6__c != newMap.get(baqId).Branch_6__c) {
                                                capp.Branch__c = newMap.get(baqId).Branch_6__c;
                                            }
                                            if(oldMap.get(baqId).OSJ_LE_6__c != newMap.get(baqId).OSJ_LE_6__c) {
                                                capp.OSJ__c = newMap.get(baqId).OSJ_LE_6__c;
                                            }
                                            isToUpdateChildApps = true;
                                            isNewAffiliation = false;
                                            changeAppToBaqResubmitted = true;
                                            break;
                                        }
                                    }
                                    if(isNewAffiliation) {
                                        /* Child app creation logic for new affiliation 6*/
                                        List<RecordType> rtypeLoan = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Loan' AND isActive=true];
                                        genesis__Applications__c cApp6 = new genesis__Applications__c();
                                        cApp6.RecordTypeId = rtypeLoan.get(0).Id;
                                        cApp6.genesis__Account__c = app.genesis__Account__c;
                                        cApp6.genesis__Contact__c = app.genesis__Contact__c;
                                        cApp6.BAQ__c = app.BAQ__c;
                                        cApp6.Opportunity__c = app.Opportunity__c;
                                        cApp6.Advisor_Type__c = 'New';
                                        cApp6.genesis__Parent_Application__c = app.Id;
                                        cApp6.Platform__c = newMap.get(baqId).Affiliation_6__c;
                                        cApp6.Branch__c = newMap.get(baqId).Branch_6__c;
                                        cApp6.OSJ__c = newMap.get(baqId).OSJ_LE_6__c;
                                        cApp6.Affiliation_Number__c = 6;
                                        cApp6.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_NEW_ENTERED;
                                        cApp6.Retirement_Plan_Assets_Editable__c = newMap.get(baqId).Retirement_Plan_Assets_Total__c;
                                        cApp6.Ranking_Dependent_BAQ_Fields_Total__c = newMap.get(baqId).Ranking_Dependent_Fields_Total__c;
                                        appsToBeInserted.add(cApp6);
                                        isToInsertChildApps = true;
                                        changeAppToBaqResubmitted = true;
                                    }
                                }
                            }
                        }
                        
                        
                        /* Changing the application status to 'BAQ Resubmitted' upon any change in the BAQ */                    
                        System.debug('## BAQ : ' + newMap.get(baqId).Name + ' ## oldMap ' + oldMap.get(baqId).Status__c + ' & newMap ' + newMap.get(baqId).Status__c);
                        if(oldMap.get(baqId).Status__c == newMap.get(baqId).Status__c) {
                            app.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_BAQ_RESUBMITTED;
                            isToUpdate = true;
                        }

                        
                        if(isToUpdate) {
                            appsToBeUpdated.add(app);
                        }
                        if(isToUpdateChildApps) {
                            for(genesis__Applications__c capp : childAppList) {
                                appsToBeUpdated.add(capp);
                            }
                        }
                    }
                }
            }
        
            if(appsToBeUpdated.size() > 0) {
                UPDATE appsToBeUpdated;
            }
            if(appsToBeInserted.size() > 0) {
                INSERT appsToBeInserted;
            }
        }
    }
}