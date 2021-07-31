/************************************************************************
* Date : 06/02/2017; 
* naga created for Advisor Self Service project BTS727;
* Get the Home Office Contact details associated to the Master Rep from the end of the URL
* Project code : BTS727 ServiceWorks project
*************************************************************************/
// Create rest resource which is unique for calling from Client Application
@RestResource(urlMapping='/UserProfile/*')
  global class LPL_UserProfile{
    // Expose method as get using @HttpGet to fetch contact details  
    @HttpGet
     global static User getUserInforById() {
        RestRequest request = RestContext.request;     
        User usrRecord = new User();
        try{                  
            string SFDCId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);      
            //Get the details from user object
           usrRecord = [Select Id
            , Name
            , Title
            , Phone
            , MobilePhone
            , Fax
            , Email 
            from User where Id = : SFDCId];                           
           }//end try
            catch(Exception e){  //If Query has nothing to return
                RestContext.response.statusCode = 404;
                usrRecord = null;          
         }         
          return  usrRecord; 
    }
}