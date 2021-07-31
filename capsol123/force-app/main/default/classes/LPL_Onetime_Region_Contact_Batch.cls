/*
Class Name              :LPL_Onetime_Region_Contact_Batch
Description             :Class for LPL_Onetime_Region_Contact_Batch_Test
Developer Name          :Ashish Gupta
Created Date            :29/9/2018

Change         Description                                                Owner                     date
CH-01        Populate Region on opportunity based on                       Vaibhav jain             11/27/2018
              (Discovery Home zip and postalcode)zip in contact 
*/

global class LPL_Onetime_Region_Contact_Batch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query='select Id, name,Region__c,Contact__c from Opportunity where (RecordType.Name=\'IAS Business Development\') AND Contact__c!=\'\' AND Contact__c In (Select id from Contact where  Discovery_Home_Zip__c!=null OR MailingPostalCode!=null)';//CH-01
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Opportunity> OppUpdateList) 
    { 
        Set<ID> conid = new  Set<ID>();
        Map<ID, Contact> prospConMap = new Map<Id, Contact>(); 
        set<string> zips = new set<string>();
        Map<String, IAS_Recruiter_Assignment__c > zipMap= new Map <String, IAS_Recruiter_Assignment__c >();
        List<Opportunity>opplist=new List<Opportunity>();
        try {
            for(Opportunity OppObj : OppUpdateList){
                conid.add(OppObj.Contact__c);
            }
            for(Contact cons:[Select id,Discovery_Home_Zip__c,MailingPostalCode from contact where ID in:conid]){//CH-01
                prospConMap.put(cons.id,cons);
                if(cons.Discovery_Home_Zip__c!=null)
                    zips.add(cons.Discovery_Home_Zip__c);
                else if(cons.MailingPostalCode!=null)   //CH-01
                    zips.add(cons.MailingPostalCode);
            }
            for(IAS_Recruiter_Assignment__c ias :  [Select Name,region__c  
                                                    from IAS_Recruiter_Assignment__c
                                                    where name in :zips] ){ 
                                                        zipMap.put(ias.name,ias); 
                                                    }
            for(Opportunity opp :OppUpdateList){  
                if(opp.Contact__c!=null){
                    if(prospConMap.size()>0 && prospConMap.get(opp.Contact__c) != null){
                        String homezip=prospConMap.get(opp.Contact__c).Discovery_Home_Zip__c;
                        String postalCode=prospConMap.get(opp.Contact__c).MailingPostalCode;
                        if(homezip!=''&& zipMap.get(homezip) !=null){
                            Opp.Region__c= zipMap.get(homezip).region__c;
                            opplist.add(Opp);
                        }
                        //CH-01 -start
                        else if(postalCode!='' && zipMap.get(postalCode)!=null){
                            Opp.Region__c = zipMap.get(postalCode).Region__c;
                            opplist.add(Opp);
                        }
                        else{
                            Opp.Region__c = null;
                            opplist.add(Opp);
                        }
                        //CH-01 -end
                    }
                }
            }
            if(opplist !=null && opplist.size()>0){
                update opplist;
            }
        }
        catch(Exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Onetime_Region_Contact_Batch','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    global void finish(Database.BatchableContext BC){
    }
}