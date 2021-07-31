/*
Trigger Name            :OpportunityHandler
Description             :

Developer Name          : Cloud Trigger
Created Date            : 3/16/2017 

##############Change History#############
CH.No       Description                                         		Developer           Date
------------------------------------------------------------------------------------------------------
CH-01       Removed four 'Ramp: Referral' tasks which were   			 Utkarsh Topre     06/13/2017
            getting created when the 'Investment Transition
            Partner' field has a value in it. Also, made the
            Category on Task as null for the same.

CH-02       Commented unwanted code to delete                 			Mahender Gangu     06/15/2017 
			unneccessary fields       

CH-03       Remove four tasks from auto-assignment to the     			Utkarsh Topre      03/26/2018
            Onboarding Consultant on opportunity records 
            and rename value from “TA/Commissions/Fees Discussion”
            to “Commission and Fee Discussion”                

CH-04    When an opportunity is created and have value in       		Ashish Gupta       10/15/2018
        "Investment Transition Partner" field, then 
        an task create with subject as   "SAM Pricing Form" 

CH-05	Transition project plan activity type update                    Rinku Yadav        03/18/2021
Note : Test Coverage for This class is covered in Test class  : LPL_OpportunityHandlerTest

*/
public without sharing class OpportunityHandler {
    
    private static boolean avoidRecrusiveEvent = false;
    private static boolean avoidRecrusiveUpdateEvent = false;
    //Schema.DescribeSObjectResult oppRecDesc = Schema.SObjectType.Opportunity;
    //Map<String,Schema.RecordTypeInfo> rtMapByName = oppRecDesc.getRecordTypeInfosByName();
    //Id IASBD = rtMapByName.get('IAS Business Development').getRecordTypeId();
    ID IASBD = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IAS Business Development').getRecordTypeId();
    //Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
    //Map<String,Schema.RecordTypeInfo> rtTaskMapByName = tskRecDesc.getRecordTypeInfosByName();
    //ID tskRtID = rtTaskMapByName.get('Transitions').getRecordTypeId();
    ID rt = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Transitions').getRecordTypeId();
    map<string, list<IAS_Recruiter_Assignment__c>> ias_zip_Map = new map<string, list<IAS_Recruiter_Assignment__c>>();
    
    public void onBeforeInsert(list<Opportunity> opps, Opportunity oldOpps, List<IAS_Recruiter_Assignment__c> iasList)
    {
    }
    public void updateConOppFields(Map<Id, Contact> ConMap, List<Opportunity> oppList){
        
        system.debug('Inside loop conopp');
        for( Opportunity o : oppList )
		{
            if( conMap.size() != 0 && conMap.size() != Null && conMap.get(o.Contact__c) != Null )
			{
                if( conMap.get(o.Contact__c).Recordtype.Name.containsIgnoreCase('Contact Prospect') )
				{
                    system.debug('Inside loop 1');
                    //o.LeadSource = conMap.get(o.Contact__c).Lead_Source__c;
                    //o.Source_Type__c = conMap.get(o.Contact__c).Source_Type_Prospect__c;
                    o.Referral_By__c = conMap.get(o.Contact__c).Referral_By__c;
                    o.Referring_Advisor_Rep_ID__c = conMap.get(o.Contact__c).Referring_Advisor_Rep_ID__c;
                    o.Marketing_Classification__c = conMap.get(o.Contact__c).Marketing_Classification_Prospect__c;
                    o.Mailer_Code__c = conMap.get(o.Contact__c).Mailer_Code_Prospect__c;
                    o.Years_in_Industry__c = conMap.get(o.Contact__c).Years_in_Industry__c;
                    o.Licenses__c = conMap.get(o.Contact__c).Licenses__c;
                    o.Current_Firm__c = conMap.get(o.Contact__c).Current_Firm__c;
                }
                if( conMap.get(o.Contact__c).Recordtype.Name.containsIgnoreCase('Contact Prospect')
					&& conMap.get(o.Contact__c).Lead_Source__c != null 
					&& conMap.get(o.Contact__c).Source_Type_Prospect__c != null 
					&& conMap.get(o.Contact__c).Lead_Source__c.equalsIgnoreCase('Referral') )
				{
                    system.debug('Inside loop 2');
                    o.LeadSource = conMap.get(o.Contact__c).Lead_Source__c;
                    o.Source_Type__c = conMap.get(o.Contact__c).Source_Type_Prospect__c;
                    o.Referral_By__c = conMap.get(o.Contact__c).Referral_By__c;
                    o.Referring_Advisor_Rep_ID__c = conMap.get(o.Contact__c).Referring_Advisor_Rep_ID__c;
                    o.Marketing_Classification__c = conMap.get(o.Contact__c).Marketing_Classification_Prospect__c;
                    o.Mailer_Code__c = conMap.get(o.Contact__c).Mailer_Code_Prospect__c;
                    o.Years_in_Industry__c = conMap.get(o.Contact__c).Years_in_Industry__c;
                    o.Licenses__c = conMap.get(o.Contact__c).Licenses__c;
                    o.Current_Firm__c = conMap.get(o.Contact__c).Current_Firm__c;
                }
            }
        }
    }
    // ---------------------------Lead Onboarding Project Code starts Here------------------------------//
    /*
	Create Activitys for Opportunity Fields Onboarding Consultant, Regional Transition Partner, Transition Support Partner, 
	Investment Transition Partner
    */          
    
    public List<Task> createOpportunityActivity(List<Opportunity> oppList, Map<ID, Opportunity> oldOppMap , List<Task> tskList) {
        
		List<Task> task_RTPList = new List<Task>();
        if(avoidRecrusiveEvent  == false)
		{
            Map<Id, Opportunity> RTPMap = new Map<Id, Opportunity>();// Regional Transition Partner 
            Map<Id, Opportunity> ITPMap = new Map<Id, Opportunity>();// Investment Transition Partner 
            Map<Id, Opportunity> TSPMap = new Map<Id, Opportunity>();// Transition Support Partners 
            Map<Id, Opportunity> OCMap = new Map<Id, Opportunity>();// Onboarding Consulting
            /**********CH-05 : Start************/
			List<string> activityRT = new List<string>();
			List<string> activityIT = new List<string>();
			List<string> activityTS = new List<string>();
			List<string> activityOC = new List<string>();
             /**********CH-05 : End************/
            Set<ID> oppId = new Set<ID>();
            for(Opportunity opp : oppList)
			{
                oppId.add(opp.Id);
            }
            //Schema.DescribeSObjectResult tskRecDesc = Schema.SObjectType.Task;
            //Map<String,Schema.RecordTypeInfo> rt_TaskMap = tskRecDesc.getRecordTypeInfosByName();
            //Id rtID = rt_TaskMap.get('Transitions').getRecordTypeId();
            List<Task> tskOCList = new List<Task>();
            List<Task> tskRTPList = new List<Task>();
            List<Task> tskITPList = new List<Task>();
            List<Task> tskTSPList = new List<Task>();
            tskOCList = null;
            tskRTPList = null;
            tskITPList = null;
            tskTSPList = null;
            Map<String, List<Task>> tskMap = new Map<String, List<Task>>();
            /**********CH-05 : Start************/
			List<Transition_Project_Plan_Activity_Type__mdt> tppList =[SELECT ID,MasterLabel,Activity_Type__c,User_Type__c,Order_Of_Task__c
                                                                       FROM Transition_Project_Plan_Activity_Type__mdt
                                                                       ORDER BY  Order_Of_Task__c];
			if(tppList.size() > 0)
			{														  
				for(Transition_Project_Plan_Activity_Type__mdt tpp : tppList)
				{
						if( tpp.User_Type__c == 'Regional Transition Partner' )
						{
							activityRT.add(tpp.Activity_Type__c);
						}
						if( tpp.User_Type__c == 'Investment Transition Partner' )
						{
							activityIT.add(tpp.Activity_Type__c);
						}
						if( tpp.User_Type__c == 'Transition Support Partners' )
						{
							activityTS.add(tpp.Activity_Type__c);
						}
						if( tpp.User_Type__c == 'Onboarding Consultant' )
						{
							activityOC.add(tpp.Activity_Type__c);
						}
				}
			}
             /**********CH-05 : End************/
            if( tskList.size() != 0 && tskList != null )
			{
                for( Task tsk : tskList )
				{
                    if( tsk.Department__c.EqualsIgnorecase('Onboarding Consultant') )
					{
                        if( tskOCList == null )
						{ 
                            tskOCList = new List<Task>();
                            tskOCList.add(tsk);  
                        }
                        else
						{    
                            tskOCList.add(tsk);
                        }
                        
                    }
					else if( tsk.Department__c.EqualsIgnorecase('Transition Support Partners') )
					{
                        if( tskTSPList == null )
                        { 
                            tskTSPList = new List<Task>();
                            tskTSPList.add(tsk);  
                        }
						else
						{
							tskTSPList.add(tsk);
						}
                    }
					else if( tsk.Department__c.EqualsIgnorecase('Investment Transition Partner') )
					{
                        if( tskITPList  == null )
						{ 
                            tskITPList = new List<Task>();
                            tskITPList.add(tsk);  
                        }
                        else
						{    
                            tskITPList.add(tsk);
                        }
                        
                    }
					else if( tsk.Department__c.EqualsIgnorecase('Regional Transition Partner') )
					{
                        if( tskRTPList== null )
						{ 
                            tskRTPList= new List<Task>();
                            tskRTPList.add(tsk);  
                        }
                        else
						{    
                            tskRTPList.add(tsk);
                        }
                        
                    }
                }
            }
            for( Opportunity opp : oppList )
			{
                if( oldOppMap != null )
				{
					Opportunity oldOpp = oldOppMap.get(opp.Id);
                    If( oldOpp != null )
					{ // Added by Sai
                        if( opp.Regional_Transition_Partner__c != null 
							&& ((opp.Regional_Transition_Partner__c != null 
							&& oldOpp.Regional_Transition_Partner__c == null ) 
                            || ((opp.Regional_Transition_Partner__c != null && oldOpp.Regional_Transition_Partner__c != null)))
                            && (opp.Regional_Transition_Partner__c != null && oldOpp.Regional_Transition_Partner__c != opp.Regional_Transition_Partner__c) 
                          )
						{
                              if( tskRTPList == null)
							  {
                                  RTPMap.put(opp.Regional_Transition_Partner__c, opp);
                              }             
                              
                        }
                        if( opp.Investment_Transition_Consultant__c != null 
							&& ((opp.Investment_Transition_Consultant__c!= null && oldOpp.Investment_Transition_Consultant__c== null)) 
                            ||(opp.Investment_Transition_Consultant__c!= null && oldOpp.Investment_Transition_Consultant__c != null)
                            && (opp.Investment_Transition_Consultant__c!= null && oldOpp.Investment_Transition_Consultant__c!= opp.Investment_Transition_Consultant__c) 
                          )
						{
                              if( tskITPList == null )
							  {
								  ITPMap.put(opp.Investment_Transition_Consultant__c, opp);
							  }
                        }
                        if( opp.Transition_Support_Partners__c!= null 
						    && ((opp.Transition_Support_Partners__c!= null && oldOpp.Transition_Support_Partners__c== null)
                            || (opp.Transition_Support_Partners__c!= null && oldOpp.Transition_Support_Partners__c != null))
                            && (opp.Transition_Support_Partners__c!= null && oldOpp.Transition_Support_Partners__c!= opp.Transition_Support_Partners__c)
                          )
						{
                              if( tskTSPList == null )   
							  {
								  TSPMap.put(opp.Transition_Support_Partners__c, opp); 
							  }
                        }
                        if( opp.Integration_Manager__c!= null 
						    && ((opp.Integration_Manager__c!= null && oldOpp.Integration_Manager__c== null)
                            || (opp.Integration_Manager__c!= null && oldOpp.Integration_Manager__c != null)) 
                            && (opp.Integration_Manager__c!= null && oldOpp.Integration_Manager__c!= opp.Integration_Manager__c)
                          )
						{
                              if( tskOCList == null )  
							  {
								  OCMap.put(opp.Integration_Manager__c, opp);
							  }
                        }
                    }
                } 
				else
				{
                    if( opp.Regional_Transition_Partner__c != null )
					{
                        RTPMap.put(opp.Regional_Transition_Partner__c, opp);
                    }
                    if( opp.Investment_Transition_Consultant__c!= null )
					{
                        ITPMap.put(opp.Investment_Transition_Consultant__c, opp);
                    }
                    if( opp.Transition_Support_Partners__c!= null )
					{
                        TSPMap.put(opp.Transition_Support_Partners__c, opp); 
                    }
                    if( opp.Integration_Manager__c!= null )
					{
                        OCMap.put(opp.Integration_Manager__c, opp);
                    }
                }
            }
            if( RTPMap.size() != 0 )
			{
                 /**********CH-05 : Start************/
                /*List<String> activityType = new List<String>{'Office Setup: BTP Introduction',
                    'Office Setup: Practice Discovery Consult & Complete Advisor Support Profile',
                    'Ramp: Investment Vehicle List',
                    'Ramp: Repapering Consult',
                    'Ramp: Deliver Repapering Plan',
                    'Ramp: Why LPL to Clients',
                    'Ramp: Training Consult',
                    'Office Setup: Infrastructure',
                    'Office Setup: Navigating Service',
                    'Ramp: Onsite Support ',
                    'Ramp: ClientWorks Overview Training',
                    'Ramp: Account Opening Readiness',
                    'Office Setup: Compliance Consult',
                    'Office Setup: Commission Statement Review',
                    'Office Set-up: Referral',
                    'Office Set-up: Referral',
                    'Office Set-up: Referral',
                    'Office Set-up: Referral',
                    'Office Set-up: Referral',
                    'Office Set-up: Referral',
                    'Office Setup: Succession Plan',
                    'Ramp: Client Proficiency Assessment',
                    'Office Setup: Branch Exam Prep',
                    'Ramp: Provide monthly progress reports',
                    'Proficiency: Transition Support Completed'};*/
                    //List<String> categList = new List<String>{'Financial Planning ', 'Private Client Group', 'Private Trust Company', 'Marketing', 'Research', 'Relationship Manager'};
                     /**********CH-05 : End************/
                for( Opportunity opp : RTPMap.values() )
				{
                    for( String str : activityRT ) 
					{
                        Task newTask = new Task();
                        newTask.recordTypeID = rt;
                        newTask.OwnerId = opp.Regional_Transition_Partner__c;
                        newTask.Subject = 'Transitions';
                        newTask.WhatId = opp.Id ;
                        newTask.ActivityDate = System.today().addDays(90);
                        newTask.Department__c = 'Regional Transition Partner';
                        newTask.Activity_Type__c = str;
                         /**********CH-05 : Start************/
                            /*if(str == 'Office Set-up: Referral' && !categList.isEmpty())
                              {
                                  newTask.Category__c = categList[0];
                                  categList.remove(0);                            
                                        
                               }
							   else 
							   {*/
                                   newTask.Category__c = '';
                             //}
                        /**********CH-05 : End************/          
                        newTask.Status = 'Not Started';
                        newTask.Priority = 'Normal';
                        newTask.Change_Status_Date__c = Date.Today();
                        task_RTPList.add(newTask);
                    }
                }
            }
            //*************CH-01 START*****************
            // Removing four 'Ramp: Referral' tasks and making the Category as null on Tasks when the 'Investment Transition Partner'
            //  field on Opportunity has value in it
            if( ITPMap.size() != 0 )
			{
                 /**********CH-05 : Start************/
                /*List<String> activityType = new List<String>{'Ramp: Product Discovery Call', 'Ramp: Product Mapping & Gap Analysis', 
                    'Ramp: Competitive Analysis', 'Proficiency: Advisory Platform Education', 
                    'Ramp: Case Consult', 'Ramp: Off-Platform Conversion', 
                    'Ramp: Reappointments Needed', 'Ramp: Referral', 
                    'Proficiency:Investor Presentation & Proposal Tool (IPPT)'};*/
                 /**********CH-05 : End************/        
                for( Opportunity opp : ITPMap.values() )
				{
                    for( String str : activityIT )
					{ 
                        Task newTask = new Task();
                        newTask.OwnerId = opp.Investment_Transition_Consultant__c;
                        newTask.recordTypeID = rt;
                        newTask.Subject = 'Transitions';
                        newTask.WhatId = opp.Id ;
                        newTask.ActivityDate = System.today().addDays(90);
                        newTask.Department__c = 'Investment Transition Partner';
                        newTask.Activity_Type__c = str;                     
                        newTask.Category__c = '';
                        newTask.Status = 'Not Started';
                        newTask.Priority = 'Normal';
                        newTask.Change_Status_Date__c = Date.Today();
                        
						task_RTPList.add(newTask);
                    } 
                    //*************CH-04 START*****************
                    /*if( opp.Investment_Transition_Consultant__c != Null )
					{
                        Task newTask = new Task();
                        newTask.OwnerId = opp.Investment_Transition_Consultant__c;
                        newTask.recordTypeID = rt;
                        newTask.Subject = 'SAM Pricing Form';
                        newTask.WhatId = opp.Id ;
                        newTask.ActivityDate = System.today().addDays(90);
                        newTask.Department__c = 'Investment Transition Partner';
                        newTask.Activity_Type__c ='SAM Pricing Form';                     
                        newTask.Change_Status_Date__c = Date.Today();
                        newTask.Status = 'Not Started';
                        newTask.Priority = 'Normal';
                        newTask.Call_Type__c='Inbound Call';
                        
						task_RTPList.add(newTask);
                    }*/
                    //*************CH-04 END*****************
                } 
                //***************CH-01 END*************************
            }
            if( TSPMap.size() != 0 )
			{
                 /**********CH-05 : Start************/
                /*List<String> activityType = new List<String>{'Ramp: Practice Discovery Consult & Repapering Consult, Complete Advisor Support Profile (if no RTP)',
                    'Ramp: Deliver Repapering Plan (if no RTP)',
                    'Ramp: Send Data Upload Sheet (if no RTP)',
                    'Ramp: Training Consult (if no RTP)',
                    'Office Setup: Infrastructure (if no RTP)',
                    'Ramp: Overview of Account Opening & Account Transfer Process',
                    'Ramp: Data upload into ClientWorks',
                    'Ramp: Onsite Support',
                    'Office Setup: Compliance Consult (if no RTP)',
                    'Ramp: Virtual Account Opening Support',
                    'Ramp: Daily/Weely Activity Assessment',
                    'Proficiency: Account Opening & eSignature process',
                    'Proficiency: Navigate ClientWorks & Resource Center',
                    'Proficiency: Account View & iDoc',
                    'Proficiency: Notifications & Account Maintenance',
                    'Proficiency: Networking & BTR',
                    'Proficiency: Move Money transactions',
                    'Proficiency:  Remote Deposit & Branch Deposit',
                    'Proficiency: Portfolio Manager',
                    'Proficiency: Transition Support Completed'
                    };*/
                  /**********CH-05 : End************/       
                for( Opportunity opp : TSPMap.values() )
				{
                    for( String str : activityTS ) 
					{
                        Task newTask = new Task();
                        newTask.OwnerId = opp.Transition_Support_Partners__c;
                        newTask.recordTypeID = rt;
                        newTask.Subject = 'Transitions';
                        newTask.WhatId = opp.Id ;
                        newTask.ActivityDate = System.today().addDays(90);
                        newTask.Department__c = 'Transition Support Partners';
                        newTask.Activity_Type__c = str;
                        newTask.Category__c = '';
                        newTask.Status = 'Not Started';
                        newTask.Priority = 'Normal';
                        newTask.Change_Status_Date__c = Date.Today();
                        
						task_RTPList.add(newTask);
                    }
                }
            }
            if( OCMap.size() != 0 )
			{
                 /**********CH-05 : Start************/
                /*List<String> activityType = new List<String>{   'Initial Call Out', 'Credit Report Sent', 'GRC Pend Items', 'GRC Approval', 
                    'OBA Consultation', 'Outside Counsel Call', 'E&O Insurance', 'ComplianceMAX Setup', 
                    'BranchNet Early Access ', 'Navigating Resource Center Email', 'New Email Setup',
                    'Learning Center Setup', 'FINRA Rule 2273 Consultation', 
                    'Marketing Discussion', 'Marketing & Stationary Items Approval', 
                    'New RIA Documents ', 'Welcome Kit', 'Request HOS Principal', 
                    'Request Service360 Team', 
                    'Secondary Documents', 'U4', 'Electronic Fingerprints', 'Direct Deposit', 
                    'Remote & Local Branch Deposit', 'Insurance and Annuity Appointments', 
                    'Non Licensed Admin Documents', 'Split Commission/Fee Agreement', 
                    'Technology Subscription - Additional Access Form', 'Intro Call with Service360', 
                    'Confirm Mandatory Trainings Complete', 'Resignation Day Call', 
                    /*CH-03 START*/ /*'Commission and Fee Discussion', /*CH-03 END*/ /*'ADV Brochure (Corp RIA only) Email', 
                    'Compliance Emails', 'Submit TAT Request', 'STAT 1 Notification', 
                    'STAT 2 Notification', 'Welcome to LPL Email', 'State Licenses Verified', 
                    'Marketing On Demand Charges', 
                    'ADV Brochure (Corp RIA only) Confirmation',
                    'Pre-TAT documents submitted to Registrations'
                    };*/
                     /**********CH-05 : End************/    
                for( Opportunity opp : OCMap.values() )
				{
                    for( String str : activityOC ) 
					{
                        Task newTask = new Task();
                        newTask.OwnerId = opp.Integration_Manager__c;
                        newTask.recordTypeID = rt;
                        newTask.Subject = 'Transitions';
                        newTask.WhatId = opp.Id ;
                        if( opp.Internal_Target_TAT_Date__c == null )
						{
                            newTask.ActivityDate = System.today().addDays(90);        
                        } 
						else 
						{
                            newTask.ActivityDate = opp.Internal_Target_TAT_Date__c;
                        }
                        newTask.Department__c = 'Onboarding Consultant';
                        newTask.Activity_Type__c = str;
                        newTask.Category__c = '';
                        newTask.Status = 'Not Started';
                        newTask.Priority = 'Normal';
                        newTask.Change_Status_Date__c = Date.Today();
                                
                        task_RTPList.add(newTask);
                    }
                }
            }
            if( task_RTPList.size() != 0 )
			{    
                avoidRecrusiveEvent  = true;
            } 
        }  
        return task_RTPList;
    }
    
    public List<Task> updateOpportunityActivity(Map<ID, opportunity> oppUpdateMap, set<ID> oppIds, Map<String, ID> oppTaskMap,  List<Task> tskUpdList){
        List<Task> updateTaskList = new List<Task>();
        if(avoidRecrusiveUpdateEvent == false) 
		{
            List<ID> updateOppList = new List<ID>();
            if( tskUpdList != null )
                for( Task tk : tskUpdList )
				{
                    if( tk.Department__c == 'Onboarding Consultant' && oppTaskMap.get(tk.Department__c) != null ) 
					{
                        tk.OwnerID = oppTaskMap.get(tk.Department__c);
                        updateTaskList.add(tk);
                    }
					else if( tk.Department__c == 'Transition Support Partners' && oppTaskMap.get(tk.Department__c) != null ) 
					{
                        tk.OwnerID = oppTaskMap.get(tk.Department__c);
                        updateTaskList.add(tk);
                    } 
					else if( tk.Department__c == 'Investment Transition Partner' && oppTaskMap.get(tk.Department__c) != null ) 
					{
                        tk.OwnerID = oppTaskMap.get(tk.Department__c);
                        updateTaskList.add(tk);
                    }
					else if( tk.Department__c == 'Regional Transition Partner' && oppTaskMap.get(tk.Department__c) != null ) 
					{
                        tk.OwnerID = oppTaskMap.get(tk.Department__c);
                        updateTaskList.add(tk);
                    }
                }
            if( updateTaskList.size() != 0 )
			{
                avoidRecrusiveUpdateEvent  = true;
            }
        }
        return updateTaskList; 
    }
    /* Ends
    Create Activity from Opportunity Fields Onboarding Consultant, Regional Transition Partner, Transition Support Partner, 
    Investment Transition Partner 
    */ 
    //---------------------------------------------------------------------------------------------//
    /* Start
    Handle GRC status and Review Status Picklist value Entry and Exit Dates.
    Handle check In And Check Out Dates of below fields,
    Direct_Independent_Affiliation
    Create_Their_Own_Independent_OSJ
    Existing_Broker_Dealer_Exploring_Partn
    Join_Existing_Institution_Bank
    Join_Existing_Independent_Branch
    
    */
    public void updateEntryExitFieldsonOpportunity(List<Opportunity> newOpp, Map<ID, Opportunity> oldOppMap){
        
        if( oldOppMap == null )
		{
            for( Opportunity opp : newOpp )
			{
                if( opp.GRC_Status__c != null )
				{
                    getGRCEntryDateAssigned(opp);
                }
                if( opp.Review_Status__c != null )
				{
                    getReviewEntryDateAssigned(opp);
                }
                
            }
        } 
        else
		{
            for( Opportunity opp : newOpp )
			{
                Opportunity oldOp = oldOppMap.get(opp.Id);
                If( oldOp != null )
				{ //Added by Sai
                    if( opp.GRC_Status__c != oldOp.GRC_Status__c )
					{
                        getGRCEntryDateAssigned(opp);
                        getGRCExitDateAssigned(opp, oldOp);
                    }
                    if( opp.Review_Status__c != oldOp.Review_Status__c )
					{
                        getReviewEntryDateAssigned(opp);
                        getReviewExitDateAssigned(opp, oldOp);
                    }
                }
            } 
        }
    }
    
    public void getGRCExitDateAssigned(Opportunity oppNew, Opportunity oppOld){
        
        String GRC_StatusOld = oppOld.GRC_Status__c;
        String GRC_StatusNew = oppNew.GRC_Status__c;
        Opportunity opp = oppNew;
        if(GRC_StatusNew != GRC_StatusOld){
            if( GRC_StatusOld == 'Reject to NCO' )
			{
                opp.Kit_Reject_to_NCO_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Assigned to GRC Analyst' )
			{
                opp.Kit_Assigned_to_GRC_Analyst_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Assigned to GRC Analyst' )
			{
                opp.Kit_Assigned_to_GRC_Analyst_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Assigned Resubmit to GRC Analyst' )
			{
                opp.Kit_Assigned_Resubmit_to_GRC_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Pending NCO - More Info Requested' )
			{
                opp.Kit_Pending_NCO_More_Info_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Pending GRC - More Info Received' )
			{
                opp.Kit_Pending_GRC_More_Info_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'GRC Escalated' )
			{
                opp.Kit_GRC_Escalated_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Call Completed' )
			{
                opp.Kit_Call_Completed_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Pending EVP Committee' )
			{
                opp.Kit_Pending_EVP_Committee_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Approved' )
			{
                opp.Kit_Approved_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Denied' )
			{
                opp.Kit_Denied_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Withdrawn' )
			{
                opp.Kit_Withdrawn_Exit__c = System.today();
            } 
			else if( GRC_StatusOld == 'Reject to Registrations' )
			{
                opp.Kit_Reject_to_Registrations_Exit__c= System.today();
            }
        }
    }
    
    public void getReviewExitDateAssigned(Opportunity oppNew, Opportunity oppOld){
        
        String Review_StatusNew = oppNew.Review_Status__c;
        String Review_StatusOld = oppOld.Review_Status__c;
        Opportunity opp = oppNew;
        if( Review_StatusNew != Review_StatusOld )
		{
            if( Review_StatusOld == 'Reject to NCO' )
			{
                opp.OBA_Reject_to_NCO_Exit__c = System.today();
            } 
			else if( Review_StatusOld  == 'Assigned to OBA Analyst' )
			{
                opp.OBA_Assigned_to_OBA_Analyst_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Pending NCO - More Info Requested' )
			{
                opp.OBA_Pending_NCO_More_Info_Req_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Pending OBA Analyst - More Info Received' )
			{
                opp.OBA_Pending_OBA_Analyst_More_Info_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Call Completed' )
			{
                opp.OBA_Call_Completed_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Pending OBA Committee' )
			{
                opp.OBA_Pending_OBA_Committee_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'OBA Review Completed' )
			{
                opp.OBA_OBA_Review_Completed_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Withdrawn' )
			{
                opp.OBA_Withdrawn_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Pending NCO – Call Requested' )
			{
                opp.OBA_Pending_NCO_Call_Req_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Pending NCO - Waiting Advisor' )
			{
                opp.OBA_Pending_NCO_Waiting_Advisor_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'OBA Consult Requested' )
			{
                opp.OBA_OBA_Consult_Requested_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Pending OBA Review - More Info Received' )
			{
                opp.OBA_Pending_OBA_Review_More_Info_Exit__c = System.today();
            } 
			else if( Review_StatusOld == 'Resubmit Assigned to OBA Analyst' )
			{
                opp.OBA_Resubmit_Assigned_to_OBA_Analyst_Ext__c = System.today();
            } 
			else if( Review_StatusOld == 'Pending Prospect – Docusign Sent' )
			{
                opp.OBA_Pending_Prospect_Docusign_Sent_Exit__c = System.today();
            }
        }
    }
    
    public void getGRCEntryDateAssigned(Opportunity oppNew){
        
        String Status_GRC = oppNew.GRC_Status__c;
        Opportunity opp = oppNew;
        if( Status_GRC != null )
		{
            if( Status_GRC == 'Reject to NCO' ){
                opp.Kit_Reject_to_NCO_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Assigned to GRC Analyst')
			{
                opp.Kit_Assigned_to_GRC_Analyst_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Assigned to GRC Analyst' )
			{
                opp.Kit_Assigned_to_GRC_Analyst_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Assigned Resubmit to GRC Analyst' )
			{
                opp.Kit_Assigned_Resubmit_to_GRC_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Pending NCO - More Info Requested' )
			{
                opp.Kit_Pending_NCO_More_Info_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Pending GRC - More Info Received' )
			{
                opp.Kit_Pending_GRC_More_Info_Entry__c = System.today();
            } 
			else if( Status_GRC == 'GRC Escalated' )
			{
                opp.Kit_GRC_Escalated_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Call Completed' )
			{
                opp.Kit_Call_Completed_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Pending EVP Committee' )
			{
                opp.Kit_Pending_EVP_Committee_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Approved' )
			{
                opp.Kit_Approved_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Denied' )
			{
                opp.Kit_Denied_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Withdrawn' )
			{
                opp.Kit_Withdrawn_Entry__c = System.today();
            } 
			else if( Status_GRC == 'Reject to Registrations' )
			{
                opp.Kit_Reject_to_Registrations_Entry__c= System.today();
            }
        }
        
    }
    
    public void getReviewEntryDateAssigned(Opportunity opp){
        
        String ReviewStatus = opp.Review_Status__c;
        if( ReviewStatus != null )
		{
            if( ReviewStatus == 'Reject to NCO' )
			{
                opp.OBA_Reject_to_NCO_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Assigned to OBA Analyst' )
			{
                opp.OBA_Assigned_to_OBA_Analyst_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Pending NCO - More Info Requested' )
			{
                opp.OBA_Pending_NCO_More_Info_Req_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Pending OBA Analyst - More Info Received' )
			{
                opp.OBA_Pending_OBA_Analyst_More_Info_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Call Completed' )
			{
                opp.OBA_Call_Completed_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Pending OBA Committee' )
			{
                opp.OBA_Pending_OBA_Committee_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'OBA Review Completed' )
			{
                opp.OBA_OBA_Review_Completed_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Withdrawn' )
			{
                opp.OBA_Withdrawn_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Pending NCO – Call Requested' )
			{
                opp.OBA_Pending_NCO_Call_Req_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Pending NCO - Waiting Advisor' )
			{
                opp.OBA_Pending_NCO_Waiting_Advisor_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'OBA Consult Requested' )
			{
                opp.OBA_OBA_Consult_Requested_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Pending OBA Review - More Info Received' )
			{
                opp.OBA_Pending_OBA_Review_More_Info_Entry__c = System.today();
            } 
			else if( ReviewStatus == 'Resubmit Assigned to OBA Analyst' )
			{
                opp.OBA_Resubmit_Assigned_to_OBA_Analyst_Ent__c = System.today();
            } 
			else if( ReviewStatus == 'Pending Prospect – Docusign Sent' )
			{
                opp.OBA_Pending_Prospect_Docusign_Sent_Entry__c = System.today();
            } 
        }
    }
    /* Ends - Handle GRC status and Review Status Entry and Exit Dates, Update Check in , Check Out Cehckbox Field.*/
}