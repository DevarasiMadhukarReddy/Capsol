public class SubscriptionDataContoller
{


    Public String SRCount{get; set;}
    Public String urlid{get; set;}
    Public String RepName {get; set;}


    Public SubscriptionDataContoller()
    {
    
        urlid=apexpages.currentpage().getparameters().get('id');
        
        if(urlid!='' && urlid!= NULL )
        {        
            list<Contact> lst= [SELECT Name FROM Contact WHERE Master_Rep_ID__c = :urlid];
            RepName =lst[0].Name;
        }
        
        List<subscriptionDataWrapper> lstSubWrapper = new List<subscriptionDataWrapper>(); 
        
        lstSubWrapper = getSubcriotionData();
        SRCount=string.valueof(lstSubWrapper.size());
        
        System.debug('SRCount=============================='+SRCount);
    
    }

    public List<subscriptionDataWrapper> getSubcriotionData()    
    {
        String urlid=apexpages.currentpage().getparameters().get('id');
        List<subscriptionDataWrapper> lstSubWrapper = new List<subscriptionDataWrapper>();        
        List<subscriptionDataWrapper> lstSubWrapperActive = new List<subscriptionDataWrapper>();
        List<subscriptionDataWrapper> lstSubWrapperCancelled = new List<subscriptionDataWrapper>();        
        lplComBtsLplsiebeladapterserviceOrde.RequestHeaderType RequestHeader= new lplComBtsLplsiebeladapterserviceOrde.RequestHeaderType();
        RequestHeader.organization='LPL';
        Blob blobKey = crypto.generateAesKey(128);       
        RequestHeader.transactionId=EncodingUtil.convertToHex(blobKey);
        RequestHeader.timeStamp=DateTime.now();
        RequestHeader.SourceSystem='salesforce';
        RequestHeader.hostName='CHLCNU3059RRM';
        lplComBtsSiebelcontact.SiebelContactPortTypeEndpoint1 stub = new lplComBtsSiebelcontact.SiebelContactPortTypeEndpoint1();
        //stub.clientCertName_x='SiebelService_Client_Certificate';
        stub.endpoint_x=Label.Tibco_Service_URL;
        stub.timeout_x=120000;
        lplComBtsLplsiebeladapterserviceOrde.OrderFulfillmentResponseType  OrderFullfilmentResponseService;
        
        if((urlid != null)&& (urlid != ''))
        {        
                try
                {                   
                
                    OrderFullfilmentResponseService= stub.OrderFulfillment(RequestHeader,urlid);  
                    
                 //    lstSubWrapper=    processSubcriotionData(OrderFullfilmentResponseService);      
                
                
                    lplComBtsLplsiebeladapterserviceOrde.ListLPLContactOrderFulfillmentType LPLContactOrderFulfillment=OrderFullfilmentResponseService.ListLPLContactOrderFulfillment;
                    lplComBtsLplsiebeladapterserviceOrde.ContactType[] Contact=LPLContactOrderFulfillment.Contact;
                    Map<String, subscriptionDataWrapper> subscriptionDataWrapperMap = new Map<String, subscriptionDataWrapper>(); // Reversed for sorting
                    List<String> sortThis = new List<String>();
                    Map<String, subscriptionDataWrapper> subscriptionDataWrapperMap1 = new Map<String, subscriptionDataWrapper>(); // Reversed for sorting
                    List<String> sortThis1 = new List<String>();
                    integer i=0;
                
                        if(Contact != null)                   
                        {                        
                                for(lplComBtsLplsiebeladapterserviceOrde.ContactType c:Contact)
                                { 
                                
                                   if(c.ListOfOrderFulfillment.OrderFulfillment != null)         
                                   { 
                                   
                                       for(lplComBtsLplsiebeladapterserviceOrde.OrderFulfillmentType o:c.ListOfOrderFulfillment.OrderFulfillment)
                                        { 
                                       
                                            subscriptionDataWrapper  SubWrapper = new subscriptionDataWrapper();
                                            
                                                      
                                            if(o.productStatus =='Active')
                                            {
                                                SubWrapper.FulfillmentID  = o.fulfillmentID;
                                                SubWrapper.ProductName= o.productName;
                                                SubWrapper.ProductVersion = o.productVersion;
                                                SubWrapper.ProductStatus = o.productStatus;
                                                SubWrapper.ProductFulfilledby = o.productFulfilledby;
                                                SubWrapper.Notes = o.notes;
                                                SubWrapper.DateActivated = o.dateActivated;
                                                SubWrapper.DateCancelled  = o.dateCancelled;
                                                lstSubWrapperActive.add(SubWrapper); 
                                                subscriptionDataWrapperMap.put(o.productName+o.fulfillmentID,SubWrapper);                          
                                                sortThis.add(o.productName+o.fulfillmentID);
                                                i++;
                                            }
                                            
                                            else
                                            {    
                                                SubWrapper.FulfillmentID  = o.fulfillmentID;
                                                SubWrapper.ProductName= o.productName;
                                                SubWrapper.ProductVersion = o.productVersion;
                                                SubWrapper.ProductStatus = o.productStatus;
                                                SubWrapper.ProductFulfilledby = o.productFulfilledby;
                                                SubWrapper.Notes = o.notes;
                                                SubWrapper.DateActivated = o.dateActivated;
                                                SubWrapper.DateCancelled  = o.dateCancelled;                                     
                                                lstSubWrapperCancelled.add(SubWrapper);                                        
                                                subscriptionDataWrapperMap1.put(o.productName+o.fulfillmentID,SubWrapper);                          
                                                sortThis1.add(o.productName+o.fulfillmentID);
                                                i++;
                                            }
                                            
                                            
                                        
                                        }
                                        i=i+1;
                                        
                                        System.debug('HERE1================================ i'+ i );
                                    
                                    }
                                    
                                  
                                    
                                    
                                    
                                    
                                }
                                
                                  if(i==0){
                                    
                                       System.debug('HERE2================================ i'+ i );
                                    
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Subscription Record is associated with Selected Contact.');
                                        ApexPages.addMessage(myMsg); 
                                    }
                                
                               sortThis.sort();   
                               sortThis1.sort(); 
                               
                               for(String s : sortThis)
                                {
                                       lstSubWrapper.add(subscriptionDataWrapperMap.get(s));
                                       
                                        System.debug('HERE2================================ i'+ i );
                                }   
                                
                                 for(String s : sortThis1)
                                {
                                       lstSubWrapper.add(subscriptionDataWrapperMap1.get(s));
                                       
                                        System.debug('HERE2================================ i'+ i );
                                } 
                                
                         }       
                         else
                         {
                             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Rep Id does not exist in Siebel');
                             ApexPages.addMessage(myMsg);   
                          
                         }   
                         
                         
                          
                          
                  }  
                  catch(System.CalloutException e)    
                   {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Service is not available,Please try again later');
                        ApexPages.addMessage(myMsg);
                   }
            
                }
        
                else
                {
                
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Master Rep Id is blank');
                        ApexPages.addMessage(myMsg); 
                
                }
            return lstSubWrapper;
    
    }
    
    /**
     public List<subscriptionDataWrapper> processSubcriotionData(lplComBtsLplsiebeladapterserviceOrde.OrderFulfillmentResponseType  OrderFullfilmentResponseService)    
    {
        List<subscriptionDataWrapper> lstSubWrapper = new List<subscriptionDataWrapper>(); 
        List<subscriptionDataWrapper> lstSubWrapperActive = new List<subscriptionDataWrapper>();
        List<subscriptionDataWrapper> lstSubWrapperCancelled = new List<subscriptionDataWrapper>();        
        
         lplComBtsLplsiebeladapterserviceOrde.ListLPLContactOrderFulfillmentType LPLContactOrderFulfillment=OrderFullfilmentResponseService.ListLPLContactOrderFulfillment;
                    lplComBtsLplsiebeladapterserviceOrde.ContactType[] Contact=LPLContactOrderFulfillment.Contact;
                    Map<String, subscriptionDataWrapper> subscriptionDataWrapperMap = new Map<String, subscriptionDataWrapper>(); // Reversed for sorting
                    List<String> sortThis = new List<String>();
                    Map<String, subscriptionDataWrapper> subscriptionDataWrapperMap1 = new Map<String, subscriptionDataWrapper>(); // Reversed for sorting
                    List<String> sortThis1 = new List<String>();
                    integer i=0;
                
                        if(Contact != null)                   
                        {                        
                                for(lplComBtsLplsiebeladapterserviceOrde.ContactType c:Contact)
                                { 
                                
                                   if(c.ListOfOrderFulfillment.OrderFulfillment != null)         
                                   { 
                                   
                                       for(lplComBtsLplsiebeladapterserviceOrde.OrderFulfillmentType o:c.ListOfOrderFulfillment.OrderFulfillment)
                                        { 
                                       
                                            subscriptionDataWrapper  SubWrapper = new subscriptionDataWrapper();
                                            
                                                      
                                            if(o.productStatus =='Active')
                                            {
                                                SubWrapper.FulfillmentID  = o.fulfillmentID;
                                                SubWrapper.ProductName= o.productName;
                                                SubWrapper.ProductVersion = o.productVersion;
                                                SubWrapper.ProductStatus = o.productStatus;
                                                SubWrapper.ProductFulfilledby = o.productFulfilledby;
                                                SubWrapper.Notes = o.notes;
                                                SubWrapper.DateActivated = o.dateActivated;
                                                SubWrapper.DateCancelled  = o.dateCancelled;
                                                lstSubWrapperActive.add(SubWrapper); 
                                                subscriptionDataWrapperMap.put(o.productName+o.fulfillmentID,SubWrapper);                          
                                                sortThis.add(o.productName+o.fulfillmentID);
                                                i++;
                                            }
                                            
                                            else
                                            {    
                                                SubWrapper.FulfillmentID  = o.fulfillmentID;
                                                SubWrapper.ProductName= o.productName;
                                                SubWrapper.ProductVersion = o.productVersion;
                                                SubWrapper.ProductStatus = o.productStatus;
                                                SubWrapper.ProductFulfilledby = o.productFulfilledby;
                                                SubWrapper.Notes = o.notes;
                                                SubWrapper.DateActivated = o.dateActivated;
                                                SubWrapper.DateCancelled  = o.dateCancelled;                                     
                                                lstSubWrapperCancelled.add(SubWrapper);                                        
                                                subscriptionDataWrapperMap1.put(o.productName+o.fulfillmentID,SubWrapper);                          
                                                sortThis1.add(o.productName+o.fulfillmentID);
                                                i++;
                                            }
                                            
                                            
                                        
                                        }
                                        i=i+1;
                                        
                                        System.debug('HERE1================================ i'+ i );
                                    
                                    }
                                    
                                  
                                    
                                    
                                    
                                    
                                }
                                
                                  if(i==0){
                                    
                                       System.debug('HERE2================================ i'+ i );
                                    
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Subscription Record is associated with Selected Contact.');
                                        ApexPages.addMessage(myMsg); 
                                    }
                                
                               sortThis.sort();   
                               sortThis1.sort(); 
                               
                               for(String s : sortThis)
                                {
                                       lstSubWrapper.add(subscriptionDataWrapperMap.get(s));
                                       
                                        System.debug('HERE2================================ i'+ i );
                                }   
                                
                                 for(String s : sortThis1)
                                {
                                       lstSubWrapper.add(subscriptionDataWrapperMap1.get(s));
                                       
                                        System.debug('HERE2================================ i'+ i );
                                } 
                                
                         }       
                         else
                         {
                             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Rep Id does not exist in Siebel');
                             ApexPages.addMessage(myMsg);   
                          
                         }        
                          
                  
                 
        
              
        return lstSubWrapper;
    }
    */
    
    
     public class subscriptionDataWrapper
    {
        public subscriptionDataWrapper()
        {            
        }
        
        public String FulfillmentID {get; set;}
        public String ProductName {get; set;}
        public String ProductVersion {get; set;}
        public String ProductStatus {get; set;}
        public String ProductFulfilledby {get; set;}
        public String Notes {get; set;}
        public String DateActivated {get; set;}
        public String DateCancelled  {get; set;}   
                
    }

}