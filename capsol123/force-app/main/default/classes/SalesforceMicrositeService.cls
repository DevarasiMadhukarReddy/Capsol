/**
* SalesforceMicrositeService.cls
* Description  : This is webservice for AEM to provide salesforce activity details as part of Microsite project. 
* 
* @Author      : Amit Verma(Cognizant)
* @version     : 1.0
* @CreatedDate : Oct 02 ,2017
* CH-01        : 11/24/2017; Naga modifed for MIC-193; Salesforce Integration (In Progress) Update to Status Tracker Step 4.
Should show In Progress on the Microsite when “Marketing & Stationary Item Approval” is either "sent" or "in progress". Today we have only support "sent
CH-02        : 02/14/2017; Amit added additional field to be passed to Microsite
CH-03        : 10/03/2018; Amit added change for ATP 4
*/


global class SalesforceMicrositeService { 
    
    global class ACTIVITY_DETAILS{       
        webservice String ActivityTypeName;
        webservice String ActivityStatus;            
    }
    
    
    global class OPPORTUNITY_DETAIL{
        webservice List<ACTIVITY_DETAILS> ACTIVITY_DETAILS;
        webservice String KitReviewStatus;
        webservice String eKitReceived;
        webservice String AssignedtoGRCAnalyst; 
        webservice String OnboardingConsultant;
        webservice String RegionalTransitionPartner;
        //New addition to the requested field 02/14 
        webservice String InternalTargetTATDate; 
        webservice String RequesttoJoinAs;
        webservice String Channel;
        webservice String RepID;
        webservice String CRD;
        webservice String LocationType;
        webservice String ApprovedExpectedAUM;
        webservice String ApprovedTATRevenue; 
        //Added new elements for ATP-9 (Sprint 4)
        webservice Boolean assignedToOBAAnalyst;
        webservice String OBAReviewStatus;
    }
    
    global class STATUS{
        webservice String StatusConditionDescription;
        webservice String StatusCode;
        webservice String StatusName;
        webservice String StatusDescription;        
    }
    
    global class MESSAGE{ 
        webservice STATUS STATUS;       
        webservice OPPORTUNITY_DETAIL OPPORTUNITY_DETAIL;      
    }
    
    global class result{
        webservice MESSAGE MESSAGE;
    }
    
    webservice static result sendActivityDetails(String email) {
        result res = new result();
        res.MESSAGE = new MESSAGE();
        res.MESSAGE.STATUS = new STATUS();
        Boolean activityTobeSent = true;
        Boolean isMarketingItemPresent = false; //Changes for No Marketing & Stationary Items Approval Activities
        if(!String.isBlank(email)){
            List<Opportunity> ooptyList = [SELECT Id,Integration_Manager__r.Name,Regional_Transition_Partner__r.Name, email__c,GRC_Status__c,eKit_Received__c,Assigned_to_GRC_Analyst__c,Internal_Target_TAT_Date__c,Request_To_Join_As__c,Channel__c,Rep_ID__c,Contact__r.CRD_Number__c,Location_Type__c,Expected_AUM__c,TAT_GDC__c,Review_Status__c,Assigned_to_OBA_Analyst__c, (Select Id,Activity_Type__c,Status,Activity_with_a_Status_N_A__c  From Tasks) from opportunity where Id =: email];
            if(ooptyList.size()>0){    
                res.MESSAGE.OPPORTUNITY_DETAIL = new OPPORTUNITY_DETAIL();
                if(!String.isBlank(ooptyList[0].GRC_Status__c)){
                    res.MESSAGE.OPPORTUNITY_DETAIL.KitReviewStatus = ooptyList[0].GRC_Status__c;
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.KitReviewStatus = '';
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].eKit_Received__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.eKitReceived = String.valueOf(ooptyList[0].eKit_Received__c);
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.eKitReceived = '';
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Assigned_to_GRC_Analyst__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.AssignedtoGRCAnalyst = String.valueOf(ooptyList[0].Assigned_to_GRC_Analyst__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.AssignedtoGRCAnalyst = '';
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Integration_Manager__r.Name))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.OnboardingConsultant = String.valueOf(ooptyList[0].Integration_Manager__r.Name); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.OnboardingConsultant = '';
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Regional_Transition_Partner__r.Name))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.RegionalTransitionPartner = String.valueOf(ooptyList[0].Regional_Transition_Partner__r.Name); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.RegionalTransitionPartner = '';
                }
                
                // start new additional fields 2/14
                if(!String.isBlank(String.valueOf(ooptyList[0].Internal_Target_TAT_Date__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.InternalTargetTATDate= String.valueOf(ooptyList[0].Internal_Target_TAT_Date__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.InternalTargetTATDate = '';
                }
                //Changes for ATP-4
                if(!String.isBlank(String.valueOf(ooptyList[0].Request_To_Join_As__c)) && 
                   (String.valueOf(ooptyList[0].Request_To_Join_As__c) == LPL_StaticDataUtility.REQUEST_LICENSED_SALES_ASST ||
                    String.valueOf(ooptyList[0].Request_To_Join_As__c) == LPL_StaticDataUtility.REQUEST_BRANCH_EMPLOYEE ||
                    String.valueOf(ooptyList[0].Request_To_Join_As__c) == LPL_StaticDataUtility.REQUEST_LICENSED_ADMIN||
                    String.valueOf(ooptyList[0].Request_To_Join_As__c) == LPL_StaticDataUtility.REQUEST_P_C_PARTNER ||
                    String.valueOf(ooptyList[0].Request_To_Join_As__c) == LPL_StaticDataUtility.REQUEST_PAAP ||
                    String.valueOf(ooptyList[0].Request_To_Join_As__c) == LPL_StaticDataUtility.REQUEST_PROGRAM_MANAGER ||
                    String.valueOf(ooptyList[0].Request_To_Join_As__c) == LPL_StaticDataUtility.REQUEST_NLA)){
                        res.MESSAGE.OPPORTUNITY_DETAIL.RequesttoJoinAs = '0'; 
                    }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.RequesttoJoinAs = '1';
                } 
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Channel__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.Channel = String.valueOf(ooptyList[0].Channel__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.Channel = '';
                } 
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Rep_ID__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.RepID = String.valueOf(ooptyList[0].Rep_ID__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.RepID = '';
                }  
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Contact__r.CRD_Number__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.CRD= String.valueOf(ooptyList[0].Contact__r.CRD_Number__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.CRD= '';
                }  
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Location_Type__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.LocationType = String.valueOf(ooptyList[0].Location_Type__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.LocationType = '';
                }  
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Expected_AUM__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.ApprovedExpectedAUM = String.valueOf(ooptyList[0].Expected_AUM__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.ApprovedExpectedAUM = '';
                } 
                
                if(!String.isBlank(String.valueOf(ooptyList[0].TAT_GDC__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.ApprovedTATRevenue = String.valueOf(ooptyList[0].TAT_GDC__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.ApprovedTATRevenue = '';
                }       
                // end of new additional fields 2/14
                
                //Added new elements for ATP-9 (Sprint 4)
                if(!String.isBlank(String.valueOf(ooptyList[0].Assigned_to_OBA_Analyst__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.assignedToOBAAnalyst = True; 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.assignedToOBAAnalyst = False;
                } 
                if(!String.isBlank(String.valueOf(ooptyList[0].Review_Status__c))){
                    res.MESSAGE.OPPORTUNITY_DETAIL.OBAReviewStatus = String.valueOf(ooptyList[0].Review_Status__c); 
                }
                else{
                    res.MESSAGE.OPPORTUNITY_DETAIL.OBAReviewStatus = '';
                } 
                //End of new elements for ATP-9 (Sprint 4)
                
                res.MESSAGE.OPPORTUNITY_DETAIL.ACTIVITY_DETAILS = new List<ACTIVITY_DETAILS>();
                String SecDocCompleted = LPL_StaticDataUtility.FLAG_CHECK_FALSE;
                for(Task tas : ooptyList[0].Tasks){
                    if(!String.isBlank(tas.Activity_Type__c) && 
                       (tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS) && 
                       (tas.Status == LPL_StaticDataUtility.STATUS_COMPLETED)){
                           SecDocCompleted = LPL_StaticDataUtility.FLAG_CHECK_TRUE;
                       } 
                    //Changes for No Marketing & Stationary Items Approval Activities
                    if(!String.isBlank(tas.Activity_Type__c) && 
                       (tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_MARKETING_STATIONARY_ITEMS_APPROVAL)){
                           isMarketingItemPresent=true;
                       }
                }
                
                for(Task tas : ooptyList[0].Tasks){
                    ACTIVITY_DETAILS  actDetail = NEW ACTIVITY_DETAILS();
                    //Changes for US of Sprint 3
                    if(!String.isBlank(tas.Activity_Type__c) && 
                       (tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_MARKETING_STATIONARY_ITEMS_APPROVAL  
                        || tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_LEARNING_CENTER_SETUP  
                        || tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_CONFIRM_MANDATORY_TRAININGS_COMPLETE
                        || tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_INSURANCE_AND_ANNUITY_APPOINTMENTS
                        || tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_RAMP_DELIVER_REPAPERING_PLAN 
                        || tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS)){
                            actDetail.ActivityTypeName = tas.Activity_Type__c;
                            
                            //Changes for US of Sprint 3
                            //CH-03 Made for ATP4
                            if(tas.Activity_with_a_Status_N_A__c == True &&
                               (tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_MARKETING_STATIONARY_ITEMS_APPROVAL  ||  
                                tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_LEARNING_CENTER_SETUP || 
                                tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_INSURANCE_AND_ANNUITY_APPOINTMENTS || 
                                tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_CONFIRM_MANDATORY_TRAININGS_COMPLETE)){
                                    actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_0;
                                }
                            else if(tas.Status == LPL_StaticDataUtility.STATUS_NOT_STARTED || 
                               (tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS && 
                                tas.Status == LPL_StaticDataUtility.STATUS_DEFERRED)){
                                    actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_1;
                                }
                            else if(tas.Status == LPL_StaticDataUtility.STATUS_COMPLETED){
                                actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_3;
                            }
                            //CH:01- start
                            else if(tas.Status == LPL_StaticDataUtility.STATUS_SENT && 
                                    tas.Activity_Type__c!=LPL_StaticDataUtility.ACTIVITY_MARKETING_STATIONARY_ITEMS_APPROVAL ){
                                        actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_2;
                                    }
                            //Changes for US of Sprint 3
                            //Included Activity Type Insurance and Annuity for ATP-8 (Sprint 4)
                            else if((tas.Status == LPL_StaticDataUtility.STATUS_SENT || 
                                     tas.Status == LPL_StaticDataUtility.STATUS_IN_PROGRESS || 
                                     tas.Status == LPL_StaticDataUtility.STATUS_RECEIVED || 
                                     tas.Status == LPL_StaticDataUtility.STATUS_REQUESTED || 
                                     tas.Status == LPL_StaticDataUtility.STATUS_SCHEDULED ) && 
                                    (tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_MARKETING_STATIONARY_ITEMS_APPROVAL ||
                                     tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_SECONDARY_DOCUMENTS || 
                                     tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_INSURANCE_AND_ANNUITY_APPOINTMENTS)){
                                         actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_2;
                                     }//CH:01- End           
                            else{
                                activityTobeSent = false;
                            } 
                            if(activityTobeSent){
                            res.MESSAGE.OPPORTUNITY_DETAIL.ACTIVITY_DETAILS.add(actDetail);
                          
                            }                            
                              activityTobeSent = true;
                        }
                    
                    //Condition for 'Submit TAT Request'
                    if(!String.isBlank(tas.Activity_Type__c) && tas.Activity_Type__c == LPL_StaticDataUtility.ACTIVITY_SUBMIT_TAT_REQUEST){
                        actDetail.ActivityTypeName = tas.Activity_Type__c;
                        if(tas.Status == LPL_StaticDataUtility.STATUS_SENT){
                            actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_2;
                        }
                        else if(tas.Status == LPL_StaticDataUtility.STATUS_NOT_STARTED){
                            actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_1;
                        }
                        else if(tas.Status == LPL_StaticDataUtility.STATUS_COMPLETED && 
                                SecDocCompleted == LPL_StaticDataUtility.FLAG_CHECK_TRUE){
                                    actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_3;
                                }
                        else{
                                activityTobeSent = false;
                           
                            } 
                        if(activityTobeSent){
                         res.MESSAGE.OPPORTUNITY_DETAIL.ACTIVITY_DETAILS.add(actDetail);                        
                        }
                         activityTobeSent = true;
                    } 
                }
                //Changes for No Marketing & Stationary Items Approval Activities
                if(isMarketingItemPresent == false){
                    ACTIVITY_DETAILS  actDetail = NEW ACTIVITY_DETAILS();
                    actDetail.ActivityTypeName = LPL_StaticDataUtility.ACTIVITY_MARKETING_STATIONARY_ITEMS_APPROVAL;
                    actDetail.ActivityStatus = LPL_StaticDataUtility.ACTIVITY_STATUS_0;
                    res.MESSAGE.OPPORTUNITY_DETAIL.ACTIVITY_DETAILS.add(actDetail);
                }
                res.MESSAGE.STATUS.StatusName= LPL_StaticDataUtility.RESPONSE_STATUS_SUCCESS;
                res.MESSAGE.STATUS.StatusConditionDescription='';
                res.MESSAGE.STATUS.StatusCode = LPL_StaticDataUtility.RESPONSE_STATUS_CODE_200;
                res.MESSAGE.STATUS.StatusDescription = LPL_StaticDataUtility.RESPONSE_STATUS_SUCCESS_DESCRIPTION;
            }
            else{
                res.MESSAGE.STATUS.StatusName = LPL_StaticDataUtility.RESPONSE_STATUS_ERROR;
                res.MESSAGE.STATUS.StatusConditionDescription ='';
                res.MESSAGE.STATUS.StatusCode = LPL_StaticDataUtility.RESPONSE_STATUS_CODE_302;
                res.MESSAGE.STATUS.StatusDescription = LPL_StaticDataUtility.RESPONSE_STATUS_ERROR_INVALID_DESCRIPTION;
            }
        }
        else{
            res.MESSAGE.STATUS.StatusName = LPL_StaticDataUtility.RESPONSE_STATUS_ERROR;
            res.MESSAGE.STATUS.StatusConditionDescription ='';
            res.MESSAGE.STATUS.StatusCode = LPL_StaticDataUtility.RESPONSE_STATUS_CODE_301;
            res.MESSAGE.STATUS.StatusDescription = LPL_StaticDataUtility.RESPONSE_STATUS_ERROR_BLANK_DESCRIPTION;
        }
     

        return res;
    }
}