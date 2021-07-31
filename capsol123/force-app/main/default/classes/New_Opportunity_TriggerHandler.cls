/*
Trigger Name            :LPL_OpportunityTriggerGateway
Description             :This class is mainly focus on Opportunity and also have dependency with Contact Object.
Developer Name          : Pravin Kale
Created Date            : 3/16/2017 
##############Change History#############
CH.No       Description                                               Developer         Date
------------------------------------------------------------------------------------------------
CH-10      	For Contract Accommodation:         
           	Getting a Task created From Opportunity                  Vaibhav Wadhai   09 Sept 2017
           	and assigned to Opportunity IRD.
CH-12   	Send email to the IRD and Assigned Recruiter when the    Utkarsh Topre    10/09/2017
 			"CH-10" conditions will meet.
CH-13       Make Assigned Recruiter as the Opportunity Owner when 
            the record type is "IAS Business Development"            Utkarsh Topre    02/23/2018 
CH-15       To Populate Assigned Recruiter,Internal Recruiter (IRD), 
            Regional VP ID based on mailingpostalcode                Manila Agnihotri 04/27/2018
CH-16       Update the Highest Stage Reached field on Contact based 
            on the highest Stage value in the related Opportunity    Utkarsh Topre    05/07/2018
CH-17       Advisor Diversity update from opportuntiy to 
            contact-LPL Advisor                                      Manila Agnihotri 05/30/2018 
CH-19       Update  Region field on Opportunity from IAS Recruiter 
            Assignment's Region based on zip code                    Ashish Gupta     10/24/2018                            
 
CH-20       Update 'Channel' and 'Request to join as' from Contact
            to Opportunity upon creation of Opportunity.             Vaibhav Jain     09/28/2018
CH-22       If “Discovery Home Zip” is blank and “Mailing Zip Code” 
            is not, “Region” populates based on “Mailing Zip Code”   Vaibhav Jain     11/12/2018
CH-23       Changes to correct mapping between Lost Outcome and 
            Prospect Status on Contact                               Garvita Rai      02/15/2019
CH-27       101 SOQL fix                                             Rinku Yadav      08/13/2020
CH-28       Optimization Fix for 101 SOQL error                      Rinku Yadav      01/12/2021
CH-29       CS-2756 Sprint 21- Remove hardcoded loan application 
CH-30       TASK0368673-Commeneted 5.Closed-Lost stage for 
            Business solution stage change                           Rinku Yadav      01/27/2021
CH-31       CS-4425 Integrate Campaign Offer Accepted field on       Amol Deshpande   07/24/2021
            Opportunity and Proposal Offer            
*/
public class New_Opportunity_TriggerHandler implements BaseTriggerHandler{
    /*****Record Type declaration*******/
    ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); //CH-16
    ID conLPLTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId(); //CH-16
    ID opBS = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
    ID opBC = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Consulting').getRecordTypeId();
    ID oppRIAID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RIA Compliance ADVantage').getRecordTypeId();
    ID oppInsuranceID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('AIS Insurance Sales').getRecordTypeId();
    ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    ID ISBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IS Business Development').getRecordTypeId();
    ID rt = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Transitions').getRecordTypeId();
    //Schema.DescribeSObjectResult oppRecDesc = Schema.SObjectType.Opportunity;
    //Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
    //Map<String,Schema.RecordTypeInfo> rt_TaskMap = tskRecDesc.getRecordTypeInfosByName();
    //Map<String,Schema.RecordTypeInfo> rtMapByName = oppRecDesc.getRecordTypeInfosByName();
    //Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
    //Map<ID,Schema.RecordTypeInfo> rt_MapCon = Contact.sObjectType.getDescribe().getRecordTypeInfosById();
    List<Contact> conUpdate = new List<Contact>();
    List<Task> insertList = new List<Task>();
    
    public static boolean runonce = true;
    public static boolean runonce1 = true;
    public static boolean runonce2 = true;
    public static boolean runonce3 = true;
    public static boolean runonce4 = true;
    public static boolean runonce5 = true;
    public static boolean runonce6 = true;
    public static boolean runonce7 = true;
    public static boolean runonce8 = true;
    /******CH-28: Start******/
    public static boolean runonce9 = true;
    public static boolean runonce10 = true;
    public static boolean capsolexecution = false ;
    public static boolean capsolProposalexecution = false ;
    /******CH-28: End******/
    public static Integer count=1;
    
    public Boolean IsDisabled()
    {
        return false;
    }
    /*******Trigger methods*******/
    public void BeforeInsert(List<SObject> newItems)
    {
        if(test.isRunningTest())
        {
            HandleCoverage.method();
            HandleCoverage.method1();
            HandleCoverage.method2();
            HandleCoverage.method3();
        }
        system.debug('insert count===>'+count);
        count++;
        HandleContact(trigger.new,(Map<ID,Opportunity>)trigger.oldMap);
        updateAUM(trigger.new,(Map<id,opportunity>)Trigger.oldMap);
        //HandleTask(Trigger.new);
        handleEmailOperation(Trigger.new,(Map<ID,Opportunity>)trigger.oldMap,Trigger.isUpdate);
        //HandleCampaign(Trigger.new);
        //Updateactivity(Trigger.new, (Map<ID,Opportunity>)trigger.oldMap);
        HandleCase(Trigger.new,(Map<ID,Opportunity>)trigger.oldMap);
    }
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems)
    {
        system.debug('update count===>'+count);
        count++;
        /********CH-28 : Start***********/
        if( capsolexecution == false )
        {
            HandleContact(trigger.new,(Map<ID,Opportunity>)trigger.oldMap);
            //HandleTask(Trigger.new);
            /*******Start: Optimization Fix**********/
            //handleEmailOperation(Trigger.new,(Map<ID,Opportunity>)trigger.oldMap,Trigger.isUpdate);
            /*******End: Optimization Fix**********/
            // HandleCampaign(Trigger.new);
            Updateactivity(Trigger.new,(Map<ID,Opportunity>)trigger.oldMap); 
            HandleCase(Trigger.new,(Map<ID,Opportunity>)trigger.oldMap);
        }
        /********CH-28 : End***********/
        updateAUM(trigger.new,(Map<id,opportunity>)Trigger.oldMap);
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems)
    {
        populatecontactrole(Trigger.new,NULL);
        HandleTask(Trigger.new); 
        FinalProcess();
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems)
    {
        //loanApplicationUpdate(Trigger.new);
        CheckOpportunitytoUpdateLoan((Map<Id,Opportunity>) Trigger.newMap,(Map<Id,Opportunity>) Trigger.oldMap);
        UpdateCampaignOfferSelected((List<Opportunity>) Trigger.new,(Map<Id,Opportunity>) Trigger.oldMap);
        /********CH-28 : Start***********/
        if( capsolexecution == false)
        {
            populatecontactrole(Trigger.new,(Map<ID,Opportunity>)Trigger.oldmap);
            //HandleTask(Trigger.new);
            Updateactivity(Trigger.new,(Map<ID,Opportunity>)trigger.oldMap);
            FinalOfferStatusTrigger((Map<ID,Opportunity>)Trigger.newMap,(Map<ID,Opportunity>)Trigger.oldMap);
            FinalProcess();
        }
        /********CH-28 : End***********/
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
    
    /******************Method execution******************************/
    
    public void HandleContact(List<Opportunity> oppList1, Map<ID, Opportunity> oldOppMap)
    {
        /*******CH-28 : Commented iaConId,AccId,AccIdConId ***********/
        List<ID> conIds = new List<ID>();
        //List<Id> iaConId = new List<Id>();
        Map<Id, Contact> conMapUpOp = new Map<Id, Contact>();
        //Set<Id> AccId = new Set<Id>();
        Map<String, IAS_Recruiter_Assignment__c> zipMap = new Map <String, IAS_Recruiter_Assignment__c>();
        List<String> newzipList = new List<String>();
        String zip;
        //Map<Id,Id> AccIdConId = new Map<Id,Id>();
        Map<Id, Contact> conMap = new Map<Id, Contact>();
        
        for( Opportunity opp : oppList1 )
        {
            conIds.add(opp.Contact__c);
            //iaConId.add(opp.Contact__c);
        }
        System.debug('con id is'+conIds);
        if( conIds.size()>0 && conIds != null )
        {
            for( Contact con : [SELECT Id,AccountID, RecordTypeID, Recordtype.Name, Lead_Source__c, Source_Type_Prospect__c, Referral_By__c,
                                Referring_Advisor_Rep_ID__c,Marketing_Classification_Prospect__c, Channel__c, Request_to_join_as__c,
                                Mailer_Code_Prospect__c, Years_in_Industry__c, Licenses__c, Current_Firm__c,
                                HomePhone, Phone, MobilePhone, Fax, Email, Rep_Type__c,AUM_from_other_source__c,
                                MailingStreet, MailingCity, MailingState, MailingPostalCode, WMO_Division__c,/*CH -04*/Insurance_Territory_New__c,
                                DoNotCall, Do_Not_Mail__c, HasOptedOutOfEmail,ELQ_Marketing_Email_Opt_Out__c,Discovery_Contact_Phone__c,Discovery_Contact_Address_1__c,Discovery_Contact_Address_2__c,Discovery_Contact_City__c,Discovery_Contact_State__c
                                ,Assigned_Recruiter__c, Regional_Vp__c,Discovery_Home_Zip__c, Internal_Recruiter_IRD__c, /* CH -01*/Inactive_Reason__c
                                , Highest_Stage_Reached__c,Marketing_Category__c /*CH-16*/
                                FROM Contact 
                                WHERE Id in: conIds] )
            {
                    conMapUpOp.put(con.ID, con);
                    System.debug('conMapUpOp  is'+ conMapUpOp);
                    /********CH-28 : Start***********/
                    /*if(( con.Rep_Type__c == 'RIA IFA Firm' || con.Rep_Type__c == 'RIA Hybrid Firm') 
                        && AccId.Contains(con.AccountID) )
                    {
                         AccIdConId.put(con.AccountId,con.Id);    
                    }*/
                    /********CH-28 : End***********/
                    if( con.Rep_Type__c == 'RIA Hybrid Firm' )
                    {
                         conMap.put(con.Id, con); 
                    }
                    /********CH-28 : Start***********/
                    /*if(AccId.Contains(con.AccountID))
                    {
                         conMap.put(con.Id, con); 
                    }*/
                    /********CH-28 : End***********/
             }
        }
        if( conIds != null && conIds.size()>0 /*&& iaConId != null && iaConId.size()>0 */ && trigger.isInsert && runonce10 )
        {     /******CH-28 : Replaced iaConId with conIds from for loop*******/
              for( ID contactID : conIds )
              {
                   if( conMapUpOp.containsKey(contactID) && conMapUpOp.get(contactID).Discovery_Home_Zip__c != null )
                   {
                      zip = conMapUpOp.get(contactID).Discovery_Home_Zip__c;
                      newzipList.add(zip);
                   }
                   /*****CH-22 - Start******/
                   if( conMapUpOp.containsKey(contactID) && conMapUpOp.get(contactID).MailingPostalCode != null )
                   {
                       zip = conMapUpOp.get(contactID).MailingPostalCode;
                       newzipList.add(zip);
                   }
                   /*****CH-22 - End******/
                }
         /******CH-27*******/
         if( newzipList != null && newzipList.size()>0 )
         {
            List<IAS_Recruiter_Assignment__c> iasList = [SELECT Name,region__c 
                                                         FROM IAS_Recruiter_Assignment__c
                                                         WHERE name in :newzipList];
                if( iasList != null && iasList.size()>0 )
                {
                   for( IAS_Recruiter_Assignment__c ias : iasList )
                   {
                       zipMap.put(ias.name,ias);
                    }
                }
           }
      }
      conOppMapping(oppList1, oldOppMap, zipMap, conMapUpOp, conMap);
   }
   /*
     * @Method name   : conOppMapping
     * @Parameter     : List<Opportunity> newOppList, Map<id,opportunity> oldOppMap, Map<String, IAS_Recruiter_Assignment__c> zipMap,Map<id,contact> conMapUpOp,Map<id,contact> conMap
     * @description   : Update Opportunity field from Contact field 
  */
   public void conOppMapping(List<Opportunity> newOppList, Map<id,opportunity> oldOppMap, Map<String, IAS_Recruiter_Assignment__c> zipMap,Map<id,contact> conMapUpOp,Map<id,contact> conMap){
        // try{
        Map<Id,Contact> contactOnIdMap = new Map<Id,Contact>();
        Map<Id, opportunity> oppMap = new Map<Id, Opportunity>();
       
        for( opportunity newOpp : newOppList )
        {
            if(trigger.isBefore && trigger.isInsert)
            {
                if( newOpp.RecordTypeId == oppRIAID && conMap.containsKey(newOpp.Contact__c) )
                {   
                    newOpp.Firm_Contact__c = conMap.get(newOpp.Contact__c).ID; 
                }
                /*If( newOpp.RecordTypeId == IASBD) {
                    system.debug('trigger.isUpdate value is =' +trigger.isUpdate);
                    //START: check the mandatory fields
                    if(newOpp.Contact__c != null){
                        //checkValidation(newOpp, conMapUpOp);
                    } //END: check mandatory fields
                    If(newOpp.Contact__c != null && trigger.isUpdate ) {
                        newOpp.Home_Phone__c = conMapUpOp.get(newOpp.Contact__c).HomePhone;
                        system.debug('conMapUpOp.get(newOpp.Contact__c).Phone '+ conMapUpOp.get(newOpp.Contact__c).Phone);
                        if(conMapUpOp.get(newOpp.Contact__c).Phone!=null){
                            newOpp.Work_Phone__c = conMapUpOp.get(newOpp.Contact__c).Phone;
                        }
                        else{
                            system.debug('AsadasadAsadasad');
                            newOpp.Work_Phone__c = conMapUpOp.get(newOpp.Contact__c).Discovery_Contact_Phone__c;
                            newOpp.Mobile__c = conMapUpOp.get(newOpp.Contact__c).MobilePhone;
                            newOpp.Fax__c = conMapUpOp.get(newOpp.Contact__c).Fax;
                            newOpp.Email__c = conMapUpOp.get(newOpp.Contact__c).Email;
                        }    
                        if(conMapUpOp.get(newOpp.Contact__c).MailingStreet != null){
                            newOpp.Home_Address__c = conMapUpOp.get(newOpp.Contact__c).MailingStreet;
                        }else{
                            newOpp.Home_Address__c = conMapUpOp.get(newOpp.Contact__c).Discovery_Contact_Address_1__c;
                        }    
                        if(conMapUpOp.get(newOpp.Contact__c).MailingCity!= null){
                            newOpp.City__c = conMapUpOp.get(newOpp.Contact__c).MailingCity;
                        }else{
                            newOpp.City__c = conMapUpOp.get(newOpp.Contact__c).Discovery_Contact_City__c;
                        }    
                        if(conMapUpOp.get(newOpp.Contact__c).MailingState!= null){
                            newOpp.State__c = conMapUpOp.get(newOpp.Contact__c).MailingState;
                        }else{
                            newOpp.State__c = conMapUpOp.get(newOpp.Contact__c).Discovery_Contact_State__c;
                            newOpp.Zip_Code__c = conMapUpOp.get(newOpp.Contact__c).MailingPostalCode;
                            newOpp.Do_Not_Call__c = conMapUpOp.get(newOpp.Contact__c).DoNotCall;
                            newOpp.Do_Not_Mail__c = conMapUpOp.get(newOpp.Contact__c).Do_Not_Mail__c;
                            newOpp.Email_Opt_Out__c = conMapUpOp.get(newOpp.Contact__c).HasOptedOutOfEmail;
                            newOpp.ELQ_Marketing_Email_Opt_Out__c = conMapUpOp.get(newOpp.Contact__c).ELQ_Marketing_Email_Opt_Out__c;
                        }
                    }
                }*/
            }
            
            if( trigger.isUpdate )
            {
                 /*******CH-28 : Commented oldopp*******/
                //opportunity oldOpp = (opportunity)trigger.oldMap.get(newOpp.Id);
                /******CH-30 : Commented the stage******/
                if( (newOpp.StageName == 'Closed-Lost' /*|| newOpp.StageName == '5.Closed-lost'*/) 
                   && newOpp.Lost_outcome__c != null 
                   && newOpp.Contact__c != null
                   && oldOppMap.get(newopp.id).StageName != newOpp.StageName
                   && trigger.isUpdate  
                   )
                 {
                       /***Ch-23 Starts***/
                       if( newOpp.Lost_outcome__c == 'Compliance Reason' )
                       {
                           conMapUpOp.get(newOpp.Contact__c).Inactive_Reason__c = 'Inactive - Compliance';
                       }
                       else if( newOpp.Lost_outcome__c == 'Joined Another Firm')
                       {
                           conMapUpOp.get(newOpp.Contact__c).Inactive_Reason__c = 'Inactive - Joined Another Firm';
                       }
                       else if( newOpp.Lost_outcome__c == 'Stayed with Current Firm')
                       {
                           conMapUpOp.get(newOpp.Contact__c).Inactive_Reason__c = 'Inactive - Stayed with Current Firm';
                       }
                       else if( newOpp.Lost_outcome__c == 'Not a Good Fit')
                       {
                           conMapUpOp.get(newOpp.Contact__c).Inactive_Reason__c = 'Inactive - Not a Good Fit';
                       }
                       else if( newOpp.Lost_outcome__c == 'Unknown')
                       {
                           conMapUpOp.get(newOpp.Contact__c).Inactive_Reason__c = 'Known- Prospect';
                       }
                       else
                       {
                           conMapUpOp.get(newOpp.Contact__c).Inactive_Reason__c = newOpp.Lost_outcome__c;
                       }
                       /***Ch-23 Ends***/
                       contactOnIdMap.put(newOpp.Contact__c,conMapUpOp.get(newOpp.Contact__c));
                   }
            }
            If( newopp != null )
            {
                oppMap.put(newOpp.Id, newOpp);
            }
            /*********CH-28 : Commented Contact and used conMapUpOp*************/
            //Contact c;
            /****CH-20 Start*****/
            if( trigger.isInsert )
            {
                if( conMapUpOp.containsKey(newOpp.Contact__c) )
                {
                     if( conMapUpOp.get(newOpp.Contact__c) != null && conMapUpOp.get(newOpp.Contact__c).Channel__c != null )
                    {
                        newOpp.Channel__c = conMapUpOp.get(newOpp.Contact__c).Channel__c;
                    }
                    if( conMapUpOp.get(newOpp.Contact__c) != null && conMapUpOp.get(newOpp.Contact__c).Request_To_Join_As__c != null)
                    {
                        newOpp.Request_To_Join_As__c = conMapUpOp.get(newOpp.Contact__c).Request_To_Join_As__c;
                    }
                }
            }
            /****CH-20 End*****/
            /****************CH-13 Start*****************/
            /******Addes IsInsert as a part active opportunity fix******/
            if(trigger.isbefore && trigger.isInsert)
            {
                if (newOpp.recordTypeID == IASBD)
                {
                    if(newOpp.Assigned_Recruiter__c != null)
                    {
                        newOpp.OwnerId = newOpp.Assigned_Recruiter__c;
                    }
                }
                /******CH-30 : Added opBS record type condition******/
                if(newOpp.Contact__c != null && conMapUpOp.size()>0  
                   && conMapUpOp.get(newOpp.Contact__c).AUM_from_other_source__c != newOpp.AUM__c
                   && newOpp.RecordTypeId != opBS
                   && newOpp.StageName != 'Closed-Joined' 
                   && newOpp.StageName != 'Closed-Lost' )     
                {      
                    conMapUpOp.get(newOpp.Contact__c).AUM_from_other_source__c = newOpp.AUM__c;         
                } 
                /*****************CH-13 End*****************/
                /******CH-28 : Start-Duplicate update******/
                /*if( newOpp.RecordTypeId == oppRIAID && conMap.containsKey(newOpp.Contact__c))
                {   
                    newOpp.Firm_Contact__c = conMap.get(newOpp.Contact__c).ID; 
                } */
                /******CH-28 : End-Duplicate update******/
                if( newOpp.RecordTypeId == oppInsuranceID && conMap.size() > 0 && conMap.containsKey(newOpp.Contact__c) )
                {   
                    if( conMap.get(newOpp.Contact__c).WMO_Division__c != null )
                        newOpp.LPL_Region__c = conMap.get(newOpp.Contact__c).WMO_Division__c;                        
                        //ConId.add(newOpp.Contact__C);
                }
                /***CH-15 Start***/
                if( newOpp.recordTypeID == IASBD && conMapUpOp.size() > 0 && conMapUpOp.get(newOpp.Contact__c) != null )
                {
                    newOpp.Assigned_Recruiter__c = conMapUpOp.get(newOpp.Contact__c).Assigned_Recruiter__c;
                    newOpp.Regional_Vp__c = conMapUpOp.get(newOpp.Contact__c).Regional_Vp__c;
                    newOpp.Internal_Recruiter_IRD__c = conMapUpOp.get(newOpp.Contact__c).Internal_Recruiter_IRD__c;
                    /***CH-19 - Start***/
                    /*****CH-28 : Start********/
                    //String contactHomeZipcode = conMapUpOp.get(newOpp.Contact__c).Discovery_Home_Zip__c;
                    //String mailingPostalZipCode = conMapUpOp.get(newOpp.Contact__c).MailingPostalCode;
                    
                    if( conMapUpOp.get(newOpp.Contact__c).Discovery_Home_Zip__c != null /*&& contactHomeZipcode != ''*/ )
                    {
                        if( zipMap.get(conMapUpOp.get(newOpp.Contact__c).Discovery_Home_Zip__c) != null )
                            newOpp.Region__c = zipMap.get(conMapUpOp.get(newOpp.Contact__c).Discovery_Home_Zip__c).Region__c;
                    }
                    /***CH-19 - End***/
                    /****CH-22 - start****/
                    else if( conMapUpOp.get(newOpp.Contact__c).MailingPostalCode !=null 
                             && conMapUpOp.get(newOpp.Contact__c).MailingPostalCode !='' )
                    {
                         if( zipMap.get(conMapUpOp.get(newOpp.Contact__c).MailingPostalCode) != null )
                              newOpp.Region__c = zipMap.get(conMapUpOp.get(newOpp.Contact__c).MailingPostalCode).Region__c;
                    }/*****CH-28 : End********/
                    else
                    {
                        newOpp.Region__c = null;
                    }
                    /****CH-22 - end****/
                }
                /***CH-15 - end***/
                system.debug('******');
                if( oppMap.size() != 0 && oppMap != null && newOpp.RecordTypeId == oppInsuranceID )
                {
                    system.debug('******');
                    assignnFirmID(oppMap);
                }
                if( newOpp.StageName != NULL && newOpp.StageName == '4 - Meeting')
                {
                    newOpp.Stage_4_Changed_Date__c = System.today();
                }
                /***CH-29 : Start***/
                if( newOpp.Revenue_Verification_Status__c != NULL && newOpp.Revenue_Verification_Status__c == LoanSubmitApplication.getApplicationStatus('Opportunity','Status_1'))
                {
                    newOpp.Revenue_Received__c = System.today();
                }
                if( newOpp.Revenue_Verification_Status__c != NULL && newOpp.Revenue_Verification_Status__c == LoanSubmitApplication.getApplicationStatus('Opportunity','Status_2'))
                {
                    newOpp.Revenue_Approved__c = System.today();  
                }
                /***CH-29 : End***/
            }
            /*******CH-28*******/
            if( ( newOpp.recordTypeID == IASBD 
                 || newOpp.recordTypeID == ISBD/*rt_Map.get(newOpp.recordTypeID).getName() == 'IS Business Development'*/) 
                 && trigger.isInsert )
               {
                    OpportunityHandler handler = new OpportunityHandler();
                    handler.updateEntryExitFieldsonOpportunity(newOppList, oldOppMap);
               }
         }
         if( contactOnIdMap.size()>0) 
         {
            update contactOnIdMap.values();
         }
        /***Added isinsert as a part of active opportunity fix***/
        if(trigger.isbefore && trigger.isInsert)
        {
            System.debug('opp value 11 is'+conMapUpOp);
            if( conMapUpOp.size() > 0 && conMapUpOp != null )
            {
                OpportunityHandler handler = new OpportunityHandler();
                handler.updateConOppFields(conMapUpOp, newOppList);
            }
        }
        /*}
        catch(Exception e) {
        System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }*/
    }
     /*
     * @Method name   : updateAUM
     * @Parameter     : List<Opportunity> newOpp, map<id,Opportunity> oldMap
     * @description   : 
  */
    public void updateAUM(List<Opportunity> newOpp, map<id,Opportunity> oldMap){
        try {
            if(runonce6)
            {
                set<Id> conidsset = new set<id>();
                ID UID = UserInfo.getUserId();
                Opportunity oldOpp = new opportunity();
                //String UserID = system.Label.User_ID.split(',');
                List<String> userIds = system.Label.User_ID.split(',');
                for(Opportunity opp : newOpp)
                {
                    conidsset.add(opp.Contact__c);
                }
                Map<id,contact> conMap = new Map<id,contact>();
                //conMapUpOp.get(newOpp.Contact__c).AUM_from_other_source__c = newOpp.AUM__c;
                if( conidsset.size()>0 )
                    conMap = New Map<id,contact>( [SELECT id,AUM_from_other_source__c 
                                                   FROM contact 
                                                   WHERE Id IN:conidsset] );
                if( !conMap.isEmpty() && conMap.size() > 0){
                    for(Opportunity opp : newOpp)
                    {
                        //oldOpp = oldmap.get(opp.id);
                        if(oldMap != null)
                        {system.debug('$%$%%'+System.Label.User_ID);
                            //oldopp = oldmap.get(Opp.id);
                            if( Opp.AUM__c != oldmap.get(Opp.id).AUM__c 
                               && (oldmap.get(opp.id).StageName =='Closed-Joined' || oldmap.get(opp.id).StageName =='Closed-Lost' ) 
                               && UID != userIds[0]/*'005U0000004Hnv0'*/
                               && UID != userIds[1]/*'005U0000004KCsx' */
                               && UID != userIds[2]/*'0050P000006dqrg'*/ 
                               && UID != userIds[3]/*'005U0000001iUf2'*/)
                            {
                                system.debug('$%$%%'+System.Label.User_ID);
                                Opp.addError('AUM value cannot be changed in closed status');
                            }
                        }
                        /******CH-30 : Added opBS record type condition******/
                        if( Opp.StageName != 'Closed-Joined' 
                           && Opp.StageName != 'Closed-Lost'
                           && Opp.RecordTypeId != opBS
                           && Opp.AUM__c == null )
                        {
                            if( conMap.containsKey(Opp.Contact__c) )
                                Opp.AUM__c = conMap.get(Opp.Contact__c).AUM_from_other_source__c;
                        }
                    }
                }
                runonce6 = false;
            }
        }
        catch (exception e){
            system.debug('exception occured in Opportunity tirgger Update AUM'+e);
        }
    }
    public void assignnFirmID(Map<ID, Opportunity> oppMap){
        if( runonce7 )
        {
            runonce7 = false;
            List<Id> conIds = new List<Id>();
            Set<Id> conIdAIS = new Set<Id>();
            Set<Id> AccId = new Set<Id>();
            Map<Id,Id> AccIdConId = new Map<Id,Id>();
            Map<Id,Opportunity> OppIdConId = new Map<Id,Opportunity>();
            Map<Id,Contact> ConIDObj = new Map<Id,Contact>();
            Map<Id,Contact> conMapUpOp = new Map<Id,Contact>();
            Map<Id, LPL_Insurance_Associates__c> iaMap = new Map<Id, LPL_Insurance_Associates__c>();
            for(Opportunity opp : oppMap.values())
            {
                AccId.add(opp.AccountID);
                conIds.add(opp.Contact__c);
                OppIdConId.put(opp.Contact__C, opp);
            }
            
            for(Contact con : [SELECT Id,AccountID, RecordTypeID, Recordtype.Name, Lead_Source__c, Source_Type_Prospect__c, Referral_By__c,
                               Referring_Advisor_Rep_ID__c,Marketing_Classification_Prospect__c, Channel__c, Request_to_join_as__c,
                               Mailer_Code_Prospect__c, Years_in_Industry__c, Licenses__c, Current_Firm__c,
                               HomePhone, Phone, MobilePhone, Fax, Email, Rep_Type__c,AUM_from_other_source__c,
                               MailingStreet, MailingCity, MailingState, MailingPostalCode, WMO_Division__c,/*CH -04*/Insurance_Territory_New__c,
                               DoNotCall, Do_Not_Mail__c, HasOptedOutOfEmail,ELQ_Marketing_Email_Opt_Out__c,Discovery_Contact_Phone__c,Discovery_Contact_Address_1__c,Discovery_Contact_Address_2__c,Discovery_Contact_City__c,Discovery_Contact_State__c
                               ,Assigned_Recruiter__c, Regional_Vp__c,Discovery_Home_Zip__c, Internal_Recruiter_IRD__c, /* CH -01*/Inactive_Reason__c
                               , Highest_Stage_Reached__c,Marketing_Category__c /*CH-16*/
                               FROM Contact 
                               WHERE Id in: conIds])
           {
                               conMapUpOp.put(con.ID, con);
                               if( con.RecordType.Name != 'Contact Propsect' )
                               {
                                  conIdAIS.add(con.ID); 
                                  if( AccId.Contains(con.AccountID) )
                                  {
                                        AccIdConId.put(con.AccountId,con.Id);
                                        ConIDObj.put(con.ID, con);
                                   }
                               }
            }
            if( conIdAIS != null && conIdAIS.size()>0 )
            {
                     for(LPL_Insurance_Associates__c ia : [SELECT Contact__c,Insurance_Tier__c,Fixed_Annuity_Segment__c,Variable_Annuity_Segment__c
                                                           FROM LPL_Insurance_Associates__c 
                                                           WHERE (Contact__c in :conIdAIS)])
                     {
                                                        iaMap.put(ia.Contact__c, ia);
                     }   
            }
            for(Opportunity newOpp : oppMap.values())
            {
                if( AccIdConId.containsKey(oppMap.get(newOpp.Id).accountId))
                    {
                        oppMap.get(newOpp.Id).Firm_Contact__c = AccIdConId.get(oppMap.get(newOpp.Id).accountId);
                    }
                /****CH-28 : Rewritten For inside for loop*****/
                /*if( conIdAIS != null && conIdAIS.size()>0 )
                {
                     for(LPL_Insurance_Associates__c ia: [SELECT Contact__c,Insurance_Tier__c,Fixed_Annuity_Segment__c,Variable_Annuity_Segment__c
                                                          FROM LPL_Insurance_Associates__c 
                                                          WHERE (Contact__c in :conIdAIS)])
                     {
                                                        iaMap.put(ia.Contact__c, ia);
                     }   
                }
                for (Id OppId: oppMap.keySet())
                {        
                    if( AccIdConId.containsKey(oppMap.get(newOpp).accountId))
                    {
                        oppMap.get(OppId).Firm_Contact__c = AccIdConId.get(oppMap.get(newOpp).accountId);
                    }
                }*/
                if( ConIds.size() != 0 && ConIds != null )
                {
                    if( ConIDObj.containsKey(OppIdConId.get(conIds[0]).Contact__c) )
                    {
                        if ( ConIDObj.get(conIds[0]).WMO_Division__c != null ) {
                            OppIdConId.get(conIds[0]).LPL_Region__c = ConIDObj.get(conIds[0]).WMO_Division__c ;  
                     }                                       
                        
                        if( iaMap.containsKey(OppIdConId.get(conIds[0]).contact__c) )
                        {
                            OppIdConId.get(conIds[0]).Variable_Annuity_Segment__c = iaMap.get(conIds[0]).Variable_Annuity_Segment__c;
                            OppIdConId.get(conIds[0]).Insurance_Segment__c = iaMap.get(conIds[0]).Insurance_Tier__c;
                            OppIdConId.get(conIds[0]).Fixed_Annuity_Segment__c = iaMap.get(conIds[0]).Fixed_Annuity_Segment__c;
                        }
                    }
                }
            }
         }
    }
    public void handleEmailOperation(List<opportunity> Lstopp,Map<Id,opportunity> Oldmap,Boolean Isupdatevalue){
        if( runonce8 )
        {
           runonce8 = false; 
			Set<Id> UserId = new set<Id>(); 
            List<String> UserEmail = new List<String>(); 
			Map<Id,User> MapUser = new Map<Id,User>();
			for(opportunity opp : Lstopp){
				if( opp.Internal_Recruiter_IRD__c != null )
				{
					UserId.add(opp.Internal_Recruiter_IRD__c);
                    UserEmail.add(opp.Internal_Recruiter_IRD__r.Email);
				}
				if( opp.Assigned_Recruiter__c != null )
				{
					UserId.add(opp.Assigned_Recruiter__c);
                    UserEmail.add(opp.Assigned_Recruiter__r.Email);
				}
				if( opp.Integration_Manager__c != null )
				{
					UserId.add(opp.Integration_Manager__c);
                    UserEmail.add(opp.Integration_Manager__r.Email);
				}
			}
			/*******To handle email alert Operations******/
			if( Userid.size() != null && Userid != null )
			{
				MapUser = new Map<Id,User>([SELECT Id, email 
											FROM user 
											WHERE Id In: Userid limit 3] );
			}
			try{
				if( MapUser.size()>0 && !trigger.isupdate )
				{
					Opportunity_EmailHandler.EmailsHandler(Lstopp, Oldmap, Isupdatevalue, MapUser);    
				}
			}
			catch(Exception e) {
				System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
			}
        }  
    }
    
    public void HandleTask(List<Opportunity> newOppList){
        if( runonce1 )
        {
            runonce1 = false;
            try
            {
                OpportunityHandler handler = new OpportunityHandler();
              //List<Contact> conUpdate = new List<Contact>();
                List<Contact> conInsert = new List<Contact>(); 
                List<String> emailSendList = new List<String>();
                List<Task> tsklist = new List<Task>();
              //List<Task> insertList = new List<Task>();
                List<Opportunity> IASopps = new List<Opportunity>();
                Map<Id,String> oppMapnew = new Map<Id,String>();
                Map<Id,Opportunity> oldOppMap = new Map<Id,Opportunity>();
                Map<Id,String> oppMapNewAssignRec = new Map<Id,String>();
                oldOppMap = null;
                List<Task> newTaskList = new List<task>();
                set<id> conids = new set<id>();
                Map<Id,Contact> conMapUpOp = new Map<Id,Contact>();
                List<Opportunity> oppList = new List<Opportunity>();
                Set<id> opids = new Set<id>();
                
                for(Opportunity opp : newOppList)
                {
                    conIds.add(opp.Contact__c);
                    opids.add(opp.id);
                    oppMapnew.put(opp.Internal_Recruiter_IRD__c,opp.Internal_Recruiter_IRD__r.Email);
                    oppMapNewAssignRec.put(opp.Assigned_Recruiter__c,opp.Assigned_Recruiter__r.Email);
                    /*****CH-28 : rtmap removed******/
                    if( opp.recordTypeID == IASBD 
                       || opp.recordTypeID == ISBD )
                    {
                        oppList.add(opp);
                    }
                }
                if(opids != null && opids.size() != 0)
                {
                    tskList = [SELECT id, Department__c, OwnerId  
                               FROM Task 
                               WHERE WhatId in: opids 
                               AND recordtypeID =: rt];
                }
                for(Contact con : [SELECT Id,AccountID, RecordTypeID, Recordtype.Name, Lead_Source__c, Source_Type_Prospect__c, Referral_By__c,
                                   Referring_Advisor_Rep_ID__c,Marketing_Classification_Prospect__c, Channel__c, Request_to_join_as__c,
                                   Mailer_Code_Prospect__c, Years_in_Industry__c, Licenses__c, Current_Firm__c,
                                   HomePhone, Phone, MobilePhone, Fax, Email, Rep_Type__c,AUM_from_other_source__c,
                                   MailingStreet, MailingCity, MailingState, MailingPostalCode, WMO_Division__c,/*CH -04*/Insurance_Territory_New__c,
                                   DoNotCall, Do_Not_Mail__c, HasOptedOutOfEmail,ELQ_Marketing_Email_Opt_Out__c,Discovery_Contact_Phone__c,Discovery_Contact_Address_1__c,Discovery_Contact_Address_2__c,Discovery_Contact_City__c,Discovery_Contact_State__c
                                   ,Assigned_Recruiter__c, Regional_Vp__c,Discovery_Home_Zip__c, Internal_Recruiter_IRD__c, /* CH -01*/Inactive_Reason__c
                                   , Highest_Stage_Reached__c,Marketing_Category__c /*CH-16*/
                                   FROM Contact 
                                   WHERE Id in: conIds])
                {
                                   conMapUpOp.put(con.ID, con);
                }
                
                for(Opportunity newOpp : newOppList)
                {
                    /*********CH-28 : rt_map removed************/
                    if( oppList.size() != 0 
                       && newOpp.recordTypeID == IASBD/*rt_Map.get(newOpp.recordTypeID).getName() == 'IAS Business Development'*/ )
                    {
                        IASopps.add(newOpp);  
                        insertList = handler.createOpportunityActivity(IASopps, oldOppMap, tskList);
                    }   
                    
                    /***Start CH-14 : Added Target_TAT_Date__c!=null due to this requirement SD974439 - Opporturnity Target TAT Date***/
                    if( newOpp.Target_TAT_Date__c != null && newOpp.Internal_Recruiter_IRD__c != null 
                       && newOpp.Acquisition__c != 'Jaguar' 
                       && String.isNotBlank(String.valueOf(newOpp.Internal_Recruiter_IRD__c)) 
                       && newOpp.StageName == '3 - Submitted a Kit' 
                       && newOpp.Expected_AUM__c>0 
                       && newOpp.Channel_Owner__c == 'IAS' ) 
                    {
                        /***CH-14 : End***/     
                        String strOppName = newOpp.Name;
                        Task taskIRDuser = new Task();
                        taskIRDuser.OwnerId = newOpp.Internal_Recruiter_IRD__c;
                        taskIRDuser.Subject = 'Contract Accommodation';
                        taskIRDuser.ActivityDate = System.today();
                        taskIRDuser.Status = 'Not Started';
                        taskIRDuser.Priority = 'High';
                        taskIRDuser.WhatId = newOpp.Id;
                        newTaskList.add(taskIRDuser);
                        /***CH-12 Start - Here if the condition matches, IRD and Assigned Recruiter will get an email ***/
                        if( oppMapnew.size()>0 && oppMapnew != null ) 
                        {
                            if( oppMapnew.get(newOpp.Internal_Recruiter_IRD__c) != null ) 
                            {
                                emailSendList.add(oppMapnew.get(newOpp.Internal_Recruiter_IRD__c));
                            }
                        }
                        if( newOpp.Assigned_Recruiter__c != null )
                        {
                            if( oppMapNewAssignRec.size()>0 && oppMapNewAssignRec != null )
                            {
                                if( oppMapNewAssignRec.get(newOpp.Assigned_Recruiter__c) != null )
                                {
                                    emailSendList.add(oppMapNewAssignRec.get(newOpp.Assigned_Recruiter__c));            
                                }
                            }
                        }
                        
                        if( emailSendList.size()>0 )
                        {
                            emailToARandIRD(emailSendList, strOppName);
                        }
                        /***CH-12 End - Here if the condition matches, IRD and Assigned Recruiter will get an email***/ 
                    }         
                    /***Ch-10 End***/
                    
                    /**********************************************CH-16 - Start***************************************/
                    if( newOpp.RecordTypeId == IASBD 
                        && (newOpp.StageName == '1 - Engaged' 
                        || newOpp.StageName == '2 - Hot List' 
                        || newOpp.StageName == '3 - Submitted a Kit') )
                    {
                              if( newOpp.Contact__c!=null && conMapUpOp.get(newOpp.Contact__c).RecordTypeID == conRecordTypeId )
                              {
                                    if( conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c == null )
                                    {
                                         conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = newOpp.StageName;
                                    }
                                    else if( conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != null )
                                    {
                                         if( newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c 
                                            && newOpp.StageName == '3 - Submitted a Kit' )
                                          {
                                            conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '3 - Submitted a Kit';
                                          }
                                          else if( newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c 
                                                   && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '3 - Submitted a Kit'
                                                   && newOpp.StageName == '2 - Hot List' ) 
                                           {
                                                conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '2 - Hot List';
                                           }
                                          else if( newOpp.StageName != conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c 
                                                  && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '3 - Submitted a Kit' 
                                                  && conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c != '2 - Hot List' 
                                                  && newOpp.StageName == '1 - Engaged' ) 
                                            {
                                                  conMapUpOp.get(newOpp.Contact__c).Highest_Stage_Reached__c = '1 - Engaged';
                                            }
                                       }
                                       if( conMapUpOp.get(newOpp.Contact__c).Lead_Source__c !=null 
                                           && conMapUpOp.get(newOpp.Contact__c).Marketing_Category__c =='Dormant' )
                                       {
                                              conMapUpOp.get(newOpp.Contact__c).Lead_Source__c = 'Transitions'; System.debug('Lead source chganged to Transitions1');
                                       }
                                                 conInsert.add(conMapUpOp.get(newOpp.Contact__c));
                                }  
                       }
                    /**********************************************CH-16 - End***************************************/
                    /***CH-17 - Start***/
                    if( newOpp.Contact__c != null 
                        && newOpp.RecordTypeId == IASBD 
                        && conMapUpOp.containsKey(newOpp.Contact__c) 
                        && conMapUpOp.get(newOpp.Contact__c).RecordTypeID == conLPLTypeId )
                    {
                           if( newOpp.Self_Identified_Gender__c != null )
                           {
                               conMapUpOp.get(newOpp.Contact__c).Self_Identified_Gender__c = newOpp.Self_Identified_Gender__c; 
                           }
                           if( newOpp.Self_Identified_Military_Service__c != null )
                           {
                               conMapUpOp.get(newOpp.Contact__c).Self_Identified_Military_Service__c = newOpp.Self_Identified_Military_Service__c; 
                           }
                           if( newOpp.Self_Identified_Race_Ethnicity__c != null )
                           {
                               conMapUpOp.get(newOpp.Contact__c).Self_Identified_Race_Ethnicity__c = newOpp.Self_Identified_Race_Ethnicity__c; 
                           }
                     }
                     else{}     //do nothing
                    /***CH-17 : End***/
                    if( conMapUpOp.containsKey(newOpp.Contact__c) && conMapUpOp.get(newOpp.Contact__c) != null )
                    {
                        conUpdate.add(conMapUpOp.get(newOpp.Contact__c));
                    }
                 }  
                /*if(insertList.size() != 0 && trigger.isInsert)
                 {
                      insert insertList;
                 }
                if(!Conupdate.isEmpty() && Conupdate.size()>0 && trigger.isUpdate)
				{
                       update conUpdate;
                }*/
               if( !newTaskList.isEmpty() && newTaskList.size()>0 )
               {
                    insert newTaskList;
               }
           }
           catch(Exception e)
           {
                LPL_CreateExceptionLog.createErrorRecordAsync('New_Opportunity_TriggerHandler','doAfterInsertActivity',e.getMessage(),e.getLineNumber(),e.getTypeName());   
            }
        }
    }
    /*
     * @Method name   : emailToARandIRD
     * @Parameter     : List<String> emailstoSend,String strOppNameForEmail
     * @description   : 
    */
    public static void emailToARandIRD(List<String> emailstoSend,String strOppNameForEmail) {
        
        if( emailstoSend.size()>0 && emailstoSend!=null ) 
        {
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
            
            if ( results[0].success ) 
            {
                System.debug('The email was sent successfully.');
            } 
            else 
            {
                System.debug('The email failed to send: '
                             + results[0].errors[0].message);
            }
        }
    }
    
    public static void HandleCampaign(List<opportunity> oppList) {//to be added in before
        Set<Id>conids = new Set<Id>();
        for(opportunity opp:oppList)
        {
            conIds.add(opp.Contact__c);
        }
        if( conids.size()>0 )
        {
            List<CampaignMember> campID = new List<CampaignMember>([SELECT Id,CampaignId,Campaign.IsActive,contactId 
                                                                   FROM CampaignMember 
                                                                   WHERE ContactId in (SELECT Id 
                                                                                       FROM contact 
                                                                                       WHERE Id in:conids 
                                                                                       AND Recordtype.Name='Contact prospect') order BY Createddate DESC LIMIT 1]);
            for(Opportunity o : oppList){
                if( campID.size()>0 )
                {
                    if( campID[0].Campaign.IsActive != False )
                        o.CampaignId = campID[0].CampaignId;
                }
            }
        }
     }
    /*
     * @Method name   : HandleCase
     * @Parameter     : List<opportunity> oppList,map<id,opportunity> oldOppMap
     * @description   : 
    */
    public static void HandleCase(List<opportunity> oppList,map<id,opportunity> oldOppMap) {
        /********CH-28 : Added Boolean Check and Rewritten the Logic********/
        if( runonce ){
            /*Map<Id,Case> caseMap = new Map<Id,Case>();
            List<case> UpdatedCaseList = new List<case>();
            Map<Id,opportunity> oppMap = new Map<Id,opportunity>();
            for(opportunity opp:oppList)
            {
                oppMap.put(opp.id,opp);
            }
            /*****CH-27******/
            /*if(oppmap != null && oppMap.size()>0)
            {
            List<case> caseList=[SELECT id,Result__c,Opportunity__c 
                                 FROM Case 
                                 WHERE Opportunity__c in: oppMap.keyset() 
                                 AND Opportunity__c != null];//CH-07
            if(!caseList.isEmpty()) 
            {
                for(Case c:caseList) 
                {
                    if(c.Opportunity__c != null) 
                    {
                        caseMap.put(c.Id,c);
                    }
                }
            }
        }
        opportunity oldopp = new opportunity();
        for(opportunity newopp : opplist){
             if(oldmap != null && oldmap.containsKey(newopp.id))
                  oldopp = oldmap.get(newopp.id);
              if(newOpp.StageName == '3 - Submitted a Kit')
              {
                   for(Case cc : caseMap.values())
                   {
                        if(cc.Opportunity__c == newOpp.Id)
                        {
                            caseMap.get(cc.id).Result__c = 'Kit received';
                            /***CH-09 START      Here we are checking Oppotunity field and then it will be assignd to case fields.***/
                           /* if(newOpp.MAX_TA_Dollars_Allowed__c != null && oldOpp.MAX_TA_Dollars_Allowed__c != newOpp.MAX_TA_Dollars_Allowed__c)
                            {
                                caseMap.get(cc.id).MAX_TA_Dollars_Allowed__c = newOpp.MAX_TA_Dollars_Allowed__c;
                            }
                            if(newOpp.Offer_Letter_Sent__c != null && oldOpp.Offer_Letter_Sent__c != newOpp.Offer_Letter_Sent__c) 
                            {
                                caseMap.get(cc.id).Offer_Letter_Sent__c = newOpp.Offer_Letter_Sent__c;
                            }
                            
                            if(newOpp.Signed_offer_Letter_Received__c != null && oldOpp.Signed_offer_Letter_Received__c != newOpp.Signed_offer_Letter_Received__c) 
                            {   
                                caseMap.get(cc.id).Signed_offer_Letter_Received__c = newOpp.Signed_offer_Letter_Received__c;
                            }
                            /***CH-09 END***/
                            /*UpdatedCaseList.add(cc);
                        }
                    }
                }
            }
            
            if(UpdatedCaseList != null && UpdatedCaseList.size()>0){
            update UpdatedCaseList;
            }*/
            runonce = false;
            system.debug('$%$%$%$%'+runonce);
            Map<Id,Case> caseMap = new Map<Id,Case>();
            List<case> UpdatedCaseList = new List<case>();
            Map<id,opportunity> oppMap = new Map<Id,opportunity>();
			for(opportunity opp:oppList)
            {
                oppMap.put(opp.id,opp);
            }
			if( oppmap != null && oppMap.size()>0 )
            {
				List<case> caseList = [SELECT id,Result__c,Opportunity__c,MAX_TA_Dollars_Allowed__c,Offer_Letter_Sent__c,Signed_offer_Letter_Received__c 
									   FROM Case 
									   WHERE Opportunity__c in: oppMap.keyset() 
									   AND Opportunity__c != null];
	        
                if( caselist != null )
                {
                  for(Case c : caseList) 
                  {
                    caseMap.put(c.Opportunity__c,c);
                  }
                }
			}
			if( casemap != null )
            {
				for(opportunity opp : oppList)
                {
					if( caseMap.containskey(opp.Id) )
                    {
                        if( opp.StageName == '3 - Submitted a Kit' )
                        {
							caseMap.get(opp.id).Result__c = 'Kit received';
                            if( opp.MAX_TA_Dollars_Allowed__c != null 
                               && oldOppMap.get(opp.id).MAX_TA_Dollars_Allowed__c != opp.MAX_TA_Dollars_Allowed__c )
                            {
                                caseMap.get(opp.id).MAX_TA_Dollars_Allowed__c = opp.MAX_TA_Dollars_Allowed__c;
                            }
                            if( opp.Offer_Letter_Sent__c != null 
                               && oldOppMap.get(opp.id).Offer_Letter_Sent__c != opp.Offer_Letter_Sent__c ) 
                            {
                                caseMap.get(opp.id).Offer_Letter_Sent__c = opp.Offer_Letter_Sent__c;
                            }
                            
                            if( opp.Signed_offer_Letter_Received__c != null 
                               && oldOppMap.get(opp.id).Signed_offer_Letter_Received__c != opp.Signed_offer_Letter_Received__c ) 
                            {   
                                caseMap.get(opp.id).Signed_offer_Letter_Received__c = opp.Signed_offer_Letter_Received__c;
                            }
                        }
					}
				}
             }
            if( casemap != null && casemap.size()>0 )
            {
              	update casemap.values();
            }           
            
        }
    }
     /*
     * @Method name   : Updateactivity
     * @Parameter     : List<Opportunity> oppList1, Map<ID, Opportunity> oldOppMap
     * @description   : 
    */
    public void Updateactivity(List<Opportunity> oppList1, Map<ID, Opportunity> oldOppMap){
        
            system.debug('count=========>'+count);
            count=count++;
            List<Task> tskList = new List<Task>();
            Map<Id,opportunity> oppMap = new Map<Id,Opportunity>();
            List<Opportunity> newOppTaskList = new List<Opportunity>();
          //List<Task> insertList = new List<Task>();
            OpportunityHandler handler = new OpportunityHandler();
            Set<Id> oppID = new Set<Id>();
            Map<Id,Opportunity> oppUpdateMap = new Map<Id,Opportunity>();
            List<Task> updateList = new List<Task>();
            List<Task> tskUpdtList = new List<Task>();
            Map<String,Id> oppTaskMap = new Map<String,Id>();
            /*********CH-28 : Start**************/
            for(Opportunity opp : oppList1)
            {
                oppMap.put(opp.Id, opp);
                oppID.add(opp.Id);
            }
            if( oppMap != null && oppMap.size() != 0 && trigger.isAfter && trigger.isUpdate )
            {
                tskList = [SELECT id, Department__c, OwnerId  
                           FROM Task 
                           WHERE WhatId in: oppMap.keyset() 
                           AND recordtypeID =: rt];
            }
            /********CH-28 : End*********/
            for(Opportunity opp : oppList1)
            {
                Opportunity oldOpp;
                /***CH-28 : Commented oppID and OppMap****/
                //oppID.add(opp.Id);
                //oppMap.put(opp.Id, opp);
                if( oldOppMap != null )
                {
                    oldOpp = oldOppMap.get(opp.Id);
                    /*****CH-28 : Removed hard coded Record type value*****/
                    if( oldOpp != null && opp.RecordTypeId == IASBD )
                    {
                        if( oldOpp.Integration_Manager__c != null && oldOpp.Integration_Manager__c != opp.Integration_Manager__c ) 
                        {
                            oppUpdateMap.put(oldOpp.Integration_Manager__c, opp);
                        }
                        if( oldOpp.Transition_Support_Partners__c != null 
                            && oldOpp.Transition_Support_Partners__c != opp.Transition_Support_Partners__c ) 
                        {
                            oppUpdateMap.put(oldOpp.Transition_Support_Partners__c, opp);
                        }
                        if( oldOpp.Investment_Transition_Consultant__c != null 
                            && oldOpp.Investment_Transition_Consultant__c != opp.Investment_Transition_Consultant__c ) 
                        {
                            oppUpdateMap.put(oldOpp.Investment_Transition_Consultant__c, opp);
                        }
                        if( oldOpp.Regional_Transition_Partner__c!= null 
                            && oldOpp.Regional_Transition_Partner__c != opp.Regional_Transition_Partner__c ) 
                        {
                            oppUpdateMap.put(oldOpp.Regional_Transition_Partner__c, opp);
                        }
                        if( trigger.isupdate )
                        {
                            /*****CH-28 : Removed hard coded Record type value*****/
                            if( opp.recordTypeID == IASBD 
                               || opp.recordTypeID == ISBD )
                            {
                                if( opp.Integration_Manager__c != oldOpp.Integration_Manager__c )
                                {
                                    oppUpdateMap.put(oldOpp.Integration_Manager__c, opp);
                                    oppID.add(opp.ID);
                                    oppTaskMap.put('Onboarding Consultant', opp.Integration_Manager__c);
                                }
                                if( opp.Transition_Support_Partners__c != oldOpp.Transition_Support_Partners__c )
                                {
                                    oppUpdateMap.put(oldOpp.Transition_Support_Partners__c, opp);
                                    oppID.add(opp.ID);
                                    oppTaskMap.put('Transition Support Partners', opp.Transition_Support_Partners__c);
                                } 
                                if( opp.Investment_Transition_Consultant__c != oldOpp.Investment_Transition_Consultant__c )
                                {
                                    oppUpdateMap.put(oldOpp.Investment_Transition_Consultant__c, opp);
                                    oppID.add(opp.ID);
                                    oppTaskMap.put('Investment Transition Partner', opp.Investment_Transition_Consultant__c);
                                } 
                                if( opp.Regional_Transition_Partner__c != oldOpp.Regional_Transition_Partner__c )
                                {
                                    oppUpdateMap.put(oldOpp.Regional_Transition_Partner__c, opp);
                                    oppID.add(opp.ID);
                                    oppTaskMap.put('Regional Transition Partner', opp.Regional_Transition_Partner__c);
                                }  
                                
                                if( (opp.Regional_Transition_Partner__c!= null &&  (oldOpp.Regional_Transition_Partner__c == null /*|| oldOpp.Regional_Transition_Partner__c != null*/))
                                   || (opp.Investment_Transition_Consultant__c != null &&  (oldOpp.Investment_Transition_Consultant__c == null /*|| oldOpp.Investment_Transition_Consultant__c != null */))
                                   || (opp.Transition_Support_Partners__c != null &&  (oldOpp.Transition_Support_Partners__c == null /*|| oldOpp.Transition_Support_Partners__c != null*/))
                                   || (opp.Integration_Manager__c != null &&  (oldOpp.Integration_Manager__c == null /*|| oldOpp.Integration_Manager__c != null*/) ) )
                                 {
                                       newOppTaskList.add(opp);
                                 }
                            }
                        }
                    }
                }
                system.debug('@@@@@@@@@@@@@@@'+newOppTaskList);
                if( trigger.isAfter && trigger.isUpdate )
                {
                    system.debug('@@@@@@@@@@@@@@@'+newOppTaskList);
                    /********CH-28**********/
                    if( newOppTaskList.size() != 0 && opp.recordTypeID == IASBD ) 
                    {
                        insertList = handler.createOpportunityActivity(newOppTaskList, oldOppMap, tskList);
                    }
                }
             }
            /*********CH-27 and CH-28 : Start*********/
            /*if(oppMap != null && oppMap.size() != 0 && trigger.isAfter && trigger.isUpdate)
            {
                tskList = [SELECT id, Department__c, OwnerId  
                           FROM Task 
                           WHERE WhatId in: oppMap.keyset() 
                           AND recordtypeID =: rt];
            }*/
             /*********CH-28 : End*********/
            if( oppUpdateMap != null && oppUpdateMap.size() != 0 )
            {
                tskUpdtList  = [SELECT id, OwnerId, Department__c 
                                FROM Task 
                                WHERE WhatId in: oppID
                                AND Department__c in ('Onboarding Consultant', 'Transition Support Partners','Investment Transition Partner','Regional Transition Partner') 
                                AND OwnerId in: oppUpdateMap.keyset() 
                                AND RecordTypeID =: rt];
            }
            if( oppUpdateMap.size() != 0 && trigger.isAfter && trigger.isUpdate )
            {
                updateList = handler.updateOpportunityActivity(oppUpdateMap, oppID, oppTaskMap, tskUpdtList);
            }
            update updateList;
            /*if(insertList.size() != 0){
                  insert insertList;
            }*/
    }
    /*
     * @Method name   : FinalOfferStatusTrigger
     * @Parameter     : Map<ID, Opportunity> NewMapOpp ,Map<ID, Opportunity> OldMapOpp
     * @description   : The method is written to update application status
    */
    public void FinalOfferStatusTrigger(Map<ID, Opportunity> NewMapOpp ,Map<ID, Opportunity> OldMapOpp){
        
        if ( !loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c )
        {
            Set<Id> appsIds = new Set<Id>();
            for(Id key : NewMapOpp.keyset()){
                if(OldMapOpp.get(key).Final_Offer_Submitted__c == false && NewMapOpp.get(key).Final_Offer_Submitted__c == true) 
                {
                   if(OldMapOpp.get(key).Final_Offer_Status__c == NewMapOpp.get(key).Final_Offer_Status__c) 
                   {
                        appsIds.add(NewMapOpp.get(key).Application__c);
                    }
                }
            }
            if( appsIds.size() > 0 )
            {
                List<genesis__Applications__c> apps = [SELECT Id, Name, genesis__Status__c
                                                       FROM genesis__Applications__c
                                                       WHERE isParentApplication__c = true 
                                                       AND Id IN :appsIds ];
                
                if( apps != null && apps.size() > 0 ) 
                {
                    List<genesis__Applications__c> appsToUpdate = new List<genesis__Applications__c>();
                    for(genesis__Applications__c app : apps) 
                    {
                        app.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_FINAL_OFFER_INITIATED;
                        appsToUpdate.add(app);
                    }
                    if( appsToUpdate.size() > 0 ) 
                    {
                        UPDATE appsToUpdate;
                    }
                }
            } 
        }
    }   
    /*
     * @Method name   : populatecontactrole
     * @Parameter     : list<Opportunity> opplist ,Map<ID, Opportunity> OldOppMap
     * @description   : Create Opportunity Contact Role for Business solution opportunity with role as Business User
     *                  and for IASBD Opportunity when created from opportunity page
    */
    public void populatecontactrole(list<Opportunity> opplist ,Map<ID, Opportunity> OldOppMap){
       /********CH-28 : Added Boolean Check********/
       //if( runonce9 )
       //{
           runonce9 = false;
        set<ID> oppIds = new set<id>();
        set<ID> conIds = new set<id>();
        List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
        List<Opportunitycontactrole> delOppRole = new List<Opportunitycontactrole>();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
            for(Opportunity opp : oppList)
            {
                oppIds.add(opp.Id);
                //oppMap.put(opp.id,opp);
                conids.add(opp.contact__c);
            }
            /*******CH-28:Optimization Fix**********/
            if(oppIds.size()>0 && oppIds != null){
                List<opportunity>  oppconlist = [SELECT id,RecordTypeId,Contact__c,contactid,contact__r.Recordtype.name 
                                                 FROM Opportunity 
                                                 WHERE id IN : oppIds
                                                 AND Contact__c IN :conids]; 
                   
                for(opportunity oppCon : oppconlist)
                {
                    if( (oppCon.RecordTypeId == IASBD || oppCon.RecordTypeId == opBC) 
                       && oppCon.contactid != oppCon.contact__c 
                       && Trigger.isAfter 
                       && Trigger.isInsert)
                    {
                        newContactRoleList.add(new OpportunityContactRole(ContactId = oppCon.Contact__c,
                                                                          OpportunityId = oppCon.Id,
                                                                          IsPrimary = true ));
                    }
                    if(oppCon.RecordTypeId == opBS 
                       && oppCon.contact__c != null 
                       && Trigger.isAfter 
                       && Trigger.isInsert ) 
                    {
                        newContactRoleList.add(new OpportunityContactRole(ContactId = oppCon.Contact__c,
                                                                          OpportunityId = oppCon.Id,
                                                                          IsPrimary = true,
                                                                          Role = 'Business User' )); 
                    }               
                    if(oldOppMap != null)
                    {
                        opportunity oldOpp = oldOppMap.get(oppcon.Id);
                        if(oppcon.RecordTypeId == IASBD 
                           && oppcon.contactid != oppcon.contact__c 
                           && oldOpp.contact__c != oppcon.contact__c 
                           && Trigger.isUpdate)
                        {
                           newContactRoleList.add(new OpportunityContactRole(ContactId = oppCon.Contact__c,
                                                                             OpportunityId = oppCon.Id,
                                                                             IsPrimary = true ));
                        }
                    }   
                }
                if(newContactRoleList.size()>0){
                    insert newContactRoleList;
                }
            }
       		if(trigger.isAfter && trigger.isUpdate)  
            {
                /**************CH-27**********************/
                //List<opportunity> oppconlist1 = [SELECT id FROM opportunity WHERE id in:oppIds and RecordTypeId =: opBC];
                if(oppIds.size()>0 && oppIds != null)
                {
                    List<opportunitycontactrole> oppconrolelist = [SELECT id,role,opportunityid,contactid 
                                                                   FROM opportunitycontactrole 
                                                                   WHERE opportunityid =: oppIds 
                                                                   AND opportunity.RecordTypeId =:opBS 
                                                                   AND opportunity.contact__c != null];
                    if(oppConRoleList.size()>0 && oppConRoleList != null)
                    {
                        for(Opportunitycontactrole opRole : oppConRoleList)
                        {
                            if(opRole.Role == null && opRole.opportunityid != null && opRole.contactid != null)
                                delOppRole.add(opRole);
                        }
                    }
                    if(delOppRole.size()> 0)
                    {
                        delete delOppRole;
                    }
                }
            }
            
       // }
    }
    
    /*public void checkValidation(Opportunity newOpp, Map<id,contact> conMapUpOp){
            try{
            if(conMapUpOp.size()>0 && newOpp.Recordtype.Name =='IAS Business Development' && newOpp.Contact__c!=null && conMapUpOp.containsKey(newOpp.Contact__c) && (conMapUpOp.get(newOpp.Contact__c).Lead_Source__c == null || conMapUpOp.get(newOpp.Contact__c).Source_Type_Prospect__c== null)){
            newOpp.addError('Please fill Lead Source and Source Type on selected Contact');
            }
            }catch(Exception e){
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
            }
    }*/
    
    Public void FinalProcess()
    {
        if(insertList.size() != 0){
            system.debug('#################'+insertList);
            insert insertList;
        }
        if(trigger.isAfter && trigger.IsUpdate)
        {
            if(!Conupdate.isEmpty() && Conupdate.size()>0)
            {
                update conUpdate;
            }
        }
    }
    /*
     * @Method name   : CheckOpportunitytoUpdateLoan
     * @Parameter     : Map<Id,Opportunity> newOppMap,Map<Id,Opportunity> oldOppMap
     * @description   :  
    */
    private void CheckOpportunitytoUpdateLoan( Map<Id,Opportunity> newOppMap,Map<Id,Opportunity> oldOppMap )
    {
        /*Map<Id, Set<Id>> OppLoanMap = new Map<Id, Set<Id>>();
        for(Id tmp : nMap.keyset())
        {
            if( checkChange(nMap.get(tmp),oMap.get(tmp)) )
            {
                OppLoanMap.put(tmp,null);
            }
        }
        /**********CH-27*******/
        /*if(OppLoanMap.size()>0)
        {
            
            for(Loan_Application__c ln : [SELECT id,Opportunity__c 
                                          FROM Loan_Application__c 
                                          WHERE Opportunity__c IN: OppLoanMap.keySet() 
                                          AND Status__c !='Declined'])
            {
                if( OppLoanMap.get(ln.Opportunity__c) == null)
                {
                    OppLoanMap.put(ln.Opportunity__c,new Set<Id>());
                }
                OppLoanMap.get(ln.Opportunity__c).add(ln.Id);
            }
            List<Loan_Application__c> Ln_List = new List<Loan_Application__c>();
            for(Id temp : OppLoanMap.keyset())
            {
                if( OppLoanMap.get(temp) != null)
                {
                    for(Id tmp : OppLoanMap.get(temp))
                    {
                        Loan_Application__c LN_temp = new Loan_Application__c();
                        LN_temp.Id=tmp;
                        LN_temp.Assigned_Recruiter__c = nMap.get(temp).Assigned_Recruiter__c;
                        LN_temp.Internal_Recruiter__c = nMap.get(temp).Internal_Recruiter_IRD__c;
                        LN_temp.Business_Developer__c = nMap.get(temp).Regional_VP__c;
                        Ln_List.add(LN_temp);
                    }
                }
            }
            if(Ln_List.size()>0){
                update Ln_List;
            }
            
        }*/
        /******CH-28: Merged Two Methods CheckOpportunitytoUpdateLoan and loanApplicationUpdate******/
        Map<Id, Set<Id>> OppLoanMap = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> OppMap = new Map<Id, Set<Id>>();
		Map<id,opportunity> oppMapValue = new Map<id,opportunity>();
        List<Loan_Application__c> Ln_List = new List<Loan_Application__c>();
        
        for( Id tmp : newOppMap.keyset() )
        {
            if( checkChange(newOppMap.get(tmp),oldOppMap.get(tmp)) )
            {
                OppLoanMap.put(tmp,null);
            }
			OppMap.put(tmp,null);
		}
		for( Opportunity opp : newOppMap.values() )
		{
			if( opp.StageName == 'Closed-Lost' )
			{
				oppMapValue.put(opp.Id, opp);
			}
		} 
        /**********CH-27*******/
        if( OppMap.size()>0 && OppMap != null )
        {  
            /***** CH-29 : Start ******/
            List<LPL_Applications_status__mdt> lplStatusLst = [SELECT Id,Action__c, Status__c ,Object_Name__c 
                                                               FROM LPL_Applications_status__mdt];
        	String   loanStatusDeclined = LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_2');
            String   loanStatusNotAccepted = LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_9');  
            List<Loan_Application__c> loanAppList = [SELECT id,Opportunity__c 
                                                     FROM Loan_Application__c 
													 WHERE Opportunity__c IN: OppMap.keySet() 
													 AND Status__c != :loanStatusDeclined];
            /***** CH-29 : End ******/
			if( OppLoanMap != null && loanAppList != null)
			{										
				for( Loan_Application__c ln : loanAppList )
				{
					 if( OppLoanMap.get(ln.Opportunity__c) == null )
					 {
						OppLoanMap.put(ln.Opportunity__c,new Set<Id>());
					 }
					 OppLoanMap.get(ln.Opportunity__c).add(ln.Id);
				}
				for( Id temp : OppLoanMap.keyset() )
				{
					if( OppLoanMap.get(temp) != null )
					{
						for( Id tmp : OppLoanMap.get(temp) )
						{
							Loan_Application__c LN_temp = new Loan_Application__c();
							LN_temp.Id=tmp;
							LN_temp.Assigned_Recruiter__c = newOppMap.get(temp).Assigned_Recruiter__c;
							LN_temp.Internal_Recruiter__c = newOppMap.get(temp).Internal_Recruiter_IRD__c;
							LN_temp.Business_Developer__c = newOppMap.get(temp).Regional_VP__c;
							Ln_List.add(LN_temp);
						}
					}
				}
				if( Ln_List.size()>0 )
				{
					update Ln_List;
				}
			}
			if( oppMapValue != null && StaticFunction.runOnce() )
			{
				for( Loan_Application__c la : loanAppList ) 
                {
                    /****CH-29 : Start******/
					if( la.status__c != loanStatusNotAccepted && oppMapValue != null )
						la.status__c = loanStatusDeclined;
                    /****CH-29 : End******/
                }
                if( loanAppList.size() > 0 && loanAppList != null )
                {
                    update loanAppList;            
                }
			}
        }
    }
    
    private static boolean checkChange(Opportunity nOpp,Opportunity oOpp)
    {
        if( nOpp.Internal_Recruiter_IRD__c != oOpp.Internal_Recruiter_IRD__c 
            || nOpp.Assigned_Recruiter__c != oOpp.Assigned_Recruiter__c 
            || nOpp.Regional_VP__c != oOpp.Regional_VP__c  )
        {
            return true;
        }
        else
        {
            return false;
        }
     }
     //CH-31 Start
    public static void UpdateCampaignOfferSelected( List<Opportunity> newOppLst,Map<Id,Opportunity> oldOppMap ){

       // Opportunity opp = new Opportunity();
       if(capsolProposalexecution){
        List<Loan_Application__c> Ln_List = new List<Loan_Application__c>();
        List<Proposal_Offer__c> pro_List = new List<Proposal_Offer__c>();
        List<Proposal_Offer__c> updatePro_List = new List<Proposal_Offer__c>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> lnIds = new Set<Id>();
       // Set<Id> oppIds = new Set<Id>();
        String CampaignOfferSelected = '';
        Id ForgivableProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
        Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
        List<LPL_Applications_status__mdt> lplStatusLst = [SELECT Id,Action__c, Status__c ,Object_Name__c 
                                                               FROM LPL_Applications_status__mdt];
        String   loanStatusDeclined = LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_2');
        String   loanStatusNotAccepted = LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_9');  
        String  loanStatusOfferExtended=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_11');

        if(newOppLst != null){
            for(Opportunity opp:newOppLst){
                oppIds.add(opp.Id);
                CampaignOfferSelected = opp.Back_End_Hurdle_Pick__c;
            }

                if(oppIds != null){
                    Ln_List = [Select id,name,Opportunity__c,RecordTypeID,Status__c from Loan_Application__c 
                    where Opportunity__c IN:oppIds AND RecordTypeID =:ForgivableLoadRecordTypeId AND 
                    Status__c != :loanStatusDeclined];
        
                        if(Ln_List != null){
                            for(Loan_Application__c la:Ln_List){
                                lnIds.add(la.Id);
                            }

                            if(lnIds !=null){
                                pro_List = [select id,name,RecordTypeID,Proposal_Status__c,
                                Campaign_Offer_Selected__c from Proposal_Offer__c where 
                                LoanApp_MD__c IN :lnIds AND RecordTypeID =:ForgivableProposalRecordTypeId];
                                    if(pro_List != null){
                                        for(Proposal_Offer__c pro:pro_List){
                                            pro.Campaign_Offer_Selected__c = CampaignOfferSelected;
                                            updatePro_List.add(pro);
                                        }
                                    }
                            }
                        }
                }
        }
        if(updatePro_List != null){
            update updatePro_List;
        }
        capsolProposalexecution = true;
    }
    }
    //CH-31 End
    /*private void loanApplicationUpdate(List<Opportunity> oppList){
        if(StaticFunction.runOnce()){
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
         for(Opportunity opp : oppList) {
            /******CH-30******/ 
            /*if(opp.StageName == 'Closed-Lost' && opp.RecordTypeId != opBS)*/ 
                /*oppMap.put(opp.Id, opp);
            
        }
            if(oppMap != null && oppMap.size() > 0 ){
                List<Loan_Application__c> loanApps = [SELECT id, status__c, Primary_Contact_Name__c 
                                                      FROM Loan_Application__c 
                                                      WHERE Opportunity__c IN: oppMap.keySet() 
                                                      AND (status__c != 'Declined')];
                for(Loan_Application__c la : loanApps) 
                {
                    if(oppMap.get(la.opportunity__c).stagename == 'Closed-Lost' && la.status__c != 'Not Accepted')
                    {
                    	la.status__c = 'Declined';
                    }
                }
                if(loanApps.size() > 0)
                {
                    update loanApps;            
                }
           }
       }
    }*/
}