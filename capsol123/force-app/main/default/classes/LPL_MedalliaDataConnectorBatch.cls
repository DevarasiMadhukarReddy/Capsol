global class LPL_MedalliaDataConnectorBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        String blank = '';
        String contactId = '003U00000054MeL';
        string query = 'SELECT id, Master_Rep_ID__c,  Net_Promoter_Score__c,NPS_Survey_Period__c, NPS_Feedback_Details__c from contact where Master_Rep_Id__c !=: blank ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Contact> contactList) {
        String createConnectionAccessToken;
        String retrieveMedalliaData;
        Map<String,List<String>> mapOfDeserialize = New map<String,List<String>>();
        //Map for capture the Contact record by its Master_Rep_ID__c.
        Map<String, Contact> mapOfMasterRepIdToContact = new Map<String, Contact>();
        if(contactList.size()> 0 || Test.isRunningTest()){
            createConnectionAccessToken = LPL_MedalliaDataConnector.createConnection();
            retrieveMedalliaData = LPL_MedalliaDataConnector.retrieveMedalliaData(createConnectionAccessToken);
            mapOfDeserialize  = LPL_MedalliaDataConnector.deserializeJSON(retrieveMedalliaData);
        }
        for(Contact eachContact : contactList)
        {     
            mapOfMasterRepIdToContact.put(eachContact.Master_Rep_ID__c, eachContact);
        }
        //system.debug('Value in the mapOfMasterRepIdToContact ' + mapOfMasterRepIdToContact);
        //Contact list to be update.
        Map<Id,Contact> contactmapToUpdateValues = New Map<Id,Contact>();
        //Net_Promoter_Score__c list to be insert.
        List<Net_Promoter_Score__c> npsList = new List<Net_Promoter_Score__c>();
        //update contactList;
        
        /*Modification*/
        if(!mapOfMasterRepIdToContact.IsEmpty()){
            for(String deserializeMapKey : mapOfDeserialize.keySet()) {     
                //System.debug('deserializeMapKey :: '+deserializeMapKey);
                if(deserializeMapKey.equalsIgnoreCase('lpl_masterid')) {
                    String quarter='';
                    Date d;
                    string surveyCompletedDate ;
                    Integer currentYear = Date.today().year();
                    Integer previousYear = Date.today().year() - 1;
					Integer previousToPrevoisYear = Date.today().year() - 2;
                    for(Integer i=0; i< mapOfDeserialize.get(deserializeMapKey).size(); i++) { //for(String columnValue :  mapOfDeserialize.get(deserializeMapKey))
                        //System.debug(' :: columnValue :: '+mapOfDeserialize.get(deserializeMapKey));
                        if(mapOfMasterRepIdToContact.containsKey(mapOfDeserialize.get(deserializeMapKey)[i])) {
                            Contact cont = mapOfMasterRepIdToContact.get(mapOfDeserialize.get(deserializeMapKey)[i]);
                            //System.debug('lpl_relationship_keymetrics_osat_likelyscale *** '+mapOfDeserialize.get('lpl_relationship_keymetrics_osat_likelyscale')[i]+':: MasterKey :: '+mapOfDeserialize.get(deserializeMapKey)[i]);
                            if(Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_keymetrics_osat_likelyscale')[i]) != null){
                                cont.Net_Promoter_Score__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_keymetrics_osat_likelyscale')[i]);    
                            }   
                            
                            if(Date.valueOf(mapOfDeserialize.get('responsedate')[i]) != null){
                                d = Date.valueOf(mapOfDeserialize.get('responsedate')[i]);
                                //Preparing the Survey Period data to be updated.
                                if(d.month() > 0 && d.month() < 4) {
                                    quarter = 'Q1';
                                } else if(d.month() > 3 && d.month() < 7) {
                                    quarter = 'Q2';
                                } else if(d.month() > 6 && d.month() < 10) {
                                    quarter = 'Q3';
                                } else {
                                    quarter = 'Q4';
                                }
                                Integer gettingYearFromMedallia = d.year();
                                system.debug('value in the gettingYearFromMedallia ' + gettingYearFromMedallia);
                                if(gettingYearFromMedallia == currentYear || gettingYearFromMedallia == previousYear || gettingYearFromMedallia == previousToPrevoisYear ){
                                    cont.NPS_Survey_Period__c = quarter +' '+ d.year();
                                    surveyCompletedDate = quarter +' '+ d.year();
                                }
                            }
                            cont.NPS_Feedback_Details__c = mapOfDeserialize.get('lpl_response_url_sso')[i];
                            contactmapToUpdateValues.put(Cont.Id, cont);
                            if(d.year() == currentYear  || d.year() == previousYear || d.year() == previousToPrevoisYear){
                            npsList.add(LPL_MedalliaDataConnector.createNPSRecord(i ,cont.Id, cont.Master_Rep_ID__c, quarter, surveyCompletedDate));                                     
                            }
                        }
                    } 
                }            
            }
        }
        if(contactmapToUpdateValues.values().size() > 0){
            try{
                update contactmapToUpdateValues.values();   
                if(npsList.size() > 0){
                    Database.UpsertResult[] srList = Database.upsert(npsList,Net_Promoter_Score__c.External_ID__c,false);
                    for (Database.UpsertResult sr : srList) {
                        if (sr.isSuccess()) {
                            // Operation was successful
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                System.debug('fields that affected this error: ' + err.getFields());
                            }
                        }
                    } 
                }
            }
            catch(Exception ex) {
                system.debug(ex);
            } 
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
}