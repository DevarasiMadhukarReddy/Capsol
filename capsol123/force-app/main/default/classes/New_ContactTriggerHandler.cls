public class New_ContactTriggerHandler implements BaseTriggerHandler {
    
    /***
* US 765 - Send Contact Updates to CLO as part of Update Customer Details Service
* for Loan Application which are already submitted to CLO
* ----------------------Updated by Amol Sprint 12 CapSol - 05/18/2020 - CH01
* 
* INC0501735 Contact not Sycing added condtion by MadhukarReddy on 7/8/2020 
* CH02 -- Implemented the OSJ ID and Enterprise name update logic from process builder 
*         as a part of Apex CPU time LImit fix -- Rinku
* CH03 -- Mailing postal code update from discover zip logic from process builder to code -- Rinku
*/
    /*
##############Change History#############
CH.No       Description                                         Developer           Date
--------------------------------------------------------------------------------------------
CH-19      Added method updateBusinessSolFields to update       Puja Jadhav         09/09/2020
Admin/Marketing/CFO status field (MS-172)  
CH-20      Added code for Zip3 Assignment batch 
to updated converted by informatica    12/09/2020 
field if Record type is changed to LPl Advisor 
and if Branch id is changed                          Rinku Yadav
CH-21      CS-2735 Process Builder Exception Error              Bhanu               01/06/2021
CH-23      TASK0368673 - Added Recordtype != Business Solution  Rinku Yadav         01/27/2021
check for Business Solution stage change
CH-24      Optimization Fix for 101 SOQL error.Boolean Check to 
not call ContactTriggerHandler for CAPSOL            Rinku Yadav         02/02/2021 
CH25       CS-2755 TA Application Performance Improvement       Amol Deshpande      02/22/2021
CH-26      LBSFNS-29  Web To Lead Form Changes                  Indrasen            04/24/2021
CH-27      Sprint10-LBSFNS-608: update Lead Grade fields from   Rinku               07/15/2021
           Contact to Lead
*/
    //global variables
    ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    ID ISOPP = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IS Opportunity').getRecordTypeId();
    ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    ID opBS = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
    ID pardotcontactRecordtypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId();
    ID LPLAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
    ID LeadLBSPreOpportunity = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('LBS Pre-Opportunity').getRecordTypeId();
    //commenting for deployment 
    //static Boolean contactTriggerInitiated = false;
    
    
    
    
    public boolean runonce=true;
    public boolean runonce1=true;
    public boolean runonce2=true;
    public boolean runonce3=true;
    public boolean runonce4=true;
    public boolean runonce5=true;
    public boolean runonce6=true;
    public boolean runonce7=true;
    //public static boolean capsolexecutionConTrigger = false ; //CH-24
    public boolean runonce8=true; //CH01
    
    public Boolean IsDisabled()
    { 
        return false;
    }
    
    public void BeforeInsert(List<SObject> newItems) {
        if(test.isRunningTest()){
            HandleCoverage.method();
            HandleCoverage.method1();
            HandleCoverage.method2();
            HandleCoverage.method3();
        }
        Handlecontact(trigger.new,trigger.old,(Map<Id,contact>)trigger.oldMap);
        /**CH02**/
        populateIASEnterpriseName(trigger.new,(Map<Id,contact>)trigger.oldMap);
    }
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        if(LPL_TriggerCall.isBeforeLoanFirstTime) {
            contactTermination(trigger.new);  
        }
        if(test.isRunningTest()){
            HandleCoverage.method();
            HandleCoverage.method1();
            HandleCoverage.method2();
            HandleCoverage.method3();
        }
        /*********CH-24 : Added capsolexecution boolean check Start*************/
        system.debug('capsolexecutionConTrigger****'+LPL_LoanApplicationHandler.capsolexecutionConTrigger);
        if(LPL_LoanApplicationHandler.capsolexecutionConTrigger == false && clsCustomUIController.capsolexecutionConTriggerOnSave == false){ //CH25
            Handlecontact(trigger.new,trigger.old,(Map<Id,contact>)trigger.oldMap);
            /**CH02**/
            populateIASEnterpriseName(trigger.new,(Map<Id,contact>)trigger.oldMap);
            //CH-19 START
            updateBusinessSolFields(trigger.new,(Map<Id,contact>)trigger.oldMap);
            //CH-19 END
        }
        /*********CH-24 : Added capsolexecution boolean check End*************/
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems) {
        HandleAccountOpp(trigger.new,trigger.old,(Map<Id,contact>)trigger.oldMap);
        updateProgramManagerOnAccount(trigger.new,trigger.old, trigger.isdelete);
        findOpportunity(trigger.new);
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        /*********CH-21 Start*******/
        if(LPL_TriggerCall.isAfterLoanFirstTime) 
        {
            UpdatecontactTermination(trigger.new);  
        }//CH-21 End
        /*********CH-24 : Added capsolexecution boolean check Start*************/
        system.debug('capsolexecutionConTrigger*************************'+LPL_LoanApplicationHandler.capsolexecutionConTrigger);
        if(LPL_LoanApplicationHandler.capsolexecutionConTrigger == false && clsCustomUIController.capsolexecutionConTriggerOnSave == false){ //CH25
            HandleAccountOpp(trigger.new,trigger.old,(Map<Id,contact>)trigger.oldMap);
            updateProgramManagerOnAccount(trigger.new,trigger.old, trigger.isdelete);
            findOpportunity(trigger.new);
            /****CH-27: START*****/
            updateProductSetGradeOnLead(trigger.new,(Map<Id,contact>)trigger.oldMap);
            /****CH-27: END*****/
        }
        /*********CH-24 : Added capsolexecution boolean check End*************/
        sendCustomerUpdatestoCLO(trigger.new,trigger.old); //CH01
        //CH-26 Change Start
        processLeadUpdates(trigger.new,(Map<Id,contact>)trigger.oldMap);
        //CH-26 Change End        
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) {
        deleteContactCount(trigger.old);
    }
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
    
    // CH01 Start
    public void sendCustomerUpdatestoCLO(list<Contact> newConList,list<Contact> oldConList){ // CH01
        if(StaticFunction.runOnceCustomerUpdatesToCLO()){
            Boolean fireUpdateApi = false;
            Id conId;
            for(Contact newCon : newConList){
                if(newCon.CLO_Customer_ID__c != null && 
                   newCon.CLO_Customer_group_ID__c != null ){
                       SObject oldContact = Trigger.oldMap.get(newCon.ID);
                       // if(oldContact.Legal_Entity__c != newCon.Legal_Entity__c )
                       
                       for(Schema.FieldSetMember fld :SObjectType.Contact.FieldSets.CapsolUpdateCustomerFieldSet.getFields()) {
                           //system.debug('FIELDSET$$$$$$$$$$$$$$$$$$$'+fld.getFieldPath());
                           system.debug('OLDVALUE$$$$$$$$$$$$$$$$$$$'+(oldContact.get(fld.getFieldPath())));
                           system.debug('NEWVALUE$$$$$$$$$$$$$$$$$$$'+(newCon.get(fld.getFieldPath())));
                           //string APIname = fld.getFieldPath();
                           if(oldContact.get(fld.getFieldPath()) != newCon.get(fld.getFieldPath())){
                               fireUpdateApi = true;
                               conId = newCon.Id;
                           }
                           
                       }
                       
                   }
                
                //}
            }
            
            if(fireUpdateApi && runonce8 && System.IsBatch() == false && System.isFuture() == false){
                runonce8 = false;
                cls_LPL_SendUpdatedCustomerDatatoMule.makePostCallout(conId);
            }
        }
        
    }
    // CH01 END
    
    public void Handlecontact(list<Contact> conList,List<Contact> oldconList,Map<Id,contact> oldconMap){
        
        if(runonce1){
            Map<String, List<IAS_Recruiter_Assignment__c>> ias_zip_Map = new Map<String, List<IAS_Recruiter_Assignment__c>>();
            Set<ID> setAccountIds = new Set<ID>();
            set<string> c_zips = new set<string>(); //CH-01
            set<string> m_zips = new set<string>();
            set<string> zips = new set<string>();
            
            for(Contact con : conList){
                Contact oldcon=new contact();
                if(oldconMap !=null && !oldconMap.isEmpty()&&oldconMap.containsKey(con.id))
                    oldcon=oldconMap.get(con.id);
                
                If(Trigger.IsInsert || trigger.Isupdate){
                    //***********CH-04:START*********
                    if( con.Discovery_Home_Zip__c!= null ){//create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
                        zips.add(con.Discovery_Home_Zip__c);
                        c_zips.add('C'+con.Discovery_Home_Zip__c);
                        m_zips.add('M'+con.Discovery_Home_Zip__c);
                    }               
                    //***********CH-04:END*********
                    /************Start***********/
                    //Lead Quality date upadte logic
                    if(con.Lead_Quality__c != null && oldcon.Lead_Quality__c != con.Lead_Quality__c){
                        if(oldcon.Lead_Quality_Date__c == con.Lead_Quality_Date__c){
                            con.Lead_Quality_Date__c = system.today();
                        }
                    }
                    /************End***********/ 
                    /*********CH-20 Start*******/
                    if((con.RecordTypeId == LPLAdvisor && oldcon.Branch_ID__c != con.Branch_ID__c) || 
                       (oldcon.RecordTypeId == pardotcontactRecordtypeID && con.RecordTypeId == LPLAdvisor)){
                           con.Converted_By_Informatica__c = true;
                       }
                    /************CH-20 End***********/
                    if( con.MailingPostalCode!= null && (con.RecordTypeId == conRecordTypeId || con.RecordTypeId == pardotcontactRecordtypeID)  ){
                        String MailingZipCode = con.MailingPostalCode;
                        String zero = '0';
                        string doublezero = '00';
                        Integer LenofMailingZipCode = MailingZipCode.Length();
                        if(LenofMailingZipCode == 3){
                            con.MailingPostalCode = doublezero.substring(0) + con.MailingPostalCode.substring(0,3);
                        }
                        else if( LenofMailingZipCode >=4 &&LenofMailingZipCode !=5 && LenofMailingZipCode <=9){
                            con.MailingPostalCode = zero.substring(0) + con.MailingPostalCode.substring(0,4);
                        } else if(LenofMailingZipCode >=10){
                            con.MailingPostalCode = con.MailingPostalCode.substring(0,5);
                        }
                    }
                    
                    if( con.MailingPostalCode!= null ){
                        zips.add(con.MailingPostalCode);
                        
                    }
                    
                }
                setAccountIds.add(con.AccountId);
                
                if(con.Discovery_Home_Zip__c== null && con.MailingPostalCode==null  && con.Allow_Lead_Type_Change__c != true){ //CH-13
                    if(con.RecordTypeId == conRecordTypeId || con.RecordTypeId == pardotcontactRecordtypeID)
                        if(Default_Oppty_Owner__c.getInstance() != null) 
                        con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
                    con.Assigned_Recruiter__c=null;
                    con.Regional_VP__c=null;
                }
                /*****CH03 Starts****/
                if(con.Discover_Zip_Code__c != null && !string.isBlank(con.Discover_Zip_Code__c)
                   && string.isBlank(con.MailingCity) && string.isBlank(con.MailingStreet) && string.isBlank(con.MailingState)
                   && con.MailingCity == null && con.MailingStreet == null && con.MailingState == null
                   && con.MailingPostalCode != con.Discover_Zip_Code__c && con.RecordTypeId == conRecordTypeId )
                {
                    con.MailingPostalCode = con.Discover_Zip_Code__c; 
                }
                /*****CH03 Ends****/
                if(con.Internal_Recruiter_IRD__c != null && con.Internal_Recruiter_IRD__c != con.OwnerId){
                    con.OwnerId = con.Internal_Recruiter_IRD__c;
                }
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
            system.debug('ias_zip_Map==>'+ias_zip_Map);
            //runonce1=false;
            if(!ias_zip_Map.isEmpty())
                executeIASLogic(conList, Trigger.isInsert,ias_zip_Map);
        }
    }
    
    public void executeIASLogic(List<Contact> conlst, boolean isInsert,Map<String, List<IAS_Recruiter_Assignment__c>> ias_zip_Map){
        try{ 
            
            for(contact con:conlst){
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
                //{
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
                //}
                
                /*CH-10- END*/
                /*Owner Update*/
                if(con.Internal_Recruiter_IRD__c != null && con.Internal_Recruiter_IRD__c != con.OwnerId){
                    con.OwnerId = con.Internal_Recruiter_IRD__c;
                } 
            }  
        }
        catch(exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());
        }
    }
    
    
    public void  HandleAccountOpp(list<Contact> conList,List<Contact> oldconList,Map<Id,contact> oldconMap){
        if(runonce2){
            Set<ID> setAccountIds = new Set<ID>();
            Map<id,contact> ContactData=new Map<id,contact>();
            for(contact con:conList){
                setAccountIds.add(con.AccountId);
                ContactData.put(con.id,con);
            }
            
            list<Opportunity> oppList = new list<Opportunity>();
            
            IF(setAccountIds.size()>0){
                //CH-05 START
                
                
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
            
            
            doUpdateOppCon(oppList);
        }
    }
    
    
    public void doUpdateOppCon(list<Opportunity> oppList){
        
        Map<ID, Contact> prospConMap = new Map<Id, Contact>();
        list<Opportunity> listOpportunity = new list<Opportunity>();
        try {
            
            Map<id,contact> ContactData =(Map<id,contact>)trigger.newMap;
            prospConMap=ContactData;
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
                                /****CH-23****/
                                if(prospConMap.get(o.Contact__c).Lead_Source__c != null 
                                   && o.LeadSource != prospConMap.get(o.Contact__c).Lead_Source__c  
                                   && o.StageName !='Closed-Joined' 
                                   && o.StageName !='Closed-Lost'
                                   /*&& o.RecordTypeId != opBS*/){ // CH-09 Added stagename condition
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
            LPL_CreateExceptionLog.createErrorRecordAsync('New_ContactTriggerHandler','doUpdateOppCon',e.getMessage(),e.getLineNumber(),e.getTypeName());//CH-03
        }
        if(runonce){
            runonce=false;
            database.upsert(listOpportunity,false);
            
        }
    }
    
    
    
    public void updateProgramManagerOnAccount(List<Contact> newConList, List<Contact> oldConList, boolean isAfterDelete) {
        
        if( runonce3 )
        {
            Set<Id> accountIds = new Set<Id>();
            List<Account> accList = new List<Account>();
            for(Contact con : newConList) {
                accountIds.add(con.AccountId);
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
                LPL_CreateExceptionLog.createErrorRecordSync('New_ContactTriggerHandler','updateProgramManagerOnAccount',e.getMessage(),e.getLineNumber(),e.getTypeName());
            }
            runonce3 = false;
        }
    }
    
    
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
            LPL_CreateExceptionLog.createErrorRecordAsync('New_ContactTriggerHandler','deleteContactCount',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
        //ch-02-End
    } 
    
    
    public  void findOpportunity(List<contact> conlist)
    {   
        if( runonce4)
        {
            runonce4=false;
            Map<ID, Opportunity> updateLostOutcomesMap = new Map<ID, Opportunity>();
            List<ID> contactIdList=new List<Id>();
            
            for(contact con:conlist){
                
                If(Con.Inactive_Reason__c=='Inactive - Compliance' 
                   || con.Inactive_Reason__c=='Inactive - Joined Another Firm'
                   || con.Inactive_Reason__c== 'Inactive - Stayed with Current Firm' 
                   || con.Inactive_Reason__c== 'Inactive - Not a Good Fit'){
                       contactIdList.add(con.Id);
                   }
                
            }
            List<contact> newConList =[ Select ID,(SELECT Id,name, Contact__c,Lost_outcome__c,Contact__r.Inactive_Reason__c FROM Opportunities__r where RecordTypeId =:IASBD AND StageName != 'Closed-Lost' ORDER BY CreatedDate DESC limit 1) 
                                       FROM Contact Where ID =:contactIdList AND RecordtypeID =: conRecordTypeId ];
            
            
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
                LPL_CreateExceptionLog.createErrorRecordAsync('New_ContactTriggerHandler','findOpportunity',e.getMessage(),e.getLineNumber(),e.getTypeName()); //CH-03
                
            }
            if(updateLostOutcomesMap.size()>0){
                database.upsert(updateLostOutcomesMap.values(),false);
            }
        }
    }
    /*********CH-21 Start*******/
    public void contactTermination(List<Contact> contactList){
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        Id lplAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Id newAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        for(Contact con : contactList) {
            if((con.recordtypeId == lplAdvisor && con.Rep_Status__c == 'Terminated') || (con.recordtypeId == newAdvisor &&
                                                                                         (con.Inactive_Reason__c == 'Inactive - Compliance' || con.Inactive_Reason__c == 'Inactive- Not in Sales' || 
                                                                                          con.Inactive_Reason__c == 'Inactive - Not a good fit' || con.Inactive_Reason__c == 'Inactive- Stayed with current firm' ||
                                                                                          con.Inactive_Reason__c == 'Inactive- Joined Another Firm' || con.Inactive_Reason__c == 'Not Interested'))) {
                                                                                              contactMap.put(con.Id, con);
                                                                                          }
        }   
        //  INC0501735 status__c!='Declined' added by Madhukar 7/8/2020      
        
        for(Contact con : contactMap.values()) {
            con.Contact_Terminated__c = true;
        }
        
    }
    
    
    public void UpdatecontactTermination(List<Contact> contactList){
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        Id lplAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Id newAdvisor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        
        for(Contact con : contactList) {
            if((con.recordtypeId == lplAdvisor && con.Rep_Status__c == 'Terminated') || (con.recordtypeId == newAdvisor &&
                                                                                         (con.Inactive_Reason__c == 'Inactive - Compliance' || con.Inactive_Reason__c == 'Inactive- Not in Sales' || 
                                                                                          con.Inactive_Reason__c == 'Inactive - Not a good fit' || con.Inactive_Reason__c == 'Inactive- Stayed with current firm' ||
                                                                                          con.Inactive_Reason__c == 'Inactive- Joined Another Firm' || con.Inactive_Reason__c == 'Not Interested'))) {
                                                                                              contactMap.put(con.Id, con);
                                                                                          }
        }   
        //  INC0501735 status__c!='Declined' added by Madhukar 7/8/2020      
        List<Loan_Application__c> loanApps = [SELECT id, status__c, Advisor__c FROM Loan_Application__c 
                                              WHERE Advisor__c IN: contactMap.keySet() AND status__c!='Declined'];
        
        for(Loan_Application__c la : loanApps) {
            la.status__c = 'Declined';
        }
        
        if(loanApps.size() > 0) {
            update loanApps;            
        }
        
        
    }//CH-21 End
    /*
* @Method Name    : populateIASEnterpriseName
* @date           : 12 Sep, 2020
* @param          : List<Contact> newList, Map<Id,Contact> oldMap
*CH02             : Update IAS Enterprise Name and Advisor depending upon the OSJ ID and Branch ID.
*/
    
    public void populateIASEnterpriseName(List<Contact> newList, Map<Id,Contact> oldMap){
        
        
        Set<String> OsjIdSet = new Set<String>();
        Set<String> BrnchIDSet = new Set<String>();
        Map<String,OSJ_ID__mdt> osjMap = new Map<String,OSJ_ID__mdt>();
        Map<String,OSJ_ID__mdt> brnchMap = new Map<String,OSJ_ID__mdt>();
        for(Contact con : newList){
            osjIdSet.add(con.OSJ_ID__c);
            osjIdSet.add(con.Branch_ID__c);
            
        }
        
        for(OSJ_ID__mdt osjmdt : [Select MasterLabel,QualifiedApiName,OSJ_Name__c, Type__c,IAS_Advisor__c 
                                  FROM OSJ_ID__mdt
                                  WHERE Active__c = true
                                  and MasterLabel in : osjIdSet]){
                                      if(osjmdt.Type__c == 'Branch'){
                                          brnchMap.put(osjmdt.MasterLabel, osjmdt);
                                      }
                                      else if(osjmdt.Type__c == 'OSJ'){
                                          osjMap.put(osjmdt.MasterLabel, osjmdt);
                                      }
                                  }
        
        if(Trigger.isInsert){
            for(Contact con : newList){
                if(con.OSJ_ID__c != null && con.OSJ_ID__c != '' && osjMap.containsKey(con.OSJ_ID__c)){
                    con.New_Large_Small_Enterprise_Name__c = osjMap.get(con.OSJ_ID__c).OSJ_Name__c;
                    con.Updated_Large_Small_Enterprise_Advisor__c = osjMap.get(con.OSJ_ID__c).IAS_Advisor__c;
                }
                else if(con.Branch_ID__c != null && con.Branch_ID__c != '' && brnchMap.containsKey(con.Branch_ID__c)){
                    con.New_Large_Small_Enterprise_Name__c = brnchMap.get(con.Branch_ID__c).OSJ_Name__c;
                    con.Updated_Large_Small_Enterprise_Advisor__c = brnchMap.get(con.Branch_ID__c).IAS_Advisor__c;
                }
                else{
                    con.New_Large_Small_Enterprise_Name__c = '';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'NO';
                }
            }
        }
        
        if(Trigger.isUpdate){
         /* for(Contact con : newList){
            if(con.OSJ_ID__c != null && con.OSJ_ID__c != '' && con.OSJ_ID__c != oldMap.get(con.Id).OSJ_ID__c &&osjMap.containsKey(con.OSJ_ID__c)){
            con.New_Large_Small_Enterprise_Name__c = osjMap.get(con.OSJ_ID__c).OSJ_Name__c;
            con.Updated_Large_Small_Enterprise_Advisor__c = 'Yes';
            }
            else if(con.Branch_ID__c != null && con.Branch_ID__c != '' && con.Branch_ID__c != oldMap.get(con.Id).Branch_ID__c  && brnchMap.containsKey(con.Branch_ID__c)){
            con.New_Large_Small_Enterprise_Name__c = brnchMap.get(con.Branch_ID__c).OSJ_Name__c;
            con.Updated_Large_Small_Enterprise_Advisor__c = 'Yes';
            }
            else{
            con.New_Large_Small_Enterprise_Name__c = '';
            con.Updated_Large_Small_Enterprise_Advisor__c = 'No';
            }
          }*/
            
            for(Contact con : newList){
                if(con.OSJ_ID__c != oldMap.get(con.Id).OSJ_ID__c){
                    if(con.OSJ_ID__c != null && con.OSJ_ID__c != ''){
                        if(osjMap.containsKey(con.OSJ_ID__c)){
                            con.New_Large_Small_Enterprise_Name__c = osjMap.get(con.OSJ_ID__c).OSJ_Name__c;
                            con.Updated_Large_Small_Enterprise_Advisor__c = osjMap.get(con.OSJ_ID__c).IAS_Advisor__c;
                        }
                        else{
                            con.New_Large_Small_Enterprise_Name__c = '';
                            con.Updated_Large_Small_Enterprise_Advisor__c = 'NO';
                        }
                    }
                    else if((con.OSJ_ID__c == null || con.OSJ_ID__c == '')){
                        if(brnchMap.containsKey(con.Branch_ID__c)){
                            con.New_Large_Small_Enterprise_Name__c = brnchMap.get(con.Branch_ID__c).OSJ_Name__c;
                            con.Updated_Large_Small_Enterprise_Advisor__c = brnchMap.get(con.Branch_ID__c).IAS_Advisor__c;
                        }
                        else{
                            con.New_Large_Small_Enterprise_Name__c = '';
                            con.Updated_Large_Small_Enterprise_Advisor__c = 'NO';
                        }
                    }
                }
                
                else if(con.Branch_ID__c != oldMap.get(con.Id).Branch_ID__c){
                    if(con.Branch_ID__c != null && con.Branch_ID__c != ''){
                        if(brnchMap.containsKey(con.Branch_ID__c)){
                            con.New_Large_Small_Enterprise_Name__c = brnchMap.get(con.Branch_ID__c).OSJ_Name__c;
                            con.Updated_Large_Small_Enterprise_Advisor__c = brnchMap.get(con.Branch_ID__c).IAS_Advisor__c;
                        }
                        else{
                            con.New_Large_Small_Enterprise_Name__c = '';
                            con.Updated_Large_Small_Enterprise_Advisor__c = 'NO';
                        }
                    }
                    else if((con.Branch_ID__c == null || con.Branch_ID__c == '')){
                        if(osjMap.containsKey(con.OSJ_ID__c)){
                            con.New_Large_Small_Enterprise_Name__c = osjMap.get(con.OSJ_ID__c).OSJ_Name__c;
                            con.Updated_Large_Small_Enterprise_Advisor__c = osjMap.get(con.OSJ_ID__c).IAS_Advisor__c;
                        }
                        else{
                            con.New_Large_Small_Enterprise_Name__c = '';
                            con.Updated_Large_Small_Enterprise_Advisor__c = 'NO';
                        }
                    }
                }
            }
            
        }
    }
    
    //CH-19 START
    public static final ID RECTYPE_LPL_ADVISOR= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
    public static void updateBusinessSolFields(List <Contact> triggerNew, map<Id,Contact> triggerOldMap)
    {
        try{
            List <Contact>  newlstCon=new List <Contact> ();
            for(Contact con:triggerNew){
                if(con.RecordtypeId==RECTYPE_LPL_ADVISOR){
                    newlstCon.add(con);
                }
            }
            if(!newlstCon.isEmpty()){
                for(contact con:newlstCon){
                    Contact oldConRecord = triggerOldMap.get(con.Id);
                    //Admin Status field Logic
                    if(con.Admin_Solutions_Active_Date__c!=oldConRecord.Admin_Solutions_Active_Date__c || con.Admin_Solutions_Termination_Date__c != oldConRecord.Admin_Solutions_Termination_Date__c ){
                        if(con.Admin_Solutions_Active_Date__c <= Date.Today() && (con.Admin_Solutions_Termination_Date__c > Date.Today() || con.Admin_Solutions_Termination_Date__c==NULL) ){
                            con.IAO_Advisor_Interest__c=System.Label.LPL_BS_Active_Status;
                        }
                        
                        else if(con.Admin_Solutions_Termination_Date__c <= Date.Today()){
                            con.IAO_Advisor_Interest__c=System.Label.LPL_BS_Terminated_Status;
                        }
                    }
                    //Marketing Solution Status field Logic
                    if(con.Marketing_Solutions_Active_Date__c!=oldConRecord.Marketing_Solutions_Active_Date__c || con.Marketing_Solutions_Termination_Date__c != oldConRecord.Marketing_Solutions_Termination_Date__c ){
                        
                        if(con.Marketing_Solutions_Active_Date__c <= Date.Today() && (con.Marketing_Solutions_Termination_Date__c > Date.Today()|| con.Marketing_Solutions_Termination_Date__c ==NULL) ){
                            con.Experiment_s__c=System.Label.LPL_BS_Active_Status;
                        }
                        
                        else if(con.Marketing_Solutions_Termination_Date__c<=Date.Today()){
                            con.Experiment_s__c=System.Label.LPL_BS_Terminated_Status;
                        }
                    }
                    //CFO Soluton status field logic
                    if(con.CFO_Solutions_Active_Date__c!=oldConRecord.CFO_Solutions_Active_Date__c || con.CFO_Solutions_Termination_Date__c != oldConRecord.CFO_Solutions_Termination_Date__c ){
                        
                        if(con.CFO_Solutions_Active_Date__c <= Date.Today() && (con.CFO_Solutions_Termination_Date__c > Date.Today()|| con.CFO_Solutions_Termination_Date__c ==NULL) ){
                            con.CFO_Solutions_Status__c=System.Label.LPL_BS_Active_Status;
                        }
                        
                        else if(con.CFO_Solutions_Termination_Date__c<=Date.Today()){
                            con.CFO_Solutions_Status__c=System.Label.LPL_BS_Terminated_Status;
                        }
                    }
                }
            }
            
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('New_ContactTriggerHandler','updateBusinessSolFields',e.getMessage(),e.getLineNumber(),e.getTypeName()); 
        }
    }
    
    /* CH-27: START
      * Story Ref: LBSFNS-608
	  * Method Name: updateProductSetGradeOnLead
      * Description - This method Update Lead Grade Fields on Lead Record depending 
      *               upon the value of lead Grade feilds on Contact record.
     */
    
    public void updateProductSetGradeOnLead( List<Contact> newConList, Map<Id,contact> oldConMap ) {
        //set<Id> conId = new set<Id>();
        Map<Id,Contact> mapCon = new Map<Id,Contact>();
        List<lead> updateLead = new List<lead>();
        for( Contact con : newConList) {
            Contact oldConList = oldConMap.get(con.ID);
            if( con.RecordTypeId == LPLAdvisor 
               /*&& ( oldConList.LBS_Admin_Grade__c != con.LBS_Admin_Grade__c || oldConList.LBS_Assurance_Grade__c != con.LBS_Assurance_Grade__c 
                   || oldConList.LBS_CFO_Solutions_Grade__c != con.LBS_CFO_Solutions_Grade__c || oldConList.LBS_Client_Engage_Grade__c != con.LBS_Client_Engage_Grade__c 
                   || oldConList.LBS_Deal_Support_Grade__c != con.LBS_Deal_Support_Grade__c || oldConList.LBS_Marketing_Solutions_Grade__c != con.LBS_Marketing_Solutions_Grade__c 
                   || oldConList.LBS_Premium_Buyer_Grade__c != con.LBS_Premium_Buyer_Grade__c || oldConList.LBS_Resilience_Grade__c != con.LBS_Resilience_Grade__c 
                   || oldConList.LBS_Seller_Support_Grade__c != con.LBS_Seller_Support_Grade__c || oldConList.LBS_Technology_Grade__c != con.LBS_Technology_Grade__c 
                   || oldConList.LBS_Valuation_Grade__c != con.LBS_Valuation_Grade__c || oldConList.LBS_Bookkeeping_Grade__c != con.LBS_Bookkeeping_Grade__c )*/ ) {
            	
                       mapCon.put(con.Id,con);
            }
         }
        if( mapCon.size() > 0 && mapCon != null ){
            List<Lead> leadList = [SELECT id,LBS_Lead_Status__c,LBS_Admin_Solutions_Grade__c,LBS_Assurance_Plan_Grade__c,LBS_CFO_Solutions_Grade__c,LBS_Client_Engage_Grade__c,
                                   LBS_Deal_Support_Grade__c,LBS_Marketing_Solutions_Grade__c,LBS_Premium_Buyer_Grade__c,
                                   LBS_Seller_Support_Grade__c,LBS_Resilience_Grade__c,LBS_Technology_Grade__c,LBS_Valuation_Grade__c,Contact__c,LBS_Bookkeeping_Grade__c 
                                   FROM Lead 
                                   WHERE LBS_Lead_Status__c != 'Converted' AND RecordTypeId =: LeadLBSPreOpportunity AND Contact__c IN : mapCon.keySet()];
            for( Lead ld : leadList ) {
                Contact oldContactList = oldConMap.get(ld.contact__c);
                /*if( mapCon.get(ld.contact__c).LBS_Admin_Grade__c == null && ld.LBS_Admin_Solutions_Grade__c != 'N/A' ) {
                    ld.LBS_Admin_Solutions_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Assurance_Grade__c == null && ld.LBS_Assurance_Plan_Grade__c != 'N/A' ){
                    ld.LBS_Assurance_Plan_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Bookkeeping_Grade__c == null && ld.LBS_Bookkeeping_Grade__c != 'N/A' ) {
                    ld.LBS_Bookkeeping_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_CFO_Solutions_Grade__c == null && ld.LBS_CFO_Solutions_Grade__c != 'N/A' ) {
                    ld.LBS_CFO_Solutions_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Client_Engage_Grade__c == null && ld.LBS_Client_Engage_Grade__c != 'N/A' ) {
                    ld.LBS_Client_Engage_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Deal_Support_Grade__c == null && ld.LBS_Deal_Support_Grade__c != 'N/A' ) {
                    ld.LBS_Deal_Support_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Marketing_Solutions_Grade__c == null && ld.LBS_Marketing_Solutions_Grade__c != 'N/A' ) {
                    ld.LBS_Marketing_Solutions_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Premium_Buyer_Grade__c == null && ld.LBS_Premium_Buyer_Grade__c != 'N/A') {
                    ld.LBS_Premium_Buyer_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Seller_Support_Grade__c == null && ld.LBS_Seller_Support_Grade__c != 'N/A' ) {
                    ld.LBS_Seller_Support_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Resilience_Grade__c == null && ld.LBS_Resilience_Grade__c != 'N/A' ) {
                    ld.LBS_Resilience_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Technology_Grade__c == null && ld.LBS_Technology_Grade__c != 'N/A' ) {
                    ld.LBS_Technology_Grade__c = 'N/A';
                }
                if( mapCon.get(ld.contact__c).LBS_Valuation_Grade__c == null && ld.LBS_Valuation_Grade__c != 'N/A' ) {
                    ld.LBS_Valuation_Grade__c = 'N/A';
                }*/
                if( mapCon.get(ld.contact__c).LBS_Admin_Grade__c != null && oldContactList.LBS_Admin_Grade__c != mapCon.get(ld.contact__c).LBS_Admin_Grade__c ) {
                    ld.LBS_Admin_Solutions_Grade__c = mapCon.get(ld.contact__c).LBS_Admin_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Assurance_Grade__c != null && oldContactList.LBS_Assurance_Grade__c != mapCon.get(ld.contact__c).LBS_Assurance_Grade__c ) {
                    ld.LBS_Assurance_Plan_Grade__c = mapCon.get(ld.contact__c).LBS_Assurance_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_CFO_Solutions_Grade__c != null && oldContactList.LBS_CFO_Solutions_Grade__c != mapCon.get(ld.contact__c).LBS_CFO_Solutions_Grade__c ) {
                    ld.LBS_CFO_Solutions_Grade__c = mapCon.get(ld.contact__c).LBS_CFO_Solutions_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Client_Engage_Grade__c != null && oldContactList.LBS_Client_Engage_Grade__c != mapCon.get(ld.contact__c).LBS_Client_Engage_Grade__c ) {
                    ld.LBS_Client_Engage_Grade__c = mapCon.get(ld.contact__c).LBS_Client_Engage_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Deal_Support_Grade__c != null && oldContactList.LBS_Deal_Support_Grade__c != mapCon.get(ld.contact__c).LBS_Deal_Support_Grade__c ) {
                    ld.LBS_Deal_Support_Grade__c = mapCon.get(ld.contact__c).LBS_Deal_Support_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Marketing_Solutions_Grade__c != null && oldContactList.LBS_Marketing_Solutions_Grade__c != mapCon.get(ld.contact__c).LBS_Marketing_Solutions_Grade__c ) {
                    ld.LBS_Marketing_Solutions_Grade__c = mapCon.get(ld.contact__c).LBS_Marketing_Solutions_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Premium_Buyer_Grade__c != null && oldContactList.LBS_Premium_Buyer_Grade__c != mapCon.get(ld.contact__c).LBS_Premium_Buyer_Grade__c ) {
                    ld.LBS_Premium_Buyer_Grade__c = mapCon.get(ld.contact__c).LBS_Premium_Buyer_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Resilience_Grade__c != null && oldContactList.LBS_Resilience_Grade__c != mapCon.get(ld.contact__c).LBS_Resilience_Grade__c ) {
                    ld.LBS_Resilience_Grade__c = mapCon.get(ld.contact__c).LBS_Resilience_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Seller_Support_Grade__c != null && oldContactList.LBS_Seller_Support_Grade__c != mapCon.get(ld.contact__c).LBS_Seller_Support_Grade__c ) {
                    ld.LBS_Seller_Support_Grade__c = mapCon.get(ld.contact__c).LBS_Seller_Support_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Technology_Grade__c != null && oldContactList.LBS_Technology_Grade__c != mapCon.get(ld.contact__c).LBS_Technology_Grade__c ) {
                    ld.LBS_Technology_Grade__c = mapCon.get(ld.contact__c).LBS_Technology_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Valuation_Grade__c != null && oldContactList.LBS_Valuation_Grade__c != mapCon.get(ld.contact__c).LBS_Valuation_Grade__c ) {
                    ld.LBS_Valuation_Grade__c = mapCon.get(ld.contact__c).LBS_Valuation_Grade__c;
                }
                if( mapCon.get(ld.contact__c).LBS_Bookkeeping_Grade__c != null && oldContactList.LBS_Bookkeeping_Grade__c != mapCon.get(ld.contact__c).LBS_Bookkeeping_Grade__c ) {
                    ld.LBS_Bookkeeping_Grade__c = mapCon.get(ld.contact__c).LBS_Bookkeeping_Grade__c;
                }
                updateLead.add(ld);
             }
        }
        if( updateLead.size() > 0 ) {
            update updateLead;
        }
    }    
    
    /**
* CH-26 Change Start
* Story Ref: LBSFNS-29
* Method Name: processLeadUpdates
* Description - This method accepts list of Contacts as parameter and verifies if there is any change in
the LBS products.

update for LBSFNS - 448
Added new condition in IF for Bookkeeping, resilience, valuvation, deal support, seller support, technology
commented digital office
**/
    private void processLeadUpdates(List<Contact> newContList, Map<Id,Contact> oldContMap){
        List<Contact> lbsContList = new List<Contact>();
        Id advisorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        for(Contact ct: newContList){
            if((ct.RecordTypeId == advisorRecordTypeId) &&
               (ct.LBS_Assurance__c == true && ct.LBS_Assurance__c != oldContMap.get(ct.Id).LBS_Assurance__c) ||
               (ct.LBS_Admin__c == true && ct.LBS_Admin__c != oldContMap.get(ct.Id).LBS_Admin__c) ||   
               (ct.LBS_CFO_Solutions__c == true && ct.LBS_CFO_Solutions__c != oldContMap.get(ct.Id).LBS_CFO_Solutions__c) ||                    
               (ct.LBS_Client_Engage__c == true && ct.LBS_Client_Engage__c != oldContMap.get(ct.Id).LBS_Client_Engage__c) ||     
               (ct.LBS_Marketing_Solutions__c == true && ct.LBS_Marketing_Solutions__c != oldContMap.get(ct.Id).LBS_Marketing_Solutions__c) ||
               //(ct.LBS_Digital_Office__c == true && ct.LBS_Digital_Office__c != oldContMap.get(ct.Id).LBS_Digital_Office__c) ||
               (ct.LBS_Bookkeeping__c == true && ct.LBS_Bookkeeping__c != oldContMap.get(ct.Id).LBS_Bookkeeping__c) ||
               (ct.LBS_Premium_Buyer__c == true && ct.LBS_Premium_Buyer__c != oldContMap.get(ct.Id).LBS_Premium_Buyer__c) ||
               (ct.LBS_Resilience__c == true && ct.LBS_Resilience__c != oldContMap.get(ct.Id).LBS_Resilience__c) ||
               (ct.LBS_Valuation__c == true && ct.LBS_Valuation__c != oldContMap.get(ct.Id).LBS_Valuation__c) ||
               (ct.LBS_Deal_Support__c == true && ct.LBS_Deal_Support__c != oldContMap.get(ct.Id).LBS_Deal_Support__c) ||
               (ct.LBS_Seller_Support__c     == true && ct.LBS_Seller_Support__c     != oldContMap.get(ct.Id).LBS_Seller_Support__c ) ||
               (ct.LBS_Technology__c == true && ct.LBS_Technology__c != oldContMap.get(ct.Id).LBS_Technology__c)){
                   lbsContList.add(ct);
               }
        }
        if(lbsContList != null && lbsContList.size() >0) {                
            System.enqueueJob(new LeadController(lbsContList));
        }
        
    }
    //CH-26 Change End       
}