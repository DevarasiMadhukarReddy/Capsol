/*
Created By:Sai Kethu
Created Date:6/23/2017
Description: This batch class takes Snapshot data of Opportunity with GDC, AUM, Tat AUM data
             when stage is closed lost/Won and closed within the week and creates a record on 
             Opportunity_Aggregate_Data__c object, And this data is used in the reports for
             data trending purpose.
             
#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------


*/

global class Lpl_Oppty_isClosed_Aggregate_Data_Batch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        /*String Query;
        Query='select Id, GDC_Prior_12_mo__c, AUM__c, TAT_AUM__c, StageName, Assigned_Recruiter__c' +  
        + 'from Opportunity ' + 
        + 'where' + 
        + ' lastModifiedDate > \'System.Today()\'';
        Date todDate = System.today();*/
        datetime lastsevendays=System.now()-7;//Getting last seven day date from today
        return Database.getQueryLocator([select Id, GDC_Prior_12_mo__c, AUM__c, TAT_AUM__c, StageName,RecordType.Name, Assigned_Recruiter__c ,Expected_AUM__c,
                                        LastmodifiedDate from Opportunity where isClosed =: True and RecordType.Name =: 'IAS Business Development' and LastmodifiedDate >=:lastsevendays]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        try{
            
            List<Opportunity_Aggregate_Data__c> insertList =  new List<Opportunity_Aggregate_Data__c>();
            
            for(Opportunity opp : scope){
                if(opp.Assigned_Recruiter__c != null){
                    Opportunity_Aggregate_Data__c oadNew = new Opportunity_Aggregate_Data__c();
                        oadNew.Assigned_Recruiter__c = opp.Assigned_Recruiter__c;
                        oadNew.Approved_Expected_AUM__c = opp.Expected_AUM__c;
                        oadNew.GDC_Prior_12__c = opp.GDC_Prior_12_mo__c;
                        oadNew.Opportunity_Stage__c = opp.StageName;
                        oadNew.Unverified_AUM__c = opp.AUM__c;
                        oadNew.Opportunity_Last_Modified__c = opp.LastmodifiedDate;
                        oadNew.Opportunity__c = opp.Id;
                        insertList.add(oadNew);
                }
            }
            if(!insertList.isEmpty() ){
                Database.SaveResult[] SaveResultList = Database.insert(insertList,false); 
            }
         }
         catch(exception e) {
                    
            LPL_CreateExceptionLog.createErrorRecordSync('Lpl_Opportunity_Aggregate_Data_Batch','Execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    
    }
}