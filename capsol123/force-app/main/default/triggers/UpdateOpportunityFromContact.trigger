/*
##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01       Match to the IAS Recruiting Table based on:         Sai Kethu - CTS     12/27/16
            ?   Contact.MailingPostalCode= IAS Recruiting Assignment.Zip Code AND
            ?   Contact.GDC_Prior_12_mo__c < IAS Recruiting Assignment.GDC_Maximum__c AND
            ?   Contact.GDC_Prior_12_mo__c >= IAS Recruiting Assignment.GDC_Minimum__c
            •   Set Contact.Assigned_Recruiter__c =  Matched Assigned_Recruiter__c
            •   Set Contact.Internal_Recruiter_IRD__c =  Matched Internal_Recruiter__c
            •   Set Contact.Regional_VP__c = Matched Regional_VP__c
            •   Set Contact.Lead_Type__c = Matched Lead_Type__c
*/

trigger UpdateOpportunityFromContact on Contact (before insert, after insert,before update, after update, before delete, after delete, after undelete) {


    Map<Id,Contact> ContactData= new Map<Id,Contact>();
    List<Contact> Contacts= new List<Contact>();
    List<Opportunity> listOpportunity= new List<Opportunity>();     
    Map<ID, Contact> prospConMap = new Map<Id, Contact>();
    
    Map<String,Schema.RecordTypeInfo> conRecordtypes = Contact.sObjectType.getDescribe().getRecordTypeInfosByName();
    map<string, list<IAS_Recruiter_Assignment__c>> ias_zip_Map = new map<string, list<IAS_Recruiter_Assignment__c>>();
    
    set<string> zips = new set<string>(); //CH-01
    set<string> c_zips = new set<string>(); //CH-01
    set<string> m_zips = new set<string>(); //CH-01
    
    ID conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    
    RecordType ISOpp = [SELECT Id, Name from RecordType where SobjectType = 'Opportunity' and Name='IS Opportunity'];
    RecordType IASBD = [SELECT Id, Name from RecordType where SobjectType = 'Opportunity' and Name='IAS Business Development'];
                                                      system.debug('++++++++++++++++++++++++++++ RecordTypes: ' + ISOpp.Id + ' ' + IASBD.Id);
    //**********CH -01: START********
    If(Trigger.IsBefore){
    If(Trigger.IsUpdate || Trigger.IsInsert) {
        //prepare the lists of zip codes to limit the IAS_Recruiter_Assignment__c records
        for(Contact con : Trigger.new)
        {
            if( con.MailingPostalCode != null)//create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
            {
              zips.add(con.MailingPostalCode);
              c_zips.add('C'+con.MailingPostalCode);
              m_zips.add('M'+con.MailingPostalCode);
              //conIds.add(o.Contact__c);
            }
        }
        
        
        
        
        //retrieve IAS_Recruiter_Assignment__c with common name/zip code
        List<IAS_Recruiter_Assignment__c> iasList = [Select Name
                                                    , Assigned_Recruiter__c
                                                    , Internal_Recruiter__c
                                                    , Regional_VP__c
                                                    , Lead_Type__c
                                                    , GDC_Maximum__c
                                                    , GDC_Minimum__c
                                                 from IAS_Recruiter_Assignment__c
                                                where name in :zips
                                                   or name in :c_zips
                                                   or name in :m_zips  ];
        
        for(IAS_Recruiter_Assignment__c ias : iasList )
        {
            string zip = ias.Name;//the actual zip-code use for matching to the opportunity
            
            if(ias.name.startsWith('C') || ias.Name.startsWith('M'))//strip out the leading "M" or "C"
                zip = ias.name.substring(1,ias.name.length()).trim();

            if(ias_zip_Map.containsKey(zip))//Add to the map or create a new map with a list of IAS_Recruiter_Assignment__c objects
            {
                list<IAS_Recruiter_Assignment__c> l = ias_zip_Map.get(zip);
                l.add(ias);
            }
            else
               ias_zip_Map.put(zip, new list<IAS_Recruiter_Assignment__c>{ias});
              
        }
        map<string, string> updatedOpps = new map<string, string>();
        for(Contact con : Trigger.new)
        {    
            Contact oldCon = new Contact();
            if(Trigger.isUpdate){
                oldCon = Trigger.oldMap.get(con.ID);
            }
            
            if((con.Internal_Recruiter_IRD__c != oldCon.Internal_Recruiter_IRD__c 
                    || con.Assigned_Recruiter__c != oldCon.Assigned_Recruiter__c 
                    || con.Regional_VP__c != oldCon.Regional_VP__c 
                    || con.Lead_Type__c != oldCon.Lead_Type__c) 
                    && ((con.GDC_Prior_12_mo__c == oldCon.GDC_Prior_12_mo__c) 
                        || con.Channel_Owner__c == oldCon.Channel_Owner__c )){
                
                system.debug('*********inside first IF');
                if(con.Lead_Type__c != oldCon.Lead_Type__c){
                    doIASassignment(con);    
                }else {
                    continue;
                }
                
            } else {
            
            
            
            
            boolean matched = false;  
            
            //move on if there are no records
            if(con.MailingPostalCode == null || ias_zip_Map.get(con.MailingPostalCode.trim()) == null )
            {
              if(con.RecordTypeId == conRecordtypes.get('Contact Prospect').getRecordTypeId())//assign the default recruiter for these record types when zip is null

               if(Default_Oppty_Owner__c.getInstance()!=null) 
               con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
              
              continue;
            }
            
            if(con.GDC_Prior_12_mo__c != oldCon.GDC_Prior_12_mo__c 
                        || con.Channel_Owner__c != oldCon.Channel_Owner__c 
                        || con.Lead_Type__c != oldCon.Lead_Type__c 
                        || con.MailingPostalCode != oldCon.MailingPostalCode){
            
                doIASassignment(con);
            }
            
        }
    }
    }
    }
    
    public void doIASassignment(Contact con){
            
            boolean matched = false;
            //get the IAS Recruiter records to compare
            if(con.MailingPostalCode != Null){
            if(ias_zip_Map.containskey(con.MailingPostalCode.trim())){
            list<IAS_Recruiter_Assignment__c> iasList = ias_zip_Map.get(con.MailingPostalCode.trim());
            
            //iterate over the IAS Recruiter records matching the oppty zip code to find a match
            if(iasList.size()>0){
            for(IAS_Recruiter_Assignment__c ias : iasList)
            {
                if(con.Lead_Type__c == ias.Lead_Type__c && con.Allow_Lead_Type_Change__c == true){
                    con.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                    con.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                    con.Regional_VP__c = ias.Regional_VP__c;
                    con.Lead_Type__c = ias.Lead_Type__c;
                    matched = true;
                    break;   
                } 
                else {
                    if(con.Allow_Lead_Type_Change__c == true){
                        continue;
                    } else {
                    
                    if(con.Channel_Owner__c == 'IS BD') {
                        if(ias.Lead_Type__c == 'Masters') {
                            con.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                            con.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                            con.Regional_VP__c = ias.Regional_VP__c;
                            con.Lead_Type__c = ias.Lead_Type__c;
                            matched = true;
                            break;
                        }else {
                            Continue;
                        }
                        
                    } else {
                    
                    if((con.Channel_Owner__c == 'IS BD' || ias.Lead_Type__c == 'Masters')
                              && (con.GDC_Prior_12_mo__c< ias.GDC_Maximum__c   //updated by Subhash
                              && con.GDC_Prior_12_mo__c>= ias.GDC_Minimum__c
                              && con.RecordTypeId == conRecordtypes.get('Contact Prospect').getRecordTypeId()))
                            {
                                system.debug('**********************');
                                //Update the Opportunity fields with the IAS Recruiter Data
                                //o.OwnerId = ias.Assigned_Recruiter__c;
                                con.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                con.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                con.Regional_VP__c = ias.Regional_VP__c;
                                con.Lead_Type__c = ias.Lead_Type__c;
                                matched = true;
                            } else {
                            system.debug('**********************');
                                //find the IAS Recruiter record within range of the opportunity
                                if(con.GDC_Prior_12_mo__c != null
                                  && con.GDC_Prior_12_mo__c< ias.GDC_Maximum__c
                                  && con.GDC_Prior_12_mo__c>= ias.GDC_Minimum__c
                                  && con.RecordTypeId == conRecordtypes.get('Contact Prospect').getRecordTypeId())
                                {
                                    //Update the Opportunity fields with the IAS Recruiter Data
                                    //o.OwnerId = ias.Assigned_Recruiter__c;
                                    con.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                    con.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                    con.Regional_VP__c = ias.Regional_VP__c;
                                    con.Lead_Type__c = ias.Lead_Type__c;
                                    matched = true;
                                }
                            }
                            }
                            //If Lead source is Core then remove logic to IRD as Kara if no GDC value.
                            if(matched == false && con.Channel_Owner__c == 'IS BD'  && ias.Lead_Type__c == 'Masters' && con.RecordTypeId == conRecordtypes.get('Contact Prospect').getRecordTypeId()){
                                con.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                con.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                con.Regional_VP__c = ias.Regional_VP__c;
                                con.Lead_Type__c = ias.Lead_Type__c;   
                            }
                            
                            if(matched == false && con.Channel_Owner__c != 'IS BD' && ias.Lead_Type__c == 'Core' && con.RecordTypeId == conRecordtypes.get('Contact Prospect').getRecordTypeId()){
                                con.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                con.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                con.Regional_VP__c = ias.Regional_VP__c;
                                con.Lead_Type__c = ias.Lead_Type__c;   
                            }
                            
                            
                        } 
                }      
                        
            }
            }
            }
            }
           /*if( matched == false && con.RecordTypeId == conRecordtypes.get('Contact Prospect').getRecordTypeId())//no match. Set the default, internal recruiter. // REf work order SD616902 // Uncommented the code dt: 09/28/15
             con.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
            */
    }
    
    //**********CH -01: END********
    
    
    If(Trigger.isAfter){
    
    Map<Id, List<Contact>> mapAcctIdContactList = new Map<Id, List<Contact>>();
    Map<Id, List<Contact>> mapAcctIdDelContactList = new Map<Id, List<Contact>>();
    Set<Id> AcctIds = new Set<Id>();    
    List<Account> listAcct = new List<Account>();
        
    If(Trigger.IsUpdate || Trigger.IsInsert) {

      for(Contact contact : Trigger.new){
      
            If(Trigger.isUpdate) {
                If(contact.HomePhone != Trigger.oldMap.get(contact.Id).HomePhone ||
                    contact.Phone != Trigger.oldMap.get(contact.Id).Phone ||
                    contact.MobilePhone != Trigger.oldMap.get(contact.Id).MobilePhone ||
                    contact.Fax != Trigger.oldMap.get(contact.Id).Fax ||
                    contact.Email != Trigger.oldMap.get(contact.Id).Email ||
                    contact.MailingStreet != Trigger.oldMap.get(contact.Id).MailingStreet ||
                    contact.MailingCity != Trigger.oldMap.get(contact.Id).MailingCity ||
                    contact.MailingState != Trigger.oldMap.get(contact.Id).MailingState ||
                    contact.MailingPostalCode != Trigger.oldMap.get(contact.Id).MailingPostalCode ||
                    contact.DoNotCall != Trigger.oldMap.get(contact.Id).DoNotCall||
                    contact.Do_Not_Mail__c != Trigger.oldMap.get(contact.Id).Do_Not_Mail__c ||
                    contact.HasOptedOutOfEmail != Trigger.oldMap.get(contact.Id).HasOptedOutOfEmail ||
                    contact.ELQ_Marketing_Email_Opt_Out__c != Trigger.oldMap.get(contact.Id).ELQ_Marketing_Email_Opt_Out__c) {
                        ContactData.put(contact.Id,Contact);
                        Contacts.add(contact);
                        system.debug('++++++++++++++++++++++++++++ CHANGE: ' + contact.Id);
                }
                
                if(Trigger.oldMap.get(contact.Id).RecordTypeID == conRecordTypeId)  {
                    prospConMap.put(contact.ID, contact);
                    ContactData.put(contact.Id,Contact);
                }
                
                /*Start - Account - Contact Rollup Logic */
                if(String.isNotBlank(contact.AccountId) && contact.AccountId != trigger.oldMap.get(contact.Id).AccountId) {
                if(!mapAcctIdContactList.containsKey(contact.AccountId)){
                    mapAcctIdContactList.put(contact.AccountId, new List<Contact>());
                }
                    mapAcctIdContactList.get(contact.AccountId).add(contact); 
                    AcctIds.add(contact.AccountId);
                } else if(String.isBlank(contact.AccountId) && String.isNotBlank(trigger.oldMap.get(contact.Id).AccountId)) {
                    if(!mapAcctIdDelContactList.containsKey(contact.AccountId)){
                        mapAcctIdDelContactList.put(contact.AccountId, new List<Contact>());
                    }
                    mapAcctIdDelContactList.get(contact.AccountId).add(contact);   
                    AcctIds.add(trigger.oldMap.get(contact.Id).AccountId);
                }
                /*End- Account - Contact Rollup Logic */
                
            }
            
            If(Trigger.isInsert) {
                ContactData.put(contact.Id,Contact);
                Contacts.add(contact);
                
                /*  Start - ******** Lead Onboarding Changes **********  */
                
                if(contact.RecordTypeID == conRecordTypeId)  {
                    prospConMap.put(contact.ID, contact);
                    ContactData.put(contact.Id,Contact);
                }
                system.debug('++++++++++++++++++++++++++++ INSERT: ' + contact.Id);
                
                /*  End - ******** Lead Onboarding Changes ********** */
                
                /*Start - Account - Contact Rollup Logic */
                if(String.isNotBlank(contact.AccountId)) {
                    if(!mapAcctIdContactList.containsKey(contact.AccountId)) {
                        mapAcctIdContactList.put(contact.AccountId, new List<Contact>());
                    }
                    mapAcctIdContactList.get(contact.AccountId).add(contact); 
                    AcctIds.add(contact.AccountId);
                }
                /*End- Account - Contact Rollup Logic */
            }
            
            
        } // end trigger for
    } // update or insert
    
    if(trigger.isUndelete) {
        for(Contact Con : trigger.new) {
            if(String.isNotBlank(Con.AccountId)){
                if(!mapAcctIdContactList.containsKey(Con.AccountId)){
                    mapAcctIdContactList.put(Con.AccountId, new List<Contact>());
                }
                mapAcctIdContactList.get(Con.AccountId).add(Con);     
                AcctIds.add(Con.AccountId);
            }
        }  
    }      

    if(trigger.isDelete) {
        for(Contact Con : trigger.Old) {
            if(String.isNotBlank(Con.AccountId)){
                if(!mapAcctIdDelContactList.containsKey(Con.AccountId)){
                    mapAcctIdDelContactList.put(Con.AccountId, new List<Contact>());
                }
                mapAcctIdDelContactList.get(Con.AccountId).add(Con);    
                AcctIds.add(Con.AccountId); 
            }
        }  
    }   
    
    /*if(AcctIds.size() > 0) {
        listAcct = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id IN : AcctIds];
        Decimal noOfConts;
        for(Account acct : listAcct) {
            if(Trigger.isDelete){
                noOfConts = acct.Number_of_Contacts__c;
            }else{
                noOfConts = 0;
            }
            
            /*if(mapAcctIdContactList.containsKey(acct.Id)) {
                noOfConts += mapAcctIdContactList.get(acct.Id).size();
            }*/ /*
            if(mapAcctIdDelContactList.containsKey(acct.Id) && mapAcctIdDelContactList != null) {
                system.debug('inside Decrease');
                if(noOfConts != 0){
                    system.debug('Decrease');
                    noOfConts = noOfConts - mapAcctIdDelContactList.get(acct.Id).size();
                    system.debug('****'+mapAcctIdDelContactList.get(acct.Id).size());
                    system.debug('****'+noOfConts);
                    
                } else {
                    noOfConts = 0;   
                }
            }
            //acct.Number_of_Contacts__c = acct.Number_of_Contacts__c == null ? noOfConts : (acct.Number_of_Contacts__c + noOfConts);
            
            if(Trigger.isDelete){
                acct.Number_of_Contacts__c = noOfConts ;
            }
            
            system.debug('Count Size'+acct.Number_of_Contacts__c);
        }
        system.debug('Deleted Main Contact');
        update listAcct;    
        }
    */
     
     If(Contacts.size()>0 || prospConMap.size() > 0) { 
     For(Opportunity o : [SELECT Id, Contact__c, Contact__r.RecordType.Name, 
                            Home_Phone__c, Work_Phone__c, Mobile__c, Fax__c, Email__c, 
                            Home_Address__c, City__c, State__c, Zip_Code__c,
                            Do_Not_Call__c, Do_Not_Mail__c, Email_Opt_Out__c, ELQ_Marketing_Email_Opt_Out__c,
                            Current_Firm2__c, LeadSource, Source_Type__c, Referral_By__c, Referring_Advisor_Rep_ID__c, Marketing_Classification__c, Mailer_Code__c,
                            Years_in_Industry__c, Licenses__c, Current_Firm__c
                            FROM Opportunity WHERE (Contact__c = : Contacts OR Contact__c in: prospConMap.keyset()) AND
                            (RecordTypeId =: ISOpp.Id OR RecordTypeId =: IASBD.Id)]){
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
                        
                        if(prospConMap.get(o.Contact__c).Lead_Source__c != null && o.LeadSource != prospConMap.get(o.Contact__c).Lead_Source__c  ){
                            o.LeadSource = prospConMap.get(o.Contact__c).Lead_Source__c;
                        }
                        if(o.Source_Type__c != prospConMap.get(o.Contact__c).Source_Type_Prospect__c && prospConMap.get(o.Contact__c).Source_Type_Prospect__c != null){
                            o.Source_Type__c = prospConMap.get(o.Contact__c).Source_Type_Prospect__c;
                        }
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
                        
                        }
                    }
                
                listOpportunity.add(o);
                system.debug('++++++++++++++++++++++++++++ UPDATED: ' + o.Contact__c + ' ' + o.Id);
                
                /*  End - ******** Lead Onboarding Changes ********** */
            }
        }  // end Opportunity         
    } // end if Contacts
  
    If(listOpportunity.size() > 0){
        system.debug('++++++++++++++++++++++++++++ UPDATE ALL: ' + listOpportunity.size());
        update listOpportunity;
    }
    
    }
    
}