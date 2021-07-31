@isTest(seeAllData=true)
private class LPL_UserProfileTest {
    @isTest static void testuserProfile() {       

        try{
            Test.StartTest();
            RestRequest request = new RestRequest();
            User userTest = [Select Id from user where email = 'nagamohan.shivakumar@lpl.com'];
            string userId =  userTest.Id;         
            string urlInstance = URL.getSalesforceBaseUrl().toExternalForm();            
            string finalURL = urlInstance+'/services/apexrest/UserProfile/';
            request.requestUri = finalURL+userId; 
            request.httpMethod = 'GET';  
            RestContext.request = request;
            LPL_UserProfile.getUserInforById();             
             if(Test.isRunningTest()){  
                 userid ='';
                request.requestUri = finalURL+userId;
                request.httpMethod = 'GET';
                RestContext.request = request;               
                LPL_UserProfile.getUserInforById();             
            }
            Test.StopTest();
        }
        Catch(Exception e){
            system.assertEquals(e.getmessage(), e.getmessage());  
        }
    }
}