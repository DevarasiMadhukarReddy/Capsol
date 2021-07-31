/***
     * This class is used to create SNOW Ticket when SF-DP/Mule integration fails for Capsol.
     * 
     * 
     * Error Handling-Create Integration Error records in SF when SF invokes Data Power or Mule Soft API.
     *                                              ---Updated by Amol Sprint 13 CapSol - 06/19/2020 - CH01
     * 
     * CS-1344 - Error handling: Salesforce - SnowInator Integration - 07/16/2020 - CH01
     * 
     * 
     * Author - Amol Deshpande
     * 
     * 
     * * CH.No       Description                                                           Developer           Date
      ---------------------------------------------------------------------------------------------------------------
     *  CH02       CS-2756 Sprint 21- Remove hardcoded loan application status values     Bhanu              02/01/2021
        CH03       CS-3380            Error handling display                              Bhanu              07/01/2021
     */

// Start CH01
public class cls_lpl_CreateSNOWTicket_CAPSOL {
    public cls_lpl_CreateSNOWTicket_CAPSOL() {}

        //@future(callout=true)
        public static void makeSNOWCallout(Id loanId,Id conId){
DatePowerEndpoint__mdt dpEndpoint = new DatePowerEndpoint__mdt();
        dpEndpoint = [Select DataPowerDEVEndpoint__c,DataPowerPRODEndpoint__c,DataPowerQAEndpoint__c,DataPowerAccessTokenAPIBody__c,
                        DataPowerAccessTokenAPI__c,DataPowerAccessTokenAuthHeader__c,DataPowerSendSFDataToCLOSubmitAPI__c,
                        DataPowerSFDataToCLOUpdateApplicationAPI__c,DataPowerSFDataToCLOUpdateCustomerAPI__c,
                        DPAccessTokenUpdateCustomerAPIBody__c,DataPowerAccessTokenUpdateLoanAPIBody__c,DataPowerSNOWEndpoint__c,
                        DataPowerSNOWAccessTokenAPIBody__c,DataPowerDEVINTEndpoint__c from DatePowerEndpoint__mdt];
                        
                        Loan_Application__c loanApp = new Loan_Application__c();
            if(loanId != null){
                  loanApp  = [select id,name,status__c from Loan_Application__c where id = :loanId];
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
        }
       HttpRequest req = new HttpRequest();
       req.setEndpoint(endpoint+dpEndpoint.DataPowerAccessTokenAPI__c);
       req.setMethod('POST');
       req.setHeader('Authorization', dpEndpoint.DataPowerAccessTokenAuthHeader__c);
       req.setBody(dpEndpoint.DataPowerSNOWAccessTokenAPIBody__c);
       Http http = new Http();
       HTTPResponse res = http.send(req);
                      system.debug('--------res -----------'+res);

System.debug(JSON.deserializeUntyped(res.getBody()));
       Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
       string accessToken = (string)metadata_Map.get('access_token');
       system.debug('token-----------'+accesstoken);

HttpRequest req1 = new HttpRequest();
             req1.setEndpoint(endpoint+dpEndpoint.DataPowerSNOWEndpoint__c);
             req1.setMethod('POST');
             req1.setTimeout(60000); 
             req1.setHeader('Content-Type', 'application/json');
             req1.setHeader('Authorization', 'Bearer ' +accessToken);

JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('type', 'SFMULECONN');
        if(loanApp.name != null){
            gen.writeStringField('applicationID', string.valueOf(loanApp.name));
        }
        // Start CH03
         if(conId != null){
         
          List<contact> lstContact = new List<contact>();
        lstContact = [Select Id,name,Master_Rep_ID__c from Contact where id =:conId];
        String MasterRepId='';    
        if(lstContact.size() > 0){
        MasterRepId= lstContact[0].Master_Rep_ID__c;
        }
         
            gen.writeStringField('applicationID', MasterRepId);
        }
         //End
        
        gen.writeEndObject();
        string jsonstring = gen.getAsString();
        req1.setBody(jsonstring);
        system.debug('jsonstring--------'+jsonstring);
          //Start CH02
         String LoanAppstatus='';
         // Start CH03
               if(loanApp!=null && loanApp.name != null)
               {

         LoanAppstatus=LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_3');}
        //End
             Http http1 = new Http();
             HTTPResponse res1 = http1.send(req1);
               system.debug('--------res1 -----------'+res1);

             system.debug('res1--------'+res1.getBody());
               // Start CH03
               if(loanApp!=null && loanApp.name != null)
               {
                 loanApp.status__c = LoanAppstatus;  //CH02
                 update loanApp;
                 }//End
        }
}
//End CH01