/*
#############################Change History####################
Requirement                                                       Developer Name                   Date

Ch-1   Adding trigger.old into bulkbefore & bulk After                   Vaibhav Wadhai                6 june 2017
Ch-2   Removing LR Engine logic                                          Vaibhav Wadhai                6 june 2017
CH-03  Fix 101 SOQL                                                        Sai Kethu                    6 june 2017
CH-04  Added try and Catch block                                         Vaibhav Wadhai                 12 june 2017
CH-05  Create MA tasks for IRD user                                      Utkarsh Topre                14 Nov 2017
CH-06  101 SOQL resolution                                              Manila Agnihotri               30 May 2018
CH-07 Email population on opportuntiy                                   Manila Agnihotri               16 OCt 2018
CH-08 Populate program manager on Enterprise                            Vaibhav Jain                    18 Jan 2019
CH -09 Commented line number 103 & 143 for not creating the activities in salesforce     Ramola Vattam   10 May 2019 
*/

public with sharing class LPL_ContactTriggerHandler implements ITrigger{
    Public static Boolean isOff = false;
    LPL_ContactTriggerGateway conGaty = new LPL_ContactTriggerGateway(); // Create Gateway Class Object.
    List<Contact> conupList = new List<Contact>();
    Map<String, String> emailsToChangeInEloqua = new Map<String, String>();
    Map<Id,Contact> ContactData= new Map<Id,Contact>();
    List<Contact> Contacts= new List<Contact>();
    Map<ID, Contact> prospConMap = new Map<Id, Contact>();
    List<Opportunity> oppList = new List<Opportunity>();
    List<Opportunity> updateLostOutcomesList = new List<Opportunity>();
    ContTriggerHandler conHandler = new ContTriggerHandler();
    List<Contact> ConList  = New List<Contact>();
    List<Contact> objects = new List<Contact>(); 
    List<Account> accList = New List<Account>();
    public static Boolean Flag =true;   //CH-06
    //public static boolean onlyonceafter= true;
    //public static boolean onlyoncebefore=true;
    ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    String detailWhereClause = 'RecordTypeID = ' + conRecordTypeId;
    
    public LPL_ContactTriggerHandler(){}
    
    public void bulkBefore(){
        
        if(Trigger.isInsert || Trigger.isUpdate){
            //if(onlyoncebefore){
                //ch-1 -start
                conGaty.collectRecordToProcess(Trigger.New,Trigger.old);
                //onlyoncebefore=false;
                //ch-1-end
            //}
            
        }
    }
    
    public void beforeInsert(SObject so){
        Contact con = (Contact)so;
        Contact oldCon = (Contact)so;
        boolean isInsert = true;
        conGaty.executeIASLogic(con, oldCon, isInsert);
        LPL_OpportunityTriggerGateway.notrigger = false; //CH-07
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Contact con = (Contact)so;
        Contact oldCon = (Contact)oldSo;
        // CH-03: Start
        if(con.At_Risk__c != oldCon.At_Risk__c){
            con.At_Risk_Last_Modified__c = datetime.now();
            
        } //CH-03: ENd
        conGaty.executeIASLogic(con, oldCon, false);
        LPL_OpportunityTriggerGateway.notrigger = false; //CH-07
    }
    
    public void beforeDelete(SObject so){
        LPL_OpportunityTriggerGateway.notrigger = false; //CH-07
    }
    
    public void bulkAfter(){
        if(Trigger.isUpdate){
            //if(onlyonceafter){
                //ch-1-start
                conGaty.collectRecordToProcess(Trigger.New,trigger.old);
                //onlyonceafter = false;
                //ch-1-end
            //}
        }
    }
    public void afterInsert(SObject so){
        Contact con = (Contact)so;
        ContactData.put(con.Id, con);
        Contacts.add(con);
        
        /*  Start - ******** Lead Onboarding Changes **********  */
        if(con.RecordTypeID == conRecordTypeId)  {
            prospConMap.put(con.ID, con);
            ContactData.put(con.Id, con);
        }
        if(con.AccountId != Null ){
            if((con.GDC_Prior_12_mo__c != Null && con.GDC_Prior_12_mo__c != 0) && Con.RecordTypeId == conRecordTypeId && con.Rep_Status__c == 'Active') {
                conList .add(con);
            }
            if(conList.size()>0){
                objects = conList; 
            }
        }
   /*     conGaty.createMAtasksInsert(con); // CH-05 - Create MA Tasks
        */
        /*if(con.AccountId != null){
            conGaty.updateProgramManagerOnAccount(con,null);//CH-08
        }*/
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        
        Contact con = (Contact)so;
        Contact oldCon = (Contact)oldSo;
        
        if(con != null
           && con.email != null 
           && con .email != '' 
           && oldCon != null
           && oldCon.email != null
           && oldCon.email != ''
           && con.email != oldCon.email) //only when changing it do we check 
        {
            emailsToChangeInEloqua.put(oldCon.email, con.email);
        }
        if(emailsToChangeInEloqua.size() > 0){
            ChangeEloquaEmailAddressCls.ChangeEloquaEmailAddress(emailsToChangeInEloqua);
        }
        //CH-06 start
        
        if(Flag){
            Flag = false;
            oppList= conGaty.doUpdateOppCon();
        } 
        //CH-06 - end
        if(con.AccountId != Null ){
            if((con.GDC_Prior_12_mo__c != Null && con.GDC_Prior_12_mo__c != 0) && Con.RecordTypeId == conRecordTypeId && con.Rep_Status__c == 'Active') {
                conList .add(con);
            }
            objects = conList;
        }
        
        updateLostOutcomesList=conGaty.findOpportunity();
    /*    conGaty.createMAtasksUpdate(con,oldCon); */
    // CH-05 - Create MA Tasks
    
        //CH-08-start
        /*if(oldcon.Role__c != con.Role__c || oldcon.Rep_Status__c != con.Rep_Status__c || oldcon.PM_Contact_Level__c != con.PM_Contact_Level__c || oldcon.Hire_Date__c != con.Hire_Date__c || oldcon.PM_Communication_List__c != con.PM_Communication_List__c || oldcon.AccountId != con.AccountId){
            if(oldcon.AccountId != con.AccountId && con.AccountId != null){
                conGaty.updateProgramManagerOnAccount(con,oldcon.AccountId);
            }
            else if(con.AccountId != null){
                conGaty.updateProgramManagerOnAccount(con,null);
            }
            else if(con.AccountId == null){
                System.debug('Account khaali hai'); 
                conGaty.updateProgramManagerOnAccount(oldcon,oldcon.AccountId);
            }
        }*/
        //CH-08-end
    }
    
    public void afterDelete(SObject so){
        Contact con = (Contact)so;
        if(con.AccountId != Null && Con.RecordTypeId == conRecordTypeId && con.Rep_Status__c == 'Active'){
            ConList.add(con);
        }
        objects = ConList;
        conGaty.deleteContactCount(Trigger.Old);
        /*if(con.AccountId != null){
            conGaty.updateProgramManagerOnAccount(con,null);//CH-08
        }*/
    }
    
    /**
* andFinally
*
* This method is called once all records have been processed by the trigger. Use this 
* method to accomplish any final operations such as creation or updates of other records.
*/
    public void andFinally(){
        
        try {                         //CH-04-Start
            
            if(updateLostOutcomesList!=null){
                if(updateLostOutcomesList.size()>0) {
                    
                    update updateLostOutcomesList;
                }} //Sai>> where is this list is getting populated. 
            //Ashish> this Filed is populated from findOpportunity method of LPL_ContactTriggergateway.
            if(oppList.size() > 0){
                update oppList;
            }
            if(accList .size() > 0){}
            
            conGaty.processAndFinally(); // CH-05 - Create MA Tasks
        }
        catch(exception e) {
            
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_ContactTriggerHandler ','andFinally',e.getMessage(),e.getLineNumber(),e.getTypeName());
            
        }           //Ch-04-End
    }
    
}