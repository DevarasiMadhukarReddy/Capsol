/*

Batch class Name              : LPL_Batch_zip3Assignment_Contacts 

Description                   : # When first 3 of zip = XXX, and channel = IAS, or IAS & IS  assign the Regional Advisory Consultant, Internal Advisory Consultant, Internal AI Consultant, and Internal Annuity Consultant, and Advisory Territory
§ Assign to all record types but the Contact Prospect record type
# When first 3 of zip = XXX, and channel = IS assign the IS Regional Advisory Consultant, Internal Annuity Consultant, and  Internal AI Consultant, and Advisory Territory
§ Assign to all record types but the Contact Prospect record type
# When first 3 of zip = XXX, assign Advisor Recruit Territory to ONLY the Contact Prospect Record type. 

Created By                    : Utkarsh Topre
Created Date                  : 08-Jan-2018

#############################Change History####################
CH No.      Requirement                                                       Developer Name                   Date

Ch-1 Hawaii Contact Requirement:If Channel (Contact) = IAS or IAS/IS 
or IS and 3 digit Zip (Zip3 Assignment) = 967 or 968, 
insert contact of type LPL Advisor                                      Ashish Gupta                     21 March 2018

CH -2 (REQ0022861-RITM0024772-TASK0034324)  			Garvita Rai		4 January 2019
Removed the logic to fetch data for following fields from zip3Assignments :
a. Regional_Advisory_Consultant__c
b. Hybrid_Advisory_Consultant__c
c. Advisory_Territory__c
d. IS_Advisory_Territory__c
e. Internal_Advisory_Consultant__c
f. Internal_Annuity_Consultant__c
*/

global class LPL_Batch_zip3Assignment_Contacts implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        ID conProsRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID lplAdvisorRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        
        //Getting qualifying Contacts
        String query='Select Id, MailingPostalCode, Branch_Channel__c, Regional_Advisory_Consultant__c,  Hybrid_Advisory_Consultant__c , Internal_Annuity_Consultant__c, Internal_AI_Consultant__c, Advisor_Recuiting_Territory__c, Institutional_Recruiting_Territory__c , IS_Advisory_Territory__c , Advisory_Territory__c, RecordTypeId, CreatedDate from Contact where (RecordTypeId =: conProsRecTypeId OR RecordTypeId =: lplAdvisorRecTypeId)';  
        return Database.getQueryLocator(query);
    }
	
    global void execute(Database.BatchableContext BC,List<Contact> conList) {
        String zip3;
        set<string> zips = new set<string>();
        String zip3code;
        map<string, list<Zip3_Assignment__c>> zip_Map = new map<string, list<Zip3_Assignment__c>>();
        map<Id, Contact> con_Map = new map<Id, Contact>();  
        
        ID conProsRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID lplAdvisorRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        
        try {   
            for(Contact con: conList){
                //create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
                if( ((con.MailingPostalCode != null && con.MailingPostalCode != '' ) && (con.Branch_Channel__c != null && 
				con.Branch_Channel__c != '') && con.MailingPostalCode.length() > 2)){
                    string zipStr = string.Valueof(con.MailingPostalCode);
                    zip3 = zipStr.substring(0,3).trim();
                    zips.add(zip3);
                }
            }
            
            //retrieve Zip3_Assignment__c with common name/zip code
            for(Zip3_Assignment__c zip3Assign : [Select Name
                                                 , X3_digit_Zip__c
                                                 , Advisory_Recruiting_Territory__c
                                                 , Internal_Advisory_Consultant_Zip3__c // added by amit
                                                 , Internal_AI_Consultant__c
                                                 , Internal_Annuity_Consultant__c
                                                 , IS_Regional_Advisory_Consultant__c
                                                 , Regional_Advisory_Consultant__r.Username
                                                 , State__c
                                                 , Territory__c
                                                 , Regional_Advisory_Consultant_Name__c
                                                 , IS_Advisory_Territory__c
                                                 , Institutional_Recruiting_Territory__c
                                                 from Zip3_Assignment__c
                                                 where name in :zips ]){
                //the actual zip-code use for matching to the opportunity
                string zip = zip3Assign.Name;
                
                //Add to the map or create a new map with a list of IAS_Recruiter_Assignment__c objects
                if(zip_Map.containsKey(zip)){
                    list<Zip3_Assignment__c> l = zip_Map.get(zip);
                    l.add(zip3Assign);
                }
                else
                    zip_Map.put(zip, new list<Zip3_Assignment__c>{zip3Assign});
            }
            
            for(Contact con : conList){
                boolean matched = false;
                if( con.MailingPostalCode != null && con.MailingPostalCode != '' && con.MailingPostalCode.length() > 2)
                    zip3code = String.Valueof(con.MailingPostalCode).substring(0,3).trim();
                
                //get the ZIP3 Recruiter records to compare
                if(con.MailingPostalCode != Null && con.MailingPostalCode != '' && con.MailingPostalCode.length() > 2){
                    if(zip_Map.containskey(zip3code.trim())){
                        list<Zip3_Assignment__c> zip3List = zip_Map.get(zip3code.trim());
                        //iterate over the IAS Recruiter records matching the oppty zip code to find a match
                        if(zip3List.size()>0){
                            for(Zip3_Assignment__c zip3Assign : zip3List){
                                if(con.RecordTypeId == lplAdvisorRecTypeId ){ 
                                    con.Institutional_Recruiting_Territory__c = zip3Assign.Institutional_Recruiting_Territory__c;
                                    matched = true;
                                    con_Map.put(con.Id, con);
                                }   
                                if(con.RecordTypeId == conProsRecTypeId ){ 
                                    con.Advisor_Recuiting_Territory__c = zip3Assign.Advisory_Recruiting_Territory__c;
                                    con.Institutional_Recruiting_Territory__c = zip3Assign.Institutional_Recruiting_Territory__c;
                                    con.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                    matched = true;
                                    con_Map.put(con.Id, con);
                                }else{
                                    if(con.Branch_Channel__c == 'IAS' || con.Branch_Channel__c == 'IAS&IS' ){
                                        con.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                        con.Advisor_Recuiting_Territory__c= zip3Assign.Advisory_Recruiting_Territory__c;
                                        matched = true;
                                        con_Map.put(con.Id, con);
                                    }else if(con.Branch_Channel__c == 'IS' ){
                                        con.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                        con.Advisor_Recuiting_Territory__c= zip3Assign.Advisory_Recruiting_Territory__c;
                                        matched = true;
                                        con_Map.put(con.Id, con);
                                    } 
                                } 
                                // Ch-01 start              
                                String zipcode=zip3Assign.Name;
                                if(zip3Assign.ID !=null && (zipcode=='967' ||zipcode =='968' ) && con.RecordTypeId == lplAdvisorRecTypeId && (con.Branch_Channel__c == 'IAS' || con.Branch_Channel__c == 'IAS&IS' || con.Branch_Channel__c == 'IS') ){
                                    con.Institutional_Recruiting_Territory__c = zip3Assign.Institutional_Recruiting_Territory__c;
                                    con.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                    con.Advisor_Recuiting_Territory__c= zip3Assign.Advisory_Recruiting_Territory__c;
                                    matched = true;
                                    con_Map.put(con.Id, con);
                                }
                                // Ch-01 END 
                            }
                        }
                    }
                }
            }
            
            if(con_Map.size()>0){
                update con_Map.values();
            }
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_zip3Assignment_Contacts','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
    }
    global void finish(Database.BatchableContext BC){ }
    
}