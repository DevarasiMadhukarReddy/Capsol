/*
Trigger Name            :LPL_OpportunityTriggerGateway
Description             :This class is mainly facus on Opportunity and also have dependency with Contact Object.

Developer Name          : Pravin Kale
Created Date            : 3/16/2017 

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01       When update an Opportunity fields StageName as      Ashish Gupta    6/6/2017
"Close-Lost" and Lost Outcome then
Contact Prospect Status field's 
value replace with Lost Outcome. 

CH-02       Commented code for using batch class                 Vaibhav Wadhai    14 june 2017
(Batch Class Name:LPL_Update_TotalAdvisoryAUM_Batch)
Note : Test Coverage for This class is covered in Test class  :  LPL_OpportunityHandlerTest

CH-03        Commentted unwanted account to delete                Sai Kethu        06/15/2017
unneccessary fields

CH-04       Requirement is to put value in opprtunity’s           Vaibhav Wadhai    07/13/2017
territory segmentation to contact’s territory 
segmentation field.

CH-05       Adding task when IRD recruiter and                    Vaibhav Wadhai    07/17/2017
HOV date is populated

CH-06       Adding task when opportunity stage is closed-lost and    Vaibhav Wadhai   07/19/2017
2-hotlist.And no change in stage within 120 and 9 monts
(for this added time based workflow)

CH-07       Updating Case When Opportinity stage changes to 'kit received'    Vaibhav Wadhai 07/26/2017

CH-08       Adding Trigger.isBefore condition to SOQL as                     Vaibhav Wadhai  08/01/2017
it is excuting only in before Triggers

CH-09       Project j Enhancement:Update case fields(MAX TA Dollars Allowed    Vaibhav Wadhai  08/16/2017
,Offer Letter Sent, Signed offer Letter Received) from Opportunity.

CH-10      For Contract Accommodation:         
User Story Desc: Getting a Task created From Opportunity            Vaibhav Wadhai   09 Sept 2017
and assigned to Opportunity IRD.
Criteria :
Opportunity'sInternal_Recruiter_IRD__c is not null && 
Opportunity's StageName equals '3 - Submitted a Kit' 
and Opportunity's approved expected aum >0 && 
Opportunity's Channel Owner equals 'IAS'
then task should be created.

CH-11      Added by Pravin Kale to stop Case trigger for TA Doller Field Update Pravin Kale        06 Oct 2017

Ch-12    Send email to the IRD and Assigned Recruiter when the "CH-10"         Utkarsh Topre        10/09/2017
conditions will meet.

CH-13    Make Assigned Recruiter as the Opportunity Owner when the            Utkarsh Topre        02/23/2018
record type is "IAS Business Development"   

CH-14 Added Target_TAT_Date__c!=null due                                        Ashish Gupta      14 march 2018
to this requirement SD974439 - Opporturnity Target TAT Date

CH-15   To Populate Assigned Recruiter,Internal Recruiter (IRD),            Manila Agnihotri      04/27/2018
Regional VP ID based on mailingpostalcode  

CH-16   Update the Highest Stage Reached field on Contact based on the         Utkarsh Topre      05/07/2018
highest Stage value in the related Opportunity

CH-17 Advisor Diversity update from opportuntiy to contact- LPL Advisor     Manila Agnihotri      05/30/2018  

CH-18 Update Lead Source to "Transition" when                 Manila Agnihotri      05-June-2018
Marketing Category equals "Dormant" and a opportuntiy
created/updated related to that Contact

CH-19   Update  Region field on Opportunity from IAS Recruiter Assignment's Region   Ashish Gupta      24 oct 2018
based on zip code                                 

CH-20 Update 'Channel' and 'Request to join as' from Contact to Opportunity upon creation of Opportunity.   Vaibhav Jain   09/28/2018

Ch-21 Email population on opportunity                                            Manila Agnihotri      10/16/2018

Ch-22 If “Discovery Home Zip” is blank and “Mailing Zip Code” is not, “Region” populates based on “Mailing Zip Code”.  Vaibhav Jain 12 Nov 2018

Ch-23 Changes to correct mapping between Lost Outcome and Prospect Status on Contact          Garvita Rai            02/15/2019
CH-25 Copy Unverified AUM from Opp to Contact when stage is marked Closed Lost or Closed Joined   Garvita Rai                    22 Apr 2019
CH-26 Replaced Insurance_Territory__c field to WMO_Division__c field to automatically populate on from contact to Opportunity.       Ramola Vattam         6 May 2019
CH-27 CS-2756 Sprint 21- Remove hardcoded loan application status values     Bhanu              02/03/2021
*/
public class LPL_OpportunityTriggerGateway{
    
    Schema.DescribeSObjectResult oppRecDesc = Schema.SObjectType.Opportunity;
    Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
    
    Map<Id, Opportunity> oldOppMap = new Map<ID, Opportunity>();
    Map<String,Schema.RecordTypeInfo> rtMapByName = oppRecDesc.getRecordTypeInfosByName();
    Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
    Map<ID,Schema.RecordTypeInfo> rt_MapCon = Contact.sObjectType.getDescribe().getRecordTypeInfosById();
    Map<String,Schema.RecordTypeInfo> rt_TaskMap = tskRecDesc.getRecordTypeInfosByName();
    Map<Id,Id> AccIdConId= new Map<Id,Id>();
    Map<Id, Contact> ConIDObj = new Map<Id, Contact>();
    Map<Id, LPL_Insurance_Associates__c> iaMap=new Map<Id, LPL_Insurance_Associates__c>();
    Map<Id, opportunity> oppMap = new Map<Id, Opportunity>();
    Map<Id, Contact> conMap = new Map<Id, Contact>();
    Map<Id, Contact> conMapUpOp = new Map<Id, Contact>();
    Map<Id,Id> opc = new Map<Id,Id>();
    Map<Id, Contact> cMap = new Map<Id, Contact>();
    Map<ID, Opportunity> oppUpdateMap = new Map<ID, Opportunity>();
    Map<String, ID> oppTaskMap = new Map<String, ID>();
    Map<Id,User> MapUser = new Map<Id,User>();
    Map<Id,Contact> contactOnIdMap=new Map<Id,Contact>();
    Map<Id,Opportunity> OppIdConId= new Map<Id,Opportunity>();
    Map<ID,String> oppMapnew =new Map<Id,String>();  //CH-12
    Map<ID,String> oppMapNewAssignRec=new Map<ID,String>();//CH-12
    Map<Id,Case> caseMap=new Map<Id,Case>();//ch-07
    
    Id rt = rt_TaskMap.get('Transitions').getRecordTypeId();
    ID oppRIAID = rtMapByName.get('RIA Compliance ADVantage').getRecordTypeId();
    ID oppInsuranceID = rtMapByName.get('AIS Insurance Sales').getRecordTypeId();
    Id IASBD = rtMapByName.get('IAS Business Development').getRecordTypeId();
    
    Set<Id> AccId= new Set<Id>();   
    Set<Id> opp = new Set<Id>(); 
    Set<Id> con = new Set<Id>(); 
    Set<Id> oppconids = new Set<Id>();
    Set<ID> oppID = new Set<ID>();
    Set<Id> UserId = new set<Id>();
    set<string> zips = new set<string>();
    set<string> c_zips = new set<string>();
    set<string> m_zips = new set<string>();
    set<Id> accIdUT= new set<Id>(); // opportunity Utility Variables
    List<Contact> conUpdate = new List<Contact>(); //CH-16
    List<Contact> conInsert = new List<Contact>(); //CH-16
    List<Contact> convalue = new List<Contact>(); //CH-16
    List<Id> ConId= new List<Id>();
    List<Id> iaConId= new List<Id>();
    List<Opportunity> oppList = new List<Opportunity>();
    List<String> oppZipList = new List<String>();
    List<Opportunity> opi = new List<Opportunity>();
    List<Opportunity> opu = new List<Opportunity>();
    List<ID> conIds = new List<ID>();
    List<ID> conIdAIS = new List<ID>(); //Pravin Kale - AIS Logic Optimization
    List<Opportunity> newOppTaskList = new List<Opportunity>();
    List<Opportunity> getTaskOpp = New List<Opportunity>();
    List<IAS_Recruiter_Assignment__c> iasOppList = new List<IAS_Recruiter_Assignment__c>();
    List<Task> tskList = new List<Task>();
    List<Task> tskUpdtList = new List<Task>();
    List<Task> insertList = new List<Task>();
    List<Task> updateList = new List<Task>();
    List<Branch_Inst_Financial__c> listOfBIF = new List<Branch_Inst_Financial__c>(); 
    List<Task> newTaskList=new List<Task>();//Ch-05
    List<Case>  UpdatedCaseList=new List<Case>();//Ch-07
    List<Case> caseList=new List<Case>();//ch-07
    List<String> emailSendList = new List<String>();  //CH-12
    List<Opportunity> oppListNew=new List<Opportunity>(); //CH-12
    List<Contact> Conupdatevalue = new List<Contact>();
    
    Map<String, IAS_Recruiter_Assignment__c> zipMap= new Map <String, IAS_Recruiter_Assignment__c>(); //CH-19
    List<String> newzipList=new List<String>();//CH-19
    public static boolean isRecursion = false;
    public static boolean stopCaseTrigTAUpdate = false; //CH-11
    static Boolean value=true;//CH-06
    static Boolean value1=true;//CH-06
    
    public static Boolean notrigger = False;
    Id caseRecordTypeIBDid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Project J').getRecordTypeId();//ch-07
    OpportunityHandler handler = new OpportunityHandler();
    ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); //CH-16
    ID conLPLTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId(); //CH-16
    public void collectRecordToProcess(List<Opportunity> oppList1, Map<ID, Opportunity> oldOppMap){
        try{
            for(Opportunity opp : oppList1){
                Opportunity oldOpp;
                oppMap.put(opp.Id, opp);
                AccId.add(opp.AccountID);
                iaConId.add(opp.Contact__c);
                conIds.add(opp.Contact__c);
                oppconids.add(opp.Contact__c);
                oppID.add(opp.Id);
                OppIdConId.put(opp.Contact__C, opp);
                
                if(rt_Map.get(opp.recordTypeID).getName() == 'IAS Business Development' || rt_Map.get(opp.recordTypeID).getName() == 'IS Business Development'){
                    oppList.add(opp);
                    oppZipList.add(opp.Zip_Code__c);
                }
                
                if(opp.Internal_Recruiter_IRD__c != Null){
                    UserId.add(opp.Internal_Recruiter_IRD__c);
                }
                if( opp.Assigned_Recruiter__c != Null){
                    UserId.add(opp.Assigned_Recruiter__c);
                }
                if( opp.Integration_Manager__c != Null){
                    UserId.add(opp.Integration_Manager__c);
                }
                
                if( opp.Zip_Code__c != null)//create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
                {
                    zips.add(opp.Zip_Code__c);
                    c_zips.add('C'+opp.Zip_Code__c);
                    m_zips.add('M'+opp.Zip_Code__c);
                }
                
                if(opp.AccountId != null && oldOppMap == null){
                    accIdUT.add(opp.AccountId);
                }
                
                if(oldOppMap != null){
                    oldOpp = oldOppMap.get(opp.Id);
                    if(oldOpp != null && rt_Map.get(oldOpp.recordTypeID).getName() == 'IAS Business Development'){
                        if(oldOpp.Integration_Manager__c != null && oldOpp.Integration_Manager__c != opp.Integration_Manager__c) {
                            oppUpdateMap.put(oldOpp.Integration_Manager__c, opp);
                        }
                        if(oldOpp.Transition_Support_Partners__c != null && oldOpp.Transition_Support_Partners__c != opp.Transition_Support_Partners__c) {
                            oppUpdateMap.put(oldOpp.Transition_Support_Partners__c, opp);
                        }
                        if(oldOpp.Investment_Transition_Consultant__c!= null && oldOpp.Investment_Transition_Consultant__c != opp.Investment_Transition_Consultant__c) {
                            oppUpdateMap.put(oldOpp.Investment_Transition_Consultant__c, opp);
                        }
                        if(oldOpp.Regional_Transition_Partner__c!= null && oldOpp.Regional_Transition_Partner__c != opp.Regional_Transition_Partner__c) {
                            oppUpdateMap.put(oldOpp.Regional_Transition_Partner__c, opp);
                        }   
                        
                        if((opp.AccountId != null && opp.Total_Advisory_AUM__c  == null) || (opp.AccountId != null && opp.AccountId != oldOppMap.get(opp.Id).AccountId)){
                            accIdUT.add(opp.AccountId);
                        }
                    }
                }
            }
            //To handle email alert Operations
            if(Userid.size() != null && Userid != null){
                MapUser = new Map<Id,User>([select Id, email from user where Id In: Userid limit 3] );
            }
            
            if(accIdUT.size()>0){
                listOfBIF = [select id,name,Account__c,Total_Advisory_AUM__c from Branch_Inst_Financial__c where Account__c In:accIdUT];
            }
            
            if(oppMap != null && oppMap.size() != 0){
                tskList = [Select id, Department__c, OwnerId  from Task where WhatId in: oppMap.keyset() and recordtypeID =: rt];
            }
            
            if(oppUpdateMap != null && oppUpdateMap.size() != 0){
                tskUpdtList  = [select id, OwnerId, Department__c 
                                from Task where WhatId in: oppID
                                and Department__c in ('Onboarding Consultant', 'Transition Support Partners',
                                                      'Investment Transition Partner','Regional Transition Partner') 
                                and OwnerId in: oppUpdateMap.keyset() and RecordTypeID =: rt];
                
            }
            for(Contact con : [Select Id,AccountID, RecordTypeID, Recordtype.Name, Lead_Source__c, Source_Type_Prospect__c, Referral_By__c,
                               Referring_Advisor_Rep_ID__c,Marketing_Classification_Prospect__c, Channel__c, Request_to_join_as__c,
                               Mailer_Code_Prospect__c, Years_in_Industry__c, Licenses__c, Current_Firm__c,
                               HomePhone, Phone, MobilePhone, Fax, Email, Rep_Type__c,AUM_from_other_source__c,
                               MailingStreet, MailingCity, MailingState, MailingPostalCode, WMO_Division__c,/*CH -04*/Insurance_Territory_New__c,
                               DoNotCall, Do_Not_Mail__c, HasOptedOutOfEmail,ELQ_Marketing_Email_Opt_Out__c,Discovery_Contact_Phone__c,Discovery_Contact_Address_1__c,Discovery_Contact_Address_2__c,Discovery_Contact_City__c,Discovery_Contact_State__c
                               ,Assigned_Recruiter__c, Regional_Vp__c,Discovery_Home_Zip__c, Internal_Recruiter_IRD__c, /* CH -01*/Inactive_Reason__c
                               , Highest_Stage_Reached__c,Marketing_Category__c /*CH-16*/
                               from Contact where Id in: conIds]){
                                   conMapUpOp.put(con.ID, con);
                                   cMap.put(con.ID, con);
                                   ConIDObj.put(con.ID, con);
                                   if((con.Rep_Type__c == 'RIA IFA Firm' || con.Rep_Type__c == 'RIA Hybrid Firm') && AccId.Contains(con.AccountID)){
                                       AccIdConId.put(con.AccountId,con.Id);    
                                   }
                                   if(con.Rep_Type__c == 'RIA Hybrid Firm' /*&& oppMap.keyset().Contains(con.AccountId)*/){
                                       conMap.put(con.Id, con); 
                                   }
                                   if(AccId.Contains(con.AccountID)){
                                       conMap.put(con.Id, con); 
                                   }
                                   //Pravin Kale - AIS Logic Optimization
                                   if(con.RecordType.Name != 'Contact Propsect'){
                                       conIdAIS.add(con.ID); 
                                   }
                               }
            //CH-08 Start
            if(Trigger.isBefore) {  
                //CH-08 End
                //Pravin Kale - AIS Logic Optimization : Cahnged the List of IDs exluded the "Contact Prospect" Contacts for processing
                for(LPL_Insurance_Associates__c ia: [Select Contact__c,Insurance_Tier__c,Fixed_Annuity_Segment__c,Variable_Annuity_Segment__c From LPL_Insurance_Associates__c Where (Contact__c in :conIdAIS)]){
                    iaMap.put(ia.Contact__c, ia);
                }
            }
            //Ch-07 Start
            caseList=[Select id,Result__c,Opportunity__c from Case where Opportunity__c in: oppMap.keyset() and Opportunity__c!=null];//CH-07
            if(!caseList.isEmpty()) {
                for(Case c:caseList) {
                    if(c.Opportunity__c!=null) {
                        caseMap.put(c.Id,c);
                    }
                }
            }
            //Ch-07 End
            
            //CH-12 Start - Querying the Email ids of the IRD user and the Assigned Recruiter
            if(Trigger.isAfter) {
                if(oppMap.size()>0) {
                    oppListNew=[Select id, Internal_Recruiter_IRD__c ,Assigned_Recruiter__c, Internal_Recruiter_IRD__r.Email, Assigned_Recruiter__r.Email from Opportunity where id in:oppMap.keyset()];
                }
                if(oppListNew.size()>0 && oppListNew!=null) {
                    for(Opportunity opp:oppListNew) {
                        oppMapnew.put(opp.Internal_Recruiter_IRD__c,opp.Internal_Recruiter_IRD__r.Email);
                        oppMapNewAssignRec.put(opp.Assigned_Recruiter__c,opp.Assigned_Recruiter__r.Email);
                    }
                }
            }
            //CH-12 End - Querying the Email ids of the IRD user and the Assigned Recruiterzips
            
            //CH-19 - start
            String zip;
            if(iaConId!=null && iaConId.size()>0){
                
                for(ID contactID: iaConId){
                    if(conMapUpOp.containsKey(contactID) && conMapUpOp.get(contactID).Discovery_Home_Zip__c!=Null){
                        zip=conMapUpOp.get(contactID).Discovery_Home_Zip__c;
                        newzipList.add(zip);
                    }
                    //CH-22 -start
                    if(conMapUpOp.containsKey(contactID) && conMapUpOp.get(contactID).MailingPostalCode!=Null){
                        zip=conMapUpOp.get(contactID).MailingPostalCode;
                        newzipList.add(zip);
                    }
                    //CH-22 -end
                    
                }
                List<IAS_Recruiter_Assignment__c> iasList = [Select Name,region__c from IAS_Recruiter_Assignment__c
                                                             where name in :newzipList];
                if(iasList!=null && iasList.size()>0){
                    for(IAS_Recruiter_Assignment__c ias : iasList ) {
                        zipMap.put(ias.name,ias);
                    }
                }
            }
            //CH-19 - END 
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    public void doInsertOperation(Opportunity newOpp){
        try{
            Map<Id, Opportunity> oldOppMap = new Map<ID, Opportunity>();
            oldOppMap = null;
            List<Opportunity> newOppList = new List<Opportunity>();
            newOppList.add(newOpp);
            
            List<CampaignMember> campID= new List<CampaignMember>([SELECT Id,CampaignId,Campaign.IsActive,contactId FROM CampaignMember WHERE ContactId in (Select id from contact where id in:conids and Recordtype.Name='Contact prospect') order by Createddate DESC LIMIT 1]);
            
            for(Opportunity o : newOppList){
                if(campID.size()>0){
                    if(campID[0].Campaign.IsActive!=False)
                        o.CampaignId=campID[0].CampaignId;
                }
            }
            //CH-20 start
            Contact c;
            if(conMapUpOp.containsKey(newOpp.Contact__c)){
                c = conMapUpOp.get(newOpp.Contact__c);
            }
            if(c!=null && !String.isEmpty(c.channel__c)){
                newOpp.Channel__c = c.channel__c;
            }
            if(c!=null && !String.isEmpty(c.request_to_join_as__c)){
                newOpp.Request_To_Join_As__c = c.request_to_join_as__c;
            }
            //CH-20 end
            /****************CH-13 - Start - Update Opportunity Owner with Assigned Recruiter*****************/
            
            if (newOpp.recordTypeID == IASBD){
                if(newOpp.Assigned_Recruiter__c != null){
                    newOpp.OwnerId = newOpp.Assigned_Recruiter__c;
                }
                
            }
            
                 if(newOpp.Contact__c!=null && conMapUpOp.size()>0  && conMapUpOp.get(newOpp.Contact__c).AUM_from_other_source__c !=newOpp.AUM__c && newOpp.StageName!='Closed-Joined' && newOpp.StageName!='Closed-Lost' )     
                {      
                    conMapUpOp.get(newOpp.Contact__c).AUM_from_other_source__c = newOpp.AUM__c;         
                } 
            /****************CH-13 - End - Update Opportunity Owner with Assigned Recruiter*****************/
            if( newOpp.RecordTypeId == oppRIAID && conMap.containsKey(newOpp.Contact__c)) {   
                newOpp.Firm_Contact__c= conMap.get(newOpp.Contact__c).ID; 
            } 
            
            if( newOpp.RecordTypeId == oppInsuranceID && conMap.size() > 0 && conMap.containsKey(newOpp.Contact__c)){   
                
                        if(conMap.get(newOpp.Contact__c).WMO_Division__c !=null)
                  newOpp.LPL_Region__c = conMap.get(newOpp.Contact__c).WMO_Division__c;                        
               
                ConId.add(newOpp.Contact__C);
                OppIdConId.put(newOpp.Contact__C, newOpp);
            }
            //CH-15 - start
            if(newOpp.recordTypeID == IASBD && conMapUpOp.size() > 0 && conMapUpOp.get(newOpp.Contact__c)!=null){
                newOpp.Assigned_Recruiter__c = conMapUpOp.get(newOpp.Contact__c).Assigned_Recruiter__c;
                newOpp.Regional_Vp__c = conMapUpOp.get(newOpp.Contact__c).Regional_Vp__c;
                newOpp.Internal_Recruiter_IRD__c = conMapUpOp.get(newOpp.Contact__c).Internal_Recruiter_IRD__c;
                //CH-19 - start
                String contactHomeZipcode=conMapUpOp.get(newOpp.Contact__c).Discovery_Home_Zip__c;
                String mailingPostalZipCode=conMapUpOp.get(newOpp.Contact__c).MailingPostalCode;
                
                if(contactHomeZipcode!=null && contactHomeZipcode!=''){
                    if(zipMap.get(contactHomeZipcode)!=null)
                        newOpp.Region__c=zipMap.get(contactHomeZipcode).Region__c;
                }
                //CH-19 - end
                //CH-22 - start
                else if(mailingPostalZipCode!=null && mailingPostalZipCode!=''){
                    if(zipMap.get(mailingPostalZipCode)!=null)
                        newOpp.Region__c=zipMap.get(mailingPostalZipCode).Region__c;
                }
                else{
                    newOpp.Region__c = null;
                }
                //CH-22 - end
            }
            //CH-15 - end
            if(oppMap.size() != 0 && oppMap != null && newOpp.RecordTypeId == oppInsuranceID){
                assignnFirmID(oppMap);
            }
            if( newOpp.StageName != NULL && newOpp.StageName == '4 - Meeting'){
                newOpp.Stage_4_Changed_Date__c = System.today();
            }
            
            if( newOpp.Revenue_Verification_Status__c != NULL && newOpp.Revenue_Verification_Status__c == 'Revenue Submitted'){
                newOpp.Revenue_Received__c = System.today();
            }
            if(newOpp.Revenue_Verification_Status__c != NULL && newOpp.Revenue_Verification_Status__c == 'Revenue Approved'){
                newOpp.Revenue_Approved__c = System.today();  
            }
            if(rt_Map.get(newOpp.recordTypeID).getName() == 'IAS Business Development' 
               || rt_Map.get(newOpp.recordTypeID).getName() == 'IS Business Development'){
                   handler.updateEntryExitFieldsonOpportunity(newOppList, oldOppMap);
               }
            opi.add(newOpp);
            
            if(conMapUpOp.size() != 0){
                handler.updateConOppFields(conMapUpOp, newOppList);
            }
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    public void doAfterInsertActivity(Opportunity newOpp){
        try{
            Map<Id, Opportunity> oldOppMap = new Map<ID, Opportunity>();
            oldOppMap = null;
            List<Opportunity> newOppList = new List<Opportunity>();
            newOppList.add(newOpp);
            
            if(oppList.size() != 0 && rt_Map.get(newOpp.recordTypeID).getName() == 'IAS Business Development'){
                insertList = handler.createOpportunityActivity(newOppList, oldOppMap, tskList);
            }
            
            //  start CH-14    Added Target_TAT_Date__c!=null due to this requirement SD974439 - Opporturnity Target TAT Date
            if(newOpp.Target_TAT_Date__c!=null && newOpp.Internal_Recruiter_IRD__c!=null && newOpp.Acquisition__c!='Jaguar' && String.isNotBlank(String.valueOf(newOpp.Internal_Recruiter_IRD__c)) && newOpp.StageName=='3 - Submitted a Kit' && newOpp.Expected_AUM__c>0 && newOpp.Channel_Owner__c=='IAS') {
                // End CH-14      
                String strOppName=newOpp.Name;
                Task taskIRDuser=new Task();
                taskIRDuser.OwnerId=newOpp.Internal_Recruiter_IRD__c;
                taskIRDuser.Subject='Contract Accommodation';
                taskIRDuser.ActivityDate=System.today();
                taskIRDuser.Status='Not Started';
                taskIRDuser.Priority='High';
                taskIRDuser.WhatId=newOpp.Id;
                newTaskList.add(taskIRDuser);
                
                //CH-12 Start - Here if the condition matches, IRD and Assigned Recruiter will get an email 
                if(oppMapnew.size()>0 && oppMapnew !=null) {
                    if(oppMapnew.get(newOpp.Internal_Recruiter_IRD__c)!=null) {
                        emailSendList.add(oppMapnew.get(newOpp.Internal_Recruiter_IRD__c));
                    }
                }
                
                if(newOpp.Assigned_Recruiter__c!=null){
                    if(oppMapNewAssignRec.size()>0 && oppMapNewAssignRec!=null) {
                        if(oppMapNewAssignRec.get(newOpp.Assigned_Recruiter__c)!=null) {
                            emailSendList.add(oppMapNewAssignRec.get(newOpp.Assigned_Recruiter__c));            
                        }
                    }
                }
                
                if(emailSendList.size()>0){
                    LPL_OpportunityTriggerGateway.emailToARandIRD(emailSendList, strOppName);
                }
                //CH-12 End - Here if the condition matches, IRD and Assigned Recruiter will get an email 
            }         
            //Ch-10 End
            
            /**********************************************CH-16 - Start***************************************/
            if(newOpp.RecordTypeId == IASBD && (newOpp.StageName == '1 - Engaged' || newOpp.StageName == '2 - Hot List' ||
                                                newOpp.StageName == '3 - Submitted a Kit')){
                                                    if(newOpp.Contact__c!=null && conMapUpOp.get(newOpp.Contact__c).RecordTypeID == conRecordTypeId){
                                                        if(conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c == null){
                                                            conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = newOpp.StageName;
                                                        }
                                                        
                                                        else if(conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != null){
                                                            if(newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c && newOpp.StageName == '3 - Submitted a Kit') {
                                                                conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '3 - Submitted a Kit';
                                                            }
                                                            else if(newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '3 - Submitted a Kit'  && newOpp.StageName == '2 - Hot List') {
                                                                conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '2 - Hot List';
                                                            }
                                                            else if(newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '3 - Submitted a Kit' && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '2 - Hot List' && newOpp.StageName == '1 - Engaged') {
                                                                conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '1 - Engaged';
                                                            }
                                                        }
                                                        if(conMapUpOp.get(newOpp.Contact__c).Lead_Source__c !=null && conMapUpOp.get(newOpp.Contact__c).Marketing_Category__c =='Dormant')
                                                        {
                                                            conMapUpOp.get(newOpp.Contact__c).Lead_Source__c = 'Transitions'; System.debug('Lead source chganged to Transitions1');
                                                        }
                                                        conInsert.add(conMapUpOp.get(newOpp.Contact__c));
                                                    }  
                                                }
            /**********************************************CH-16 - End***************************************/
            // CH-17 - Start
            if(newOpp.Contact__c!=null && newOpp.RecordTypeId == IASBD && conMapUpOp.containsKey(newOpp.Contact__c) 
               && conMapUpOp.get(newOpp.Contact__c).RecordTypeID == conLPLTypeId){
                   if(newOpp.Self_Identified_Gender__c!=null){
                       conMapUpOp.get(newOpp.Contact__c).Self_Identified_Gender__c = newOpp.Self_Identified_Gender__c; 
                   }
                   if(newOpp.Self_Identified_Military_Service__c!=null){
                       conMapUpOp.get(newOpp.Contact__c).Self_Identified_Military_Service__c = newOpp.Self_Identified_Military_Service__c; 
                   }
                   if(newOpp.Self_Identified_Race_Ethnicity__c!=null){
                       conMapUpOp.get(newOpp.Contact__c).Self_Identified_Race_Ethnicity__c = newOpp.Self_Identified_Race_Ethnicity__c; 
                   }
                   
                
               }
            else{}     //do nothing
            
            // CH-17 - end
            if(conMapUpOp.containsKey(newOpp.Contact__c) && conMapUpOp.get(newOpp.Contact__c) != null){
                conUpdate.add(conMapUpOp.get(newOpp.Contact__c));
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_OpportunityTriggerGateway','doAfterInsertActivity',e.getMessage(),e.getLineNumber(),e.getTypeName());   
        }
    }
    
    public void assignnFirmID(Map<ID, Opportunity> oppMap){
        try{
            for (Id OppId: oppMap.keySet()){        
                if(AccIdConId.containsKey(oppMap.get(OppId).accountId)){
                    oppMap.get(OppId).Firm_Contact__c=AccIdConId.get(oppMap.get(OppId).accountId);
                }
            }
            if(ConIds.size() != 0 && ConIds != null){
                if(ConIDObj.containsKey(OppIdConId.get(conIds[0]).Contact__c)){
                    if (ConIDObj.get(conIds[0]).WMO_Division__c != null) {
                        OppIdConId.get(conIds[0]).LPL_Region__c=ConIDObj.get(conIds[0]).WMO_Division__c ;  
                          }                                       
               /*     else {
                    OppIdConId.get(conIds[0]).addError('Please provide value of Insurance Territory on Contact, Insurance Territory on contact can not blank'); 
                    OppIdConId.get(conIds[0]).accountId=ConIDObj.get(conIds[0]).accountId ;
                    } */
                    if(iaMap.containsKey(OppIdConId.get(conIds[0]).contact__c)){
                        OppIdConId.get(conIds[0]).Variable_Annuity_Segment__c=iaMap.get(conIds[0]).Variable_Annuity_Segment__c;
                        OppIdConId.get(conIds[0]).Insurance_Segment__c=iaMap.get(conIds[0]).Insurance_Tier__c;
                        OppIdConId.get(conIds[0]).Fixed_Annuity_Segment__c=iaMap.get(conIds[0]).Fixed_Annuity_Segment__c;
                    }
                }
            }
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }

public void updateAUM(List<Opportunity> newOpp, List<Opportunity> oldOpp){
    try {
        set<Id> conidsset=new set<id>();
        
        for(Opportunity opp:newOpp){
            conidsset.add(opp.Contact__c);
        }
        //conMapUpOp.get(newOpp.Contact__c).AUM_from_other_source__c = newOpp.AUM__c;
        if(conidsset.size()>0)
        Map<id,contact> conMap=New Map<id,contact>([select id,AUM_from_other_source__c from contact where Id IN:conidsset]);
        
        if(!conMap.isEmpty()){
            for(Opportunity opp:newOpp){
                if(Opp.StageName!='Closed-Joined' && Opp.StageName !='Closed-Lost' && Opp.AUM__c==null){
                    if(conMap.containsKey(Opp.Contact__c))
                    Opp.AUM__c=conMap.get(Opp.Contact__c).AUM_from_other_source__c;
                }
        }
        }
        
        
    }catch (exception e){
        
    }

}
    
    public void doUpdateOperation(Opportunity newOpp, Opportunity oldOpp){
        try{
            Map<Id, Opportunity> oldOppMap = new Map<ID, Opportunity>();
            oldOppMap.put(oldOpp.ID, oldOpp);
            List<Opportunity> newOppList = new List<Opportunity>();
            newOppList.add(newOpp);
            //CH-22-start
            if(newOpp.recordTypeID == IASBD){
                String contactHomeZipcode=null;
                String mailingPostalZipCode=null;
                if(conMapUpOp.get(newOpp.Contact__c)!=null){
                    contactHomeZipcode=conMapUpOp.get(newOpp.Contact__c).Discovery_Home_Zip__c;
                    mailingPostalZipCode=conMapUpOp.get(newOpp.Contact__c).MailingPostalCode;
                }
                if(contactHomeZipcode!=null && contactHomeZipcode!=''){
                    if(zipMap.get(contactHomeZipcode)!=null)
                        newOpp.Region__c=zipMap.get(contactHomeZipcode).Region__c;
                }
                else if(mailingPostalZipCode!=null && mailingPostalZipCode!=''){
                    if(zipMap.get(mailingPostalZipCode)!=null)
                        newOpp.Region__c=zipMap.get(mailingPostalZipCode).Region__c;
                }
                else{
                    newOpp.Region__c = null;
                }
            }
            //CH-22 - end
            
            
            if( newOpp.RecordTypeId == oppInsuranceID && newOpp.Contact__c != oldOpp.Contact__c && conMap.containsKey(newOpp.Contact__c)){   
                if(conMap.get(newOpp.Contact__c).WMO_Division__c != null)
                newOpp.LPL_Region__c = conMap.get(newOpp.Contact__c).WMO_Division__c;              
                
                ConId.add(newOpp.Contact__C); 
            }
            if(oppMap.size() != 0 && oppMap != null && newOpp.RecordTypeId == oppInsuranceID){
                assignnFirmID(oppMap);
            } 
            
            If(newOpp.Contact__c != oldOpp.Contact__c || newOpp.Assigned_Recruiter__c == null) {
                opp.add(newOpp.Id);
                opc.put(newOpp.Id, newOpp.Contact__c);
            } 
            
            if(newOpp.StageName != oldOpp.StageName && newOpp.StageName == '4 - Meeting' && newOpp.StageName != NULL){
                newOpp.Stage_4_Changed_Date__c = System.today();
            }
            
            if((newOpp.Revenue_Verification_Status__c != oldOpp.Revenue_Verification_Status__c) && newOpp.Revenue_Verification_Status__c == 'Revenue Submitted' 
               && newOpp.Revenue_Verification_Status__c != NULL){
                   newOpp.Revenue_Received__c = System.today();
               }
            if((newOpp.Revenue_Verification_Status__c != oldOpp.Revenue_Verification_Status__c) && newOpp.Revenue_Verification_Status__c == 'Revenue Approved' 
               && newOpp.Revenue_Verification_Status__c != NULL){
                   newOpp.Revenue_Approved__c = System.today();  
               }      
            
            If(newOpp.Contact__c != null){
                con.add(newOpp.Contact__c);
            }
            if(newOpp.GRC_Status__c != oldOpp.GRC_Status__c || newOpp.Review_Status__c != oldOpp.Review_Status__c){
                handler.updateEntryExitFieldsonOpportunity(newOppList, oldOppMap);
            }
            
            /****************CH-13 - Start - Update Opportunity Owner with Assigned Recruiter*****************/
            if (newOpp.recordTypeID == IASBD){
                if(newOpp.Assigned_Recruiter__c != null){
                    newOpp.OwnerId = newOpp.Assigned_Recruiter__c;
                }
            }
            
            /****************CH-13 - End - Update Opportunity Owner with Assigned Recruiter*****************/
            conIds.add(newOpp.Contact__c);
            opi.add(newOpp);
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_OpportunityTriggerGateway','doUpdateOperation',e.getMessage(),e.getLineNumber(),e.getTypeName());   
        }
    }
    
    public void prepareUpdateOppOperation(Opportunity newOpp, Opportunity oldOpp, boolean isUpdate){
        try{
            boolean isUpdate1 = isUpdate;
            oldOppMap.put(oldOpp.ID, oldOpp);
            List<Opportunity> newOppList = new List<Opportunity>();
            newOppList.add(newOpp);
            
            if(conMapUpOp.size() != 0 && isUpdate == false){
                handler.updateConOppFields(conMapUpOp, newOppList);
            } 
            If(opp.size()>0) {
                
                If( newOpp.RecordTypeId == IASBD) {
                    If(newOpp.Contact__c != null && isUpdate1 ) {
                        newOpp.Home_Phone__c = cMap.get(newOpp.Contact__c).HomePhone;
                        if(cMap.get(newOpp.Contact__c).Phone!=null){
                            newOpp.Work_Phone__c = cMap.get(newOpp.Contact__c).Phone;
                        }
                        else{
                            
                            newOpp.Work_Phone__c = cMap.get(newOpp.Contact__c).Discovery_Contact_Phone__c;
                            newOpp.Mobile__c = cMap.get(newOpp.Contact__c).MobilePhone;
                            newOpp.Fax__c = cMap.get(newOpp.Contact__c).Fax;
                            newOpp.Email__c = cMap.get(newOpp.Contact__c).Email;
                        }    
                        if(cMap.get(newOpp.Contact__c).MailingStreet != null){
                            newOpp.Home_Address__c = cMap.get(newOpp.Contact__c).MailingStreet;
                        }else{
                            newOpp.Home_Address__c = cMap.get(newOpp.Contact__c).Discovery_Contact_Address_1__c;
                        }    
                        if(cMap.get(newOpp.Contact__c).MailingCity!= null){
                            newOpp.City__c = cMap.get(newOpp.Contact__c).MailingCity;
                        }else{
                            newOpp.City__c = cMap.get(newOpp.Contact__c).Discovery_Contact_City__c;
                        }    
                        if(cMap.get(newOpp.Contact__c).MailingState!= null){
                            newOpp.State__c = cMap.get(newOpp.Contact__c).MailingState;
                        }else{
                            newOpp.State__c = cMap.get(newOpp.Contact__c).Discovery_Contact_State__c;
                            newOpp.Zip_Code__c = cMap.get(newOpp.Contact__c).MailingPostalCode;
                            newOpp.Do_Not_Call__c = cMap.get(newOpp.Contact__c).DoNotCall;
                            newOpp.Do_Not_Mail__c = cMap.get(newOpp.Contact__c).Do_Not_Mail__c;
                            newOpp.Email_Opt_Out__c = cMap.get(newOpp.Contact__c).HasOptedOutOfEmail;
                            newOpp.ELQ_Marketing_Email_Opt_Out__c = cMap.get(newOpp.Contact__c).ELQ_Marketing_Email_Opt_Out__c;
                        }
                    }
                }
            } 
            /*  CH -01 Start Process builder requirement convert into Trigger.*/
            if(newOpp.StageName=='Closed-Lost'&&newOpp.Lost_outcome__c!=null&& newOpp.Contact__c != null&&isUpdate  
               && oldOpp.StageName !=newOpp.StageName) {
                   //Ch-23 Starts
                   if( newOpp.Lost_outcome__c=='Compliance Reason' ) {
                       cMap.get(newOpp.Contact__c).Inactive_Reason__c= 'Inactive - Compliance';
                   }
                   else if( newOpp.Lost_outcome__c=='Joined Another Firm') {
                       cMap.get(newOpp.Contact__c).Inactive_Reason__c= 'Inactive - Joined Another Firm';
                   }
                   else if( newOpp.Lost_outcome__c=='Stayed with Current Firm' ) {
                       cMap.get(newOpp.Contact__c).Inactive_Reason__c= 'Inactive - Stayed with Current Firm';
                   }
                   else if( newOpp.Lost_outcome__c=='Not a Good Fit' ) {
                       cMap.get(newOpp.Contact__c).Inactive_Reason__c= 'Inactive - Not a Good Fit';
                   }else if( newOpp.Lost_outcome__c=='Unknown' ) {
                       cMap.get(newOpp.Contact__c).Inactive_Reason__c= 'Known- Prospect';
                   }else{
                       cMap.get(newOpp.Contact__c).Inactive_Reason__c=newOpp.Lost_outcome__c;
                   }
                   
                   //Ch-23 Ends
                   contactOnIdMap.put(newOpp.Contact__c,cMap.get(newOpp.Contact__c));
               }
            
            if(rt_Map.get(newOpp.recordTypeID).getName().containsIgnoreCase('IAS Business Development') || rt_Map.get(newOpp.recordTypeID).getName() == 'IS Business Development'){
                if(newOpp.Integration_Manager__c != oldOpp.Integration_Manager__c){
                    oppUpdateMap.put(oldOpp.Integration_Manager__c, newOpp);
                    oppID.add(newOpp.ID);
                    oppTaskMap.put('Onboarding Consultant', newOpp.Integration_Manager__c);
                }
                if(newOpp.Transition_Support_Partners__c!= oldOpp.Transition_Support_Partners__c){
                    oppUpdateMap.put(oldOpp.Transition_Support_Partners__c, newOpp);
                    oppID.add(newOpp.ID);
                    oppTaskMap.put('Transition Support Partners', newOpp.Transition_Support_Partners__c);
                } 
                if(newOpp.Investment_Transition_Consultant__c!= oldOpp.Investment_Transition_Consultant__c){
                    oppUpdateMap.put(oldOpp.Investment_Transition_Consultant__c, newOpp);
                    oppID.add(newOpp.ID);
                    oppTaskMap.put('Investment Transition Partner', newOpp.Investment_Transition_Consultant__c);
                } 
                if(newOpp.Regional_Transition_Partner__c!= oldOpp.Regional_Transition_Partner__c){
                    oppUpdateMap.put(oldOpp.Regional_Transition_Partner__c, newOpp);
                    oppID.add(newOpp.ID);
                    oppTaskMap.put('Regional Transition Partner', newOpp.Regional_Transition_Partner__c);
                }  
                
                if((newOpp.Regional_Transition_Partner__c!= null &&  (oldOpp.Regional_Transition_Partner__c == null || oldOpp.Regional_Transition_Partner__c != null))
                   || (newOpp.Investment_Transition_Consultant__c != null &&  (oldOpp.Investment_Transition_Consultant__c == null || oldOpp.Investment_Transition_Consultant__c != null ))
                   || (newOpp.Transition_Support_Partners__c != null &&  (oldOpp.Transition_Support_Partners__c == null || oldOpp.Transition_Support_Partners__c != null))
                   || (newOpp.Integration_Manager__c != null &&  (oldOpp.Integration_Manager__c == null || oldOpp.Integration_Manager__c != null) ) ){
                       newOppTaskList.add(newOpp);
                   }
            }
            
            if(oppUpdateMap.size() != 0 && isUpdate == true){
                updateList = handler.updateOpportunityActivity(oppUpdateMap, oppID, oppTaskMap, tskUpdtList);
            }
            
            if(newOppTaskList.size() != 0 && rt_Map.get(newOpp.recordTypeID).getName() == 'IAS Business Development' && Trigger.isafter /*CH-09 - Added by Pravin Kale*/) {
                insertList = handler.createOpportunityActivity(newOppTaskList, oldOppMap, tskList);
            }
            
            if(newOpp.StageName=='3 - Submitted a Kit') {
                for(Case cc:caseMap.values()) {
                    if(cc.Opportunity__c==newOpp.Id){
                        caseMap.get(cc.id).Result__c='Kit received';
                        
                        //CH-09 START      Here we are checking Oppotunity field and then it will be assignd to case fields.
                        if(newOpp.MAX_TA_Dollars_Allowed__c!=Null && oldOpp.MAX_TA_Dollars_Allowed__c!=newOpp.MAX_TA_Dollars_Allowed__c) {
                            caseMap.get(cc.id).MAX_TA_Dollars_Allowed__c=newOpp.MAX_TA_Dollars_Allowed__c;
                        }
                        
                        if(newOpp.Offer_Letter_Sent__c!=Null && oldOpp.Offer_Letter_Sent__c!=newOpp.Offer_Letter_Sent__c) {
                            caseMap.get(cc.id).Offer_Letter_Sent__c=newOpp.Offer_Letter_Sent__c;
                        }
                        
                        if(newOpp.Signed_offer_Letter_Received__c!=Null && oldOpp.Signed_offer_Letter_Received__c!=newOpp.Signed_offer_Letter_Received__c) {   
                            caseMap.get(cc.id).Signed_offer_Letter_Received__c=newOpp.Signed_offer_Letter_Received__c;
                        }
                        //CH-09 END
                        UpdatedCaseList.add(cc);
                    }
                }
            }
            else {  //CH-09 START
                if(newOpp.MAX_TA_Dollars_Allowed__c!=Null || newOpp.Offer_Letter_Sent__c!=Null || newOpp.Signed_offer_Letter_Received__c!=Null) {
                    for(Case cc:caseMap.values()) {
                        if(cc.Opportunity__c==newOpp.Id) {
                            if(newOpp.MAX_TA_Dollars_Allowed__c!=Null && oldOpp.MAX_TA_Dollars_Allowed__c!=newOpp.MAX_TA_Dollars_Allowed__c) {
                                caseMap.get(cc.id).MAX_TA_Dollars_Allowed__c=newOpp.MAX_TA_Dollars_Allowed__c;
                            }
                            
                            if(newOpp.Offer_Letter_Sent__c!=Null && oldOpp.Offer_Letter_Sent__c!=newOpp.Offer_Letter_Sent__c) {
                                caseMap.get(cc.id).Offer_Letter_Sent__c=newOpp.Offer_Letter_Sent__c;
                            }
                            
                            if(newOpp.Signed_offer_Letter_Received__c!=Null && oldOpp.Signed_offer_Letter_Received__c!=newOpp.Signed_offer_Letter_Received__c) {   
                                caseMap.get(cc.id).Signed_offer_Letter_Received__c=newOpp.Signed_offer_Letter_Received__c;
                            }
                            UpdatedCaseList.add(cc);
                        }
                    }
                }
                //CH-09 END
            }
            // CH-10 START Here creates a task when IRD user
            if(trigger.isAfter && trigger.isUpdate){
                //////start CH-20
                if(conMapUpOp.containsKey(newOpp.Contact__c) && newOpp.Contact__c!=null){
                    if(newOpp.Channel__c!=null){
                        conMapUpOp.get(newOpp.Contact__c).Channel__c = newOpp.Channel__c;
                    }
                    if(newOpp.Request_To_Join_As__c!=null){
                        conMapUpOp.get(newOpp.Contact__c).Request_to_join_as__c = newOpp.Request_To_Join_As__c;
                    }
                }
                //////END CH-20
                
                //  start CH-14   Added Target_TAT_Date__c!=null due to this requirement SD974439 - Opporturnity Target TAT Date
                if( newOpp.Target_TAT_Date__c!=null && newOpp.Internal_Recruiter_IRD__c!=null && newOpp.Acquisition__c!='Jaguar' && String.isNotBlank(String.valueOf(newOpp.Internal_Recruiter_IRD__c)) && newOpp.StageName=='3 - Submitted a Kit' && newOpp.Expected_AUM__c>0 && newOpp.Channel_Owner__c=='IAS' && (newOpp.Internal_Recruiter_IRD__c!=oldOpp.Internal_Recruiter_IRD__c || newOpp.StageName!=oldOpp.StageName || newOpp.Expected_AUM__c!=oldOpp.Expected_AUM__c || newOpp.Channel_Owner__c!=oldOpp.Channel_Owner__c ||newOpp.Acquisition__c!=oldOpp.Acquisition__c)) {
                    // End Ch-14 
                    String strOppName=newOpp.Name; 
                    Task taskIRDusers=new Task();
                    taskIRDusers.OwnerId=newOpp.Internal_Recruiter_IRD__c;
                    taskIRDusers.Subject='Contract Accommodation';
                    taskIRDusers.ActivityDate=System.today();
                    taskIRDusers.Status='Not Started';
                    taskIRDusers.Priority='High';
                    taskIRDusers.WhatId=newOpp.Id;
                    newTaskList.add(taskIRDusers);  
                    //CH-12 Start - Here if the condition matches, IRD and Assigned Recruiter will get an email 
                    if(oppMapnew.size()>0 && oppMapnew !=null) {
                        if(oppMapnew.get(newOpp.Internal_Recruiter_IRD__c)!=null) {
                            emailSendList.add(oppMapnew.get(newOpp.Internal_Recruiter_IRD__c));
                        }
                    }
                    
                    if(oppMapNewAssignRec.size()>0 && oppMapNewAssignRec!=null) {
                        if(oppMapNewAssignRec.get(newOpp.Assigned_Recruiter__c)!=null) {
                            emailSendList.add(oppMapNewAssignRec.get(newOpp.Assigned_Recruiter__c));
                        }
                    }
                    if(!emailSendList.isEmpty()&&emailSendList.size()>0){
                        LPL_OpportunityTriggerGateway.emailToARandIRD(emailSendList,strOppName);
                    }
                    
                    //CH-12 End - Here if the condition matches, IRD and Assigned Recruiter will get an email 
                }
                
                // CH-10 END
                /**********************************************CH-16 - Start***************************************/
                
                if(newOpp.RecordTypeId == IASBD && (newOpp.StageName == '1 - Engaged' || newOpp.StageName == '2 - Hot List' || newOpp.StageName == '3 - Submitted a Kit')){
                    if(newOpp.Contact__c!=null && conMapUpOp.containskey(newOpp.Contact__c) &&conMapUpOp.get(newOpp.Contact__c).RecordTypeID == conRecordTypeId){
                        if(conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c == null){
                            conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = newOpp.StageName;
                        }
                        else if(conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != null){
                            if(newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c && oldOpp.StageName != newOpp.StageName && newOpp.StageName == '3 - Submitted a Kit') {
                                conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '3 - Submitted a Kit';
                            }
                            else if(newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c && oldOpp.StageName != newOpp.StageName && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '3 - Submitted a Kit'  && newOpp.StageName == '2 - Hot List') {
                                conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '2 - Hot List';
                            }
                            else if(newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c && oldOpp.StageName != newOpp.StageName && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '3 - Submitted a Kit' && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '2 - Hot List' && newOpp.StageName == '1 - Engaged') {
                                conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '1 - Engaged';
                            }
                        }
                        if(conMapUpOp.get(newOpp.Contact__c).Lead_Source__c !=null && conMapUpOp.get(newOpp.Contact__c).Marketing_Category__c =='Dormant'){
                            conMapUpOp.get(newOpp.Contact__c).Lead_Source__c = 'Transitions'; System.debug('Lead source chganged to Transitions2');
                        }
                    }
                }  
                
                //CH-17  - start  
                if(newOpp.Contact__c!=null && newOpp.RecordTypeId == IASBD && conMapUpOp.containskey(newOpp.Contact__c) && conMapUpOp.get(newOpp.Contact__c).RecordTypeID == conLPLTypeId){
                    if(newOpp.Self_Identified_Gender__c!=null){
                        conMapUpOp.get(newOpp.Contact__c).Self_Identified_Gender__c = newOpp.Self_Identified_Gender__c; 
                    }
                    if(newOpp.Self_Identified_Military_Service__c!=null){
                        conMapUpOp.get(newOpp.Contact__c).Self_Identified_Military_Service__c = newOpp.Self_Identified_Military_Service__c; 
                    }
                    if(newOpp.Self_Identified_Race_Ethnicity__c!=null){
                        conMapUpOp.get(newOpp.Contact__c).Self_Identified_Race_Ethnicity__c = newOpp.Self_Identified_Race_Ethnicity__c; 
                    }
                    //convalue.add(conMapUpOp.get(newOpp.Contact__c));
                }
                else{
                    //do nothing
                }
                    //Start CH-27
                            string IgnoreUser = System.Label.LPL_Ignore_Users;
              
                if( newOpp.AUM__c != oldOpp.AUM__c && (oldOpp.StageName=='Closed-Joined' || oldOpp.StageName=='Closed-Lost' )  && !IgnoreUser.contains(string.valueOf(UserInfo.getUserId()))){//Ends
                newOpp.addError('AUM value cannot be changed in closed status');
                }
                
                //AMIT'S CHANGE STARTS 01-26-2019  
                if(newOpp.Contact__c!=null && conMapUpOp.size()>0  && conMapUpOp.get(newOpp.Contact__c).AUM_from_other_source__c !=newOpp.AUM__c && oldOpp.StageName!='Closed-Joined' && oldOpp.StageName!='Closed-Lost')     
                {      
                    conMapUpOp.get(newOpp.Contact__c).AUM_from_other_source__c = newOpp.AUM__c;         
                }  
                
                // AMIT'S CHANGE ends 01-26-2019
                
                if(conMapUpOp.containsKey(newOpp.Contact__c) && conMapUpOp.get(newOpp.Contact__c) != null){
                    conUpdate.add(conMapUpOp.get(newOpp.Contact__c));
                }
            }
        }
        //CH-17  - end 
        /**********************************************CH-16 - End***************************************/
        catch(Exception e){
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    public void FinalOfferStatusTrigger(Map<ID, Opportunity> NewMapOpp ,Map<ID, Opportunity> OldMapOpp){
        if (!loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c){
            Set<Id> appsIds = new Set<Id>();
            for(Id key : NewMapOpp.keyset()){
                /* Changing logic with checkbox data type */
                if(OldMapOpp.get(key).Final_Offer_Submitted__c == false && NewMapOpp.get(key).Final_Offer_Submitted__c == true) 
                {
                    /* Defensive check against recursive call */
                    if(OldMapOpp.get(key).Final_Offer_Status__c == NewMapOpp.get(key).Final_Offer_Status__c) {
                        appsIds.add(NewMapOpp.get(key).Application__c);
                    }
                }
            }
            
            if(appsIds.size() > 0){
                List<genesis__Applications__c> apps = [SELECT Id, Name, genesis__Status__c
                                                       FROM genesis__Applications__c
                                                       WHERE isParentApplication__c = true AND Id IN :appsIds ];
                
                if(apps != null && apps.size() > 0) {
                    List<genesis__Applications__c> appsToUpdate = new List<genesis__Applications__c>();
                    for(genesis__Applications__c app : apps) {
                        app.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_FINAL_OFFER_INITIATED;
                        appsToUpdate.add(app);
                    }
                    
                    if(appsToUpdate.size() > 0) {
                        UPDATE appsToUpdate;
                    }
                }
            } 
        }
    }
    
    public void checkValidation(Opportunity newOpp){
        try{
            if(conMapUpOp.size()>0 && newOpp.Contact__c!=null && conMapUpOp.containsKey(newOpp.Contact__c) && (conMapUpOp.get(newOpp.Contact__c).Lead_Source__c == null || conMapUpOp.get(newOpp.Contact__c).Source_Type_Prospect__c== null)){
                newOpp.addError('Please fill Lead Source and Source Type on selected Contact');
            }
        }catch(Exception e){
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    public void handleEmailOperation(List<opportunity> Lstopp,Map<Id,opportunity> Oldmap,Boolean Isupdatevalue){
        try{
            if(MapUser.size() != 0){
                Opportunity_EmailHandler.EmailsHandler(Lstopp, Oldmap, Isupdatevalue, MapUser);    
            }
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
    }
    
    public static void emailToARandIRD(List<String> emailstoSend,String strOppNameForEmail) {
        
        if(emailstoSend.size()>0 && emailstoSend!=null) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = emailstoSend;
            message.optOutPolicy = 'FILTER';
            message.subject = 'Contract Accommodation Required for '+ strOppNameForEmail;
            message.plainTextBody = '';
            message.plainTextBody += 'All advisors with Approved Expected AUM >$0 are required to have a Contract Accommodation submission. \n';
            message.plainTextBody += 'Please submit all accommodations for '+strOppNameForEmail+'once an Offer Letter has been signed and attached to the Opportunity.\n';
            message.plainTextBody += 'Go to the advisor’s Contact page to submit an accommodation \n';
            message.plainTextBody += 'A Task has also been created. Please complete the task once submitted. \n\n';  
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } 
            else {
                System.debug('The email failed to send: '
                             + results[0].errors[0].message);
            }
        }
    }
    
    public void processFinallyOperations(){
        try{
            notrigger =false; //Ch-21
            if(!notrigger){ //Ch-21
                if(insertList.size() != 0){
                    insert insertList;
                }
                if(updateList.size() != 0){
                    update updateList;
                } 
                
                //CH-05 start 
                if(!newTaskList.isEmpty() && newTaskList.size()>0) {
                    insert newTaskList;
                }
                //CH-05 End
                //ch-07 start        
                if(!UpdatedCaseList.isEmpty()) {
                    stopCaseTrigTAUpdate = true; //CH-11 Added by Pravin Kale to stop Case trigger for TA Doller Field Update
                    update UpdatedCaseList;
                }
                //ch-07 End
                if(trigger.isAfter && trigger.IsInsert){
                    if(!conInsert.isEmpty() && conInsert.size()>0){
                        update conInsert;
                    }
                }
                
                if(trigger.isAfter && trigger.IsUpdate){
                    
                    // CH -01 Start Add process builder requirement in trigger
                    if( contactOnIdMap.size()>0) {
                        update contactOnIdMap.values();
                    }
                    // Ch-01 End
                    if(!Conupdate.isEmpty() && Conupdate.size()>0){
                        update conUpdate;
                    }
                }
            }  
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_OpportunityTriggerGateway','processFinallyOperations',e.getMessage(),e.getLineNumber(),e.getTypeName());   
        }
    }   
}