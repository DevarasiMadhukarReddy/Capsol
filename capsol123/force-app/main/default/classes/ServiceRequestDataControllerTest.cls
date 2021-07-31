@isTest(SeeAllData=false) 
private class ServiceRequestDataControllerTest{
    

     static testmethod void testcase1_InvokeServiceRequest() {
        
           Test.setMock(WebServiceMock.class, new ServiceRequestDataWebServiceMockImpl());
            ServiceRequestDataContoller controller = new ServiceRequestDataContoller();           
              
            ApexPages.currentPage().getParameters().put('id', '1234');
          controller.getServiceRequestData();
        
      
    }
    
    static testmethod void testcase2_InvokeServiceRequest() {
        
           Test.setMock(WebServiceMock.class, new ServiceRequestDataWebServiceMockImpl());
            ServiceRequestDataContoller controller = new ServiceRequestDataContoller();   
              
            ApexPages.currentPage().getParameters().put('id', '');
            controller.getServiceRequestData();
        
      
    }
     static testmethod void testcase3_InvokeServiceRequest() {
        
           Test.setMock(WebServiceMock.class, new ServiceRequestDataWebServiceMockImpl());
      
           ServiceRequestDataContoller controller = new ServiceRequestDataContoller();                 
            ApexPages.currentPage().getParameters().put('id', 'ABCD');
           controller.getServiceRequestData();
        
      
    }
   
    
    
}