/*
CH -01 This is a one time batch for the new requirement to populate the IRD and Assigned Recruiter fields for the historical Lead data and			Vaibhav Jain		21 Nov 2018
updating the record Owner with the IRD value.

*/

global class LPL_AssignLeadOwnerAsIRD_OneTimeBatch implements Database.Batchable<sObject> {
    
    List<Lead> recordsToUpdate = new List<Lead>();
    Map<String,IAS_Recruiter_Assignment__c> ias_zip_map = new Map<String,IAS_Recruiter_Assignment__c>();    
    Set<String> zipSet = new Set<String>();

    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select id,postalcode,Allow_Lead_Type_Change__c,Internal_Recruiter_IRD__c,OwnerId from Lead'; //Fetch all the Lead records
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc,List<Lead> leadList){
        try{
            for(Lead l:leadList){
                if(l.PostalCode!=null)
                    zipSet.add(l.PostalCode); //set of all the postal codes in Lead records
            }
            List<IAS_Recruiter_Assignment__c> iasList = [select id,name,Internal_Recruiter__c,Assigned_Recruiter__c from IAS_Recruiter_Assignment__c where name in:zipSet];
            for(IAS_Recruiter_Assignment__c ias:iasList){
                if(!ias_zip_map.containsKey(ias.name)){
                    ias_zip_map.put(ias.Name,ias);
                }
            }
            for(Lead l:leadList){
                if((l.PostalCode!=null && ias_zip_map.containsKey(l.PostalCode)) && l.Allow_Lead_Type_Change__c != true){ //value of Postal code is present in IAS 
                    IAS_Recruiter_Assignment__c ias = ias_zip_map.get(l.PostalCode);
                    l.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                    l.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                }
                else if((l.PostalCode==null || !ias_zip_map.containsKey(l.PostalCode)) && l.Allow_Lead_Type_Change__c != true){ //Either postal code field is empty or populated with a value not present in IAS
                    if(Default_Oppty_Owner__c.getInstance() != null){ 
                        if(Default_Oppty_Owner__c.getInstance()!=null) 
                            l.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; 
                        l.Assigned_Recruiter__c=null;
                    }
                    
                }
                if(l.Internal_Recruiter_IRD__c!=null){
                    l.OwnerId = l.Internal_Recruiter_IRD__c;
                }
                recordsToUpdate.add(l);                                        
            }
            update recordsToUpdate;
        }
        catch(Exception e){
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_AssignLeadOwnerAsIRD_OneTimeBatch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    global void finish(Database.BatchableContext bc){}
}