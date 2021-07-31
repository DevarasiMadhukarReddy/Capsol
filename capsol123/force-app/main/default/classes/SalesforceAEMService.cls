/**
 * SalesforceAEMService.cls
 * Description  : This is webservice for AEM to provide salesforce contact presense in salesforce to AEM. 
 * 
 * @Author      : Subhash Ghorpade(Cognizant)
 * @version     : 1.0
 * @CreatedDate : April 30,2015
 */


global class SalesforceAEMService { 
   

   webservice static string checkSalesforceContactValidity(String email) {
   
         String status;
   
      /**
        if((repId !='' && repId != null))
         {   
            try
            
                {   
                    List<Contact> contactList= [Select  Id                    
                    From contact where Master_Rep_ID__c = :repId ];
                    
                    if(contactList.size()>0) 
                    status='True';
                }
                catch(Exception e)            
                {
                
                 status='ERROR'; 
                                
                } 
         }
         else */
         
         if((email !='' && email != null))
         {
         
                try
            
                {   
                    List<Contact> contactList1= [Select  Id                    
                    From contact where email = :email];
                    
                     if(contactList1.size()>0) 
                     status='True';
                }
                
               catch(Exception e)            
                {
                
                 status='ERROR'; 
                                
                } 
         }
         else
         {
         
            status = 'False';
             
         }
         
         return status ;
      
  }
  
  /**
   webservice static string checkSalesforceUserValidity(String email) {
   
         String status;
   
      
        if((email !='' && email != null))
         {   
            try
            
                {   
                    List<User> userList= [Select  Id                    
                    From User where email= :email];
                    
                    if(userList.size()>0) 
                    status='True';
                }
                catch(Exception e)            
                {
                
                 status='ERROR'; 
                                
                } 
         }
        
         else
         {
         
            status = 'False';
             
         }
         
         return status ;
      
  }
  
  
  */
  
  
  
  
}