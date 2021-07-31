/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
CH-01           Source Type Update on Contact                                       Manila Agnihotri                    12 March 2018
Ch-02           Source type modified                                                Manila Agnihotri                    9 June 2018 
*/

global class LPL_SourcetypeUpdate_batch implements Database.Batchable<sObject>{
    
    List<Contact> fetchMACreateDate = new List<Contact>();  
    List<Contact> con = new List<contact>();
    Set<ID> conIds = new Set<ID>();
    //Ch-02 - start
     Set<Id> MainContacts = new Set<Id>();
    global LPL_SourcetypeUpdate_batch(Set<Id> listMaincontacts)
    {
        MainContacts = listMaincontacts;
    }
    //Ch-02 - end
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String allRecordTobBeProcessed= Label.LeadSourceAndType;
        if(allRecordTobBeProcessed == 'true') {
            String query='Select ID,FirstName, IsReferral__c,Referral_Override__c,LastName, LeadSource,Lead_source__c,Marketing_Category__c from Contact where (RecordType.Name=\'Contact Prospect\') AND ID in:MainContacts'; // //Ch-02 
            return database.getQueryLocator(query);  
        }
        else{
            String query='Select ID,FirstName, IsReferral__c,Referral_Override__c,LastName, LeadSource,Lead_source__c,Marketing_Category__c from Contact where (RecordType.Name=\'Contact Prospect\') AND ID in:MainContacts'; // //Ch-02
            return database.getQueryLocator(query);  
        }
        
    }
    global void execute(Database.BatchableContext BC,List<Contact> conUpdateList){
        
        for(Contact con : conUpdateList){
            conIds.add(con.Id);
        }
        
        fetchMACreateDate = [Select Id, Source_Type_Prospect__c,Lead_Source__c,Dynamic_Channel__c, IsReferral__c,Referral_Override__c, Marketing_Category__c, (Select Id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,WhoId from Tasks WHERE Status = 'Completed' and (Department__c='Business Development' and ((Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting' OR Activity_Type__c='BDA Touch') and ( Category__c!='Left Message – Prospecting' and  Category__c!='Mailed information' and  Category__c!='Email – Prospecting' and  Category__c!='Referral to Branch' and  Category__c!='Referral to Core' and  Category__c!='Referral to IS' and  Category__c!='Referral to Masters' and Category__c!='Other'))) ORDER BY CreatedDate DESC limit 1),(Select Id, Placement_ID__c,Name, ELOQUA__Activity_Type__c, CreatedDate, ELOQUA__Contact__c from R00N30000000rPtwEAE__r  where (Name LIKE '%Marketing Campaign Response%' OR Name LIKE '%BD_DisruptionEM%' OR Name LIKE '%BD_DripEM%' OR Name LIKE '%BD_Agile%') AND ELOQUA__Activity_Type__c!='Email Sent' ORDER BY CreatedDate DESC limit 1 ) from Contact where ID in:conIds];
        
        /*------------------- Source type ----------------------*/
        for(Contact consource: fetchMACreateDate)
        {   
            if(consource.Lead_Source__c=='Marketing Initiated'){
                if(consource.ELOQUA__R00N30000000rPtwEAE__r.size()>0)
                {
                    for(ELOQUA__Marketing_Activity__c Eqa: consource.ELOQUA__R00N30000000rPtwEAE__r) {
                        String Name= eqa.Name;
                        if(String.isBlank(eqa.Placement_ID__c)){
                            if(Name.contains('BD_')){
                                consource.Source_Type_Prospect__c='Organic Email';
                            }
                        }
                        else if(eqa.Placement_ID__c.substring(2,4) == 'BN' ) {
                            consource.Source_Type_Prospect__c='Banner';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4)=='DM'){
                            consource.Source_Type_Prospect__c='Direct Mail';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4)=='EM'){
                            consource.Source_Type_Prospect__c='Inorganic Email';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4) =='GL'){
                            consource.Source_Type_Prospect__c='Guaranteed Lead';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4)=='GR'){
                            consource.Source_Type_Prospect__c='Guaranteed Response';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4)=='PC'){
                            consource.Source_Type_Prospect__c='Pay Per Click';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4)=='SM'){
                            consource.Source_Type_Prospect__c='Social Media';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4)=='WB'){
                            consource.Source_Type_Prospect__c='Web';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4)=='WL'){
                            consource.Source_Type_Prospect__c='WhitePaper Listing';
                        }
                        else if(eqa.Placement_ID__c.substring(2,4)=='WN'){
                            consource.Source_Type_Prospect__c='Webinar';
                        }
                        else if(String.isBlank(eqa.Placement_ID__c)){
                            consource.Source_Type_Prospect__c='';
                        }
                    }
                }
                else if(consource.ELOQUA__R00N30000000rPtwEAE__r.size() == 0)
                { 
                    string channel= consource.Pardot_Marketing_Channel__c;
                    if(consource.Dynamic_Channel__c==''){
                        if(channel.startsWithIgnoreCase('BD_')){
                            consource.Source_Type_Prospect__c='Organic Email';
                        }
                    }
                    else if(consource.Dynamic_Channel__c=='BN') {
                        consource.Source_Type_Prospect__c='Banner';
                    }
                    else if(consource.Dynamic_Channel__c=='DM'){
                        consource.Source_Type_Prospect__c='Direct Mail';
                    }
                    else if(consource.Dynamic_Channel__c=='EM'){
                        consource.Source_Type_Prospect__c='Inorganic Email';
                    }
                    else if(consource.Dynamic_Channel__c=='GL'){
                        consource.Source_Type_Prospect__c='Guaranteed Lead';
                    }
                    else if(consource.Dynamic_Channel__c=='GR'){
                        consource.Source_Type_Prospect__c='Guaranteed Response';
                    }
                    else if(consource.Dynamic_Channel__c=='PC'){
                        consource.Source_Type_Prospect__c='Pay Per Click';
                    }
                    else if(consource.Dynamic_Channel__c=='SM'){
                        consource.Source_Type_Prospect__c='Social Media';
                    }
                    else if(consource.Dynamic_Channel__c=='WB'){
                        consource.Source_Type_Prospect__c='Web';
                    }
                    else if(consource.Dynamic_Channel__c=='WL'){
                        consource.Source_Type_Prospect__c='WhitePaper Listing';
                    }
                    else if(consource.Dynamic_Channel__c=='WN'){
                        consource.Source_Type_Prospect__c='Webinar';
                    }
                    else if(consource.Dynamic_Channel__c==''){
                        consource.Source_Type_Prospect__c='';
                    }
                }
            }
            else if(consource.Lead_Source__c=='Recruiter Initiated') 
            {
                for(Task task: consource.tasks)
                {
                    if(task.Department__c=='Business Development')
                    { 
                        if(!String.isBlank(task.Activity_Type__c) && !String.isBlank(task.Category__c) )
                        {
                            if(task.Activity_Type__c=='IRD Touch')
                            {
                                if(task.Category__c=='BAQ'){
                                    consource.Source_Type_Prospect__c='IRD BAQ';
                                }
                                else if(task.Category__c=='Call-Inbound'){
                                    consource.Source_Type_Prospect__c='IRD Inbound Call';
                                }
                                else if(task.Category__c=='Call-Outbound'){
                                    consource.Source_Type_Prospect__c='IRD outbound Call';
                                }
                                else if(task.Category__c=='Call – Outbound Prospecting'){
                                    consource.Source_Type_Prospect__c='IRD Outbound Call';
                                }
                                else if(task.Category__c=='HOV Host'){
                                    consource.Source_Type_Prospect__c='IRD HOV';
                                }
                                else if(task.Category__c=='IRD Meeting Complete'){
                                    consource.Source_Type_Prospect__c='IRD outbound Call';
                                }
                                else if(task.Category__c=='IRD Meeting Set'){
                                    consource.Source_Type_Prospect__c='IRD outbound Call';
                                }
                                else if(task.Category__c=='IRD Meeting Set– Existing Recruit'){
                                    consource.Source_Type_Prospect__c='IRD outbound Call';
                                }
                                else if(task.Category__c=='IRD Meeting Set – New Recruit'){
                                    consource.Source_Type_Prospect__c='IRD outbound Call';
                                }
                                else if(task.Category__c=='Social Media Outreach'){
                                    consource.Source_Type_Prospect__c='IRD Digital OutReach';
                                }
                            }
                            else if(task.Activity_Type__c=='BDA Touch')
                            {
                                if(task.Category__c=='BAQ'){
                                    consource.Source_Type_Prospect__c='BDA BAQ';
                                }
                                else if(task.Category__c=='Call-Inbound'){
                                    consource.Source_Type_Prospect__c='BDA Inbound Call';
                                }
                                else if(task.Category__c=='Call-outbound'){
                                    consource.Source_Type_Prospect__c='BDA outbound Call';
                                }
                                else if(task.Category__c=='IRD Meeting Set'){
                                    consource.Source_Type_Prospect__c='BDA outbound Call';
                                }
                                else if(task.Category__c=='RD Meeting Set'){
                                    consource.Source_Type_Prospect__c='BDA outbound Call';
                                }
                                else if(task.Category__c=='Social OutReach'){
                                    consource.Source_Type_Prospect__c='BDA Digital OutReach';
                                }
                            }
                            else if(task.Activity_Type__c=='Master Recruiting')
                            {
                                if(task.Category__c=='Additional Response'){
                                    consource.Source_Type_Prospect__c='Master Additional Response';
                                }
                                else if(task.Category__c=='BAQ'){
                                    consource.Source_Type_Prospect__c='Master BAQ';
                                }
                                else if(task.Category__c=='Call-Inbound'){
                                    consource.Source_Type_Prospect__c='Master Inbound Call';
                                }
                                else if(task.Category__c=='Call-Outbound'){
                                    consource.Source_Type_Prospect__c='Master outbound Call';
                                }
                                else if(task.Category__c=='Conf. Call Webinar'){
                                    consource.Source_Type_Prospect__c='Master digital Outreach';
                                }
                                else if(task.Category__c=='Home Office Visit'){
                                    consource.Source_Type_Prospect__c='Masters HOV';
                                }
                                else if(task.Category__c=='In Person Presentation'){
                                    consource.Source_Type_Prospect__c='Masters Meeting';
                                }
                                else if(task.Category__c=='In Person Proforma'){
                                    consource.Source_Type_Prospect__c='Masters Meeting';
                                }
                                else if(task.Category__c=='Master Conf Offered'){
                                    consource.Source_Type_Prospect__c='Master Conference offered';
                                }
                                else if(task.Category__c=='Meeting{Various}'){
                                    consource.Source_Type_Prospect__c='Master Meeting';
                                }
                                else if(task.Category__c=='Natl Conf Offered '){
                                    consource.Source_Type_Prospect__c='Master Conference offered';
                                }
                                else if(task.Category__c=='RVP Assist Meeting'){
                                    consource.Source_Type_Prospect__c='Masters Meeting';
                                }
                                else if(task.Category__c=='Summit Offered'){
                                    consource.Source_Type_Prospect__c='Masters Conference offered';
                                }
                            }
                            else if(task.Activity_Type__c=='Recruiting')
                            {
                                if(task.Category__c=='Additional Response'){
                                    consource.Source_Type_Prospect__c='RD Additional Response';
                                }
                                else if(task.Category__c=='BAQ'){
                                    consource.Source_Type_Prospect__c='RD BAQ';
                                }
                                else if(task.Category__c=='Call-Inbound'){
                                    consource.Source_Type_Prospect__c='RD Inbound Call';
                                }
                                else if(task.Category__c=='Call-Outbound'){
                                    consource.Source_Type_Prospect__c='RD outbound Call';
                                }
                                else if(task.Category__c=='Conf. Call Webinar'){
                                    consource.Source_Type_Prospect__c='RD Inbound Call';
                                }
                                else if(task.Category__c=='Home Visit office'){
                                    consource.Source_Type_Prospect__c='RD HOV';
                                }
                                else if(task.Category__c=='Master Conf Offered'){
                                    consource.Source_Type_Prospect__c='RD Conference offered';
                                }
                                else if(task.Category__c.contains('Meeting')){
                                    consource.Source_Type_Prospect__c='RD Meeting';
                                }
                                else if(task.Category__c=='Natl Conf Offered'){
                                    consource.Source_Type_Prospect__c='RD Conference offered';
                                }
                                else if(task.Category__c=='RVP Assist meeting'){
                                    consource.Source_Type_Prospect__c='RD Meeting';
                                }
                                else if(task.Category__c=='Walk In'){
                                    consource.Source_Type_Prospect__c='RD Drop in';
                                }
                            }
                        }
                    }
                }
            }
            else if(consource.Lead_Source__c=='Referral')
            {    
                if(consource.IsReferral__c=='LPL Advisor'){
                    consource.Source_Type_Prospect__c='LPL Advisor';
                }
                else if(consource.IsReferral__c=='Recruit'){
                    consource.Source_Type_Prospect__c='Recruit';
                }
                else if(consource.IsReferral__c=='Wholesaler'){
                    consource.Source_Type_Prospect__c='Wholesaler';
                }
                else if(consource.IsReferral__c=='Outside Recruiting Firm'){
                    consource.Source_Type_Prospect__c='Outside Recruiting Firm';
                }
                else if(consource.IsReferral__c=='Recruiting Branch'){
                    consource.Source_Type_Prospect__c='Recruiting Branch';
                }
                
            }
            else if(consource.Lead_Source__c=='Transitions') {   
                consource.Source_Type_Prospect__c='Transitions';
            }
            else if(consource.Lead_Source__c==null){
                consource.Source_Type_Prospect__c='';
            }
            con.add(consource);
        }
        update con;
    }
    global void finish(Database.BatchableContext BC){
        system.debug('3r batch completed');
        
    }
    
}