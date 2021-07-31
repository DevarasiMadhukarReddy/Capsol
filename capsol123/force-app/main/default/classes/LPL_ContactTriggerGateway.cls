/*
#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
Ch-1   Adding trigger.old list into method                               Vaibhav Wadhai                   6 june 2017
And also Added logic for Update(for mailing postal code)

ch-02  Added try and catch block                                         Vaibhav wadhai                   12 june 2017

Ch-03  Change debug statement to log into Excpetion Object               Vaibhav Wadhai                   16 june 2017

CH-04  Logic optimization                                                Sai Kethu                        16 june 2017

CH-05  Added Custom Setting to remove hard code AccountId               Vaibhav Wadhai                    22 june 2017 

CH-06  Create MA tasks for IRD user as per the PardotActivityInput      Utkarsh Topre                     13 Nov  2017
field                       

CH-07  Marketing related changes as per the PardotActivityInput         Utkarsh Topre                     04 Dec 2017
field

CH-08  Merge pardot contact with Email ID                                Ashish Gupta                     18 Dec 2017

CH-09   Lead Source - MI & RI- Update                                   Manila Agnihotri                05 March 2018       

CH-10   To Populate Assigned Recruiter,Internal Recruiter (IRD),        Manila Agnihotri                  27 APRIL 2018
Regional VP ID based on mailingpostalcode

CH-11 User Story 123274:SD1017053 - Discovery zipcode                   Amit Verma                        29 May 2018

ch-12 User story 

CH-13 Update contact's Internal Recuiter field from IRA object   Ashish Gupta                          29/9/2018
when maillingpostal code and discovery home zip match

BFR007-009 added few feilds to update opportunity from contact.

CH-14 Populate IRD with Default value when the mailing postal code is invalid       Vaibhav Jain        2 Apr 2019
CH-15 Change label name for Pardot Contact record type to Pardot Prospect

CH-17 Update Program_Manager__c on Account                                          Vaibhav Jain        4 Apr 2019

CH-18 Don't Copy Unverified AUM from Contact to opportunity when stage is marked Closed Lost or Closed Joined    Rinku Yadav  2 May 2019 
CH -19 Commented Lines from 478 to 621 for avoid creating the activities         Ramola Vattam 10 May 2019
*/
public without sharing class LPL_ContactTriggerGateway{
    static Integer count = 0;//CH-17
    
    Set<ID> cIDs = new Set<ID>();
    set<string> zips = new set<string>(); //CH-01
    set<string> c_zips = new set<string>(); //CH-01
    set<string> m_zips = new set<string>(); //CH-01
    Set<ID> setAccountIds = new Set<ID>();
    
    List<Contact> updatedRecords = new List<Contact>();
    List<Contact> toBeUpdated = new List<Contact>();
    List<Contact> allUpdatedContacts = new List<Contact>();
    List<Contact> newConList=new List<Contact>();
    List<ID> contactIdList=new List<Id>();
    List<Opportunity> oppList = new List<Opportunity>();
    List<Account_Bypass__c> accBypassList=Account_Bypass__c.getAll().values();//CH-05 Getting values from custom setting
    List<Task> taskList1 = new List<Task>();   // CH-06  
    
    Map<ID, Contact> oldRecMap = new Map<ID, Contact>();
    Map<ID, Opportunity> updateLostOutcomesMap = new Map<ID, Opportunity>();
    Map<ID, Contact> ContactData = new Map<ID, Contact>();
    Map<String, List<IAS_Recruiter_Assignment__c>> ias_zip_Map = new Map<String, List<IAS_Recruiter_Assignment__c>>();
    Map<ID, Contact> prospConMap = new Map<Id, Contact>();   
    
    ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    ID ISOPP = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IS Opportunity').getRecordTypeId();
    ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    ID pardotcontactRecordtypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId(); //CH-15
    
    String detailWhereClause = 'RecordTypeID = ' + conRecordTypeId;
    
    //ch-1 start
    public void collectRecordToProcess(list<Contact> conList,List<Contact> oldconList){    
        //ch-1 end 
        try {                                              //ch-02 -start
            Map<Id,contact> oldconMap=new Map<Id,contact>();
            
            if(oldconList!=null){
                for(Integer i=0;i<oldconList.size();i++){      //ch-1 start
                    oldconMap.put(oldconList[i].id,oldconList[i]);
                }
            }                                                //ch-1 end
            for(Contact con : conList){
                cIDs.add(con.Id);//ch-1 start
                Contact oldcon=oldconMap.get(con.id);
                If(Trigger.IsInsert){
                    //***********CH-04:START*********
                    if( con.Discovery_Home_Zip__c!= null ){//create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
                        zips.add(con.Discovery_Home_Zip__c);
                        c_zips.add('C'+con.Discovery_Home_Zip__c);
                        m_zips.add('M'+con.Discovery_Home_Zip__c);
                    }               
                    //***********CH-04:END*********
                    
                    If(Con.Inactive_Reason__c=='Inactive - Compliance' 
                       || con.Inactive_Reason__c=='Inactive - Joined Another Firm'
                       || con.Inactive_Reason__c== 'Inactive - Stayed with Current Firm' 
                       || con.Inactive_Reason__c== 'Inactive - Not a Good Fit'){
                           contactIdList.add(con.Id);
                       }
                    if( con.MailingPostalCode!= null ){
                        zips.add(con.MailingPostalCode);
                    }
                }
                if(Trigger.IsUpdate){
                    //***********CH-04:START*********
                    //create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
                    if( con.Discovery_Home_Zip__c!= null || con.Allow_Lead_Type_Change__c == true ){
                        zips.add(con.Discovery_Home_Zip__c);
                        c_zips.add('C'+con.Discovery_Home_Zip__c);
                        m_zips.add('M'+con.Discovery_Home_Zip__c);
                    }
                    if( con.MailingPostalCode!= null ){
                        zips.add(con.MailingPostalCode);
                    }
                    //***********CH-04:END*********
                    
                    If((Con.Inactive_Reason__c=='Inactive - Compliance' 
                        || con.Inactive_Reason__c=='Inactive - Joined Another Firm'
                        || con.Inactive_Reason__c== 'Inactive - Stayed with Current Firm' 
                        || con.Inactive_Reason__c== 'Inactive - Not a Good Fit') && (con.Inactive_Reason__c !=oldcon.Inactive_Reason__c)){
                            contactIdList.add(con.Id);
                        }
                    
                    ContactData.put(con.Id, con);   
                }
                //ch-1 end
                setAccountIds.add(con.AccountId);
                ContactData.put(con.Id, con);
                prospConMap.put(con.ID, con);
                system.debug('--AccountId--'+con.AccountId +'--setAccountIds--'+setAccountIds);
            }
            if(zips.size()>0){//ch-1
                List<IAS_Recruiter_Assignment__c> iasList = [Select Name, Assigned_Recruiter__c, Internal_Recruiter__c, Regional_VP__c, 
                                                             Lead_Type__c, GDC_Maximum__c, GDC_Minimum__c
                                                             from IAS_Recruiter_Assignment__c
                                                             where name in :zips OR name in :c_zips OR name in :m_zips];
                
                for(IAS_Recruiter_Assignment__c ias : iasList ) {
                    string zip = ias.Name;//the actual zip-code use for matching to the opportunity
                    
                    if(ias.name.startsWith('C') || ias.Name.startsWith('M'))//strip out the leading "M" or "C"
                        zip = ias.name.substring(1,ias.name.length()).trim();
                    
                    if(ias_zip_Map.containsKey(zip)){//Add to the map or create a new map with a list of IAS_Recruiter_Assignment__c objects
                        list<IAS_Recruiter_Assignment__c> l = ias_zip_Map.get(zip);
                        l.add(ias);
                    }
                    else
                        ias_zip_Map.put(zip, new list<IAS_Recruiter_Assignment__c>{ias});
                }
            }
            
            IF(ContactData.size() != 0 && ContactData != null && setAccountIds.size()>0){
                //CH-05 START
                if(accBypassList[0].accountId__c!=null && setAccountIds.contains(accBypassList[0].accountId__c))//CH-05 END
                {     
                }
                else{
                    
                    // BFR007-009  Added fields to this query
                    oppList = [SELECT Id, Contact__c, Contact__r.RecordType.Name, 
                               Home_Phone__c, Work_Phone__c, Mobile__c, Fax__c, Email__c, 
                               Home_Address__c,StageName, City__c, State__c, Zip_Code__c,
                               Do_Not_Call__c, Do_Not_Mail__c, Email_Opt_Out__c, ELQ_Marketing_Email_Opt_Out__c,
                               Current_Firm2__c, LeadSource, Source_Type__c, Referral_By__c, Referring_Advisor_Rep_ID__c, Marketing_Classification__c, Mailer_Code__c,
                               Years_in_Industry__c, Licenses__c, Current_Firm__c, Internal_Recruiter_IRD__c, Regional_Vp__c, Territory_Segmentation__c,
                               Assigned_Recruiter__c, Team_Institutional_Group__c, Pref_Name__c, Ramp_Speed__c, Firm_Type_Broker_Dealer__c,Channel_Owner__c,
                               Advisor_Recruiting_Territory__c, Outside_Recruiting_Firm_Name__c, Outside_Recruiting_Firm_Fee_Amount__c, CRD_Number_c__c, 
                               External_Consultant_Fee__c, Lead_Approval_Date__c, Channel__c, Disclosures__c, GDC_Prior_12_mo__c, Date_of_Birth__c,AUM__c  
                               FROM Opportunity 
                               WHERE Contact__c in: ContactData.keyset() AND
                               AccountId in:setAccountIds AND (StageName!='Closed-Joined' OR StageName!='Closed-Lost' ) AND
                               (RecordTypeId =: ISOPP OR RecordTypeId =: IASBD)];
                }  
            } 
            //** Fetch list of Contact where have latest created an Opportunity   
            newConList =[ Select ID,(SELECT Id,name, Contact__c,Lost_outcome__c,Contact__r.Inactive_Reason__c FROM Opportunities__r where RecordTypeId =:IASBD AND StageName != 'Closed-Lost' ORDER BY CreatedDate DESC limit 1) 
                         FROM Contact Where ID =:contactIdList AND RecordtypeID =: conRecordTypeId ];
            
            
        }
        catch(exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());
        } 
        //ch-02-End
    } 
    /*CH-10- START*/
    // CH-11 replaced mailingpostalcode with Discovery_Home_Zip__c
    public void executeIASLogic(Contact con, Contact oldCon, boolean isInsert){
        try{ 
            if(LPL_OpportunityTriggerHandler.Flag){
                if((con.RecordTypeId == conRecordTypeId || con.RecordTypeId == pardotcontactRecordtypeID) && con.Discovery_Home_Zip__c != Null && con.Allow_Lead_Type_Change__c != true){ 
                    if(ias_zip_Map.containskey(con.Discovery_Home_Zip__c.trim())){
                        list<IAS_Recruiter_Assignment__c> iasList = ias_zip_Map.get(con.Discovery_Home_Zip__c.trim());
                        if(iasList.size()>0){
                            for(IAS_Recruiter_Assignment__c ias : iasList){
                                con.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                con.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                con.Regional_VP__c = ias.Regional_VP__c;
                                con.Lead_Type__c = ias.Lead_Type__c;
                            }
                        }
                    }
                    else{
                        if(!ias_zip_Map.containskey(con.Discovery_Home_Zip__c.trim()) && con.Allow_Lead_Type_Change__c != true){
                            if(Default_Oppty_Owner__c.getInstance() != null) 
                                con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
                            con.Assigned_Recruiter__c=null;
                            con.Regional_VP__c=null;  
                        }
                    }
                }
                else{
                    if(con.Discovery_Home_Zip__c== null && con.MailingPostalCode==null  && con.Allow_Lead_Type_Change__c != true){ //CH-13
                        if(con.RecordTypeId == conRecordTypeId || con.RecordTypeId == pardotcontactRecordtypeID)
                            if(Default_Oppty_Owner__c.getInstance() != null) 
                            con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
                        con.Assigned_Recruiter__c=null;
                        con.Regional_VP__c=null;
                    } /*CH-13- START*/
                    else if(con.MailingPostalCode!=null && ias_zip_Map.containskey(con.MailingPostalCode.trim()) && con.Discovery_Home_Zip__c== null && (con.RecordTypeId == conRecordTypeId  || con.RecordTypeId == pardotcontactRecordtypeID) && con.Allow_Lead_Type_Change__c != true){   // added by amit (con.Allow_Lead_Type_Change__c != true)on 10/19/2018
                        list<IAS_Recruiter_Assignment__c> iasList1 = ias_zip_Map.get(con.MailingPostalCode.trim());
                        if(iasList1.size()>0){
                            for(IAS_Recruiter_Assignment__c ias : iasList1){
                                con.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                con.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                con.Regional_VP__c=ias.Regional_VP__c;
                            }
                        }
                    }
                    //CH-14 - start
                    else if(con.MailingPostalCode!=null && !ias_zip_Map.containskey(con.MailingPostalCode.trim()) && con.Discovery_Home_Zip__c== null && (con.RecordTypeId == conRecordTypeId || con.RecordTypeId == pardotcontactRecordtypeID) && con.Allow_Lead_Type_Change__c != true){
                        if(Default_Oppty_Owner__c.getInstance() != null) 
                            con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
                        con.Assigned_Recruiter__c=null;
                        con.Regional_VP__c=null;    
                    }
                    //CH-14 - end
                    /*CH-13- End*/
                }
            }
            /*CH-10- END*/
            
            
            
            /*********CH-07 Start - Marketing Related Changes**************/    
            If(trigger.IsBefore && Trigger.IsInsert ){
                If(con.PardotActivityInput__c!=null && con.PardotActivityInput__c == 'MA1'){
                    con.Previous_PardotAcivity_Value__c = con.PardotActivityInput__c;
                    con.PardotActivityInput__c = '';
                    if(con.RecordTypeId==pardotcontactRecordtypeID){
                        con.Internal_Recruiter_IRD__c =con.ownerId;
                    }
                }   
            }
            
            If(trigger.IsBefore && Trigger.IsUpdate ){
                If(con.PardotActivityInput__c!=null && con.PardotActivityInput__c == 'MA1'){
                    con.Previous_PardotAcivity_Value__c = con.PardotActivityInput__c;
                }
            }
            
            If(trigger.IsBefore && Trigger.IsInsert){
                If(con.PardotActivityInput__c!=null && (con.PardotActivityInput__c == 'MA2' || con.PardotActivityInput__c == 'MA3' || con.PardotActivityInput__c == 'MA4') && con.PardotActivityInputDate__c== null){
                    con.PardotActivityInputDate__c = system.today();
                }
            }
            
            If(trigger.IsBefore && Trigger.IsUpdate){
                If(con.PardotActivityInput__c!=null && (con.PardotActivityInput__c == 'MA2' || con.PardotActivityInput__c == 'MA3' || con.PardotActivityInput__c == 'MA4') && (con.PardotActivityInputDate__c == null || (con.PardotActivityInputDate__c != null && con.PardotActivityInputDate__c.daysBetween(System.Today())>90))){
                    con.PardotActivityInputDate__c = system.today();
                }
            }
            /*************CH-07 End - Marketing Related Changes********************************/
        }  
        catch(exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());
        }
    }
    
    public List<Opportunity> doUpdateOppCon(){
        
        list<Opportunity> listOpportunity = new list<Opportunity>();
        try {
            
            ContactData = prospConMap;
            if(oppList.size() != 0 && oppList != null){
                
                for(Opportunity o : oppList){
                    If(o.Contact__c != null) {
                        
                        if(o.Home_Phone__c != ContactData.get(o.Contact__c).HomePhone && ContactData.get(o.Contact__c).HomePhone != null ){
                            o.Home_Phone__c = ContactData.get(o.Contact__c).HomePhone;
                        }
                        if(o.Work_Phone__c != ContactData.get(o.Contact__c).Phone && ContactData.get(o.Contact__c).Phone != null){
                            o.Work_Phone__c = ContactData.get(o.Contact__c).Phone;
                        }
                        if(o.Mobile__c != ContactData.get(o.Contact__c).MobilePhone && ContactData.get(o.Contact__c).MobilePhone != null){
                            o.Mobile__c = ContactData.get(o.Contact__c).MobilePhone;
                        }
                        if(o.Fax__c != ContactData.get(o.Contact__c).Fax && ContactData.get(o.Contact__c).Fax != null){
                            o.Fax__c = ContactData.get(o.Contact__c).Fax;
                        }
                        if(o.Email__c != ContactData.get(o.Contact__c).Email && ContactData.get(o.Contact__c).Email != null){
                            o.Email__c = ContactData.get(o.Contact__c).Email;
                        }
                        if(o.Home_Address__c != ContactData.get(o.Contact__c).MailingStreet && ContactData.get(o.Contact__c).MailingStreet != null){
                            o.Home_Address__c = ContactData.get(o.Contact__c).MailingStreet;
                        }
                        if(o.City__c != ContactData.get(o.Contact__c).MailingCity && ContactData.get(o.Contact__c).MailingCity  != null){
                            o.City__c = ContactData.get(o.Contact__c).MailingCity;
                        }
                        if(o.State__c != ContactData.get(o.Contact__c).MailingState && ContactData.get(o.Contact__c).MailingState != null){
                            o.State__c = ContactData.get(o.Contact__c).MailingState;
                        }
                        if(o.Zip_Code__c != ContactData.get(o.Contact__c).MailingPostalCode && ContactData.get(o.Contact__c).MailingPostalCode != null){
                            o.Zip_Code__c = ContactData.get(o.Contact__c).MailingPostalCode;
                        }
                        if(o.Do_Not_Call__c != ContactData.get(o.Contact__c).DoNotCall && ContactData.get(o.Contact__c).DoNotCall != null){
                            o.Do_Not_Call__c = ContactData.get(o.Contact__c).DoNotCall;
                        }
                        if(o.Do_Not_Mail__c != ContactData.get(o.Contact__c).Do_Not_Mail__c && ContactData.get(o.Contact__c).Do_Not_Mail__c != null){
                            o.Do_Not_Mail__c = ContactData.get(o.Contact__c).Do_Not_Mail__c;
                        }
                        if(o.Email_Opt_Out__c != ContactData.get(o.Contact__c).HasOptedOutOfEmail && ContactData.get(o.Contact__c).HasOptedOutOfEmail != null){
                            o.Email_Opt_Out__c = ContactData.get(o.Contact__c).HasOptedOutOfEmail;
                        }
                        if(o.ELQ_Marketing_Email_Opt_Out__c != ContactData.get(o.Contact__c).ELQ_Marketing_Email_Opt_Out__c && ContactData.get(o.Contact__c).ELQ_Marketing_Email_Opt_Out__c != null){
                            o.ELQ_Marketing_Email_Opt_Out__c = ContactData.get(o.Contact__c).ELQ_Marketing_Email_Opt_Out__c;
                        }
                        
                        /*  Start - ******** Lead Onboarding Changes **********  */
                        
                        if(o.Contact__r.RecordType.Name.equalsIgnoreCase('Contact Prospect')){
                            if(prospConMap.size()>0){
                                if(prospConMap.get(o.Contact__c).Lead_Source__c != null && o.LeadSource != prospConMap.get(o.Contact__c).Lead_Source__c  && o.StageName !='Closed-Joined' && o.StageName !='Closed-Lost'){ // CH-09 Added stagename condition
                                    o.LeadSource = prospConMap.get(o.Contact__c).Lead_Source__c;
                                }
                                
                                // BFR007-009 Start 
                                //CH-18 Added stagename condition
                                
                               if(prospConMap.get(o.Contact__c).AUM_from_other_source__c != null && o.AUM__c==null && o.AUM__c != prospConMap.get(o.Contact__c).AUM_from_other_source__c) {
                                     
                                   o.AUM__c = prospConMap.get(o.Contact__c).AUM_from_other_source__c;
                                }
                                if(o.Source_Type__c != prospConMap.get(o.Contact__c).Source_Type_Prospect__c && prospConMap.get(o.Contact__c).Source_Type_Prospect__c != null){
                                    o.Source_Type__c = prospConMap.get(o.Contact__c).Source_Type_Prospect__c;
                                }
                                // BFR007-009 End
                                if(o.Referral_By__c != prospConMap.get(o.Contact__c).Referral_By__c && prospConMap.get(o.Contact__c).Referral_By__c != null){
                                    o.Referral_By__c = prospConMap.get(o.Contact__c).Referral_By__c;
                                }
                                if(o.Referring_Advisor_Rep_ID__c != prospConMap.get(o.Contact__c).Referring_Advisor_Rep_ID__c && prospConMap.get(o.Contact__c).Referring_Advisor_Rep_ID__c != null){
                                    o.Referring_Advisor_Rep_ID__c = prospConMap.get(o.Contact__c).Referring_Advisor_Rep_ID__c;
                                }
                                if(o.Marketing_Classification__c != prospConMap.get(o.Contact__c).Marketing_Classification_Prospect__c && prospConMap.get(o.Contact__c).Marketing_Classification_Prospect__c != null){
                                    o.Marketing_Classification__c = prospConMap.get(o.Contact__c).Marketing_Classification_Prospect__c;
                                }
                                if(o.Mailer_Code__c != prospConMap.get(o.Contact__c).Mailer_Code_Prospect__c && prospConMap.get(o.Contact__c).Mailer_Code_Prospect__c != null){
                                    o.Mailer_Code__c = prospConMap.get(o.Contact__c).Mailer_Code_Prospect__c;
                                }
                                if(o.Years_in_Industry__c != prospConMap.get(o.Contact__c).Years_in_Industry__c && prospConMap.get(o.Contact__c).Years_in_Industry__c != null){
                                    o.Years_in_Industry__c = prospConMap.get(o.Contact__c).Years_in_Industry__c;
                                }
                                if(o.Licenses__c != prospConMap.get(o.Contact__c).Licenses__c && prospConMap.get(o.Contact__c).Licenses__c != null){
                                    o.Licenses__c = prospConMap.get(o.Contact__c).Licenses__c;
                                }
                                if(o.Current_Firm__c != prospConMap.get(o.Contact__c).Current_Firm__c && prospConMap.get(o.Contact__c).Current_Firm__c != null){
                                    o.Current_Firm__c = prospConMap.get(o.Contact__c).Current_Firm__c;
                                }
                                /* BFR007-009 Start*/
                                if(o.Pref_Name__c != prospConMap.get(o.Contact__c).Pref_Name__c && prospConMap.get(o.Contact__c).Pref_Name__c != null){
                                    o.Pref_Name__c = prospConMap.get(o.Contact__c).Pref_Name__c;
                                }
                                
                                if(o.Channel_Owner__c != prospConMap.get(o.Contact__c).Channel_Owner__c && prospConMap.get(o.Contact__c).Channel_Owner__c != null){
                                    o.Channel_Owner__c = prospConMap.get(o.Contact__c).Channel_Owner__c;
                                }
                                if(o.Territory_Segmentation__c != prospConMap.get(o.Contact__c).Territory_Segmentation__c && prospConMap.get(o.Contact__c).Territory_Segmentation__c != null){
                                    o.Territory_Segmentation__c = prospConMap.get(o.Contact__c).Territory_Segmentation__c;
                                }
                                if(o.Advisor_Recruiting_Territory__c != prospConMap.get(o.Contact__c).Advisor_Recuiting_Territory__c && prospConMap.get(o.Contact__c).Advisor_Recuiting_Territory__c != null){
                                    o.Advisor_Recruiting_Territory__c = prospConMap.get(o.Contact__c).Advisor_Recuiting_Territory__c;
                                }
                                if(o.Assigned_Recruiter__c != prospConMap.get(o.Contact__c).Assigned_Recruiter__c && prospConMap.get(o.Contact__c).Assigned_Recruiter__c != null){
                                    o.Assigned_Recruiter__c = prospConMap.get(o.Contact__c).Assigned_Recruiter__c;
                                }
                                if(o.Internal_Recruiter_IRD__c != prospConMap.get(o.Contact__c).Internal_Recruiter_IRD__c && prospConMap.get(o.Contact__c).Internal_Recruiter_IRD__c != null){
                                    o.Internal_Recruiter_IRD__c = prospConMap.get(o.Contact__c).Internal_Recruiter_IRD__c;
                                }
                                if(o.Regional_VP__c != prospConMap.get(o.Contact__c).Regional_VP__c && prospConMap.get(o.Contact__c).Regional_VP__c != null){
                                    o.Regional_VP__c = prospConMap.get(o.Contact__c).Regional_VP__c;
                                }
                                system.debug('--Contact Prospect.Outside_Recruiting_Firm_Name__c--'+prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Name__c);
                                if(o.Outside_Recruiting_Firm_Name__c != prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Name__c && prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Name__c != null){
                                    o.Outside_Recruiting_Firm_Name__c = prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Name__c;
                                }
                                if(o.Outside_Recruiting_Firm_Fee_Amount__c != prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Payout__c && prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Payout__c != null){
                                    o.Outside_Recruiting_Firm_Fee_Amount__c = prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Payout__c;
                                }
                                if(o.External_Consultant_Fee__c != prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Fee__c && prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Fee__c != null){
                                    o.External_Consultant_Fee__c = prospConMap.get(o.Contact__c).Outside_Recruiting_Firm_Fee__c;
                                }
                                if(o.Lead_Approval_Date__c != prospConMap.get(o.Contact__c).Lead_Approval_Date__c && prospConMap.get(o.Contact__c).Lead_Approval_Date__c != null){
                                    o.Lead_Approval_Date__c = prospConMap.get(o.Contact__c).Lead_Approval_Date__c;
                                }
                                if(o.Channel__c != prospConMap.get(o.Contact__c).Channel__c && prospConMap.get(o.Contact__c).Channel__c != null){
                                    o.Channel__c = prospConMap.get(o.Contact__c).Channel__c;
                                }
                                if(o.CRD_Number_c__c != prospConMap.get(o.Contact__c).CRD_Number__c && prospConMap.get(o.Contact__c).CRD_Number__c != null){
                                    o.CRD_Number_c__c = prospConMap.get(o.Contact__c).CRD_Number__c;
                                }
                                if(o.Disclosures__c != prospConMap.get(o.Contact__c).Discovery_Regulatory_Disclosures__c && prospConMap.get(o.Contact__c).Discovery_Regulatory_Disclosures__c != null){
                                    o.Disclosures__c = prospConMap.get(o.Contact__c).Discovery_Regulatory_Disclosures__c;
                                }
                                system.debug('--GDC_Prior_12_mo__c--'+prospConMap.get(o.Contact__c).GDC_Prior_12_mo__c);
                                if(o.GDC_Prior_12_mo__c != prospConMap.get(o.Contact__c).GDC_Prior_12_mo__c&& prospConMap.get(o.Contact__c).GDC_Prior_12_mo__c!= null){
                                    o.GDC_Prior_12_mo__c = prospConMap.get(o.Contact__c).GDC_Prior_12_mo__c;
                                }
                                if(o.Date_of_Birth__c != prospConMap.get(o.Contact__c).Discovery_Date_of_Birth_Full__c && prospConMap.get(o.Contact__c).Discovery_Date_of_Birth_Full__c != null){
                                    o.Date_of_Birth__c = prospConMap.get(o.Contact__c).Discovery_Date_of_Birth_Full__c;
                                }
                                /* BFR007-009 End */
                                
                            }
                        }
                        listOpportunity.add(o);
                        /*  End - ******** Lead Onboarding Changes ********** */
                    }
                }
            }                    
            
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_ContactTriggerGateway','doUpdateOppCon',e.getMessage(),e.getLineNumber(),e.getTypeName());//CH-03
        }
        return listOpportunity;
    }
    
    /***** BFR009 - Contacts : User should be able to edit contact fields and It should update to Active opportunity*******/
    
    public void updateOppfieldsfromContact(Contact contactRec) {
        
        /*   try{
if(contactRec.RecordTypeId == conRecordTypeId ||contactRec.RecordTypeId == pardotcontactRecordtypeID){

if(contactRec.Internal_Recruiter_IRD__c!=null && contactRec.Previous_PardotAcivity_Value__c=='MA1'){ //CH-07 Start - Marketing Related Changes

Task t1 = new Task();
t1.Subject = 'Marketing Form Follow up';
t1.whoId = contactRec.ID;
t1.Status = 'Not Started';
t1.Department__c = 'Business Development';
t1.Activity_Type__c = 'IRD Touch';
t1.Category__c = 'Call-Outbound';
t1.ActivityDate = System.Today() + 2;
t1.recordtypeId = Label.TaskMasterRecordType;
t1.Type = 'Outbound Call';
t1.ownerId = contactRec.Internal_Recruiter_IRD__c ;  
taskList1.add(t1); 
}



}
}

catch(Exception e) {
LPL_CreateExceptionLog.createErrorRecordAsync('LPL_ContactTriggerGateway','createMAtasks',e.getMessage(),e.getLineNumber(),e.getTypeName());
} */
    }
    
    
    /***** CH-06 Start - Create MA tasks for the IRD user as per the criteria*******/
   /* 
    public void createMAtasksInsert(Contact contactRec) {
        
        try{
            if(contactRec.RecordTypeId == conRecordTypeId ||contactRec.RecordTypeId == pardotcontactRecordtypeID){
                
                if(contactRec.Internal_Recruiter_IRD__c!=null && contactRec.Previous_PardotAcivity_Value__c=='MA1'){ //CH-07 Start - Marketing Related Changes
                    
                    Task t1 = new Task();
                    t1.Subject = 'Marketing Form Follow up';
                    t1.whoId = contactRec.ID;
                    t1.Status = 'Not Started';
                    t1.Department__c = 'Business Development';
                    t1.Activity_Type__c = 'IRD Touch';
                    t1.Category__c = 'Call-Outbound';
                    t1.ActivityDate = System.Today() + 2;
                    t1.recordtypeId = Label.TaskMasterRecordType;
                    t1.Type = 'Outbound Call';
                    t1.ownerId = contactRec.Internal_Recruiter_IRD__c ;  
                    taskList1.add(t1); 
                }
                
                if(contactRec.Internal_Recruiter_IRD__c!=null && contactRec.PardotActivityInput__c=='MA2' ){
                    
                    Task t2 = new Task();
                    t2.Subject = 'Disruption Email Click Through Follow Up';
                    t2.whoId = contactRec.ID;
                    t2.Status = 'Not Started';
                    t2.Department__c = 'Business Development';
                    t2.Activity_Type__c = 'IRD Touch';
                    t2.Category__c = 'Call-Outbound';
                    t2.ActivityDate = System.Today() + 5;
                    t2.recordtypeId = Label.TaskMasterRecordType;
                    t2.Type = 'Outbound Call';
                    t2.ownerId =  contactRec.Internal_Recruiter_IRD__c ;  
                    taskList1.add(t2);    
                }
                
                if(contactRec.Internal_Recruiter_IRD__c!=null && contactRec.PardotActivityInput__c=='MA3' ){            
                    Task t3 = new Task();
                    t3.Subject = 'Drip Email Click Through Follow Up ';
                    t3.whoId = contactRec.ID;
                    t3.Status = 'Not Started';
                    t3.Department__c = 'Business Development';
                    t3.Activity_Type__c = 'IRD Touch';
                    t3.Category__c = 'Call-Outbound';
                    t3.ActivityDate = System.Today() + 5;
                    t3.recordtypeId = Label.TaskMasterRecordType;
                    t3.Type = 'Outbound Call';
                    t3.ownerId =  contactRec.Internal_Recruiter_IRD__c ;  
                    taskList1.add(t3);    
                }
                if(contactRec.Internal_Recruiter_IRD__c!=null && contactRec.PardotActivityInput__c=='MA4'  ){            
                    Task t4 = new Task();
                    t4.Subject = 'Agile Email Click Through Follow Up';
                    t4.whoId = contactRec.ID;
                    t4.Status = 'Not Started';
                    t4.Department__c = 'Business Development';
                    t4.Activity_Type__c = 'IRD Touch';
                    t4.Category__c = 'Call-Outbound';
                    t4.ActivityDate = System.Today() + 5;
                    t4.recordtypeId = Label.TaskMasterRecordType;
                    t4.ownerId =  contactRec.Internal_Recruiter_IRD__c ;  
                    taskList1.add(t4);    
                }
            }
        }
        
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_ContactTriggerGateway','createMAtasks',e.getMessage(),e.getLineNumber(),e.getTypeName());
        } 
    }
    
    public void createMAtasksUpdate(Contact NewCon ,Contact OldCon) {
        try{
            if(NewCon.RecordTypeId == conRecordTypeId || NewCon.RecordTypeId == pardotcontactRecordtypeID){
                
                if(NewCon.Internal_Recruiter_IRD__c!=null && NewCon.PardotActivityInput__c=='MA1' && oldCon.PardotActivityInput__c!= ''){ //CH-07 Start - Marketing Related Changes
                    Task t1 = new Task();
                    t1.Subject = 'Marketing Form Follow up';
                    t1.whoId = NewCon.ID;
                    t1.Status = 'Not Started';
                    t1.Department__c = 'Business Development';
                    t1.Activity_Type__c = 'IRD Touch';
                    t1.Category__c = 'Call-Outbound';
                    t1.ActivityDate = System.Today() + 2;
                    t1.recordtypeId = Label.TaskMasterRecordType;
                    t1.Type = 'Outbound Call';
                    t1.ownerId = NewCon.Internal_Recruiter_IRD__c ;  
                    taskList1.add(t1);
                }
                
                if(NewCon.Internal_Recruiter_IRD__c!=null && NewCon.PardotActivityInput__c=='MA2'  && (OldCon.PardotActivityInputDate__c==null || (OldCon.PardotActivityInputDate__c!=null && OldCon.PardotActivityInputDate__c.daysBetween(System.Today())>90))){ //CH-07 Start - Marketing Related Changes
                    
                    Task t2 = new Task();
                    t2.Subject = 'Disruption Email Click Through Follow Up';
                    t2.whoId = NewCon.ID;
                    t2.Status = 'Not Started';
                    t2.Department__c = 'Business Development';
                    t2.Activity_Type__c = 'IRD Touch';
                    t2.Category__c = 'Call-Outbound';
                    t2.ActivityDate = System.Today() + 5;
                    t2.recordtypeId = Label.TaskMasterRecordType;
                    t2.Type = 'Outbound Call';
                    t2.ownerId =  NewCon.Internal_Recruiter_IRD__c ;  
                    taskList1.add(t2);    
                }
                
                if(NewCon.Internal_Recruiter_IRD__c!=null && NewCon.PardotActivityInput__c=='MA3'  && (OldCon.PardotActivityInputDate__c==null || (OldCon.PardotActivityInputDate__c!=null && OldCon.PardotActivityInputDate__c.daysBetween(System.Today())>90))){  //CH-07 Start - Marketing Related Changes          
                    Task t3 = new Task();
                    t3.Subject = 'Drip Email Click Through Follow Up ';
                    t3.whoId = NewCon.ID;
                    t3.Status = 'Not Started';
                    t3.Department__c = 'Business Development';
                    t3.Activity_Type__c = 'IRD Touch';
                    t3.Category__c = 'Call-Outbound';
                    t3.ActivityDate = System.Today() + 5;
                    t3.recordtypeId = Label.TaskMasterRecordType;
                    t3.Type = 'Outbound Call';
                    t3.ownerId =  NewCon.Internal_Recruiter_IRD__c ;  
                    taskList1.add(t3);    
                }
                
                if(NewCon.Internal_Recruiter_IRD__c!=null && NewCon.PardotActivityInput__c=='MA4'  && (OldCon.PardotActivityInputDate__c==null || (OldCon.PardotActivityInputDate__c!=null && OldCon.PardotActivityInputDate__c.daysBetween(System.Today())>90))){     //CH-07 Start - Marketing Related Changes       
                    Task t4 = new Task();
                    t4.Subject = 'Agile Email Click Through Follow Up';
                    t4.whoId = NewCon.ID;
                    t4.Status = 'Not Started';
                    t4.Department__c = 'Business Development';
                    t4.Activity_Type__c = 'IRD Touch';
                    t4.Category__c = 'Call-Outbound';
                    t4.ActivityDate = System.Today() + 5;
                    t4.recordtypeId = Label.TaskMasterRecordType;
                    t4.ownerId =  NewCon.Internal_Recruiter_IRD__c ;  
                    taskList1.add(t4);    
                }
            }
        }
        
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_ContactTriggerGateway','createMAtasksUpdate',e.getMessage(),e.getLineNumber(),e.getTypeName());
        } 
    }
    */
    public void deleteContactCount(List<Contact> contactList) {
        
        try {//ch-02-start
            Set<Id> accIdSet=new Set<Id>();
            
            for(Contact contactObj:contactList) {
                ID idValue=contactObj.AccountId;
                accIdSet.add(idValue);
            }
            List<Account> accountList= [Select Id,Number_of_Contacts__c from Account where Id In:accIdSet];
            List<Account> newAccountList=new  List<Account>();
            
            for(Account accObj:accountList) {
                accObj.Number_of_Contacts__c = accObj.Number_of_Contacts__c -1;
                newAccountList.add(accObj);
            }
            update newAccountList;
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_ContactTriggerGateway','deleteContactCount',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
        //ch-02-End
    } 
    
    /* This method run on after update Contact Records, modified Lost outcome and Win/Lost Reason field of Opportunity.
Created By:Ashish Gupta Version:0.1 */
    public  List<Opportunity> findOpportunity()
    {    
        List<Opportunity> OppList = new List<Opportunity>();
        try {
            if(newConList.size()>0) {
                
                for(Contact con:newConList) {
                    if(con.Opportunities__r.size()>0){
                        OppList.add(con.Opportunities__r);    
                    }
                }
            } 
            
            if(OppList.size()>0) {
                for(Opportunity OppObject:oppList) {
                    if(OppObject.Contact__r.Inactive_Reason__c=='Inactive - Compliance') {
                        
                        OppObject.Lost_outcome__c='Compliance Reason';
                        OppObject.Win_Loss_Reasons__c='Unknown';
                        updateLostOutcomesMap.put(OppObject.ID, OppObject);
                    }
                    if(OppObject.Contact__r.Inactive_Reason__c=='Inactive - Joined Another Firm') {
                        
                        OppObject.Lost_outcome__c='Joined Another Firm';
                        OppObject.Win_Loss_Reasons__c='Unknown';
                        updateLostOutcomesMap.put(OppObject.ID, OppObject);
                    }
                    if(OppObject.Contact__r.Inactive_Reason__c=='Inactive - Stayed with Current Firm') {
                        
                        OppObject.Lost_outcome__c='Stayed with Current Firm';
                        OppObject.Win_Loss_Reasons__c='Unknown';
                        updateLostOutcomesMap.put(OppObject.ID, OppObject);
                    }
                    if(OppObject.Contact__r.Inactive_Reason__c=='Inactive - Not a Good Fit') {
                        
                        OppObject.Lost_outcome__c='Not a Good Fit';
                        OppObject.Win_Loss_Reasons__c='Unknown';
                        updateLostOutcomesMap.put(OppObject.ID, OppObject);
                    }
                }
            }     
            
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_ContactTriggerGateway','findOpportunity',e.getMessage(),e.getLineNumber(),e.getTypeName()); //CH-03
            
        }
        if(updateLostOutcomesMap.size()>0){
            return updateLostOutcomesMap.values();
        }
        else{
            return null;
        }
    }
    
    // CH-08  start
    /* this method for Contact Merge */
    Map<Contact, Contact> mergeContactMap=new Map<Contact,Contact>();
    List<Task> updateTaskOwnerList=new  List<Task>();
    list<Contact> IRDAssignmentList=new list<Contact>();
    
    //  CH-08 END
    
    /***** CH-06 Start- Create MA tasks for the IRD user as per the criteria*******/
    public void processAndFinally() {
        Contact master;
        Contact child;
        if(taskList1.size()>0) {
        system.debug('taskList1=======>'+taskList1.size());
            insert taskList1;
        }
        
        if(IRDAssignmentList.size()>0){
            update IRDAssignmentList;
        }
        
        if(mergeContactMap.size()>0){
            
            for(Contact masterCon:mergeContactMap.values()){
                master=masterCon;
                
            }
            for(Contact childCon:mergeContactMap.keySet()){
                child=childCon;
            }
            ID childConID=child.Id;
            List<Task> tList = [select Id, WhoId from Task where WhoId =:childConID];
            
            for(Task tsk:tList ){
                tsk.OwnerID=master.Internal_Recruiter_IRD__c;
                updateTaskOwnerList.add(tsk);
            }
            if(updateTaskOwnerList.size()>0){
                update updateTaskOwnerList;
            }
            
            database.merge(master,child);             
        }
    }     
    /***** CH-06 End - Create MA tasks for the IRD user as per the criteria*******/
    //CH-17 Start
    /*public void updateProgramManagerOnAccount(Contact c,Id oldAccId){
        try{
            System.debug('Inside Program Manager');
            
            Map<String,Account> accMap = new Map<String,Account>();
            Map<String,List<Contact>> mapRelatedContacts = new Map<String,List<Contact>>();
            List<Account> accConList = new List<Account>();
            if(oldAccId != null){
                accConList = [Select id,program_manager__c, (Select id,Role__c,accountId,Rep_Status__c,PM_Contact_Level__c,CreatedDate,Hire_Date__c from Contacts order by createdDate) from Account where RecordType.Name='IS - Institution' and (Id=:c.AccountId or Id=:oldAccId)];
            }
            else{
                accConList = [Select id,program_manager__c, (Select id,Role__c,accountId,Rep_Status__c,PM_Contact_Level__c,CreatedDate,Hire_Date__c from Contacts order by createdDate) from Account where RecordType.Name='IS - Institution' and Id=:c.AccountId];
            }
            for(Account acc : accConList){
                mapRelatedContacts.put(acc.Id,acc.Contacts);
                accMap.put(acc.Id, acc);
            }
            for(Account a:accConList){
                DateTime conCreatedDateP = null;
                Date conHireDateP = null;
                DateTime conCreatedDateS = null;
                Date conHireDateS = null;
                if(a.contacts.size()>1){
                    for(Contact con:a.contacts){
                        if(con.Rep_Status__c == 'Active' && (con.Role__c=='Program Manager' || con.Role__c=='Financial Consultant/PM')){
                            if(con.PM_Contact_Level__c=='Primary PM Contact' || con.PM_Contact_Level__c=='Primary'){
                                count++;
                                if(String.valueOf(conCreatedDateP)==null){
                                    conCreatedDateP = con.CreatedDate;
                                    conHireDateP = con.Hire_Date__c;
                                    accMap.get(a.Id).program_Manager__c = con.Id;
                                }
                                else if (conCreatedDateP==con.CreatedDate){
                                    if(String.valueOf(conHireDateP)==null){
                                        conHireDateP = con.Hire_Date__c;
                                        accMap.get(a.Id).program_Manager__c = con.Id;
                                    }
                                    else if(conHireDateP>con.Hire_Date__c){
                                        conHireDateP = con.Hire_Date__c;
                                        accMap.get(a.Id).program_Manager__c = con.Id;
                                    }
                                }
                                else if (conCreatedDateP<con.CreatedDate)
                                    break;
                            }
                            else if((con.PM_Contact_Level__c=='Secondary PM Contact' || con.PM_Contact_Level__c=='Secondary') && conCreatedDateP == null){
                                count++;
                                if(String.valueOf(conCreatedDateS)==null){
                                    conCreatedDateS = con.CreatedDate;
                                    conHireDateS = con.Hire_Date__c;
                                    accMap.get(a.Id).program_Manager__c = con.Id;
                                }
                                else if (conCreatedDateS==con.CreatedDate){
                                    if(conHireDateS>con.Hire_Date__c){
                                        conHireDateS = con.Hire_Date__c;
                                        accMap.get(a.Id).program_Manager__c = con.Id;
                                    }
                                }
                                else if (conCreatedDateS<con.CreatedDate){}
                                //break;
                            }
                            else if(conCreatedDateP==null && conCreatedDateS==null){
                                count++;
                                accMap.get(a.Id).program_Manager__c = con.Id;
                            }
                        }
                    }
                }
                
                else if(a.contacts.size()==1){
                    Contact con = a.contacts[0];
                    if(con.Rep_Status__c == 'Active' && (con.Role__c=='Program Manager' || con.Role__c=='Financial Consultant/PM')){
                        count++;
                        accMap.get(a.Id).program_Manager__c = a.contacts[0].Id;
                    }
                }
                
                if(count==0){
                    accMap.get(a.Id).program_Manager__c = null;
                }
            }
            if(accMap.values().size()>0)
                update accMap.values();
        }
        catch(Exception e){
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_ContactTriggerGateway','updateProgramManagerOnAccount',e.getMessage(),e.getLineNumber(),e.getTypeName());//CH-03
        }
        
    }*/
    //CH-17 End
    public void updateProgramManagerOnAccount(List<Contact> newConList, List<Contact> oldConList, boolean isAfterDelete) {
        Set<Id> accountIds = new Set<Id>();
        List<Account> accList = new List<Account>();
        
        if(newConList != null && !newConList.isEmpty() && oldConList == null && !isAfterDelete) {
            for(Contact con: newConList) {
                accountIds.add(con.AccountId);
            }
        } 
        else if (newConList != null && !newConList.isEmpty() && oldConList != null && !oldConList.isEmpty() && !isAfterDelete) {
            for(Contact con : oldConList) {
                accountIds.add(con.AccountId);
            }
        } 
        else if (newConList == null && oldConList != null && !oldConList.isEmpty() && isAfterDelete) {
            for(Contact con : oldConList) {
                accountIds.add(con.AccountId);
            }
        }
        
        if(accountIds != null && !accountIds.isEmpty()) {
            accList = [SELECT Id, (SELECT Id FROM Contacts WHERE Rep_Status__c = 'Active' AND Role__c = 'Program Manager' ORDER BY Contact_Level__c , CreatedDate, Hire_Date__c LIMIT 1), (SELECT Id, Related_Contacts__c FROM Related_Enterprises__r WHERE Relationship_Type__c IN ('Advisor & PM', 'PM', 'PM & OSJ') ORDER BY Related_Contacts__r.Contact_Level__c, Related_Contacts__r.Hire_Date__c desc LIMIT 1) FROM Account WHERE RecordType.Name = 'IS - Institution' AND Id IN: accountIds];
        }
        
        if(accList != null && !accList.isEmpty()) {
            for(Account acc : accList) {
                if(acc.Contacts != null && !acc.Contacts.isEmpty()) {
                    acc.Program_Manager__c = acc.Contacts[0].Id;
                } else {
                    if(acc.Related_Enterprises__r != null && !acc.Related_Enterprises__r.isEmpty()){
                        acc.Program_Manager__c = acc.Related_Enterprises__r[0].Related_Contacts__c;
                    }
                }
            }
        }
        
        try {
            update accList;
        } 
        catch (Exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_ContactTriggerGateway','updateProgramManagerOnAccount',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
}