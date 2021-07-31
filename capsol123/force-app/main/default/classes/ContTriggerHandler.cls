/*
#############################Change History####################
Requirement                                                       Developer Name                   Date

Ch-1   Adding trigger.old into bulkbefore & bulk After                   Sai Kethu                       6 june 2017

Ch-2  Hawaii Contact Requirement:If Channel (Contact) = IAS or IAS/IS 
or IS and 3 digit Zip (Zip3 Assignment) = 967 or 968, 
Update on contact of type LPL Advisor 										Ashish Gupta					 21 March 2018

CH -3  (REQ0022861-RITM0024772-TASK0034324) Removed the logic to  			Garvita Rai		4 January 2019
fetch data for following fields from zip3Assignments :
a. Regional_Advisory_Consultant__c
b. Hybrid_Advisory_Consultant__c
c. Advisory_Territory__c
d. IS_Advisory_Territory__c
e. Internal_Advisory_Consultant__c
f. Internal_Annuity_Consultant__c
*/

public class ContTriggerHandler
{
    
    public void zip3Assignment(list<Contact> cons, list<Contact> oldconList){
        /*  # When first 3 of zip = XXX, and channel = IAS, or IAS & IS  assign the Regional Advisory Consultant, Internal Advisory Consultant, Internal AI Consultant, and Internal Annuity Consultant, and Advisory Territory
§ Assign to all record types but the Contact Prospect record type
# When first 3 of zip = XXX, and channel = IS assign the IS Regional Advisory Consultant, Internal Annuity Consultant, and  Internal AI Consultant, and Advisory Territory
§ Assign to all record types but the Contact Prospect record type
# When first 3 of zip = XXX, assign Advisor Recruit Territory to ONLY the Contact Prospect Record type. 

*/
        String zip3;
        set<string> zips = new set<string>();
        set<string> c_zips = new set<string>();
        set<string> m_zips = new set<string>();
        Map<Id,contact> oldconMap=new Map<Id,contact>(); // CH- 01
        String zip3code;
        ID conProsRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        ID lplAdvisorRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId(); 
        //prepare the lists of zip codes to limit the IAS_Recruiter_Assignment__c records
        for(Contact con : cons){  
            if(oldconList!=null){
                for(Integer i=0;i<oldconList.size();i++){      //ch-1 start
                    oldconMap.put(oldconList[i].id,oldconList[i]);
                }
            }        
            //***********CH-01 : Start ************
            Contact oldcon=oldconMap.get(con.id);
            If(Trigger.isInsert){
                if( ((con.MailingPostalCode != null && con.MailingPostalCode != '' ) && (con.Branch_Channel__c != null && con.Branch_Channel__c != '') && con.MailingPostalCode.length() > 2) && oldcon==NULL)//create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
                {
                    string zipStr = string.Valueof(con.MailingPostalCode);
                    zip3 = zipStr.substring(0,3).trim();
                    zips.add(zip3);
                }
            }
            If(Trigger.isUpdate)
            {
                if( ((con.MailingPostalCode != null && con.MailingPostalCode != '') &&  (con.Branch_Channel__c != null && con.Branch_Channel__c != '')  && con.MailingPostalCode.length() > 2)
                   && (con.MailingPostalCode != oldcon.MailingPostalCode ) ){
                    string zipStr = string.Valueof(con.MailingPostalCode);
                    zip3 = zipStr.substring(0,3).trim();
                    zips.add(zip3);
                }
            }
            //***********CH-01 : Start ************
        }
        
        Map<String,Schema.RecordTypeInfo> conRecordtypes = Contact.sObjectType.getDescribe().getRecordTypeInfosByName();
        map<string, list<Zip3_Assignment__c>> zip_Map = new map<string, list<Zip3_Assignment__c>>();
        //retrieve Zip3_Assignment__c with common name/zip code
        for(Zip3_Assignment__c zip3Assign : [Select Name
                                             , X3_digit_Zip__c
                                             , Advisory_Recruiting_Territory__c                                                    
                                             , Internal_AI_Consultant__c
                                             , Internal_Annuity_Consultant__c
                                             , IS_Regional_Advisory_Consultant__c
                                             , Regional_Advisory_Consultant__r.Username
                                             , Internal_Advisory_Consultant_Zip3__c
                                             , State__c
                                             , Territory__c
                                             , Regional_Advisory_Consultant_Name__c
                                             , IS_Advisory_Territory__c
                                             , Institutional_Recruiting_Territory__c
                                             from Zip3_Assignment__c
                                             where name in :zips ]){
            string zip = zip3Assign.Name;//the actual zip-code use for matching to the opportunity
            
            if(zip_Map.containsKey(zip))//Add to the map or create a new map with a list of IAS_Recruiter_Assignment__c objects
            {
                list<Zip3_Assignment__c> l = zip_Map.get(zip);
                l.add(zip3Assign);
            }
            else
                zip_Map.put(zip, new list<Zip3_Assignment__c>{zip3Assign});
        }
        map<string, string> updatedOpps = new map<string, string>();
        for(Contact con : cons){
            boolean matched = false;
            if( con.MailingPostalCode != null && con.MailingPostalCode != '' && con.MailingPostalCode.length() > 2)
                zip3code = String.Valueof(con.MailingPostalCode).substring(0,3).trim();
            
            //move on if there are no records
            
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
                            }   
                            if(con.RecordTypeId == conProsRecTypeId ){
                                con.Advisor_Recuiting_Territory__c = zip3Assign.Advisory_Recruiting_Territory__c;
                                con.Institutional_Recruiting_Territory__c = zip3Assign.Institutional_Recruiting_Territory__c;
                                con.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                matched = true;
                            }else{
                                if(con.Branch_Channel__c == 'IAS' || con.Branch_Channel__c == 'IAS&IS' ){
                                    con.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                    con.Advisor_Recuiting_Territory__c= zip3Assign.Advisory_Recruiting_Territory__c;
                                    matched = true;
                                    
                                }else if(con.Branch_Channel__c == 'IS' ){
                                    con.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                    con.Advisor_Recuiting_Territory__c= zip3Assign.Advisory_Recruiting_Territory__c;
                                    matched = true;
                                    
                                } 
                            } 
                            //  Ch-2  start
                            String zipcode=zip3Assign.Name;
                            if(Trigger.isInsert && zip3Assign !=null && (zipcode=='967' ||zipcode =='968' ) && con.RecordTypeId == lplAdvisorRecTypeId && (con.Branch_Channel__c == 'IAS' || con.Branch_Channel__c == 'IAS&IS' || con.Branch_Channel__c == 'IS') ){
                                con.Institutional_Recruiting_Territory__c = zip3Assign.Institutional_Recruiting_Territory__c;
                                con.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                con.Advisor_Recuiting_Territory__c= zip3Assign.Advisory_Recruiting_Territory__c;
                                matched = true;                                        
                            }
                            //  Ch-2 END
                        }
                    }
                }
            }
        }
    }
}