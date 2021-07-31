/*
#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------
CH-01  Logic optimization                                                Pravin Kale                        20 june 2017   

CH-02 Using the same logic as the Contacts object, programmatically      Vaibhav Jain                       28 Feb 2019
populate the “Internal Recruiter (IRD)” (Internal_Recruiter_IRD__c) and
“Assigned Recruiter” (Assigned_Recruiter__c) fields on Leads

CH-03 If the “Internal Recruiter (IRD)” (Internal_Recruiter_IRD__c)      Vaibhav Jain                       28 Feb 2019
field is changed on a Lead, programmatically change the “Owner” (Owner)
to match the “Internal Recruiter (IRD)” (Internal_Recruiter_IRD__c)

*/

public class LPL_LeadTriggerGateway{
    
    Map<String,Schema.RecordTypeInfo> ledRecordtypes = Lead.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map<String, list<IAS_Recruiter_Assignment__c>> ias_zip_Map = new Map<String, list<IAS_Recruiter_Assignment__c>>();
    
    Set<String> pinCodes = new Set<String>();
    set<string> zips = new set<string>();
    set<string> c_zips = new set<string>();
    set<string> m_zips = new set<string>();
    Map<Id, Lead> leadConMap = new Map<Id, Lead>(); // Map of the converted Contact ID and the Lead Status
    Map<Id, Lead> leadOppMap = new Map<Id, Lead>(); // Map of the converted Opprotunity ID and the Lead Status
    Map<Id, Contact> oppConMap = new Map<ID, Contact>(); //to Connect Orrortunity and Contact.
    List<Contact> conList = new List<Contact>();
    List<Opportunity> oppList = new List<Opportunity>();
    
    Map<Id, Lead> leadMap = new Map<Id, Lead>();
    List<ELOQUA__Marketing_Activity__c> elqMktList  = new List<ELOQUA__Marketing_Activity__c>();
    list<ELOQUA__Marketing_Activity__c> elqMrkActLst = new list<ELOQUA__Marketing_Activity__c>();
    
    List<Contact> conListUpdate = new List<Contact>();
    List<Opportunity> oppListUpdate = new List<Opportunity>();
    
    public void collectRecordToProcess(List<Lead> leadLst, List<Lead> oldledList){
        try{
            Map<Id,Lead> oldledMap=new Map<Id,Lead>();
            
            if(oldledList != null){
                for(Integer i=0;i<oldledList.size();i++){      //ch-1 start
                    oldledMap.put(oldledList[i].id,oldledList[i]);
                }
            }
            
            for(Lead led : leadLst){
                Lead oldled=oldledMap.get(led.id);
                If(Trigger.IsInsert){
                    if( led.PostalCode != null  && !led.IsConverted && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())//create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
                    {
                        zips.add(led.PostalCode);
                        c_zips.add('C'+led.PostalCode);
                        m_zips.add('M'+led.PostalCode);
                    }
                    //CH-02 -start modify all records irrespective of their record types
                    else if(led.RecordTypeId != ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())
                        zips.add(led.PostalCode);
                    //CH-02 -end
                }
                
                if(Trigger.IsUpdate){
                    //***********CH-01:START*********
                    //create sets of zip codes matching the IAS_Recruiter_Assignment__c object's three variations.
                    
                    if(led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId()){
                        if(led.PostalCode != null ||
                           (led.GDC_Prior_12_mo__c != null && (led.GDC_Prior_12_mo__c != oldled.GDC_Prior_12_mo__c)) ||
                           (led.Channel_Owner__c != null && (led.Channel_Owner__c != oldled.Channel_Owner__c)) ||
                           (led.Prospect_Type__c != null && (led.Prospect_Type__c != oldled.Prospect_Type__c )) ||
                           led.Allow_Lead_Type_Change__c == true ){
                               zips.add(led.PostalCode );
                               c_zips.add('C'+led.PostalCode );
                               m_zips.add('M'+led.PostalCode );
                           }
                    }
                    //CH-02 -start modify all records irrespective of their record types
                    else if(led.RecordTypeId != ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())
                        zips.add(led.PostalCode);
                    //CH-02 -end
                }
                //***********CH-01:END*********
                
                if (led.IsConverted) {
                    If(led.ConvertedContactId != null && led.ConvertedOpportunityId != null) {
                        leadConMap.put(led.ConvertedContactId, led);
                    }
                    else if(led.ConvertedContactId != null){
                        leadConMap.put(led.ConvertedContactId, led);
                    }
                } 
            }
            
            conList = [SELECT Id, HomePhone FROM Contact WHERE Contact.Id IN :leadConMap.keyset()];
            //retrieve IAS_Recruiter_Assignment__c with common name/zip code
            if(zips.size()>0){
                for(IAS_Recruiter_Assignment__c ias : [Select Name, Assigned_Recruiter__c
                                                       , Internal_Recruiter__c, Regional_VP__c
                                                       , Lead_Type__c, GDC_Maximum__c
                                                       , GDC_Minimum__c from IAS_Recruiter_Assignment__c
                                                       where name in :zips or name in :c_zips
                                                       or name in :m_zips ]){
                                                           string zip = ias.Name;//the actual zip-code use for matching to the opportunity
                                                           if(ias.name.startsWith('C') || ias.Name.startsWith('M'))//strip out the leading "M" or "C"
                                                               zip = ias.name.substring(1,ias.name.length()).trim();
                                                           
                                                           if(ias_zip_Map.containsKey(zip)){//Add to the map or create a new map with a list of IAS_Recruiter_Assignment__c objects : Changes by Sai
                                                               list<IAS_Recruiter_Assignment__c> l = ias_zip_Map.get(zip);
                                                               l.add(ias);
                                                           }
                                                           else
                                                               ias_zip_Map.put(zip, new list<IAS_Recruiter_Assignment__c>{ias});
                                                       }
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_LeadTriggerGateway','collectRecordToProcess',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    
    public void collectRecordToProcessAfter(List<Lead> leadLst){
        try {
            for(Lead led : leadLst){
                if (led.IsConverted) {
                    leadMap.put(led.id, led);
                    If(led.ConvertedContactId != null && led.ConvertedOpportunityId != null) {
                        leadConMap.put(led.ConvertedContactId, led);
                        leadOppMap.put(led.ConvertedOpportunityId, led);
                    }
                    else if(led.ConvertedContactId != null){
                        leadConMap.put(led.ConvertedContactId, led);
                    }
                } 
            }
            
            elqMktList = [select id, ELOQUA__Lead__c, ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c
                          where ELOQUA__Lead__c in: leadMap.keyset()];
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_LeadTriggerGateway','collectRecordToProcessAfter',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    
    public void doInsertOperation(Lead led){
        try{
            //CH-02-start
            if((led.postalCode!=null && ias_zip_Map.containsKey(led.PostalCode.trim())) && 
               led.Allow_Lead_Type_Change__c != true){
                   List<IAS_Recruiter_Assignment__c> ias = ias_zip_Map.get(led.PostalCode.trim());
                   led.Internal_Recruiter_IRD__c = ias[0].Internal_Recruiter__c;
                   led.Assigned_Recruiter__c = ias[0].Assigned_Recruiter__c;
               }
            else{
                if((led.PostalCode==null || !ias_zip_Map.containskey(led.PostalCode.trim())) && 
                   led.Allow_Lead_Type_Change__c != true){
                       if(Default_Oppty_Owner__c.getInstance() != null){ 
                           if(Default_Oppty_Owner__c.getInstance()!=null) 
                               led.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; 
                           led.Assigned_Recruiter__c=null;
                       }
                   }
            }
            
            //CH-02-end
            
            //--------IAS Recruiter Assignment: START-----------
            if(led.GDC_Prior_12_mo__c != Null 
               || (led.Channel_Owner__c != Null || led.Channel_Owner__c != '')
               || (led.Lead_Type__c != Null || led.Lead_Type__c != '') 
               || (led.Prospect_Type__c != Null || led.Prospect_Type__c != '') ){
                   doIASassignment(led);                        
               }
            //CH-03 - start
            if(led.Internal_Recruiter_IRD__c!=null)
                led.OwnerId = led.Internal_Recruiter_IRD__c;System.debug('record type is 12 '+led.Internal_Recruiter_IRD__c);
            //CH-03 - end
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
        
        //--------IAS Recruiter Assignment: END-----------
    }
    
    public void doUpdateOperation(Lead led, Lead oldLed){
        try{
            //CH-02-start
            if(ias_zip_Map.size()>0 && led.PostalCode!=null && ias_zip_Map.containsKey(led.PostalCode.trim())){
                List<IAS_Recruiter_Assignment__c> ias = ias_zip_Map.get(led.PostalCode.trim());
                led.Internal_Recruiter_IRD__c = ias[0].Internal_Recruiter__c;
                led.Assigned_Recruiter__c = ias[0].Assigned_Recruiter__c;
            }
            else{
                if(led.PostalCode==null || !ias_zip_Map.containskey(led.PostalCode.trim()) && led.Allow_Lead_Type_Change__c != true){
                    if(Default_Oppty_Owner__c.getInstance() != null){
                        led.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c;
                        led.Assigned_Recruiter__c=null;
                    }
                }
            }
            //CH-02-end
            boolean matched = false;  
            
            if((led.Internal_Recruiter_IRD__c != oldLed.Internal_Recruiter_IRD__c 
                || led.Assigned_Recruiter__c != oldLed.Assigned_Recruiter__c 
                || led.Regional_VP__c != oldLed.Regional_VP__c 
                || led.Prospect_Type__c != oldLed.Prospect_Type__c) 
               && ((led.GDC_Prior_12_mo__c == oldLed.GDC_Prior_12_mo__c) || led.Channel_Owner__c == oldLed.Channel_Owner__c ) || led.Allow_Lead_Type_Change__c == true){
                   if(led.Prospect_Type__c != oldLed.Prospect_Type__c){
                       doIASassignment(led);    
                   }
                   
               } else {
                   boolean isZipNull = false; 
                   //move on if there are no records
                   if(led.PostalCode == null ) // || ias_zip_Map.get(led.PostalCode.trim()) == null ) - CH-01: Commenting this line
                   {
                       if(led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())//assign the default recruiter for these record types when zip is null
                           
                           if(Default_Oppty_Owner__c.getInstance()!=null) 
                           led.Internal_Recruiter_IRD__c = Default_Oppty_Owner__c.getInstance().OwnerId__c; // REf work order SD616902 //Uncommented the code dt: 09/28/15
                       isZipNull = true;
                   }
                   // CH-01: Added isZipNull condition
                   if(isZipNull == false){ 
                       if(led.GDC_Prior_12_mo__c != oldLed.GDC_Prior_12_mo__c 
                          || led.Channel_Owner__c != oldLed.Channel_Owner__c 
                          || led.Lead_Type__c != oldLed.Lead_Type__c
                          || led.PostalCode != oldled.PostalCode){
                              doIASassignment(led);
                          }
                   }
               }
            //CH-03 - start
            if(led.Internal_Recruiter_IRD__c!=null)
                led.OwnerId = led.Internal_Recruiter_IRD__c;System.debug('!!!!@@ 123');
            //CH-03 - end
        }
        catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause());      
        }
        
    }
    
    public void doIASassignment(Lead led) {
        try{
            boolean matched;
            //get the IAS Recruiter records to compare
            if(led.PostalCode != Null && !led.IsConverted){
                if(ias_zip_Map.containskey(led.PostalCode.trim()) ){
                    list<IAS_Recruiter_Assignment__c> iasList = ias_zip_Map.get(led.PostalCode.trim());
                    
                    //iterate over the IAS Recruiter records matching the oppty zip code to find a match
                    if(iasList.size()>0){
                        for(IAS_Recruiter_Assignment__c ias : iasList){
                            if(led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId()){
                                if(led.Prospect_Type__c == ias.Lead_Type__c && led.Allow_Lead_Type_Change__c == true){
                                    led.Regional_VP__c = ias.Regional_VP__c;
                                    led.Prospect_Type__c = ias.Lead_Type__c;
                                    matched = true;
                                    break; 
                                }
                                else{
                                    if(led.Allow_Lead_Type_Change__c == true){
                                        continue;
                                    }else{
                                        
                                        if((led.GDC_Prior_12_mo__c == NULL || led.GDC_Prior_12_mo__c == 0) && ias.Lead_Type__c == 'Core' && led.Channel_Owner__c != 'IS BD'){
                                            led.Regional_VP__c = ias.Regional_VP__c;
                                            led.Prospect_Type__c = ias.Lead_Type__c;
                                            matched = true;
                                            break;  
                                            
                                        }
                                        
                                        if(led.Channel_Owner__c == 'IS BD') {
                                            if(ias.Lead_Type__c == 'Masters') {
                                                led.Regional_VP__c = ias.Regional_VP__c;
                                                led.Prospect_Type__c = ias.Lead_Type__c;
                                                matched = true;
                                                break;
                                            }else {
                                                Continue;
                                            }
                                            
                                        }
                                        else{
                                            if(ias.Lead_Type__c == 'Masters'
                                               && led.GDC_Prior_12_mo__c< ias.GDC_Maximum__c
                                               && led.GDC_Prior_12_mo__c>= ias.GDC_Minimum__c
                                               && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())
                                            {
                                                led.Regional_VP__c = ias.Regional_VP__c;
                                                led.Prospect_Type__c = ias.Lead_Type__c;
                                                matched = true;
                                            } else {
                                                //find the IAS Recruiter record within range of the opportunity
                                                if(led.GDC_Prior_12_mo__c != null
                                                   && led.GDC_Prior_12_mo__c< ias.GDC_Maximum__c
                                                   && led.GDC_Prior_12_mo__c>= ias.GDC_Minimum__c
                                                   && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId())
                                                {
                                                    led.Regional_VP__c = ias.Regional_VP__c;
                                                    led.Prospect_Type__c = ias.Lead_Type__c;
                                                    matched = true;
                                                }
                                            }
                                        }           
                                        if(matched == false && led.Channel_Owner__c != 'IS BD' && ias.Lead_Type__c == 'Core' && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId()){
                                            led.Regional_VP__c = ias.Regional_VP__c;
                                            led.Prospect_Type__c = ias.Lead_Type__c;   
                                        }
                                        if(matched == false && led.Channel_Owner__c == 'IS BD' && ias.Lead_Type__c == 'Masters' && led.RecordTypeId == ledRecordtypes.get('Discovery Database Lead').getRecordTypeId()){
                                            led.Regional_VP__c = ias.Regional_VP__c;
                                            led.Prospect_Type__c = ias.Lead_Type__c;   
                                        }   
                                    }
                                } 
                            }
                        }
                    }
                }     
            }
        } catch(Exception e) {
            System.debug('ExceptionType:' + e.getTypeName() + 'Message:' +e.getMessage() + 'LineNumber:' + e.getLineNumber() +'Cause:' + e.getCause()); 
        }
    }
    
    public void updateContAndOpty() {
        try{
            for( Contact con : conList) {
                con.HomePhone = leadConMap.get(con.Id).Home_Phone__c;
                oppConMap.put(leadConMap.get(con.Id).ConvertedOpportunityId, con);
                con.recordtypeId=Label.Contact_Prospect_Recordtype;
                con.Lead_Source__c=leadConMap.get(con.Id).LeadSource;
                conListUpdate.add(con);
            }
        } catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_LeadTriggerGateway','updateContAndOpty',e.getMessage(),e.getLineNumber(),e.getTypeName());      
        }
    }
    
    
    //When Lead is converted, Contact field on Eloqua Marketing Activity is updated with Lead contact ID.
    public void updateElqMrktAct() {
        
        try{
            if(leadMap.size()>0){
                for(ELOQUA__Marketing_Activity__c obj: elqMktList){
                    obj.ELOQUA__Contact__c = leadMap.get(obj.ELOQUA__Lead__c).ConvertedContactId;
                    elqMrkActLst.add(obj);
                }
            }
        } 
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_LeadTriggerGateway','updateElqMrktAct',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
        
    }   
    
    public void processFinally(){
        try{
            if(conListUpdate.size()> 0)
                update conListUpdate;
            
            if(elqMrkActLst.size()>0){
                update elqMrkActLst;
            }
        }
        catch(exception e){
            LPL_CreateExceptionLog.createErrorRecordAsync('LPL_LeadTriggerGateway','processFinally',e.getMessage(),e.getLineNumber(),e.getTypeName());     
        }
    }
    
}