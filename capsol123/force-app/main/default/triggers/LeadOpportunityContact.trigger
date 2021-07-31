trigger LeadOpportunityContact on Lead (before update, before insert) {
    
    set<string> zips = new set<string>(); //CH-01
    set<string> c_zips = new set<string>(); //CH-01
    set<string> m_zips = new set<string>(); //CH-01
    
    Map<String,Schema.RecordTypeInfo> ledRecordtypes = Lead.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map<String, list<IAS_Recruiter_Assignment__c>> ias_zip_Map = new Map<String, list<IAS_Recruiter_Assignment__c>>();
    
    RecordType ISOpp = [SELECT Id, Name from RecordType where SobjectType = 'Lead' and Name='Discovery Database Lead'];
    
    if(Trigger.isBefore){
    
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(Lead led : Trigger.New)
            {
               if( led.PostalCode != null)//create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
               {
                   zips.add(led.PostalCode);
                   c_zips.add('C'+led.PostalCode);
                   m_zips.add('M'+led.PostalCode);
               }    
            }
            
            //retrieve IAS_Recruiter_Assignment__c with common name/zip code
            for(IAS_Recruiter_Assignment__c ias : [Select Name
                                                        , Assigned_Recruiter__c
                                                        , Internal_Recruiter__c
                                                        , Regional_VP__c
                                                        , Lead_Type__c
                                                        , GDC_Maximum__c
                                                        , GDC_Minimum__c
                                                     from IAS_Recruiter_Assignment__c
                                                    where name in :zips
                                                       or name in :c_zips
                                                       or name in :m_zips ])
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
            
            
            map<string, string> updatedLed = new map<string, string>();
            
            for(Lead led : Trigger.new)
            {
                boolean matched = false;  
                
                Lead oldLed = new Lead();
                if(Trigger.isUpdate){
                    oldLed = Trigger.oldMap.get(led.ID);
                }
                
                if((led.Internal_Recruiter_IRD__c != oldLed.Internal_Recruiter_IRD__c 
                    || led.Assigned_Recruiter__c != oldLed.Assigned_Recruiter__c 
                    || led.Regional_VP__c != oldLed.Regional_VP__c 
                    || led.Prospect_Type__c != oldLed.Prospect_Type__c) 
                && ((led.GDC_Prior_12_mo__c == oldLed.GDC_Prior_12_mo__c) || led.Channel_Owner__c == oldLed.Channel_Owner__c )){
                system.debug('*********inside first IF');
                if(led.Prospect_Type__c != oldLed.Prospect_Type__c){
                    doIASassignment(led);    
                }else {
                    continue;
                }
                
                } else {
                //move on if there are no records
                if(led.PostalCode == null || ias_zip_Map.get(led.PostalCode.trim()) == null )
                {
                  if(led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())//assign the default recruiter for these record types when zip is null
    
                   if(Default_Oppty_Owner__c.getInstance()!=null) 
                   led.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
                  
                  continue;
                }
                
                if(led.GDC_Prior_12_mo__c != oldLed.GDC_Prior_12_mo__c 
                        || led.Channel_Owner__c != oldLed.Channel_Owner__c 
                        || led.Lead_Type__c != oldLed.Lead_Type__c){
                doIASassignment(led);
                }
                
                }
            }
        }
    
    }
    public void doIASassignment(Lead led) {
    
        boolean matched;
        //get the IAS Recruiter records to compare
                if(led.PostalCode != Null)
                {
                if(ias_zip_Map.containskey(led.PostalCode.trim()))
                    {
                    list<IAS_Recruiter_Assignment__c> iasList = ias_zip_Map.get(led.PostalCode.trim());
                    
                    //iterate over the IAS Recruiter records matching the oppty zip code to find a match
                    if(iasList.size()>0)
                        {
                        for(IAS_Recruiter_Assignment__c ias : iasList)
                            {
                                if(led.Prospect_Type__c == ias.Lead_Type__c && led.Allow_Lead_Type_Change__c == true){
                                led.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                led.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                led.Regional_VP__c = ias.Regional_VP__c;
                                led.Prospect_Type__c = ias.Lead_Type__c;
                                matched = true;
                                break;   
                                } 
                                else {
                                    if(led.Allow_Lead_Type_Change__c == true){
                                        continue;
                                    } else {
                                
                                if(led.Channel_Owner__c == 'IS BD') {
                                    if(ias.Lead_Type__c == 'Masters') {
                                        led.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                        led.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                        led.Regional_VP__c = ias.Regional_VP__c;
                                        led.Prospect_Type__c = ias.Lead_Type__c;
                                        matched = true;
                                        break;
                                    }else {
                                        Continue;
                                    }
                                    
                                } else {
                                
                                if((led.Channel_Owner__c == 'IS BD' || ias.Lead_Type__c == 'Masters')
                                          && led.GDC_Prior_12_mo__c< ias.GDC_Maximum__c
                                          && led.GDC_Prior_12_mo__c>= ias.GDC_Minimum__c
                                          && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())
                                {
                                    system.debug('**********************');
                                    //Update the Opportunity fields with the IAS Recruiter Data
                                    //o.OwnerId = ias.Assigned_Recruiter__c;
                                    led.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                    led.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                    led.Regional_VP__c = ias.Regional_VP__c;
                                    led.Prospect_Type__c = ias.Lead_Type__c;
                                    matched = true;
                                } else {
                                system.debug('**********************');
                                    //find the IAS Recruiter record within range of the opportunity
                                    if(led.GDC_Prior_12_mo__c != null
                                      && led.GDC_Prior_12_mo__c< ias.GDC_Maximum__c
                                      && led.GDC_Prior_12_mo__c>= ias.GDC_Minimum__c
                                      && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())
                                    {
                                        //Update the Opportunity fields with the IAS Recruiter Data
                                        //o.OwnerId = ias.Assigned_Recruiter__c;
                                        led.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                        led.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                        led.Regional_VP__c = ias.Regional_VP__c;
                                        led.Prospect_Type__c = ias.Lead_Type__c;
                                        matched = true;
                                    }
                                }
                                }
                            if(matched == false && led.Channel_Owner__c != 'IS BD' && ias.Lead_Type__c == 'Core' && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId()){
                                led.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                led.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                led.Regional_VP__c = ias.Regional_VP__c;
                                led.Prospect_Type__c = ias.Lead_Type__c;   
                            }
                            
                            if(matched == false && led.Channel_Owner__c == 'IS BD' && ias.Lead_Type__c == 'Masters' && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId()){
                                led.Assigned_Recruiter__c = ias.Assigned_Recruiter__c;
                                led.Internal_Recruiter_IRD__c = ias.Internal_Recruiter__c;
                                led.Regional_VP__c = ias.Regional_VP__c;
                                led.Prospect_Type__c = ias.Lead_Type__c;   
                            }
                            
                                       
                            }
                        }
                        
                    }
          } }      }
    }
    
    
    
    if(Trigger.isUpdate){
    
        Map<Id, Lead> leadConMap = new Map<Id, Lead>(); // Map of the converted Contact ID and the Lead Status
        Map<Id, Lead> leadOppMap = new Map<Id, Lead>(); // Map of the converted Opprotunity ID and the Lead Status
        
        for(Lead lead : Trigger.new) {
            if (lead.IsConverted) {
                If(lead.ConvertedContactId != null && lead.ConvertedOpportunityId != null) {
                    leadConMap.put(lead.ConvertedContactId, lead);
                    leadOppMap.put(lead.ConvertedOpportunityId, lead);
                }
                else if(lead.ConvertedContactId != null)
                {
                  leadConMap.put(lead.ConvertedContactId, lead);
                }
            }
        }
        
        Map<Id, Contact> oppConMap = new Map<ID, Contact>(); //to Connect Orrortunity and Contact.
        
        List<Contact> conList = [SELECT Id, HomePhone FROM Contact WHERE Contact.Id IN :leadConMap.keyset()];
        if(conList.size() > 0) {
            for ( Contact con : conList) {
                con.HomePhone = leadConMap.get(con.Id).Home_Phone__c;
                oppConMap.put(leadConMap.get(con.Id).ConvertedOpportunityId, con);
                con.recordtypeId=Label.Contact_Prospect_Recordtype;
                con.Lead_Source__c=leadConMap.get(con.Id).LeadSource;
            }
            update conList;
        }
        
        List<Opportunity> oppList = [SELECT Id, Contact__c FROM Opportunity WHERE Id IN :leadOppMap.keyset()];
        if(oppList.size() > 0) {
            for(Opportunity opp : oppList) {
                opp.Contact__c = oppConMap.get(opp.Id).ID;
            }
            update oppList;
        }
    }
    
}