/*
#############################Change History####################
Requirement                                       Developer Name                   Date
CH - 01  - Null Pointer exception fix            Garvita Rai                      6th Feb,2019

****************************************/trigger EI_Campaign_Update on CampaignMember (after insert) 
{
    //Initial list based on the records that triggered the code
    list<CampaignMember> cMemT = new list <CampaignMember> ();
    cMemT = trigger.new;
    
    //Getting all of the campaign memebers
    list<CampaignMember> cMem = new list<CampaignMember> 
    (
        [select id, contactid, campaignid from CampaignMember where id in :cMemT]
     );
    
    CampaignMember campMem = cMem.get(0);
    
    String campID = campMem.CampaignId;
     
    //Getting the campaign into a record so I can use its data for comparison purposes
    Campaign campaignRecord = ([select ID, type, conference__c, year__c from Campaign where id = :campID]);
    
    String campaignType = campaignRecord.type;
    String campaignConf = campaignRecord.conference__c;
    String campaignYear = campaignRecord.year__c;
    String conf = 'Conference';
    //If the campaign is of the right type, then we're going to proceed
    if(campaignType!=null && campaignType.contains(conf))//CH - 01  - Null Pointer exception fix 
    {
        //Getting all the contacts that are campaign members
        list<Contact> cons = new list<Contact> 
        (
            [select id from Contact where id in 
                (select contactID from CampaignMember where id in :cMem)
            ]
        );
        
         //Getting the year now
         Datetime rightnow = Datetime.now();
         String yearNow = rightnow.format('yyyy');
         
         //Getting prior year
         Datetime lastyear = rightnow.addYears(-1);
         String yearLastYear = lastyear.format('yyyy');  
         
         //Checking if the year for the campaign is this year or prior, else we're goinng to skip
         if(campaignYear == yearLastYear || campaignYear == yearNow)
         {
            //List to contain a list of all the conferences
            list<String> conferences = new list<String>();
            
            /**
             * Adding all the conferences to the array manually.
             * Note, go back and eventually pull this from Salesforce!
             **/
            conferences.add('FOCUS');
            conferences.add('Masters');
            conferences.add('Summit');
            conferences.add('BLF');
            conferences.add('Top Producers');
            conferences.add('RRT');
            conferences.add('Program Leadership');
            conferences.add('CU EAC');
            conferences.add('Bank EAC');
            conferences.add('Insurance Champions');
            
            String endQueryString = ' from Engagement_Index__c where Advisor__c in :cons';
            String startQueryString = 'select id, ';
            String fieldToUpdate = '';
            
            //Setting up the update that will be updated via dynamic SOQL 
            for(integer i=0; i<conferences.size(); i++) 
            {
                String confName = conferences.get(i);
                
                if(campaignConf.contains(confName))
                {
                    String field = confName.trim();
                    
                    field = field.replaceAll(' ','_');
                    if(campaignYear == yearLastYear)
                        fieldToUpdate = field+'_Prior_Year__c';
                    else if(campaignYear == yearNow)
                        fieldToUpdate = field+'_Current_Year__c';
                    break;
                }
            }
            
            if(fieldToUpdate.length()>1)
            {
                //Grabbing all of the engagement indices
                String fullQuery = startQueryString+fieldToUpdate+endQueryString;
                list<Engagement_Index__c> eiList = Database.query(fullQuery);
                system.debug(fullQuery);
                //List containing the Engagement indices to update
                list<Engagement_Index__c> eiUpdate = new list<Engagement_Index__c>();
                
                //We're going to loop through each of the engagment index records
                for(Engagement_Index__c ei : eiList)
                {
                    ei.put(fieldToUpdate,1);
                    eiUpdate.add(ei);
                }
                
                if(eiUpdate.size()>0)
                {
                    update eiUpdate;
                }
            }
            
         }
         
    }
}