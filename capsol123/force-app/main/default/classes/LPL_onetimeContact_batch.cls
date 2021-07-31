/*
Class Name              :LPL_onetimeContact_batch
Description             :Test Class for LPL_onetimeContact_batch_Test

Developer Name          :Manila


##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01       Update contact's Internal Recuiter field from IRA object       Ashish Gupta    29/9/2018
when maillingpostal code and discovery home zip match

CH-02       Populate Default IRD value in case of invalid Discovery Home Zip or Mailing Postal Code         vaibhav Jain        22 Nov 2018
*/
global class LPL_onetimeContact_batch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query='Select ID,LastName,Internal_Recruiter_IRD__c,Assigned_Recruiter__c,Regional_VP__c,Allow_Lead_Type_Change__c,MailingStreet, MailingCity, MailingState, MailingPostalCode, Discovery_Home_Zip__c from Contact where ((RecordType.Name=\'Contact Prospect\' OR RecordType.Name=\'Pardot Prospect\'))';
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Contact> conUpdateList) 
    {
        Map<String, IAS_Recruiter_Assignment__c> ias_zip_Map = new Map<String, IAS_Recruiter_Assignment__c>();
        List<Contact> Conlist = new List<Contact>();
        set<string> zips = new set<string>(); 
        set<Contact> ConSet = new set<Contact>();
        
        for(contact con: conUpdateList){
            if(con.Discovery_Home_Zip__c !=null){
                zips.add(con.Discovery_Home_Zip__c );
                
            }
            else if(con.MailingPostalCode !=null){
                
                zips.add(con.MailingPostalCode);
            }
        }    
        
        for(IAS_Recruiter_Assignment__c ias :  [Select Name, Assigned_Recruiter__c, Internal_Recruiter__c, Regional_VP__c, 
                                                Lead_Type__c from IAS_Recruiter_Assignment__c
                                                where name in :zips] ){ 
                                                    string zip = ias.Name;
                                                    if(!ias_zip_Map.containsKey(zip))
                                                        ias_zip_Map.put(zip,ias);
                                                }
        for(contact con: conUpdateList){
            if(con.Discovery_Home_Zip__c != Null && con.Allow_Lead_Type_Change__c != true){ 
                if(ias_zip_Map.containskey(con.Discovery_Home_Zip__c.trim())){
                    IAS_Recruiter_Assignment__c iasDisHome = ias_zip_Map.get(con.Discovery_Home_Zip__c);
                    if(iasDisHome !=null){
                        con.Assigned_Recruiter__c = iasDisHome.Assigned_Recruiter__c;
                        con.Internal_Recruiter_IRD__c = iasDisHome.Internal_Recruiter__c;
                        con.Regional_VP__c = iasDisHome.Regional_VP__c;
                    }
                }
                //CH-02 -start
                else{
                    if(!ias_zip_Map.containskey(con.Discovery_Home_Zip__c.trim()) && con.Allow_Lead_Type_Change__c != true){
                        if(Default_Oppty_Owner__c.getInstance() != null) 
                            con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; 
                        con.Assigned_Recruiter__c=null;
                        con.Regional_VP__c=null;  
                    }
                }
                //CH-02 - end
            }
            else if(con.Discovery_Home_Zip__c== null && con.MailingPostalCode==null ){ // CH-01  
                if(Default_Oppty_Owner__c.getInstance() != null){
                    con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c;
                }
                con.Assigned_Recruiter__c=null;
                con.Regional_VP__c=null;
            }
            // CH-01  start
            else if(con.Discovery_Home_Zip__c== null && con.MailingPostalCode!=null ) {
                if(ias_zip_Map.containsKey(con.MailingPostalCode.trim())){
                    IAS_Recruiter_Assignment__c iasMailingPostalRec = ias_zip_Map.get(con.MailingPostalCode);
                    if(iasMailingPostalRec!=null){
                        con.Assigned_Recruiter__c = iasMailingPostalRec.Assigned_Recruiter__c;
                        con.Internal_Recruiter_IRD__c = iasMailingPostalRec.Internal_Recruiter__c;
                        con.Regional_VP__c = iasMailingPostalRec.Regional_VP__c;
                    }
                }
                //CH-02 - start
                else{
                    if(!ias_zip_Map.containskey(con.MailingPostalCode.trim()) && con.Allow_Lead_Type_Change__c != true){
                        if(Default_Oppty_Owner__c.getInstance() != null) 
                            con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
                        con.Assigned_Recruiter__c=null;
                        con.Regional_VP__c=null;  
                    }
                }
                //CH-02 - end
            }
            // CH-01 End
            if(con.Internal_Recruiter_IRD__c!=null){
                con.OwnerId = con.Internal_Recruiter_IRD__c;
            }
            ConSet.add(con);
        }
        if(conSet.size() > 0)
            Conlist.addAll(conSet);
        database.update(Conlist, false);
    }
    
    global void finish(Database.BatchableContext BC){
    }
}