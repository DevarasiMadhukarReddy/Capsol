@isTest(SeeAllData=false) 
private class SubscriptionDataControllerTest{
    
    static testmethod void testcase1_InvokeSubscriptionRequest() {
        
           Test.setMock(WebServiceMock.class, new SubscriptionDataWebServiceMockImpl());
      
          List<SubscriptionDataContoller.subscriptionDataWrapper> lstSubWrapper = new List<SubscriptionDataContoller.subscriptionDataWrapper>(); 
            
            lplComBtsLplsiebeladapterserviceOrde.OrderFulfillmentResponseType  OrderFullfilmentResponseService;
            
            SubscriptionDataContoller controller = new SubscriptionDataContoller();
              
            ApexPages.currentPage().getParameters().put('id', '1234');
           controller.getSubcriotionData();
        
      
    }
    
    static testmethod void testcase2_InvokeSubscriptionRequest() {
        
           Test.setMock(WebServiceMock.class, new SubscriptionDataWebServiceMockImpl());
      
          List<SubscriptionDataContoller.subscriptionDataWrapper> lstSubWrapper = new List<SubscriptionDataContoller.subscriptionDataWrapper>(); 
            
            lplComBtsLplsiebeladapterserviceOrde.OrderFulfillmentResponseType  OrderFullfilmentResponseService;
            
            SubscriptionDataContoller controller = new SubscriptionDataContoller();
              
            ApexPages.currentPage().getParameters().put('id', '');
           controller.getSubcriotionData();
        
      
    }
     static testmethod void testcase3_InvokeSubscriptionRequest() {
        
           Test.setMock(WebServiceMock.class, new SubscriptionDataWebServiceMockImpl());
      
            List<SubscriptionDataContoller.subscriptionDataWrapper> lstSubWrapper = new List<SubscriptionDataContoller.subscriptionDataWrapper>(); 
            
            lplComBtsLplsiebeladapterserviceOrde.OrderFulfillmentResponseType  OrderFullfilmentResponseService;
            
            SubscriptionDataContoller controller = new SubscriptionDataContoller();
              
            ApexPages.currentPage().getParameters().put('id', 'ABCD');
           controller.getSubcriotionData();
        
      
    }
    
       
}