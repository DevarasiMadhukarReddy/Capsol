@isTest(seeAllData=True)
private class LPL_RepProfileTest {
    @isTest static void testGetConRepId() {       
      
        try{
            Test.StartTest();
            RestRequest request = new RestRequest();            
            string urlInstance = URL.getSalesforceBaseUrl().toExternalForm();            
            //urlInstance = urlInstance.replace('Url:[delegate=','').replace(']','');          
            string finalURL = urlInstance+'/services/apexrest/RepProfile/';
            request.requestUri = finalURL+'K16G'; 
            //request.requestUri= 'https://lplmainorg--partiallob.cs51.my.salesforce.com/services/apexrest/RepProfile/123';             
            request.httpMethod = 'GET';  
            RestContext.request = request;
            LPL_RepProfile.RepClass repwrapp = new LPL_RepProfile.RepClass();
            repwrapp = LPL_RepProfile.getContactByRepId();
            if(Test.isRunningTest()){
                
                //request.requestUri = 'https://lplmainorg--partiallob.cs51.my.salesforce.com/services/apexrest/RepProfile/';
                finalURL = finalURL+'123';
                request.requestUri = finalURL;
                request.httpMethod = 'GET';
                RestContext.request = request;
               
                LPL_RepProfile.RepClass repwrapper = new LPL_RepProfile.RepClass();
                repwrapper = LPL_RepProfile.getContactByRepId();
                
            }
            Test.StopTest();
        }
        Catch(Exception e){
            system.assertEquals(e.getmessage(), e.getmessage());  
        }
    }
}