/*
*****************Change History********************
CH-#            Description                             Developer               Date
--------------------------------------------------------------------------------------
CH-1            Adding logic to save date value of      CTS-Sai Kethu           24-Nov-15               
                "4 - Meeting" stage.
CH-2            1.)Revenue Received date field auto     CTS-Sai Kethu           24-Nov-15 
                populate whenever Revenue Submitted 
                is selected in the status dropdown
                2.Revenue Approved date auto populate 
                whenever the Revenue Approved dropdown
                is selected in the status dropdown?
*/

trigger OpportunityTrigger on Opportunity (before insert, before update,After Insert,After Update) {
if(userinfo.getProfileId() == System.Label.SystemAdmin && System.Label.OpptSkipTrigger == 'TRUE') 
{
System.debug('Inside Trigger&&&&&&&&&& --'+ System.UserInfo.getProfileId());
//Date today = Date.today();
}
else
{
if(trigger.Isbefore && (trigger.IsInsert || trigger.Isupdate)){
//Opportunity_Utility.update_TotalAdvisoryAUM(trigger.new,trigger.Isupdate,Trigger.oldmap);
}

if((trigger.IsAfter && Trigger.IsInsert) || (Trigger.ISAfter && Trigger.IsUpdate) && Opportunity_EmailHandler.Recursive ){
//Opportunity_EmailHandler.EmailsHandler(Trigger.New,Trigger.oldmap,trigger.Isupdate);
}
if(Trigger.Isbefore){
    OpportunityHandler handler = new OpportunityHandler();
    
    Set<Id> opp = new Set<Id>(); 
    Set<Id> con = new Set<Id>(); 
    List<Opportunity> opi = new List<Opportunity>();
    List<Opportunity> opu = new List<Opportunity>();
    Map<Id,Id> opc = new Map<Id,Id>(); 
  //  RecordType ISOpp = [SELECT Id, Name from RecordType where SobjectType = 'Opportunity' and Name='IS Opportunity'];
    RecordType IASBD = [SELECT Id, Name from RecordType where SobjectType = 'Opportunity' and Name='IAS Business Development'];
 
 Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
                                                  system.debug('++++++++++++++++++++++++++++ RecordTypes: ' + ' ' + IASBD.Id);
          Opportunity oldOpp = new Opportunity();
          List<ID> conIds = new List<ID>();
          For(Opportunity o : Trigger.new){          
                                          system.debug('+++++++++++++++++++++++++++++++ TRIGGER ZIP: ' + o.Zip_Code__c + '+ OPP ID: ' + o.Id + '+ CONTACT: ' + o.Contact__c);         
            if(trigger.isUpdate){
            oldOpp = Trigger.OldMap.get(o.ID); }
            
            If(trigger.isUpdate) {
               If(o.Contact__c != Trigger.oldMap.get(o.Id).Contact__c || o.Assigned_Recruiter__c == null) {
                  opp.add(o.Id);
                  opc.put(o.Id,o.Contact__c);
                                          system.debug('+++++++++++++++++++++++++++++++ UPDATE: ' + o.Id + '+ CONTACT: ' + o.Contact__c);         
               }
                // CH-1 - START
                if((o.StageName != Trigger.oldMap.get(o.Id).StageName) && o.StageName == '4 - Meeting' && o.StageName != NULL){
                    o.Stage_4_Changed_Date__c = System.today();
                }
                // CH-1 - END
                // CH-2 - START
                if((o.Revenue_Verification_Status__c != Trigger.oldMap.get(o.Id).Revenue_Verification_Status__c) && o.Revenue_Verification_Status__c == 'Revenue Submitted' && o.Revenue_Verification_Status__c != NULL){
                o.Revenue_Received__c = System.today();
                }
                if((o.Revenue_Verification_Status__c != Trigger.oldMap.get(o.Id).Revenue_Verification_Status__c) && o.Revenue_Verification_Status__c == 'Revenue Approved' && o.Revenue_Verification_Status__c != NULL){
                o.Revenue_Approved__c = System.today();  
                }
                // CH-2 - END
                  If(o.Contact__c != null) con.add(o.Contact__c);
                
                /*  Start -******** Lead Onboarding Changes **********  */
                
                //Kit Review and OBA Review Status Entry
                if(o.GRC_Status__c != Trigger.oldMap.get(o.ID).GRC_Status__c || o.Review_Status__c != Trigger.oldMap.get(o.ID).Review_Status__c){
                        handler.updateEntryExitFieldsonOpportunity(Trigger.new,Trigger.oldMap);
                    }
            /*    if(o.Direct_Independent_Affiliation__c != Trigger.oldMap.get(o.ID).Direct_Independent_Affiliation__c 
                || o.Create_Their_Own_Independent_OSJ__c != Trigger.oldMap.get(o.ID).Create_Their_Own_Independent_OSJ__c
                || o.Existing_Broker_Dealer_Exploring_Partn__c != Trigger.oldMap.get(o.ID).Existing_Broker_Dealer_Exploring_Partn__c
                || o.Join_Existing_Institution_Bank_CU__c != Trigger.oldMap.get(o.ID).Join_Existing_Institution_Bank_CU__c
                || o.Join_Existing_Independent_Branch__c != Trigger.oldMap.get(o.ID).Join_Existing_Independent_Branch__c){
                handler.updateCheckInOutEntryCheckboxFields(Trigger.new, Trigger.oldMap);
            }*/
            
            conIds.add(o.Contact__c);
            
                  opi.add(o);
            
            
            }
            
            if(conIds.size() != 0){
              //handler.updateConOppFields(conIds, Trigger.New);
            }
            /*  End -******** Lead Onboarding Changes ********** */
            
            
            If(trigger.isInsert) {
                                          system.debug('+++++++++++++++++++++++++++++++ INSERT: ' + o.Id);         
                if( o.StageName != NULL && o.StageName == '4 - Meeting'){
                    o.Stage_4_Changed_Date__c = System.today();
                }
                // CH-1 - END
                // CH-2 - START
                if( o.Revenue_Verification_Status__c != NULL && o.Revenue_Verification_Status__c == 'Revenue Submitted'){
                o.Revenue_Received__c = System.today();
                }
                if(o.Revenue_Verification_Status__c != NULL && o.Revenue_Verification_Status__c == 'Revenue Approved'){
                o.Revenue_Approved__c = System.today();  
                }
                // CH-2 - END
                
                
                if(rt_Map.get(o.recordTypeID).getName() == 'IAS Business Development' || rt_Map.get(o.recordTypeID).getName() == 'IS Business Development'){
                    handler.updateEntryExitFieldsonOpportunity(Trigger.new,Trigger.oldMap);
                }
                
                
                conIds.add(o.Contact__c);
                
                
                  opi.add(o);
                
                
                
                }
                
            }
            
          If(opi.size()>0) {
                 //handler.onBeforeInsert(opi, oldOpp);
             }
             
          if(conIds.size() != 0){
              //handler.updateConOppFields(conIds, Trigger.New);
          }
            
          If(con.size()>0) {
             Map<Id,Contact> c = new Map<Id,Contact>([SELECT Id, HomePhone, Phone, MobilePhone, Fax, Email, 
                        MailingStreet, MailingCity, MailingState, MailingPostalCode,
                        DoNotCall, Do_Not_Mail__c, HasOptedOutOfEmail,ELQ_Marketing_Email_Opt_Out__c,Discovery_Contact_Phone__c,Discovery_Contact_Address_1__c,Discovery_Contact_Address_2__c,Discovery_Contact_City__c,Discovery_Contact_State__c
                        FROM Contact WHERE Id =: con]);
                                                        
          If(opp.size()>0) {
           For(Opportunity oc : Trigger.new) {                  
                                          system.debug('+++++++++++++++++++++++++++++++ OPP ID: ' + oc.Id + '+ CON ID: ' + oc.Contact__c);         
                If( oc.RecordTypeId == IASBD.Id) {
                    If(oc.Contact__c != null && trigger.isUpdate) {
                        oc.Home_Phone__c = c.get(oc.Contact__c).HomePhone;
                        
                        if(c.get(oc.Contact__c).Phone!=null)
                        oc.Work_Phone__c = c.get(oc.Contact__c).Phone;
                        else
                        oc.Work_Phone__c = c.get(oc.Contact__c).Discovery_Contact_Phone__c;
                        
                        
                        oc.Mobile__c = c.get(oc.Contact__c).MobilePhone;
                        oc.Fax__c = c.get(oc.Contact__c).Fax;
                        oc.Email__c = c.get(oc.Contact__c).Email;
                        
                        if(c.get(oc.Contact__c).MailingStreet != null)
                        oc.Home_Address__c = c.get(oc.Contact__c).MailingStreet;
                        else
                        oc.Home_Address__c = c.get(oc.Contact__c).Discovery_Contact_Address_1__c;
                        
                        if(c.get(oc.Contact__c).MailingCity!= null)
                        oc.City__c = c.get(oc.Contact__c).MailingCity;
                        else
                        oc.City__c = c.get(oc.Contact__c).Discovery_Contact_City__c;
                        
                        if(c.get(oc.Contact__c).MailingState!= null)
                        oc.State__c = c.get(oc.Contact__c).MailingState;
                        else
                        oc.State__c = c.get(oc.Contact__c).Discovery_Contact_State__c;
                        
                        oc.Zip_Code__c = c.get(oc.Contact__c).MailingPostalCode;
                        
                        oc.Do_Not_Call__c = c.get(oc.Contact__c).DoNotCall;
                        oc.Do_Not_Mail__c = c.get(oc.Contact__c).Do_Not_Mail__c;
                        oc.Email_Opt_Out__c = c.get(oc.Contact__c).HasOptedOutOfEmail;
                        oc.ELQ_Marketing_Email_Opt_Out__c = c.get(oc.Contact__c).ELQ_Marketing_Email_Opt_Out__c;

                    If(oc.Assigned_Recruiter__c == null) {
                       opu.add(oc);
                       }
                    }
                }
                                              system.debug('+++++++++++++++++++++++++++++++ CON ZIP: ' + oc.Zip_Code__c);

                               
                } // end for oc
           } // end if opp
          If(opu.size()>0) {
             //handler.onBeforeInsert(opu, oldOpp);
             }
     
   }
}        
        /*  Start - ******** Lead Onboarding Changes **********  */
            
        if(Trigger.Isafter){
        Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
        Map<ID,Schema.RecordTypeInfo> rt_MapCon = Contact.sObjectType.getDescribe().getRecordTypeInfosById();
        
        System.debug(rt_MapCon);
            
            if(Trigger.isInsert){
                
                
                List<Opportunity> oppList = new List<opportunity>();
                List<String> oppZipList = new List<String>();
                
                List<ID> conList = new List<ID>();
                for(Opportunity opp : Trigger.new){
                    if(rt_Map.get(opp.recordTypeID).getName() == 'IAS Business Development' || rt_Map.get(opp.recordTypeID).getName() == 'IS Business Development'){
                        oppList.add(opp);
                        oppZipList.add(opp.Zip_Code__c);
                    }
                    
                    
                }
                OpportunityHandler handler1 = new OpportunityHandler();
                if(oppList.size() != 0){
                    
                    //handler1.createOpportunityActivity(Trigger.new,Trigger.oldMap);
                    //handler1.handleIASRecruitmentUpdate(oppZipList, Trigger.new, Trigger.oldMap);
                }
                
                
                
                
            }
            
            
            
            
            
            if(Trigger.isUpdate){
                OpportunityHandler handler1 = new OpportunityHandler();
                Map<ID, Opportunity> oppUpdateMap = new Map<ID, Opportunity>();
                Map<String, ID> oppTaskMap = new Map<String, ID>();
                Set<ID> oppID = new Set<ID>();
                List<Opportunity> newOppTaskList = new List<Opportunity>();
                
                List<Opportunity> getTaskOpp = Trigger.new;
                
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Task' and Name = 'Transitions' LIMIT 1];
                
                
                
                
                for(Opportunity opp : Trigger.new){
                system.debug('*********'+rt_Map.get(opp.recordTypeID).getName());
                if(rt_Map.get(opp.recordTypeID).getName().containsIgnoreCase('IAS Business Development') || rt_Map.get(opp.recordTypeID).getName() == 'IS Business Development'){
                    system.debug('***************Inside Update');
                    Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
                    system.debug('***************Inside Update'+oldOpp);
                    if(opp.Integration_Manager__c != oldOpp.Integration_Manager__c){
                        oppUpdateMap.put(oldOpp.Integration_Manager__c, opp);
                        oppID.add(opp.ID);
                        oppTaskMap.put('Onboarding Consultant', Opp.Integration_Manager__c);
                    }
                    if(opp.Transition_Support_Partners__c!= oldOpp.Transition_Support_Partners__c){
                        oppUpdateMap.put(oldOpp.Transition_Support_Partners__c, opp);
                        oppID.add(opp.ID);
                        oppTaskMap.put('Transition Support Partners', Opp.Transition_Support_Partners__c);
                    } 
                    if(opp.Investment_Transition_Consultant__c!= oldOpp.Investment_Transition_Consultant__c){
                        oppUpdateMap.put(oldOpp.Investment_Transition_Consultant__c, opp);
                        oppID.add(opp.ID);
                        oppTaskMap.put('Investment Transition Partner', Opp.Investment_Transition_Consultant__c);
                    } 
                    if(opp.Regional_Transition_Partner__c!= oldOpp.Regional_Transition_Partner__c){
                        oppUpdateMap.put(oldOpp.Regional_Transition_Partner__c, opp);
                        oppID.add(opp.ID);
                        oppTaskMap.put('Regional Transition Partner', Opp.Regional_Transition_Partner__c);
                    }  
                    
                    system.debug('***************Inside Update'+oldOpp);
                    if((opp.Regional_Transition_Partner__c!= null &&  (oldOpp.Regional_Transition_Partner__c == null || oldOpp.Regional_Transition_Partner__c != null))
                        || (opp.Investment_Transition_Consultant__c != null &&  (oldOpp.Investment_Transition_Consultant__c == null || oldOpp.Investment_Transition_Consultant__c != null ))
                        || (opp.Transition_Support_Partners__c != null &&  (oldOpp.Transition_Support_Partners__c == null || oldOpp.Transition_Support_Partners__c != null))
                        || (opp.Integration_Manager__c != null &&  (oldOpp.Integration_Manager__c == null || oldOpp.Integration_Manager__c != null) ) ){
                        newOppTaskList.add(opp);
                        system.debug('****'+newOppTaskList);
                    }
                    
                    
                }
                }
                
                if(oppUpdateMap.size() != 0){
                    //handler1.updateOpportunityActivity(oppUpdateMap, oppID, oppTaskMap);
                }
                
                if(newOppTaskList.size() != 0) {
                system.debug('****'+newOppTaskList);
                    //handler1.createOpportunityActivity(newOppTaskList, Trigger.oldMap);
                }
                
            }
            
            
        }
        
        
       
        /*  End - ******** Lead Onboarding Changes ********** */
       }
}