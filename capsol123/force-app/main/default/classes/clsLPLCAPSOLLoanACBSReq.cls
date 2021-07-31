/***
     * This class is used to get Loan Data fromACBS based on Master Rep Id of Advisor.
     * CH.No       Description                                                           Developer           Date
--------------------------------------------------------------------------------------------------------------------------
          
      * CH01      CS-3367 Get ACBS Loan Details                                            Bhanu               06/22/2021
      * CH02      CS-3380 Error handling display                                Bhanu               07/01/2021
      */           


    public class clsLPLCAPSOLLoanACBSReq {

   
   
   // CH01 start
        @AuraEnabled
        public static Map<String,Object> getloanPayment(Id ContactId){
            try {
          DatePowerEndpoint__mdt dpEndpoint = new DatePowerEndpoint__mdt();
             dpEndpoint = [Select DataPowerDEVEndpoint__c,DataPowerPRODEndpoint__c,DataPowerQAEndpoint__c, DataPowerAccessTokenAPI__c, DataPowerAccessTokenAuthHeader__c,
                        DataPowerACBSAccessTokenAPIBody__c,DataPowerACBSEndpoint__c from DatePowerEndpoint__mdt];
       
        List<contact> lstContact = new List<contact>();
        lstContact = [Select Id,name,Master_Rep_ID__c from Contact where id =:ContactId];
        String MasterRepId='';    
        if(lstContact.size() > 0){
        MasterRepId= lstContact[0].Master_Rep_ID__c;
        }
             
           
        system.debug('dpEndpoint-------'+dpEndpoint);
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('Base URL: ' + sfdcBaseURL );  
        
        String endpoint = ''; 
              
        if(sfdcBaseURL.contains('lplmainorg--qa')){
           endpoint = dpEndpoint.DataPowerQAEndpoint__c;  
        }else if(sfdcBaseURL.contains('lplmainorg--finance')){
            endpoint = dpEndpoint.DataPowerDEVEndpoint__c;
        }else if(sfdcBaseURL.contains('lplmainorg--int1')){
            endpoint = dpEndpoint.DataPowerDEVINTEndpoint__c;
        }else if(sfdcBaseURL.contains('lplmainorg.')){
            endpoint = dpEndpoint.DataPowerPRODEndpoint__c;
        }else if(sfdcBaseURL.contains('lplmainorg--c.')){ // Added by Amol 7/24
            endpoint = dpEndpoint.DataPowerPRODEndpoint__c;
        }
       HttpRequest req = new HttpRequest();
       req.setEndpoint(endpoint+dpEndpoint.DataPowerAccessTokenAPI__c);
       req.setMethod('POST');
       req.setHeader('Authorization', dpEndpoint.DataPowerAccessTokenAuthHeader__c);
       req.setBody(dpEndpoint.DataPowerACBSAccessTokenAPIBody__c);
       
       Http http = new Http();
       HTTPResponse res = http.send(req);
         system.debug('-----res 53 -------'+res );
        if(res.getStatusCode() != 200){
            //CH02 Start
              LoanSubmitApplication.snowError = 'DataPower';
            LPL_CreateExceptionLog.createErrorRecordForSFMuleAPIFailure('clsLPLCAPSOLLoanACBSReq','getloanPayment',52,dpEndpoint.DataPowerACBSAccessTokenAPIBody__c,
            res.getBody(),'Data Power',res.getStatus(),res.getStatusCode(),null,ContactId);  
            
              Map<String,Object> reslt= new Map<String,Object>();
           reslt.put('loanDetails',(Object)'DataPower');
          system.debug('-----reslt 61 -------'+reslt);
           return reslt;
            } //CH02 Ends
            else{ 
       System.debug(JSON.deserializeUntyped(res.getBody()));
       Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
       String accessToken = (String)metadata_Map.get('access_token');
       system.debug('token-----------'+accesstoken);
           HttpRequest req1 = new HttpRequest();
             req1.setEndpoint(endpoint+dpEndpoint.DataPowerACBSEndpoint__c);
             req1.setMethod('GET');
             req1.setTimeout(60000); 
             req1.setHeader('Content-Type', 'application/json');
             req1.setHeader('Authorization', 'Bearer ' +accessToken);
             req1.setHeader('oauthuri', '/'+MasterRepId);
             req1.setHeader('userid', '28184');
             Http http1 = new Http();
           
           HTTPResponse res1 = http1.send(req1);
           if(res1.getStatusCode() == 200){
           Map<String, Object> metadata_Map1 = (Map<String, Object>) JSON.deserializeUntyped(res1.getBody());
         
           Object value = (Object) metadata_Map1.get('data');
            Map<String,Object> mappedValue = (Map<String,Object>)value;
         
          system.debug('-----response-------'+mappedValue);
          system.debug('-----response123-------' + mappedValue.get('loanDetails'));
           return mappedValue;
            }
           else{
            //CH02 Start
            LoanSubmitApplication.snowError = 'MuleSoft';
            LPL_CreateExceptionLog.createErrorRecordForSFMuleAPIFailure('clsLPLCAPSOLLoanACBSReq','getloanPayment',74,dpEndpoint.DataPowerACBSEndpoint__c,
            res1.getBody()+'\n','Mule Soft',res1.getStatus(),res1.getStatusCode(),null,ContactId);           }
           Map<String,Object> reslt= new Map<String,Object>();
           reslt.put('loanDetails',(Object)'MuleSoft');
          system.debug('-----MuleSoft-------'+reslt);
           return reslt;//CH02 Ends
           }
           } catch (Exception e) {
               // throw new AuraHandledException(e.getMessage());
               
                 Map<String,Object> reslt= new Map<String,Object>();
           reslt.put('loanDetails',(Object)'DataPower');
          system.debug('-----reslt 61 -------'+reslt);
           return reslt;
           }
           
        }
        
        
       // CH01 ends
       
    }