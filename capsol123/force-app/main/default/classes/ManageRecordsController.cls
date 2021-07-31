public with sharing class ManageRecordsController {  
   @AuraEnabled(cacheable=true)  
   public static List<Contact> getLookupSerachRecords(String searchString, String selectedSObject, Integer recordLimit) {  
     if(searchString != null && searchString != ''){  
       String query = 'select Name, Id from ' + selectedSObject;  
         query += ' where Name like \'%'+ searchString +'%\' ';  
       query+= ' limit ' + recordLimit;  
       return Database.query(query);  
     }  
     return null;  
   }  
 }