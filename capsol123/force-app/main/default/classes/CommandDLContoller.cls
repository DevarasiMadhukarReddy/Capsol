public with sharing class CommandDLContoller {

    


    //Public String SRCount{get; set;}
    Public String urlid{get; set;}
    Public String RepName {get; set;}
    public Boolean result{get; set;}    
    public Boolean hideInfo {get; set;}    
    public List<Automated_Data_Processes__c> adpList {get; set;}
    
    Public CommandDLContoller ()
    {
      result = false;
      hideInfo =true;
      urlid=apexpages.currentpage().getparameters().get('id');
      system.debug('------'+urlid);
    }

    
    public PageReference cancel() {
        return new pagereference('/' + urlid);
    }
    
    public void getFileCopyConfirmation() {
        
       
        if((validateId(urlid) != null)&& (validateId(urlid) != ''))
        {
        
        adpList = [select Name,Process_Name__c,Moved_to_Production_Successful__c from  Automated_Data_Processes__c where Id=: urlid limit 1];
        RepName =UserInfo.getFirstName() + ' ' +UserInfo.getLastName(); 
        
        system.debug('------'+adpList );
        system.debug('------'+RepName );
        
        
        lplComBtsProjectsLplsalesforcedatalo.RequestHeaderType RequestHeader = new lplComBtsProjectsLplsalesforcedatalo.RequestHeaderType();
        
        RequestHeader.organization='LPL';
        
        Blob blobKey = crypto.generateAesKey(128);       
        RequestHeader.transactionId=EncodingUtil.convertToHex(blobKey);
        RequestHeader.timeStamp=Datetime.now();
        RequestHeader.SourceSystem='Salesforce';
        RequestHeader.hostName='CHLCNU3059RRM';
        
        lplComBtsProjectsLplsalesforcedatalo.AutomatedDLRequestType serviceDLReqType = new lplComBtsProjectsLplsalesforcedatalo.AutomatedDLRequestType();
        serviceDLReqType.salesforceRecordId=adpList[0].Name;
        system.debug('serviceDLReqType.salesforceRecordId------'+serviceDLReqType.salesforceRecordId );
        serviceDLReqType.folderName= adpList[0].Process_Name__c;
        system.debug('serviceDLReqType.folderName------'+serviceDLReqType.folderName);
        serviceDLReqType.userName = RepName;
        system.debug('serviceDLReqType.userName-----'+serviceDLReqType.userName );
        
        lplComBtsSalesforceautodl.LPLSalesForceDataLoadPortTypeEndpoint0 stub = new  lplComBtsSalesforceautodl.LPLSalesForceDataLoadPortTypeEndpoint0 ();
        
        stub.endpoint_x =Label.Automated_DL_Service;        
        stub.timeout_x=12000;   
        
        lplComBtsProjectsLplsalesforcedatalo.ResponseHeaderType   SRResponseService;
        
          try
                {    
                    /*if((validateId(urlid) != null)&& (validateId(urlid) != ''))
                        {*/
                             system.debug('+++++++++in Responce');
                             SRResponseService = stub.triggerSalesForceDataLoad(RequestHeader, serviceDLReqType);
                             system.debug('+++++++++in SRResponseService ' + SRResponseService );
                             
                       /* }
                        
                        else
                        {
                        
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Record Id is blank');
                                        ApexPages.addMessage(myMsg); 
                        
                        }*/
                 }                
                catch(System.CalloutException e)        
                {                
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Service is not available,Please try again later'+ e);
                        ApexPages.addMessage(myMsg);
                }
                
                      
        
        if(SRResponseService != null && SRResponseService.success == 'true')
        {
        
          adpList[0].Moved_to_Production_Successful__c = true;
          system.debug('adpList[0]' + adpList[0]);
         
          result = true;
          hideInfo = false;
          
         updateADPRecord();
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Success');
                                    ApexPages.addMessage(myMsg); 
         
        } else {
            result = true;
            hideInfo = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Failure');
                                    ApexPages.addMessage(myMsg); 
        }
        
     
    } else  {
        
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Service is not available');
                                        ApexPages.addMessage(myMsg); 
                       
        
    }
       
    }
    
    public void updateADPRecord(){
          
          system.debug('-------- Updated all records' + adpList);
          if(adpList!= null)
          update adpList;
    }
    
   static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return id;
        }
        return null;
}
}