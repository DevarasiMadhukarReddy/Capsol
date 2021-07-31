/**
 * SalesforceContactService.cls
 * Description  : This is webservice for siebel to provide salesforce contact and exception data of salesforce to siebel. 
 * 
 * @Author      : Subhash Ghorpade(Cognizant)
 * @version     : 1.0
 * @CreatedDate : April 30,2015
 */


global class SalesforceContactService { 
   
   //Define an object in apex that is exposed in apex web service
   global class SalesforceContactClass {
   
           
           webservice String atRiskIndicator;
           webservice Date conversionDate;
           webservice String LPLCRMAssistantName;
           webservice String name;
           webservice String accountName;                                    
           webservice String phone;                                    
           webservice String role;                                    
           webservice String role_Override;                                    
           webservice String description;                                    
           webservice String website;                                    
           webservice String internalAdvisoryConsultantName;                                    
           webservice String regionalAdvisoryConsultantName;                                    
           webservice String integrationManagerName;                                    
           webservice String internalAnnuityConsultantName;                                    
           webservice String internalAIConsultantName;                                    
           webservice String internalInsuranceSpecialist;                                    
           webservice String ExternalInsuranceSpecialist;                                    
           webservice String BCRMRegion;                                    
           webservice String advisoryTerritory;                                    
           webservice String service360Teamc;                                    
           webservice String designatedPrincipal;                                    
           webservice String educationConsultant;                                    
           webservice String retirementPartnersRM;                                    
           webservice String LBEConsultant;
           webservice String BusinessConsultantRM;
           webservice List<SalesforceExceptionClass> exceptionclass;
           
   }
   
    //Define an object in apex that is exposed in apex web service
   global class SalesforceExceptionClass {
   
          webservice String   name;
          webservice Date     expirationorReviewDate;
          webservice String   exceptionValue;
          webservice String   exceptionType;
          webservice Boolean   exceptionDoesNotExpire;
          webservice String   approvedByName;
          webservice String   createdByName;
          
   }


   global class ResponseContactsAndExceptionsClass {
        webservice String status ;
        webservice String error ;
        webservice List<SalesforceContactClass> results;
    }

   
   

   webservice static ResponseContactsAndExceptionsClass getSalesforceContact(String repId) {
        
        System.debug('repId=============================='+repId);
        
        ResponseContactsAndExceptionsClass rtnError = new ResponseContactsAndExceptionsClass ();
        
        List<SalesforceContactClass> lstSalesforceContact= new List<SalesforceContactClass>();
        
        String trimrepId = repId.trim();
        
        if(trimrepId !='' && trimrepId != null)
         {   
            try
            
                {   
                    List<Contact> contactList= [Select  At_Risk_Level__c
                    ,Conversion_Date__c
                    ,LPLCRM__Assistant_Name__c
                    ,Name
                    ,Account.Name
                    ,Phone
                    ,Role__c
                    ,Role_Override__c
                    ,Description
                    ,Website__c
                    ,Internal_Advisory_Consultant__r.Name
                    ,Regional_Advisory_Consultant__r.Name
                    ,Integration_Manager__r.Name
                    ,Internal_Annuity_Consultant__r.Name
                    ,Internal_AI_Consultant__r.Name
                    ,Internal_Insurance_Specialist__c
                    ,External_Insurance_Specialist__c
                    ,BC_RM_Region__c
                    ,Advisory_Territory__c
                    ,Service_360_Team__c
                    ,Designated_Principal__c
                    ,Education_Consultant__c
                    ,Retirement_Partners_RM__c
                    ,LBE_Consultant_1__c,
                    Business_Consultant_RM__r.Name,
                    (Select Name, Expiration_or_Review_Date__c, Exception_Value__c, Exception_Type__c, Exception_Does_Not_Expire__c, Approved_By__r.Name,CreatedBy.Name From Exceptions_History__r )
                    From contact where Master_Rep_ID__c = :trimrepId ];
                    
                    System.debug('Contact List=============================='+contactList);
                    
                    if(contactList.size()>0)
                     {
                    
                    
                        for(Contact con: contactList){
                        
                        SalesforceContactClass cls= new SalesforceContactClass();
                        
                        if(con.At_Risk_Level__c != NULL && con.At_Risk_Level__c !='')
                        cls.atRiskIndicator = con.At_Risk_Level__c;
                        else
                        cls.atRiskIndicator= NULL;
                        
                        if(con.Conversion_Date__c!= NULL)
                        cls.conversionDate = con.Conversion_Date__c;
                        else
                        cls.conversionDate = NULL;
                        
                        if(con.LPLCRM__Assistant_Name__c!= NULL && con.LPLCRM__Assistant_Name__c!='')
                        cls.LPLCRMAssistantName =con.LPLCRM__Assistant_Name__c;
                        else
                        cls.LPLCRMAssistantName = NULL;
                        
                        if(con.Name!= NULL && con.Name!='')
                        cls.name= con.Name;
                        else
                        cls.name= NULL;
                        
                        cls.accountName=    con.Account.Name ;                               
                        cls.phone  =    con.Phone ;                             
                        cls.role   =    con.Role__c ;                           
                        cls.role_Override=     con.Role_Override__c ;                              
                        cls.description =   con.Description ;                             
                        cls.website   =     con.Website__c ;                          
                        cls.internalAdvisoryConsultantName  =   con.Internal_Advisory_Consultant__r.Name;                               
                        cls.regionalAdvisoryConsultantName  =   con.Regional_Advisory_Consultant__r.Name;                               
                        cls.integrationManagerName  =      con.Integration_Manager__r.Name;             
                        cls.internalAnnuityConsultantName=   con.Internal_Annuity_Consultant__r.Name;                           
                        cls.internalAIConsultantName     =   con.Internal_AI_Consultant__r.Name;                
                        cls.internalInsuranceSpecialist  =    con.Internal_Insurance_Specialist__c;                    
                        cls.externalInsuranceSpecialist   =   con.External_Insurance_Specialist__c;                   
                        cls.BCRMRegion  =     con.BC_RM_Region__c ;
                        cls.advisoryTerritory =  con.Advisory_Territory__c;           
                        cls.service360Teamc  =   con.Service_360_Team__c;       
                        cls.designatedPrincipal   =   con.Designated_Principal__c ;              
                        cls.educationConsultant   =    con.Education_Consultant__c;            
                        cls.retirementPartnersRM  =  con.Retirement_Partners_RM__c;               
                        cls.LBEConsultant=con.LBE_Consultant_1__c;                        
                        cls.BusinessConsultantRM    =    con.Business_Consultant_RM__r.Name;
                        List<SalesforceExceptionClass> lstSalesforceException= new List<SalesforceExceptionClass>();
                        for(Exceptions_History__c exp: con.Exceptions_History__r)
                        {
                            SalesforceExceptionClass expcls= new SalesforceExceptionClass();
                            
                            expcls.name=exp.Name;
                            expcls.expirationorReviewDate=exp.Expiration_or_Review_Date__c;
                            expcls.exceptionValue=exp.Exception_Value__c;
                            expcls.exceptionType=exp.Exception_Type__c;
                            expcls.exceptionDoesNotExpire=exp.Exception_Does_Not_Expire__c;
                            expcls.approvedByName=exp.Approved_By__r.Name;
                            expcls.createdByName=exp.CreatedBy.Name;
                            
                            System.debug('expcls=============================='+expcls); 
                            lstSalesforceException.add(expcls);
                            
                            System.debug('SalesforceExceptionClass =============================='+lstSalesforceException);
                        }
                        
                        cls.exceptionclass=lstSalesforceException;
                        
                        lstSalesforceContact.add(cls); 
                        }
                        
                        System.debug('lstSalesforceContact=============================='+lstSalesforceContact);
                        
                        rtnError.status='SUCCESS';
                        rtnError.error = '';
                        rtnError.results=lstSalesforceContact;
                        
                        }
                        
                        else{
                        
                        rtnError.status='ERROR';
                        rtnError.error = 'Contact associated with the requested REP ID is not present in salesforce';                        
                        
                        }
                    
                }
            
                catch(Exception e)            
                {
                
                 rtnError.status='ERROR';
                 rtnError.error = String.valueof(e);
                
                }  
            
            
            }   
            
            else{
            
                rtnError.status='ERROR';
                rtnError.error = 'REP ID can not be blank or null,Please provide valid REP ID';
            
            
            }   
        
        return rtnError;
  }
  


}