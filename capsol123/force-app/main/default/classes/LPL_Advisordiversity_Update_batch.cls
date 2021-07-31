/*
#############################Change History####################
CH#              Description                                                      Developer Name             Date
----------------------------------------------------------------------------------------------------------------------
Ch-1    Batch created to update Contact-"LPL Advisor" record type                 Manila Agnihotri           25 May 2018
        from "Contact prospect" using MaterRepID on opportunity - 
        User Story 123285:Advisor Diversity
*/

global class LPL_Advisordiversity_Update_batch implements Database.Batchable<sObject>{
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select id,Contact__c,Self_Identified_Gender__c,Self_Identified_Military_Service__c,Self_Identified_Race_Ethnicity__c,Rep_ID__c from Opportunity where Rep_ID__c != NULL AND LastModifiedDate = Today AND RecordType.Name=\'IAS Business Development\' ORDER BY LastModifiedDate DESC NULLS LAST';
        return database.getQueryLocator(query);
    }
     global void execute(Database.BatchableContext BC,List<Opportunity> OppList) 
    {
        List<Contact> LPLadvlist = new List<Contact>();
        Set<ID> Conid = new Set<ID>();
        Set<Contact> Conval = new Set<Contact>();
        for(Opportunity opp: OppList)
        {
            for(Contact con : [Select id,RecordType.Name,Self_Identified_Gender__c,Self_Identified_Military_Service__c,Self_Identified_Race_Ethnicity__c from Contact where RecordType.Name= 'LPL Advisor' AND Master_Rep_ID__c != NULL AND Master_Rep_ID__c =:opp.Rep_ID__c])
          {
             con.Self_Identified_Gender__c = opp.Self_Identified_Gender__c; 
              con.Self_Identified_Military_Service__c = opp.Self_Identified_Military_Service__c;
              con.Self_Identified_Race_Ethnicity__c = opp.Self_Identified_Race_Ethnicity__c;
              
              Conval.add(con);
           }
            }
         
           if(Conval.size() > 0){
           LPLadvlist.addAll(Conval);
           database.update(LPLadvlist, false);
        }  
    }
    
     global void finish(Database.BatchableContext BC){
           system.debug('Batch finish'); 
      }

}