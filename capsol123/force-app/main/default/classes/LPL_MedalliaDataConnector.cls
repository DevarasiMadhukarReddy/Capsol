public class LPL_MedalliaDataConnector {
    
    public static Map<String,List<String>> mapOfDeserialize = New map<String,List<String>>();
    Public static Set<String> setOfMasterRepIds = new Set<String>();
    List<Net_Promoter_Score__c> checkExisting = New List<Net_Promoter_Score__c>();
    /*
  Method Name : createConnection
  Description : This method will create the connection b/w salesforce and Medallia by accessToken.
  */
    public static String createConnection() {
    
        Http h = new Http();
        HttpRequest req = new HttpRequest();
    //Setting the Endpoint for Medallia for accessing the token with providing all the required details.
        req.setEndpoint('https://lplfinancial.medallia.com/oauth/lplfinancial/token');
        String clientSecret = 'c2a7ng';
        String clientId = 'mql_salesforce_account';
        String grantType = 'client_credentials';
        String scope = '-d';
    //Preparing the body with all required header
        String body = 'client_secret='+clientSecret+'&client_id='+clientId+'&grant_type='+grantType+'&scope='+scope;
        req.setMethod('POST');
        req.setBody(body);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
    
    //HttpResponse class to get the response from Medallia.
        HttpResponse res = new HttpResponse();
        
        Http h1 = new Http();
    //Sending the prepared request to Medallia.
        HttpResponse res2 = h1.send(req);
    //Storing the response in string variable
        String resp = res2.getBody();
        String decodedResult = EncodingUtil.urlDecode(resp, 'UTF-8');
    
    //Deserializing the response to pass to the retrieveMedalliaData method.
        Map<String,Object> result = (Map<String,Object>)JSON.deserializeUntyped(decodedResult);
        return (String)result.get('access_token');
        //retrieveMedalliaData((String)result.get('access_token'));
    }
    
    /*
    Method name : retrieveMedalliaData
    Description : This method will prepare the query to retrieve Medallia data and deserialize the same with the help of LPL_MedalliaDataWrapper apex class.
    */
    public static String retrieveMedalliaData(String accessToken) {
        system.debug('accestoken'+accessToken);
        string n = '%27NPS%27';
        string responseDate = 'timeperiod( 640 ,responsedate) ';
    Http http = new Http();
        HttpRequest request = new HttpRequest();
    //URL to get the mql data
        String url = 'https://lplfinancial.apis.medallia.com/data/v0/mql';//&accept=application/json
        system.debug('urlllll'+url);
    //Setting endpoint
        request.setEndpoint(EncodingUtil.urlDecode(url, 'UTF-8')); 
        
       // request.setBody('?company=lplfinancial&version=1&output=json&query=select+surveyid%2C+responsedate%2C+lpl_masterid%2C+lpl_relationship_keymetrics_osat_likelyscale%2C+lpl_response_url_sso+from+survey+where+lpl_survey_type_alt='+ n+'+AND+'+responsedate);
          
      //Preparing the body for retrieve data from Medallia
     // request.setBody('?company=lplfinancial&version=1&output=json&query=SELECT+surveyid%2C+responsedate%2C+lpl_masterid%2C+lpl_relationship_keymetrics_osat_likelyscale%2C+lpl_nps_segment%2C+lpl_relationship_keymetrics_osat_satscale%2C+lpl_wave_txt%2C+lpl_top_area_to_improve%2C+lpl_relationship_keymetrics_yoy_alt%2C+lpl_relationship_kpi_independence_satscalewna%2C+%2C+lpl_relationship_kpi_value_satscalewna%2C+lpl_relationship_kpi_strategy_satscalewna%2C+lpl_relationship_kpi_reputation_satscalewna%2C+lpl_relationship_kpi_attentin_satscalewna%2C+lpl_relationship_kpi_technlogy_satscalewna%2C+lpl_relationship_individualratings_tshd_satscale%2C+lpl_relationship_kpi_research_satscalewna%2C+lpl_relationship_cx_supportbusiness_agreescale%2C+lpl_relationship_cx_easybusiness_agreescale%2C+lpl_relationship_cx_personable_agreescale%2C+lpl_relationship_cx_consultativepartner_agreescale%2C+lpl_relationship_cx_expectations_agreescale%2C+lpl_relationship_individualratings_institution_likelyscale%2C+lpl_relationship_individualratings_rm_bc_satscale%2C+lpl_relationship_individualratings_rm_bc_satscale%2C+lpl_relationship_individualratings_tshd_satscale%2C+lpl_relationship_individualratings_tshd_satscale%2C+lpl_permission_contact_yn%2C+lpl_follow_up_owner_email_txt%2C+lpl_response_url_sso%2C+alert_date_closed+from+survey+where+lpl_survey_type_alt='+ n+'+AND+'+responsedate);
        request.setBody('?company=lplfinancial&version=1&output=json&query=SELECT+surveyid%2C+responsedate%2C+lpl_masterid%2C+lpl_relationship_keymetrics_osat_likelyscale%2C+lpl_nps_segment%2C+lpl_relationship_keymetrics_osat_satscale%2C+lpl_wave_txt%2C+lpl_relationship_keymetrics_yoy_alt%2C+lpl_relationship_kpi_independence_satscalewna%2C+lpl_relationship_kpi_legalsupport_satscalewna%2C+lpl_relationship_kpi_payout_satscalewna%2C+lpl_relationship_kpi_value_satscalewna%2C+lpl_relationship_lead_osat%2C+lpl_relationship_rep_brand_osat%2C+lpl_relationship_kpi_attentin_satscalewna%2C+lpl_relationship_kpi_technlogy_satscalewna%2C+lpl_relationship_individualratings_tshd_satscale%2C+lpl_relationship_kpi_research_satscalewna%2C+lpl_relationship_cx_easybusiness_agreescale%2C+lpl_relationship_individualratings_institution_likelyscale%2C+lpl_relationship_individualratings_rm_bc_satscale%2C+lpl_relationship_individualratings_rm_bc_satscale%2C+lpl_permission_contact_yn%2C+lpl_follow_up_owner_email_txt%2C+lpl_response_url_sso%2C+lpl_relationship_kpi_productsplatform_satscalewna%2C+lpl_relationship_sc_osat%2C+lpl_relationship_kpi_compliance_satscalewna%2C+lpl_relationship_cx_reliable_agreescale%2C+lpl_relationship_cx_valued_agreescale%2C+lpl_relationship_wealth_management_osat%2C+top_area_rank_three%2C+top_area_rank_three_second_choice%2C+top_area_rank_three_third_choice%2C+alert_date_closed+from+survey+where+lpl_survey_type_alt='+ n+'+AND+'+responsedate);
        
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer '+ accessToken);

        request.setHeader('content-type','application/x-www-form-urlencoded');
        
        HttpResponse response = http.send(request);
        String decodedResult = EncodingUtil.urlDecode(response.getBody(), 'UTF-8');
        system.debug('!!!'+ response);
        System.debug('Status code for big query '+ response.getStatusCode());
       
        system.debug('Response !!!body'+ response);
      system.debug('!!!body'+ response.getBody());
        
        return response.getBody();
    }
    
  /*
  Method Name : deserializeJSON
  Description : This method is calling the parse method from LPL_MedalliaDataWrapper apex class which is basically providing deserialized data.
  After getting the deserialize data from LPL_MedalliaDataWrapper. Preparing the map with fieldName of medallia as key and List of String as values. 
  */
    Public static Map<String,List<String>> deserializeJSON(String Json){
  
     //Creating the instance for LPL_MedalliaDataWrapper
         LPL_MedalliaDataWrapper deserializeResponse = LPL_MedalliaDataWrapper.parse(Json);
     
     //Calling the inner class to use it's variable.
     LPL_MedalliaDataWrapper.Query innerParser =  deserializeResponse.query;     
         
         System.debug('Value in the innerparser columns' + innerParser.columns);
         //System.debug('Value in the innerparser columns' + innerParser.table);
        
    //Iterating over the columns of the medallia which is nothing but fieldName of medallia. 
        for(String tableHeader : innerParser.columns) {
      //Filling the mapOfDeserialize with column header and blank string.
            mapOfDeserialize.put(tableHeader, new List<String>());
        }
        
    //Iterating over the innerParser table size for filling the mapOfDeserialize values.
        for(Integer start=0;start<innerParser.table.size();start++) {
            List<String> dataLst = innerParser.table.get(start);
            Integer count=0;
            for(String columnValue : dataLst) {
                String headerName = innerParser.columns.get(count);
                mapOfDeserialize.get(headerName).add(columnValue);
                count++;
            }
        }
        return mapOfDeserialize;
    }
    
  /*
  Method name : createNPSRecord
  Description : Method to be used to create the Net_Promoter_Score__c object.
  */
    public static Net_Promoter_Score__c createNPSRecord(Integer i , String con , string masterRepId, String quarter, String surveyCompletedDate ) {
        setOfMasterRepIds.add(masterRepId);
        Date dateToFindOutTheYear;
        if(Date.valueOf(mapOfDeserialize.get('responsedate')[i]) != null){
            dateToFindOutTheYear = Date.valueOf(mapOfDeserialize.get('responsedate')[i]);
        }
        Net_Promoter_Score__c netPromoterInstance = new Net_Promoter_Score__c();
        netPromoterInstance.Name = dateToFindOutTheYear.year()+'-'+quarter+'-'+masterRepId;
        netPromoterInstance.External_ID__c = dateToFindOutTheYear.year()+'-'+quarter+'-'+masterRepId;
        netPromoterInstance.Survey_Completed_Date__c = surveyCompletedDate;
        Contact contactInstance = New Contact(Master_Rep_Id__c = masterRepId);
        netPromoterInstance.Advisor_Program_Manager__r = contactInstance; //mapOfDeserialize.get('lpl_masterid').get(index);//wrap.lpl_masterid;
        if(Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_keymetrics_osat_likelyscale')[i]) != null){
            netPromoterInstance.NPS_Score__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_keymetrics_osat_likelyscale')[i]) ; //wrap.lpl_relationship_keymetrics_osat_likelyscale;    
        }
        String tempString39 = mapOfDeserialize.get('lpl_relationship_keymetrics_osat_satscale')[i];
        system.debug('value in the tempString39 ' + tempString39);
        if(mapOfDeserialize.get('lpl_relationship_keymetrics_osat_satscale')[i] != ''){
            if(!tempString39.contains('N/A')){
            	netPromoterInstance.Overall_Satisfaction_with_LPL__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_keymetrics_osat_satscale')[i]);//wrap.lpl_relationship_keymetrics_osat_satscale;    
            }
        }
        String tempString14 = mapOfDeserialize.get('lpl_relationship_kpi_independence_satscalewna')[i];
        system.debug('value in the tempString5 ' + tempString14);
        if(mapOfDeserialize.get('lpl_relationship_kpi_independence_satscalewna')[i] != ''){
            if(!tempString14.contains('N/A')){
              netPromoterInstance.Independence_Autonomy_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_kpi_independence_satscalewna')[i]);//wrap.lpl_relationship_kpi_independence_satscalewna;      
            }
            
        }
        string tempString4 = mapOfDeserialize.get('lpl_relationship_kpi_payout_satscalewna')[i];
        system.debug('value in the tempString4 ' + tempString4);
        if(mapOfDeserialize.get('lpl_relationship_kpi_payout_satscalewna')[i] != ''){
            if(!tempString4.contains('N/A')){
            netPromoterInstance.Payout_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_kpi_payout_satscalewna')[i]);//wrap.lpl_relationship_kpi_payout_satscalewna;        
            }
            
        }
        string tempString5 = mapOfDeserialize.get('lpl_relationship_kpi_value_satscalewna')[i];
        system.debug('value in the tempString5 ' + tempString5);
        if(mapOfDeserialize.get('lpl_relationship_kpi_value_satscalewna')[i] != ''){
            if(!tempString5.contains('N/A')){
                netPromoterInstance.Value_offered_for_fees_charged_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_kpi_value_satscalewna')[i]);//wrap.lpl_relationship_kpi_value_satscalewna;     
            }
        }
       String tempstring = mapOfDeserialize.get('lpl_relationship_lead_osat')[i];
        system.debug('value in the tempstring ' + tempstring);
        if(mapOfDeserialize.get('lpl_relationship_lead_osat')[i] != ''){
            if(!tempstring.contains('N/A')){
                netPromoterInstance.Firm_s_strategic_direction_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_lead_osat')[i]);//wrap.lpl_relationship_lead_osat;    
            }
        }
        String tempstring6 = mapOfDeserialize.get('lpl_relationship_rep_brand_osat')[i];
        System.debug('value in the tempstring6 ' + tempstring6);
        if(mapOfDeserialize.get('lpl_relationship_rep_brand_osat')[i] != ''){
            if(!tempstring6.contains('N/A')){
                netPromoterInstance.Reputation_brand_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_rep_brand_osat')[i]);//wrap.lpl_relationship_rep_brand_osat;        
            }
        }
        String tempstring7 = mapOfDeserialize.get('lpl_relationship_kpi_attentin_satscalewna')[i];
        system.debug('value in the tempstring7 ' + tempstring7);
        if(mapOfDeserialize.get('lpl_relationship_kpi_attentin_satscalewna')[i] != ''){
            if(!tempstring7.contains('N/A')){
                netPromoterInstance.Personal_attention_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_kpi_attentin_satscalewna')[i]);//wrap.lpl_relationship_kpi_attentin_satscalewna;        
            }
        }
        String tempstring8 = mapOfDeserialize.get('lpl_relationship_kpi_technlogy_satscalewna')[i];
        system.debug('value in the tempstring8 ' + tempstring8);
        if(mapOfDeserialize.get('lpl_relationship_kpi_technlogy_satscalewna')[i] != ''){
            if(!tempstring8.contains('N/A')){
                netPromoterInstance.Technology_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_kpi_technlogy_satscalewna')[i]);//wrap.lpl_relationship_kpi_technlogy_satscalewna;         
            }
        }
        String tempstring1 = mapOfDeserialize.get('lpl_relationship_kpi_research_satscalewna')[i];
        system.debug('temstring1 contains N/A ' + tempstring1);
        if(mapOfDeserialize.get('lpl_relationship_kpi_research_satscalewna')[i] !='' ){
            if(!tempstring1.contains('N/A')){
                netPromoterInstance.Research_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_kpi_research_satscalewna')[i]);//wrap.lpl_relationship_kpi_research_satscalewna;         
            }
        }
       
        String tempstring30 = mapOfDeserialize.get('lpl_relationship_kpi_productsplatform_satscalewna')[i];
        if( mapOfDeserialize.get('lpl_relationship_kpi_productsplatform_satscalewna')[i] != ''){
            if(!tempstring30.contains('N/A')){
                netPromoterInstance.Products_and_platforms_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_kpi_productsplatform_satscalewna')[i]);//wrap.lpl_relationship_kpi_productsplatform_satscalewna;
            }
        }
        
        String tempstring31 = mapOfDeserialize.get('lpl_relationship_sc_osat')[i];
        if( mapOfDeserialize.get('lpl_relationship_sc_osat')[i] !=''){
            if(!tempstring31.contains('N/A')){
                netPromoterInstance.Service_team_support_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_sc_osat')[i]);//wrap.lpl_relationship_sc_osat;
            }
        }
        
        String tempstring32 = mapOfDeserialize.get('lpl_relationship_kpi_compliance_satscalewna')[i];
        if( mapOfDeserialize.get('lpl_relationship_kpi_compliance_satscalewna')[i] != '' ){
            if(!tempstring32.contains('N/A')){
                netPromoterInstance.Compliance_Regulatory_support_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_kpi_compliance_satscalewna')[i]);//wrap.lpl_relationship_kpi_compliance_satscalewna;
            }
        }
        
        String tempstring33 = mapOfDeserialize.get('lpl_relationship_cx_reliable_agreescale')[i];
        if( mapOfDeserialize.get('lpl_relationship_cx_reliable_agreescale')[i] != ''){
            if(!tempstring33.contains('N/A')){
                netPromoterInstance.Reliable__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_cx_reliable_agreescale')[i]);//wrap.lpl_relationship_cx_reliable_agreescale;
            }
        }
        
        String tempstring34 = mapOfDeserialize.get('alert_date_closed')[i];
        if(mapOfDeserialize.get('alert_date_closed')[i] != ''){
            if(!tempstring34.contains('N/A')){
            netPromoterInstance.Closed_Loop_Date__c = Date.valueOf(tempstring34);    
            }
            
        }
        
        /*String tempstring9 = mapOfDeserialize.get('lpl_relationship_cx_supportbusiness_agreescale')[i];
        system.debug('value in the tempstring9 ' + tempstring9);
        if(mapOfDeserialize.get('lpl_relationship_cx_supportbusiness_agreescale')[i] != ''){
            if(!tempstring9.contains('N/A')){
                netPromoterInstance.Understands_Supports_My_Business_Needs__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_cx_supportbusiness_agreescale')[i]);//wrap.lpl_relationship_cx_supportbusiness_agreescale;       
            }
        }*/
        String tempstring10 = mapOfDeserialize.get('lpl_relationship_cx_easybusiness_agreescale')[i];
        system.debug('value in the tempstring10 ' + tempstring10);
        if(mapOfDeserialize.get('lpl_relationship_cx_easybusiness_agreescale')[i] != ''){
            if(!tempstring10.contains('N/A')){
            netPromoterInstance.Easy_to_do_Business_with__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_cx_easybusiness_agreescale')[i]);//wrap.lpl_relationship_cx_easybusiness_agreescale;        
            }
        }
        /*String tempstring11 = mapOfDeserialize.get('lpl_relationship_cx_personable_agreescale')[i];
        system.debug('value in the tempstring11 ' + tempstring11);
        if(mapOfDeserialize.get('lpl_relationship_cx_personable_agreescale')[i] != ''){
            if(!tempstring11.contains('N/A')){
                netPromoterInstance.Personable__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_cx_personable_agreescale')[i]);//wrap.lpl_relationship_cx_personable_agreescale;      
            }
        }
        String tempstring12 = mapOfDeserialize.get('lpl_relationship_cx_consultativepartner_agreescale')[i];
        system.debug('value in the tempstring12 ' + tempstring12);
        if(mapOfDeserialize.get('lpl_relationship_cx_consultativepartner_agreescale')[i] != ''){
            if(!tempstring12.contains('N/A')){
                netPromoterInstance.Consultative_Partner__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_cx_consultativepartner_agreescale')[i]);//wrap.lpl_relationship_cx_consultativepartner_agreescale;        
            }
        }
        String tempstring13 = mapOfDeserialize.get('lpl_relationship_cx_expectations_agreescale')[i];
        system.debug('value in the tempstring13 ' + tempstring13);
        if(mapOfDeserialize.get('lpl_relationship_cx_expectations_agreescale')[i] != ''){
            if(!tempstring13.contains('N/A')){
                netPromoterInstance.Goes_Above_and_Beyond_My_Expectations__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_cx_expectations_agreescale')[i]);//wrap.lpl_relationship_cx_expectations_agreescale;        
            }
        }*/
		
		 String tempstring36 = mapOfDeserialize.get('lpl_relationship_cx_valued_agreescale')[i];
        system.debug('value in the tempstring36 ' + tempstring36);
        if(mapOfDeserialize.get('lpl_relationship_cx_valued_agreescale')[i] != ''){
            if(!tempstring36.contains('N/A')){
                netPromoterInstance.Customer_Value__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_cx_valued_agreescale')[i]);//wrap.lpl_relationship_cx_expectations_agreescale;        
            }
        }
		 String tempstring37 = mapOfDeserialize.get('lpl_relationship_wealth_management_osat')[i];
        system.debug('value in the tempstring37 ' + tempstring37);
        if(mapOfDeserialize.get('lpl_relationship_wealth_management_osat')[i] != ''){
            if(!tempstring37.contains('N/A')){
                netPromoterInstance.Wealth_Management_rating__c = Decimal.valueOf(mapOfDeserialize.get('lpl_relationship_wealth_management_osat')[i]);//wrap.lpl_relationship_cx_expectations_agreescale;        
            }
        }
        
        String tempstring3 = mapOfDeserialize.get('lpl_relationship_individualratings_tshd_satscale')[i];
        system.debug('value in the tempstring3 ' + tempstring3);
        if(mapOfDeserialize.get('lpl_relationship_individualratings_tshd_satscale')[i] != ''){
                netPromoterInstance.Tech_support_help_desk_rating__c = mapOfDeserialize.get('lpl_relationship_individualratings_tshd_satscale')[i];//wrap.lpl_relationship_individualratings_tshd_satscale;    
        }
        
        if(mapOfDeserialize.get('top_area_rank_three')[i] != ''){
                netPromoterInstance.Top_Area_to_Improve__c = mapOfDeserialize.get('top_area_rank_three')[i];//wrap.lpl_relationship_individualratings_tshd_satscale;    
        }
		if(mapOfDeserialize.get('top_area_rank_three_second_choice')[i] != ''){
                netPromoterInstance.Top_Area_to_Improve_2__c = mapOfDeserialize.get('top_area_rank_three_second_choice')[i];//wrap.lpl_relationship_individualratings_tshd_satscale;    
        }
		if(mapOfDeserialize.get('top_area_rank_three_third_choice')[i] != ''){
                netPromoterInstance.Top_Area_to_Improve_3__c = mapOfDeserialize.get('top_area_rank_three_third_choice')[i];//wrap.lpl_relationship_individualratings_tshd_satscale;    
        }
        
        String tempstring35 = mapOfDeserialize.get('lpl_nps_segment')[i];
        system.debug('value in the tempstring3 ' + tempstring3);
        if(tempstring35 != '' && !tempstring35.contains('N/A') ){
      if(tempstring35.contains('(9,10)') ){
        netPromoterInstance.Loyalty_Category__c = 'Promoters (9,10)';
      }
      if(tempstring35.contains('(7,8)') ){
        netPromoterInstance.Loyalty_Category__c = 'Passives (7,8)';
      }
      if(tempstring35.contains('(1-6)') ){
        netPromoterInstance.Loyalty_Category__c = 'Detractors (1-6)';
      }
            if(tempstring35.contains('(0-6)') ){
                netPromoterInstance.Loyalty_Category__c = 'Detractors (0-6)';
            }
                //netPromoterInstance.Loyalty_Category__c = mapOfDeserialize.get('lpl_nps_segment')[i];//wrap.lpl_nps_segment;    
        }
        
        return netPromoterInstance;
    }
}