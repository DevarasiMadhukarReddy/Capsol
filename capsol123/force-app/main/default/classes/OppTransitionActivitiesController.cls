/*
Trigger Name            : OppTransitionActivitiesController
Description             : Lead Onboarding Changes VF page Controller

Developer Name          : 
Created Date            : 

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01    Remove the tasks to show in the VF page with the     Utkarsh Topre        03/28/2018
         four Activity type values. Line - 57
         WO: SD988020 - TasK - Onboarding Consultant


Note: The code coverage for this class is covered in the testOppTransitionController test class.

*/

/*  ******** Lead Onboarding Changes VF page Controller********** */


public with sharing class OppTransitionActivitiesController {

    
    public Decimal statusAge;

    

    public List<Opportunity> getAdvisorDetails;
    ID oppID = ApexPages.currentPage().getParameters().get('id');
    
    public List<Task> getOCTaskDetails;
    public List<Task> getRTPTaskDetails;
    public List<Task> getITPTaskDetails;
    public List<Task> getTSPTaskDetails;
    
    
    
    public PageReference backToOpportunity() {
        PageReference parentPage = new PageReference('/' + oppID );
        parentPage.setRedirect(true);
        return parentPage;
    }
    
    public List<Opportunity> getgetAdvisorDetails(){
        if(getAdvisorDetails == null)
        getAdvisorDetails = [select id, name, Rep_ID__c, Home_Phone__c, email__c, Firm_Type_Broker_Dealer__c, Target_TAT_Date__c, Integration_Manager__r.Name, 
                            Transition_Support_Partners__r.Name, Investment_Transition_Consultant__r.Name, Regional_Transition_Partner__r.Name
                                 ,Internal_Target_TAT_Date__c from Opportunity where ID =:oppID];
        return getAdvisorDetails;
    }
    
    public List<Task> getgetOCTaskDetails(){
        if(getOCTaskDetails == null)
        getOCTaskDetails= [select id, Activity_Type__c, Category__c, Status,Activity_with_a_Status_N_A__c, Change_Status_Date__c, Description, Owner.name, 
                                No_Of_Days_In_Not_Started__c, ActivityDate from Task where WhatID =:oppID and Department__c= 'Onboarding Consultant' 
                /*CH-01 START*/ AND(Activity_Type__c!='Transition Assistance - Credit/Forgivable Loan/Unlocking Loan' AND Activity_Type__c!='Transition Assistance - OSJ Credit' AND Activity_Type__c!='Transition Assistance - Referral Credit' AND Activity_Type__c!='Transition Assistance - Working Capital Loan') /*CH-01 END*/ ORDER BY CreatedDate ASC ];
        return getOCTaskDetails;
    }
    
    public List<Task> getgetRTPTaskDetails(){
        if(getRTPTaskDetails == null)
        getRTPTaskDetails= [select id, Activity_Type__c, Category__c, Status,Activity_with_a_Status_N_A__c, Change_Status_Date__c, Description, WhatID, 
                                    ActivityDate, No_Of_Days_In_Not_Started__c from Task where WhatID =:oppID and Department__c= 'Regional Transition Partner' ORDER BY CreatedDate ASC];
        return getRTPTaskDetails;
    }
    
    public List<Task> getgetITPTaskDetails(){
        if(getITPTaskDetails == null)
        getITPTaskDetails= [select id, Activity_Type__c, Category__c, Status,Activity_with_a_Status_N_A__c, Change_Status_Date__c, Description, WhatID, 
                                ActivityDate, No_Of_Days_In_Not_Started__c from Task where WhatID =:oppID and Department__c= 'Investment Transition Partner' ORDER BY CreatedDate ASC];
        return getITPTaskDetails;
    }
    public List<Task> getgetTSPTaskDetails(){
        if(getTSPTaskDetails == null)
        getTSPTaskDetails= [select id, Activity_Type__c, Category__c, Status,Activity_with_a_Status_N_A__c, Change_Status_Date__c, Description, WhatID, 
                                    ActivityDate, No_Of_Days_In_Not_Started__c from Task where WhatID =:oppID and Department__c= 'Transition Support Partners' ORDER BY CreatedDate ASC];
        return getTSPTaskDetails;
    }
    
    
}