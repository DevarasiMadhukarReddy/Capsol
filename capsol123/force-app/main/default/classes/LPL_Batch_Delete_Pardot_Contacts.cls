/*Batch class Name               : LPL_Batch_Delete_Pardot_Contacts 
Description                      : This batch class is getting the Contacts which are coming from Pardot and need to be deleted based on the Delete Contact custom setting.
Created By                       : Utkarsh Topre
Created Date                     : 18-Dec-2017
*/
global class LPL_Batch_Delete_Pardot_Contacts implements Database.Batchable<sObject> {

  ID pardotConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId(); 
  
  Decimal Days = Delete_Contacts__c.getInstance('Add Days').No_of_Days__c;
  
  Date d = (System.Today() - Integer.valueOf(Days));
  
  
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('d>>'+d);
        //Getting qualify Contacts
        String query='Select Id, Pardot_Status__c, RecordTypeId, CreatedDate from Contact where Pardot_Status__c = \'Yes\' AND Pardot_Status__c!=null AND RecordTypeId =: pardotConRecordTypeId AND CreatedDate >=: d';
        
        
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC,List<Contact> conList) {
        
        //List<Contact> delCons = new List<Contact>();
         system.debug('conList.size()>>'+conList.size());    
      try {   
        
        if(conList.size()>0 && conList.size() != null){
        system.debug('Inside conList.size()');
            delete conList;
        }
                    
        }
        
      
      catch(exception e) {
        
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Delete_Pardot_Contacts ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
    }
    global void finish(Database.BatchableContext BC){
        
    }
}