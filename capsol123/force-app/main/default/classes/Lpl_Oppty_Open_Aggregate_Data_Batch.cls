/*
Created By:Mahender Gangu   
Created Date:6/23/2017
Description: This batch class takes Snapshot data of Opportunity with GDC, AUM, Tat AUM data
when stage is either 1-Engaged  or 2-Hot List or 3-submitted a kit for IAS Business 
Development record type and creates a record on Opportunity_Aggregate_Data__c object, 
this data is used in the reports for data trending purpose.

#############################Change History####################
CH#              Description                                             Developer Name                       Date
----------------------------------------------------------------------------------------------------------------------


*/

global class Lpl_Oppty_Open_Aggregate_Data_Batch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        /*String Query;
Query='select Id, GDC_Prior_12_mo__c, AUM__c, TAT_AUM__c, StageName, Assigned_Recruiter__c' +  
+ 'from Opportunity ' + 
+ 'where' + 
+ ' lastModifiedDate > \'System.Today()\'';
Date todDate = System.today();*/
        //datetime lastsevendays=System.now()-7;//Getting last seven day date from today
        return Database.getQueryLocator([select Id, GDC_Prior_12_mo__c, AUM__c, TAT_AUM__c, StageName, Assigned_Recruiter__c,Expected_AUM__c,
                                         LastmodifiedDate from Opportunity where recordtype.name='IAS Business Development' and IsClosed=false]);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        try{
            // Map<String, List<Opportunity_Aggregate_Data__c>> oadMap = new Map<String, List<Opportunity_Aggregate_Data__c>>();
            List<Opportunity_Aggregate_Data__c> insertList =  new List<Opportunity_Aggregate_Data__c>();
            //List<Opportunity_Aggregate_Data__c> newOADList = new List<Opportunity_Aggregate_Data__c>();
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
            if(insertList.size() != 0){
                list<Database.Saveresult> dbinsert = Database.insert(insertList,false);
            }
        }
        catch(exception e) {
            
            LPL_CreateExceptionLog.createErrorRecordSync('Lpl_Opportunity_Aggregate_Stage_Data','Execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    
    global void finish(Database.BatchableContext BC){
        Database.executeBatch(new Lpl_Oppty_isClosed_Aggregate_Data_Batch());
    }
}