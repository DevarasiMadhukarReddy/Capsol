/**
* SalesforceAEMService.cls
* Description  : This is webservice for AEM to provide salesforce contact present in salesforce to AEM. 
* 
* @Author      : Amit Verma(Cognizant)
* @version     : 1.0
* @CreatedDate : October 16,2017
* CH-01        : 11/24/2017; Naga modified to handle Production Defect- MIC- 225: Salesforce Integration Modification - Open Opportunity 
* CH-02        : 01/10/2018; Amit modified the class to add additional parameters to be passed to AEM. Parameters added: hireDate,firstName,lastName,firmName and firmType.
* CH-03        : 04/25/2018; Amit opening the filter for all the opportunities
*/


global class NewSalesforceAEMService { 
    
    
    global class LOGIN_DETAIL{      
        webservice String currentEmail;
        webservice String caseSafeId;       
    }
    
    global class ONBOARDINGCON_DETAIL{      
        webservice String OnboardingConsultant;
        webservice String OnboardingConsultantEmail;
        webservice String OnboardingConsultantPhone;
        webservice String OnboardingConsultantExtension;
        webservice String OnboardingConsultantMobilePhone;
        // New addition as part of NPH Wave 2 starts
        webservice String hireDate;
        webservice String firstName;
        webservice String lastName;
        webservice String firmName;
        webservice String firmType;
        // New addition as part of NPH Wave 2 ends
        webservice String opportunityStage;
        webservice Boolean initialCallOut;       
    }
    
    global class STATUS{
        webservice String StatusConditionDescription;
        webservice String StatusCode;
        webservice String StatusName;
        webservice String StatusDescription;        
    }
    
    global class MESSAGE{ 
        webservice STATUS STATUS;       
        webservice LOGIN_DETAIL LOGIN_DETAIL; 
        webservice ONBOARDINGCON_DETAIL ONBOARDINGCON_DETAIL;     
    }
    
    global class result{
        webservice MESSAGE MESSAGE;
    }
    
    
    webservice static result getSalesforceContactInfo(String email, String oppCaseSafeId) {
        
        result res = new result();
        res.MESSAGE = new MESSAGE();
        res.MESSAGE.STATUS = new STATUS();
        res.MESSAGE.LOGIN_DETAIL = new LOGIN_DETAIL();
        res.MESSAGE.LOGIN_DETAIL.currentEmail = '';
        res.MESSAGE.LOGIN_DETAIL.caseSafeId = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL = new ONBOARDINGCON_DETAIL();
        res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultant = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantEmail = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantPhone = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantExtension = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantMobilePhone = '';
        // New addition as part of NPH Wave 2 starts 
        res.MESSAGE.ONBOARDINGCON_DETAIL.hireDate = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.firstName = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.lastName = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.firmName = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.firmType = '';
        // New addition as part of Sprint 3 US
        res.MESSAGE.ONBOARDINGCON_DETAIL.opportunityStage = '';
        res.MESSAGE.ONBOARDINGCON_DETAIL.initialCallOut = false;
        // New addition as part of NPH Wave 2 ends
        String localOppCaseSafeId;
        
        if((oppCaseSafeId !='' && oppCaseSafeId != null)){ 
            try{   
                List<Opportunity> contactList0= [Select  Id, email__c 
                                                 From Opportunity where Id = :oppCaseSafeId];
                if(contactList0.size()>0 && contactList0[0].email__c != null) {
                    res.MESSAGE.LOGIN_DETAIL.currentEmail = contactList0[0].email__c;
                    res.MESSAGE.LOGIN_DETAIL.caseSafeId = oppCaseSafeId;
                    localOppCaseSafeId = oppCaseSafeId;
                    res.MESSAGE.STATUS.StatusName='SUCCESS';
                    res.MESSAGE.STATUS.StatusConditionDescription='';
                    res.MESSAGE.STATUS.StatusCode='200';
                    res.MESSAGE.STATUS.StatusDescription='Successfully Sent the Contact details'; 
                }                    
            }
            catch(Exception e){
                res.MESSAGE.STATUS.StatusName='ERROR';
                res.MESSAGE.STATUS.StatusConditionDescription='';
                res.MESSAGE.STATUS.StatusCode='301';
                res.MESSAGE.STATUS.StatusDescription='Error in caseSafeId section. Please contact salesforce Admin'; 
                return res ;               
            } 
        }
        else if((email !='' && email != null)){
            try{   
                 //List<Opportunity> contactList1= [Select  Id From opportunity where (Qualified__c ='Jaguar' OR Acquisition__c = 'Jaguar') and email__c = :email];//CH-01
                    
                 //opening the filter for all the opportunities: 4/25 CH-03
                    List<Opportunity> contactList1= [Select  Id From opportunity where (NOT StageName like '%Closed%') and email__c = :email];//CH-03
                
                if(contactList1.size()>0){
                    res.MESSAGE.LOGIN_DETAIL.currentEmail = email;
                    res.MESSAGE.LOGIN_DETAIL.caseSafeId = contactList1[0].Id;
                    localOppCaseSafeId = contactList1[0].Id;
                    res.MESSAGE.STATUS.StatusName='SUCCESS';
                    res.MESSAGE.STATUS.StatusConditionDescription='';
                    res.MESSAGE.STATUS.StatusCode='200';
                    res.MESSAGE.STATUS.StatusDescription='Successfully Sent the Contact details'; 
                } 
                else{
                    res.MESSAGE.STATUS.StatusName='ERROR';
                    res.MESSAGE.STATUS.StatusConditionDescription='';
                    res.MESSAGE.STATUS.StatusCode='303';
                    res.MESSAGE.STATUS.StatusDescription='No email Id found. Please try with a valid email Id'; 
                    return res ;
                }                   
            }
            catch(Exception e){
                res.MESSAGE.STATUS.StatusName='ERROR';
                res.MESSAGE.STATUS.StatusConditionDescription='';
                res.MESSAGE.STATUS.StatusCode='302';
                res.MESSAGE.STATUS.StatusDescription='Error in email section. Please contact salesforce Admin'; 
                return res ;              
            } 
        }
        else{
            res.MESSAGE.STATUS.StatusName='ERROR';
            res.MESSAGE.STATUS.StatusConditionDescription='';
            res.MESSAGE.STATUS.StatusCode='300';
            res.MESSAGE.STATUS.StatusDescription='No email and CasesafeId. One of these is required'; 
            return res ;
        }
        
        //---------------------------------------------------------------------------------------------------------
        System.debug('email Id>>'+email+'localOppCaseSafeId>.'+localOppCaseSafeId);
        
        if((localOppCaseSafeId !='' && localOppCaseSafeId != null)){ 
            try{   
                // New addition of fields and condition in query for Tasks as part of Sprint 3 US
                List<Opportunity> ooptyList = [SELECT Id,Integration_Manager__r.Name,Integration_Manager__r.Email,Integration_Manager__r.Phone ,Integration_Manager__r.Extension,Integration_Manager__r.MobilePhone,Regional_Transition_Partner__r.Name, email__c,GRC_Status__c,eKit_Received__c,Assigned_to_GRC_Analyst__c,Hire_Date__c,Account.name,Firm_Type__c,Contact__r.firstName, Contact__r.lastName,Firm_Type2__c,Firm_Type_Broker_Dealer__c,StageName, (Select Id,Activity_Type__c,Status From Tasks WHERE Activity_Type__c='Initial Call Out' AND Status='Completed') from opportunity where ID =: localOppCaseSafeId];
                if(ooptyList.size()>0) {
                    if(!String.isBlank(String.valueOf(ooptyList[0].Integration_Manager__r.Name))){
                        res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultant = String.valueOf(ooptyList[0].Integration_Manager__r.Name);
                        if(!String.isBlank(String.valueOf(ooptyList[0].Integration_Manager__r.Email))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantEmail = String.valueOf(ooptyList[0].Integration_Manager__r.Email);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantEmail = '';
                        }
                        if(!String.isBlank(String.valueOf(ooptyList[0].Integration_Manager__r.Phone))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantPhone = String.valueOf(ooptyList[0].Integration_Manager__r.Phone);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantPhone = '';
                        }
                        if(!String.isBlank(String.valueOf(ooptyList[0].Integration_Manager__r.Extension))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantExtension = String.valueOf(ooptyList[0].Integration_Manager__r.Extension);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantExtension = '';
                        }
                        if(!String.isBlank(String.valueOf(ooptyList[0].Integration_Manager__r.MobilePhone))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantMobilePhone = String.valueOf(ooptyList[0].Integration_Manager__r.MobilePhone);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.OnboardingConsultantMobilePhone = '';
                        }
                        // New addition as part of NPH Wave 2 starts 
                        if(!String.isBlank(String.valueOf(ooptyList[0].Hire_Date__c))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.hireDate = String.valueOf(ooptyList[0].Hire_Date__c);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.hireDate = '';
                        }
                        if(!String.isBlank(String.valueOf(ooptyList[0].Account.name))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.firmName = String.valueOf(ooptyList[0].Account.name);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.firmName = '';
                        } 
                        if(!String.isBlank(String.valueOf(ooptyList[0].Firm_Type_Broker_Dealer__c))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.firmType = String.valueOf(ooptyList[0].Firm_Type_Broker_Dealer__c);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.firmType = '';
                        } 
                        if(!String.isBlank(String.valueOf(ooptyList[0].Contact__r.firstName))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.firstName = String.valueOf(ooptyList[0].Contact__r.firstName);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.firstName = '';
                        } 
                        if(!String.isBlank(String.valueOf(ooptyList[0].Contact__r.lastName))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.lastName = String.valueOf(ooptyList[0].Contact__r.lastName);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.lastName = '';
                        } 
                        // New addition as part of NPH Wave 2 ends  
                        // New addition as part of Sprint 3 US
                        if(!String.isBlank(String.valueOf(ooptyList[0].StageName))){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.opportunityStage = String.valueOf(ooptyList[0].StageName);
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.opportunityStage = '';
                        }
                        if(ooptyList[0].Tasks.size()>0){
                            res.MESSAGE.ONBOARDINGCON_DETAIL.initialCallOut = true;
                        }
                        else{
                            res.MESSAGE.ONBOARDINGCON_DETAIL.initialCallOut = false;
                        }
                        // New addition as part of Sprint 3 US ends
                    }
                }                    
                res.MESSAGE.STATUS.StatusName='SUCCESS';
                res.MESSAGE.STATUS.StatusConditionDescription='';
                res.MESSAGE.STATUS.StatusCode='200';
                res.MESSAGE.STATUS.StatusDescription='Successfully Sent the Contact details'; 
            }
            catch(Exception e){
                res.MESSAGE.STATUS.StatusName='ERROR';
                res.MESSAGE.STATUS.StatusConditionDescription='';
                res.MESSAGE.STATUS.StatusCode='301';
                res.MESSAGE.STATUS.StatusDescription='Error in caseSafeId section. Please contact salesforce Admin'; 
            } 
        }
        else{
            res.MESSAGE.STATUS.StatusName='ERROR';
            res.MESSAGE.STATUS.StatusConditionDescription='';
            res.MESSAGE.STATUS.StatusCode='300';
            res.MESSAGE.STATUS.StatusDescription='No email and CasesafeId found'; 
        }
        return res ;
    }
}