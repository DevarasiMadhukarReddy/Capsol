public class ServiceRequestDataContoller

{

    Public String SRCount{get; set;}
    Public String urlid{get; set;}
    Public String RepName {get; set;}


    Public ServiceRequestDataContoller()
    {
        urlid=apexpages.currentpage().getparameters().get('id');
        
        if(urlid!='' && urlid!= NULL )
        {        
            list<Contact> lst= [SELECT Name FROM Contact WHERE Master_Rep_ID__c = :urlid];
            RepName =lst[0].Name;
        }
        List<serviceRequestWrapper> lstSerWrapper = new List<serviceRequestWrapper>(); 
        
        lstSerWrapper =getServiceRequestData();
        SRCount=string.valueof(lstSerWrapper.size());
        System.debug('SRCount=============================='+SRCount);
    }

    public List<serviceRequestWrapper> getServiceRequestData()
    {
        String urlid=apexpages.currentpage().getparameters().get('id');
        System.debug('urlid =============================='+urlid);
        List<serviceRequestWrapper> lstSerWrapper = new List<serviceRequestWrapper>();        
        List<serviceRequestWrapper> lstSerWrapperEscalated = new List<serviceRequestWrapper>();        
        List<serviceRequestWrapper> lstSerWrapperOpen = new List<serviceRequestWrapper>();        
        List<serviceRequestWrapper> lstSerWrapperCancelled = new List<serviceRequestWrapper>();         
        Map<Integer, serviceRequestWrapper> serviceRequestDataWrapperMap = new Map<Integer, serviceRequestWrapper>(); // Reversed for sorting
        List<Integer> sortThis = new List<Integer>();                
        Map<Integer, serviceRequestWrapper> serviceRequestDataWrapperMap1 = new Map<Integer, serviceRequestWrapper>(); // Reversed for sorting
        List<Integer> sortThis1 = new List<Integer>();          
        Map<Integer, serviceRequestWrapper> serviceRequestDataWrapperMap2 = new Map<Integer, serviceRequestWrapper>(); // Reversed for sorting
        List<Integer> sortThis2 = new List<Integer>();
        
        
        //lplComBtsFrameworkMessageheader2013.RequestHeaderType RequestHeader= new lplComBtsFrameworkMessageheader2013.RequestHeaderType();
        lplComBtsLplsiebeladapterserviceSrre.RequestHeaderType RequestHeader= new lplComBtsLplsiebeladapterserviceSrre.RequestHeaderType();
        
        RequestHeader.organization='SalesForce';
        
        Blob blobKey = crypto.generateAesKey(128);       
        RequestHeader.transactionId=EncodingUtil.convertToHex(blobKey);
        RequestHeader.timeStamp=Datetime.now();
        RequestHeader.SourceSystem='Data Power';
        RequestHeader.hostName='CHLCNU3059RRM';
        
        lplComBtsLplsiebeladapterserviceSrre.SRRequestType SRRequest= new lplComBtsLplsiebeladapterserviceSrre.SRRequestType();
        
        SRRequest.repID=urlid;
        
        System.debug('SRRequest=============================='+SRRequest);
        lplComBtsSiebelcontact.SiebelContactPortTypeEndpoint1 stub = new lplComBtsSiebelcontact.SiebelContactPortTypeEndpoint1();        
        stub.endpoint_x =Label.Tibco_Service_URL;        
        stub.timeout_x=120000;     
        
        System.debug('stub =============================='+stub );
        System.debug('RequestHeader=============================='+RequestHeader);
        
        lplComBtsLplsiebeladapterserviceSrre.SRResponseType SRResponseService;
        
        integer counter =0;
        
        if((urlid != null)&& (urlid != ''))
        {
        
                try
                {
                
                    if((urlid != null)&& (urlid != ''))
                        {
                             SRResponseService = stub.ServiceRequest(RequestHeader,urlid);  
                        }
                        
                        else
                        {
                        
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Master Rep Id is blank');
                                        ApexPages.addMessage(myMsg); 
                        
                        }
                
                
                
                     
                    
                     System.debug('SRResponseService =============================='+SRResponseService );    
                
                   lplComBtsLplsiebeladapterserviceSrre.ContactType[] Contact=SRResponseService.Contact;
                   
                   if(Contact != null)
                   
                   {
                
                        for(lplComBtsLplsiebeladapterserviceSrre.ContactType c:Contact)
                        {  
                         
                           
                           System.debug('Inside First For loop =============================='+ c);
                           
                           
                           if(c.ServiceRequests.ServiceRequest != null)
                           
                           {
                           
                               for(lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType s:c.ServiceRequests.ServiceRequest)
                                { 
                                
                                
                                System.debug('Inside Second For loop =============================='+ c.ServiceRequests.ServiceRequest);
                                
                               
                                    serviceRequestWrapper SerWrapper = new serviceRequestWrapper(); 
                                    
                                    
                                    if(s.Priority=='Escalated' && s.Status != 'Closed' && s.Status != 'cancelled' )
                                    {
                                    
                                        SerWrapper .SRNumber = s.SRNumber ;          
                        
                                        SerWrapper .TaskOriginator = s.TaskOriginator ;
                                        SerWrapper .Area = s.Area ;
                                        SerWrapper .SubArea = s.SubArea ;
                                        SerWrapper .Detail = s.Detail ;
                                        SerWrapper .Description = s.Description ;
                                        SerWrapper .Status = s.Status ;
                                        SerWrapper .CreatedBy = s.CreatedBy ;
                                        SerWrapper .Owner  = s.Owner  ;
                                        SerWrapper .SRCreated= s.SRCreated;
                                        SerWrapper .Owner= s.OwnerFirstName+ ' '+s.OwnerLastName;
                                        //SerWrapper .OwnerLastName= s.OwnerLastName;
                                        SerWrapper .Priority  = s.Priority  ;
                                        SerWrapper .ClosedDate= s.ClosedDate;
                                        
                                        lstSerWrapperEscalated.add(SerWrapper);
                                        
                                       // Integer i = Integer.valueof(s.SRNumber.substring(2,s.SRNumber.length()));
                                        
                                        serviceRequestDataWrapperMap.put(Integer.valueof(s.SRNumber.substring(2,s.SRNumber.length())) ,SerWrapper );                          
                                        sortThis.add(Integer.valueof(s.SRNumber.substring(2,s.SRNumber.length())));
                                        
                                         System.debug('Inside Escalated =============================='+sortThis);
                                         counter ++;
                                    
                                    } 
                                    
                                    else if(s.Priority!='Escalated' && s.Status != 'Closed' && s.Status != 'cancelled')
                                    {                         
                                    
                                        SerWrapper .SRNumber = s.SRNumber ;            
                        
                                        SerWrapper .TaskOriginator = s.TaskOriginator ;
                                        SerWrapper .Area = s.Area ;
                                        SerWrapper .SubArea = s.SubArea ;
                                        SerWrapper .Detail = s.Detail ;
                                        SerWrapper .Description = s.Description ;
                                        SerWrapper .Status = s.Status ;
                                        SerWrapper .CreatedBy = s.CreatedBy ;
                                        SerWrapper .Owner  = s.Owner  ;
                                        SerWrapper .SRCreated= s.SRCreated;
                                        SerWrapper .Owner= s.OwnerFirstName+ ' '+s.OwnerLastName;
                                        //SerWrapper .OwnerLastName= s.OwnerLastName;
                                        SerWrapper .Priority  = s.Priority  ;
                                        SerWrapper .ClosedDate= s.ClosedDate;
                                        
                                        lstSerWrapperOpen.add(SerWrapper);
                                        
                                        serviceRequestDataWrapperMap1.put(Integer.valueof(s.SRNumber.substring(2,s.SRNumber.length())) ,SerWrapper );                          
                                        sortThis1.add(Integer.valueof(s.SRNumber.substring(2,s.SRNumber.length())));
                                        
                                        System.debug('Inside Not Escalated =============================='+sortThis1);
                                        counter ++;
                                    
                                    }
                                    
                                    else if((s.Status == 'Closed' || s.Status == 'cancelled')&&(setStringToDateFormat(s.ClosedDate) >= Date.Today().AddDays(-14) )){
                                        SerWrapper .SRNumber = s.SRNumber ;  
                                        SerWrapper .TaskOriginator = s.TaskOriginator ;
                                        SerWrapper .Area = s.Area ;
                                        SerWrapper .SubArea = s.SubArea ;
                                        SerWrapper .Detail = s.Detail ;
                                        SerWrapper .Description = s.Description ;
                                        SerWrapper .Status = s.Status ;
                                        SerWrapper .CreatedBy = s.CreatedBy ;
                                        SerWrapper .Owner  = s.Owner  ;
                                        SerWrapper .SRCreated= s.SRCreated;
                                        SerWrapper .Owner= s.OwnerFirstName+ ' '+s.OwnerLastName;
                                        //SerWrapper .OwnerLastName= s.OwnerLastName;
                                        SerWrapper .Priority  = s.Priority  ;
                                        SerWrapper .ClosedDate= s.ClosedDate;                                    
                                        lstSerWrapperCancelled.add(SerWrapper);                                    
                                        serviceRequestDataWrapperMap2.put(Integer.valueof(s.SRNumber.substring(2,s.SRNumber.length())) ,SerWrapper );                          
                                        sortThis2.add(Integer.valueof(s.SRNumber.substring(2,s.SRNumber.length())));
                                        
                                         System.debug('Inside Closed =============================='+sortThis2);
                                         counter ++;
                                        
                                    }          
                                
                                }
                                
                           /**     
                               sortThis.sort();   
                               sortThis1.sort(); 
                               sortThis2.sort();
                               
                               
                               
                               
                               List<Integer> finalList = new List<Integer>();
                                for(Integer i = sortThis.size()-1; i>=0;i--)
                                {
                                    finalList.add(sortThis.get(i));
                                }
                                
                                List<Integer> finalList1 = new List<Integer>();
                                for(Integer i = sortThis1.size()-1; i>=0;i--)
                                {
                                    finalList1.add(sortThis1.get(i));
                                }
                                
                                List<Integer> finalList2 = new List<Integer>();
                                for(Integer i = sortThis2.size()-1; i>=0;i--)
                                {
                                    finalList2.add(sortThis2.get(i));
                                }
                               
                               System.debug('finalList     List =============================='+ finalList);
                               System.debug('finalList1     List =============================='+ finalList1);
                               System.debug('finalList2      List =============================='+ finalList2);
                               
                               
                               for(Integer s : finalList)
                                {
                                       lstSerWrapper.add(serviceRequestDataWrapperMap.get(s));
                                }   
                                
                                 for(Integer s : finalList1)
                                {
                                       lstSerWrapper.add(serviceRequestDataWrapperMap1.get(s));
                                }    
                                
                                 for(Integer s : finalList2)
                                {
                                       lstSerWrapper.add(serviceRequestDataWrapperMap2.get(s));
                                } 
                                
                                
                                
                                 System.debug('lstSerWrapper  List =============================='+ lstSerWrapper);
                                counter ++;
                                
                                ApexPages.getMessages().clear(); */
                            
                            }
                             
                            
                
                        }
                        
                        /**  New Addition Starts */
                          sortThis.sort();   
                               sortThis1.sort(); 
                               sortThis2.sort();
                               
                               
                               
                               
                               List<Integer> finalList = new List<Integer>();
                                for(Integer i = sortThis.size()-1; i>=0;i--)
                                {
                                    finalList.add(sortThis.get(i));
                                }
                                
                                List<Integer> finalList1 = new List<Integer>();
                                for(Integer i = sortThis1.size()-1; i>=0;i--)
                                {
                                    finalList1.add(sortThis1.get(i));
                                }
                                
                                List<Integer> finalList2 = new List<Integer>();
                                for(Integer i = sortThis2.size()-1; i>=0;i--)
                                {
                                    finalList2.add(sortThis2.get(i));
                                }
                               
                               System.debug('finalList     List =============================='+ finalList);
                               System.debug('finalList1     List =============================='+ finalList1);
                               System.debug('finalList2      List =============================='+ finalList2);
                               
                               
                               for(Integer s : finalList)
                                {
                                       lstSerWrapper.add(serviceRequestDataWrapperMap.get(s));
                                }   
                                
                                 for(Integer s : finalList1)
                                {
                                       lstSerWrapper.add(serviceRequestDataWrapperMap1.get(s));
                                }    
                                
                                 for(Integer s : finalList2)
                                {
                                       lstSerWrapper.add(serviceRequestDataWrapperMap2.get(s));
                                } 
                                
                                
                                
                                 System.debug('lstSerWrapper  List =============================='+ lstSerWrapper);
                                
                                
                                ApexPages.getMessages().clear();
                                
                                
                                /**  New Addition Ends */
                        
                        if(counter==0)
                            {    
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Service Request Record is associated with Selected Contact.');
                                ApexPages.addMessage(myMsg);            
                            
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
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Service is not available,Please try again later'+ e);
                        ApexPages.addMessage(myMsg);
                }
            }
            else
            {                
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Master Rep Id is blank');
                    ApexPages.addMessage(myMsg); 
            
            }
               
               System.debug('Return lstSerWrapper  List =============================='+ lstSerWrapper + lstSerWrapper.size() );
               
               
                
                return lstSerWrapper ;
                
                 
        
            }
        
              public class serviceRequestWrapper
            {
                     
                public serviceRequestWrapper()
                {            
                }
                
                public String SRNumber{get; set;}
                public String TaskOriginator {get; set;}
                public String Area {get; set;}
                public String SubArea {get; set;}
                public String Detail {get; set;}
                public String Description {get; set;}
                public String Status {get; set;}
                public String CreatedBy {get; set;}
               // public String Owner  {get; set;}  
                public String SRCreated{get; set;}
                public String Owner{get; set;}
                //public String OwnerLastName{get; set;} 
                
                public String Priority {get; set;}
                public String ClosedDate{get; set;}
                 
                        
            }
            
            
            private Date setStringToDateFormat(String myDate) {
                   String[] myDateOnly = myDate.split(' ');
                   String[] strDate = myDateOnly[0].split('-');
                   Integer myIntDate = integer.valueOf(strDate[2].substringBefore('T'));
                   Integer myIntMonth = integer.valueOf(strDate[1]);
                   Integer myIntYear = integer.valueOf(strDate[0]);
                   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                   return d;
            }
            
             private list<serviceRequestWrapper> getListInReverseOrder(list<serviceRequestWrapper> s) {
             
                    List<serviceRequestWrapper> lstReverse = new List<serviceRequestWrapper>();      
                
                    for (Integer i=s.size();i>0;i--) {
                        lstReverse.add(s[i-1]);                         
                    }            
                   
                  return lstReverse ; 
            }
            
            
            private list<serviceRequestWrapper> getSortedListOnSRNo(list<serviceRequestWrapper> s) { 
             
                    List<serviceRequestWrapper> lstReverse = new List<serviceRequestWrapper>(); 
                    return lstReverse ; 
            }
            
            
}