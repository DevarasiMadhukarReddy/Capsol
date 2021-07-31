/************************************************************************
* Date : 05/31/2017; 
* naga created for Advisor Self Service project BTS727
* Project code : BTS727 ServiceWorks project
*************************************************************************/
// Create rest resource which is unique for calling from Client Application
@RestResource(urlMapping='/RepProfile/*')
global class LPL_RepProfile{
    // Expose method as get using @HttpGet to fetch contact details 
    //class to store the response data
    //Adding At_Risk_Level__c, Net_Promoter_Score__c, and Advisor_Channel__c for ServiceWorks team on 8/27/19 (contact: Vlad Predtechensky). Jeff Box
     
    global class RepClass {
        String Id;
        String atRiskIndicator;
        Date   conversionDate;
        String LPLCRMAssistantName;
        String name;
        String title;
        String accountName;                                    
        String phone;
        string mobile; 
        string email;                                        
        String role;                                    
        String role_Override;                                    
        String description;                                    
        String website;
        String ISRegionalAdvisoryConsultantId;                                    
        String internalAdvisoryConsultantId;                                    
        String regionalAdvisoryConsultantId;                                    
        String integrationManagerId;                                    
        String internalAnnuityConsultantId;                                    
        String internalAIConsultantId;                                    
        String internalInsuranceSpecialist;                                    
        String ExternalInsuranceSpecialist;
        string internalbusinessconsultant;                                    
        String BCRMRegion;                                    
        String advisoryTerritory; 
        String ISAdvisoryTerritoryId;                                   
        String service360Teamc;                                    
        String designatedPrincipal;                                    
        String educationConsultant;                                    
        String retirementPartnersRM;                                    
        String LBEConsultant;
        String BusinessConsultantRMId;
        String MasterRepId;
        String EnterpriseName;
        String AtRiskLevel;
        Decimal NetPromoterScore;
        String AdvisorChannel;
        string photo;
    }
 @HttpGet
    global static RepClass getContactByRepId() {
        try
        {
            RestRequest request = RestContext.request;
            Contact recContact = new Contact();
            // grab the Contact Rep Id from the end of the URL
            RepClass strRep= new RepClass();
            String RepId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
            // Get Id of contact using Rep Id
            recContact= [Select Id
                         , At_Risk_Level__c
                         ,Conversion_Date__c
                         ,LPLCRM__Assistant_Name__c
                         ,Title
                         ,Name
                         ,Account.Name
                         ,Phone
                         ,MobilePhone
                         ,Email
                         ,Role__c
                         ,Photo__c
                         ,Role_Override__c
                         ,Description
                         ,Website__c
                         ,Internal_Advisory_Consultant__c
                         ,Regional_Advisory_Consultant__c
                         ,Hybrid_Advisory_Consultant__c
                         ,Integration_Manager__c
                         ,Internal_Annuity_Consultant__c
                         ,Internal_AI_Consultant__c
                         ,IS_Advisory_Territory__c
                         ,Internal_Insurance_Specialist__c
                         ,External_Insurance_Specialist__c
                         ,BC_RM_Region__c
                         ,Advisory_Territory__c
                         ,Service_360_Team__c
                         ,Designated_Principal__c
                         ,Education_Consultant__c
                         ,Retirement_Partners_RM__c
                         ,LBE_Consultant_1__c,
                         Business_Consultant_RM__c,
                         Master_Rep_ID__c ,
                         Enterprise_Name__c,
                         Net_Promoter_Score__c,
                         Advisor_Channel__c                   
                         From contact where Master_Rep_ID__c = :RepId LIMIT 1];
            String Photourl;
            if(recContact.Photo__c!=null){
                String strBase64;
                String contactimg = recContact.Photo__c.substringBetween('<img', 'img>');
                String imgsrc = Contactimg.substringBetween('src="', '"');
                imgsrc = imgsrc.replace('amp;', '');
                PageReference page = new PageReference(imgsrc);
                if(!Test.isRunningTest()){
                Blob imgblob = page.getContent();
                strBase64  = EncodingUtil.base64Encode(imgblob);  }
               
                Photourl ='<img alt="photo" src="data:image/jpg;base64,"'+strBase64+'></img>'; 
               }//end if
            if(recContact !=null)
            {
                strRep.Id = recContact.Id;
                strRep.accountName= recContact.Account.Name ; 
                strRep.name = recContact.Name;
                strRep.title = recContact.Title;                              
                strRep.phone  =    recContact.Phone ; 
                strRep.mobile = recContact.MobilePhone; 
                strRep.email = recContact.Email;                           
                strRep.role   =    recContact.Role__c ; 
                strRep.Photo = Photourl;                          
                strRep.role_Override=     recContact.Role_Override__c ;                              
                strRep.description =   recContact.Description ;                             
                strRep.website   =     recContact.Website__c ;                          
                strRep.internalAdvisoryConsultantId  =   recContact.Internal_Advisory_Consultant__c;                               
                strRep.regionalAdvisoryConsultantId  =   recContact.Regional_Advisory_Consultant__c;                               
                strRep.integrationManagerId  =      recContact.Integration_Manager__c;             
                strRep.internalAnnuityConsultantId=   recContact.Internal_Annuity_Consultant__c;                           
                strRep.internalAIConsultantId     =   recContact.Internal_AI_Consultant__c;                
                strRep.internalInsuranceSpecialist  =    recContact.Internal_Insurance_Specialist__c;                    
                strRep.externalInsuranceSpecialist   =   recContact.External_Insurance_Specialist__c;                   
                strRep.BCRMRegion  =     recContact.BC_RM_Region__c ;
                strRep.advisoryTerritory =  recContact.Advisory_Territory__c;           
                strRep.service360Teamc  =   recContact.Service_360_Team__c;       
                strRep.designatedPrincipal   =   recContact.Designated_Principal__c ;              
                strRep.educationConsultant   =    recContact.Education_Consultant__c;            
                strRep.retirementPartnersRM  =  recContact.Retirement_Partners_RM__c;               
                strRep.LBEConsultant=recContact.LBE_Consultant_1__c;                        
                strRep.BusinessConsultantRMId    =    recContact.Business_Consultant_RM__c;
                strRep.MasterRepId = recContact.Master_Rep_ID__c;
                strRep.EnterpriseName = recContact.Enterprise_Name__c;
                strRep.AtRiskLevel = recContact.At_Risk_Level__c;
                strRep.NetPromoterScore = recContact.Net_Promoter_Score__c;
                strRep.AdvisorChannel = recContact.Advisor_Channel__c;
                strRep.ISRegionalAdvisoryConsultantId = recContact.Hybrid_Advisory_Consultant__c;                 
            }//end if
            return strRep;
        }//end try
        
        catch(Exception e){  //If Query has nothing to return
            //RestContext.response.statusCode = 404;           
            return null;
            
        }//end catch
    }//end class
}//end LPL Rep Profile class