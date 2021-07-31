global class ServiceRequestDataWebServiceMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         
        lplComBtsLplsiebeladapterserviceSrre.SRResponseType SRRequest= new lplComBtsLplsiebeladapterserviceSrre.SRResponseType();        
        
        lplComBtsLplsiebeladapterserviceSrre.ResponseHeaderType ResponseHeaderType= new lplComBtsLplsiebeladapterserviceSrre.ResponseHeaderType();
        
        ResponseHeaderType.transactionId='test';
        ResponseHeaderType.timeStamp=System.now();            
        ResponseHeaderType.success='true';  
        
        SRRequest.responseMessageHeader = ResponseHeaderType;
        lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType ServiceRequestType= new lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType();
        
        ServiceRequestType.TaskOriginator='12345';
        ServiceRequestType.Area='Test Product Name';
        ServiceRequestType.SubArea='test Product Version';
        ServiceRequestType.Detail='Active';
        ServiceRequestType.Description='test Subhash';
        ServiceRequestType.Status='Open';
        ServiceRequestType.CreatedBy='2015-07-27T09:38:59.816-07:00';
        ServiceRequestType.Owner='2015-07-27T09:38:59.816-07:00';        
        ServiceRequestType.SRNumber='123456';
        ServiceRequestType.SRCreated='Active';
        ServiceRequestType.OwnerFirstName='test Subhash';
        ServiceRequestType.OwnerLastName='test Notes';
        ServiceRequestType.Closeddate='';
        ServiceRequestType.Priority='Escalated'; 
        
        lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType ServiceRequestType1= new lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType();  
        
        ServiceRequestType1.TaskOriginator='23456';
        ServiceRequestType1.Area='Test Product Name';
        ServiceRequestType1.SubArea='test Product Version';
        ServiceRequestType1.Detail='Active';
        ServiceRequestType1.Description='test Subhash';
        ServiceRequestType1.Status='Open';
        ServiceRequestType1.CreatedBy='2015-07-27T09:38:59.816-07:00';
        ServiceRequestType1.Owner='2015-07-27T09:38:59.816-07:00';        
        ServiceRequestType1.SRNumber='2343456';
        ServiceRequestType1.SRCreated='Active';
        ServiceRequestType1.OwnerFirstName='test Subhash';
        ServiceRequestType1.OwnerLastName='test Notes';
        ServiceRequestType1.Closeddate='';
        ServiceRequestType1.Priority='Standard';
        
        lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType ServiceRequestType2= new lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType();  
        
        ServiceRequestType2.TaskOriginator='34567';
        ServiceRequestType2.Area='Test Product Name';
        ServiceRequestType2.SubArea='test Product Version';
        ServiceRequestType2.Detail='Active';
        ServiceRequestType2.Description='test Subhash';
        ServiceRequestType2.Status='Closed';
        ServiceRequestType2.CreatedBy='2015-07-27T09:38:59.816-07:00';
        ServiceRequestType2.Owner='2015-07-27T09:38:59.816-07:00';        
        ServiceRequestType2.SRNumber='2223356';
        ServiceRequestType2.SRCreated='Active';
        ServiceRequestType2.OwnerFirstName='test Subhash';
        ServiceRequestType2.OwnerLastName='test Notes';
        ServiceRequestType2.Closeddate='2015-07-27T09:38:59.816-07:00';
        ServiceRequestType2.Priority='Standard';
        
        lplComBtsLplsiebeladapterserviceSrre.ServiceRequestsType ServiceRequestsType =new lplComBtsLplsiebeladapterserviceSrre.ServiceRequestsType();
        
        list<lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType> lst= new list<lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType >();
        
        lst.add(ServiceRequestType);
        lst.add(ServiceRequestType1);
        lst.add(ServiceRequestType2);
        
        ServiceRequestsType.ServiceRequest=lst;
        
        lplComBtsLplsiebeladapterserviceSrre.ContactType  ContactType= new lplComBtsLplsiebeladapterserviceSrre.ContactType();
        
        ContactType.ServiceRequests=ServiceRequestsType;
        
        list<lplComBtsLplsiebeladapterserviceSrre.ContactType> lst1= new list<lplComBtsLplsiebeladapterserviceSrre.ContactType >();
        
        lst1.add(ContactType);
        
        SRRequest.Contact = lst1;
        
        response.put('response_x', SRRequest); 
   }
}